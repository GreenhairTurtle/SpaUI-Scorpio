Scorpio "SpaUI.Config.Chat" ""

L = _Locale

-- 默认配置
DefaultConfig = {
    -- 聊天栏
    ChatBar                     = {
        Enable                  = true
    },          
    -- 聊天切换
    ChatTab                     = {
        Enable                  = true
    },          
    -- 聊天表情
    ChatEmoji                   = {
        Enable                  = true,

        ChatBubble              = {
            Enable              = true,
        }
    },
    -- 聊天链接显示鼠标提示
    ChatLinkTooltips            = {
        Enable                  = true
    }
}

ConfigBehaivors = {
    -- 聊天栏
    ChatBar                     = {
        NeedReload              = function(self)
            return self.TempValue ~= nil and self.TempValue ~= DB.ChatBar.Enable
        end,
        OnValueChange           = function(self, value)
            self.TempValue      = value
        end
    },
}

function OnLoad(self)
    _Enabled = false
    SetDefaultToConfigDB(_Name, DefaultConfig)
    DB = _Config[_Name]
end

function Show()
    if not ChatContainer then _Enabled = true return end
    ChatContainer:Show()
end

function Hide()
    if not ChatContainer then return end
    ChatContainer:Hide()
end

-- 不太希望这个三个方法放在父模组内，尽管可以这样,使用起来也方便
-- 是否需要重载界面
function NeedReload()
    if ConfigItems then
        for _, configItem in ipairs(ConfigItems) do
            if configItem:NeedReload() then return true end
        end
    end
end

-- 添加变更后需要重载的配置项
function AddReloadWatch(item)
    if not ConfigItems then ConfigItems = {} end
    if Interface.ValidateValue(ConfigItem, item) then
        tinsert(ConfigItems, item)
    end
end

-- 添加变更后需要重载的配置项列表
__Arguments__(UIObject)
function AddReloadWatchList(parent)
    for _, child in parent:GetChilds() do
        AddReloadWatch(child)
        AddReloadWatchList(child)
    end
end
----------  end  -----------
----------------------------

function OnEnable(self)
    ChatContainer = Frame("ChatContainer", ConfigContainer)
    -- 聊天栏
    ChatBarTitle = FontString("ChatBarTitle", ChatContainer, nil, "GameFontNormal")
    ChatBarEnableButton = OptionsCheckButton("ChatBarEnableButton", ChatContainer)

    AddReloadWatchList(ChatContainer)

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
            checked                     = DB.ChatBar.Enable,
            configBehavior              = ConfigBehaivors.ChatBar,
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