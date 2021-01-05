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

    Style[ConfigPanel] = {
        size                = Size(858,660),

        Header              = {
            text            = L['config_panel_title']
        }
    }
end

function OnDisable()
    Log("ConfigPanel OnDisable")
end