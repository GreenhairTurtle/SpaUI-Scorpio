Scorpio "SpaUI.Config" ""

L = _Locale
local InCombatLockdown = InCombatLockdown

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
        hasChildren = true
    },
    {
        name = L['config_category_features_auto_sell_repair'],
        module = "AutoSell_Repair",
        parent = "Features"
    },
    -- 聊天
    {
        name = L['config_category_chat'],
        module = "Chat"
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
            Hide()
        else
            Show()
        end
    end
    _Enabled = true
end

function Show()
    if ConfigPanel then
        ConfigPanel:Show()
        -- 还原状态
        for _, category in ipairs(CategoryList) do
            local module = GetModuleByCategory(category)
            if module.OnRestore then
                module.OnRestore()
            end
        end
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

-- 创建类别
local function CreateCategorys()
    if not CategoryList or not CategoryPanel then return end
    CategoryListButtons = {}
    for index, category in ipairs(CategoryList) do
        local button = CategoryListButton("Category"..index, CategoryPanel.ScrollChild)
        button.OnClick = OnCategoryButtonClick
        button.OnCollpasedChanged = OnCategoryToggleSub
        button:SetCategory(category)
        CategoryListButtons[index] = button
    end
    RefreshCategorys()
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

    CreateCategorys()
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
function SelectCategory(index)
    if not CategoryListButtons then return end
    local button = CategoryListButtons[index]
    if button then
        OnCategoryButtonClick(button)
    end
end

-- 点击确定
__AsyncSingle__()
function OnConfirmButtonClick(self)
    for _, category in ipairs(CategoryList) do
        local module = GetModuleByCategory(category)
        if module.NeedReload and module.NeedReload() then
            local result = Confirm(L["config_reload_confirm"])
            if result then OnConfirm() end
            return
        end
    end
    Hide()
end

-- 点击取消
__AsyncSingle__()
function OnCancelButtonClick(self)
    for _, category in ipairs(CategoryList) do
        local module = GetModuleByCategory(category)
        if module.NeedReload and module.NeedReload() then
            local result = Confirm(L["config_cancel_confirm"])
            if result then Hide() end
            return
        end
    end
    Hide()
end

-- 确定
function OnConfirm()
    for _, category in ipairs(CategoryList) do
        local module = GetModuleByCategory(category)
        if module.OnSaveConfig then
            module.OnSaveConfig()
        end
    end
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

-- 从ConfigBehaviors里复制默认值
__Arguments__{RawTable, RawTable/nil, String/nil}
function CopyDefaultFromConfigBehaviors(src, des, parentKey)
    des = des or {}
    for field, value in pairs(src) do
        if type(value) == "table" then
            if field ~= "Default" then
                if parentKey then 
                    des[parentKey] = des[parentKey] or {}
                end
                CopyDefaultFromConfigBehaviors(value, des[parentKey] or des, field)
            else
                if parentKey then des[parentKey] = value end
            end
        end
    end
    return des
end

__Arguments__{NEString, RawTable}
function SetDefaultToConfigDB(key,table)
    _Config:SetDefault(key,CopyDefaultFromConfigBehaviors(table))
end