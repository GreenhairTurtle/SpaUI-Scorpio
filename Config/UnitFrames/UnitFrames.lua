Scorpio "SpaUI.Config.UnitFrames" ""

-- 玩家框体
UNITFRAME_PLAYER = 1
-- 目标框体
UNITFRAME_TARGET = 2
-- 焦点框体
UNITFRAME_FOCUS = 3

UNITFRAMES                                     = {
    [UNITFRAME_PLAYER]                         = L["config_unitframes_player"],
    [UNITFRAME_TARGET]                         = L["config_unitframes_target"],
    [UNITFRAME_FOCUS]                          = L["config_unitframes_focus"]
}

function OnLoad(self)
    _Enabled = false
    -- _Parent.SetDefaultToConfigDB(_Name, DefaultConfig)
    -- DB = _Config[_Name]
end

function SetDefaultToConfigDB(childName, globalConfig, charConfig)
    DefaultConfig = DefaultConfig or {}
    DefaultConfig[childName] = globalConfig
    DefaultCharConfig = DefaultCharConfig or {}
    DefaultCharConfig[childName] = charConfig
    _Parent.SetDefaultToConfigDB(_Name, DefaultConfig, DefaultCharConfig)
end

function Show(childModule)
    if not UnitFramesContainer then
        _Enabled = true
    end
    if childModule then
        _Modules[childModule].Show()
        UnitFramesContainer:Hide()
    else
        UnitFramesContainer:Show()
    end
end

function Hide(childModule)
    if childModule then
        _Modules[childModule].Hide()
    else
        if not UnitFramesContainer then return end
        UnitFramesContainer:Hide()
    end
end

function OnEnable(self)
    UnitFramesContainer = Frame("UnitFramesContainer", ConfigContainer)

    Style[UnitFramesContainer]                                  = {
        location                                                = {
            Anchor("TOPLEFT", 15, -15),
            Anchor("BOTTOMRIGHT", -15, 15),
        }
    }
end