Scorpio "SpaUI.Features" ""

namespace "SpaUI.Widget.Features"

-- TradeTabs.lua
__Sealed__() __Template__(SecureCheckButton)
class "TradeTab" {
    Border              = Texture,
    Icon                = Texture,
    Cover               = Frame,
    Cd                  = Cooldown
}

Style.UpdateSkin("Default",{
    [TradeTab]              = {
        size                = Size(32,32),
        highlightTexture    = {
            file            = [[Interface\Buttons\ButtonHilight-Square]],
            alphamode       = "ADD",
            setAllPoints    = true
        },
        checkedTexture    = {
            file            = [[Interface\Buttons\CheckButtonHilight]],
            alphamode       = "ADD",
            setAllPoints    = true
        },

        Border              = {
            file            = [[Interface\SpellBook\SpellBook-SkillLineTab]],
            drawlayer       = "BORDER",
            size            = Size(64,64),
            location        = {
                Anchor("TOPLEFT",-3,11)
            }
        },

        -- todo TextureSubLevel
        Icon                = {
            file            = [[INTERFACE\HELPFRAME\REPORTLAGICON-CHAT]],
            drawlayer       = "ARTWORK",
            size            = Size(30,30),
            location        = {
                Anchor("CENTER")
            },
            texCoords      = { left=0.03125, right=0.96875, top= 0.03125, bottom= 0.96875 }
        },

        Cover               = {
            setAllPoints    = true,
            enableMouse     = true
        },

        Cd                  = {
            setAllPoints        = true,
            swipeColor          = ColorType(0, 0, 0),
            swipeTexture        = {
                file            = "",
                color           = ColorType(1, 1, 1, 0.8)
            },
            edgeTexture         = {
                file            = [[Interface\Cooldown\edge]]
            },
            blingTexture        = {
                file            = [[Interface\Cooldown\star4]],
                color           = ColorType(0.3, 0.6, 1, 0.8)
            }
        }
    }
})