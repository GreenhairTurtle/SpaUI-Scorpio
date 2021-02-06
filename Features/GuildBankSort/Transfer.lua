-- 物品转移
Scorpio "SpaUI.Features.GuildBankSort.Transfer" ""

Filter_DEFAULT_SELECTED_VALUE = -1
local SlotInfos
local SrcTab

__SystemEvent__ "SPAUI_GUILDBANK_TRANSFER"
function ToggleTransferDialog()
    if not TransferDialog then
        CreateTransferDialog()
        return
    end
    if TransferDialog:IsShown() then
        TransferDialog:Hide()
    else
        TransferDialog:Show()
    end
end

-- 创建物品转移对话框
function CreateTransferDialog()
    TransferDialog = Dialog("TransferDialog", GuildBankFrame)
    FontString("SrcTitle", TransferDialog)
    ClassFilter = ComboBox("ClassFilter", TransferDialog)
    SubClassFilter = ComboBox("SubClassFilter", TransferDialog)
    ExpacFilter = ComboBox("ExpacFilter", TransferDialog)
    QualityFilter = ComboBox("QualityFilter", TransferDialog)
    Frame("SrcItemsContainerBackground", TransferDialog)
    local SrcItemsContainer = FauxScrollFrame("SrcItemsContainer", TransferDialog)
    SrcPanel = ElementPanel("SrcPanel", SrcItemsContainer.ScrollChild)
    FontString("WaitingTransferTitle", TransferDialog)
    Frame("WaitingTransferItemsContainerBackground", TransferDialog)
    local WaitingTransferItemsContainer = FauxScrollFrame("WaitingTransferItemsContainer", TransferDialog)
    WaitingTransferPanel = ElementPanel("WaitingTransferPanel", WaitingTransferItemsContainer.ScrollChild)
    local TransferAllButton = UIPanelButton("TransferAllButton", TransferDialog)
    local ClearAllButton = UIPanelButton("ClearAllButton", TransferDialog)
    local TransferToBagButton = UIPanelButton("TransferToBagButton", TransferDialog)
    local TransferToOtherTabButton = UIPanelButton("TransferToOtherTabButton", TransferDialog)
    OtherTabPicker = ComboBox("OtherTabPicker", TransferDialog)

    TransferDialog.OnHide = OnTransferDialogHide
    TransferDialog.OnShow = OnTransferDialogShow
    ClassFilter.OnSelectChanged = OnClassFilterChanged
    SubClassFilter.OnSelectChanged = OnSubClassFilterChanged
    ExpacFilter.OnSelectChanged = OnExpacFilterChanged
    QualityFilter.OnSelectChanged = OnQualityFilterChanged
    SrcPanel.OnElementCreated = OnItemButtonCreated
    WaitingTransferPanel.OnElementCreated = OnItemButtonCreated
    TransferAllButton.OnClick = TransferAll
    ClearAllButton.OnClick = ClearAllWaitingTransferItem
    TransferToBagButton.OnClick = TransferToBag
    TransferToOtherTabButton.OnClick = TransferToOtherTab
    OnTransferDialogShow()

    Style[TransferDialog] = {
        enableMouse                             = true,
        Resizer                                 = {
            visible                             = false
        },
        location                                = {
            Anchor("CENTER", 0, 0, "UIParent", "CENTER")
        },
        size                                    = Size(600, 620),

        Header                                  = {
            text                                = L["guild_bank_transfer_dialog_title"]
        },

        SrcTitle                                = {
            location                            = {
                Anchor("TOP", 0, -10, "Header", "BOTTOM")
            }
        },

        ClassFilter                             = {
            size                                = Size(165, 32),
            location                            = {
                Anchor("TOP", 0, -30, "SrcTitle", "BOTTOM"),
                Anchor("LEFT")
            },

            label                               = {
                text                            = L["guild_bank_transfer_class_filter_title"],
                justifyH                        = "LEFT",
                location                        = {
                    Anchor("BOTTOMLEFT", 20, 0, nil, "TOPLEFT")
                }
            }
        },

        SubClassFilter                          = {
            size                                = Size(165, 32),
            location                            = {
                Anchor("TOPLEFT", 0, -30, "ClassFilter", "BOTTOMLEFT")
            },

            label                               = {
                text                            = L["guild_bank_transfer_subclass_filter_title"],
                justifyH                        = "LEFT",
                location                        = {
                    Anchor("BOTTOMLEFT", 20, 0, nil, "TOPLEFT")
                }
            }
        },

        ExpacFilter                             = {
            size                                = Size(165, 32),
            location                            = {
                Anchor("TOPLEFT", 0, -30, "SubClassFilter", "BOTTOMLEFT")
            },

            label                               = {
                text                            = L["guild_bank_transfer_expac_filter_title"],
                justifyH                        = "LEFT",
                location                        = {
                    Anchor("BOTTOMLEFT", 20, 0, nil, "TOPLEFT")
                }
            }
        },

        QualityFilter                           = {
            size                                = Size(165, 32),
            location                            = {
                Anchor("TOPLEFT", 0, -20, "ExpacFilter", "BOTTOMLEFT")
            },

            label                               = {
                text                            = L["guild_bank_transfer_quality_filter_title"],
                justifyH                        = "LEFT",
                location                        = {
                    Anchor("BOTTOMLEFT", 20, 0, nil, "TOPLEFT")
                }
            }
        },

        SrcItemsContainerBackground             = {
            frameStrata                         = "BACKGROUND",
            location                            = {
                Anchor("TOP", 0, -5, "SrcTitle", "BOTTOM"),
                Anchor("LEFT", 0, 0, "ClassFilter", "RIGHT"),
                Anchor("RIGHT", -20, 0),
                Anchor("BOTTOM", 0, 0, "QualityFilter", "BOTTOM")
            },
            backdrop                            = {
                edgeFile                        = [[Interface\Tooltips\UI-Tooltip-Border]],
                edgeSize                        = 16,
                tileEdge                        = true
            }
        },

        TransferAllButton                       = {
            size                                = Size(96, 22),
            text                                = L["guild_bank_transfer_src_transfer_all"],
            location                            = {
                Anchor("TOPRIGHT", 0, -5, "SrcItemsContainerBackground", "BOTTOMRIGHT")
            }
        },

        SrcItemsContainer                       = {
            location                            = {
                Anchor("TOPLEFT", 10, -10, "SrcItemsContainerBackground", "TOPLEFT"),
                Anchor("BOTTOMRIGHT", -10, 10, "SrcItemsContainerBackground", "BOTTOMRIGHT")
            },
            scrollBarHideable                   = true,

            ScrollBar                           = {
                location                        = {
                    Anchor("TOPRIGHT", 0, -24),
                    Anchor("BOTTOMRIGHT", 0, 24)
                },
            },

            ScrollChild                         = {
                SrcPanel                        = {
                    location                    = {
                        Anchor("TOPLEFT", 0, 0)
                    },
                    elementType                 = Button,
                    elementWidth                = 36,
                    elementHeight               = 36,
                    hSpacing                    = 6,
                    vSpacing                    = 5,
                    rowCount                    = 13,
                    columnCount                 = 9
                }
            }
        },

        WaitingTransferTitle                    = {
            text                                = L["guild_bank_transfer_waiting_title"],
            location                            = {
                Anchor("TOPLEFT", 20, -30, "QualityFilter", "BOTTOMLEFT")
            }
        },

        WaitingTransferItemsContainerBackground = {
            height                              = 200,
            frameStrata                         = "BACKGROUND",
            location                            = {
                Anchor("TOPLEFT", 0, -5, "WaitingTransferTitle", "BOTTOMLEFT"),
                Anchor("TOPRIGHT", -20, -5)
            },
            backdrop                            = {
                edgeFile                        = [[Interface\Tooltips\UI-Tooltip-Border]],
                edgeSize                        = 16,
                tileEdge                        = true
            }
        },

        ClearAllButton                          = {
            size                                = Size(96, 22),
            text                                = L["guild_bank_transfer_waiting_transfer_clear_all"],
            location                            = {
                Anchor("TOPLEFT", 0, -5, "WaitingTransferItemsContainerBackground", "BOTTOMLEFT")
            }
        },

        WaitingTransferItemsContainer           = {
            location                            = {
                Anchor("TOPLEFT", 10, -10, "WaitingTransferItemsContainerBackground", "TOPLEFT"),
                Anchor("BOTTOMRIGHT", -10, 10, "WaitingTransferItemsContainerBackground", "BOTTOMRIGHT")
            },
            scrollBarHideable                   = true,

            ScrollBar                           = {
                location                        = {
                    Anchor("TOPRIGHT", 0, -24),
                    Anchor("BOTTOMRIGHT", 0, 24)
                },
            },

            ScrollChild                         = {
                WaitingTransferPanel            = {
                    location                    = {
                        Anchor("TOPLEFT", 0, 0)
                    },
                    elementType                 = Button,
                    elementWidth                = 36,
                    elementHeight               = 36,
                    hSpacing                    = 8,
                    vSpacing                    = 5,
                    rowCount                    = 13,
                    columnCount                 = 12
                }
            }
        },

        TransferToBagButton                     = {
            text                                = L["guild_bank_transfer_to_bag"],
            size                                = Size(120, 22),
            location                            = {
                Anchor("BOTTOMRIGHT", -20, 15)
            }
        },

        TransferToOtherTabButton                = {
            text                                = L["guild_bank_transfer_to_other_tab"],
            size                                = Size(150,22),
            location                            = {
                Anchor("RIGHT", -5, 0, "TransferToBagButton", "LEFT")
            }
        },

        OtherTabPicker                          = {
            size                                = Size(180, 22),
            location                            = {
                Anchor("RIGHT", 5, -2, "TransferToOtherTabButton", "LEFT")
            },

            label                               = {
                text                            = L["guild_bank_transfer_to_other_tab_picker_label"],
                location                        = {
                    Anchor("RIGHT", 10, 1, nil, "LEFT")
                }
            },

            DisplayText                         = {
                location                        = {
                    Anchor("LEFT", 25, 1),
                    Anchor("RIGHT", -43, 1)
                }
            }
        }
    }
end

__Async__()
function OnTransferDialogShow(self)
    ShowLoading()
    SrcTab = GetCurrentGuildBankTab()
    SlotInfos = GetGuildBankSlotInfos(SrcTab)
    local tabName, tabIcon = GetGuildBankTabInfo(SrcTab)
    TransferDialog:GetChild("SrcTitle"):SetText(L["guild_bank_transfer_src_title"]:format(tabIcon, tabName, SrcTab))
    RefreshClassFilters()
    RefreshSubClassFilters()
    RefreshExpacFilters()
    RefreshQualityFilters()
    RefreshSrcData()
    RefreshWaitingTransferData()
    RefreshOtherTabPicker()
end

function OnTransferDialogHide(self)
    SrcTab = nil
    SlotInfos = nil
    HideLoading()
end

-- 刷新Src数据
__AsyncSingle__()
function RefreshSrcData()
    if not SlotInfos then return end
    Next()
    local itemInfos = {}
    local count = 0
    for _, slotInfo in ipairs(SlotInfos) do
        if slotInfo.count > 0 and slotInfo.item then
            local item = slotInfo.item
            -- markTransfer 标记为待转移物品
            if IsItemFiltered(item) and not slotInfo.markTransfer then 
                local itemInfo = itemInfos[item.itemId]
                if not itemInfo then
                    itemInfo = {}
                    itemInfo.itemTexture = item.itemTexture
                    itemInfo.itemQuality = item.itemQuality
                    itemInfo.itemId = item.itemId
                    itemInfos[item.itemId] = itemInfo
                    count = count + 1
                end
                itemInfo.count = (itemInfo.count or 0) + slotInfo.count
            end
        end
    end
    SrcPanel.Count = count

    local index = 1
    for _, itemInfo in pairs(itemInfos) do
        local element = SrcPanel.Elements[index]
        if element then
            Continue()
            element:SetItemInfo(itemInfo)
            index = index + 1
        end
    end
end

-- 刷新待转移物品数据
__AsyncSingle__()
function RefreshWaitingTransferData()
    if not SlotInfos then return end
    Next()
    local itemInfos = {}
    local count = 0
    for _, slotInfo in ipairs(SlotInfos) do
        if slotInfo.count > 0 and slotInfo.item then
            local item = slotInfo.item
            -- markTransfer 标记为待转移物品
            if slotInfo.markTransfer then 
                local itemInfo = itemInfos[item.itemId]
                if not itemInfo then
                    itemInfo = {}
                    itemInfo.itemTexture = item.itemTexture
                    itemInfo.itemQuality = item.itemQuality
                    itemInfo.itemId = item.itemId
                    itemInfos[item.itemId] = itemInfo
                    count = count + 1
                end
                itemInfo.count = (itemInfo.count or 0) + slotInfo.count
            end
        end
    end
    WaitingTransferPanel.Count = count

    local index = 1
    for _, itemInfo in pairs(itemInfos) do
        local element = WaitingTransferPanel.Elements[index]
        if element then
            Continue()
            element:SetItemInfo(itemInfo, false)
            index = index + 1
        end
    end
end

-- return true:物品满足筛选条件
function IsItemFiltered(item)
    local classFilterValue = ClassFilter.SelectedValue
    local subClassFilterValue = SubClassFilter.SelectedValue
    local expacFilterValue = ExpacFilter.SelectedValue
    local qualityFilterValue = QualityFilter.SelectedValue
    return (classFilterValue == Filter_DEFAULT_SELECTED_VALUE or item.classID == classFilterValue)
        and (subClassFilterValue == Filter_DEFAULT_SELECTED_VALUE or item.subclassID == subClassFilterValue)
        and (expacFilterValue == Filter_DEFAULT_SELECTED_VALUE or item.expacID == expacFilterValue)
        and (qualityFilterValue == Filter_DEFAULT_SELECTED_VALUE or item.itemQuality == qualityFilterValue)
end

function RefreshClassFilters()
    ClassFilter:ClearItems()
    if SlotInfos then
        local classInfos = {}
        for _, slot in ipairs(SlotInfos) do
            if slot and slot.item and slot.item.classID then
                classInfos[slot.item.classID] = true
            end
        end
        for key, _ in pairs(classInfos)do
            ClassFilter.Items[key] = GetItemClassInfo(key)
        end
    end
    ClassFilter.Items[Filter_DEFAULT_SELECTED_VALUE] = L["guild_bank_transfer_filter_default"]
    ClassFilter.SelectedValue = Filter_DEFAULT_SELECTED_VALUE
end

function RefreshSubClassFilters()
    SubClassFilter:ClearItems()
    local classId = ClassFilter.SelectedValue
    if classId ~= Filter_DEFAULT_SELECTED_VALUE then
        if SlotInfos then
            local subClassInfos = {}
            for _, slot in ipairs(SlotInfos) do
                if slot and slot.item and slot.item.classID == classId then
                    subClassInfos[slot.item.subclassID] = true
                end
            end
            for key, _ in pairs(subClassInfos)do
                SubClassFilter.Items[key] = GetItemSubClassInfo(classId, key)
            end
        end
    end
    SubClassFilter.Items[Filter_DEFAULT_SELECTED_VALUE] = L["guild_bank_transfer_filter_default"]
    SubClassFilter.SelectedValue = Filter_DEFAULT_SELECTED_VALUE
end

function RefreshExpacFilters()
    ExpacFilter:ClearItems()
    if SlotInfos then
        local expacInfos = {}
        for _, slot in ipairs(SlotInfos) do
            if slot and slot.item and slot.item.expacID then
                expacInfos[slot.item.expacID] = true
            end
        end
        for key, _ in pairs(expacInfos)do
            ExpacFilter.Items[key] = _G["EXPANSION_NAME"..key]
        end
    end
    ExpacFilter.Items[Filter_DEFAULT_SELECTED_VALUE] = L["guild_bank_transfer_filter_default"]
    ExpacFilter.SelectedValue = Filter_DEFAULT_SELECTED_VALUE
end

function RefreshQualityFilters()
    QualityFilter:ClearItems()
    if SlotInfos then
        local qualityInfos = {}
        for _, slot in ipairs(SlotInfos) do
            if slot and slot.item and slot.item.itemQuality then
                qualityInfos[slot.item.itemQuality] = true
            end
        end
        for key, _ in pairs(qualityInfos)do
            QualityFilter.Items[key] =  ITEM_QUALITY_COLORS[key].hex.._G["ITEM_QUALITY"..key.."_DESC"]..Color.CLOSE
        end
    end
    QualityFilter.Items[Filter_DEFAULT_SELECTED_VALUE] = L["guild_bank_transfer_filter_default"]
    QualityFilter.SelectedValue = Filter_DEFAULT_SELECTED_VALUE
end

function RefreshOtherTabPicker()
    OtherTabPicker:ClearItems()
    local tabNumbers = GetNumGuildBankTabs()
    for tab = 1, tabNumbers do
        local _, _, _, canDeposit = GetGuildBankTabInfo(tab)
        if canDeposit and tab ~= SrcTab then
            local name = GetGuildBankTabInfo(tab)
            OtherTabPicker.Items[tab] = L["guild_bank_transfer_to_other_tab_picker_text"]:format(name,tab)
        end
    end
    OtherTabPicker.Items[Filter_DEFAULT_SELECTED_VALUE] = L["guild_bank_transfer_to_other_tab_picker_default"]
    OtherTabPicker.SelectedValue = Filter_DEFAULT_SELECTED_VALUE
end

function OnClassFilterChanged(self, value)
    RefreshSubClassFilters()
    RefreshSrcData()
end

function OnSubClassFilterChanged(self, value)
    RefreshSrcData()
end

function OnExpacFilterChanged(self, value)
    RefreshSrcData()
end

function OnQualityFilterChanged(self, value)
    RefreshSrcData()
end

function OnItemButtonCreated(self, element)
    Texture("Icon", element)
    FontString("Count", element)
    Texture("IconBorder", element)

    element.OnEnter = function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetItemByID(self.itemInfo.itemId)
        GameTooltip:AddLine(self.isSrc and L["guild_bank_transfer_add_item_tooltip"] or L["guild_bank_transfer_remove_item_tooltip"])
        GameTooltip:Show()
    end

    element.OnLeave = function(self)
        GameTooltip:Hide()
    end

    -- iteminfo内字段：itemId itemQuality itemTexture count
    element.SetItemInfo = function(self, itemInfo, isSrc)
        self.itemInfo = itemInfo
        self.isSrc = isSrc== nil and true or false
        local icon = element:GetChild("Icon")
        local count = element:GetChild("Count")
        local iconBorder = element:GetChild("IconBorder")
        local quality = itemInfo.itemQuality
        icon:SetTexture(itemInfo.itemTexture)
        count:SetText(tostring(itemInfo.count))
        if quality >= _G["Enum"].ItemQuality.Common and ITEM_QUALITY_COLORS[quality] then
            iconBorder:Show();
            local color = ITEM_QUALITY_COLORS[quality]
            iconBorder:SetVertexColor(color.r, color.g, color.b);
        else
            iconBorder:Hide();
        end
    end

    element.OnClick = function(self)
        MarkItemAsTransfer(self.itemInfo, not self.isSrc)
    end

    element:RegisterForClicks("RightButtonUp")

    Style[element] = {
        normalTexture           = {
            file                = [[Interface\Buttons\UI-Quickslot2]],
            size                = Size(64,64),
            location            = {
                Anchor("CENTER")
            }
        },
        pushedTexture           = {
            file                = [[Interface\Buttons\UI-Quickslot-Depress]],
            setAllPoints        = true
        },
        highlightTexture        = {
            file                = [[Interface\Buttons\ButtonHilight-Square]],
            setAllPoints        = true,
            alphaMode           = "ADD"
        },

        Icon                    = {
            drawLayer           = "BORDER",
            setAllPoints        = true
        },
    
        Count                   = {
            fontObject          = NumberFontNormal,
            location            = {
                Anchor("BOTTOMRIGHT", -2 ,2)
            },
            justifyH            = "RIGHT"
        },

        IconBorder              = {
            file                = [[Interface\Common\WhiteIconFrame]],
            setAllPoints        = true,
            drawLayer           = "OVERLAY"
        }
    }
end

-- 标记需要转移的物品
function MarkItemAsTransfer(itemInfo, clear)
    if not SlotInfos or not itemInfo then return end
    for _, slotInfo in ipairs(SlotInfos) do
        if slotInfo.item and slotInfo.item.itemId == itemInfo.itemId then
            slotInfo.markTransfer = not clear
        end
    end
    RefreshSrcData()
    RefreshWaitingTransferData()
end

-- 全部转移至待转区
function TransferAll(self)
    if not SlotInfos then return end
    if SrcPanel.Count > 0 then
        local itemInfos = {}
        for i = 1, SrcPanel.Count do
            local itemInfo = SrcPanel.Elements[i].itemInfo
            itemInfos[itemInfo.itemId] = itemInfo
        end
        for _, slotInfo in ipairs(SlotInfos) do
            if slotInfo.item and itemInfos[slotInfo.item.itemId]then
                slotInfo.markTransfer = true
            end
        end
        RefreshSrcData()
        RefreshWaitingTransferData()
    end
end

-- 清除待转移的所有物品
function ClearAllWaitingTransferItem(self)
    if not SlotInfos then return end
    if WaitingTransferPanel.Count > 0 then
        local itemInfos = {}
        for i = 1, WaitingTransferPanel.Count do
            local itemInfo = WaitingTransferPanel.Elements[i].itemInfo
            itemInfos[itemInfo.itemId] = itemInfo
        end
        for _, slotInfo in ipairs(SlotInfos) do
            if slotInfo.item and itemInfos[slotInfo.item.itemId]then
                slotInfo.markTransfer = false
            end
        end
        RefreshSrcData()
        RefreshWaitingTransferData()
    end
end

-- 转移至背包
__AsyncSingle__()
function TransferToBag(self)
    if WaitingTransferPanel.Count <= 0 then return end
    if not CanSortTab(SrcTab) then ShowUIError(L["guild_bank_cannot_withdraw"]) return end
    -- 这里要重新拿一次，放置对话框显示太久公会银行物品可能变更了
    -- 这样可以规避部分问题
    local slotInfos = GetGuildBankSlotInfos(SrcTab)
    local itemInfos = {}
    for i = 1, WaitingTransferPanel.Count do
        local itemInfo = WaitingTransferPanel.Elements[i].itemInfo
        itemInfos[itemInfo.itemId] = itemInfo
    end
    local paths = {}
    for slot, slotInfo in ipairs(slotInfos) do
        if slotInfo.item and itemInfos[slotInfo.item.itemId]then
            local path = {}
            path.tab = SrcTab
            path.slot = slot 
            tinsert(paths, path)
        end
    end
    if #paths <= 0 then return end

    local result = Confirm(L["guild_bank_transfer_to_bag_confirm"])
    if result then
        TransferDialog:Hide()
        local count = math.min(#paths, CalculateTotalNumberOfFreeBagSlots())
        for i = 1, count do
            if not GuildBankFrame:IsShown() then return end
            ShowLoading(i, count, L["guild_bank_transfer_to_bag_description"])
            local path = paths[i]
            AutoStoreGuildBankItem(path.tab, path.slot)
            Delay(0.7)
        end
        HideLoading()
    end
end

-- 转移至其它标签页
__AsyncSingle__()
function TransferToOtherTab(self)
    if OtherTabPicker.SelectedValue == Filter_DEFAULT_SELECTED_VALUE or WaitingTransferPanel.Count <= 0 then return end
    if not CanSortTab(SrcTab) then ShowUIError(L["guild_bank_cannot_withdraw"]) return end
    local desTab = OtherTabPicker.SelectedValue
    ShowMessage(L["guild_bank_transfer_to_other_tab_retrive_data"])
    QueryGuildBankTab(desTab)
    Delay(1)
    local _, _, isViewable, canDeposit = GetGuildBankTabInfo(desTab)
    if not isViewable or not canDeposit then ShowUIError(L["guild_bank_cannot_deposit"]) return end
    -- 查询目标标签页会导致当前标签页的可提取额度变为目标标签页的，因为查询后暴雪做了缓存
    -- 所以要再查一次当前标签页的数据使其正常
    QueryGuildBankTab(SrcTab)
    Delay(0.5)
    -- 获取目标标签页数据
    local desSlotInfos = GetGuildBankSlotInfos(desTab)
    -- 这里要重新拿一次，防止对话框显示太久公会银行物品可能变更了
    -- 这样可以规避部分问题
    local slotInfos = GetGuildBankSlotInfos(SrcTab)
    local itemInfos = {}
    
    for i = 1, WaitingTransferPanel.Count do
        local itemInfo = WaitingTransferPanel.Elements[i].itemInfo
        itemInfos[itemInfo.itemId] = itemInfo
    end
    
    local paths = {}
    local desSlotIndex = 1
    for slot, slotInfo in ipairs(slotInfos) do
        Continue()
        -- 找到当前标签页需要转移的物品的格子
        if slotInfo.item and itemInfos[slotInfo.item.itemId]then
            for desSlot = desSlotIndex, #desSlotInfos do
                desSlotInfo = desSlotInfos[desSlot]
                -- 找到目标标签页的空格
                if desSlotInfo.count <=0 and not desSlotInfo.item then
                    local path = {}
                    path.srcTab = SrcTab
                    path.srcSlot = slot
                    path.desTab = desTab
                    path.desSlot = desSlot
                    desSlotIndex = desSlot + 1
                    tinsert(paths, path)
                    break
                end
            end
        end
    end

    if #paths <=0 then
        ShowMessage(L["guild_bank_transfer_to_other_tab_full"])
    else
        local name, icon = GetGuildBankTabInfo(desTab)
        local result = Confirm(L["guild_bank_transfer_to_other_tab_confirm"]:format(icon, name, desTab))
        if result then
            TransferDialog:Hide()
            ApplyPaths(paths, L["guild_bank_transfer_to_other_tab_description"])
            HideLoading()
        end
    end
end