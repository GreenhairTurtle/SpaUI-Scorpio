-- 物品转移
Scorpio "SpaUI.Features.GuildBankSort.Transfer" ""

function CreateTransferDialog()
    TransferDialog = Dialog("TransferDialog", GuildBankFrame)
    local SrcContainer = Frame("SrcContainer", TransferDialog)
    local DesContainer = Frame("DesContainer", TransferDialog)
    FontString("Title", SrcContainer)
    FontString("Title", DesContainer)
    
    Style[TransferDialog] = {
        location                                = {
            Anchor("CENTER", 0, 0, "UIParent", "CENTER")
        },
        size                                    = Size(600, 500),

        Header                                  = {
            text                                = L["guild_bank_transfer_dialog_title"]
        },

        SrcContainer                            = {
            location                            = {
                Anchor("TOP", 0, -16, "Header", "BOTTOM"),
                Anchor("LEFT", 16, 0),
                Anchor("RIGHT", -8, 0, nil, "CENTER"),
                Anchor("BOTTOM", 0, 16)
            },
            backdrop                            = {
                edgeFile                        = [[Interface\Tooltips\UI-Tooltip-Border]],
                edgeSize                        = 16,
                tileEdge                        = true
            },      
            backdropBorderColor                 = ColorType(0.6, 0.6, 0.6, 0.6),

            Title                               = {
                text                            = L["guild_bank_transfer_src_title"],
                location                        = {
                    Anchor("BOTTOM", 0, 5, nil, "TOP")
                }
            }
        },

        DesContainer                            = {
            location                            = {
                Anchor("TOP", 0, -16, "Header", "BOTTOM"),
                Anchor("LEFT", 8, 0, nil, "CENTER"),
                Anchor("RIGHT", -16, 0),
                Anchor("BOTTOM", 0, 16)
            },
            backdrop                            = {
                edgeFile                        = [[Interface\Tooltips\UI-Tooltip-Border]],
                edgeSize                        = 16,
                tileEdge                        = true
            },
            backdropBorderColor                 = ColorType(0.6, 0.6, 0.6, 0.6),

            Title                               = {
                text                            = L["guild_bank_transfer_des_title"],
                location                        = {
                    Anchor("BOTTOM", 0, 5, nil, "TOP")
                }                    
            }
        }
    }
end

__SystemEvent__ "SPAUI_GUILDBANK_TRANSFER"
function ShowTransferDialog()
    if not TransferDialog then
        CreateTransferDialog()
    end
end