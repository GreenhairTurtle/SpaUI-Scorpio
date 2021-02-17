local addonName,_ = ...
Scorpio "SpaUI" ""

L = _Locale

namespace "SpaUI"

struct "NEStrings" { NEString }

function OnLoad(self)
    ScorpioVersion = GetAddOnMetadata("Scorpio","version")
    AddonVersion = GetAddOnMetadata(addonName,"version")
    ShowMessage(L["addon_loaded_tip"]:format(AddonVersion))
    _Config = SVManager("SpaUIConfigDB","SpaUIConfigDBChar")
    if _Config.DebugMode then
        ShowMessage(L['config_debug_enable'])
    end
    C_CVar.SetCVar("taintLog", 2)
end

-- 简化/reload
__SlashCmd__ "rl"
function Reload()
    ReloadUI()
end

-- 字符串染色
__Arguments__{
    Variable("text", NEString),
    Variable("r",ColorFloat),
    Variable("g",ColorFloat),
    Variable("b",ColorFloat),
    Variable("a",ColorFloat,true,1)
}
function ColorText(text,r,g,b,a)
    return Color(r,g,b,a)..text..Color.CLOSE
end

__Arguments__{Color, NEString}
function FormatText(color, text)
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

function Error(...)
    print(L["error_prefix"], ...)
end

function GetNpcID(guid)
    return tonumber(strmatch((guid or ""), "%-(%d-)%-%x-$"))
end

-- 是否为中国区
function IsChinaRegion()
    return GetCurrentRegion() == 5
end

-- 打印table
-- 百度抄的
function Dump(value, desciption, nesting)
    -- if not (_Config and _Config.DebugMode) then return end
    if type(nesting) ~= "number" then nesting = 5 end
 
    local lookupTable = {}
    local result = {}
 
    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end
 
 
    local function _dump(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(desciption)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
        elseif lookupTable[value] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, desciption, spc)
        else
            lookupTable[value] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, desciption)
            else
                result[#result +1 ] = string.format("%s%s = {", indent, _v(desciption))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    _dump(value, desciption, "- ", 1)
 
    for i, line in ipairs(result) do
        print(line)
    end
end