-- 公会银行修理
Scorpio "SpaUI.Features.GuildBankSort" ""

GUILDBANK_TAB_ITEM_SIZE = 98

-- 获取公会银行格子信息
__Async__()
function GetGuildBankSlotsInfo(tab)
    local slotInfos = {}
    for slot = 1, GUILDBANK_TAB_ITEM_SIZE do
        Continue()
        print(GetTime())
        local info = {}
        local _, count = GetGuildBankItemInfo(tab,slot)
        info.count = 0
        if count > 0 then
            local link = GetGuildBankItemLink(tab, slot)
            if link then
                local item = {}
                local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
                    itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expacID, setID, isCraftingReagent
                    = GetItemInfo(link)
                item.itemName = itemName
                item.itemLink = itemLink
                item.itemQuality = itemQuality
                item.itemLevel = itemLevel
                item.itemMinLevel = itemMinLevel
                item.itemType = itemType
                item.itemSubType = itemSubType
                item.itemStackCount = itemStackCount
                item.itemEquipLoc = itemEquipLoc
                item.itemTexture = itemTexture
                item.sellPrice = sellPrice
                item.classID = classID
                item.subclassID = subclassID
                item.bindType = bindType
                item.expacID = expacID
                item.setID = setID
                item.isCraftingReagent = isCraftingReagent
                info.item = item
            end
        end
        slotInfos[slot] = info
    end
    Dump(slotInfos)
    return slotInfos
end