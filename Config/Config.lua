Scorpio "SpaUI.Config" ""

namespace "SpaUI.Widget.Config"

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
        if self:GetChecked() then
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

-- ConfigPanel Category
__Sealed__()
struct "ConfigCategory" {
    { name = "name", type = NEString, require = true },
    { name = "module", type = NEString, require = true },
    { name = "enable", type = Boolean, default = true },
    { name = "update", type = Boolean }
}

-- CategoryList Button
__Sealed__()
class "CategoryListButton"(function(_ENV)
    inherit "CheckButton"

    Category            = ConfigCategory

    function SetCategory(self,category)
        Category = category
        self:SetText(category.name)
        self:SetEnabled(category.enable)
    end
end)

Style.UpdateSkin("Default", {
    [CategoryListButton] = {
        size                    = Size(175, 18),
        highlightFont           = GameFontHighlight,
        normalFont              = GameFontNormal,
        disabledFont            = GameFontDisable,
        highlightTexture        = {
            file                = [[Interface\QuestFrame\UI-QuestLogTitleHighlight]],
            alphaMode           = "ADD",
            location            = {
                Anchor("TOPLEFT", 0, 1),
                Anchor("BOTTOMRIGHT", 0, 1)
            }
        },
        buttonText              = {
            fontObject          = GameFontNormal,
            justifyH            = "LEFT",
            wordwrap            = false,
        }
    }
})