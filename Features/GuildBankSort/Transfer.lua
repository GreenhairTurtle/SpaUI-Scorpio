-- 物品转移
Scorpio "SpaUI.Features.GuildBankSort.Transfer" ""

Filter_DEFAULT_SELECTED_VALUE = -1
local SlotInfos, ItemInfos

__SystemEvent__ "SPAUI_GUILDBANK_TRANSFER"
function ShowTransferDialog()
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
    ClassFilter = ComboBox("ClassFilter", TransferDialog)
    SubClassFilter = ComboBox("SubClassFilter", TransferDialog)
    ExpacFilter = ComboBox("ExpacFilter", TransferDialog)
    QualityFilter = ComboBox("QualityFilter", TransferDialog)

    TransferDialog.OnHide = OnTransferDialogHide()
    TransferDialog.OnShow = OnTransferDialogShow()
    ClassFilter.OnSelectChanged = OnClassFilterChanged
    SubClassFilter.OnSelectChanged = OnSubClassFilterChanged
    ExpacFilter.OnSelectChanged = OnExpacFilterChanged
    QualityFilter.OnSelectChanged = OnQualityFilterChanged

    Style[TransferDialog] = {
        location                                = {
            Anchor("CENTER", 0, 0, "UIParent", "CENTER")
        },
        size                                    = Size(600, 500),

        Header                                  = {
            text                                = L["guild_bank_transfer_dialog_title"]
        },

        ClassFilter                             = {
            size                                = Size(165, 32),
            location                            = {
                Anchor("TOPLEFT", 10, -40)
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
                Anchor("TOPLEFT", 0, -20, "ClassFilter", "BOTTOMLEFT")
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
                Anchor("TOPLEFT", 0, -20, "SubClassFilter", "BOTTOMLEFT")
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

        -- ExpacFilter                             = {
        --     location                            = {
        --         Anchor("TOP", 0, 0, "ExpacFilterTitle", "BOTTOM"),
        --         Anchor("LEFT", 0, 0, "ClassFilter", "LEFT")
        --     }
        -- },

        -- QualityFilter                             = {
        --     location                            = {
        --         Anchor("TOP", 0, 0, "QualityFilterTitle", "BOTTOM"),
        --         Anchor("LEFT", 0, 0, "ClassFilter", "LEFT")
        --     }
        -- },
    }
end

__Async__()
function OnTransferDialogShow(self)
    SlotInfos, ItemInfos = GetGuildBankSlotInfos(GetCurrentGuildBankTab())
    RefreshClassFilters()
    RefreshSubClassFilters()
    RefreshExpacFilters()
end

function OnTransferDialogHide(self)
    SlotInfos = nil
    ItemInfos = nil
    HideLoading()
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

function OnClassFilterChanged(self, value)
    RefreshSubClassFilters()
end

function OnSubClassFilterChanged(self, value)
    print(self:GetName(), value)
end

function OnExpacFilterChanged(self, value)
    print(self:GetName(), value)
end

function OnQualityFilterChanged(self, value)
    print(self:GetName(), value)
end