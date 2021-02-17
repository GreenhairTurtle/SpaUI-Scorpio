Scorpio "SpaUI.Config.Quest" ""

function OnLoad(self)
    _Enabled = false
end

function SetDefaultToConfigDB(childName, globalConfig, charConfig)
    DefaultConfig = DefaultConfig or {}
    DefaultConfig[childName] = globalConfig
    DefaultCharConfig = DefaultCharConfig or {}
    DefaultCharConfig[childName] = charConfig
    _Parent.SetDefaultToConfigDB(_Name, DefaultConfig, DefaultCharConfig)
end

function Show(childModule)
    _Enabled = true
    if childModule then
        _Modules[childModule].Show()
    end
end

function Hide(childModule)
    if childModule then
        _Modules[childModule].Hide()
    end
end