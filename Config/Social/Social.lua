Scorpio "SpaUI.Config.Social" ""

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

ConfigBehaviors = {
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
    _Parent.SetDefaultToConfigDB(_Name, DefaultConfig)
    DB = _Config[_Name]
end

function SetDefaultToConfigDB(childName, globalConfig, charConfig)
    DefaultConfig = DefaultConfig or {}
    DefaultConfig[childName] = globalConfig
    DefaultCharConfig = DefaultCharConfig or {}
    DefaultCharConfig[childName] = charConfig
    _Parent.SetDefaultToConfigDB(_Name, DefaultConfig, DefaultCharConfig)
end

function Show(childModule)
    if not SocialContainer then
        _Enabled = true
    end
    _Enabled = true
    if childModule then
        _Modules[childModule].Show()
        SocialContainer:Hide()
    else
        SocialContainer:Show()
    end
end

function Hide(childModule)
    if childModule then
        _Modules[childModule].Hide()
    else
        if not SocialContainer then return end
        SocialContainer:Hide()
    end
end

function OnEnable(self)
    SocialContainer = Frame("SocialContainer", ConfigContainer)
    FontString("ChatTitle", SocialContainer)
    ChatBarEnableButton = OptionsCheckButton("ChatBarEnableButton", SocialContainer)
    ChatEmoteEnableButton = OptionsCheckButton("ChatEmoteEnableButton", ChatBarEnableButton)
    OptionsCheckButton("ChatLinkTooltipEnableButton", SocialContainer)
    OptionsCheckButton("ChatTab", SocialContainer)

    Style[SocialContainer]                      = {
        location                                = {
            Anchor("TOPLEFT", 15, -15),
            Anchor("BOTTOMRIGHT", -15, 15)
        },

        ChatTitle                               = {
            location                            = {
                Anchor("TOPLEFT")
            },
            text                                = L["config_chat_enhanced"],
            fontObject                          = GameFontNormalLarge
        },

        ChatBarEnableButton                     = {
            configBehavior                      = ConfigBehaviors.ChatBar,
            tooltipText                         = L["config_chat_bar_tooltip"],
            location                            = {
                Anchor("TOPLEFT", -3, -5, "ChatTitle", "BOTTOMLEFT")
            },

            Label                               = {
                text                            = L["config_chat_bar"]
            },

            ChatEmoteEnableButton               = {
                configBehavior                  = ConfigBehaviors.ChatBar.ChatEmote,
                enabled                         = DB.ChatBar.Enable,
                tooltipText                     = L["config_chat_emote_tooltip"],
                location                        = {
                    Anchor("TOPLEFT", 15, -3, nil, "BOTTOMLEFT")
                },
                Label                           = {
                    text                        = L["config_chat_emote"]
                }
            },
        },

        ChatLinkTooltipEnableButton             = {
            configBehavior                      = ConfigBehaviors.ChatLinkTooltips,
            tooltipText                         = L["config_chat_linktip_tooltip"],
            location                            = {
                Anchor("LEFT", 0, 0, "ChatBarEnableButton", "LEFT"),
                Anchor("TOP", 0, -3, "ChatBarEnableButton.ChatEmoteEnableButton", "BOTTOM")
            },
            Label                               = {
                text                            = L["config_chat_linktip"]
            }
        },

        ChatTab                                 = {
            configBehavior                      = ConfigBehaviors.ChatTab,
            tooltipText                         = L["config_chat_tab_tooltip"],
            location                            = {
                Anchor("TOPLEFT", 0, -3, "ChatLinkTooltipEnableButton", "BOTTOMLEFT")
            },
            Label                               = {
                text                            = L["config_chat_tab"]
            }
        }
    }
end