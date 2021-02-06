Scorpio "SpaUI.Quest.QuestTrackerEnhanced" ""

-- 暂时挂起 2021/02/07
__SecureHook__()
function ObjectiveTrackerBlockHeader_OnEnter(self)
    local block = self:GetParent()
    local moduleName = block.module.friendlyName
    -- 战役、任务
    if moduleName == "QUEST_TRACKER_MODULE" or moduleName == "CAMPAIGN_QUEST_TRACKER_MODULE" then
        if not IsInGroup() then
		    GameTooltip:SetOwner(block, "ANCHOR_TOPLEFT");
        end
        GameTooltip:AddDoubleLine(L["tooltip_task_id"], HIGHLIGHT_FONT_COLOR_CODE..block.id..FONT_COLOR_CODE_CLOSE)
        GameTooltip:Show()
    end
end