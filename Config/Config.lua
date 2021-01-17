Scorpio "SpaUI.Config" ""

namespace "SpaUI.Widget.Config"

__Sealed__()
interface "ConfigItem" (function(_ENV)

    __Abstract__()
    property "ConfigBehavior"

    -- 值变化回调
    function OnValueChange(self,...)
        if self.ConfigBehavior and self.ConfigBehavior.OnValueChange then
            return self.ConfigBehavior:OnValueChange(...)
        end
    end

    -- 是否需要重载
    function NeedReload(self)
        return self.ConfigBehavior and self.ConfigBehavior.NeedReload and self.ConfigBehavior:NeedReload()
    end

    -- 保存配置回调
    function OnSaveConfig(self)
        if self.ConfigBehavior and self.ConfigBehavior.OnSaveConfig then
            return self.ConfigBehavior:OnSaveConfig()
        end
    end

    -- 重置
    function Restore(self)
        if self.ConfigBehavior then
            if self.ConfigBehavior.GetValue then
                return self:OnRestore(self.ConfigBehavior.GetValue())
            end
            if self.ConfigBehavior.OnRestore then
                return self.ConfigBehavior:OnRestore()
            end
        end
    end

    -- 重置回调
    __Abstract__()
    function OnRestore(self, ...) end
end)

-- ConfigPanel CheckButton
__Sealed__()
class "OptionsCheckButton" (function(_ENV)
    inherit "CheckButton"
    extend "ConfigItem"
    
    property "TooltipText" { type = String }
    property "ConfigBehavior" {
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
        self:OnValueChange(checked)
    end

    function OnRestore(self, value)
        self:SetChecked(value)
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

    event "OnCollpasedChanged"

    local function ToggleChild(self, collapsed)
        local toggle = self:GetChild("Toggle")
        if collapsed then
			toggle:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-UP");
			toggle:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-DOWN");
        else
			toggle:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-UP");
			toggle:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-DOWN");
        end
        OnCollpasedChanged(self, collapsed)
    end

    property "Collapsed" {
        type        = Boolean,
        default     = true,
        handler     = ToggleChild
    }

    function SetCategory(self,category)
        self.category = category
        self:SetText(category.name)
        local toggle = self:GetChild("Toggle")
        if category.parent then
            self:SetNormalFontObject(GameFontHighlightSmall);
            self:SetHighlightFontObject(GameFontHighlightSmall);
            self:GetFontString():SetPoint("LEFT", 16, 2)
            toggle:Hide()
            self:Hide()
        else
            self:SetNormalFontObject(GameFontNormal);
            self:SetHighlightFontObject(GameFontHighlight);
            self:GetFontString():SetPoint("LEFT", 8, 2)
            self:Show()
            if category.hasChildren then
                toggle:Show()
            end
        end
    end

    local function OnClick(self)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    end

    local function OnToggleClick(self)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
        local parent = self:GetParent()
        parent.Collapsed = not parent.Collapsed
    end

    __Template__{
        Toggle  =   Button
    }
    function __ctor(self)
        self.OnClick = self.OnClick + OnClick
        local toggle = self:GetChild("Toggle")
        toggle.OnClick = toggle.OnClick + OnToggleClick
        self:InstantApplyStyle()
    end
end)

Style.UpdateSkin("Default", {
    [CategoryListButton] = {
        size                    = Size(175, 18),
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
            wordwrap            = false
        },

        Toggle                  = {
            size                = Size(14, 14),
            location            = {
                Anchor("TOPRIGHT", -6, -1)
            },
            visible             = false,
            normalTexture       = {
                setAllPoints    = true,
                file            = [[Interface\Buttons\UI-PlusButton-UP]]
            },
            pushedTexture       = {
                setAllPoints    = true,
                file            = [[Interface\Buttons\UI-PlusButton-DOWN]]
            },
            highlightTexture    = {
                setAllPoints    = true,
                file            = [[Interface\Buttons\UI-PlusButton-Hilight]],
                alphaMode       = "ADD"
            }
        }
    }
})

-- Line
__Sealed__() __Template__(Texture)
class "OptionsLine" {}

Style.UpdateSkin("Default", {
    [OptionsLine] = {
        height                  = 1,
        color                   = ColorType(1, 1, 1, 0.2)
    }
})

-- ConfigPanel DropDownMenu
__Sealed__()
class "OptionsDropDownMenu" (function(_ENV)
    inherit "Frame"
    extend "ConfigItem"

    -- DropDownMenu GetValue至少需要返回两个参数
    -- return arg1:value
    -- return arg2:text
    property "ConfigBehavior" {
        type                    = RawTable,
        handler                 = function(self, behavior)
            CloseDropDownMenus()
            if behavior and behavior.GetValue then
                local _, text = behavior:GetValue()
                self:SetText(text)
            end
        end
    }

    property "DropDownInfos" {
        type                    = RawTable,
        handler                 = function(self, infos)
            self:SetEnabled(infos and #infos > 0)
        end
    }

    local function OnItemSelect(button, arg1, arg2, checked)
        if button and button:GetParent() and button:GetParent().dropdown then
            local self = button:GetParent().dropdown
            -- 如果返回true，则改变当前文本
            local result = self:OnValueChange(arg1, arg2, checked)
            if result == true then
                SetText(self,arg2)
            end
        end
        CloseDropDownMenus()
    end

    local function SetupInfo(info, value)
        info.value = info.value or info.text
        info.arg1 = info.arg1 or info.value or info.text
        info.arg2 = info.arg2 or info.text
        info.func = OnItemSelect
        info.tooltipTitle = (not info.tooltipTitle and info.tooltipText) and info.text or nil
        info.tooltipOnButton = (info.tooltipText or info.tooltipTitle) and true or false
        info.hasArrow = info.menuList and #info.menuList > 0
        info.checked = IsInfoChecked(info, value)
    end

    function IsInfoChecked(info, value)
        if value == nil then return false end
        if info.arg1 == value then return true end
        if info.menuList and #info.menuList > 0 then
            for _, childInfo in ipairs(info.menuList) do
                SetupInfo(childInfo)
                if childInfo.hasArrow then
                    return IsInfoChecked(childInfo, value)
                else
                    return childInfo.arg1 == value
                end
            end
        end
        return false
    end

    -- 判断是否选中的条件为arg1是否与ConfigBehavior返回的第一个参数相等
    -- 如果arg1为nil，则会取value，继而取text
    local function DropDownInitialize(self, level, menuList)
        local infos = (( level or 1 ) == 1 ) and self.DropDownInfos or menuList
        if not infos or #infos <= 0 then return end
        local value = self.ConfigBehavior and self.ConfigBehavior.TempValue or (self.ConfigBehavior.GetValue and self.ConfigBehavior:GetValue())
        for _, info in ipairs(infos) do
            SetupInfo(info, value)
            UIDropDownMenu_AddButton(info, level)
        end
    end

    function SetText(self, text)
        UIDropDownMenu_SetText(self, text)
    end

    function OnRestore(self, _, text)
        self:SetText(text)
    end

    property "DropDownMenuWidth" {
        type                = Number,
        handler             = function(self, width)
            UIDropDownMenu_SetWidth(self, width)
        end
    }

    function SetEnabled(self, enable)
        if enable then
            UIDropDownMenu_EnableDropDown(self)
        else
            UIDropDownMenu_DisableDropDown(self)
        end
    end

    function __ctor(self)
        -- 锚点对齐框体.
        self:SetEnabled(false)
        UIDropDownMenu_SetAnchor(self, 14, 22)
        UIDropDownMenu_Initialize(self, DropDownInitialize)
        UIDropDownMenu_JustifyText(self,"LEFT")
    end

    function __new(_,_,parent,...)
        return CreateFrame("Frame", nil, parent, "UIDropDownMenuTemplate")
    end
end)

-- 角色配置指示器
__Sealed__() 
__ChildProperty__(OptionsDropDownMenu, "CharIndicator")
__ChildProperty__(OptionsCheckButton, "CharIndicator")
class "CharOptionsIndicator" {Texture}

Style.UpdateSkin("Default", {
    [CharOptionsIndicator] = {
        file                        = [[Interface\Addons\SpaUI\Media\char_indicator]],
        setAllPoints                = true,
        size                        = Size(22, 22)
    }
})