-- 聊天表情 修改自SimpleChat
Scorpio "SpaUI.Social.ChatBar.ChatEmote" ""

EMOTE_SIZE = 25
EMOTE_SIZE_MARGIN = 6
EMOTE_RAW_SIZE = 8
ALPHA_PRESS = 0.6
ALPHA_NORMAL = 1

EMOTES = {
    -- 原版暴雪提供的8个图标
    {L["chat_emote_rt1"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_1]=]},
    {L["chat_emote_rt2"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_2]=]},
    {L["chat_emote_rt3"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_3]=]},
    {L["chat_emote_rt4"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_4]=]},
    {L["chat_emote_rt5"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_5]=]},
    {L["chat_emote_rt6"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_6]=]},
    {L["chat_emote_rt7"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_7]=]},
    {L["chat_emote_rt8"], [=[Interface\TargetingFrame\UI-RaidTargetingIcon_8]=]},
    -- 自定义表情
    {L["chat_emote_angle"], [=[Interface\Addons\SpaUI\Social\emojis\Angel]=]},
    {L["chat_emote_angry"], [=[Interface\Addons\SpaUI\Social\emojis\Angry]=]},
    {L["chat_emote_laugh"], [=[Interface\Addons\SpaUI\Social\emojis\Biglaugh]=]},
    {L["chat_emote_applause"], [=[Interface\Addons\SpaUI\Social\emojis\Clap]=]},
    {L["chat_emote_cool"], [=[Interface\Addons\SpaUI\Social\emojis\Cool]=]},
    {L["chat_emote_cry"], [=[Interface\Addons\SpaUI\Social\emojis\Cry]=]},
    {L["chat_emote_lovely"], [=[Interface\Addons\SpaUI\Social\emojis\Cutie]=]},
    {L["chat_emote_despise"], [=[Interface\Addons\SpaUI\Social\emojis\Despise]=]},
    {L["chat_emote_dream"], [=[Interface\Addons\SpaUI\Social\emojis\Dreamsmile]=]},
    {L["chat_emote_embarrassed"],[=[Interface\Addons\SpaUI\Social\emojis\Embarrass]=]},
    {L["chat_emote_evil"], [=[Interface\Addons\SpaUI\Social\emojis\Evil]=]},
    {L["chat_emote_excited"], [=[Interface\Addons\SpaUI\Social\emojis\Excited]=]},
    {L["chat_emote_dizzy"], [=[Interface\Addons\SpaUI\Social\emojis\Faint]=]},
    {L["chat_emote_fight"], [=[Interface\Addons\SpaUI\Social\emojis\Fight]=]},
    {L["chat_emote_influenza"], [=[Interface\Addons\SpaUI\Social\emojis\Flu]=]},
    {L["chat_emote_stay"], [=[Interface\Addons\SpaUI\Social\emojis\Freeze]=]},
    {L["chat_emote_frown"], [=[Interface\Addons\SpaUI\Social\emojis\Frown]=]},
    {L["chat_emote_salute"], [=[Interface\Addons\SpaUI\Social\emojis\Greet]=]},
    {L["chat_emote_grimace"], [=[Interface\Addons\SpaUI\Social\emojis\Grimace]=]},
    {L["chat_emote_barking_teeth"],[=[Interface\Addons\SpaUI\Social\emojis\Growl]=]}, 
    {L["chat_emote_happy"], [=[Interface\Addons\SpaUI\Social\emojis\Happy]=]},
    {L["chat_emote_heart"], [=[Interface\Addons\SpaUI\Social\emojis\Heart]=]},
    {L["chat_emote_fear"], [=[Interface\Addons\SpaUI\Social\emojis\Horror]=]},
    {L["chat_emote_sick"], [=[Interface\Addons\SpaUI\Social\emojis\Ill]=]},
    {L["chat_emote_innocent"],[=[Interface\Addons\SpaUI\Social\emojis\Innocent]=]},
    {L["chat_emote_kung_fu"], [=[Interface\Addons\SpaUI\Social\emojis\Kongfu]=]},
    {L["chat_emote_anthomaniac"], [=[Interface\Addons\SpaUI\Social\emojis\Love]=]},
    {L["chat_emote_mail"], [=[Interface\Addons\SpaUI\Social\emojis\Mail]=]},
    {L["chat_emote_makeup"], [=[Interface\Addons\SpaUI\Social\emojis\Makeup]=]},
    {L["chat_emote_mario"], [=[Interface\Addons\SpaUI\Social\emojis\Mario]=]},
    {L["chat_emote_meditation"],[=[Interface\Addons\SpaUI\Social\emojis\Meditate]=]},
    {L["chat_emote_poor"], [=[Interface\Addons\SpaUI\Social\emojis\Miserable]=]},
    {L["chat_emote_good"], [=[Interface\Addons\SpaUI\Social\emojis\Okay]=]},
    {L["chat_emote_beautiful"], [=[Interface\Addons\SpaUI\Social\emojis\Pretty]=]},
    {L["chat_emote_spit"], [=[Interface\Addons\SpaUI\Social\emojis\Puke]=]},
    {L["chat_emote_shake_hands"],[=[Interface\Addons\SpaUI\Social\emojis\Shake]=]}, 
    {L["chat_emote_yell"], [=[Interface\Addons\SpaUI\Social\emojis\Shout]=]},
    {L["chat_emote_shut_up"], [=[Interface\Addons\SpaUI\Social\emojis\Shuuuu]=]},
    {L["chat_emote_shy"], [=[Interface\Addons\SpaUI\Social\emojis\Shy]=]},
    {L["chat_emote_sleep"], [=[Interface\Addons\SpaUI\Social\emojis\Sleep]=]},
    {L["chat_emote_smile"], [=[Interface\Addons\SpaUI\Social\emojis\Smile]=]},
    {L["chat_emote_surprised"],[=[Interface\Addons\SpaUI\Social\emojis\Suprise]=]},
    {L["chat_emote_failure"],[=[Interface\Addons\SpaUI\Social\emojis\Surrender]=]}, 
    {L["chat_emote_sweat"], [=[Interface\Addons\SpaUI\Social\emojis\Sweat]=]},
    {L["chat_emote_tears"], [=[Interface\Addons\SpaUI\Social\emojis\Tear]=]},
    {L["chat_emote_tragedy"], [=[Interface\Addons\SpaUI\Social\emojis\Tears]=]},
    {L["chat_emote_thinking"], [=[Interface\Addons\SpaUI\Social\emojis\Think]=]},
    {L["chat_emote_snicker"], [=[Interface\Addons\SpaUI\Social\emojis\Titter]=]},
    {L["chat_emote_wretched"], [=[Interface\Addons\SpaUI\Social\emojis\Ugly]=]},
    {L["chat_emote_victory"], [=[Interface\Addons\SpaUI\Social\emojis\Victory]=]},
    {L["chat_emote_lei_feng"],[=[Interface\Addons\SpaUI\Social\emojis\Volunteer]=]},
    {L["chat_emote_injustice"],[=[Interface\Addons\SpaUI\Social\emojis\Wronged]=]}
}

function OnLoad(self)
    _Enabled = _Config.Social.ChatBar.ChatEmote.Enable
end

function OnEnable(self)
    RegisterEmoteChanel()
    OnChatBubblesSettingChanged()
    CreateChatEmoteButton()
end

-- 表情解析规则
EMOTE_RULE = format("\124T%%s:%d\124t", max(floor(select(2, SELECTED_CHAT_FRAME:GetFont())),EMOTE_SIZE))

function ReplaceEmote(msg)
    for i = 1, #EMOTES do
        if msg == EMOTES[i][1] then
            return format(EMOTE_RULE,EMOTES[i][2])
        end
    end
    return msg
end

function ChatEmoteFilter(self, event, msg, ...)
    msg = msg:gsub("%{.-%}", ReplaceEmote)
    return false, msg, ...
end

-- 注册需要解析表情的频道
function RegisterEmoteChanel()
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ChatEmoteFilter) -- 公共频道
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", ChatEmoteFilter) -- 说
    ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", ChatEmoteFilter) -- 大喊
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", ChatEmoteFilter) -- 团队
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", ChatEmoteFilter) -- 团队领袖
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", ChatEmoteFilter) -- 队伍
    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", ChatEmoteFilter) -- 队伍领袖
    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", ChatEmoteFilter) -- 公会
    ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", ChatEmoteFilter) -- AFK玩家自动回复
    ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", ChatEmoteFilter) -- 切勿打扰自动回复
    
    -- 副本和副本领袖
    ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", ChatEmoteFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", ChatEmoteFilter)
    -- 解析战网私聊
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", ChatEmoteFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", ChatEmoteFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", ChatEmoteFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", ChatEmoteFilter)
    -- 解析社区聊天内容
    ChatFrame_AddMessageEventFilter("CHAT_MSG_COMMUNITIES_CHANNEL", ChatEmoteFilter)
end

function OnEmoteClick(button, clickType)
    if (clickType == "LeftButton") then
        local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
        if (not ChatFrameEditBox:IsShown()) then
            ChatEdit_ActivateChat(ChatFrameEditBox)
        end
        ChatFrameEditBox:Insert(button.text)
    end
    ToggleEmoteTable()
end

-- 创建表情面板
function CreateEmoteTableFrame()
    EmoteTableFrame = Frame("SpaUIEmoteTableFrame", UIParent, "BasicFrameTemplateWithInset")
    
    local Container = Frame("Container", EmoteTableFrame)
    Container:SetPoint("TOPLEFT", EmoteTableFrame.LeftBorder, "TOPRIGHT")
    Container:SetPoint("BOTTOMRIGHT", EmoteTableFrame.RightBorder, "BOTTOMLEFT")
    EmoteTableFrame.TitleText:SetText(L["chat_bar_emote_table"])

    local icon, row, col, text, texture
    for i = 1, #EMOTES do
        row = floor((i - 1) / EMOTE_RAW_SIZE)
        col = floor((i - 1) % EMOTE_RAW_SIZE)
        text = EMOTES[i][1]
        texture = EMOTES[i][2]

        icon = Button(format("SpaUIEmoteIcon%d", i),Container)
        icon.text = text
        icon:SetSize(EMOTE_SIZE, EMOTE_SIZE)
        icon:SetLocation{
            Anchor("LEFT", col * (EMOTE_SIZE + EMOTE_SIZE_MARGIN), 0, Container:GetName(true), "LEFT"),
            Anchor("TOP", 0, -row * (EMOTE_SIZE + EMOTE_SIZE_MARGIN), Container:GetName(true), "TOP")
        }
        icon:SetNormalTexture(texture)
        icon:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]],"ADD")
        function icon:OnEnter()
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(self.text)
            GameTooltip:Show()
        end
        
        function icon:OnLeave()
            GameTooltip:Hide()
        end

        function icon:OnMouseDown()
            self:SetAlpha(ALPHA_PRESS)
        end

        function icon:OnMouseUp(button)
            self:SetAlpha(ALPHA_NORMAL)
            OnEmoteClick(self, button)
        end
    end
    EmoteTableFrame:SetSize((EMOTE_SIZE + EMOTE_SIZE_MARGIN) * EMOTE_RAW_SIZE + 20, (row + 1) * (EMOTE_SIZE + EMOTE_SIZE_MARGIN) + 35)
    EmoteTableFrame:SetFrameStrata("DIALOG")
    EmoteTableFrame:Hide()
end

-- 生成表情按钮
function CreateChatEmoteButton()
    ChatEmoteButton = Button("SpaUIChatEmoteButton")
    Style[ChatEmoteButton] = {
        size = Size(CHAT_BAR_BUTTON_SIZE,CHAT_BAR_BUTTON_SIZE),
        location = {Anchor("RIGHT", -CHAT_BAR_BUTTON_MARGIN, 0, ChatBar:GetName() ,"LEFT")},
        alpha = ALPHA_LEAVE,
        normalTexture = {
            file = [[Interface\Addons\SpaUI\Social\emojis\greet]],
            setAllPoints = true
        }
    }
    
    function ChatEmoteButton:OnEnter()
        self:SetAlpha(ALPHA_ENTER)     
    end

    function ChatEmoteButton:OnLeave()
        self:SetAlpha(ALPHA_LEAVE)     
    end
    
    function ChatEmoteButton:OnMouseUp()
        self:SetScale(SCALE_UP)
    end

    function ChatEmoteButton:OnMouseDown()
        self:SetScale(SCALE_PRESS)
    end

    function ChatEmoteButton:OnClick()
        FireSystemEvent("SPAUI_TOGGLE_EMOTE_FRAME",Anchors{Anchor("BOTTOMLEFT",3,3,self:GetName(),"TOPRIGHT")})
    end
end

----------------
--  聊天气泡   --
----------------
EMOTE_CHAT_DEFAULT_RULE = format("\124T%%s:%d\124t", EMOTE_SIZE)

function DefaultReplaceEmote(msg)
    for i = 9, #EMOTES do
        if msg == EMOTES[i][1] then
            return format(EMOTE_CHAT_DEFAULT_RULE,EMOTES[i][2])
        end
    end
    return msg
end


-- 启用/禁用气泡消息接收监听
__AsyncSingle__(true)
function ChatBubblesMsgEnabled(enable, events)
    while enable do
        Wait(unpack(events))
        --最多重试5次
        local count = 5
        repeat
            Delay(0.1)
            local chatBubbles = C_ChatBubbles.GetAllChatBubbles()
            local frame, text, after
            for _, v in pairs(chatBubbles) do
                frame = v:GetChildren()
                if (frame and frame.String) then
                    text = frame.String:GetText()
                    after = text:gsub("%{.-%}", DefaultReplaceEmote)
                    if (after ~= text) then
                        return frame.String:SetText(after)
                    end
                end
            end
            if #chatBubbles > 0 then
                break
            end
            count = count -1
        until count < 0
    end
end

-- 监听聊天气泡设置变更
__SecureHook__(_G,"InterfaceOptionsDisplayPanelChatBubblesDropDown_SetValue")
function OnChatBubblesSettingChanged()
    local chatBubbles = C_CVar.GetCVarBool("chatBubbles")
    local chatBubblesParty = C_CVar.GetCVarBool("chatBubblesParty")
    if chatBubbles or chatBubblesParty then
        local events = {}
        if chatBubbles then
            tinsert(events, "CHAT_MSG_SAY")
        end
        if chatBubblesParty then
            tinsert(events, "CHAT_MSG_PARTY")
        end
        ChatBubblesMsgEnabled(true,events)
    else
        ChatBubblesMsgEnabled(false)
    end
end

-- 关闭表情面板
__SystemEvent__("SPAUI_CLOSE_EMOTE_FRAME")
function CloseEmoteTable()
    if not _Enabled or not EmoteTableFrame then return end
    EmoteTableFrame:Hide()
end

-- 打开/关闭表情面板
__SystemEvent__("SPAUI_TOGGLE_EMOTE_FRAME")
__Arguments__{Variable.Optional(Archors, nil)}
__AsyncSingle__()
function ToggleEmoteTable(location)
    if not _Enabled then return end
    if not EmoteTableFrame then
        CreateEmoteTableFrame()
    end
    if EmoteTableFrame:IsShown() then
        EmoteTableFrame:Hide()
    else
        EmoteTableFrame:SetLocation(location)
        EmoteTableFrame:Show()
    end
end