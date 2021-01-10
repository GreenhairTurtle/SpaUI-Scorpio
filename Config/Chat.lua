Scorpio "SpaUI.Config.Chat" ""

L = _Locale

DefaultConfig = {
    -- 聊天栏
    ChatBar                     = {
        Enable                  = true,
        NeedReload              = true,
    },          
    -- 聊天切换    
    ChatTab                     = {
        Enable                  = true,
        NeedReload              = false
    },          
    -- 聊天表情     
    ChatEmoji                   = {
        Enable                  = true,
        NeedReload              = true,

        ChatBubble              = {
            Enable              = true,
            NeedReload          = true
        }
    },
    -- 聊天链接显示鼠标提示
    ChatLinkTooltips            = {
        Enable                  = true,
        NeedReload              = false
    }
}

function OnLoad(self)
    _Enabled = false
    SetDefaultToDB(_Name, DefaultConfig)
    Config = _Config[_Name]
end

function Show()
    if not ChatContainer then _Enabled = true return end
    ChatContainer:Show()
end

function Hide()
    if not ChatContainer then return end
    ChatContainer:Hide()
end

function OnEnable(self)
    ChatContainer = Frame("ChatContainer", ConfigContainer)
    -- 聊天栏
    ChatBarTitle = FontString("ChatBarTitle", ChatContainer, nil, "GameFontNormal")
    ChatBarEnableButton = OptionsCheckButton("ChatBarEnableButton", ChatContainer)

    Style[ChatContainer] = {
        location                        = {
            Anchor("TOPLEFT", 15, -15),
            Anchor("BOTTOMRIGHT", -15, 15)
        },

        ChatBarTitle                    = {
            location                    = {
                Anchor("TOPLEFT")
            },
            text                        = L["config_chat_bar_title"]
        },

        ChatBarEnableButton             = {
            checked                     = Config.ChatBar.Enable,
            tooltipText                 = L["config_chat_bar_tooltip"],
            location                    = {
                Anchor("TOPLEFT", -3, -5, "ChatBarTitle", "BOTTOMLEFT")
            },
            Label                       = {
                text                    = L["enable"]
            }
        }
    }
end