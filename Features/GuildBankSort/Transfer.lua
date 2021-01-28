-- 物品转移
Scorpio "SpaUI.Features.GuildBankSort.Transfer" ""

function CreateTransferDialog()
    TransferDialog = Dialog("TransferDialog", GuildBankFrame)
    
    
    Style[TransferDialog] = {
        location                                = {
            Anchor("CENTER", 0, 0, "UIParent", "CENTER")
        },
        size                                    = Size(600, 500),

        Header                                  = {
            text                                = L["guild_bank_transfer_dialog_title"]
        }
    }
end

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