Scorpio "SpaUI.Features.AutoSell" ""

--售卖间隔，防止频繁点击商人后打印无效的售卖信息引起误导
SELL_INTERVAL = 1

LastSellTime = 0
L = _Locale

__SystemEvent__() __Async__()
function MERCHANT_SHOW()
    local current = GetTime()
    if current - LastSellTime < SELL_INTERVAL then return end
    LastSellTime = current

    local total = 0
    for container = 0, 4 do
        local slotNum = GetContainerNumSlots(container)
        for slot = 1, slotNum do
            local link = GetContainerItemLink(container, slot)
            -- item quality == 0 (poor) 
            if link and select(3, GetItemInfo(link)) == 0 then
                -- vendor price per each * stack number 
                local price = select(11, GetItemInfo(link)) * select(2,GetContainerItemInfo(container, slot))
                if price > 0 then
                    UseContainerItem(container, slot)
                    PickupMerchantItem()
                    total = total + price
                    print(string.format(L["auto_sell_detail"], link, GetCoinTextureString(price)))
                end
            end
        end
    end

    if total > 0 then
        print(string.format(L["auto_sell_total"], GetCoinTextureString(total)))
    end
end