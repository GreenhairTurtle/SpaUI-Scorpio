-- 小地图ping，修改自SexyMap
Scorpio "SpaUI.Features.MinimapPing" ""

function CreateMinimapFrame()
    MinimapPingFrame = Frame("SpaUIMinimapPingFrame", Minimap)
    MinimapPingFrame:SetPoint("TOP", Minimap, "TOP", 0, -10)
    FontString("name", MinimapPingFrame)
    local anim = AnimationGroup("anim",MinimapPingFrame)
    Alpha("alpha",anim)
    MinimapPingFrame:Hide()

    function anim:OnFinished()
        MinimapPingFrame:Hide()
    end

    Style[MinimapPingFrame]     = {
        size                    = Size(100,20),
        backdrop                = {
            bgFile              = [[Interface\Tooltips\UI-Tooltip-Background]],
            edgeFile            = [[Interface\Tooltips\UI-Tooltip-Border]],
            tile                = true,
            edgeSize            = 16,
            insets              = { left = 4, right = 4, top = 4, bottom = 4 }
        },
        backdropColor           = ColorType(0, 0, 0, 0.8),
        backdropBorderColor     = ColorType(0, 0, 0, 0.6),
        frameStrata             = "HIGH",
        fadeout                 = {
            duration            = 2.5,
            autohide            = true
        },

        name = {
            setAllPoints        = true,
            fontobject          = GameFontNormalSmall
        },

        anim = {
            alpha = {
                duration        = 2.5,
                fromAlpha       = 1,
                toAlpha         = 0,
                order           = 1
            }
        }
    }
end

function OnEnable(self)
    CreateMinimapFrame()
end

__SystemEvent__('MINIMAP_PING')
function OnMinimapPing(unit)
    if not unit then return end
    if not MinimapPingFrame then return end
    local class = select(2, UnitClass(unit))
    local color = class and Color[class] or Color.GRAY

    local name = GetUnitName(unit, false)
    if not name then return end
    -- 添加小队信息
    if IsInRaid() then
        for i = 1, GetNumGroupMembers() do
            local member, _, subgroup = GetRaidRosterInfo(i)
            if member == name and subgroup then
                name = L["minimap_ping_who_group"]:format(subgroup, name)
                break
            end
        end
    end

    name = FormatText(color,name)

    MinimapPingFrame.name:SetText(name)
    MinimapPingFrame:SetWidth(MinimapPingFrame.name:GetStringWidth() +14)
    MinimapPingFrame:SetHeight(MinimapPingFrame.name:GetStringHeight() + 10)
    MinimapPingFrame.anim:Stop()
    MinimapPingFrame:Show()
    MinimapPingFrame.anim:Play()
end
