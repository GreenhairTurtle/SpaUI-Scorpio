Scorpio "SpaUI.Config.ActionBar.Visibility" ""

ACTIONBAR_MIN_OPACITY = 0
ACTIONBAR_MAX_OPACITY = 100
ACTIONBAR_OPACITY_STEP = 1
ACTIONBAR_FADE_DURATION_MIN = 0.5
ACTIONBAR_FADE_DURATION_MAX = 5
ACTIONBAR_FADE_DURATION_STEP = 0.1
SelectedActionBar = ACTIONBAR_MAIN

DefaultConfig                   = {
    Enable                      = false,

    -- 主动作条
    MainActionBar               = {
        OpacityConditional      = 100,
        OpacityNormal           = 30,
        FadeDuration            = 1,
        FadeAnimate             = true,

        Condition               = {
            HasTarget           = false,
            TargetCanAttack     = true,
            InCombat            = true,
            InInstance          = true
        }
    },

    -- 微型菜单和背包栏
    MicroButtonsActionBar       = {
        OpacityConditional      = 0,
        OpacityNormal           = 0,
        FadeDuration            = 1,
        FadeAnimate             = true,

        Condition               = {
            HasTarget           = false,
            TargetCanAttack     = true,
            InCombat            = false,
            InInstance          = false
        }
    },

    -- 右边动作条
    MultiBarRight               = {
        OpacityConditional      = 30,
        OpacityNormal           = 30,
        FadeDuration            = 1,
        FadeAnimate             = true,

        Condition               = {
            HasTarget           = false,
            TargetCanAttack     = true,
            InCombat            = false,
            InInstance          = false
        }
    },

    -- 右边动作条2
    MultiBarLeft                = {
        OpacityConditional      = 30,
        OpacityNormal           = 30,
        FadeDuration            = 1,
        FadeAnimate             = true,

        Condition               = {
            HasTarget           = false,
            TargetCanAttack     = true,
            InCombat            = false,
            InInstance          = false
        }
    }
}

ConfigBehaviors = {
    GetValue                    = function(self)
        return DB.Enable
    end,
    NeedReload                  = function(self)
        return self.TempValue ~= nil and self.TempValue ~= DB.Enable
    end,
    OnValueChange               = function(self, value)
        self.TempValue = value
    end,
    SaveConfig                  = function(self)
        if self.TempValue ~= nil then
            DB.Enable = self.TempValue
        end
    end,
    Restore                     = function(self)
        self.TempValue = nil
    end,

    ActionBar                   = {
        OnValueChange           = function(self, arg1, arg2, checked)
            SelectedActionBar = arg1
            OnActionBarSelectedChanged()
            return true
        end,
        GetValue                = function(self)
            return SelectedActionBar, ACTIONBARS[SelectedActionBar]
        end
    },

    -- 主动作条
    MainActionBar               = {
        OpacityConditional      = {
            GetValue            = function(self)
                return DB.MainActionBar.OpacityConditional, ACTIONBAR_MIN_OPACITY, ACTIONBAR_MAX_OPACITY, ACTIONBAR_OPACITY_STEP
            end,
            OnValueChange       = function(self, value)
                DB.MainActionBar.OpacityConditional = value
            end
        },

        OpacityNormal           = {
            GetValue            = function(self)
                return DB.MainActionBar.OpacityNormal, ACTIONBAR_MIN_OPACITY, ACTIONBAR_MAX_OPACITY, ACTIONBAR_OPACITY_STEP
            end,
            OnValueChange       = function(self, value)
                DB.MainActionBar.OpacityNormal = value
            end
        },

        FadeAnimate             = {
            GetValue            = function(self)
                return DB.MainActionBar.FadeAnimate
            end,
            OnValueChange       = function(self, value)
                DB.MainActionBar.FadeAnimate = value
            end
        },

        FadeDuration            = {
            GetValue            = function(self)
                return DB.MainActionBar.FadeDuration, ACTIONBAR_FADE_DURATION_MIN, ACTIONBAR_FADE_DURATION_MAX, ACTIONBAR_FADE_DURATION_STEP
            end,
            OnValueChange       = function(self, value)
                DB.MainActionBar.FadeDuration = value
            end
        },

        Condition               = {
            HasTarget           = {
                GetValue        = function(self)
                    return DB.MainActionBar.Condition.HasTarget
                end,
                OnValueChange   = function(self, value)
                    DB.MainActionBar.Condition.HasTarget = value
                end
            },

            TargetCanAttack     = {
                GetValue        = function(self)
                    return DB.MainActionBar.Condition.TargetCanAttack
                end,
                OnValueChange   = function(self, value)
                    DB.MainActionBar.Condition.TargetCanAttack = value
                end
            },

            InCombat            = {
                GetValue        = function(self)
                    return DB.MainActionBar.Condition.InCombat
                end,
                OnValueChange   = function(self, value)
                    DB.MainActionBar.Condition.InCombat = value
                end
            },

            InInstance          = {
                GetValue        = function(self)
                    return DB.MainActionBar.Condition.InInstance
                end,
                OnValueChange   = function(self, value)
                    DB.MainActionBar.Condition.InInstance = value
                end
            }
        },
    },

    -- 微型菜单栏
    MicroButtonsActionBar       = {
        OpacityConditional      = {
            GetValue            = function(self)
                return DB.MicroButtonsActionBar.OpacityConditional, ACTIONBAR_MIN_OPACITY, ACTIONBAR_MAX_OPACITY, ACTIONBAR_OPACITY_STEP
            end,
            OnValueChange       = function(self, value)
                DB.MicroButtonsActionBar.OpacityConditional = value
            end
        },

        OpacityNormal           = {
            GetValue            = function(self)
                return DB.MicroButtonsActionBar.OpacityNormal, ACTIONBAR_MIN_OPACITY, ACTIONBAR_MAX_OPACITY, ACTIONBAR_OPACITY_STEP
            end,
            OnValueChange       = function(self, value)
                DB.MicroButtonsActionBar.OpacityNormal = value
            end
        },

        FadeAnimate             = {
            GetValue            = function(self)
                return DB.MicroButtonsActionBar.FadeAnimate
            end,
            OnValueChange       = function(self, value)
                DB.MicroButtonsActionBar.FadeAnimate = value
            end
        },

        FadeDuration            = {
            GetValue            = function(self)
                return DB.MicroButtonsActionBar.FadeDuration, ACTIONBAR_FADE_DURATION_MIN, ACTIONBAR_FADE_DURATION_MAX, ACTIONBAR_FADE_DURATION_STEP
            end,
            OnValueChange       = function(self, value)
                DB.MicroButtonsActionBar.FadeDuration = value
            end
        },

        Condition               = {
            HasTarget           = {
                GetValue        = function(self)
                    return DB.MicroButtonsActionBar.Condition.HasTarget
                end,
                OnValueChange   = function(self, value)
                    DB.MicroButtonsActionBar.Condition.HasTarget = value
                end
            },

            TargetCanAttack     = {
                GetValue        = function(self)
                    return DB.MicroButtonsActionBar.Condition.TargetCanAttack
                end,
                OnValueChange   = function(self, value)
                    DB.MicroButtonsActionBar.Condition.TargetCanAttack = value
                end
            },

            InCombat            = {
                GetValue        = function(self)
                    return DB.MicroButtonsActionBar.Condition.InCombat
                end,
                OnValueChange   = function(self, value)
                    DB.MicroButtonsActionBar.Condition.InCombat = value
                end
            },

            InInstance          = {
                GetValue        = function(self)
                    return DB.MicroButtonsActionBar.Condition.InInstance
                end,
                OnValueChange   = function(self, value)
                    DB.MicroButtonsActionBar.Condition.InInstance = value
                end
            }
        },
    },

    -- 右边动作条
    MultiBarRight               = {
        OpacityConditional      = {
            GetValue            = function(self)
                return DB.MultiBarRight.OpacityConditional, ACTIONBAR_MIN_OPACITY, ACTIONBAR_MAX_OPACITY, ACTIONBAR_OPACITY_STEP
            end,
            OnValueChange       = function(self, value)
                DB.MultiBarRight.OpacityConditional = value
            end
        },

        OpacityNormal           = {
            GetValue            = function(self)
                return DB.MultiBarRight.OpacityNormal, ACTIONBAR_MIN_OPACITY, ACTIONBAR_MAX_OPACITY, ACTIONBAR_OPACITY_STEP
            end,
            OnValueChange       = function(self, value)
                DB.MultiBarRight.OpacityNormal = value
            end
        },

        FadeAnimate             = {
            GetValue            = function(self)
                return DB.MultiBarRight.FadeAnimate
            end,
            OnValueChange       = function(self, value)
                DB.MultiBarRight.FadeAnimate = value
            end
        },

        FadeDuration            = {
            GetValue            = function(self)
                return DB.MultiBarRight.FadeDuration, ACTIONBAR_FADE_DURATION_MIN, ACTIONBAR_FADE_DURATION_MAX, ACTIONBAR_FADE_DURATION_STEP
            end,
            OnValueChange       = function(self, value)
                DB.MultiBarRight.FadeDuration = value
            end
        },

        Condition               = {
            HasTarget           = {
                GetValue        = function(self)
                    return DB.MultiBarRight.Condition.HasTarget
                end,
                OnValueChange   = function(self, value)
                    DB.MultiBarRight.Condition.HasTarget = value
                end
            },

            TargetCanAttack     = {
                GetValue        = function(self)
                    return DB.MultiBarRight.Condition.TargetCanAttack
                end,
                OnValueChange   = function(self, value)
                    DB.MultiBarRight.Condition.TargetCanAttack = value
                end
            },

            InCombat            = {
                GetValue        = function(self)
                    return DB.MultiBarRight.Condition.InCombat
                end,
                OnValueChange   = function(self, value)
                    DB.MultiBarRight.Condition.InCombat = value
                end
            },

            InInstance          = {
                GetValue        = function(self)
                    return DB.MultiBarRight.Condition.InInstance
                end,
                OnValueChange   = function(self, value)
                    DB.MultiBarRight.Condition.InInstance = value
                end
            }
        },
    },

    -- 右边动作条2
    MultiBarLeft                = {
        OpacityConditional      = {
            GetValue            = function(self)
                return DB.MultiBarLeft.OpacityConditional, ACTIONBAR_MIN_OPACITY, ACTIONBAR_MAX_OPACITY, ACTIONBAR_OPACITY_STEP
            end,
            OnValueChange       = function(self, value)
                DB.MultiBarLeft.OpacityConditional = value
            end
        },

        OpacityNormal           = {
            GetValue            = function(self)
                return DB.MultiBarLeft.OpacityNormal, ACTIONBAR_MIN_OPACITY, ACTIONBAR_MAX_OPACITY, ACTIONBAR_OPACITY_STEP
            end,
            OnValueChange       = function(self, value)
                DB.MultiBarLeft.OpacityNormal = value
            end
        },

        FadeAnimate             = {
            GetValue            = function(self)
                return DB.MultiBarLeft.FadeAnimate
            end,
            OnValueChange       = function(self, value)
                DB.MultiBarLeft.FadeAnimate = value
            end
        },

        FadeDuration            = {
            GetValue            = function(self)
                return DB.MultiBarLeft.FadeDuration, ACTIONBAR_FADE_DURATION_MIN, ACTIONBAR_FADE_DURATION_MAX, ACTIONBAR_FADE_DURATION_STEP
            end,
            OnValueChange       = function(self, value)
                DB.MultiBarLeft.FadeDuration = value
            end
        },

        Condition               = {
            HasTarget           = {
                GetValue        = function(self)
                    return DB.MultiBarLeft.Condition.HasTarget
                end,
                OnValueChange   = function(self, value)
                    DB.MultiBarLeft.Condition.HasTarget = value
                end
            },

            TargetCanAttack     = {
                GetValue        = function(self)
                    return DB.MultiBarLeft.Condition.TargetCanAttack
                end,
                OnValueChange   = function(self, value)
                    DB.MultiBarLeft.Condition.TargetCanAttack = value
                end
            },

            InCombat            = {
                GetValue        = function(self)
                    return DB.MultiBarLeft.Condition.InCombat
                end,
                OnValueChange   = function(self, value)
                    DB.MultiBarLeft.Condition.InCombat = value
                end
            },

            InInstance          = {
                GetValue        = function(self)
                    return DB.MultiBarLeft.Condition.InInstance
                end,
                OnValueChange   = function(self, value)
                    DB.MultiBarLeft.Condition.InInstance = value
                end
            }
        },
    }
}

function OnLoad(self)
    _Enabled = false
    SetDefaultToConfigDB(_Name, DefaultConfig)
    DB = _Config[_Parent._Name][_Name]
end

function Show()
    if not ActionBarVisibilityContainer then _Enabled = true return end
    ActionBarVisibilityContainer:Show()
end

function Hide()
    if not ActionBarVisibilityContainer then return end
    ActionBarVisibilityContainer:Hide()
end

function OnEnable(self)
    ActionBarVisibilityContainer = Frame("ActionBarVisibilityContainer", ConfigContainer)
    FontString("ActionBarVisibilityTitle", ActionBarVisibilityContainer)
    FontString("ActionBarVisibilityDescription", ActionBarVisibilityContainer)
    ActionBarVisibilityEnableButton = OptionsCheckButton("ActionBarVisibilityEnableButton", ActionBarVisibilityContainer)
    OptionsLine("Line1", ActionBarVisibilityContainer)
    OptionsDropDownMenu("ActionBarSelectDropDownMenu", ActionBarVisibilityEnableButton)
    OptionsLine("Line2", ActionBarVisibilityContainer)
    FontString("ActionBarVisibilityStyleTitle", ActionBarVisibilityContainer)
    ActionBarConditionalOpacitySlider = OptionsSlider("ActionBarConditionalOpacitySlider", ActionBarVisibilityEnableButton)
    ActionBarNormalOpacitySlider = OptionsSlider("ActionBarNormalOpacitySlider", ActionBarVisibilityEnableButton)
    ActionBarFadeAnimationButton = OptionsCheckButton("ActionBarFadeAnimationButton", ActionBarVisibilityEnableButton)
    ActionBarFadeDurationSlider = OptionsSlider("ActionBarFadeDurationSlider", ActionBarVisibilityEnableButton)
    OptionsLine("Line3", ActionBarVisibilityContainer)
    FontString("ActionBarVisibilityConditionalTitle", ActionBarVisibilityContainer)
    ConditionInCombatButton = OptionsCheckButton("ConditionInCombatButton", ActionBarVisibilityEnableButton)
    ConditionInInstanceButton = OptionsCheckButton("ConditionInInstanceButton", ActionBarVisibilityEnableButton)
    ConditionHasTargetButton = OptionsCheckButton("ConditionHasTargetButton", ActionBarVisibilityEnableButton)
    ConditionTargetCanAttackButton = OptionsCheckButton("ConditionTargetCanAttackButton", ConditionHasTargetButton)
    
    OnActionBarSelectedChanged()

    Style[ActionBarVisibilityContainer] = {
        location                                            = {
            Anchor("TOPLEFT", 15, -15),
            Anchor("BOTTOMRIGHT", -15, 15)
        },

        ActionBarVisibilityTitle                            = {
            location                                        = {
                Anchor("TOPLEFT")
            },
            text                                            = L["config_category_actionbar_visibility"],
            fontObject                                      = GameFontNormalLarge
        },

        ActionBarVisibilityDescription                      = {
            fontObject                                      = OptionsFontHighlightSmall,
            location                                        = {
                Anchor("TOPLEFT", 0, -5, "ActionBarVisibilityTitle", "BOTTOMLEFT"),
                Anchor("RIGHT")
            },
            justifyH                                        = "LEFT",
            text                                            = L["config_actionbar_visibility_description"]
        },

        Line1                                               = {
            location                                        = {
                Anchor("LEFT"),
                Anchor("RIGHT"),
                Anchor("TOP", 0, -10, "ActionBarVisibilityEnableButton", "BOTTOM")
            }
        },

        Line2                                               = {
            location                                        = {
                Anchor("LEFT"),
                Anchor("RIGHT"),
                Anchor("TOP", 0, -10, "ActionBarVisibilityEnableButton.ActionBarSelectDropDownMenu", "BOTTOM")
            }
        },

        ActionBarVisibilityStyleTitle                       = {
            location                                        = {
                Anchor("LEFT"),
                Anchor("TOP", 0, -10, "Line2", "BOTTOM")
            },
            text                                            = L["config_actionbar_visibility_style_title"]
        },

        Line3                                               = {
            location                                        = {
                Anchor("LEFT"),
                Anchor("RIGHT"),
                Anchor("TOP", 0, -30, "ActionBarVisibilityEnableButton.ActionBarConditionalOpacitySlider", "BOTTOM")
            }
        },

        ActionBarVisibilityConditionalTitle                 = {
            location                                        = {
                Anchor("LEFT"),
                Anchor("TOP", 0, -10, "Line3", "BOTTOM")
            },
            text                                            = L["config_actionbar_visibility_conditional_title"]
        },

        ActionBarVisibilityEnableButton                     = {
            configBehavior                                  = ConfigBehaviors,
            location                                        = {
                Anchor("TOPLEFT", -3, -5, "ActionBarVisibilityDescription", "BOTTOMLEFT")
            },

            Label                                           = {
                text                                        = L["module_enable"]
            },

            ActionBarSelectDropDownMenu                     = {
                location                                    = {
                    Anchor("TOPLEFT", -18, -30, "$parent.$parent.Line1", "BOTTOMLEFT")
                },
                configBehavior                              = ConfigBehaviors.ActionBar,
                dropDownMenuWidth                           = 160,
                displayTextJustifyH                         = "RIGHT",
                dropDownInfos                               = {
                    {
                        text                                = L["config_actionbar_mainbar"],
                        value                               = ACTIONBAR_MAIN,
                        tooltipText                         = L["config_actionbar_visibility_mainbar_tooltip"]
                    },
                    {
                        text                                = L["config_actionbar_microbuttons_bagsbar"],
                        value                               = ACTIONBAR_MICROBUTTONS
                    },
                    {
                        text                                = L["config_actionbar_multibar_right"],
                        value                               = ACTIONBAR_MULTIBAR_RIGHT
                    },
                    {
                        text                                = L["config_actionbar_multibar_left"],
                        value                               = ACTIONBAR_MULTIBAR_LEFT
                    }
                },

                Label                                       = {
                    fontObject                              = GameFontNormal,
                    text                                    = L["config_actionbar_visibility_actionbar_dropdown_label"],
                    location                                = {
                        Anchor("BOTTOMLEFT", 18, 5, nil, "TOPLEFT")
                    }
                }
            },

            ActionBarFadeAnimationButton                    = {
                location                                    = {
                    Anchor("LEFT"),
                    Anchor("TOP", 0, -10, "$parent.$parent.ActionBarVisibilityStyleTitle", "BOTTOM")
                },
                tooltipText                                 = L["config_actionbar_visibility_fade_animation_tooltip"],

                Label                                       = {
                    text                                    = L["config_actionbar_visibility_fade_animation"]
                }
            },

            ActionBarFadeDurationSlider                     = {
                location                                    = {
                    Anchor("LEFT", 0, 0, "$parent.$parent", "CENTER"),
                    Anchor("TOP", 0, -10, "$parent.$parent.ActionBarVisibilityStyleTitle", "BOTTOM")
                },
                
                Text                                        = {
                    size                                    = Size(45,15),
                    maxLetters                              = 4,
                    multiLine                               = false
                },

                Label                                       = {
                    text                                    = L["config_actionbar_visibility_fade_duration"]
                }
            },

            ActionBarConditionalOpacitySlider               = {
                location                                    = {
                    Anchor("LEFT", 5, 0),
                    Anchor("TOP", 0, -30, "ActionBarFadeAnimationButton", "BOTTOM")
                },

                Text                                        = {
                    size                                    = Size(35, 15),
                    maxLetters                              = 3,
                    numeric                                 = true,
                    multiLine                               = false
                },

                Label                                       = {
                    text                                    = L["config_actionbar_visibility_conditional_opacity"]
                }
            },

            ActionBarNormalOpacitySlider                    = {
                location                                    = {
                    Anchor("LEFT", 0, 0, "$parent.$parent", "CENTER"),
                    Anchor("TOP", 0, -30, "ActionBarFadeAnimationButton", "BOTTOM")
                },

                Text                                        = {
                    size                                    = Size(35, 15),
                    maxLetters                              = 3,
                    numeric                                 = true,
                    multiLine                               = false
                },

                Label                                       = {
                    text                                    = L["config_actionbar_visibility_normal_opacity"]
                }
            },

            ConditionInCombatButton                         = {
                location                                    = {
                    Anchor("TOPLEFT", -3, -5, "$parent.$parent.ActionBarVisibilityConditionalTitle", "BOTTOMLEFT"),
                },
                
                Label                                       = {
                    text                                    = L["config_actionbar_visibility_condiation_incombat"]
                }
            },

            ConditionInInstanceButton                       = {
                location                                    = {
                    Anchor("TOPLEFT", 0, -10, "ConditionInCombatButton", "BOTTOMLEFT"),
                },
                
                Label                                       = {
                    text                                    = L["config_actionbar_visibility_condiation_ininstance"]
                }
            },

            ConditionHasTargetButton                        = {
                location                                    = {
                    Anchor("TOPLEFT", 0, -10, "ConditionInInstanceButton", "BOTTOMLEFT"),
                },
                
                Label                                       = {
                    text                                    = L["config_actionbar_visibility_condiation_hastarget"]
                },

                ConditionTargetCanAttackButton              = {
                    location                                = {
                        Anchor("TOPLEFT", 15, -3, nil, "BOTTOMLEFT"),
                    },
                    
                    Label                                   = {
                        text                                = L["config_actionbar_visibility_condiation_target_canattack"]
                    }
                }
            }
        }
    }
end

function OnActionBarSelectedChanged()
    local behavior
    if SelectedActionBar == ACTIONBAR_MAIN then
        behavior = ConfigBehaviors.MainActionBar
    elseif SelectedActionBar == ACTIONBAR_MICROBUTTONS then
        behavior = ConfigBehaviors.MicroButtonsActionBar
    elseif SelectedActionBar == ACTIONBAR_MULTIBAR_RIGHT then
        behavior = ConfigBehaviors.MultiBarRight
    elseif SelectedActionBar == ACTIONBAR_MULTIBAR_LEFT then
        behavior = ConfigBehaviors.MultiBarLeft
    end
    if not behavior then return end
    ActionBarFadeAnimationButton:SetConfigBehavior(behavior.FadeAnimate)
    ActionBarFadeDurationSlider:SetConfigBehavior(behavior.FadeDuration)
    ActionBarConditionalOpacitySlider:SetConfigBehavior(behavior.OpacityConditional)
    ActionBarNormalOpacitySlider:SetConfigBehavior(behavior.OpacityNormal)
    ConditionInCombatButton:SetConfigBehavior(behavior.Condition.InCombat)
    ConditionInInstanceButton:SetConfigBehavior(behavior.Condition.InInstance)
    ConditionHasTargetButton:SetConfigBehavior(behavior.Condition.HasTarget)
    ConditionTargetCanAttackButton:SetConfigBehavior(behavior.Condition.TargetCanAttack)
end