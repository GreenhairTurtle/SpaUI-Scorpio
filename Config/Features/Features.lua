Scorpio "SpaUI.Config.Features" ""

namespace "SpaUI.Widget.Config.Features"

DefaultConfig = {
    EasyDelete                              = {
        Enable                              = true
    }
}

ConfigBehaviors = {
    EasyDelete                              = {
        Default                             = {
            Enable                          = true
        },
        NeedReload                          = function(self)
            return self.TempValue ~= nil and self.TempValue ~= DB.EasyDelete.Enable
        end,
        OnValueChange                       = function(self, value)
            self.TempValue = value
        end,
        SaveConfig                          = function(self)
            if self.TempValue ~= nil then
                DB.EasyDelete.Enable  = self.TempValue
            end
        end,
        GetValue                            = function(self)
            return DB.EasyDelete.Enable
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
    if not FeaturesContainer then
        _Enabled = true
    end
    if childModule then
        _Modules[childModule].Show()
        FeaturesContainer:Hide()
    else
        FeaturesContainer:Show()
    end
end

function Hide(childModule)
    if childModule then
        _Modules[childModule].Hide()
    else
        if not FeaturesContainer then return end
        FeaturesContainer:Hide()
    end
end

function OnEnable(self)
    FeaturesContainer = Frame("FeaturesContainer", ConfigContainer)
    FeaturesTitle = FontString("FeaturesTitle", FeaturesContainer)
    OptionsCheckButton("EasyDeleteEnableButton", FeaturesContainer)

    Style[FeaturesContainer] = {
        location                        = {
            Anchor("TOPLEFT", 15, -15),
            Anchor("BOTTOMRIGHT", -15, 15)
        },

        FeaturesTitle                   = {
            location                    = {
                Anchor("TOPLEFT")
            },
            text                        = L["config_category_features_title"],
            fontObject                  = GameFontNormalLarge
        },

        EasyDeleteEnableButton          = {
            configBehavior              = ConfigBehaviors.EasyDelete,
            tooltipText                 = L["config_category_features_easy_delete_tooltip"],
            location                    = {
                Anchor("TOPLEFT", -3, -5, "FeaturesTitle", "BOTTOMLEFT")
            },
            Label                       = {
                text                    = L["config_category_features_esay_delete"]
            }
        }
    }
end