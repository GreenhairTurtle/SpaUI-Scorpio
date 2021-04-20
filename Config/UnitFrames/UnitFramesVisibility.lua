Scorpio "SpaUI.Config.UnitFrames.Visibility" ""

UNITFRAMES_MIN_OPACITY = 0
UNITFRAMES_MAX_OPACITY = 100
UNITFRAMES_OPACITY_STEP = 1
UNITFRAMES_FADE_DURATION_MIN = 0.5
UNITFRAMES_FADE_DURATION_MAX = 5
UNITFRAMES_FADE_DURATION_STEP = 0.1
SelectedUnitFrame = UNITFRAME_PLAYER

DefaultConfig                   = {
    Enable                      = false,

    -- 玩家框体
    PlayerFrame                 = {
        OpacityConditional      = 100,
        OpacityNormal           = 30,
        FadeDuration            = 1,
        FadeAnimate             = true,

        Condition               = {
            InCombat            = true,
            InInstance          = true,
            HasTarget           = true,
            TargetCanAttack     = true,
        }
    },

    -- 目标框体
    TargetFrame                 = {
        OpacityConditional      = 100,
        OpacityNormal           = 30,
        FadeDuration            = 1,
        FadeAnimate             = true,

        Condition               = {
            InCombat            = true,
            InInstance          = true,
            HasTarget           = true,
            TargetCanAttack     = true,
        }
    },

    -- 焦点框体
    FocusFrame                  = {
        OpacityConditional      = 100,
        OpacityNormal           = 30,
        FadeDuration            = 1,
        FadeAnimate             = true,

        Condition               = {
            InCombat            = true,
            InInstance          = true,
            HasTarget           = false,
            TargetCanAttack     = true,
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

    UnitFrames                  = {
        OnValueChange           = function(self, arg1, arg2, checked)
            SelectedUnitFrame = arg1
            OnUnitFrameSelectedChanged()
            return true
        end,
        GetValue                = function(self)
            return SelectedUnitFrame, UNITFRAMES[SelectedUnitFrame]
        end
    },

    -- 玩家框体
    PlayerFrame                 = {
        OpacityConditional      = {
            GetValue            = function(self)
                return DB.PlayerFrame.OpacityConditional, UNITFRAMES_MIN_OPACITY, UNITFRAMES_MAX_OPACITY, UNITFRAMES_OPACITY_STEP
            end,
            OnValueChange       = function(self, value)
                DB.PlayerFrame.OpacityConditional = value
            end
        },

        OpacityNormal           = {
            GetValue            = function(self)
                return DB.PlayerFrame.OpacityNormal, UNITFRAMES_MIN_OPACITY, UNITFRAMES_MAX_OPACITY, UNITFRAMES_OPACITY_STEP
            end,
            OnValueChange       = function(self, value)
                DB.PlayerFrame.OpacityNormal = value
            end
        },

        FadeAnimate             = {
            GetValue            = function(self)
                return DB.PlayerFrame.FadeAnimate
            end,
            OnValueChange       = function(self, value)
                DB.PlayerFrame.FadeAnimate = value
            end
        },

        FadeDuration            = {
            GetValue            = function(self)
                return DB.PlayerFrame.FadeDuration, UNITFRAMES_FADE_DURATION_MIN, UNITFRAMES_FADE_DURATION_MAX, UNITFRAMES_FADE_DURATION_STEP
            end,
            OnValueChange       = function(self, value)
                DB.PlayerFrame.FadeDuration = value
            end
        },

        Condition               = {

            InCombat            = {
                GetValue        = function(self)
                    return DB.PlayerFrame.Condition.InCombat
                end,
                OnValueChange   = function(self, value)
                    DB.PlayerFrame.Condition.InCombat = value
                end
            },

            InInstance          = {
                GetValue        = function(self)
                    return DB.PlayerFrame.Condition.InInstance
                end,
                OnValueChange   = function(self, value)
                    DB.PlayerFrame.Condition.InInstance = value
                end
            },
            
            HasTarget           = {
                GetValue        = function(self)
                    return DB.PlayerFrame.Condition.HasTarget
                end,
                OnValueChange   = function(self, value)
                    DB.PlayerFrame.Condition.HasTarget = value
                end
            },

            TargetCanAttack     = {
                GetValue        = function(self)
                    return DB.PlayerFrame.Condition.TargetCanAttack
                end,
                OnValueChange   = function(self, value)
                    DB.PlayerFrame.Condition.TargetCanAttack = value
                end
            },
        },
    },

    -- 目标框体
    TargetFrame                 = {
        OpacityConditional      = {
            GetValue            = function(self)
                return DB.TargetFrame.OpacityConditional, UNITFRAMES_MIN_OPACITY, UNITFRAMES_MAX_OPACITY, UNITFRAMES_OPACITY_STEP
            end,
            OnValueChange       = function(self, value)
                DB.TargetFrame.OpacityConditional = value
            end
        },

        OpacityNormal           = {
            GetValue            = function(self)
                return DB.TargetFrame.OpacityNormal, UNITFRAMES_MIN_OPACITY, UNITFRAMES_MAX_OPACITY, UNITFRAMES_OPACITY_STEP
            end,
            OnValueChange       = function(self, value)
                DB.TargetFrame.OpacityNormal = value
            end
        },

        FadeAnimate             = {
            GetValue            = function(self)
                return DB.TargetFrame.FadeAnimate
            end,
            OnValueChange       = function(self, value)
                DB.TargetFrame.FadeAnimate = value
            end
        },

        FadeDuration            = {
            GetValue            = function(self)
                return DB.TargetFrame.FadeDuration, UNITFRAMES_FADE_DURATION_MIN, UNITFRAMES_FADE_DURATION_MAX, UNITFRAMES_FADE_DURATION_STEP
            end,
            OnValueChange       = function(self, value)
                DB.TargetFrame.FadeDuration = value
            end
        },

        Condition               = {

            InCombat            = {
                GetValue        = function(self)
                    return DB.TargetFrame.Condition.InCombat
                end,
                OnValueChange   = function(self, value)
                    DB.TargetFrame.Condition.InCombat = value
                end
            },

            InInstance          = {
                GetValue        = function(self)
                    return DB.TargetFrame.Condition.InInstance
                end,
                OnValueChange   = function(self, value)
                    DB.TargetFrame.Condition.InInstance = value
                end
            },
 
            HasTarget           = {
                GetValue        = function(self)
                    return DB.TargetFrame.Condition.HasTarget
                end,
                OnValueChange   = function(self, value)
                    DB.TargetFrame.Condition.HasTarget = value
                end
            },

            TargetCanAttack     = {
                GetValue        = function(self)
                    return DB.TargetFrame.Condition.TargetCanAttack
                end,
                OnValueChange   = function(self, value)
                    DB.TargetFrame.Condition.TargetCanAttack = value
                end
            },
        },
    },

    -- 焦点框体
    FocusFrame                  = {
        OpacityConditional      = {
            GetValue            = function(self)
                return DB.FocusFrame.OpacityConditional, UNITFRAMES_MIN_OPACITY, UNITFRAMES_MAX_OPACITY, UNITFRAMES_OPACITY_STEP
            end,
            OnValueChange       = function(self, value)
                DB.FocusFrame.OpacityConditional = value
            end
        },

        OpacityNormal           = {
            GetValue            = function(self)
                return DB.FocusFrame.OpacityNormal, UNITFRAMES_MIN_OPACITY, UNITFRAMES_MAX_OPACITY, UNITFRAMES_OPACITY_STEP
            end,
            OnValueChange       = function(self, value)
                DB.FocusFrame.OpacityNormal = value
            end
        },

        FadeAnimate             = {
            GetValue            = function(self)
                return DB.FocusFrame.FadeAnimate
            end,
            OnValueChange       = function(self, value)
                DB.FocusFrame.FadeAnimate = value
            end
        },

        FadeDuration            = {
            GetValue            = function(self)
                return DB.FocusFrame.FadeDuration, UNITFRAMES_FADE_DURATION_MIN, UNITFRAMES_FADE_DURATION_MAX, UNITFRAMES_FADE_DURATION_STEP
            end,
            OnValueChange       = function(self, value)
                DB.FocusFrame.FadeDuration = value
            end
        },

        Condition               = {

            InCombat            = {
                GetValue        = function(self)
                    return DB.FocusFrame.Condition.InCombat
                end,
                OnValueChange   = function(self, value)
                    DB.FocusFrame.Condition.InCombat = value
                end
            },

            InInstance          = {
                GetValue        = function(self)
                    return DB.FocusFrame.Condition.InInstance
                end,
                OnValueChange   = function(self, value)
                    DB.FocusFrame.Condition.InInstance = value
                end
            },

            HasTarget           = {
                GetValue        = function(self)
                    return DB.FocusFrame.Condition.HasTarget
                end,
                OnValueChange   = function(self, value)
                    DB.FocusFrame.Condition.HasTarget = value
                end
            },

            TargetCanAttack     = {
                GetValue        = function(self)
                    return DB.FocusFrame.Condition.TargetCanAttack
                end,
                OnValueChange   = function(self, value)
                    DB.FocusFrame.Condition.TargetCanAttack = value
                end
            },
        },
    }
}

function OnLoad(self)
    _Enabled = false
    SetDefaultToConfigDB(_Name, DefaultConfig)
    DB = _Config[_Parent._Name][_Name]
end

function Show()
    if not UnitFramesVisibilityContainer then _Enabled = true return end
    UnitFramesVisibilityContainer:Show()
end

function Hide()
    if not UnitFramesVisibilityContainer then return end
    UnitFramesVisibilityContainer:Hide()
end

function OnEnable(self)
    UnitFramesVisibilityContainer = Frame("UnitFramesVisibilityContainer", ConfigContainer)
    FontString("UnitFramesVisibilityTitle", UnitFramesVisibilityContainer)
    FontString("UnitFramesVisibilityDescription", UnitFramesVisibilityContainer)
    UnitFramesVisibilityEnableButton = OptionsCheckButton("UnitFramesVisibilityEnableButton", UnitFramesVisibilityContainer)
    OptionsLine("Line1", UnitFramesVisibilityContainer)
    OptionsDropDownMenu("UnitFramesSelectDropDownMenu", UnitFramesVisibilityEnableButton)
    OptionsLine("Line2", UnitFramesVisibilityContainer)
    FontString("UnitFramesVisibilityStyleTitle", UnitFramesVisibilityContainer)
    UnitFramesConditionalOpacitySlider = OptionsSlider("UnitFramesConditionalOpacitySlider", UnitFramesVisibilityEnableButton)
    UnitFramesNormalOpacitySlider = OptionsSlider("UnitFramesNormalOpacitySlider", UnitFramesVisibilityEnableButton)
    UnitFramesFadeAnimationButton = OptionsCheckButton("UnitFramesFadeAnimationButton", UnitFramesVisibilityEnableButton)
    UnitFramesFadeDurationSlider = OptionsSlider("UnitFramesFadeDurationSlider", UnitFramesVisibilityEnableButton)
    OptionsLine("Line3", UnitFramesVisibilityContainer)
    FontString("UnitFramesVisibilityConditionalTitle", UnitFramesVisibilityContainer)
    ConditionInCombatButton = OptionsCheckButton("ConditionInCombatButton", UnitFramesVisibilityEnableButton)
    ConditionInInstanceButton = OptionsCheckButton("ConditionInInstanceButton", UnitFramesVisibilityEnableButton)
    ConditionHasTargetButton = OptionsCheckButton("ConditionHasTargetButton", UnitFramesVisibilityEnableButton)
    ConditionTargetCanAttackButton = OptionsCheckButton("ConditionTargetCanAttackButton", ConditionHasTargetButton)
    
    OnUnitFrameSelectedChanged()

    Style[UnitFramesVisibilityContainer]                                    = {
        location                                                            = {
            Anchor("TOPLEFT", 15, -15),
            Anchor("BOTTOMRIGHT", -15, 15),
        },

        UnitFramesVisibilityTitle                                           = {
            location                                                        = {
                Anchor("TOPLEFT")
            },
            text                                                            = L["config_category_unitframes_visibility"],
            fontObject                                                      = GameFontNormalLarge
        },

        UnitFramesVisibilityDescription                                     = {
            fontObject                                                      = OptionsFontHighlightSmall,
            location                                                        = {
                Anchor("TOPLEFT", 0, -5, "UnitFramesVisibilityTitle", "BOTTOMLEFT"),
                Anchor("RIGHT")
            },
            justifyH                                                        = "LEFT",
            text                                                            = L["config_unitframes_visibility_description"]
        },

        Line1                                                               = {
            location                                                        = {
                Anchor("LEFT"),
                Anchor("RIGHT"),
                Anchor("TOP", 0, -10, "UnitFramesVisibilityEnableButton", "BOTTOM")
            }
        },

        Line2                                                               = {
            location                                                        = {
                Anchor("LEFT"),
                Anchor("RIGHT"),
                Anchor("TOP", 0, -10, "UnitFramesVisibilityEnableButton.UnitFramesSelectDropDownMenu", "BOTTOM")
            }
        },

        UnitFramesVisibilityStyleTitle                                      = {
            location                                                        = {
                Anchor("LEFT"),
                Anchor("TOP", 0, -10, "Line2", "BOTTOM")
            },
            text                                                            = L["config_unitframes_visibility_style_title"]
        },

        Line3                                                               = {
            location                                                        = {
                Anchor("LEFT"),
                Anchor("RIGHT"),
                Anchor("TOP", 0, -30, "UnitFramesVisibilityEnableButton.UnitFramesConditionalOpacitySlider", "BOTTOM")
            }
        },

        UnitFramesVisibilityConditionalTitle                                = {
            location                                                        = {
                Anchor("LEFT"),
                Anchor("TOP", 0, -10, "Line3", "BOTTOM")
            },
            text                                                            = L["config_unitframes_visibility_conditional_title"]
        },

        UnitFramesVisibilityEnableButton                                    = {
            configBehavior                                                  = ConfigBehaviors,
            location                                                        = {
                Anchor("TOPLEFT", -3, -5, "UnitFramesVisibilityDescription", "BOTTOMLEFT")
            },

            Label                                                           = {
                text                                                        = L["module_enable"]
            },

            UnitFramesSelectDropDownMenu                                    = {
                location                                                    = {
                    Anchor("TOPLEFT", -18, -30, "$parent.$parent.Line1", "BOTTOMLEFT")
                },
                configBehavior                                              = ConfigBehaviors.UnitFrames,
                dropDownMenuWidth                                           = 160,
                displayTextJustifyH                                         = "RIGHT",

                Label                                                       = {
                    fontObject                                              = GameFontNormal,
                    text                                                    = L["config_unitframes_visibility_unitframes_dropdown_label"],
                    location                                                = {
                        Anchor("BOTTOMLEFT", 18, 5, nil, "TOPLEFT")
                    }
                },
                dropDownInfos                                               = {
                    {
                        text                                                = L["config_unitframes_player"],
                        value                                               = UNITFRAME_PLAYER
                    },
                    {
                        text                                                = L["config_unitframes_target"],
                        value                                               = UNITFRAME_TARGET
                    },
                    {
                        text                                                = L["config_unitframes_focus"],
                        value                                               = UNITFRAME_FOCUS
                    }
                },
            },

            UnitFramesFadeAnimationButton                                   = {
                location                                                    = {
                    Anchor("LEFT"),
                    Anchor("TOP", 0, -10, "$parent.$parent.UnitFramesVisibilityStyleTitle", "BOTTOM")
                },
                tooltipText                                                 = L["config_unitframes_visibility_fade_animation_tooltip"],

                Label                                                       = {
                    text                                                    = L["config_unitframes_visibility_fade_animation"]
                }
            },

            UnitFramesFadeDurationSlider                                    = {
                location                                                    = {
                    Anchor("LEFT", 0, 0, "$parent.$parent", "CENTER"),
                    Anchor("TOP", 0, -10, "$parent.$parent.UnitFramesVisibilityStyleTitle", "BOTTOM")
                },
                
                Text                                                        = {
                    size                                                    = Size(45,15),
                    maxLetters                                              = 4,
                    multiLine                                               = false
                },    

                Label                                                       = {
                    text                                                    = L["config_unitframes_visibility_fade_duration"]
                }
            },

            UnitFramesConditionalOpacitySlider                              = {
                location                                                    = {
                    Anchor("LEFT", 5, 0),
                    Anchor("TOP", 0, -30, "UnitFramesFadeAnimationButton", "BOTTOM")
                },

                Text                                                        = {
                    size                                                    = Size(35, 15),
                    maxLetters                                              = 3,
                    numeric                                                 = true,
                    multiLine                                               = false
                },

                Label                                                       = {
                    text                                                    = L["config_unitframes_visibility_conditional_opacity"]
                }
            },

            UnitFramesNormalOpacitySlider                                   = {
                location                                                    = {
                    Anchor("LEFT", 0, 0, "$parent.$parent", "CENTER"),
                    Anchor("TOP", 0, -30, "UnitFramesFadeAnimationButton", "BOTTOM")
                },

                Text                                                        = {
                    size                                                    = Size(35, 15),
                    maxLetters                                              = 3,
                    numeric                                                 = true,
                    multiLine                                               = false
                },              

                Label                                                       = {
                    text                                                    = L["config_unitframes_visibility_normal_opacity"]
                }
            },

            ConditionInCombatButton                                         = {
                location                                                    = {
                    Anchor("TOPLEFT", -3, -5, "$parent.$parent.UnitFramesVisibilityConditionalTitle", "BOTTOMLEFT"),
                },
                
                Label                                                       = {
                    text                                                    = L["config_unitframes_visibility_condiation_incombat"]
                } 
            },

            ConditionInInstanceButton                                       = {
                location                                                    = {
                    Anchor("TOPLEFT", 0, -10, "ConditionInCombatButton", "BOTTOMLEFT"),
                },
                
                Label                                                       = {
                    text                                                    = L["config_unitframes_visibility_condiation_ininstance"]
                }
            },

            ConditionHasTargetButton                                        = {
                location                                                    = {
                    Anchor("TOPLEFT", 0, -10, "ConditionInInstanceButton", "BOTTOMLEFT"),
                },

                Label                                                       = {
                    text                                                    = L["config_unitframes_visibility_condiation_hastarget"]
                },

                ConditionTargetCanAttackButton                              = {
                    location                                                = {
                        Anchor("TOPLEFT", 15, -3, nil, "BOTTOMLEFT"),
                    },
                    Label                                                   = {
                        text                                                = L["config_unitframes_visibility_condiation_target_canattack"]
                    }
                }
            }
        }
    }
end

function OnUnitFrameSelectedChanged()
    local behavior
    if SelectedUnitFrame == UNITFRAME_PLAYER then
        behavior = ConfigBehaviors.PlayerFrame
    elseif SelectedUnitFrame == UNITFRAME_PET then
        behavior = ConfigBehaviors.PetFrame
    elseif SelectedUnitFrame == UNITFRAME_TARGET then
        behavior = ConfigBehaviors.TargetFrame
    elseif SelectedUnitFrame == UNITFRAME_FOCUS then
        behavior = ConfigBehaviors.FocusFrame
    end
    if not behavior then return end
    UnitFramesFadeAnimationButton:SetConfigBehavior(behavior.FadeAnimate)
    UnitFramesFadeDurationSlider:SetConfigBehavior(behavior.FadeDuration)
    UnitFramesConditionalOpacitySlider:SetConfigBehavior(behavior.OpacityConditional)
    UnitFramesNormalOpacitySlider:SetConfigBehavior(behavior.OpacityNormal)
    ConditionInCombatButton:SetConfigBehavior(behavior.Condition.InCombat)
    ConditionInInstanceButton:SetConfigBehavior(behavior.Condition.InInstance)
    ConditionHasTargetButton:SetConfigBehavior(behavior.Condition.HasTarget)
    ConditionTargetCanAttackButton:SetConfigBehavior(behavior.Condition.TargetCanAttack)
end