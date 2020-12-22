local addonName,addon = ...
Scorpio "SpaUI" ""

SpaUI = addon
L = _Locale

-- 显示红字错误
function SpaUI:ShowUIError(string)
    UIErrorsFrame:AddMessage(string, 1.0, 0.0, 0.0, 1, 3)
end

-- 显示消息
function SpaUI:ShowMessage(string)
    print(L["message_format"]:format(string))
end

function OnLoad(self)
    SpaUI:ShowMessage(L["addon_loaded_tip"]:format(GetAddOnMetadata(addonName,"version")))
end