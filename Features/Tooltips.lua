-- 各种ID，修改自idTip
Scorpio "SpaUI.Features.Tooltips" ""

-- 法术ID
SpellIDPrefix = L["tooltip_spell_id"]
-- NPC ID
NpcIDPrefix = L["tooltip_npc_id"]
-- 货币ID
CurrencyIDPrefix = L["tooltip_currency_id"]
-- 任务ID
TaskIDPrefix = L["tooltip_task_id"]
-- 物品id
ItemIDPrefix = L["tooltip_item_id"]

-- Tooltip添加id
function AddLine(tooltip, id, prefix)
    if not id or id == "" then return end
    if tooltip == GameTooltip and not IsAltKeyDown() then
        return
    end
    id = HIGHLIGHT_FONT_COLOR_CODE .. id .. FONT_COLOR_CODE_CLOSE
    tooltip:AddLine("")
    tooltip:AddDoubleLine(prefix, id)
    tooltip:Show()
end

__SecureHook__(GameTooltip)
function SetUnitBuff(self,...)
    local id = select(10, UnitBuff(...))
    AddLine(self, id, SpellIDPrefix)
end

__SecureHook__(GameTooltip)
function SetUnitDebuff(self,...)
    local id = select(10, UnitDebuff(...))
    AddLine(self, id, SpellIDPrefix)
end

__SecureHook__(GameTooltip)
function SetUnitAura(self,...)
    local id = select(10, UnitAura(...))
    AddLine(self, id, SpellIDPrefix)
end

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
    -- 天赋面板会出现两次，这里过滤掉，来自idTip
    local frame, text
    for i = 1, 15 do
        frame = _G[self:GetName() .. "TextLeft" .. i]
        if frame then text = frame:GetText() end
        if text and string.find(text, SpellIDPrefix) then return end
    end
    local id = select(2, self:GetSpell())
    AddLine(self, id, SpellIDPrefix)
end)

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    if C_PetBattles.IsInBattle() then return end
    local unit = select(2, self:GetUnit())
    if unit then
        local guid = UnitGUID(unit) or ""
        local id = GetNpcID(guid)
        if id and guid:match("%a+") ~= "Player" then
            AddLine(GameTooltip, id, NpcIDPrefix)
        end
    end
end)

__SecureHook__(GameTooltip)
function SetCurrencyToken(self,index)
    local id = tonumber(string.match(C_CurrencyInfo.GetCurrencyListLink(index),"currency:(%d+)"))
    AddLine(self, id, CurrencyIDPrefix)
end

__SecureHook__(GameTooltip)
function SetCurrencyByID(self,id)
    AddLine(self, id, CurrencyIDPrefix)
end

__SecureHook__(GameTooltip)
function SetCurrencyTokenByID(self,id)
    AddLine(self, id, CurrencyIDPrefix)
end

__SecureHook__()
function QuestMapLogTitleButton_OnEnter(self)
    local id = C_QuestLog.GetQuestIDForLogIndex(self.questLogIndex)
    AddLine(GameTooltip, id, TaskIDPrefix)
end

__SecureHook__()
function TaskPOI_OnEnter(self)
    if self and self.questID then
        AddLine(GameTooltip, self.questID, TaskIDPrefix)
    end
end

__SecureHook__(GameTooltip)
function SetToyByItemID(self, id)
    AddLine(self, id, ItemIDPrefix)
end

local function attachItemTooltip(self)
    local link = select(2, self:GetItem())
    if not link then return end
    local itemString = string.match(link, "item:([%-?%d:]+)")
    if not itemString then return end

    local id = string.match(link, "item:(%d*)")
    if (id == "" or id == "0") and TradeSkillFrame ~= nil and TradeSkillFrame:IsVisible() and GetMouseFocus().reagentIndex then
        local selectedRecipe = TradeSkillFrame.RecipeList:GetSelectedRecipeID()
        for i = 1, 8 do
            if GetMouseFocus().reagentIndex == i then
                id = C_TradeSkillUI.GetRecipeReagentItemLink(selectedRecipe, i):match("item:(%d*)") or nil
                break
            end
        end
    end

    if id then
        AddLine(self, id, ItemIDPrefix)
    end
end

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
