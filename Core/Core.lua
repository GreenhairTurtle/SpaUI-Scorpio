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

-------------------
-- 常用的一些方法 --
-------------------

-- RGB颜色转16进制
function RGBToHex(r, g, b)
    r = r <= 255 and r >= 0 and r or 0
    g = g <= 255 and g >= 0 and g or 0
    b = b <= 255 and b >= 0 and b or 0
    return string.format("%02x%02x%02x", r, g, b)
end

-- 字符串颜色格式化
-- return non nil
function FormatColorTextByRGB(text, r, g, b)
    if not text then return "" end
    r = r <= 255 and r >= 0 and r or 0
    g = g <= 255 and g >= 0 and g or 0
    b = b <= 255 and b >= 0 and b or 0
    return string.format("\124cff%02x%02x%02x%s\124r", r, g, b, text)
end

-- RGB颜色(百分比)转16进制
function RGBPercToHex(r, g, b)
    r = r <= 1 and r >= 0 and r or 0
    g = g <= 1 and g >= 0 and g or 0
    b = b <= 1 and b >= 0 and b or 0
    return string.format("%02x%02x%02x", r * 255, g * 255, b * 255)
end

-- 字符串颜色格式化
-- return non nil
function FormatColorTextByRGBPerc(text, r, g, b)
    if not text then return "" end
    r = r <= 1 and r >= 0 and r or 0
    g = g <= 1 and g >= 0 and g or 0
    b = b <= 1 and b >= 0 and b or 0
    return string.format("\124cff%02x%02x%02x%s\124r", r * 255, g * 255, b * 255 , text)
end

-- 显示红字错误
function ShowUIError(string)
    UIErrorsFrame:AddMessage(string, 1.0, 0.0, 0.0, 1, 3)
end

-- 显示消息
function ShowMessage(string)
    print(L["message_format"]:format(string))
end