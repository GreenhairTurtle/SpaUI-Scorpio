Scorpio "SpaUI.ActionBar.ActionBarVisibility" ""

ACTIONBAR_MAIN = "MainBar"
ACTIONBAR_MULTIBAR_RIGHT = "MultiBarRight"
ACTIONBAR_MULTIBAR_LEFT = "MultiBarLeft"
ACTIONBAR_MICROBUTTONS = "MicroButtons"

function OnLoad(self)
    Config = _Config.ActionBar.Visibility
    _Enabled = Config.Enable
end

function OnEnable(self)
    InitOpacityInfos()
    InitActionBars()
    ApplyOpacityChanged()
end

function InitActionBars()
    -- MultiBarRight And MultiBarLeft
    for i = 1, 12 do
        local button = _G["MultiBarRightButton"..i]
        if button then
            button:HookScript("OnEnter", OnMultiBarEnter)
            button:HookScript("OnLeave", OnMultiBarLeave)
        end
        button = _G["MultiBarLeftButton"..i]
        if button then
            button:HookScript("OnEnter", OnMultiBarEnter)
            button:HookScript("OnLeave", OnMultiBarLeave)
        end
    end

    for _, button in ipairs(MicroButtonsBarWidgets) do
        if button then
            MicroButtonAndBagsBar:HookScript("OnEnter", OnMicroButtonAndBagsBarEnter)
            MicroButtonAndBagsBar:HookScript("OnLeave", OnMicroButtonAndBagsBarLeave)
        end
    end

    -- MainActionBar
    for _, button in ipairs(MainBarWidgets) do
        if button and button:IsObjectType("Frame") then
            button:HookScript("OnEnter", OnMainActionBarEnter)
            button:HookScript("OnLeave", OnMainActionBarLeave)
        end
    end
end

__SecureHook__()
function UpdateMicroButtonsParent(parent)
    -- MicroButtonAndBagsBar和MicroButtons的frameStrata和frameLevel一样
    -- 在进入载具以后退出，会导致MicroButtons被MicroButtonAndBagsBar遮蔽
    -- 这里使它们的FrameLevel+1
    for i=1, #MICRO_BUTTONS do
        local button = _G[MICRO_BUTTONS[i]]
		button:SetFrameLevel(button:GetFrameLevel() + 1)
	end
end

function InitOpacityInfos()
    -- 背包和微型菜单按钮
    MicroButtonsBarWidgets = { MicroButtonAndBagsBar }
    for _, name in ipairs(MICRO_BUTTONS) do
        local button = _G[name]
        if button then
            tinsert(MicroButtonsBarWidgets, button)
        end
    end
    
    -- MainActionBar
    MainBarWidgets = {}
    -- 添加主动作条、左下和右下动作条
    for i = 1, 12 do
        local button = _G["ActionButton"..i]
        if button then
            tinsert(MainBarWidgets, button)
        end
        button = _G["MultiBarBottomLeftButton"..i]
        if button then
            tinsert(MainBarWidgets, button)
        end
        button = _G["MultiBarBottomRightButton"..i]
        if button then
            tinsert(MainBarWidgets, button)
        end
    end
    -- 添加翻页按钮
    tinsert(MainBarWidgets, ActionBarUpButton)
    tinsert(MainBarWidgets, ActionBarDownButton)
    -- 添加背景
    tinsert(MainBarWidgets, MainMenuBarArtFrameBackground)
    -- 离开载具按钮
    tinsert(MainBarWidgets, MainMenuBarVehicleLeaveButton)
    -- 添加两只鹰和动作条页码
    tinsert(MainBarWidgets, MainMenuBarArtFrame.LeftEndCap)
    tinsert(MainBarWidgets, MainMenuBarArtFrame.RightEndCap)
    tinsert(MainBarWidgets, MainMenuBarArtFrame.PageNumber)
    -- 添加姿态条和宠物技能条
    for i = 1, 10 do
        local button = _G["StanceButton"..i]
        if button then
            tinsert(MainBarWidgets, button)
        end
        button = _G["PetActionButton"..i]
        if button then
            tinsert(MainBarWidgets, button)
        end
    end
    -- 添加载具按钮
    tinsert(MainBarWidgets, PossessBackground1)
    tinsert(MainBarWidgets, PossessBackground2)
    tinsert(MainBarWidgets, PossessButton1)
    tinsert(MainBarWidgets, PossessButton2)
    -- 添加经验、声望条
    tinsert(MainBarWidgets, StatusTrackingBarManager)

    OpacityInfos                        = {
        MultiBarRight                   = {
            name                        = ACTIONBAR_MULTIBAR_RIGHT,
            Widget                      = MultiBarRight,
            Config                      = Config.MultiBarRight,
            Condition                   = Config.MultiBarRight.Condition,
            CurrentAlpha                = MultiBarRight:GetAlpha(),
            IsMouseOver                 = function(self)
                return self.Widget:IsMouseOver()
            end
        },
        MultiBarLeft                    = {
            name                        = ACTIONBAR_MULTIBAR_LEFT,
            Widget                      = MultiBarLeft,
            Config                      = Config.MultiBarLeft,
            Condition                   = Config.MultiBarLeft.Condition,
            CurrentAlpha                = MultiBarLeft:GetAlpha(),
            IsMouseOver                 = function(self)
                return self.Widget:IsMouseOver()
            end
        },
        MicroButtonsBar                 = {
            name                        = ACTIONBAR_MICROBUTTONS,
            Widgets                     = MicroButtonsBarWidgets,
            Config                      = Config.MicroButtonsActionBar,
            Condition                   = Config.MicroButtonsActionBar.Condition,
            CurrentAlpha                = MicroButtonAndBagsBar:GetAlpha(),
            IsMouseOver                 = function(self)
                for _, widget in ipairs(self.Widgets) do
                    if widget:IsMouseOver() then
                        return true
                    end
                end
            end
        },
        MainActionBar                   = {
            name                        = ACTIONBAR_MAIN,
            Widgets                     = MainBarWidgets,
            Config                      = Config.MainActionBar,
            Condition                   = Config.MainActionBar.Condition,
            CurrentAlpha                = MainMenuBarArtFrame:GetAlpha(),
            IsMouseOver                 = function(self)
                for _, widget in ipairs(self.Widgets) do
                    if widget:IsMouseOver() then
                        return true
                    end
                end
            end
        }
    }
end

function OnMainActionBarEnter(self)
    OnConditionChanged(nil, ACTIONBAR_MAIN, true)
end

function OnMainActionBarLeave(self)
    OnConditionChanged(nil, ACTIONBAR_MAIN, false)
end

function OnMicroButtonAndBagsBarEnter(self)
    OnConditionChanged(nil, ACTIONBAR_MICROBUTTONS, true)
end

function OnMicroButtonAndBagsBarLeave(self)
    OnConditionChanged(nil, ACTIONBAR_MICROBUTTONS, false)
end

function OnMultiBarEnter(self)
    local name = self:GetName()
    if name:match(ACTIONBAR_MULTIBAR_RIGHT) then
        OnConditionChanged(nil, ACTIONBAR_MULTIBAR_RIGHT, true)
    elseif name:match(ACTIONBAR_MULTIBAR_LEFT) then
        OnConditionChanged(nil, ACTIONBAR_MULTIBAR_LEFT, true)
    end
end

function OnMultiBarLeave(self)
    local name = self:GetName()
    if name:match(ACTIONBAR_MULTIBAR_RIGHT) then
        OnConditionChanged(nil, ACTIONBAR_MULTIBAR_RIGHT, false)
    elseif name:match(ACTIONBAR_MULTIBAR_LEFT) then
        OnConditionChanged(nil, ACTIONBAR_MULTIBAR_LEFT, false)
    end
end

function OnOpacityConditionChanged(opacityInfo, inCombat, inInstance, hasTarget, targetCanAttack, isEnter)
    local ToAlpha = opacityInfo.ToAlpha
    if isEnter or HasOverrideActionBar() or (HasVehicleActionBar() and not IsPossessBarVisible()) then
        ToAlpha = 1
    elseif (inCombat and opacityInfo.Condition.InCombat) or (inInstance and opacityInfo.Condition.InInstance) then
        ToAlpha = opacityInfo.Config.OpacityConditional
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

__SystemEvent__ "UNIT_ENTERED_VEHICLE" "UNIT_EXITED_VEHICLE"
function OnVehicleStatusChanged(unit)
    Log("OnVehicleStatusChanged", unit)
    if unit == "player" then
        OnConditionChanged()
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

-- 条件变更时回调
__SystemEvent__ "PLAYER_TARGET_CHANGED" "UPDATE_OVERRIDE_ACTIONBAR"
function OnConditionChanged(inCombat, bar, isEnter)
    if not OpacityInfos then return end
    inCombat = inCombat or InCombatLockdown()
    local inInstance = IsInInstance()
    local hasTarget = UnitExists("target") and not UnitIsDeadOrGhost("target")
    local targetCanAttack = UnitCanAttack("player", "target")

    -- Log("OnConditionChanged", inCombat, inInstance, hasTarget, targetCanAttack)
    local needChange = false
    for _, opacityInfo in pairs(OpacityInfos) do
        local barEnter = (bar and bar == opacityInfo.name and isEnter)
        local result = OnOpacityConditionChanged(opacityInfo, inCombat, inInstance, hasTarget, targetCanAttack, barEnter)
        if result then
            needChange = true
        end
    end
    if needChange then
        FireSystemEvent("SPAUI_ACTIONBAR_VISIBILITY_CHANGE")
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
    while Wait("SPAUI_ACTIONBAR_VISIBILITY_CHANGE") do
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