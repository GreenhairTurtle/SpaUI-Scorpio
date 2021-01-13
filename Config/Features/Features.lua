Scorpio "SpaUI.Config.Features" ""

L = _Locale

function OnLoad(self)
    _Enabled = false
end

function Show()
    
end

function Hide()
    
end

function OnSaveConfig()
    if not ConfigItems then return end
    for _, configItem in ipairs(ConfigItems) do
        configItem:OnSaveConfig()
    end
end

-- 不太希望这几个函数放在父模组内，尽管可以这样,使用起来也方便

-- 保存配置
function OnSaveConfig()
    if not ConfigItems then return end
    for _, configItem in ipairs(ConfigItems) do
        configItem:OnSaveConfig()
    end
end

-- 还原状态
function OnRestore()
    if not ConfigItems then return end
    for _, configItem in ipairs(ConfigItems) do
        configItem:OnRestore()
    end
end

-- 是否需要重载界面
function NeedReload()
    if ConfigItems then
        for _, configItem in ipairs(ConfigItems) do
            if configItem:NeedReload() then return true end
        end
    end
end

-- 添加变更后需要重载的配置项
function AddReloadWatch(item)
    if not ConfigItems then ConfigItems = {} end
    if Interface.ValidateValue(ConfigItem, item) then
        tinsert(ConfigItems, item)
    end
end

-- 添加变更后需要重载的配置项列表
__Arguments__(UIObject)
function AddReloadWatchList(parent)
    AddReloadWatch(parent)
    for _, child in parent:GetChilds() do
        AddReloadWatchList(child)
    end
end
----------  end  -----------
----------------------------