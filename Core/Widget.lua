Scorpio "SpaUI.Widget" ""

namespace "SpaUI.Widget"

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

-- ConfigPanel CheckButton
__Sealed__()
class "OptionsCheckButton" (function(_ENV)
    inherit "CheckButton"

    TooltipText         = String

    local function OnEnter(self)
        if self.TooltipText then
            GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
            GameTooltip:AddLine(self.TooltipText)
            GameTooltip:Show()
        end
    end

    local function OnLeave(self)
        GameTooltip:Hide()
    end

    local function OnClick(self)
        if ( self:GetChecked() ) then
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
        else
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
        end
    end

    __Template__{
        Label               = FontString,
    }
    function __ctor(self)
        self.OnEnter = self.OnEnter + OnEnter
        self.OnLeave = self.OnLeave + OnLeave
        self.OnClick = self.OnClick + OnClick
    end
end)

Style.UpdateSkin("Default",{
    [OptionsCheckButton] = {
        size                    = Size(26, 26),
        hitRectInsets           = Inset(0,-100,0,0),

        NormalTexture           = {
            file                = [[Interface\Buttons\UI-CheckBox-Up]],
            setAllPoints        = true,
        },
        PushedTexture           = {
            file                = [[Interface\Buttons\UI-CheckBox-Down]],
            setAllPoints        = true,
        },
        HighlightTexture        = {
            file                = [[Interface\Buttons\UI-CheckBox-Highlight]],
            setAllPoints        = true,
            alphamode           = "ADD",
        },
        CheckedTexture          = {
            file                = [[Interface\Buttons\UI-CheckBox-Check]],
            setAllPoints        = true,
        },
        DisabledCheckedTexture  = {
            file                = [[Interface\Buttons\UI-CheckBox-Check-Disabled]],
            setAllPoints        = true,
        },
        Label                   = {
            fontObject          = GameFontHighlightLeft,
            location            = { Anchor("LEFT", 2, 1, nil, "RIGHT") },
        }
    }
})

__Sealed__()
class ""