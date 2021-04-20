Scorpio "SpaUI.UnitFrames.UnitFramesVisibility" ""

UNITFRAME_PLAYER = "PlayerFrame"
UNITFRAME_TARGET = "TargetFrame"
UNITFRAME_FOCUS = "FocusFrame"

function OnLoad(self)
    Config = _Config.UnitFrames.Visibility
    _Enabled = Config.Enable
end

function OnEnable(self)
    InitOpacityInfos()
    InitUnitFrames()
    ApplyOpacityChanged()
end

function InitUnitFrames()
    for _, widget in ipairs(PlayerFrameWidgets) do
        widget:HookScript("OnEnter", OnUnitFrameEnter)
        widget:HookScript("OnLeave", OnUnitFrameLeave)
    end
    for _, widget in ipairs(TargetFrameWidgets) do
        widget:HookScript("OnEnter", OnUnitFrameEnter)
        widget:HookScript("OnLeave", OnUnitFrameLeave)
    end
    for _, widget in ipairs(FocusFrameWidgets) do
        widget:HookScript("OnEnter", OnUnitFrameEnter)
        widget:HookScript("OnLeave", OnUnitFrameLeave)
    end
end

function InitOpacityInfos()
    PlayerFrameWidgets              = {
        PlayerFrame, PetFrame
    }

    TargetFrameWidgets              = {
        TargetFrame, TargetFrameToT
    }

    FocusFrameWidgets              = {
        FocusFrame, FocusFrameToT
    }

    OpacityInfos                    = {
        PlayerFrame                 = {
            name                    = UNITFRAME_PLAYER,
            Widget                  = PlayerFrame,
            Config                  = Config.PlayerFrame,
            Condition               = Config.PlayerFrame.Condition,
            CurrentAlpha            = PlayerFrame:GetAlpha(),
            IsMouseOver             = function(self)
                for _, widget in ipairs(PlayerFrameWidgets) do
                    if widget:IsMouseOver() then
                        return true
                    end
                end
            end
        },
        
        TargetFrame                 = {
            name                    = UNITFRAME_TARGET,
            Widget                  = TargetFrame,
            Config                  = Config.TargetFrame,
            Condition               = Config.TargetFrame.Condition,
            CurrentAlpha            = TargetFrame:GetAlpha(),
            IsMouseOver             = function(self)
                for _, widget in ipairs(TargetFrameWidgets) do
                    if widget:IsMouseOver() then
                        return true
                    end
                end
            end
        },

        FocusFrame                  = {
            name                    = UNITFRAME_FOCUS,
            Widget                  = FocusFrame,
            Config                  = Config.FocusFrame,
            Condition               = Config.FocusFrame.Condition,
            CurrentAlpha            = FocusFrame:GetAlpha(),
            IsMouseOver             = function(self)
                for _, widget in ipairs(FocusFrameWidgets) do
                    if widget:IsMouseOver() then
                        return true
                    end
                end
            end
        }
    }
end

function OnUnitFrameEnter(self)
    local name = self:GetName()
    if name:match("PetFrame") then
        OnConditionChanged(nil, UNITFRAME_PLAYER, true)
    elseif name:match(UNITFRAME_TARGET) then
        OnConditionChanged(nil, UNITFRAME_TARGET, true)
    elseif name:match(UNITFRAME_FOCUS) then
        OnConditionChanged(nil, UNITFRAME_FOCUS, true)
    else
        OnConditionChanged(nil, name, true)
    end
end

function OnUnitFrameLeave(self)
    local name = self:GetName()
    if name:match("PetFrame") then
        OnConditionChanged(nil, UNITFRAME_PLAYER, false)
    elseif name:match(UNITFRAME_TARGET) then
        OnConditionChanged(nil, UNITFRAME_TARGET, false)
    elseif name:match(UNITFRAME_FOCUS) then
        OnConditionChanged(nil, UNITFRAME_FOCUS, false)
    else
        OnConditionChanged(nil, name, false)
    end
end

__SystemEvent__()
function PLAYER_REGEN_DISABLED()
    OnConditionChanged(true)
end

__SystemEvent__()
function PLAYER_REGEN_ENABLED()
    OnConditionChanged(false)
end

__SystemEvent__()
function PLAYER_ENTERING_WORLD()
    OnConditionChanged()
end

function OnOpacityConditionChanged(opacityInfo, inCombat, inInstance, hasTarget, targetCanAttack, isEnter)
    local ToAlpha = opacityInfo.ToAlpha
    if isEnter then
        ToAlpha = 1
    elseif (inCombat and opacityInfo.Condition.InCombat) or (inInstance and opacityInfo.Condition.InInstance) then
        ToAlpha = opacityInfo.Config.OpacityConditional/100
    elseif hasTarget and opacityInfo.Condition.HasTarget then
        if opacityInfo.Condition.TargetCanAttack then
            if targetCanAttack then
                ToAlpha = opacityInfo.Config.OpacityConditional/100
            else
                ToAlpha = opacityInfo.Config.OpacityNormal/100
            end
        else
            ToAlpha = opacityInfo.Config.OpacityConditional/100
        end
    else
        ToAlpha = opacityInfo.Config.OpacityNormal/100
    end
    local needChange = opacityInfo.ToAlpha ~= ToAlpha
    opacityInfo.ToAlpha = ToAlpha
    return needChange
end

-- 条件变更时回调
__SystemEvent__ "PLAYER_TARGET_CHANGED"
function OnConditionChanged(inCombat, frame, isEnter)
    if not OpacityInfos then return end
    inCombat = inCombat or InCombatLockdown()
    local inInstance = IsInInstance()
    local hasTarget = UnitExists("target") and not UnitIsDeadOrGhost("target")
    local targetCanAttack = UnitCanAttack("player", "target")

    local needChange = false
    for _, opacityInfo in pairs(OpacityInfos) do
        local frameEnter = (frame and frame == opacityInfo.name and isEnter)
        local result = OnOpacityConditionChanged(opacityInfo, inCombat, inInstance, hasTarget, targetCanAttack, frameEnter)
        if result then
            needChange = true
        end
    end
    if needChange then
        FireSystemEvent("SPAUI_UNITFRAME_VISIBILITY_CHANGE")
    end
end

-- 不透明度是否已经应用完成
function OpacityIsChangingDone(opacityInfo)
    local current = opacityInfo.CurrentAlpha
    return math.abs(current - opacityInfo.ToAlpha) <= 10e-3
end

-- 获取不透明度变化增量
function GetOpacityIncrement(opacityInfo)
    local increment = math.abs(opacityInfo.Config.OpacityNormal/100 - opacityInfo.Config.OpacityConditional/100)/opacityInfo.Config.FadeDuration
    local positive = opacityInfo.CurrentAlpha < opacityInfo.ToAlpha
    return increment * (positive and 1 or -1)
end

-- 设置不透明度
-- lastFrameTime:上一帧的时间
function SetOpacity(opacityInfo, lastFrameTime)
    local alpha
    if opacityInfo:IsMouseOver() then
        alpha = 1
    elseif not opacityInfo.Config.FadeAnimate then
        alpha = opacityInfo.ToAlpha
    else
        local increment = (GetTime() - lastFrameTime) * GetOpacityIncrement(opacityInfo)
        if increment == 0 then
            alpha = opacityInfo.ToAlpha
        else
            increment = floor(10^4 * increment + 0.5) / 10^4
            alpha = opacityInfo.CurrentAlpha + increment
            if alpha > 1 then
                alpha = 1
            elseif alpha < 0 then
                alpha = 0
            end
        end
    end
    opacityInfo.CurrentAlpha = alpha
    if opacityInfo.Widgets then
        for _, widget in ipairs(opacityInfo.Widgets) do
            widget:SetAlpha(alpha)
        end
    else
        opacityInfo.Widget:SetAlpha(alpha)
    end
end

__AsyncSingle__()
function ApplyOpacityChanged()
    while Wait("SPAUI_UNITFRAME_VISIBILITY_CHANGE") do
        local current = GetTime()
        while true do
            Next()
            local doneCount = 0
            local opacityInfoCount = 0
            for _, opacityInfo in pairs(OpacityInfos) do
                local done = OpacityIsChangingDone(opacityInfo)
                if done then
                    doneCount = doneCount + 1
                else
                    SetOpacity(opacityInfo, current)
                    current = GetTime()
                end
                opacityInfoCount = opacityInfoCount + 1
            end
            if doneCount >= opacityInfoCount then
                break
            end
        end
    end
end