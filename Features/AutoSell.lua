-- 来源NGA论坛
Scorpio "SpaUI.Features.AutoSell" ""

--售卖间隔，防止频繁点击商人后打印无效的售卖信息引起误导
SELL_INTERVAL = 1
L = _Locale

local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemLink = GetContainerItemLink
local GetItemInfo =GetItemInfo
local GetContainerItemInfo = GetContainerItemInfo
local UseContainerItem = UseContainerItem
local PickupMerchantItem = PickupMerchantItem
local GetCoinTextureString = GetCoinTextureString

function OnLoad(self)
    Config = _Config.Char.Features.AutoSell_Repair.AutoSell
end

__SystemEvent__()
__AsyncSingle__()
function MERCHANT_SHOW()
    if not Config.Enable then return end
    local total = 0
    for container = 0, 4 do
        local slotNum = GetContainerNumSlots(container)
        for slot = 1, slotNum do
            Continue()
            local link = GetContainerItemLink(container, slot)
            if link then
            local _, _, rarity, _, _, _, _, _, _, _, price = GetItemInfo(link)
                if rarity == 0 then
                    -- vendor price per each * stack number 
                    local price = price * select(2,GetContainerItemInfo(container, slot))
                    if price > 0 then
                        UseContainerItem(container, slot)
                        total = total + price
                        ShowMessage(string.format(L["auto_sell_detail"], link, GetCoinTextureString(price)))
                    end
                end
            end
        end
    end

    if total > 0 then
        ShowMessage(string.format(L["auto_sell_total"], GetCoinTextureString(total)))
    end

    Delay(SELL_INTERVAL)
end