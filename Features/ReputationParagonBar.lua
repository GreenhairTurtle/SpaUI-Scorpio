Scorpio "SpaUI.Features.ReputationParagonBar" ""

-- 感谢Paragon Reputation提供了颜色
PARAGON_COLOR = Color(0, 0.5, 0.9)
PARAGON_STANDING_LABLE = L["reputation_paragon_standing_text"]

__SecureHook__()
function ReputationFrame_Update()
    for i=1, NUM_FACTIONS_DISPLAYED do        
		local factionRow = _G["ReputationBar"..i]
		local factionBar = _G["ReputationBar"..i.."ReputationBar"]
		local factionStanding = _G["ReputationBar"..i.."ReputationBarFactionStanding"]
        local factionIndex = factionRow.index

        if factionIndex then
            local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID = GetFactionInfo(factionIndex)
            if ( factionID and C_Reputation.IsFactionParagon(factionID) ) then
                local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
                factionStanding:SetText(PARAGON_STANDING_LABLE)
                factionRow.standingText = PARAGON_STANDING_LABLE
                factionBar:SetMinMaxValues(0, threshold)
                local barValue = currentValue % threshold
                factionBar:SetValue(barValue)
                factionBar:SetStatusBarColor(PARAGON_COLOR.r, PARAGON_COLOR.g, PARAGON_COLOR.b)
                factionRow.rolloverText = HIGHLIGHT_FONT_COLOR_CODE.." "..format(REPUTATION_PROGRESS_FORMAT, BreakUpLargeNumbers(barValue), BreakUpLargeNumbers(threshold))..FONT_COLOR_CODE_CLOSE

                if (factionIndex == GetSelectedFaction() and ReputationDetailFrame:IsShown()) then
                    ReputationDetailFactionName:SetText(name..FormatText(PARAGON_COLOR, "x"..floor(currentValue/threshold)))
                end
			end
        end
    end
end

__SecureHook__()
function ReputationParagonFrame_SetupParagonTooltip(frame)
    local currentValue, threshold, _, _, tooLowLevelForParagon = C_Reputation.GetFactionParagonInfo(frame.factionID)
    if not tooLowLevelForParagon and EmbeddedItemTooltipTextLeft1 then
        EmbeddedItemTooltipTextLeft1:SetText(PARAGON_STANDING_LABLE..FormatText(PARAGON_COLOR, "x"..floor(currentValue/threshold))) 
    end
end