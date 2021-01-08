Scorpio "SpaUI.Config.Introduce" ""

L = _Locale
ChangeLogPageSize = 5

function OnLoad(self)
    local category = ConfigCategory(L['config_category_introduce'], _Name)
    RegisterCategory(category)
end

__Async__()
function OnEnable(self)
    CreateChangeLogContent()
    -- 介绍页
    IntroduceConainter = Frame("Introduce", ConfigContainer)
    FontString("IntroduceText", IntroduceConainter)
    FontString("ChangeLogTitle", IntroduceConainter)
    ChangeLogFrame = FauxScrollFrame("ChangeLog", IntroduceConainter)
    LoadChangeLogItems()

    Style[IntroduceConainter] = {
        setAllPoints            = true,

        IntroduceText           = {
            fontobject          = GameFontHighlight,
            text                = L["config_addon_introduct"],
            location            = {
                Anchor("LEFT", 15, 0),
                Anchor("RIGHT", -15, 0),
                Anchor("TOP", 0, - 15)
            }
        },

        ChangeLogTitle          = {
            fontobject          = GameFontNormal,
            text                = L["config_changelog_title"],
            location            = {
                Anchor("LEFT", 15, 0),
                Anchor("TOP", 0, -15, "IntroduceText", "BOTTOM")
            }
        },

        ChangeLog               = {
            location            = {
                Anchor("TOPLEFT", 0, -15, "ChangeLogTitle", "BOTTOMLEFT"),
                Anchor("BOTTOMRIGHT", -15, 15)
            },
            scrollBarHideable       = true,

            ScrollBar               = {
                location            = {
                    Anchor("TOPRIGHT", -6, -24),
                    Anchor("BOTTOMRIGHT", -6, 24)
                },
            }
        }
    }
end

-- 加载更新日志
function LoadChangeLogItems()
    if not ChangeLogContent or #ChangeLogContent <= 0 then return end
    local currentSize = ChangeLogFrame.CurrentSize or 0
    local loadIdx = currentSize
    for index = currentSize + 1, currentSize + ChangeLogPageSize do
        local changeLogItem = ChangeLogContent[index]
        if not changeLogItem then break end
        local title = FontString("Title"..index, ChangeLogFrame.ScrollChild, "GameFontNormal")
        local content = FontString("Content"..index, ChangeLogFrame.ScrollChild, nil, "GameFontWhite")
        title:SetText(("%s %s"):format(changeLogItem.version, changeLogItem.date))
        content:SetText(changeLogItem.content)
        title:SetJustifyH("LEFT")
        content:SetJustifyH("LEFT")
        title:SetPoint("LEFT",ChangeLogFrame.ScrollChild,"LEFT")
        title:SetPoint("TOP",index==1 and ChangeLogFrame.ScrollChild or ChangeLogFrame.ScrollChild:GetChild("Content"..(index-1)),"BOTTOM",0,index==1 and 0 or -15)
        title:SetPoint("RIGHT",ChangeLogFrame.ScrollBar,"Left",-15,0)
        content:SetPoint("TOPLEFT",title,"BOTTOMLEFT",24,-10)
        content:SetPoint("RIGHT",ChangeLogFrame.ScrollBar,"Left",-15,0)
        loadIdx = index
    end
    ChangeLogFrame.CurrentSize = loadIdx

    local LoadMoreButton = ChangeLogFrame.ScrollChild:GetChild("LoadMoreButton")

    if not LoadMoreButton then
        LoadMoreButton = UIPanelButton("LoadMore", ChangeLogFrame.ScrollChild)
        LoadMoreButton:SetText(L["config_load_more"])
        LoadMoreButton.OnClick = function(self)
            LoadChangeLogItems()
        end
    end

    if loadIdx > 0 then
        LoadMoreButton:SetPoint("TOP",ChangeLogFrame.ScrollChild:GetChild("Content"..loadIdx),"BOTTOM",0,-20)
    end

    if loadIdx == #ChangeLogContent then
        LoadMoreButton:Hide()
    end
end

function CreateChangeLogContent()
    if ChangeLogContent then return end
    ChangeLogContent = {
        {
            version         = "Alpha-v1.0",
            date            = "2020/10/21",
            content         = [[第一个版本]]
        }
    }
end