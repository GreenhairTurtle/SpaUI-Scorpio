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

__SystemEvent__()
__AsyncSingle__()
function MERCHANT_SHOW()
    local total = 0
    for container = 0, 4 do
        local slotNum = GetContainerNumSlots(container)
        for slot = 1, slotNum do
            Continue()
            local link = GetContainerItemLink(container, slot)
            -- item quality == 0 (poor) 
            if link and select(3, GetItemInfo(link)) == 0 then
                -- vendor price per each * stack number 
                local price = select(11, GetItemInfo(link)) * select(2,GetContainerItemInfo(container, slot))
                if price > 0 then
                    UseContainerItem(container, slot)
                    PickupMerchantItem()
                    total = total + price
                    ShowMessage(string.format(L["auto_sell_detail"], link, GetCoinTextureString(price)))
                end
            end
        end
    end

    if total > 0 then
        ShowMessage(string.format(L["auto_sell_total"], GetCoinTextureString(total)))
    end

    Delay(SELL_INTERVAL)
end