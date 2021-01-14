Scorpio "SpaUI.Config.Features.AutoSell_Repair" ""

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
        }
    }
end