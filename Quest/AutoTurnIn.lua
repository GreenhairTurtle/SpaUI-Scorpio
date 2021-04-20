-- 自动交接任务
Scorpio "SpaUI.Quest.AutoTurnIn" ""

import "SpaUI.Widget.Config"

-- 忽略的NPC 直接搬的NDui
local IgnoredQuestNPCs = {
	[88570] = true,		-- Fate-Twister Tiklal
	[87391] = true,		-- Fate-Twister Seress
	[111243] = true,	-- Archmage Lan'dalock
	[108868] = true,	-- Hunter's order hall
	[101462] = true,	-- Reaves
	[43929] = true,		-- 4000
	[14847] = true,		-- DarkMoon
	[119388] = true,	-- 酋长哈顿
	[114719] = true,	-- 商人塞林
	[121263] = true,	-- 大技师罗姆尔
	[126954] = true,	-- 图拉扬
	[124312] = true,	-- 图拉扬
	[103792] = true,	-- 格里伏塔
	[101880] = true,	-- 泰克泰克
	[141584] = true,	-- 祖尔温
	[142063] = true,	-- 特兹兰
	[143388] = true,	-- 德鲁扎
	[98489] = true,		-- 海难俘虏
	[135690] = true,	-- 亡灵舰长
	[105387] = true,	-- 安杜斯
	[93538] = true,		-- 达瑞妮斯
	[154534] = true,	-- 大杂院阿畅
	[150987] = true,	-- 肖恩·维克斯，斯坦索姆
	[150563] = true,	-- 斯卡基特，麦卡贡订单日常
	[143555] = true,	-- 山德·希尔伯曼，祖达萨PVP军需官
	[168430] = true,	-- 戴克泰丽丝，格里恩挑战
	[160248] = true,	-- 档案员费安，罪魂碎片
	[127037] = true,	-- 纳毕鲁
	[326027] = true,	-- 运输站回收生成器DX-82
}

local QUEST_WEEKLY = _G.Enum.QuestFrequency.Weekly
local QUEST_DAILY = _G.Enum.QuestFrequency.Daily
local QUEST_DEFAULT = _G.Enum.QuestFrequency.Default
-- 超过100G的任务不自动完成
QUEST_MAX_REQUIRED_MONEY = 100*100*100

function OnLoad(self)
    Config = _Config.Char.Quest.AutoTurnIn
    _Enabled = Config.Enable
end

function OnEnable(self)
    AutoTurnInButton = OptionsCheckButton("SpaUIAutoTurnInButton", ObjectiveTrackerFrame)
    AutoTurnInButton.OnClick = function(self)
        Config.Auto = self:GetChecked()
        FireSystemEvent("SPAUI_TOGGLE_AUTO_TURN_IN")
    end
    AutoTurnInButton.OnEnter = function(self)
        GameTooltip:SetOwner(self)
        GameTooltip:SetText(L["auto_quest_turnin_button_tooltip"]:format(OptionsModifierKey.GetKeyText(Config.ModifierKey)), nil, nil, nil, true)
        GameTooltip:Show()
    end

    Style[AutoTurnInButton] = {
        frameLevel          = ObjectiveTrackerFrame.HeaderMenu:GetFrameLevel(),
        size                = Size(18, 18),
        checked             = Config.Auto
    }
end

local function IsAutoTurnIn()
    local keyDown = OptionsModifierKey.IsKeyDown(Config.ModifierKey)
    return (Config.Auto and not keyDown) or (not Config.Auto and keyDown)
end

local function CanAcceptQuest(questID, isTrivial, frequency, isRepeatable, isIgnored)
    Log(_Name, "CanAcceptQuest",questID, isTrivial, frequency, isRepeatable, isIgnored)
    -- 忽略已忽略任务
    if isIgnored then return false end
    -- 任务日志已满
    local _, numQuests = C_QuestLog.GetNumQuestLogEntries()
    if numQuests >= MAX_QUESTS then return false end

    -- 忽略部分npc
    local npcID = GetNpcID(UnitGUID("npc"))
    if IgnoredQuestNPCs[npcID] then
        Log(_Name, "CanAcceptQuest is ignored npc")
        return false
    end

    -- 检测是否屏蔽
    if not IsAutoTurnIn() then return false end

    if isTrivial then
        if not Config.AutoTrivial then return false end
        if frequency == QUEST_WEEKLY then
            return Config.AutoTrivialWeekly
        end
        if frequency == QUEST_DAILY then
            return Config.AutoTrivialDaily
        end
        if isRepeatable then
            return Config.AutoTrivialRepeatable
        end
        return true
    else
        if frequency == QUEST_WEEKLY then
            return Config.AutoWeekly
        end
        if frequency == QUEST_DAILY then
            return Config.AutoDaily
        end
        if isRepeatable then
            return Config.AutoRepeatable
        end
        return true
    end
end

local function CanCompleteQuest(questID, isComplete)
    if not IsAutoTurnIn() then return false end
    if not isComplete then return false end
    if C_QuestLog.GetRequiredMoney(questID) < QUEST_MAX_REQUIRED_MONEY then
        return true
    end 
end

local function GetActiveQuests()
    local uiMapID = C_Map.GetBestMapForUnit('player')
    if uiMapID then
        local quests = C_QuestLog.GetQuestsOnMap(uiMapID)
        if quests and #quests > 0 then
            local activeQuests = {}
            for _, quest in ipairs(quests) do
                local questID = quest.questID
                local questName = C_QuestLog.GetTitleForQuestID(questID)
                if questName then
                    activeQuests[questName] = questID
                end
            end
            return activeQuests
        end
    end
end 

local function IsQuestNpc()
    local activeQuests = GetActiveQuests()
    if activeQuests then
        SpaUIScanningTooltip:ClearLines()
        SpaUIScanningTooltip:SetUnit("npc")
        for i = 1, SpaUIScanningTooltip:NumLines() do
            local fontString = _G['SpaUIScanningTooltipTextLeft' .. i]
            local text = fontString and fontString:GetText()
            if text and activeQuests[text] then return true end
        end
    end
    return nil
end

__SystemEvent__()
function GOSSIP_SHOW()
    Log(_Name, "GOSSIP_SHOW")
    if not IsAutoTurnIn() then return end

    local activeNum = C_GossipInfo.GetNumActiveQuests()
    if activeNum > 0 then
        local quests = C_GossipInfo.GetActiveQuests()
        for i = 1, activeNum do
            local quest = quests[i]
            if quest and CanCompleteQuest(quest.questID, quest.isComplete) and GossipFrame:IsVisible() and UnitExists("npc") then
                return C_GossipInfo.SelectActiveQuest(i)
            end
        end
    end

    local availableNum = C_GossipInfo.GetNumAvailableQuests()
    if availableNum > 0 then
        local quests = C_GossipInfo.GetAvailableQuests()
        for i = 1, availableNum do
           local quest = quests[i]
           if quest and CanAcceptQuest(quest.questID, quest.isTrivial, quest.frequency, quest.repeatable, quest.isIgnored) then
                if GossipFrame:IsVisible() and UnitExists("npc") then
                    return C_GossipInfo.SelectAvailableQuest(i)
                end
           end
        end
    end

    local gossipNum = C_GossipInfo.GetNumOptions()
    if gossipNum > 0 then
        local gossips = C_GossipInfo.GetOptions()
        -- 如果有选项标记为(任务)，点击该选项
        for i = 1, gossipNum do
            local gossip = gossips[i]
            if gossip.type == "gossip" and gossip.name:match(L["config_quest_auto_turn_in_auto_gossip_pattern"]) then
                if GossipFrame:IsVisible() and UnitExists("npc") then
                    return C_GossipInfo.SelectOption(i)
                end
            end
        end

        -- 是任务npc并且只有一个选项时
        if GossipFrame:IsVisible() and UnitExists("npc") then
            if gossipNum == 1 and gossips[1].type == "gossip" and IsQuestNpc() then
                C_GossipInfo.SelectOption(1)
            end
        end
    end
end

__SystemEvent__()
function QUEST_PROGRESS()
    Log(_Name, "QUEST_PROGRESS")
    if QuestFrame:IsVisible() and UnitExists("npc") and CanCompleteQuest(GetQuestID(), IsQuestCompletable()) then
        CompleteQuest()
    end
end

__SystemEvent__()
function QUEST_COMPLETE()
    Log(_Name, "QUEST_COMPLETE")
    if QuestFrame:IsVisible() and UnitExists("npc")
        and not (GetNumQuestChoices() > 1) then
        GetQuestReward(1)
    end
end

__SystemEvent__()
function QUEST_GREETING()
    Log("QUEST_GREETING")
    if not IsAutoTurnIn() then return end

    local activeNum = GetNumActiveQuests()
    if activeNum > 0 then
        for i = 1, activeNum do
            local questID = GetActiveQuestID(i)
            local _, isComplete = GetActiveTitle(i)
            if questID and CanCompleteQuest(questID, isComplete) and QuestFrame:IsVisible() and UnitExists("npc") then
                return SelectActiveQuest(i)
            end
        end
    end

    local availableNum = GetNumAvailableQuests()
    if availableNum > 0 then
        for i = 1, availableNum do
           local isTrivial, frequency, isRepeatable, _, questID = GetAvailableQuestInfo(i)
           if questID and CanAcceptQuest(questID, isTrivial, frequency, isRepeatable) then
                if QuestFrame:IsVisible() and UnitExists("npc") then
                    return SelectAvailableQuest(i)
                end
           end
        end
    end
end

__SystemEvent__()
function QUEST_DETAIL()
    Log(_Name, "QUEST_DETAIL")
    local questID = GetQuestID()
    if questID and questID > 0 then
        local frequency = QuestIsWeekly() and QUEST_WEEKLY or (QuestIsDaily() and QUEST_DAILY or QUEST_DEFAULT)
        if CanAcceptQuest(questID, C_QuestLog.IsQuestTrivial(questID), frequency, C_QuestLog.IsRepeatableQuest(questID)) then
            if QuestFrame and QuestFrame:IsVisible() and UnitExists("npc") then
                AcceptQuest()
            end
        end
    end
end

-- 和控制台开关同步
__SystemEvent__()
function SPAUI_TOGGLE_AUTO_TURN_IN()
    if not AutoTurnInButton then return end
    AutoTurnInButton:SetChecked(Config.Auto)
end

-- 动态更新按钮锚点
__SecureHook__()
function ObjectiveTracker_Update()
    if not AutoTurnInButton then return end
    if ObjectiveTrackerFrame.collapsed then
        AutoTurnInButton:Hide()
        return
    end
    if ObjectiveTrackerFrame.MODULES_UI_ORDER then
        for _, module in ipairs(ObjectiveTrackerFrame.MODULES_UI_ORDER) do
            local header = module.Header
            if header.added and header:IsVisible() then
                local relativeTo = header.MinimizeButton
                if not header.MinimizeButton:IsVisible() then
                    relativeTo = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
                end
                AutoTurnInButton:SetPoint("RIGHT", relativeTo, "LEFT", -3, 0.5)
                AutoTurnInButton:Show()
                return
            end
        end
    end
    AutoTurnInButton:Hide()
end