Scorpio "SpaUI.Config.Chat" ""

L = _Locale
ConfigBehaivors = {
    -- 聊天栏
    ChatBar                                 = {
        Default                             = {
            Enable                          = true
        },
        NeedReload                          = function(self)
            return self.TempValue ~= nil and self.TempValue ~= DB.ChatBar.Enable
        end,
        OnValueChange                       = function(self, value)
            self.TempValue = value
            ChatEmoteEnableButton:SetEnabled(value)
        end,
        OnSaveConfig                        = function(self)
            DB.ChatBar.Enable   = self.TempValue
        end,
        GetValue                            = function(self)
            return DB.ChatBar.Enable
        end,

        -- 聊天表情
        ChatEmote                           = {
            Default                         = {
                Enable                      = true
            },      
            NeedReload                      = function(self)
                return self.TempValue ~= nil and self.TempValue ~= DB.ChatBar.ChatEmote.Enable
            end,
            OnValueChange                   = function(self, value)
                self.TempValue      = value
            end,
            OnSaveConfig                    = function(self)
                DB.ChatBar.ChatEmote.Enable   = self.TempValue
            end,
            GetValue                        = function(self)
                return DB.ChatBar.ChatEmote.Enable
            end
        }
    },
    -- 聊天链接悬浮提示
    ChatLinkTooltips                        = {
        Default                             = {
            Enable                          = true
        },
        OnValueChange                       = function(self, value)
            DB.ChatLinkTooltips.Enable = value
        end,
        GetValue                            = function(self)
            return DB.ChatLinkTooltips.Enable
        end
    }       
}

function OnLoad(self)
    _Enabled = false
    SetDefaultToConfigDB(_Name, ConfigBehaivors)
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

function OnSaveConfig()
    if not ConfigItems then return end
    for _, configItem in ipairs(ConfigItems) do
        configItem:OnSaveConfig()
    end
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
    FontString("ChatTitle", ChatContainer, nil, "GameFontNormal")
    OptionsCheckButton("ChatBarEnableButton", ChatContainer)
    ChatEmoteEnableButton = OptionsCheckButton("ChatEmoteEnableButton", ChatContainer)
    OptionsCheckButton("ChatLinkTooltipEnableButton", ChatContainer)

    AddReloadWatchList(ChatContainer)

    Style[ChatContainer] = {
        location                        = {
            Anchor("TOPLEFT", 15, -15),
            Anchor("BOTTOMRIGHT", -15, 15)
        },

        ChatTitle                    = {
            location                    = {
                Anchor("TOPLEFT")
            },
            text                        = L["config_chat_enhanced"]
        },

        ChatBarEnableButton             = {
            configBehavior              = ConfigBehaivors.ChatBar,
            tooltipText                 = L["config_chat_bar_tooltip"],
            location                    = {
                Anchor("TOPLEFT", -3, -5, "ChatTitle", "BOTTOMLEFT")
            },
            Label                       = {
                text                    = L["config_chat_bar"]
            }
        },

        ChatEmoteEnableButton           = {
            configBehavior              = ConfigBehaivors.ChatBar.ChatEmote,
            enabled                     = DB.ChatBar.Enable,
            tooltipText                 = L["config_chat_emote_tooltip"],
            location                    = {
                Anchor("TOPLEFT", 3, -3, "ChatBarEnableButton", "BOTTOMLEFT")
            },
            Label                       = {
                text                    = L["config_chat_emote"]
            }
        },

        ChatLinkTooltipEnableButton     = {
            configBehavior              = ConfigBehaivors.ChatLinkTooltips,
            tooltipText                 = L["config_chat_linktip_tooltip"],
            location                    = {
                Anchor("TOPLEFT", 0, -3, "ChatEmoteEnableButton", "BOTTOMLEFT")
            },
            Label                       = {
                text                    = L["config_chat_linktip"]
            }
        }
    }


end