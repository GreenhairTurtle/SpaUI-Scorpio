Scorpio "SpaUI.Config.Features.AutoSell_Repair" ""

class "AutoRepairConfig" (function(_ENV)

    __Arguments__{Integer, NEString, NEString}
    function __new(_, strategy, description, detail)
        return { Strategy = strategy, Description = description, Detail = detail}
    end
end)

__Sealed__() __Final__()
class "AutoRepairConfig" (function(_ENV)
    
    __Static__()
    property "GUILD" { set = false, default = AutoRepairConfig(1, L["config_features_auto_repair_strategy_guild"], L["config_features_auto_repair_strategy_guild_tooltip"]) }
    
    __Static__()
    property "AUTO" { set = false, default = AutoRepairConfig(2, L["config_features_auto_repair_strategy_auto"], L["config_features_auto_repair_strategy_auto_tooltip"]) }
    
    __Static__()
    property "NONE" { set = false, default = AutoRepairConfig(3, L["config_features_auto_repair_strategy_none"], L["config_features_auto_repair_strategy_none_tooltip"]) }

    __Arguments__{Integer}
    __Static__()
    function FromStrategy(strategy)
        if strategy == 1 then
            return AutoRepairConfig.GUILD
        elseif strategy == 2 then
            return AutoRepairConfig.AUTO
        else
            return AutoRepairConfig.NONE
        end
    end
end)

DefaultCharConfig = {
    AutoRepair                      = {
        Strategy                    = AutoRepairConfig.GUILD.Strategy
    },

    AutoSell                        = {
        Enable                      = true
    }
}

ConfigBehaviors = {
    AutoRepair                      = {
        GetValue                    = function(self)
            local config = AutoRepairConfig.FromStrategy(DBChar.AutoRepair.Strategy)
            return config, config.Description
        end,
        OnValueChange               = function(self, arg1, arg2, checked)
            DBChar.AutoRepair.Strategy = arg1.Strategy
            return true
        end,
    },
    AutoSell                        = {
        GetValue                    = function(self)
            return DBChar.AutoSell.Enable
        end,
        OnValueChange               = function(self, value)
            DBChar.AutoSell.Enable = value
        end
    }
}

function OnLoad(self)
    _Enabled = false
    SetDefaultToConfigDB(_Name,nil, DefaultCharConfig)
    DBChar = _Config.Char[_Parent._Name][_Name]
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
    OptionsLine("Line1", AutoSell_RepairContainer)
    FontString("AutoSellTitle", AutoSell_RepairContainer)
    OptionsCheckButton("AutoSellJunkEnableButton", AutoSell_RepairContainer)

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
                Anchor("TOPLEFT", -18, -35, "AutoRepairTitle", "BOTTOMLEFT")
            },
            dropDownMenuWidth           = 125,
            configBehavior              = ConfigBehaviors.AutoRepair,
            displayTextJustifyH         = "RIGHT",
            dropDownInfos               = {
                {
                    text                = AutoRepairConfig.GUILD.Description,
                    value               = AutoRepairConfig.GUILD,
                    tooltipText         = AutoRepairConfig.GUILD.Detail
                },
                {
                    text                = AutoRepairConfig.AUTO.Description,
                    value               = AutoRepairConfig.AUTO,
                    tooltipText         = AutoRepairConfig.AUTO.Detail
                },
                {
                    text                = AutoRepairConfig.NONE.Description,
                    value               = AutoRepairConfig.NONE,
                    tooltipText         = AutoRepairConfig.NONE.Detail
                }
            },

            Label                       = {
                text                    = L["config_features_auto_repair_strategy"],
                location                = {
                    Anchor("BOTTOMLEFT", 18, 5, nil, "TOPLEFT")
                }
            }
        },

        Line1                           = {
            location                    = {
                Anchor("LEFT"),
                Anchor("RIGHT"),
                Anchor('TOP', 0, -10, "AutoRepairDropDownMenu", "BOTTOM")
            }
        },

        AutoSellTitle                   = {
            location                    = {
                Anchor("TOPLEFT", 0, -10, "Line1", "BOTTOMLEFT")
            },
            text                        = L["config_features_auto_sell"],
            fontObject                  = GameFontNormalLarge
        },

        AutoSellJunkEnableButton        = {
            configBehavior              = ConfigBehaviors.AutoSell,
            location                    = {
                Anchor("TOPLEFT", -3, -5, "AutoSellTitle", "BOTTOMLEFT")
            },

            Label                       = {
                text                    = L["config_features_auto_sell_junk"]
            }
        }
    }
end