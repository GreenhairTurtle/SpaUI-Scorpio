Scorpio "SpaUI.Config" ""

namespace "SpaUI.Widget.Config"

__Sealed__()
interface "ConfigItem" (function(self)
    -- 值变化回调
    __Abstract__()
    function OnValueChange(self,...) end

    -- 是否需要重载
    __Abstract__()
    function NeedReload(self) end

    -- 确认回调
    __Abstract__()
    function OnSaveConfig(self) end

    -- 恢复
    __Abstract__()
    function Restore(self) end
end)

-- ConfigPanel CheckButton
__Sealed__()
class "OptionsCheckButton" (function(_ENV)
    inherit "CheckButton"
    extend "ConfigItem"
    
    property "TooltipText" { type = String }
    property "configBehavior" {
        type                    = RawTable,
        handler                 = function(self, behavior)
            if behavior and behavior.GetValue then
                self:SetChecked(behavior:GetValue())
            end
        end
    }

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
        local checked = self:GetChecked()
        if checked then
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
        else
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
        end
        OnValueChange(self,checked)
    end

    function OnValueChange(self,...)
        if self.configBehavior and self.configBehavior.OnValueChange then
            self.configBehavior:OnValueChange(...)
        end
    end

    function NeedReload(self)
        return self.configBehavior and self.configBehavior.NeedReload and self.configBehavior:NeedReload()
    end

    function OnSaveConfig(self)
        if self.configBehavior and self.configBehavior.OnSaveConfig then
            self.configBehavior:OnSaveConfig()
        end
    end

    function OnRestore(self)
        if self.configBehavior then
            if self.configBehavior.GetValue then
                self:SetChecked(self.configBehavior.GetValue)
            end
            if self.configBehavior.OnRestore then
                self.configBehavior:OnRestore()
            end
        end
    end

    function __ctor(self)
        self.OnEnter = self.OnEnter + OnEnter
        self.OnLeave = self.OnLeave + OnLeave
        self.OnClick = self.OnClick + OnClick
    end
end)

Style.UpdateSkin("Default",{
    [OptionsCheckButton] = {
        size                    = Size(26, 26),

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
            location            = { Anchor("LEFT", 2, 0, nil, "RIGHT") },
        }
    }
})

-- CategoryList Button
__Sealed__()
class "CategoryListButton"(function(_ENV)
    inherit "CheckButton"

    function SetCategory(self,category)
        self.category = category
        self:SetText(category.name)
        self:SetEnabled(category.enable)
    end

    local function OnClick(self)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    end

    __Template__{
        Toggle  =   Button
    }
    function __ctor(self)
        self.OnClick = self.OnClick + OnClick
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
            vertexColor         = ColorType(.196, .388, .8),
            location            = {
                Anchor("TOPLEFT", 0, 1),
                Anchor("BOTTOMRIGHT", 0, 1)
            }
        },
        buttonText              = {
            justifyH            = "LEFT",
            wordwrap            = false,
            location            = {
                Anchor("TOPLEFT", 10, 0),
                Anchor("BOTTOMRIGHT", -10, 0)
            }
        },

        Toggle                  = {
            size                = Size(14, 14),
            location            = {
                Anchor("TOPRIGHT", -6, -1)
            },
            normalTexture       = {
                file            = [[Interface\Buttons\UI-MinusButton-UP]],
                setAllPoints    = true
            },
            pushedTexture       = {
                file            = [[Interface\Buttons\UI-MinusButton-DOWN]],
                setAllPoints    = true
            },
            highlightTexture       = {
                file            = [[Interface\Buttons\UI-PlusButton-Hilight]],
                setAllPoints    = true,
                alphaMode       = "ADD",
            }
        }
    }
})

__Sealed__() __Template__(Texture)
class "OptionsLine" {}

Style.UpdateSkin("Default", {
    [OptionsLine] = {
        height                  = 1,
        color                   = ColorType(1, 1, 1, 0.2)
    }
})