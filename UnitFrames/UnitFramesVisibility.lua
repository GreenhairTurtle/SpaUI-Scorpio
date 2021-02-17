Scorpio "SpaUI.UnitFrames.UnitFramesVisibility" ""

function OnLoad(self)
    Config = _Config.UnitFrames.Visibility
    _Enabled = Config.Enable
end

function OnEnable(self)

end

function InitOpacityInfos()
    OpacityInfos                    = {
        PlayerFrame                 = {
            Widget                  = PlayerFrame,
            Config                  = Config.PlayerFrame,
            Condition               = Config.PlayerFrame.Condition,
            CurrentAlpha            = PlayerFrame:GetAlpha(),
        }
    }
end