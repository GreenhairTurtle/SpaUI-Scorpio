-- 摧毁物品不需要填写delete
--------------------------------------------------------------------------------
-- EasyDeleteConfirm
-- By Kesava at curse.com
-- All rights reserved
--------------------------------------------------------------------------------
Scorpio "SpaUI.Features.EasyDelete" ""

local GetCursorInfo = GetCursorInfo

function OnEnable(self)
    -- create item link container
    EasyDeleteLink = FontString("SpaUIEasyDeleteLink", StaticPopup1)

    Style[EasyDeleteLink] = {
        fontobject = GameFontHighlight,
        location   = {Anchor("CENTER", 0, -5)},
        visible    = false
    }

    StaticPopup1:HookScript('OnHide',function(self) EasyDeleteLink:Hide() end)
end

__SystemEvent__()
__Async__()
function DELETE_ITEM_CONFIRM()
    if StaticPopup1EditBox:IsShown() then
        StaticPopup1EditBox:Hide()
        StaticPopup1Button1:Enable()
        local link = select(3, GetCursorInfo())

        EasyDeleteLink:SetText(link)
        EasyDeleteLink:Show()
    end
end
