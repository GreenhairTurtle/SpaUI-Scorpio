Scorpio "SpaUI.Chat.ChatBar" ""

L = _Locale

CHAT_BAR_MESSAGE_TYPES = {
    "Say", "Yell", "Party", "Raid", "Instance_Chat", "Guild", "World", "Roll"
}
CHAT_BAR_BUTTON_SIZE = 20
CHAT_BAR_BUTTON_MARGIN = 2
ALPHA_ENTER = 1.0
ALPHA_LEAVE = 0.3
SCALE_PRESS = 1.25
SCALE_UP = 1
CHANNEL_WORLD_DEFAULT_COLOR_R = 1
CHANNEL_WORLD_DEFAULT_COLOR_G = 0.75294125080109
CHANNEL_WORLD_DEFAULT_COLOR_B = 0.75294125080109

local ChatTypeInfo = ChatTypeInfo
local ChatEdit_UpdateHeader = ChatEdit_UpdateHeader
local ChatFrame1EditBox = ChatFrame1EditBox
local ChatFrame1Background = ChatFrame1Background
local GetCVar = GetCVar
local ChatMenu_SetChatType = ChatMenu_SetChatType
local RandomRoll = RandomRoll
local ChatFrame_OpenChat = ChatFrame_OpenChat

function OnEnable(self)
    -- 创建聊天条和表情按钮
    CreateChatBar()
    CreateChatEmoteButton()
end

local function SetOrHookScript(scriptType)
    if ChatFrame1EditBox:GetScript(scriptType) then
        ChatFrame1EditBox:HookScript(scriptType, OnEditBoxStatusChange)
    else
        ChatFrame1EditBox:SetScript(scriptType, OnEditBoxStatusChange)
    end
end

-- -- 创建ChatBar
--todo
function CreateChatBar()
    if not ChatFrame1EditBox then return end
    ChatBar = Frame("SpaUIChatBar")
    Style[ChatBar] = {
            size = Size(#CHAT_BAR_MESSAGE_TYPES * (CHAT_BAR_BUTTON_SIZE + CHAT_BAR_BUTTON_MARGIN), CHAT_BAR_BUTTON_SIZE),
            frameStrata = ChatFrame1:GetFrameStrata(),
    }

    ChangeChatBarLocation(ChatFrame1EditBox)

    for i = 1, #CHAT_BAR_MESSAGE_TYPES do CreateChatBarButton(i) end

    SetOrHookScript("OnEditFocusLost")
    SetOrHookScript("OnEditFocusGained")

    if ChatBar.relativeTo:GetBottom() < CHAT_BAR_BUTTON_SIZE then
        ShowMessage(L["chat_bar_outside"])
    end
end

-- 更改ChatBar锚点
__SecureHook__(_G,"ChatEdit_ActivateChat")
function ChangeChatBarLocation(editbox)
    if not editbox or editbox ~= ChatFrame1EditBox or not ChatBar then
        return
    end
    local chatStyle = GetCVar("chatStyle")
    local relativeTo
    if chatStyle == "classic" then
        relativeTo = ChatFrame1Background
    else
        relativeTo = editbox
    end
    if ChatBar.chatStyle ~= chatStyle or ChatBar.relativeTo ~= relativeTo then
        ChatBar:SetLocation(Anchors({Anchor("TOPLEFT", 0, 0, relativeTo:GetName(), "BOTTOMLEFT")}))
        ChatBar.chatStyle = chatStyle
        ChatBar.relativeTo = relativeTo
    end
end

-- 创建ChatBar按钮
function CreateChatBarButton(index)
    local type = CHAT_BAR_MESSAGE_TYPES[index]
    local button = Button("SpaUIChatBarButton"..type, ChatBar)
    -- 默认样式
    Style[button] = {
        size = Size(CHAT_BAR_BUTTON_SIZE,CHAT_BAR_BUTTON_SIZE),
        alpha = ALPHA_LEAVE,
        location = {Anchor("LEFT",(index-1)*(CHAT_BAR_BUTTON_MARGIN + CHAT_BAR_BUTTON_SIZE),0,nil,"LEFT")},
    }

    --淡入淡出
    function button:OnEnter()
        self:SetAlpha(ALPHA_ENTER)
    end
    function button:OnLeave()
        self:SetAlpha(ALPHA_LEAVE)
    end

    local chatTypeInfo = ChatTypeInfo[strupper(type)]
    if chatTypeInfo then
        -- 更改按钮颜色 设置点击事件
        local Text = FontString("Text",button,"GameFontNormal")
        Style[Text] = {
            setAllPoints = true,
            text = Color.ColorText(L["chat_bar_channel_"..strlower(type)],chatTypeInfo.r,chatTypeInfo.g,chatTypeInfo.b)
        }
        function button:OnClick()
            ChatMenu_SetChatType(ChatFrame1,strupper(type))
        end
    elseif type == "World" then
        local channelTarget = GetWorldChannelID()
        local info = channelTarget and ChatTypeInfo["CHANNEL" .. channelTarget] or nil
        local r = info and info.r or CHANNEL_WORLD_DEFAULT_COLOR_R
        local g = info and info.g or CHANNEL_WORLD_DEFAULT_COLOR_G
        local b = info and info.b or CHANNEL_WORLD_DEFAULT_COLOR_B
        -- 世界频道按钮
        local Text = FontString("Text",button,"GameFontNormal")
        Style[Text] = {
            setAllPoints = true,
            text = Color.ColorText(L["chat_bar_channel_" .. (strlower(type))],r,g,b)
        }

        function button:OnClick(button)
            OnWorldChannelButtonClick(self,button)
        end
    elseif type == "Roll" then
    --     -- roll点
        Style[button] = {
            location = {Anchor("LEFT",(index-1)*(CHAT_BAR_BUTTON_MARGIN + CHAT_BAR_BUTTON_SIZE)+3,0,nil,"LEFT")},
            normalTexture = {
                file = [[Interface\Addons\SpaUI\Media\roll]],
                setAllPoints = true
            },
            highlightTexture = {
                file = [[Interface\Addons\SpaUI\Media\roll_highlight]],
                setAllPoints = true
            },
            pushedTexture = {
                file = [[Interface\Addons\SpaUI\Media\roll_pressed]],
                setAllPoints = true
            }
        }
        function button:OnClick()
            RandomRoll(1,100)
        end
    end
end

-- 点击世界频道按钮
function OnWorldChannelButtonClick(button,key)
    local channelTarget = GetWorldChannelID()
    if channelTarget then
        local chatTypeInfo = ChatTypeInfo["CHANNEL" .. channelTarget]
        -- 改下世界频道的按钮颜色
        if chatTypeInfo then
            button.Text:SetText(Color.ColorText(L["chat_bar_channel_world"], chatTypeInfo.r,chatTypeInfo.g, chatTypeInfo.b))
        end
        local editbox = ChatFrame_OpenChat("", ChatFrame1)
        editbox:SetAttribute("chatType", "CHANNEL")
        editbox:SetAttribute("channelTarget", channelTarget)
        ChatEdit_UpdateHeader(editbox)
    end
end

-- -- 状态变更
function OnEditBoxStatusChange(editbox)
    if editbox:HasFocus() then
        ChatBar:Hide()
    else
        if editbox:GetText():len() <= 0 then ChatBar:Show() end
        -- Widget:CloseEmoteTable()
    end
end

-- 生成表情按钮
function CreateChatEmoteButton()
    if not ChatBar then return end
    ChatEmoteButton = Button("SpaUIChatEmoteButton")
    Style[ChatEmoteButton] = {
        size = Size(CHAT_BAR_BUTTON_SIZE,CHAT_BAR_BUTTON_SIZE),
        location = {Anchor("RIGHT",-CHAT_BAR_BUTTON_MARGIN,0,ChatBar:GetName(),"LEFT")},
        alpha = ALPHA_LEAVE,
        normalTexture = {
            file = [[Interface\Addons\SpaUI\Chat\emojis\greet]],
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