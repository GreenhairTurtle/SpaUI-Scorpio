Scorpio "SpaUI.Features.AutoRepair" ""
import "SpaUI.Widget.Config.Features"

--修理间隔，防止频繁点击商人后打印无效的修理信息引起误导
REPAIR_INTERVAL = 1

function OnLoad(self)
    Config = _Config.Char.Features.AutoSell_Repair.AutoRepair
end

__SystemEvent__() __AsyncSingle__()
function MERCHANT_SHOW()
    local RepairStrategy = AutoRepairConfig.FromStrategy(Config.Strategy)
    -- 不使用自动修理
    if RepairStrategy == AutoRepairConfig.NONE then return end
    if CanMerchantRepair() then
        local cost , canRepair = GetRepairAllCost()
        if canRepair then
            if RepairStrategy == AutoRepairConfig.GUILD and IsInGuild() and CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= cost then
                RepairAllItems(true)
                ShowMessage(format(L["auto_repair_guild_cost"],GetCoinTextureString(cost)))
            else
                if cost <= GetMoney() then
                    RepairAllItems()
                    ShowMessage(format(L["auto_repair_cost"], GetCoinTextureString(cost)))
                else
                    ShowUIError(L["auto_repair_no_money"])
                end
            end
        end
    end

    Delay(REPAIR_INTERVAL)
end