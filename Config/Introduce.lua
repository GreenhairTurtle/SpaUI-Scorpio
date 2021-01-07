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

    local item1 = ChangeLogItemFrame("ChangeLogItem1", ChangeLogFrame.ScrollChild)
    Style[item1].Title = "1111"
    item1.Content = "3333\n44444444422121\n4r-00-qw-dqfqf"
    -- Style[item1].Content = "3333\n44444444422121\n4r-00-qw-dqfqf"
    item1:SetPoint("TOP",0,0)
    item1:SetPoint("LEFT")
    item1:SetPoint("RIGHT")
    -- local item2 = ChangeLogItemFrame("ChangeLogItem2", ChangeLogFrame.ScrollChild)
    -- item2:SetPoint("TOP",item1,"BOTTOM",0,-32)
    -- item2:SetPoint("LEFT")
    -- item2:SetPoint("RIGHT")
    -- Style[item2].Title = "1111"
    -- Style[item2].Content = "2222"

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
        }
    }
end

function CreateChangeLogContent()
    if ChangeLogContent then return end
    ChangeLogContent = {
        ["Alpha-v1.1"]      = {
            date            = "2020/10/21",
            content         = [[
                测试测试测试测试
            ]]
        },
        ["Alpha-v1.0"]      = {
            date            = "2020/10/21",
            content         = [[第一个版本]]
        }
    }
end