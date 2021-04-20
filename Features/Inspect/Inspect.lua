-- 修改自TinyInspect
Scorpio "SpaUI.Features.Inspect" ""

INSPECT_DATA_CAPACITY = 100
INSPECT_DATA_REQUEST_TIMEOUT = 3
INSPECT_DATA_EXPIRED_TIME = 5 * 60
INSPECT_DATA_RETRY_COUNT = 5
Enum = _G["Enum"]

function OnEnable(self)
    InspectCache = LruCache(INSPECT_DATA_CAPACITY)
    RequestQueue = {}
end

__SystemEvent__()
function INSPECT_READY(guid)
    if not guid then return end
    -- pop request queue
    local request = RequestQueue[guid]
    RequestQueue[guid] = nil

    local data = InspectCache[guid]
    if not data or data == -1 then
        data = {}
        InspectCache[guid] = data
    end
    data.expired = time() + INSPECT_DATA_EXPIRED_TIME
    if request and request.unit then
        -- 取到数据的时候判断unit对应的gui是否仍是原先那个
        if UnitExists(request.unit) and guid == UnitGUID(request.unit) then
            PutUnitInfo(data, request.unit)
            if CheckInspectDataValid(data) then
                FireSystemEvent("SPAUI_INSPECT_READY", guid)
            else
                -- 重试
                if (data.retryCount or 0) >= INSPECT_DATA_RETRY_COUNT then
                    InspectCache[guid] = nil
                else
                    data.retryCount = (data.retryCount or 0) + 1
                    ClearInspectPlayer()
                    NotifyInspect(request.unit)
                end
            end
        else
            -- unit对应guid变更，标记为empty
            data.empty = true
        end
    end
end


-- 获取Unit信息，只能在INSPECT_READY后调用
function PutUnitInfo(data, unit)
    data.class = select(2, UnitClass(unit))
    data.name, data.realm = UnitName(unit)
    data.realm = data.realm or GetRealmName()
    data.level = UnitLevel(unit)
    data.specID, data.specName = GetSpecInfo(unit)
    data.ilevel = GetUnitItemLevel(unit) or 0
    data.empty = false
end

-- 获取专精信息
function GetSpecInfo(unit)
    local specID, specName
    if unit == "player" then
        local specIndex = GetSpecialization()
        specID, specName = GetSpecializationInfo(specIndex)
    else
        specID = GetInspectSpecialization(unit)
        if specID and specID > 0 then
            specID, specName = GetSpecializationInfoByID(specID)
        end
    end
    return specID, specName
end

-- 检查InspectData是否合法
function CheckInspectDataValid(data)
    local valid = (data and data ~= -1) and not (not data.specID or data.specID <= 0 or data.ilevel <= 0)
    if valid then
        data.retryCount = 0
    end
    return valid
end

-- 刷新自己信息
function RefreshPlayerInfo(guid)
    guid = guid or UnitGUID("player")
    local data = InspectCache[guid]
    if not data or data == -1 then
        data = {}
        InspectCache[guid] = data
    end
    data.expired = time() + INSPECT_DATA_EXPIRED_TIME
    PutUnitInfo(data, "player")
    return data
end

-- 检测是否需要刷新观察信息
-- return true:需要刷新 false:不需要 nil:非法
function NeedRefreshInspectInfo(unit)
    if not unit or not UnitExists(unit) then return end
    local guid = UnitGUID(unit)
    if not guid then return end

    if UnitIsUnit(unit, "player") then
        RefreshPlayerInfo(guid)
        return false
    end

    local request = RequestQueue[guid]
    -- 请求中，不需要刷新
    if request and request.expired > time() then
        return false
    end

    local data = InspectCache[guid]
    if data and data ~= -1 and data.expired > time() then
        if data.empty then
            PutUnitInfo(data, unit)
        end
        if not CheckInspectDataValid(data) then
            return true
        end
        return false
    else
        -- 没有数据或超时
        return true
    end
end

__SecureHook__(_G, "NotifyInspect")
function Hook_NotifyInspect(unit)
    local guid = UnitGUID(unit)
    if guid then
        RequestQueue[guid] = RequestQueue[guid] or {}
        local request = RequestQueue[guid]
        request.unit = unit
        request.expired = time() + INSPECT_DATA_REQUEST_TIMEOUT
    end
end

-- 获取装等，抄的Ndui
function GetUnitItemLevel(unit)
    if not unit then
        return
    end

    local class = select(2, UnitClass(unit))
    local ilvl, boa, total, haveWeapon, twohand = 0, 0, 0, 0, 0
    local delay, mainhand, offhand, hasArtifact
    local weapon1, weapon2 = 0, 0

    for i = 1, 17 do
        if i ~= 4 then
            local itemTexture = GetInventoryItemTexture(unit, i)

            if itemTexture then
                local itemLink = GetInventoryItemLink(unit, i)

                if not itemLink then
                    delay = true
                else
                    local _, _, quality, level, _, _, _, _, slot = GetItemInfo(itemLink)
                    if (not quality) or (not level) then
                        delay = true
                    else
                        if quality == Enum.ItemQuality.Heirloom then
                            boa = boa + 1
                        end

                        if unit ~= "player" then
                            level = GetItemLevel(itemLink) or level
                            if i < 16 then
                                total = total + level
                            elseif i > 15 and quality == Enum.ItemQuality.Artifact then
                                local relics = {select(4, strsplit(":", itemLink))}
                                for i = 1, 3 do
                                    local relicID = relics[i] ~= "" and relics[i]
                                    local relicLink = select(2, GetItemGem(itemLink, i))
                                    if relicID and not relicLink then
                                        delay = true
                                        break
                                    end
                                end
                            end

                            if i == 16 then
                                if quality == Enum.ItemQuality.Artifact then
                                    hasArtifact = true
                                end

                                weapon1 = level
                                haveWeapon = haveWeapon + 1
                                if slot == "INVTYPE_2HWEAPON" or slot == "INVTYPE_RANGED" or
                                    (slot == "INVTYPE_RANGEDRIGHT" and class == "HUNTER") then
                                    mainhand = true
                                    twohand = twohand + 1
                                end
                            elseif i == 17 then
                                weapon2 = level
                                haveWeapon = haveWeapon + 1
                                if slot == "INVTYPE_2HWEAPON" then
                                    offhand = true
                                    twohand = twohand + 1
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if not delay then
        if unit == "player" then
            ilvl = select(2, GetAverageItemLevel())
        else
            if hasArtifact or twohand == 2 then
                local higher = max(weapon1, weapon2)
                total = total + higher * 2
            elseif twohand == 1 and haveWeapon == 1 then
                total = total + weapon1 * 2 + weapon2 * 2
            elseif twohand == 1 and haveWeapon == 2 then
                if mainhand and weapon1 >= weapon2 then
                    total = total + weapon1 * 2
                elseif offhand and weapon2 >= weapon1 then
                    total = total + weapon2 * 2
                else
                    total = total + weapon1 + weapon2
                end
            else
                total = total + weapon1 + weapon2
            end
            ilvl = total / 16
        end

        if ilvl > 0 then
            ilvl = floor(10 * ilvl + 0.5) / 10
        end
    else
        ilvl = nil
    end

    return ilvl
end