Scorpio "SpaUI" ""

SpaUIScanningTooltip = CreateFrame('GameTooltip', 'SpaUIScanningTooltip')
SpaUIScanningTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
SpaUIScanningTooltip:AddFontStrings(SpaUIScanningTooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"),
    SpaUIScanningTooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText"))

ItemLevelDB = {}

-- 字符串染色
__Arguments__{
    Variable("text", NEString),
    Variable("r",ColorFloat),
    Variable("g",ColorFloat),
    Variable("b",ColorFloat),
    Variable("a",ColorFloat,true,1)
}
function ColorText(text,r,g,b,a)
    return Color(r,g,b,a)..text..Color.CLOSE
end

__Arguments__{Color, NEString}
function FormatText(color, text)
    return color..text..Color.CLOSE
end

__Arguments__{String, String, Color/nil, Color/nil}
function TooltipAddDoubleLine(leftText, rightText, leftColor, rightColor)
    GameTooltip:AddDoubleLine(leftText, rightText, 
    leftColor and leftColor.r, leftColor and leftColor.g, leftColor and leftColor.b,
    rightColor and rightColor.r, rightColor and rightColor.g, rightColor and rightColor.b)
end

function GetNpcID(guid)
    return tonumber(strmatch((guid or ""), "%-(%d-)%-%x-$"))
end

-- 是否为中国区
function IsChinaRegion()
    return GetCurrentRegion() == 5
end

-- 获取物品等级 修改自Ndui
function GetItemLevel(itemLink)
    if not itemLink then
        return nil
    end
    if ItemLevelDB[itemLink] then return ItemLevelDB[itemLink] end

    SpaUIScanningTooltip:ClearLines()
    SpaUIScanningTooltip:SetHyperlink(itemLink)

    local fontString = _G['SpaUIScanningTooltipTextLeft1']
    local text = fontString and fontString:GetText()
    if text == RETRIEVING_ITEM_INFO then
        return nil
    end

    for i = 2, 5 do
        fontString = _G['SpaUIScanningTooltipTextLeft' .. i]
        text = fontString and fontString:GetText()
        if text then
            local found = strfind(text, STAT_AVERAGE_ITEM_LEVEL)
            if found then
                local level = strmatch(text, "(%d+)%)?$")
                ItemLevelDB[itemLink] = tonumber(level)
                break
            end
        end
    end

    return ItemLevelDB[itemLink]
end