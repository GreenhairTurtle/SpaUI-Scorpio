Scorpio "SpaUI.Config" ""
import "SpaUI.Widget"

L = _Locale
local InCombatLockdown = InCombatLockdown

function OnLoad()
    _Enabled = false
end

-- 开启/关闭面板
__SlashCmd__ "spa"
__SlashCmd__ "spaui"
__AsyncSingle__()
function ToggleConfigPanel()
    if InCombatLockdown() then
       ShowMessage(L['config_panel_show_after_combat'])
    end
    NoCombat()
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
            ShowMessage(L['command_debugmode_disable'])
        elseif info == "1" or info == "true" or info == "enable" then
            _Config.DebugMode = true
            ShowMessage(L['command_debugmode_enable'])
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
    ConfigCategory = FauxScrollFrame("CategoryList", ConfigPanel)
    ConfigContainer = Frame("Container", ConfigPanel)
    -- 版本号
    Version = FontString("Version", ConfigPanel)
    -- 默认设置
    DefaultButton = UIPanelButton("DefaultButton", ConfigPanel)
    -- 取消
    -- 只有需要reload的选项这个按钮才有用，其它时候只是简单的关闭面板
    CancelButton = UIPanelButton("CancelButton", ConfigPanel)
    -- 确定
    -- 只有需要reload的选项这个按钮才有用，其它时候只是简单的关闭面板
    OkayButton = UIPanelButton("OkayButton", ConfigPanel)
    -- 调试按钮
    DebugButton = OptionsCheckButton("DebugButton", ConfigPanel)
    DebugButton.TooltipText = L['config_debug_tooltip']

    Style[ConfigPanel] = {
        size                = Size(858, 660),

        Header              = {
            text            = L['config_panel_title']
        },

        Resizer             = {
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
            visible         = _Config.DebugMode,
            location        = {Anchor("BOTTOMLEFT",0,0,"CategoryList","TOPLEFT")},
            Label           = {
                text        = L['config_debug']
            }
        }
    }
end

function OnDisable()
    Log("ConfigPanel OnDisable")
end