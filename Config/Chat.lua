Scorpio "SpaUI.Config.Chat" ""

DefaultConfig = {
    ChatBar                                 = {
        Enable                              = true,
        
        ChatEmote                           = {
            Enable                          = true
        }
    },

    ChatLinkTooltips                        = {
        Enable                              = true
    },

    ChatTab                                 = {
        Enable                              = true
    }
}

ConfigBehaivors = {
    -- 聊天栏
    ChatBar                                 = {
        NeedReload                          = function(self)
            return self.TempValue ~= nil and self.TempValue ~= DB.ChatBar.Enable
        end,
        OnValueChange                       = function(self, value)
            self.TempValue = value
        end,
        SaveConfig                          = function(self)
            if self.TempValue ~= nil then
                DB.ChatBar.Enable  = self.TempValue
            end
        end,
        GetValue                            = function(self)
            return DB.ChatBar.Enable
        end,
        Restore                             = function(self)
            self.TempValue = nil
        end,

        -- 聊天表情
        ChatEmote                           = {
            NeedReload                      = function(self)
                return self.TempValue ~= nil and self.TempValue ~= DB.ChatBar.ChatEmote.Enable
            end,
            OnValueChange                   = function(self, value)
                self.TempValue = value
            end,
            SaveConfig                      = function(self)
                if self.TempValue ~= nil then
                    DB.ChatBar.ChatEmote.Enable = self.TempValue
                end
            end,
            GetValue                        = function(self)
                return DB.ChatBar.ChatEmote.Enable
            end,
            Restore                         = function(self)
                self.TempValue = nil
            end,
        }
    },

    -- 聊天链接悬浮提示
    ChatLinkTooltips                        = {
        OnValueChange                       = function(self, value)
            DB.ChatLinkTooltips.Enable = value
        end,
        GetValue                            = function(self)
            return DB.ChatLinkTooltips.Enable
        end
    },
    
    -- Tab切换频道
    ChatTab                                 = {
        OnValueChange                       = function (self, value)
            DB.ChatTab.Enable = value
        end,
        GetValue                            = function (self)
            return DB.ChatTab.Enable
        end
    }       
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

function OnEnable(self)
    ChatContainer = Frame("ChatContainer", ConfigContainer)
    FontString("ChatTitle", ChatContainer)
    ChatBarEnableButton = OptionsCheckButton("ChatBarEnableButton", ChatContainer)
    ChatEmoteEnableButton = OptionsCheckButton("ChatEmoteEnableButton", ChatBarEnableButton)
    OptionsCheckButton("ChatLinkTooltipEnableButton", ChatContainer)
    OptionsCheckButton("ChatTab", ChatContainer)

    Style[ChatContainer] = {
        location                        = {
            Anchor("TOPLEFT", 15, -15),
            Anchor("BOTTOMRIGHT", -15, 15)
        },

        ChatTitle                       = {
            location                    = {
                Anchor("TOPLEFT")
            },
            text                        = L["config_chat_enhanced"],
            fontObject                  = GameFontNormalLarge
        },

        ChatBarEnableButton             = {
            configBehavior              = ConfigBehaivors.ChatBar,
            tooltipText                 = L["config_chat_bar_tooltip"],
            location                    = {
                Anchor("TOPLEFT", -3, -5, "ChatTitle", "BOTTOMLEFT")
            },

            Label                       = {
                text                    = L["config_chat_bar"]
            },

            ChatEmoteEnableButton           = {
                configBehavior              = ConfigBehaivors.ChatBar.ChatEmote,
                enabled                     = DB.ChatBar.Enable,
                tooltipText                 = L["config_chat_emote_tooltip"],
                location                    = {
                    Anchor("TOPLEFT", 15, -3, nil, "BOTTOMLEFT")
                },
                Label                       = {
                    text                    = L["config_chat_emote"],
                    fontObject              = GameFontNormal
                }
            },
        },

        ChatLinkTooltipEnableButton     = {
            configBehavior              = ConfigBehaivors.ChatLinkTooltips,
            tooltipText                 = L["config_chat_linktip_tooltip"],
            location                    = {
                Anchor("LEFT", 0, 0, "ChatBarEnableButton", "LEFT"),
                Anchor("TOP", 0, -3, "ChatBarEnableButton.ChatEmoteEnableButton", "BOTTOM")
            },
            Label                       = {
                text                    = L["config_chat_linktip"]
            }
        },

        ChatTab                         = {
            configBehavior              = ConfigBehaivors.ChatTab,
            tooltipText                 = L["config_chat_tab_tooltip"],
            location                    = {
                Anchor("TOPLEFT", 0, -3, "ChatLinkTooltipEnableButton", "BOTTOMLEFT")
            },
            Label                       = {
                text                    = L["config_chat_tab"]
            }
        }
    }
end