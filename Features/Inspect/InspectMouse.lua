-- 修改自TinyInspect
Scorpio "SpaUI.Features.Inspect.Mouse" ""

function OnEnable(self)
    GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)
end

function OnTooltipSetUnit(self)
    local _, unit = self:GetUnit()
    if not unit then
        return
    end
    if not CanInspect(unit) then
        return
    end
    local guid = UnitGUID(unit)
    if not guid then
        return
    end
    local needRefresh = NeedRefreshInspectInfo(unit)
    if needRefresh then
        if not UnitIsVisible(unit) or UnitIsDeadOrGhost("player") or UnitOnTaxi("player") then
            return
        end
        if InspectFrame and InspectFrame:IsShown() then
            return
        end
        ClearInspectPlayer()
        NotifyInspect(unit)
    elseif needRefresh == false then
        AddInspectDataToTooltip(guid)
    end
end

__SystemEvent__ "SPAUI_INSPECT_READY"
function AddInspectDataToTooltip(guid)
    local _, unit = GameTooltip:GetUnit()
    if not unit then
        return
    end
    if not guid or UnitGUID(unit) ~= guid then
        return
    end
    local data = InspectCache[guid]
    if data and data ~= -1 and data.ilevel and data.ilevel > 0 then
        local levelText = STAT_AVERAGE_ITEM_LEVEL .. ":" .. data.ilevel
        TooltipAddDoubleLine(levelText, data.specName, Color.WHITE, Color[data.class or "WHITE"])
        GameTooltip:Show()
    end
end