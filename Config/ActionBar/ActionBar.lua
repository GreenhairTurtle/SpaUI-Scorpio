Scorpio "SpaUI.Config.ActionBar" ""

-- 主动作条
ACTIONBAR_MAIN = 1
-- 微型菜单和背包栏
ACTIONBAR_MICROBUTTONS = 2
-- 右边动作条
ACTIONBAR_MULTIBAR_RIGHT = 3
-- 右边动作条2
ACTIONBAR_MULTIBAR_LEFT = 4

ACTIONBARS                                  = {
    [ACTIONBAR_MAIN]                        = L["config_actionbar_mainbar"],
    [ACTIONBAR_MICROBUTTONS]                = L["config_actionbar_microbuttons_bagsbar"],
    [ACTIONBAR_MULTIBAR_RIGHT]              = L["config_actionbar_multibar_right"],
    [ACTIONBAR_MULTIBAR_LEFT]               = L["config_actionbar_multibar_left"]
}

DefaultConfig                               = {
    OutOfRangeColor                         = {
        Enable                              = true
    }
}

ConfigBehaviors                             = {
    OutOfRangeColor                         = {
        Default                             = {
            Enable                          = true
        },
        NeedReload                          = function(self)
            return self.TempValue ~= nil and self.TempValue ~= DB.OutOfRangeColor.Enable
        end,
        OnValueChange                       = function(self, value)
            self.TempValue = value
        end,
        SaveConfig                          = function(self)
            if self.TempValue ~= nil then
                DB.OutOfRangeColor.Enable  = self.TempValue
            end
        end,
        GetValue                            = function(self)
            return DB.OutOfRangeColor.Enable
        end,
        Restore                             = function(self)
            self.TempValue = nil
        end,
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
    if not ActionBarContainer then
        _Enabled = true
    end
    if childModule then
        _Modules[childModule].Show()
        ActionBarContainer:Hide()
    else
        ActionBarContainer:Show()
    end
end

function Hide(childModule)
    if childModule then
        _Modules[childModule].Hide()
    else
        if not ActionBarContainer then return end
        ActionBarContainer:Hide()
    end
end

function OnEnable(self)
    ActionBarContainer = Frame("ActionBarContainer", ConfigContainer)
    FontString("ActionBarTitle", ActionBarContainer)
    OptionsCheckButton("OutOfRangeColorEnableButton", ActionBarContainer)

    Style[ActionBarContainer]                       = {
        location                                    = {
            Anchor("TOPLEFT", 15, -15),
            Anchor("BOTTOMRIGHT", -15, 15)
        },

        ActionBarTitle                              = {
            location                                = {
                Anchor("TOPLEFT")
            },

            text                                    = L["config_actionbar_title"],
            fontObject                              = GameFontNormalLarge
        },

        OutOfRangeColorEnableButton                 = {
            configBehavior                          = ConfigBehaviors.OutOfRangeColor,
            location                                = {
                Anchor("TOPLEFT", -3, -5, "ActionBarTitle", "BOTTOMLEFT")
            },

            Label                                   = {
                text                                = L["config_actionbar_out_of_range_color"]
            }
        }
    }
end