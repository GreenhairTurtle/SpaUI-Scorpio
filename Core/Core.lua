local addonName,addon = ...
Scorpio "SpaUI" ""

L = _Locale

-- 显示红字错误
function ShowUIError(string)
    UIErrorsFrame:AddMessage(string, 1.0, 0.0, 0.0, 1, 3)
end

-- 显示消息
function ShowMessage(string)
    print(L["message_format"]:format(string))
end

function OnLoad(self)
    ShowMessage(L["addon_loaded_tip"]:format(GetAddOnMetadata(addonName,"version")))
end

-- 简化/reload
__SlashCmd__ "rl"
function Reload()
    ReloadUI()
end