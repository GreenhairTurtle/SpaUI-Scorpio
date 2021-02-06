Scorpio "SpaUI.Features.GuildBankSort.Sort" ""

-- 整理
__SystemEvent__ "SPAUI_GUILDBANK_SORT"
__AsyncSingle__()
function Sort()
    local tab = GetCurrentGuildBankTab()
    if not CanSortTab(tab) then
        ShowUIError(L["guild_bank_cannot_withdraw"])
        return
    end
    local slotInfos = GetGuildBankSlotInfos(tab)
    MergeItems(tab, slotInfos)
    MoveItems(tab, slotInfos)
    HideLoading()
end

-- 移动物品
function MoveItems(tab, slotInfos)
    local paths = {}
    for index = 1, #slotInfos - 1 do
        Continue()
        local maxIndex = index
        -- 找到本次循环最大值
        for compareIndex = index + 1, #slotInfos do
            if CompareSlot(slotInfos[compareIndex], slotInfos[maxIndex]) >= 0 then
                maxIndex = compareIndex
            end
        end

        local maxSlotInfo = slotInfos[maxIndex]
        local maxItem = maxSlotInfo.item
        local slotInfo = slotInfos[index]
        local item = slotInfo.item

        if maxItem and maxIndex ~= index and (item == nil or maxItem.itemId ~= item.itemId) then
            -- 交换位置
            slotInfos[maxIndex] = slotInfos[index]
            slotInfos[index] = maxSlotInfo
            local path = {}
            path.srcTab = tab
            path.srcSlot = maxIndex
            path.desTab = tab
            path.desSlot = index
            tinsert(paths, path)
        end
    end

    ApplyPaths(paths, L["guild_bank_move_items"])
end

-- 合并物品
function MergeItems(tab, slotInfos)
    local paths = {}
    for index, slotInfo in ipairs(slotInfos) do
        Continue()
        local item = slotInfo.item
        if item then
            local itemId = item.itemId
            local itemStackCount = item.itemStackCount
            -- 没堆满，遍历后续所有物品，查到相同则合并
            if slotInfo.count < itemStackCount then
                for i = index + 1, #slotInfos do
                    -- 某一次合并后可能堆满了，跳出循环
                    if slotInfo.count >= itemStackCount then break end
                    local compareSlot = slotInfos[i]
                    -- 是同一物品并且没有堆满，合并
                    if compareSlot.item and compareSlot.item.itemId == itemId and compareSlot.count < itemStackCount then
                        local path = {}
                        path.srcTab = tab
                        path.srcSlot = i
                        path.desTab = tab
                        path.desSlot = index
                        tinsert(paths, path)

                        if compareSlot.count + slotInfo.count <= itemStackCount then
                            slotInfo.count = slotInfo.count + compareSlot.count
                            compareSlot.item = nil
                            compareSlot.count = 0
                        else
                            compareSlot.count = compareSlot.count - (itemStackCount - slotInfo.count)
                            slotInfo.count = itemStackCount
                        end
                    end
                end
            end
        end
    end
    ApplyPaths(paths, L["guild_bank_merge_items"])
end

-- return：负数：slot1 < slot2; 0:slot1 = slot2; 正数: slot1 > slot2;
-- 空格永远最小！
function CompareSlot(slot1, slot2)
    local item1 = slot1.item
    local item2 = slot2.item

    if item1 == item2 then
        return 0
    elseif item1 == nil then
        return -1
    elseif item2 == nil then
        return 1
    end

    if item1.classID ~= item2.classID then
        return item1.classID - item2.classID
    end
    if item1.subclassID ~= item2.subclassID then
        return item1.subclassID - item2.subclassID
    end
    if item1.expacID ~= item2.expacID then
        return item1.expacID - item2.expacID
    end
    if item1.itemQuality ~= item2.itemQuality then
        return item1.itemQuality - item2.itemQuality
    end
    if item1.itemId ~= item2.itemId then
        return item1.itemId - item2.itemId
    end
    -- if slot1.count ~= slot2.count then
    --     return slot1.count - slot2.count
    -- end
    return 0
end