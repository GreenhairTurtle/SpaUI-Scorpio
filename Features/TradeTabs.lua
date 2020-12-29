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

namespace "SpaUI.Features.Trade"

__Sealed__() __Template__(SecureCheckButton)
class "TradeTab" {
    Border              = Texture,
    Icon                = Texture,
    Cover               = Frame,
    Cd                  = Cooldown
}

Style.UpdateSkin("Default",{
    [TradeTab]              = {
        size                = Size(32,32),
        highlightTexture    = {
            file            = [[Interface\Buttons\ButtonHilight-Square]],
            alphamode       = "ADD",
            setAllPoints    = true
        },
        checkedTexture    = {
            file            = [[Interface\Buttons\CheckButtonHilight]],
            alphamode       = "ADD",
            setAllPoints    = true
        },

        Border              = {
            file            = [[Interface\SpellBook\SpellBook-SkillLineTab]],
            drawlayer       = "BORDER",
            size            = Size(64,64),
            location        = {
                Anchor("TOPLEFT",-3,11)
            }
        },

        -- todo TextureSubLevel
        Icon                = {
            file            = [[INTERFACE\HELPFRAME\REPORTLAGICON-CHAT]],
            drawlayer       = "ARTWORK",
            size            = Size(30,30),
            location        = {
                Anchor("CENTER")
            },
            texCoords      = { left=0.03125, right=0.96875, top= 0.03125, bottom= 0.96875 }
        },

        Cover               = {
            setAllPoints    = true,
            enableMouse     = true
        },

        Cd                  = {
            setAllPoints        = true,
            visible             = hide,
            swipeTexture        = {
                file            = "",
                color           = ColorType(0, 0, 0, 0.8)
            },
            edgeTexture         = {
                file            = [[Interface\Cooldown\edge]]
            },
            blingTexture        = {
                file            = [[Interface\Cooldown\star4]],
                color           = ColorType(0.3, 0.6, 1, 0.8)
            }
        }
    }
})

__Async__()
function OnEnable(self)
    NextEvent('TRADE_SKILL_SHOW')
    TradeTabsInitialization()
end

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

local function AddSpellInfo(infos,name,icon,spellID,slotID,canCastSpellDirect)
    local info = {}
    info.name = name
    info.icon = icon
    info.spellID = spellID
    info.slotID = slotID
    info.canCastSpellDirect = canCastSpellDirect
    tinsert(infos,info)
end

local function SetTradeTab(tab)
    local spellInfo = tab.spellInfo
    local name,icon,slotID,canCastSpellDirect = spellInfo.name,spellInfo.icon,spellInfo.slotID,spellInfo.canCastSpellDirect
    Style[tab].Icon.fileID = icon
    tab:SetScript("OnEnter",function(self)
        GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
        GameTooltip:SetSpellBookItem(slotID,BOOKTYPE_PROFESSION)
        GameTooltip:Show()
    end)
    tab:SetScript("OnLeave",function(self)
        GameTooltip:Hide()
    end)

    if canCastSpellDirect then
        tab:SetScript("OnClick",function(self)
            CastSpell(slotID,BOOKTYPE_PROFESSION)
        end)
    else
        tab:SetAttribute("type","spell")
        tab:SetAttribute("spell",name)
    end
end

-- 创建Trade Tab
function CreateTradeTabs(spellInfos)
    if not TradeSkillFrame then
        return
    end
    local tabContainer = Frame("SpaUITradeTabContainer",TradeSkillFrame)

    tabContainer:SetScript("OnShow",function(self)
        self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
        UpdateTradeTab()
    end)
    tabContainer:SetScript("OnHide",function(self)
        self:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED")
    end)
    tabContainer:SetScript("OnEvent",function ()
        UpdateTradeTab()
    end)

    Style[tabContainer] = {
        width           = 50,
        location        = {
            Anchor("TOPLEFT",0,0,TradeSkillFrame:GetName(),"TOPRIGHT"),
            Anchor("BOTTOMLEFT",0,0,TradeSkillFrame:GetName(),"BOTTOMRIGHT")
        }
    }

    TradeTabs = {}
    for i=1,#spellInfos do
        local spellInfo = spellInfos[i]
        local tab = TradeTab("TradeTab"..i,tabContainer)
        tab.spellInfo = spellInfo
        Style[tab].Location = {Anchor("LEFT"),Anchor("TOP",0,-i*50)}
        SetTradeTab(tab)
        tinsert(TradeTabs,tab)
    end
    tabContainer:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
    UpdateTradeTab()
end

function TradeTabsInitialization()
    local prof1,prof2,_,fishing,cooking = GetProfessions()
    local spellOffsets = {}
    AddSpellOffsetNeededShow(spellOffsets,prof1)
    AddSpellOffsetNeededShow(spellOffsets,prof2)
    AddSpellOffsetNeededShow(spellOffsets,cooking)
    AddSpellOffsetNeededShow(spellOffsets,fishing)
    local spellInfos = {}
    for i=1,#spellOffsets do
        local spellOffset = spellOffsets[i]
        local name, _, icon, _, _, _, spellID = GetSpellInfo(spellOffset,"spell")
        local passive = IsPassiveSpell(spellOffset,BOOKTYPE_PROFESSION)
        if not passive then
            AddSpellInfo(spellInfos,name,icon,spellID,spellOffset,i==1)
        end
    end
    if #spellInfos>0 then   
        CreateTradeTabs(spellInfos)
    end
end

function UpdateTradeTab()
    if not TradeTabs then
        return
    end
    for _,tab in pairs(TradeTabs) do
        local spellID = tab.spellInfo.spellID
        if IsCurrentSpell(spellID) then 
            Style[tab].Checked = true
            Style[tab].Cover.Visible = true
        else
            Style[tab].Checked = false
            Style[tab].Cover.Visible = false
        end
        local start,duration = GetSpellCooldown(spellID)
        if start and duration and duration > 1.5 then
            tab.Cd:SetCooldown(start,duration)
        end
    end
end