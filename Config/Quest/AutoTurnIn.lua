Scorpio "SpaUI.Config.Quest.AutoTurnIn" ""

DefaultCharConfig = {
    Enable                  = true,
    Auto                    = true,
    ModifierKey             = OptionsModifierKey.SHIFT,
    AutoDaily               = false,
    AutoWeekly              = true,
    AutoRepeatable          = false,
    AutoTrivial             = false,
    AutoTrivialDaily        = false,
    AutoTrivialWeekly       = true,
    AutoTrivialRepeatable   = false
}

ConfigBehaivors = {
    GetValue                        = function(self)
        return DBChar.Enable
    end,
    NeedReload                      = function(self)
        return self.TempValue ~= nil and self.TempValue ~= DBChar.Enable
    end,
    OnValueChange                   = function(self, value)
        self.TempValue = value
    end,
    SaveConfig                      = function(self)
        if self.TempValue ~= nil then
            DBChar.Enable = self.TempValue
        end
    end,
    Restore                         = function(self)
        self.TempValue = nil
    end,

    AutoTurnIn                      = {
        GetValue                    = function(self)
            return DBChar.Auto
        end,
        OnValueChange               = function(self, value)
            DBChar.Auto = value
            FireSystemEvent("SPAUI_TOGGLE_AUTO_TURN_IN")
        end
    },

    ModifierKey                     = {
        GetValue                    = function(self)
            return DBChar.ModifierKey, OptionsModifierKey.GetKeyText(DBChar.ModifierKey)
        end,
        OnValueChange               = function(self, arg1, arg2, checked)
            DBChar.ModifierKey = arg1
            return true
        end
    },

    AutoDaily                       = {
        GetValue                    = function(self)
            return DBChar.AutoDaily
        end,
        OnValueChange               = function(self, value)
            DBChar.AutoDaily = value
        end
    },

    AutoWeekly                      = {
        GetValue                    = function(self)
            return DBChar.AutoWeekly
        end,
        OnValueChange               = function(self, value)
            DBChar.AutoWeekly = value
        end
    },

    AutoRepeatable                  = {
        GetValue                    = function(self)
            return DBChar.AutoRepeatable
        end,
        OnValueChange               = function(self, value)
            DBChar.AutoRepeatable = value
        end
    },

    AutoTrivial                     = {
        GetValue                    = function(self)
            return DBChar.AutoTrivial
        end,
        OnValueChange               = function(self, value)
            DBChar.AutoTrivial = value
        end
    },

    AutoTrivialWeekly               = {
        GetValue                    = function(self)
            return DBChar.AutoTrivialWeekly
        end,
        OnValueChange               = function(self, value)
            DBChar.AutoTrivialWeekly = value
        end
    },

    AutoTrivialDaily                = {
        GetValue                    = function(self)
            return DBChar.AutoTrivialDaily
        end,
        OnValueChange               = function(self, value)
            DBChar.AutoTrivialDaily = value
        end
    },

    AutoTrivialRepeatable           = {
        GetValue                    = function(self)
            return DBChar.AutoTrivialRepeatable
        end,
        OnValueChange               = function(self, value)
            DBChar.AutoTrivialRepeatable = value
        end
    }
}

function OnLoad(self)
    _Enabled = false
    SetDefaultToConfigDB(_Name,nil, DefaultCharConfig)
    DBChar = _Config.Char[_Parent._Name][_Name]
end

function Show()
    if not AutoTurnInContainer then _Enabled = true return end
    AutoTurnInContainer:Show()
end

function Hide()
    if not AutoTurnInContainer then return end
    AutoTurnInContainer:Hide()
end

function OnEnable(self)
    AutoTurnInContainer = Frame("AutoTurnInContainer", ConfigContainer)
    FontString("AutoTurnInTitle", AutoTurnInContainer)
    AutoTurnInModuleEnableButton = OptionsCheckButton("AutoTurnInModuleEnableButton", AutoTurnInContainer)
    OptionsLine("Line1", AutoTurnInContainer)
    OptionsCheckButton("AutoTurnInEnableButton", AutoTurnInModuleEnableButton)
    OptionsDropDownMenu("AutoTurnInModifierKeyDropDownMenu", AutoTurnInModuleEnableButton)
    OptionsLine("Line2", AutoTurnInContainer)
    OptionsCheckButton("AutoWeeklyEnableButton", AutoTurnInModuleEnableButton)
    OptionsCheckButton("AutoDailyEnableButton", AutoTurnInModuleEnableButton)
    OptionsCheckButton("AutoRepeatableEnableButton", AutoTurnInModuleEnableButton)
    OptionsLine("Line3", AutoTurnInContainer)
    local AutoTrivialEnableButton = OptionsCheckButton("AutoTrivialEnableButton", AutoTurnInModuleEnableButton)
    OptionsCheckButton("AutoTrivialWeeklyEnableButton", AutoTrivialEnableButton)
    OptionsCheckButton("AutoTrivialDailyEnableButton", AutoTrivialEnableButton)
    OptionsCheckButton("AutoTrivialRepeatableEnableButton", AutoTrivialEnableButton)

    Style[AutoTurnInContainer] = {
        location                                        = {
            Anchor("TOPLEFT", 15, -15),
            Anchor("BOTTOMRIGHT", -15, 15)
        },

        AutoTurnInTitle                                 = {
            text                                        = L["config_quest_auto_turn_in_title"],
            location                                    = {
                Anchor("TOPLEFT")
            },
            fontObject                                  = GameFontNormalLarge
        },

        Line1                                           = {
            location                                    = {
                Anchor("LEFT"),
                Anchor("RIGHT"),
                Anchor("TOP", 0, -10, "AutoTurnInModuleEnableButton", "BOTTOM")
            }
        },

        Line2                                           = {
            location                                    = {
                Anchor("LEFT"),
                Anchor("RIGHT"),
                Anchor("TOP", 0, -10, "AutoTurnInModuleEnableButton.AutoTurnInModifierKeyDropDownMenu", "BOTTOM")
            }
        },

        Line3                                           = {
            location                                    = {
                Anchor("LEFT"),
                Anchor("RIGHT"),
                Anchor("TOP", 0, -10, "AutoTurnInModuleEnableButton.AutoRepeatableEnableButton", "BOTTOM")
            }
        },

        AutoTurnInModuleEnableButton                    = {
            configBehavior                              = ConfigBehaivors,
            location                                    = {
                Anchor("TOPLEFT", -3, -5, "AutoTurnInTitle", "BOTTOMLEFT")
            },
            tooltipText                                 = L["config_quest_auto_turn_in_module_enable_tooltip"],

            Label                                       = {
                text                                    = L["module_enable"]
            },

            AutoTurnInEnableButton                      = {
                configBehavior                          = ConfigBehaivors.AutoTurnIn,
                location                                = {
                    Anchor("LEFT"),
                    Anchor("TOP", 0, -10, "$parent.$parent.Line1", "BOTTOM")
                },
                
                Label                                   = {
                    text                                = L["config_quest_auto_turn_in_enable_tooltip"]
                }
            },

            AutoTurnInModifierKeyDropDownMenu           = {
                location                                = {
                    Anchor("TOPLEFT", -13, -30, "AutoTurnInEnableButton", "BOTTOMLEFT"),
                },
                configBehavior                          = ConfigBehaivors.ModifierKey,
                dropDownMenuWidth                       = 120,
                displayTextJustifyH                     = "RIGHT",
                tooltipText                             = L["config_quest_auto_turn_in_enable_key_tooltip"],
                dropDownInfos                           = {
                    {
                        text                            = SHIFT_KEY,
                        value                           = OptionsModifierKey.SHIFT,
                    },
                    {
                        text                            = ALT_KEY,
                        value                           = OptionsModifierKey.ALT,
                    },
                    {
                        text                            = CTRL_KEY,
                        value                           = OptionsModifierKey.CTRL,
                    }
                },

                Label                                   = {
                    fontObject                          = GameFontNormal,
                    text                                = L["config_quest_auto_turn_in_enable_key"],
                    location                            = {
                        Anchor("BOTTOMLEFT", 18, 5, nil, "TOPLEFT")
                    }
                }
            },

            AutoWeeklyEnableButton                      = {
                configBehavior                          = ConfigBehaivors.AutoWeekly,
                location                                = {
                    Anchor("LEFT"),
                    Anchor("TOP", 0, -10, "$parent.$parent.Line2", "BOTTOM")
                },

                Label                                   = {
                    text                                = L["config_quest_auto_turn_in_auto_weekly"]
                }
            },

            AutoDailyEnableButton                       = {
                configBehavior                          = ConfigBehaivors.AutoDaily,
                location                                = {
                    Anchor("TOP", 0, -10, "$parent.$parent.Line2", "BOTTOM")
                },

                Label                                   = {
                    text                                = L["config_quest_auto_turn_in_auto_daily"]
                }
            },

            AutoRepeatableEnableButton                  = {
                configBehavior                          = ConfigBehaivors.AutoRepeatable,
                location                                = {
                    Anchor("TOPLEFT", 0, -10, "AutoWeeklyEnableButton", "BOTTOMLEFT")
                },

                Label                                   = {
                    text                                = L["config_quest_auto_turn_in_auto_repeatable"]
                }
            },

            AutoTrivialEnableButton                     = {
                configBehavior                          = ConfigBehaivors.AutoTrivial,
                location                                = {
                    Anchor("LEFT"),
                    Anchor("TOP", 0, -10, "$parent.$parent.Line3", "BOTTOM")
                },

                Label                                   = {
                    text                                = L["config_quest_auto_turn_in_auto_trivial"],
                    fontObject                          = GameFontNormal
                },

                AutoTrivialWeeklyEnableButton           = {
                    configBehavior                      = ConfigBehaivors.AutoTrivialWeekly,
                    location                            = {
                        Anchor("TOP", 0, -10, "$parent.$parent.$parent.Line3", "BOTTOM")
                    },

                    Label                               = {
                        text                            = L["config_quest_auto_turn_in_auto_trivial_weekly"]
                    }
                },

                AutoTrivialDailyEnableButton            = {
                    configBehavior                      = ConfigBehaivors.AutoTrivialDaily,
                    location                            = {
                        Anchor("TOPLEFT", 0, -10, nil, "BOTTOMLEFT")
                    },

                    Label                               = {
                        text                            = L["config_quest_auto_turn_in_auto_trivial_daily"]
                    }
                },

                AutoTrivialRepeatableEnableButton       = {
                    configBehavior                      = ConfigBehaivors.AutoTrivialRepeatable,
                    location                            = {
                        Anchor("TOPLEFT", 0, -10, "AutoTrivialWeeklyEnableButton", "BOTTOMLEFT")
                    },

                    Label                               = {
                        text                            = L["config_quest_auto_turn_in_auto_trivial_repeatable"]
                    }
                }
            }
        }
    }
end

-- 和任务栏开关按钮状态同步
__SystemEvent__()
function SPAUI_TOGGLE_AUTO_TURN_IN()
    if not AutoTurnInEnableButton then return end
    AutoTurnInEnableButton:SetChecked(DBChar.Auto)
end