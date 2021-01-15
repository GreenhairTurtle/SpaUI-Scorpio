Scorpio "SpaUI.Config.Features.AutoSell_Repair" ""

ConfigBehaivors = {
    AutoRepair                      = {
        Default                     = {

        },
        GetValue                    = function(self)
            return 1,"测试"
        end,
        OnValueChange               = function(self, arg1, arg2, checked)
            self.TempValue = arg1
            self.TempText  = arg2
        end,
    }
}

function OnLoad(self)
    _Enabled = false
end

function Show()
    if not AutoSell_RepairContainer then _Enabled = true return end
    AutoSell_RepairContainer:Show()
end

function Hide()
    if not AutoSell_RepairContainer then return end
    AutoSell_RepairContainer:Hide()
end

function OnEnable(self)
    AutoSell_RepairContainer = Frame("AutoSell_RepairContainer", ConfigContainer)
    FontString("AutoRepairTitle", AutoSell_RepairContainer)
    OptionsDropDownMenu("AutoRepairDropDownMenu", AutoSell_RepairContainer)

    Style[AutoSell_RepairContainer] = {
        location                        = {
            Anchor("TOPLEFT", 15, -15),
            Anchor("BOTTOMRIGHT", -15, 15)
        },

        AutoRepairTitle                 = {
            location                    = {
                Anchor("TOPLEFT")
            },
            text                        = L["config_features_auto_repair"],
            fontObject                  = GameFontNormalLarge
        },

        AutoRepairDropDownMenu          = {
            location                    = {
                Anchor("TOPLEFT", 0, -5, "AutoRepairTitle", "BOTTOMLEFT")
            },
            configBehavior              = ConfigBehaivors.AutoRepair,
            dropDownInfos               = {
                {
                    text                = "1111",
                    value               = 1
                },
                {
                    text                = "2222",
                    value               = 2
                }
            }
        }
    }
end