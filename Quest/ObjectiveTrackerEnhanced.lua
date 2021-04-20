Scorpio "SpaUI.Quest.QuestTrackerEnhanced" ""

function OnLoad(self)
    _Enabled = _Config.Quest.ObjectiveTrackerEnhanced.Enable
end

-- 追踪栏标题更换材质
__AddonSecureHook__ "Blizzard_ObjectiveTracker"
function ObjectiveTracker_Initialize()
    if ObjectiveTrackerFrame.MODULES_UI_ORDER then
        local color = Color.PLAYER
        local r, g, b = color.r, color.g, color.b
        for _, module in ipairs(ObjectiveTrackerFrame.MODULES_UI_ORDER) do
            local header = module.Header
            -- 修改自Ndui
            header.Background:SetTexture("Interface\\LFGFrame\\UI-LFG-SEPARATOR")
            header.Background:SetTexCoord(0, 0.66, 0.25, 0.31)
            header.Background:SetVertexColor(r, g, b, 0.7)
            header.Background:ClearAllPoints()
            header.Background:SetPoint("BOTTOM", 0, -4)
            header.Background:SetSize(240, 4)
        end
    end
end