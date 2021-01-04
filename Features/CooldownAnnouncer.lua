-- 冷却广播员
Scorpio "SpaUI.Features.CooldownAnnouncer" ""

L = _Locale
local HasAction = HasAction
local GetActionInfo = GetActionInfo
local GetMacroSpell = GetMacroSpell
local GetSpellLink = GetSpellLink
local GetSpellCooldown = GetSpellCooldown
local IsInGroup = IsInGroup
local SendChatMessage = SendChatMessage
local GetItemCount = GetItemCount
local GetItemInfo = GetItemInfo

SupportAnnouncerFrames = {
    ActionButton1,ActionButton2,ActionButton3,ActionButton4,ActionButton5,ActionButton6,
    ActionButton7,ActionButton8,ActionButton9,ActionButton10,ActionButton11,ActionButton12,
    MultiBarBottomLeftButton1,MultiBarBottomLeftButton2,MultiBarBottomLeftButton3,MultiBarBottomLeftButton4,MultiBarBottomLeftButton5,MultiBarBottomLeftButton6,
    MultiBarBottomLeftButton7,MultiBarBottomLeftButton8,MultiBarBottomLeftButton9,MultiBarBottomLeftButton10,MultiBarBottomLeftButton11,MultiBarBottomLeftButton12,
    MultiBarBottomRightButton1,MultiBarBottomRightButton2,MultiBarBottomRightButton3,MultiBarBottomRightButton4,MultiBarBottomRightButton5,MultiBarBottomRightButton6,
    MultiBarBottomRightButton7,MultiBarBottomRightButton8,MultiBarBottomRightButton9,MultiBarBottomRightButton10,MultiBarBottomRightButton11,MultiBarBottomRightButton12,
    MultiBarRightButton1,MultiBarRightButton2,MultiBarRightButton3,MultiBarRightButton4,MultiBarRightButton5,MultiBarRightButton6,
    MultiBarRightButton7,MultiBarRightButton8,MultiBarRightButton9,MultiBarRightButton10,MultiBarRightButton11,MultiBarRightButton12,
    MultiBarLeftButton1,MultiBarLeftButton2,MultiBarLeftButton3,MultiBarLeftButton4,MultiBarLeftButton5,MultiBarLeftButton6,
    MultiBarLeftButton7,MultiBarLeftButton8,MultiBarLeftButton9,MultiBarLeftButton10,MultiBarLeftButton11,MultiBarLeftButton12,
}

Announcer = SecureFrame("SpaUICooldownAnnouncer")
Announcer:Execute[[
    Announcer = self
]]

__SecureMethod__()
__AsyncSingle__()
function Announcer:AnnouncerCooldown(name)
    local button = _G[name]
    if not button or not button.action or not HasAction(button.action) then return end
    local action = button.action
    local actionType, id, subType = GetActionInfo(action)
    Log(actionType,id,subType)
    if actionType == "spell" or actionType == "macro" then
        local spellID = (actionType == "macro" and GetMacroSpell(id) or id)
        if spellID then 
            local link = GetSpellLink(spellID)
            local start, duration, enabled = GetSpellCooldown(spellID)
            if link then
                if enabled == 0 then
                    SendCooldownMessage(L['cooldown_announcer_spell_active']:format(link))
                elseif start > 0 and duration > 0 then
                    SendCooldownMessage(L['cooldown_announcer_spell_not_ready']:format(link, FormatCooldown(floor(duration-(GetTime()-start)+0.5))))
                else
                    SendCooldownMessage(L['cooldown_announcer_spell_ready']:format(link))
                end
            end
        end
    elseif actionType == "item" then
        -- todo
    end
    Delay(0.5)
end

function FormatCooldown(second)
    if second <= 60 then
        return L["second_format"]:format(second)
    else
        local minute = second/60
        second = second%60
        return L['minute_format']:format(minute)..L['second_format']:format(second)
    end
end

function SendCooldownMessage(message)
    local chatType = "EMOTE"
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        chatType = "INSTANCE_CHAT"
    elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
        if IsInRaid() then
            chatType = "RAID"
        else
            chatType = "PARTY"
        end
    end
    SendChatMessage(message, chatType)
end

local PreActionRun = [[
    -- 拦截点击事件
    if button == 'LeftButton' and IsAltKeyDown() then
        Announcer:CallMethod('AnnouncerCooldown', self:GetName())
        return false
    end
]]

for _,frame in ipairs(SupportAnnouncerFrames) do
    Announcer:WrapScript(frame,"OnClick",PreActionRun)
end
