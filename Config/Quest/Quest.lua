Scorpio "SpaUI.Config.Quest" ""

DefaultConfig                               = {
    ObjectiveTrackerEnhanced                = {
        Enable                              = true
    }
}

ConfigBehaviors                             = {
    ObjectiveTrackerEnhanced                = {
        NeedReload                          = function(self)
            return self.TempValue ~= nil and self.TempValue ~= DB.ObjectiveTrackerEnhanced.Enable
        end,
        OnValueChange                       = function(self, value)
            self.TempValue = value
        end,
        SaveConfig                          = function(self)
            if self.TempValue ~= nil then
                DB.ObjectiveTrackerEnhanced.Enable  = self.TempValue
            end
        end,
        GetValue                            = function(self)
            return DB.ObjectiveTrackerEnhanced.Enable
        end,
        Restore                             = function(self)
            self.TempValue = nil
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
    if not QuestContainer then
        _Enabled = true
    end
    if childModule then
        _Modules[childModule].Show()
        QuestContainer:Hide()
    else
        QuestContainer:Show()
    end
end

function Hide(childModule)
    if childModule then
        _Modules[childModule].Hide()
    else
        if QuestContainer then
            QuestContainer:Hide()
        end
    end
end

function OnEnable(self)
    QuestContainer = Frame("QuestContainer", ConfigContainer)
    FontString("QuestTitle", QuestContainer)
    OptionsCheckButton("ObjectiveTrackerEnhancedEnableButton", QuestContainer)

    Style[QuestContainer] = {
        location                                                = {
            Anchor("TOPLEFT", 15, -15),
            Anchor("BOTTOMRIGHT", -15, 15)
        },

        QuestTitle                                              = {
            location                                            = {
                Anchor("TOPLEFT")
            },
            text                                                = L["config_quest_title"],
            fontObject                                          = GameFontNormalLarge
        },

        ObjectiveTrackerEnhancedEnableButton                    = {
            configBehavior                                      = ConfigBehaviors.ObjectiveTrackerEnhanced,
            location                                            = {
                Anchor("TOPLEFT", -3, -5, "QuestTitle", "BOTTOMLEFT")
            },

            Label                                               = {
                text                                            = L["config_quest_objective_enhanced"]
            }
        }
    }
end