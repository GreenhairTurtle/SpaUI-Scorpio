-- ----------------------------------------------------------------------------
-- RaidFrameIcons by Szandos
-- Continued by Soyier
-- ----------------------------------------------------------------------------
-- 团队框架标记 修改自Raid Frame Icons
Scorpio "SpaUI.Features.RaidFrameMarker" ""

RaidTargetMarkers = {}

function UpdateRaidTargetIcon(frame)
    local unit = frame.unit
    local name = frame:GetName()

    if not name or not unit or not UnitExists(unit) then return end
    local marker = GetRaidTargetIndex(unit)

    if not RaidTargetMarkers[name] then
        RaidTargetMarkers[name] = {}
        RaidTargetMarkers[name].icon = Texture(name.."Marker", frame, "OVERLAY")
        RaidTargetMarkers[name].icon:SetPoint("CENTER", frame, 0, 0)
        RaidTargetMarkers[name].icon:SetWidth(28)
        RaidTargetMarkers[name].icon:SetHeight(28)
    end

    if marker ~= RaidTargetMarkers[name].marker then
        RaidTargetMarkers[name].marker = marker
        if marker then
            RaidTargetMarkers[name].icon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_" .. marker)
            RaidTargetMarkers[name].icon:Show()
        else
            RaidTargetMarkers[name].icon:Hide()
        end
    end

    if frame.name and frame.name:IsObjectType("FontString") then
        if UnitIsGroupLeader(unit) then
            frame.name:SetFontObject(GameFontNormalSmall)
        else
            frame.name:SetFontObject(GameFontHighlightSmall)
        end
    end
end

__Async__()
function OnEnable()
    local function Debounce()
        local result = Wait(0.25, "RAID_TARGET_UPDATE", "GROUP_ROSTER_UPDATE", "PLAYER_ENTERING_WORLD")
        return type(result) ~= "number"
    end 

    while Wait("RAID_TARGET_UPDATE", "GROUP_ROSTER_UPDATE", "PLAYER_ENTERING_WORLD") do
        while Debounce() do
            -- do nothing
        end
        CompactRaidFrameContainer_ApplyToFrames(CompactRaidFrameContainer, "normal", UpdateRaidTargetIcon)
    end
end