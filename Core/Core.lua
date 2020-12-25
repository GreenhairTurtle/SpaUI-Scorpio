local addonName,_ = ...
Scorpio "SpaUI" ""

L = _Locale

function OnLoad(self)
    ShowMessage(L["addon_loaded_tip"]:format(GetAddOnMetadata(addonName,"version")))
end

-- 简化/reload
__SlashCmd__ "rl"
function Reload()
    ReloadUI()
end

-- 字符串染色
__Static__()
__Arguments__{
    Variable("text",NEString),
    Variable("r",ColorFloat),
    Variable("g",ColorFloat),
    Variable("b",ColorFloat),
    Variable("a",ColorFloat,true,1)
}
function Color.ColorText(text,r,g,b,a)
    return Color(r,g,b,a)..text..Color.CLOSE
end

-- 显示红字错误
function ShowUIError(string)
    UIErrorsFrame:AddMessage(string, 1.0, 0.0, 0.0, 1, 3)
end

-- 显示消息
function ShowMessage(string)
    print(L["message_format"]:format(string))
end