local addonName,_ = ...
Scorpio "SpaUI" ""

L = _Locale

function OnLoad(self)
    ScorpioVersion = GetAddOnMetadata("Scorpio","version")
    AddonVersion = GetAddOnMetadata(addonName,"version")
    ShowMessage(L["addon_loaded_tip"]:format(AddonVersion))
    _Config = SVManager("SpaUIConfigDB","SpaUIConfigDBChar")
    if _Config.DebugMode then
        ShowMessage(L['config_debug_enable'])
    end
end

-- 简化/reload
__SlashCmd__ "rl"
function Reload()
    ReloadUI()
end

__SlashCmd__ "spa" "help"
__SlashCmd__ "spaui" "help"
function CmdHelp()
    ShowMessage(L["command_help"])
end

-- 字符串染色
__Arguments__{
    Variable("text",NEString),
    Variable("r",ColorFloat),
    Variable("g",ColorFloat),
    Variable("b",ColorFloat),
    Variable("a",ColorFloat,true,1)
}
function ColorText(text,r,g,b,a)
    return Color(r,g,b,a)..text..Color.CLOSE
end

__Arguments__{Color,NEString}
function FormatText(color,text)
    return color..text..Color.CLOSE
end

-- 显示红字错误
__Arguments__{NEString}
function ShowUIError(text)
    UIErrorsFrame:AddMessage(text, 1.0, 0.0, 0.0, 1, 3)
end

-- 显示消息
__Arguments__{NEString}
function ShowMessage(text)
    print(L["message_format"]:format(text))
end

-- Log
function Log(...)
    if _Config and _Config.DebugMode then
        print(L["debug_prefix"], ...)
    end
end