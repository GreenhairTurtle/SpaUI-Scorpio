-- 修改自TinyInspect
Scorpio "SpaUI.Features.Inspect.Party" ""

function OnEnable()
    PartyCache = {}
end

-- 小队变化时触发
__SystemEvent__()
function GROUP_ROSTER_UPDATE()
    if not IsInGroup() then
        wipe(PartyCache)
        return 
    end
    if IsInRaid() then return end
    RefreshPartyInspectData()
end

__SystemEvent__()
function UNIT_INVENTORY_CHANGED(unit)
    RefreshPartyInspectData()
end

__SystemEvent__()
function PLAYER_SPECIALIZATION_CHANGED(unit)
    RefreshPartyInspectData()
end

--通报
__SystemEvent__ "SPAUI_INSPECT_READY"
function RefreshPartyInspectData()
    if not IsInGroup() or IsInRaid() then return end
    for i = 1, GetNumSubgroupMembers() do
        local unit = "party"..i
        if not CanInspect(unit) then return end
        local guid = UnitGUID(unit)
        if not guid then return end
        local data = InspectCache[guid]
        if not CheckInspectDataValid(data) then
            ClearInspectPlayer()
            NotifyInspect(unit)
            return
        end
    end
    SendPartyInspectData()
end

local function GetRoleIcon(unit)
    local role = UnitGroupRolesAssigned(unit)
    if (role == "TANK") then
        return "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:14:14:0:0:64:64:0:19:22:41|t"
    elseif (role == "HEALER") then
        return "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:14:14:0:0:64:64:20:39:1:20|t"
    elseif (role == "DAMAGER") then
        return "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:14:14:0:0:64:64:20:39:22:41|t"
    else
        return ""
    end
end

-- 发送队伍信息
function SendPartyInspectData()
    if not IsInGroup() then return end
    if PartyCache.broadcastTime and time() - PartyCache.broadcastTime < 5 then return end

    local broadcast = false
    for i = 1, GetNumSubgroupMembers() do
        local unit = "party"..i
        local guid = UnitGUID(unit)
        if not guid then return end
        if not PartyCache[guid] then
            broadcast = true
            break
        end
    end

    if not broadcast then return end

    local num, pattern = 30, "%s %.1f |c%s%s|r |cffffffff%s|r"
    DEFAULT_CHAT_FRAME:AddMessage(string.rep("-", num), 1, 0.752, 0.796)
    local data = RefreshPlayerInfo()
    DEFAULT_CHAT_FRAME:AddMessage(format(pattern,
            GetRoleIcon("player"),
            data.ilevel,
            select(4, GetClassColor(data.class)),
            data.name,
            data.specName
        ), 1, 0.82, 0)
    for i = 1, GetNumSubgroupMembers() do
        local unit = "party"..i
        local guid = UnitGUID(unit)
        if not guid then return end
        local data = InspectCache[guid]
        PartyCache[guid] = true
        DEFAULT_CHAT_FRAME:AddMessage(format(pattern,
                GetRoleIcon(unit),
                data.ilevel,
                select(4, GetClassColor(data.class)),
                data.name,
                data.specName
            ), 1, 0.82, 0)
    end
    DEFAULT_CHAT_FRAME:AddMessage(string.rep("-", num), 1, 0.752, 0.796)
    PartyCache.broadcastTime = time()
end