Scorpio "SpaUI.Config" ""

L = _Locale
local InCombatLockdown = InCombatLockdown

function OnLoad()
    _Enabled = false
end

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
    CategoryList = FauxScrollFrame("CategoryList", ConfigPanel)

    Style[ConfigPanel] = {
        size                = Size(858, 660),

        Header              = {
            text            = L['config_panel_title']
        },

        Resizer             = {
            visible         = false
        },

        CategoryList        = {
            size            = Size(175, 569),
            location        = {Anchor("TOPLEFT",22,-40)},
            backdrop                = {
                edgeFile            = [[Interface\Tooltips\UI-Tooltip-Border]],
                edgeSize            = 16,
                tileEdge            = true,
                insets              = { left = 0, right = 0, top = 5, bottom = 5 }
            },
            backdropBorderColor     = ColorType(0.6, 0.6, 0.6, 0.6),
            scrollBarHideable       = true,

            ScrollBar               = {
                location            = {
                    Anchor("TOPRIGHT", -6, -24),
                    Anchor("BOTTOMRIGHT", -6, 24)
                },
            },
        }
    }
end

function OnDisable()
    Log("ConfigPanel OnDisable")
end