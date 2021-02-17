Scorpio "SpaUI.Config" ""

local CurrentModule

CategoryList = {
    -- 介绍
    {
        name = L['config_category_introduce'],
        module = "Introduce"
    },
    -- 综合
    {
        name = L['config_category_features'],
        module = "Features",
        children = {
            -- 综合-自动修理&出售
            {
                name = L['config_category_features_auto_sell_repair'],
                module = "AutoSell_Repair",
                isCharOption = true,
                parent = "Features"
            }
        }
    },
    -- 社交
    {
        name = L['config_category_social'],
        module = "Social"
    },
    -- 任务
    {
        name = L['config_category_quest'],
        module = "Quest",
        children = {
            -- 任务-自动交接
            {
                name = L['config_category_quest_auto_turn_in'],
                module = "AutoTurnIn",
                isCharOption = true,
                parent = "Quest"
            }
        }
    },
    -- 动作条
    {
        name = L["config_category_actionbar"],
        module = "ActionBar",
        children = {
            -- 动作条-右边动作条
            {
                name = L["config_category_actionbar_visibility"],
                module = "Visibility",
                parent = "ActionBar"
            }
        }
    },
    -- 单位框体
    {
        name = L["config_category_unitframes"],
        module = "UnitFrames",
        children = {
            -- 单位框体-可见性
            {
                name = L["config_category_unitframes_visibility"],
                module = "Visibility",
                parent = "UnitFrames"
            }
        }
    },
    -- 更新日志
    {
        name = L['config_category_changelog'],
        module = "ChangeLog"
    },
}

function OnLoad()
    _Enabled = false
    hooksecurefunc("GameMenuFrame_UpdateVisibleButtons", InjectConfigButtonToGameMenu)
end

-- 游戏菜单注入Config按钮
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
__SlashCmd__("spa", "config", L["cmd_config"])
__AsyncSingle__()
function ToggleConfigPanel()
    if InCombatLockdown() then
       ShowMessage(L['config_panel_show_after_combat'])
    end
    NoCombat()
    HideUIPanel(GameMenuFrame)
    if ConfigPanel then
        if ConfigPanel:IsShown() then
            Hide()
        else
            Show()
        end
    end
    _Enabled = true
end

-- 显示更新日志
__SlashCmd__("spa","news", L["cmd_news"])
function ShowChangeLog()
    CurrentModule = "ChangeLog"
    ToggleConfigPanel()
end

function Show()
    if ConfigPanel then
        ConfigPanel:Show()
        -- 还原状态
        ConfigContainer:Restore()
    end
end

-- 进入战斗关闭面板
__SystemEvent__("PLAYER_REGEN_DISABLED")
function Hide()
    if ConfigPanel then
        ConfigPanel:Hide()
    end
end

-- 切换调试模式
__SlashCmd__("spa", "debug", L["cmd_debug"])
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
            ShowMessage(L['cmd_error'])
        end
    else
        _Config.DebugMode = false
    end
    if DebugButton then
        DebugButton:SetChecked(_Config.DebugMode)
        if _Config.DebugMode then
            DebugButton:Show()
        else
            DebugButton:Hide()
        end
    end
end

function OnEnable()
    if not ConfigPanel then
        CreateConfigPanel()
    end
end

-- 创建类别
local function CreateCategorys()
    if not CategoryList or not CategoryPanel then return end
    CategoryListButtons = {}
    for index, category in ipairs(CategoryList) do
        local button = CategoryListButton("Category"..index, CategoryPanel.ScrollChild)
        button.OnClick = OnCategoryButtonClick
        button.OnCollpasedChanged = OnCategoryToggleSub
        button:SetCategory(category)
        tinsert(CategoryListButtons, button)

        if category.children then
            for subIndex, subCategory in ipairs(category.children) do
                local subButton = CategoryListButton("Category"..index.."Child"..subIndex, CategoryPanel.ScrollChild)
                subButton.OnClick = OnCategoryButtonClick
                subButton:SetCategory(subCategory)
                tinsert(CategoryListButtons, subButton)
            end
        end
    end
    RefreshCategorys()
end

-- 创建配置面板
__NoCombat__()
function CreateConfigPanel()
    if ConfigPanel then return end

    ConfigPanel = Dialog("SpaUIConfigPanel")
    CategoryPanel = FauxScrollFrame("CategoryList", ConfigPanel)
    ConfigContainer = OptionsContainer("Container", ConfigPanel)
    -- 版本号
    FontString("Version", ConfigPanel)
    -- 默认设置
    DefaultButton = UIPanelButton("DefaultButton", ConfigPanel)
    DefaultButton.OnClick = OnDefaultButtonClick
    -- 取消
    -- 只有需要reload的选项这个按钮才有用，其它时候只是简单的关闭面板
    CancelButton = UIPanelButton("CancelButton", ConfigPanel)
    CancelButton.OnClick = OnCancelButtonClick
    -- 确定
    -- 只有需要reload的选项这个按钮才有用，其它时候只是简单的关闭面板
    OkayButton = UIPanelButton("OkayButton", ConfigPanel)
    OkayButton.OnClick = OnConfirmButtonClick
    -- 调试按钮
    DebugButton = OptionsCheckButton("DebugButton", ConfigPanel)
    -- 角色配置文本
    FontString("CharIndicatorText", ConfigPanel)

    CreateCategorys()
    SelectCategory(CurrentModule)

    Style[ConfigPanel] = {
        size                            = Size(858, 660),

        Header                          = {
            text                        = L['config_panel_title']
        },

        Resizer                         = {
            visible                     = false
        },

        CloseButton                     = {
            visible                     = false
        },

        Version                         = {
            text                        = L['config_version']:format(ScorpioVersion,AddonVersion),
            location                    = {
                Anchor("BOTTOMRIGHT", -10, 0, "Container", "TOPRIGHT")
            }
        },

        CategoryList                    = {
            size                        = Size(175, 569),
            location                    = {Anchor("TOPLEFT",22,-40)},
            backdrop                    = {
                edgeFile                = [[Interface\Tooltips\UI-Tooltip-Border]],
                edgeSize                = 16,
                tileEdge                = true
            },
            backdropBorderColor         = ColorType(0.6, 0.6, 0.6, 0.6),
            scrollBarHideable           = true,

            ScrollBar                   = {
                location                = {
                    Anchor("TOPRIGHT", -6, -24),
                    Anchor("BOTTOMRIGHT", -6, 24)
                },
            },
        },

        Container                       = {
            backdrop                    = {
                edgeFile                = [[Interface\Tooltips\UI-Tooltip-Border]],
                edgeSize                = 16,
                tileEdge                = true
            },  
            backdropBorderColor         = ColorType(0.6, 0.6, 0.6),
            location                    = {
                Anchor("TOPLEFT",16,0,"CategoryList","TOPRIGHT"),
                Anchor("BOTTOMLEFT",16,1,"CategoryList","BOTTOMRIGHT"),
                Anchor("RIGHT",-22,0)
            }
        },

        DefaultButton                   = {
            size                        = Size(96,22),
            text                        = DEFAULTS,
            location                    = {Anchor("BOTTOMLEFT",22,16)}
        },          

        CancelButton                    = {
            size                        = Size(96,22),
            text                        = CANCEL,
            location                    = {Anchor("BOTTOMRIGHT",-22,16)}
        },          

        OkayButton                      = {
            size                        = Size(96,22),
            text                        = OKAY,
            location                    = {Anchor("BOTTOMRIGHT",0,0,"CancelButton","BOTTOMLEFT")}
        },

        DebugButton                     = {
            enabled                     = false,
            checked                     = _Config.DebugMode,
            visible                     = _Config.DebugMode or false,
            location                    = {Anchor("LEFT", 0, 0, "DefaultButton", "RIGHT")},
            Label                       = {
                text                    = L['config_debug']
            }
        },

        CharIndicatorText               = {
            text                        = L["config_char"],
            fontObject                  = GameFontHighlightSmall,
            location                    = {Anchor("BOTTOMLEFT",0,0,"CategoryList","TOPLEFT")}
        }
    }
end

-- 刷新类别
function RefreshCategorys()
    local container = CategoryPanel.ScrollChild
    for index, button in ipairs(CategoryListButtons) do
        local idx = index
        local relativeTo
        while idx > 0 and (not relativeTo or not relativeTo:IsShown())do
            relativeTo = CategoryListButtons[idx -1]
            idx = idx -1
        end
        if not relativeTo then
            relativeTo = container
        end
        local top = index == 1
        local yOffset = top and -8 or -5
        button:SetPoint("TOPLEFT", relativeTo, top and "TOPLEFT" or "BOTTOMLEFT", 0, yOffset)
        index = index + 1
    end
end

-- 获取类别对应的模组
function GetModuleByCategory(category)
    local module = nil
    if category.parent then
        module = _Modules[category.parent]._Modules[category.module]
    else
        module = _Modules[category.module]
    end
    return module
end

-- 展开子类型
function OnCategoryToggleSub(self, collapsed)
    local parent = self.category.module
    for _, button in ipairs(CategoryListButtons) do
        if button.category.parent == parent then
            if collapsed then
                button:Hide()
            else
                button:Show()
            end
        end
    end
    RefreshCategorys()
end

-- 类别点击事件
function OnCategoryButtonClick(self)
    for _, button in ipairs(CategoryListButtons) do
        local category = button.category
        CurrentModule = category.module
        local module,childModule
        if category.parent then
            module = _Modules[category.parent]
            childModule = category.module
        else
            module = _Modules[category.module]
        end
        if button == self then
            button:LockHighlight()
            button:GetHighlightTexture():SetVertexColor(1, 1, 0)
            module.Show(childModule)
        else
            button:UnlockHighlight()
            button:GetHighlightTexture():SetVertexColor(.196, .388, .8)
            module.Hide(childModule)
        end
    end
end

-- 选中类别
function SelectCategory(moduleName)
    if not CategoryListButtons then return end
    moduleName = moduleName or "Introduce"
    local selectedButton
    for _, button in ipairs(CategoryListButtons) do
        if button.category.module == moduleName then
            selectedButton = button
        end
    end
    if not selectedButton then
        selectedButton = CategoryListButtons[1]
    end
    OnCategoryButtonClick(selectedButton)
end

-- 点击确定
__AsyncSingle__()
function OnConfirmButtonClick(self)
    if ConfigContainer:NeedReload() then
        local result = Confirm(L["config_reload_confirm"])
        if result then OnConfirm() end
        return
    end
    Hide()
end

-- 点击取消
__AsyncSingle__()
function OnCancelButtonClick(self)
    if ConfigContainer:NeedReload() then
        local result = Confirm(L["config_cancel_confirm"])
        if result then Hide() end
        return
    end
    Hide()
end

-- 确定
function OnConfirm()
    ConfigContainer:SaveConfig()
    ReloadUI()
end

-- 点击默认设置
__AsyncSingle__()
function OnDefaultButtonClick(self)
    local result = Confirm(L["config_default_confirm"])
    if result then
        _Config:Reset()
        _Config.Char:Reset()
        _Config.Char.Spec:ResetAll()
        ReloadUI()
    end
end

-- 默认配置
function SetDefaultToConfigDB(key, globalConfig, charConfig)
    if globalConfig then _Config:SetDefault(key, globalConfig) end
    if charConfig then _Config.Char:SetDefault(key, charConfig) end
end