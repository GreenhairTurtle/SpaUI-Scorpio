Scorpio "SpaUI.Config" ""
import "SpaUI.Widget.Config"

L = _Locale
local InCombatLockdown = InCombatLockdown


CategoryList = {
    -- 介绍
    {
        name = L['config_category_introduce'],
        module = "Introduce",
        enable = true
    },
    -- 聊天
    {
        name = L['config_category_chat'],
        module = "Chat",
        enable = true
    },
    -- 更新日志
    {
        name = L['config_category_changelog'],
        module = "ChangeLog",
        enable = true
    },
}

function OnLoad()
    _Enabled = false
    hooksecurefunc("GameMenuFrame_UpdateVisibleButtons", InjectConfigButtonToGameMenu)
end

-- 游戏菜单注入Config按钮
__Async__()
function InjectConfigButtonToGameMenu()
    if not SpaUIConfigButton then
        SpaUIConfigButton = Button("SpaUIConfigButton", GameMenuFrame, "GameMenuButtonTemplate")
        local _, relativeTo, _, _, offY = GameMenuButtonStore:GetPoint()
        SpaUIConfigButton:SetText(L["addon_name"])
        SpaUIConfigButton:SetPoint("TOP", relativeTo, "BOTTOM", 0, offY)
        SpaUIConfigButton.OnClick = OnGameMenuConfigButtonClick
        GameMenuButtonStore:ClearAllPoints()
        GameMenuButtonStore:SetPoint("TOP", SpaUIConfigButton, "BOTTOM", 0, offY)
    end
    GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + SpaUIConfigButton:GetHeight() + 1)
end

function OnGameMenuConfigButtonClick(self)
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
    ToggleConfigPanel()
    if InCombatLockdown() then ShowUIError(L["combat_error"]) end
end

-- 开启/关闭面板
__SlashCmd__ "spa" "config"
__SlashCmd__ "spaui" "config"
__AsyncSingle__()
function ToggleConfigPanel()
    if InCombatLockdown() then
       ShowMessage(L['config_panel_show_after_combat'])
    end
    NoCombat()
    HideUIPanel(GameMenuFrame)
    if ConfigPanel then
        if ConfigPanel:IsShown() then
            ConfigPanel:Hide()
        else
            ConfigPanel:Show()
        end
    end
    _Enabled = true
end

-- 切换调试模式
__SlashCmd__ "spaui" "debug"
__SlashCmd__ "spa" "debug"
__AsyncSingle__()
function ToggleDebugMode(info)
    if not _Config then return end
    if info then
        info = strlower(info)
        if info == "0" or info == "off" or info == "disable" then
            _Config.DebugMode = false
            ShowMessage(L['config_debug_disable'])
        elseif info == "1" or info == "true" or info == "enable" then
            _Config.DebugMode = true
            ShowMessage(L['config_debug_enable'])
        else
            ShowMessage(L['command_error'])
        end
    else
        _Config.DebugMode = false
    end
    if DebugButton then
        Style[DebugButton].Visible = _Config.DebugMode
        Style[DebugButton].Checked = _Config.DebugMode
    end
end

__Async__()
function OnEnable()
    Log("ConfigPanel OnEnable")
    if not ConfigPanel then
        CreateConfigPanel()
    end
end

-- 创建配置面板
__NoCombat__()
function CreateConfigPanel()
    if ConfigPanel then return end
    Log("Create ConfigPanel")

    ConfigPanel = Dialog("SpaUIConfigPanel")
    CategoryPanel = FauxScrollFrame("CategoryList", ConfigPanel)
    ConfigContainer = Frame("Container", ConfigPanel)
    -- 版本号
    Version = FontString("Version", ConfigPanel)
    -- 默认设置
    DefaultButton = UIPanelButton("DefaultButton", ConfigPanel)
    -- 取消
    -- 只有需要reload的选项这个按钮才有用，其它时候只是简单的关闭面板
    CancelButton = UIPanelButton("CancelButton", ConfigPanel)
    CancelButton.OnClick = function(self)
        ConfigPanel:Hide()
    end
    -- 确定
    -- 只有需要reload的选项这个按钮才有用，其它时候只是简单的关闭面板
    OkayButton = UIPanelButton("OkayButton", ConfigPanel)
    -- 调试按钮
    DebugButton = OptionsCheckButton("DebugButton", ConfigPanel)

    RefreshCategorys()
    SelectCategory(1)

    Style[ConfigPanel] = {
        size                = Size(858, 660),

        Header              = {
            text            = L['config_panel_title']
        },

        Resizer             = {
            visible         = false
        },

        CloseButton         = {
            visible         = false
        },

        Version             = {
            text            = L['config_version']:format(ScorpioVersion,AddonVersion),
            location        = {
                Anchor("BOTTOMRIGHT", -10, 0, "Container", "TOPRIGHT")
            }
        },

        CategoryList        = {
            size            = Size(175, 569),
            location        = {Anchor("TOPLEFT",22,-40)},
            backdrop                = {
                edgeFile            = [[Interface\Tooltips\UI-Tooltip-Border]],
                edgeSize            = 16,
                tileEdge            = true
            },
            backdropBorderColor     = ColorType(0.6, 0.6, 0.6, 0.6),
            scrollBarHideable       = true,

            ScrollBar               = {
                location            = {
                    Anchor("TOPRIGHT", -6, -24),
                    Anchor("BOTTOMRIGHT", -6, 24)
                },
            },
        },

        Container           = {
            backdrop                = {
                edgeFile            = [[Interface\Tooltips\UI-Tooltip-Border]],
                edgeSize            = 16,
                tileEdge            = true
            },
            backdropBorderColor     = ColorType(0.6, 0.6, 0.6),
            location        = {
                Anchor("TOPLEFT",16,0,"CategoryList","TOPRIGHT"),
                Anchor("BOTTOMLEFT",16,1,"CategoryList","BOTTOMRIGHT"),
                Anchor("RIGHT",-22,0)
            }
        },

        DefaultButton       = {
            size            = Size(96,22),
            text            = DEFAULTS,
            location        = {Anchor("BOTTOMLEFT",22,16)}
        },

        CancelButton        = {
            size            = Size(96,22),
            text            = CANCEL,
            location        = {Anchor("BOTTOMRIGHT",-22,16)}
        },

        OkayButton          = {
            size            = Size(96,22),
            text            = OKAY,
            location        = {Anchor("BOTTOMRIGHT",0,0,"CancelButton","BOTTOMLEFT")}
        },

        DebugButton    = {
            enabled         = false,
            checked         = _Config.DebugMode,
            visible         = _Config.DebugMode or false,
            location        = {Anchor("BOTTOMLEFT",0,0,"CategoryList","TOPLEFT")},
            Label           = {
                text        = L['config_debug']
            }
        }
    }
end

-- 进入战斗关闭面板
__SystemEvent__()
function PLAYER_REGEN_DISABLED()
    if ConfigPanel and ConfigPanel:IsShown() then
        ConfigPanel:Hide()
    end
end

-- 刷新类别
function RefreshCategorys()
    if not CategoryList or not CategoryPanel then return end
    Log("Refresh Config Categorys")
    if not CategoryListButtons then
        CategoryListButtons = {}
    end
    for index, category in ipairs(CategoryList) do
        local button = CategoryListButtons[index]
        if not button then
            button = CategoryListButton("Category"..index, CategoryPanel.ScrollChild)
            local top = index == 1
            button:SetPoint("TOPLEFT",top and CategoryPanel.ScrollChild or CategoryPanel.ScrollChild:GetChild("Category"..(index-1)),top and "TOPLEFT" or "BOTTOMLEFT", 0, top and -8 or -5)
            button:InstantApplyStyle()
            button.OnClick = OnCategoryButtonClick
            CategoryListButtons[index] = button
        end
        button:SetCategory(category)
        button:Show()
    end
end

-- 类别点击事件
function OnCategoryButtonClick(self)
    for _, button in ipairs(CategoryListButtons) do
        local module = _Modules[button.category.module]
        if button == self then
            button:LockHighlight()
            button:GetHighlightTexture():SetVertexColor(1, 1, 0)
            module.Show()
        else
            button:UnlockHighlight()
            button:GetHighlightTexture():SetVertexColor(.196, .388, .8)
            module.Hide()
        end
    end
end

-- 选中类别
function SelectCategory(index)
    if not CategoryListButtons then return end
    local button = CategoryListButtons[index]
    if button then
        OnCategoryButtonClick(button)
    end
end

-- 需要保存的字段
NecessaryFieldToDB = {
    Enable              = true
}

-- 清除不合法及不需要的字段
__Arguments__(RawTable)
function ClearUnnecessaryFiledFromTable(table)
    for field, value in pairs(table) do
        if not NecessaryFieldToDB[field] then
            if type(value) == "table" then
                ClearUnnecessaryFiledFromTable(value)
            else
                table[field] = nil
            end
        end
    end
end

__Arguments__{NEString, RawTable}
function SetDefaultToConfigDB(key,table)
    ClearUnnecessaryFiledFromTable(table)
    _Config:SetDefault(key,table)
end