-- 参考了NDUI
Scorpio "SpaUI.Features.TradeTabs" ""

local GetSpellCooldown,CastSpell,IsCurrentSpell = GetSpellCooldown,CastSpell,IsCurrentSpell
local tinsert = tinsert

-- 需要去重的专业技能
SkillLineNeedDistinct = {
	[171] = true, -- 炼金
	[202] = true, -- 工程
	[182] = true, -- 草药
	[393] = true, -- 剥皮
	[356] = true, -- 钓鱼
}

__Async__()
function OnEnable(self)
    NextEvent('TRADE_SKILL_SHOW')
    CreateTradeTabContainer()
end

-- 创建Trade Tab
__NoCombat__()
function CreateTradeTabContainer()
    if not TradeSkillFrame then
        return
    end
    
    TabContainer = Frame("SpaUITradeTabContainer",TradeSkillFrame)
    Log("TradeTabs Create TradeTabContainer")

    TabContainer.OnShow = function(self)  
        Log("TradeContainer OnShow")
        self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
        UpdateTradeTabs()
    end

    TabContainer.OnHide = function(self)
        Log("TradeContainer OnHide")
        self:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED")
    end

    TabContainer.OnEvent = function()
        UpdateTradeTabs()
    end

    TradeTabs = {}

    TabContainer:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
    CreateOrChangeTradeTabs()
    UpdateTradeTabs()

    Style[TabContainer] = {
        width           = 50,
        location        = {
            Anchor("TOPLEFT",0,0,TradeSkillFrame:GetName(),"TOPRIGHT"),
            Anchor("BOTTOMLEFT",0,0,TradeSkillFrame:GetName(),"BOTTOMRIGHT")
        }
    }
end

-- 记录专业技能的相关信息
local function AddSpellInfo(name,icon,spellID,slotID,canCastSpellDirect)
    local info = {}
    info.name = name
    info.icon = icon
    info.spellID = spellID
    info.slotID = slotID
    info.canCastSpellDirect = canCastSpellDirect
    tinsert(TradeTabs.SpellInfos,info)
end

-- 记录专业技能在技能书中的offset
local function AddSpellOffsetNeededShow(table,professionIndex)
    if not professionIndex then return end 
    
    local _,_,_,_,numAbilities,spellOffset,skillLine = GetProfessionInfo(professionIndex)
    numAbilities = SkillLineNeedDistinct[skillLine] and 1 or numAbilities
    if numAbilities > 0 then   
        for i=1, numAbilities do
            tinsert(table,spellOffset+i)
        end
    end
end

-- 创建或更改按钮
__AsyncSingle__()
__SystemEvent__ "SKILL_LINES_CHANGED"
function CreateOrChangeTradeTabs()
    if not TabContainer or not TradeTabs then return end
    local prof1,prof2,_,fishing,cooking = GetProfessions()
    if not (prof1 ~= TradeTabs["prof1"] or prof2 ~= TradeTabs["prof2"] or fishing ~= TradeTabs["fishing"] or cooking ~= TradeTabs["cooking"]) then
        return
    end
    -- 这个标识符用于一种情况：
    -- 战斗状态下专业技能有变更，比如遗忘了某专业
    -- 此时显示TradeTab，鼠标移入某个Tab时显示鼠标提示会取原先的spellOffset
    -- 这个时候offset是不对的，所以根据这个标识符进行判断
    TradeTabChanging = true

    TradeTabs["prof1"] = prof1
    TradeTabs["prof2"] = prof2
    TradeTabs["fishing"] = fishing
    TradeTabs["cooking"] = cooking

    Log("TradeTabs Create or Change TradeTabs")

    NoCombat()
    -- 记录专业技能在技能书中的offset
    local spellOffsets = {}
    AddSpellOffsetNeededShow(spellOffsets,prof1)
    AddSpellOffsetNeededShow(spellOffsets,prof2)
    AddSpellOffsetNeededShow(spellOffsets,cooking)
    AddSpellOffsetNeededShow(spellOffsets,fishing)

    -- 记录专业技能的相关信息
    TradeTabs.SpellInfos = {}
    for i=1,#spellOffsets do
        local spellOffset = spellOffsets[i]
        local name, _, icon, _, _, _, spellID = GetSpellInfo(spellOffset,"spell")
        local passive = IsPassiveSpell(spellOffset,BOOKTYPE_PROFESSION)
        if not passive then
            AddSpellInfo(name,icon,spellID,spellOffset,i==1)
        end
    end

    local count = max(#TradeTabs.SpellInfos,#TradeTabs)

    for i = 1, count do
        local tab = TradeTabs[i]
        local spellInfo = TradeTabs.SpellInfos[i]
        if not tab and spellInfo then
            tab = TradeTab("TradeTab"..i,TabContainer)
            Log("TradeTabs Create TradeTab"..i)
            TradeTabs[i] = tab
        end
        SetTradeTab(i)
    end

    TradeTabChanging = false
    UpdateTradeTabs()
end

-- 设置按钮
__NoCombat__()
function SetTradeTab(index)
    Log("TradeTabs Set TradeTab"..index)
    local spellInfo = TradeTabs.SpellInfos[index]
    local tab = TradeTabs[index]
    if not tab then return end
    if not spellInfo and tab then
        tab:Hide()
        return
    end

    tab.spellInfo = spellInfo
    local name,icon,canCastSpellDirect = spellInfo.name,spellInfo.icon,spellInfo.canCastSpellDirect

    tab.OnEnter = function(self)
        if TradeTabChanging then return end
        GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
        GameTooltip:SetSpellBookItem(self.spellInfo.slotID,BOOKTYPE_PROFESSION)
        GameTooltip:Show()
    end

    tab.OnLeave = function(self)
        GameTooltip:Hide()
    end

    if canCastSpellDirect then
        tab.OnClick = function(self)
            if TradeTabChanging then return end
            CastSpell(self.spellInfo.slotID,BOOKTYPE_PROFESSION)
        end
    else
        tab:SetAttribute("type","spell")
        tab:SetAttribute("spell",name)
    end

    tab.Cooldown:Clear()
    tab.Cover:Hide()
    tab:Show()
    tab:SetChecked(false)

    Style[tab] = {
        location = {Anchor("LEFT"),Anchor("TOP",0,-index * 50)},
        Icon     = {
            fileID  = icon
        }
    }
end

-- 更新按钮状态
function UpdateTradeTabs()
    for _,tab in ipairs(TradeTabs) do
        local spellID = tab.spellInfo.spellID
        if IsCurrentSpell(spellID) then
            tab:SetChecked(true)
            tab.Cover:Show()
        else
            tab:SetChecked(false)
            tab.Cover:Hide()
        end
        local start,duration = GetSpellCooldown(spellID)
        if start and duration and duration > 1.5 then
            tab.Cooldown:SetCooldown(start,duration)
            tab:SetChecked(false)
        end
    end
end