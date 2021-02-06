Scorpio "SpaUI.Config.Introduce" ""

function OnLoad(self)
    _Enabled = false
end

function Show()
    if not IntroduceContainer then _Enabled = true return end
    IntroduceContainer:Show()
end

function Hide()
    if not IntroduceContainer then return end
    IntroduceContainer:Hide()
end

__Async__()
function OnEnable(self)
    -- 介绍页
    IntroduceContainer = Frame("IntroduceContainer", ConfigContainer)
    FontString("IntroduceText", IntroduceContainer)
    FontString("Macros", IntroduceContainer)

    Style[IntroduceContainer] = {
        setAllPoints            = true,

        IntroduceText           = {
            fontobject          = GameFontHighlight,
            text                = L["config_addon_introduct"],
            location            = {
                Anchor("LEFT", 15, 0),
                Anchor("RIGHT", -15, 0),
                Anchor("TOP", 0, - 15)
            }
        },

        Macros                  = {
            fontobject          = GameFontWhite,
            text                = L["cmd_help"],
            justifyH            = "LEFT",
            spacing             = 3,
            location            = {
                Anchor("TOPLEFT", 0, -15, "IntroduceText", "BOTTOMLEFT")
            }
        }
    }
end