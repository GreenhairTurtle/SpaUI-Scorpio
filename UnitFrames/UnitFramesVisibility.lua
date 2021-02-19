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
    PlayerFrame:HookScript("OnEnter", OnUnitFrameEnter)
    TargetFrame:HookScript("OnEnter", OnUnitFrameEnter)
    FocusFrame:HookScript("OnEnter", OnUnitFrameEnter)
    PlayerFrame:HookScript("OnLeave", OnUnitFrameLeave)
    TargetFrame:HookScript("OnLeave", OnUnitFrameLeave)
    FocusFrame:HookScript("OnLeave", OnUnitFrameLeave)
end

function InitOpacityInfos()
    OpacityInfos                    = {
        PlayerFrame                 = {
            name                    = UNITFRAME_PLAYER,
            Widget                  = PlayerFrame,
            Config                  = Config.PlayerFrame,
            Condition               = Config.PlayerFrame.Condition,
            CurrentAlpha            = PlayerFrame:GetAlpha(),
            IsMouseOver             = function(self)
                return self.Widget:IsMouseOver()
            end
        },
        
        TargetFrame                 = {
            name                    = UNITFRAME_TARGET,
            Widget                  = TargetFrame,
            Config                  = Config.TargetFrame,
            Condition               = Config.TargetFrame.Condition,
            CurrentAlpha            = TargetFrame:GetAlpha(),
            IsMouseOver             = function(self)
                return self.Widget:IsMouseOver()
            end
        },

        FocusFrame                  = {
            name                    = UNITFRAME_FOCUS,
            Widget                  = FocusFrame,
            Config                  = Config.FocusFrame,
            Condition               = Config.FocusFrame.Condition,
            CurrentAlpha            = FocusFrame:GetAlpha(),
            IsMouseOver             = function(self)
                return self.Widget:IsMouseOver()
            end
        }
    }
end

function OnUnitFrameEnter(self)
    OnConditionChanged(nil, self:GetName(), true)
end

function OnUnitFrameLeave(self)
    OnConditionChanged(nil, self:GetName(), false)
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

function OnOpacityConditionChanged(opacityInfo, inCombat, inInstance, isEnter)
    local ToAlpha = opacityInfo.ToAlpha
    if isEnter then
        ToAlpha = 1
    elseif (inCombat and opacityInfo.Condition.InCombat) or (inInstance and opacityInfo.Condition.InInstance) then
        ToAlpha = opacityInfo.Config.OpacityConditional
    else
        ToAlpha = opacityInfo.Config.OpacityNormal/100
    end
    local needChange = opacityInfo.ToAlpha ~= ToAlpha
    opacityInfo.ToAlpha = ToAlpha
    return needChange
end

-- 条件变更时回调
function OnConditionChanged(inCombat, frame, isEnter)
    if not OpacityInfos then return end
    inCombat = inCombat or InCombatLockdown()
    local inInstance = IsInInstance()

    local needChange = false
    for _, opacityInfo in pairs(OpacityInfos) do
        local frameEnter = (frame and frame == opacityInfo.name and isEnter)
        local result = OnOpacityConditionChanged(opacityInfo, inCombat, inInstance, frameEnter)
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
    return math.abs(current - opacityInfo.ToAlpha) <= 10e-4
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