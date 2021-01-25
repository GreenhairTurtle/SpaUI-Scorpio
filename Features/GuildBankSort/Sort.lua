Scorpio "SpaUI.Features.GuildBankSort.Sort" ""

L = _Locale

-- 整理
__SystemEvent__ "SPAUI_GUILDBANK_SORT"
__AsyncSingle__()
function Sort()
    local tab = GetCurrentGuildBankTab()
    if not CanSortTab(tab) then
        ShowUIError(L["guild_bank_cannot_withdraw"])
        return
    end
    local slotInfos, itemInfos = GetGuildBankSlotInfos(tab)
    MergeItems(tab,slotInfos,itemInfos)
    MoveItems(tab, slotInfos)
    HideLoading()
end

-- 移动物品
function MoveItems(tab, slotInfos)
    local paths = {}
    for index = 1, #slotInfos - 1 do
        Continue()
        local minIndex = index
        -- 找到本次循环最大值
        for compareIndex = index + 1, #slotInfos do
            if CompareSlot(slotInfos[compareIndex], slotInfos[minIndex]) > 0 then
                minIndex = compareIndex
            end
        end

        local slotInfo = slotInfos[minIndex]
        local item = slotInfo.item
        -- 交换位置
        slotInfos[minIndex] = slotInfos[index]
        slotInfos[index] = slotInfo
        if item and minIndex ~= index then
            local path = {}
            path.srcTab = tab
            path.srcSlot = minIndex
            path.desTab = tab
            path.desSlot = index
            tinsert(paths, path)
        end
    end
    ApplyPaths(paths, "move")
end

-- 合并物品
function MergeItems(tab,slotInfos, itemInfos)
    local paths = {}
    for index = 1, #slotInfos do
        local slotInfo = slotInfos[index]
        local item = slotInfo.item
        if item then
            local itemInfo = itemInfos[item.itemId]
            if #itemInfo > 1 then
                for i = 1, #itemInfo do
                    CreateMergeItemMovingPath(tab, slotInfos, itemInfo, i, paths)
                end
            end
        end
    end
    ApplyPaths(paths, "merge")
end

-- 创建合并物品移动路径
function CreateMergeItemMovingPath(tab, slotInfos, itemInfo, start, paths)
    local startSlotIndex = itemInfo[start]
    if not startSlotIndex then return end
    local startSlot = slotInfos[startSlotIndex]
    local startItem = startSlot.item
    if startSlot.count >= startItem.itemStackCount then return end
    if not startItem then return end
    for index = start + 1, #itemInfo do
        local slotIndex = itemInfo[index]
        if slotIndex then
            local slot = slotInfos[slotIndex]
            local item = slot.item
            if item and slot.count < item.itemStackCount then
                local path = {}
                path.srcTab = tab
                path.srcSlot = slotIndex
                path.desTab = tab
                path.desSlot = startSlotIndex
                tinsert(paths,path)

                if slot.count + startSlot.count <= startItem.itemStackCount then
                    startSlot.count = startSlot.count + slot.count
                    -- 将被合并的格子数据清除
                    slot.item = nil
                    slot.count = 0
                    itemInfo[index] = nil
                else
                    -- startSlot 堆叠上限了
                    slot.count = slot.count - (startItem.itemStackCount - startSlot.count)
                    startSlot.count = startItem.itemStackCount
                    break
                end
            end
        end
    end
end

-- 应用移动路径
function ApplyPaths(paths, type)
    local typeString
    if type == "merge" then
        typeString = L["guild_bank_merge_items"]
    elseif type == "move" then
        typeString = L["guild_bank_move_items"]
    end

    local count = #paths
    for index, path in ipairs(paths) do
        if not GuildBankFrame:IsShown() then break end
        ShowLoading(typeString:format(index,count))
        PickupGuildBankItem(path.srcTab, path.srcSlot)
        PickupGuildBankItem(path.desTab, path.desSlot)
        if CursorHasItem() then
            PickupGuildBankItem(path.desTab, path.desSlot)
        end
        Delay(1)
    end
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