-- 修改自TinyInspect 角色和观察面板显示装等、宝石、附魔信息
Scorpio "SpaUI.Features.Inspect.Detail" ""

function OnEnable(self)
    Slots                   = {
        CharacterHeadSlot = true,
        CharacterNeckSlot = true,
        CharacterShoulderSlot = true,
        CharacterBackSlot = true,
        CharacterChestSlot = true,
        CharacterWristSlot = true,
        CharacterHandsSlot = true,
        CharacterWaistSlot = true,
        CharacterLegsSlot = true,
        CharacterFeetSlot = true,
        CharacterFinger0Slot = true,
        CharacterFinger1Slot = true,
        CharacterTrinket0Slot = true,
        CharacterTrinket1Slot = true,
        CharacterMainHandSlot = true,
        CharacterSecondaryHandSlot = true
    }
end

function ClearDetail(slot)
    if slot.ilevel then
        slot.ilevel:SetText(nil)
    end
end

__SecureHook__()
function PaperDollItemSlotButton_Update(self)
    local name = self:GetName()
    if not Slots[name] then return end
    local slot = _G[name]
    local textureName = GetInventoryItemTexture("player", self:GetID())
    if not textureName then
        ClearDetail(slot)
        return 
    end
    if not slot.ilevel then 
        slot.ilevel = FontString("SpaUIItemLevel", slot, nil, "ChatFontSmall")
        slot.ilevel:SetPoint("BOTTOMRIGHT")
        slot.ilevel:SetTextColor(NORMAL_FONT_COLOR:GetRGB())
    end
    slot.ilevel:SetText(GetItemLevel(GetInventoryItemLink("player", self:GetID())))
end