-- 显示农历和节假日
Scorpio "SpaUI.Features.Calendar.ChinaCalendar" ""

CHINA_DATE_VIEW_NAME_PREFIX = "SpaUICalendarDayChinaDate"
CALENDAR_MAX_DAYS_PER_MONTH = 42

function OnLoad(self)
    -- 只在中国启用
    _Enabled = IsChinaRegion()
end

__Async__()
function OnEnable(self)
    CreateLunarData()
    if not IsAddOnLoaded('Blizzard_Calendar') then
        -- 这里不用ADDON_LOADED事件监听Blizzard_Calendar加载
        -- 因为它的第一次加载在OnLoad里面，但其也不一定百分比成功
        -- 所以监听CALENDAR_UPDATE_EVENT_LIST事件确定其一定拿到了数据
        while Wait("CALENDAR_UPDATE_EVENT_LIST") do
            if CalendarFrame then
                break
            end
        end
    end
    CalendarDayButtons = {}
    for i = 1, CALENDAR_MAX_DAYS_PER_MONTH do
        local button = _G["CalendarDayButton"..i]
        CalendarDayButtons[i] = button
        local chinaDate =  FontString(CHINA_DATE_VIEW_NAME_PREFIX..i, _G["CalendarDayButton"..i.."DateFrame"], "ARTWORK", "GameFontHighlightSmall")
        chinaDate:SetPoint("TOPRIGHT", button, "TOPRIGHT", -5, -7)
        chinaDate:SetJustifyH("RIGHT")
        chinaDate:SetWidth(55)
        chinaDate:SetMaxLines(1)
        button.chinaDate = chinaDate
        CalendarFrame_UpdateDay(i)
    end
end

__AddonSecureHook__ "Blizzard_Calendar"
function CalendarFrame_UpdateDay(buttonIndex)
    if not CalendarDayButtons then return end
    local button = CalendarDayButtons[buttonIndex]
    if not button or not button.chinaDate then return end
    if not button.day or not button.monthOffset then return end
    local monthInfo = C_Calendar.GetMonthInfo(button.monthOffset)
    if monthInfo then
        local chinaDate = GetChinaDateData(monthInfo.year, monthInfo.month, button.day)
        if chinaDate then
            button.chinaDate:SetText(GetChinaDateFormat(chinaDate))
            button.chinaDate:Show()
        else
            button.chinaDate:Hide()
        end
    end
end

__AddonSecureHook__ "Blizzard_Calendar"
function CalendarDayButton_OnEnter(self)
    if not self or not self.chinaDate then return end
    if not self.day or not self.monthOffset then return end
    local monthInfo = C_Calendar.GetMonthInfo(self.monthOffset)
    if monthInfo then
        local chinaDate = GetChinaDateData(monthInfo.year, monthInfo.month, self.day)
        if chinaDate then
            GameTooltip:AddLine(" ")
            GameTooltip:AddDoubleLine("农历", chinaDate.month.."月"..chinaDate.day.."日", 1, 0.82, 0, 1, 1, 1)
            if chinaDate.dayDes then
                GameTooltip:AddDoubleLine("节气&节日", table.concat(chinaDate.dayDes, "，"), 1, 0.82, 0, 1, 1, 1)
            end
            if chinaDate.rest then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine(FormatText(Color.BLUE, "今天放假！"))
            elseif chinaDate.work then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine(FormatText(Color.RED, "今天上班！"))
            end
            GameTooltip:Show()
        end
    end

end

function GetChinaDateFormat(date)
    local format = ""
    if date.dayDes then
        format = date.dayDes[#date.dayDes]
    elseif date.rest then
        format = "休"
    elseif date.work then
        format = "班"
    else
        local day = date.day
        if day == 1 then
            format = "初一"
        elseif day == 2 then
            format = "初二"
        elseif day == 3 then
            format = "初三"
        elseif day == 4 then
            format = "初四"
        elseif day == 5 then
            format = "初五"
        elseif day == 6 then
            format = "初六"
        elseif day == 7 then
            format = "初七"
        elseif day == 8 then
            format = "初八"
        elseif day == 9 then
            format = "初九"
        elseif day == 10 then
            format = "初十"
        elseif day == 11 then
            format = "十一"
        elseif day == 12 then
            format = "十二"
        elseif day == 13 then
            format = "十三"
        elseif day == 14 then
            format = "十四"
        elseif day == 15 then
            format = "十五"
        elseif day == 16 then
            format = "十六"
        elseif day == 17 then
            format = "十七"
        elseif day == 18 then
            format = "十八"
        elseif day == 19 then
            format = "十九"
        elseif day == 20 then
            format = "二十"
        elseif day == 21 then
            format = "廿一"
        elseif day == 22 then
            format = "廿二"
        elseif day == 23 then
            format = "廿三"
        elseif day == 24 then
            format = "廿四"
        elseif day == 25 then
            format = "廿五"
        elseif day == 26 then
            format = "廿六"
        elseif day == 27 then
            format = "廿七"
        elseif day == 28 then
            format = "廿八"
        elseif day == 29 then
            format = "廿九"
        elseif day == 30 then
            format = "三十"
        end
    end

    local color
    if date.rest then
        color = Color.BLUE
    elseif date.work then
        color = Color.RED
    elseif date.dayDes then
        color = Color.LIGHTSALMON
    else
        color = Color.MINTCREAM
    end
    return FormatText(color, format)
end

struct "ChinaDate" {
    { name = "month",           type = Number, require = true },
    { name = "day",             type = Number, require = true },
    { name = "dayDes",          type = NEStrings, default = nil },
    { name = "rest",            type = Boolean, default = false },
    { name = "work",            type = Boolean, default = false }
}

function GetChinaDateData(year, month, day)
    if not year or not month or not day or not ChinaDateDatas then return end
    local yearDatas = ChinaDateDatas[year]
    if yearDatas then
        local monthDatas = yearDatas[month]
        if monthDatas then return monthDatas[day] end
    end
end

-- 创建数据
-- 用农历算法占的内存得不偿失，
-- 不如直接写死今年的，反正要更新
function CreateLunarData()
    ChinaDateDatas              = {
        [2021]                  = {
            [1]                 = {
                [1]             = ChinaDate(11, 18, {"元旦"}, true),
                [2]             = ChinaDate(11, 19, nil, true),
                [3]             = ChinaDate(11, 20, nil, true),
                [4]             = ChinaDate(11, 21),
                [5]             = ChinaDate(11, 22, {"小寒"}),
                [6]             = ChinaDate(11, 23),
                [7]             = ChinaDate(11, 24),
                [8]             = ChinaDate(11, 25, {"三九"}),
                [9]             = ChinaDate(11, 26),
                [10]            = ChinaDate(11, 27, {"中国人民警察节"}),
                [11]            = ChinaDate(11, 28),
                [12]            = ChinaDate(11, 29),
                [13]            = ChinaDate(12, 1, {"腊月"}),
                [14]            = ChinaDate(12, 2),
                [15]            = ChinaDate(12, 3),
                [16]            = ChinaDate(12, 4),
                [17]            = ChinaDate(12, 5, {"四九"}),
                [18]            = ChinaDate(12, 6),
                [19]            = ChinaDate(12, 7),
                [20]            = ChinaDate(12, 8, {"大寒", "腊八节"}),
                [21]            = ChinaDate(12, 9),
                [22]            = ChinaDate(12, 10),
                [23]            = ChinaDate(12, 11),
                [24]            = ChinaDate(12, 12),
                [25]            = ChinaDate(12, 13),
                [26]            = ChinaDate(12, 14, {"五九"}),
                [27]            = ChinaDate(12, 15),
                [28]            = ChinaDate(12, 16),
                [29]            = ChinaDate(12, 17),
                [30]            = ChinaDate(12, 18),
                [31]            = ChinaDate(12, 19)
            },
            [2]                 = {
                [1]             = ChinaDate(12, 20),
                [2]             = ChinaDate(12, 21),
                [3]             = ChinaDate(12, 22, {"立春"}),
                [4]             = ChinaDate(12, 23, {"六九", "北方小年"}),
                [5]             = ChinaDate(12, 24, {"南方小年"}),
                [6]             = ChinaDate(12, 25),
                [7]             = ChinaDate(12, 26, nil, false, true),
                [8]             = ChinaDate(12, 27),
                [9]             = ChinaDate(12, 28),
                [10]            = ChinaDate(12, 29),
                [11]            = ChinaDate(12, 30, {"除夕"}, true),
                [12]            = ChinaDate(1, 1, {"春节"}, true),
                [13]            = ChinaDate(1, 2, {"七九"}, true),
                [14]            = ChinaDate(1, 3, {"情人节"}, true),
                [15]            = ChinaDate(1, 4, nil, true),
                [16]            = ChinaDate(1, 5, nil, true),
                [17]            = ChinaDate(1, 6, nil, true),
                [18]            = ChinaDate(1, 7, {"雨水"}),
                [19]            = ChinaDate(1, 8),
                [20]            = ChinaDate(1, 9, nil, false, true),
                [21]            = ChinaDate(1, 10),
                [22]            = ChinaDate(1, 11, {"八九"}),
                [23]            = ChinaDate(1, 12),
                [24]            = ChinaDate(1, 13),
                [25]            = ChinaDate(1, 14),
                [26]            = ChinaDate(1, 15, {"元宵节"}),
                [27]            = ChinaDate(1, 16),
                [28]            = ChinaDate(1, 17)
            },
            [3]                 = {
                [1]             = ChinaDate(1, 18),
                [2]             = ChinaDate(1, 19),
                [3]             = ChinaDate(1, 20, {"九九"}),
                [4]             = ChinaDate(1, 21),
                [5]             = ChinaDate(1, 22, {"惊蛰"}),
                [6]             = ChinaDate(1, 23),
                [7]             = ChinaDate(1, 24),
                [8]             = ChinaDate(1, 25, {"妇女节"}),
                [9]             = ChinaDate(1, 26),
                [10]            = ChinaDate(1, 27),
                [11]            = ChinaDate(1, 28),
                [12]            = ChinaDate(1, 29, {"植树"}),
                [13]            = ChinaDate(2, 1, {"二月"}),
                [14]            = ChinaDate(2, 2),
                [15]            = ChinaDate(2, 3, {"消费者权益日"}),
                [16]            = ChinaDate(2, 4),
                [17]            = ChinaDate(2, 5),
                [18]            = ChinaDate(2, 6),
                [19]            = ChinaDate(2, 7),
                [20]            = ChinaDate(2, 8, {"春分"}),
                [21]            = ChinaDate(2, 9),
                [22]            = ChinaDate(2, 10),
                [23]            = ChinaDate(2, 11),
                [24]            = ChinaDate(2, 12),
                [25]            = ChinaDate(2, 13),
                [26]            = ChinaDate(2, 14),
                [27]            = ChinaDate(2, 15),
                [28]            = ChinaDate(2, 16),
                [29]            = ChinaDate(2, 17),
                [30]            = ChinaDate(2, 18),
                [31]            = ChinaDate(2, 19),
            },
            [4]                 = {
                [1]             = ChinaDate(2, 20, {"愚人节"}),
                [2]             = ChinaDate(2, 21),
                [3]             = ChinaDate(2, 22, nil, true),
                [4]             = ChinaDate(2, 23, {"清明节"}, true),
                [5]             = ChinaDate(2, 24, nil, true),
                [6]             = ChinaDate(2, 25),
                [7]             = ChinaDate(2, 26),
                [8]             = ChinaDate(2, 27),
                [9]             = ChinaDate(2, 28),
                [10]            = ChinaDate(2, 29),
                [11]            = ChinaDate(2, 30),
                [12]            = ChinaDate(3, 1, {"三月"}),
                [13]            = ChinaDate(3, 2),
                [14]            = ChinaDate(3, 3),
                [15]            = ChinaDate(3, 4),
                [16]            = ChinaDate(3, 5),
                [17]            = ChinaDate(3, 6),
                [18]            = ChinaDate(3, 7),
                [19]            = ChinaDate(3, 8),
                [20]            = ChinaDate(3, 9, {"谷雨"}),
                [21]            = ChinaDate(3, 10),
                [22]            = ChinaDate(3, 11),
                [23]            = ChinaDate(3, 12),
                [24]            = ChinaDate(3, 13),
                [25]            = ChinaDate(3, 14, nil, false, true),
                [26]            = ChinaDate(3, 15),
                [27]            = ChinaDate(3, 16),
                [28]            = ChinaDate(3, 17),
                [29]            = ChinaDate(3, 18),
                [30]            = ChinaDate(3, 19),
            },
            [5]                 = {
                [1]             = ChinaDate(3, 20, {"劳动节"}, true),
                [2]             = ChinaDate(3, 21, nil, true),
                [3]             = ChinaDate(3, 22, nil, true),
                [4]             = ChinaDate(3, 23, {"青年节"}, true),
                [5]             = ChinaDate(3, 24, {"立夏"}, true),
                [6]             = ChinaDate(3, 25),
                [7]             = ChinaDate(3, 26),
                [8]             = ChinaDate(3, 27, nil, false, true),
                [9]             = ChinaDate(3, 28, {"母亲节"}),
                [10]            = ChinaDate(3, 29),
                [11]            = ChinaDate(3, 30),
                [12]            = ChinaDate(4, 1, {"四月"}),
                [13]            = ChinaDate(4, 2),
                [14]            = ChinaDate(4, 3),
                [15]            = ChinaDate(4, 4),
                [16]            = ChinaDate(4, 5),
                [17]            = ChinaDate(4, 6),
                [18]            = ChinaDate(4, 7),
                [19]            = ChinaDate(4, 8),
                [20]            = ChinaDate(4, 9),
                [21]            = ChinaDate(4, 10, {"小满"}),
                [22]            = ChinaDate(4, 11),
                [23]            = ChinaDate(4, 12),
                [24]            = ChinaDate(4, 13),
                [25]            = ChinaDate(4, 14),
                [26]            = ChinaDate(4, 15),
                [27]            = ChinaDate(4, 16),
                [28]            = ChinaDate(4, 17),
                [29]            = ChinaDate(4, 18),
                [30]            = ChinaDate(4, 19),
                [31]            = ChinaDate(4, 20),
            },
            [6]                 = {
                [1]             = ChinaDate(4, 21, {"儿童节"}),
                [2]             = ChinaDate(4, 22),
                [3]             = ChinaDate(4, 23),
                [4]             = ChinaDate(4, 24),
                [5]             = ChinaDate(4, 25, {"芒种"}),
                [6]             = ChinaDate(4, 26),
                [7]             = ChinaDate(4, 27),
                [8]             = ChinaDate(4, 28),
                [9]             = ChinaDate(4, 29),
                [10]            = ChinaDate(5, 1, {"五月"}),
                [11]            = ChinaDate(5, 2),
                [12]            = ChinaDate(5, 3, nil, true),
                [13]            = ChinaDate(5, 4, nil, true),
                [14]            = ChinaDate(5, 5, {"端午节"}, true),
                [15]            = ChinaDate(5, 6),
                [16]            = ChinaDate(5, 7),
                [17]            = ChinaDate(5, 8),
                [18]            = ChinaDate(5, 9),
                [19]            = ChinaDate(5, 10),
                [20]            = ChinaDate(5, 11, {"父亲节"}),
                [21]            = ChinaDate(5, 12, {"夏至"}),
                [22]            = ChinaDate(5, 13),
                [23]            = ChinaDate(5, 14),
                [24]            = ChinaDate(5, 15),
                [25]            = ChinaDate(5, 16),
                [26]            = ChinaDate(5, 17),
                [27]            = ChinaDate(5, 18),
                [28]            = ChinaDate(5, 19),
                [29]            = ChinaDate(5, 20),
                [30]            = ChinaDate(5, 21),
            },
            [7]                 = {
                [1]             = ChinaDate(5, 22, {"建党节"}),
                [2]             = ChinaDate(5, 23),
                [3]             = ChinaDate(5, 24),
                [4]             = ChinaDate(5, 25),
                [5]             = ChinaDate(5, 26, {"芒种"}),
                [6]             = ChinaDate(5, 27),
                [7]             = ChinaDate(5, 28, {"小暑"}),
                [8]             = ChinaDate(5, 29),
                [9]             = ChinaDate(5, 30),
                [10]            = ChinaDate(6, 1, {"六月"}),
                [11]            = ChinaDate(6, 2),
                [12]            = ChinaDate(6, 3),
                [13]            = ChinaDate(6, 4),
                [14]            = ChinaDate(6, 5),
                [15]            = ChinaDate(6, 6),
                [16]            = ChinaDate(6, 7),
                [17]            = ChinaDate(6, 8),
                [18]            = ChinaDate(6, 9),
                [19]            = ChinaDate(6, 10),
                [20]            = ChinaDate(6, 11),
                [21]            = ChinaDate(6, 12, {"入伏"}),
                [22]            = ChinaDate(6, 13, {"大暑"}),
                [23]            = ChinaDate(6, 14),
                [24]            = ChinaDate(6, 15),
                [25]            = ChinaDate(6, 16),
                [26]            = ChinaDate(6, 17),
                [27]            = ChinaDate(6, 18),
                [28]            = ChinaDate(6, 19),
                [29]            = ChinaDate(6, 20),
                [30]            = ChinaDate(6, 21),
                [31]            = ChinaDate(6, 22, {"中伏"}),
            },
            [8]                 = {
                [1]             = ChinaDate(6, 23, {"建军节"}),
                [2]             = ChinaDate(6, 24),
                [3]             = ChinaDate(6, 25),
                [4]             = ChinaDate(6, 26),
                [5]             = ChinaDate(6, 27),
                [6]             = ChinaDate(6, 28),
                [7]             = ChinaDate(6, 29, {"立秋"}),
                [8]             = ChinaDate(7, 1, {"七月"}),
                [9]             = ChinaDate(7, 2),
                [10]            = ChinaDate(7, 3, {"末伏"}),
                [11]            = ChinaDate(7, 4),
                [12]            = ChinaDate(7, 5),
                [13]            = ChinaDate(7, 6),
                [14]            = ChinaDate(7, 7, {"七夕节"}),
                [15]            = ChinaDate(7, 8),
                [16]            = ChinaDate(7, 9),
                [17]            = ChinaDate(7, 10),
                [18]            = ChinaDate(7, 11),
                [19]            = ChinaDate(7, 12),
                [20]            = ChinaDate(7, 13),
                [21]            = ChinaDate(7, 14),
                [22]            = ChinaDate(7, 15, {"中元节"}),
                [23]            = ChinaDate(7, 16, {"处暑"}),
                [24]            = ChinaDate(7, 17),
                [25]            = ChinaDate(7, 18),
                [26]            = ChinaDate(7, 19),
                [27]            = ChinaDate(7, 20),
                [28]            = ChinaDate(7, 21),
                [29]            = ChinaDate(7, 22),
                [30]            = ChinaDate(7, 23),
                [31]            = ChinaDate(7, 24),
            },
            [9]                 = {
                [1]             = ChinaDate(7, 25),
                [2]             = ChinaDate(7, 26),
                [3]             = ChinaDate(7, 27),
                [4]             = ChinaDate(7, 28),
                [5]             = ChinaDate(7, 29),
                [6]             = ChinaDate(7, 30),
                [7]             = ChinaDate(8, 1, {"白露"}),
                [8]             = ChinaDate(8, 2),
                [9]             = ChinaDate(8, 3),
                [10]            = ChinaDate(8, 4, {"教师节"}),
                [11]            = ChinaDate(8, 5),
                [12]            = ChinaDate(8, 6),
                [13]            = ChinaDate(8, 7),
                [14]            = ChinaDate(8, 8),
                [15]            = ChinaDate(8, 9),
                [16]            = ChinaDate(8, 10),
                [17]            = ChinaDate(8, 11),
                [18]            = ChinaDate(8, 12, nil, false, true),
                [19]            = ChinaDate(8, 13, nil, true),
                [20]            = ChinaDate(8, 14, nil, true),
                [21]            = ChinaDate(8, 15, {"中秋节"}, true),
                [22]            = ChinaDate(8, 16),
                [23]            = ChinaDate(8, 17, {"秋分"}),
                [24]            = ChinaDate(8, 18),
                [25]            = ChinaDate(8, 19),
                [26]            = ChinaDate(8, 20, nil, false, true),
                [27]            = ChinaDate(8, 21),
                [28]            = ChinaDate(8, 22),
                [29]            = ChinaDate(8, 23),
                [30]            = ChinaDate(8, 24),
            },
            [10]                = {
                [1]             = ChinaDate(8, 25, {"国庆节"}, true),
                [2]             = ChinaDate(8, 26, nil, true),
                [3]             = ChinaDate(8, 27, nil, true),
                [4]             = ChinaDate(8, 28, nil, true),
                [5]             = ChinaDate(8, 29, nil, true),
                [6]             = ChinaDate(9, 1, {"九月"}, true),
                [7]             = ChinaDate(9, 2, nil, true),
                [8]             = ChinaDate(9, 3, {"寒露"}),
                [9]             = ChinaDate(9, 4, nil, false, true),
                [10]            = ChinaDate(9, 5),
                [11]            = ChinaDate(9, 6),
                [12]            = ChinaDate(9, 7),
                [13]            = ChinaDate(9, 8),
                [14]            = ChinaDate(9, 9, {"重阳节"}),
                [15]            = ChinaDate(9, 10),
                [16]            = ChinaDate(9, 11),
                [17]            = ChinaDate(9, 12),
                [18]            = ChinaDate(9, 13),
                [19]            = ChinaDate(9, 14),
                [20]            = ChinaDate(9, 14),
                [21]            = ChinaDate(9, 16),
                [22]            = ChinaDate(9, 17),
                [23]            = ChinaDate(9, 18, {"霜降"}),
                [24]            = ChinaDate(9, 19),
                [25]            = ChinaDate(9, 20),
                [26]            = ChinaDate(9, 21),
                [27]            = ChinaDate(9, 22),
                [28]            = ChinaDate(9, 23),
                [29]            = ChinaDate(9, 24),
                [30]            = ChinaDate(9, 25),
                [31]            = ChinaDate(9, 26, {"万圣节"}),
            },
            [11]                = {
                [1]             = ChinaDate(9, 27),
                [2]             = ChinaDate(9, 28),
                [3]             = ChinaDate(9, 29),
                [4]             = ChinaDate(9, 30),
                [5]             = ChinaDate(10, 1, {"十月"}),
                [6]             = ChinaDate(10, 2),
                [7]             = ChinaDate(10, 3, {"立冬"}),
                [8]             = ChinaDate(10, 4),
                [9]             = ChinaDate(10, 5),
                [10]            = ChinaDate(10, 6),
                [11]            = ChinaDate(10, 7),
                [12]            = ChinaDate(10, 8),
                [13]            = ChinaDate(10, 9),
                [14]            = ChinaDate(10, 10),
                [15]            = ChinaDate(10, 11),
                [16]            = ChinaDate(10, 12),
                [17]            = ChinaDate(10, 13),
                [18]            = ChinaDate(10, 14),
                [19]            = ChinaDate(10, 15),
                [20]            = ChinaDate(10, 16),
                [21]            = ChinaDate(10, 17),
                [22]            = ChinaDate(10, 18, {"小雪"}),
                [23]            = ChinaDate(10, 19),
                [24]            = ChinaDate(10, 20),
                [25]            = ChinaDate(10, 21, {"感恩节"}),
                [26]            = ChinaDate(10, 22),
                [27]            = ChinaDate(10, 23),
                [28]            = ChinaDate(10, 24),
                [29]            = ChinaDate(10, 25),
                [30]            = ChinaDate(10, 26)
            },
            [12]                = {
                [1]             = ChinaDate(10, 27),
                [2]             = ChinaDate(10, 28),
                [3]             = ChinaDate(10, 29),
                [4]             = ChinaDate(11, 1, {"冬月"}),
                [5]             = ChinaDate(11, 2),
                [6]             = ChinaDate(11, 3),
                [7]             = ChinaDate(11, 4, {"大雪"}),
                [8]             = ChinaDate(11, 5),
                [9]             = ChinaDate(11, 6),
                [10]            = ChinaDate(11, 7),
                [11]            = ChinaDate(11, 8),
                [12]            = ChinaDate(11, 9),
                [13]            = ChinaDate(11, 10, {"国家公祭日"}),
                [14]            = ChinaDate(11, 11),
                [15]            = ChinaDate(11, 12),
                [16]            = ChinaDate(11, 13),
                [17]            = ChinaDate(11, 14),
                [18]            = ChinaDate(11, 15),
                [19]            = ChinaDate(11, 16),
                [20]            = ChinaDate(11, 17),
                [21]            = ChinaDate(11, 18, {"冬至"}),
                [22]            = ChinaDate(11, 19),
                [23]            = ChinaDate(11, 20),
                [24]            = ChinaDate(11, 21, {"平安夜"}),
                [25]            = ChinaDate(11, 22, {"圣诞节"}),
                [26]            = ChinaDate(11, 23),
                [27]            = ChinaDate(11, 24),
                [28]            = ChinaDate(11, 25),
                [29]            = ChinaDate(11, 26),
                [30]            = ChinaDate(11, 27, {"二九"}),
                [31]            = ChinaDate(11, 28)
            },
        }
    }
end