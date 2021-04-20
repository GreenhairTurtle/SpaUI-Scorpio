Scorpio "SpaUI.Social.FriendsColor" ""

function OnEnable(self)
    RealmName = GetRealmName()
    FactionName = UnitFactionGroup("player")
    FRIENDS_TOOLTIP_WOW_INFO_TEMPLATE = NORMAL_FONT_COLOR_CODE..FRIENDS_LIST_ZONE.."|r%1$s|n"..NORMAL_FONT_COLOR_CODE..FRIENDS_LIST_REALM.."|r%2$s"
    CLASS_FILE_INDEXD_BY_LOCALIZED = {}
    for classFile, localizedName in pairs(LOCALIZED_CLASS_NAMES_MALE) do
        CLASS_FILE_INDEXD_BY_LOCALIZED[localizedName] = classFile
    end
end

-- 获取战网名和角色名
-- 修改blz的FriendsFrame_GetBNetAccountNameAndStatus
local function GetBNetAccountAndCharacterName(accountInfo, noCharacterName)
    if not accountInfo then return end

    local classFile = CLASS_FILE_INDEXD_BY_LOCALIZED[accountInfo.gameAccountInfo.className]
    if classFile then
        local color = Color[classFile]
        local nameText = BNet_GetBNetAccountName(accountInfo)
        if not noCharacterName then
            local characterName = BNet_GetValidatedCharacterName(accountInfo.gameAccountInfo.characterName, nil, accountInfo.gameAccountInfo.clientProgram)
            if characterName ~= "" then
                if accountInfo.gameAccountInfo.clientProgram == BNET_CLIENT_WOW and CanCooperateWithGameAccount(accountInfo) then
                    nameText = nameText..FormatText(color, " ("..characterName..")")
                else
                    if ENABLE_COLORBLIND_MODE == "1" then
                        characterName = accountInfo.gameAccountInfo.characterName..CANNOT_COOPERATE_LABEL
                    end
                    nameText = nameText.." "..FRIENDS_OTHER_NAME_COLOR_CODE.."("..characterName..")"..FONT_COLOR_CODE_CLOSE
                end
            end
        end
        return nameText
    end
end

-- 好友染色
__SecureHook__()
function FriendsFrame_UpdateFriendButton(button)
    if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
        local info = C_FriendList.GetFriendInfoByIndex(button.id)
        if info.connected then
            local color = Color[CLASS_FILE_INDEXD_BY_LOCALIZED[info.className]]
            local nameText = FormatText(color, info.name)..", "..format(FRIENDS_LEVEL_TEMPLATE, info.level, info.className)
            button.name:SetText(nameText)

            -- 不要用info.area去比较，而是直接用button.info显示的文本去比较
            -- 这样才不会打乱blz的逻辑，blz会显示招募关系
            local infoText = button.info:GetText()
            if infoText == GetRealZoneText() then
                button.info:SetText(FormatText(Color.BROWN, infoText))
            end
        end
    elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET then
        local accountInfo = C_BattleNet.GetFriendAccountInfo(button.id)
        if accountInfo then
            local nameText = GetBNetAccountAndCharacterName(accountInfo)
            if nameText then
                button.name:SetText(nameText)
            end

            local infoText = button.info:GetText()
            if infoText == GetRealZoneText() then
                button.info:SetText(FormatText(Color.BROWN, infoText))
            end
        end
    end
end

-- 查询列表染色，虽然没有啥意义
__SecureHook__()
__SecureHook__(WhoListScrollFrame, "update")
function WhoList_Update()
	local scrollFrame = WhoListScrollFrame
	local buttons = scrollFrame.buttons
    for i = 1, #buttons do
		local button = buttons[i]
        local index = button.index
        if index then
            local info = C_FriendList.GetWhoInfo(index)
            if info.filename then
                local color = Color[info.filename] or Color.Normal
                button.Name:SetTextColor(color.r, color.g, color.b)
            end
        end
    end
end
