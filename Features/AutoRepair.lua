Scorpio "SpaUI.Features.AutoRepair" ""

--修理间隔，防止频繁点击商人后打印无效的修理信息引起误导
REPAIR_INTERVAL = 1
L = _Locale

__SystemEvent__() __AsyncSingle__()
function MERCHANT_SHOW()
    if CanMerchantRepair() then
        local cost , canRepair = GetRepairAllCost()
        if canRepair then
            if IsInGuild() and CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= cost then
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
