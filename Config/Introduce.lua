Scorpio "SpaUI.Config.Introduce" ""

L = _Locale

__Async__()
function OnEnable(self)
    CreateChangeLogContent()
    -- 介绍页
    IntroduceConainter = Frame("Introduce", ConfigContainer)
    FontString("IntroduceText", IntroduceConainter)
    FontString("ChangeLogTitle", IntroduceConainter)
    ChangeLogFrame = FauxScrollFrame("ChangeLog", IntroduceConainter)

    for index, changeLogItem in pairs(ChangeLogContent) do
        local title = FontString("Title"..index, ChangeLogFrame.ScrollChild, "GameFontNormal")
        local content = FontString("Content"..index, ChangeLogFrame.ScrollChild, nil, "GameFontWhite")
        title:SetText(("%s %s"):format(changeLogItem.version, changeLogItem.date))
        content:SetText(changeLogItem.content)
        title:SetJustifyH("LEFT")
        content:SetJustifyH("LEFT")
        title:SetPoint("LEFT",ChangeLogFrame.ScrollChild,"LEFT")
        title:SetPoint("TOP",index==1 and ChangeLogFrame.ScrollChild or ChangeLogFrame.ScrollChild:GetChild("Content"..(index-1)),"BOTTOM",0,index==1 and 0 or -20)
        -- title:SetPoint("RIGHT",ChangeLogFrame.ScrollChild,"RIGHT")
        content:SetPoint("TOPLEFT",title,"BOTTOMLEFT",24,-10)
        -- content:SetPoint("RIGHT",ChangeLogFrame.ScrollChild,"RIGHT")
    end

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
            },

            -- ScrollChild             = {
            --     location            = {
            --         Anchor("TOPLEFT"),
            --         Anchor("TOPRIGHT", -28, 0)
            --     }
            -- }
        }
    }
end

function CreateChangeLogContent()
    if ChangeLogContent then return end
    ChangeLogContent = {
        {
            version         = "Alpha-v1.1",
            date            = "2020/10/21",
            content         = [[测试测试测试测试]]
        },
        {
            version         = "Alpha-v1.1",
            date            = "2020/10/21",
            content         = [[测试测试测试测试]]
        },
        {
            version         = "Alpha-v1.1",
            date            = "2020/10/21",
            content         = [[测试测试测试测试]]
        },
        {
            version         = "Alpha-v1.1",
            date            = "2020/10/21",
            content         = [[测试测试测试测试]]
        },
        {
            version         = "Alpha-v1.1",
            date            = "2020/10/21",
            content         = [[测试测试测试测试]]
        },
        {
            version         = "Alpha-v1.1",
            date            = "2020/10/21",
            content         = [[测试测试测试测试]]
        },
        {
            version         = "Alpha-v1.1",
            date            = "2020/10/21",
            content         = [[测试测试测试测试]]
        },
        {
            version         = "Alpha-v1.1",
            date            = "2020/10/21",
            content         = [[测试测试测试测试]]
        },
        {
            version         = "Alpha-v1.1",
            date            = "2020/10/21",
            content         = [[测试测试测试测试]]
        },
        {
            version         = "Alpha-v1.1",
            date            = "2020/10/21",
            content         = [[测试测试测试测试]]
        },
        {
            version         = "Alpha-v1.1",
            date            = "2020/10/21",
            content         = [[测试测试测试测试]]
        },
        {
            version         = "Alpha-v1.1",
            date            = "2020/10/21",
            content         = [[测试测试测试测试]]
        },
        {
            version         = "Alpha-v1.1",
            date            = "2020/10/21",
            content         = [[测试测试测试测试]]
        },
        {
            version         = "Alpha-v1.1",
            date            = "2020/10/21",
            content         = [[测试测试测试测试]]
        },
        {
            version         = "Alpha-v1.0",
            date            = "2020/10/21",
            content         = [[第一个版本]]
        }
    }
end