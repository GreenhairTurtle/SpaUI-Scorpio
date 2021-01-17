Scorpio "SpaUI.Config.Features" ""

namespace "SpaUI.Widget.Config.Features"
L = _Locale

ConfigBehaivors = {
    EasyDelete                          = {
        Default                         = {
            Enable                      = true
        },
        NeedReload                      = function(self)
            return self.TempValue ~= nil and self.TempValue ~= DB.EasyDelete.Enable
        end,
        OnValueChange                       = function(self, value)
            self.TempValue = value
        end,
        OnSaveConfig                        = function(self)
            DB.EasyDelete.Enable  = self.TempValue
        end,
        GetValue                            = function(self)
            return DB.EasyDelete.Enable
        end,
        OnRestore                           = function(self)
            self.TempValue = nil
        end,
    }
}

function OnLoad(self)
    _Enabled = false
    _Parent.SetDefaultToConfigDB(_Name, ConfigBehaivors)
    DB = _Config[_Name]
end

__Arguments__{NEString, RawTable}
function SetDefaultToConfigDB(childName,table)
    ConfigBehaivors[childName] = table
    _Parent.SetDefaultToConfigDB(_Name, ConfigBehaivors)
end

__Arguments__{NEString, RawTable}
function SetDefaultToCharConfigDB(childName,table)
    CharConfigBehaivors = CharConfigBehaivors or {}
    CharConfigBehaivors[childName] = table
    _Parent.SetDefaultToCharConfigDB(_Name,CharConfigBehaivors)
end

function Show(childModule)
    if not FeaturesContainer then 
        _Enabled = true
    end
    if childModule then
        _Modules[childModule].Show()
        FeaturesContainer:Hide()
    else
        FeaturesContainer:Show()
    end
end

function Hide(childModule)
    if childModule then
        _Modules[childModule]:Hide()
    else
        if not FeaturesContainer then return end
        FeaturesContainer:Hide()
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

function OnEnable(self)
    FeaturesContainer = Frame("FeaturesContainer", ConfigContainer)
    FeaturesTitle = FontString("FeaturesTitle", FeaturesContainer)
    OptionsCheckButton("EasyDeleteEnableButton", FeaturesContainer)
    
    AddReloadWatchList(FeaturesContainer)

    Style[FeaturesContainer] = {
        location                        = {
            Anchor("TOPLEFT", 15, -15),
            Anchor("BOTTOMRIGHT", -15, 15)
        },

        FeaturesTitle                   = {
            location                    = {
                Anchor("TOPLEFT")
            },
            text                        = L["config_category_features_title"],
            fontObject                  = GameFontNormalLarge
        },

        EasyDeleteEnableButton          = {
            configBehavior              = ConfigBehaivors.EasyDelete,
            tooltipText                 = L["config_category_features_easy_delete_tooltip"],
            location                    = {
                Anchor("TOPLEFT", -3, -5, "FeaturesTitle", "BOTTOMLEFT")
            },
            Label                       = {
                text                    = L["config_category_features_esay_delete"]
            }
        }
    }
end