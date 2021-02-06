-- 大米不同层数装备奖励明细
Scorpio "SpaUI.Features.KeystoneRewardLevel" ""

RewardItemMargin = 5
local GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel

-- 系统api有问题，懒得查原因，直接写死
REWARD_LEVELS = {
    {level = 2, firstWeek = 187, endofRunLevel = 187, weeklyLevel = 200},
    {level = 3, firstWeek = 190, endofRunLevel = 190, weeklyLevel = 203},
    {level = 4, firstWeek = 194, endofRunLevel = 194, weeklyLevel = 207},
    {level = 5, firstWeek = 194, endofRunLevel = 194, weeklyLevel = 210},
    {level = 6, firstWeek = 197, endofRunLevel = 197, weeklyLevel = 210},
    {level = 7, firstWeek = 200, endofRunLevel = 200, weeklyLevel = 213},
    {level = 8, firstWeek = 200, endofRunLevel = 200, weeklyLevel = 216},
    {level = 9, firstWeek = 200, endofRunLevel = 200, weeklyLevel = 216},
    {level = 10, firstWeek = 203, endofRunLevel = 203, weeklyLevel = 220},
    {level = 11, firstWeek = 203, endofRunLevel = 203, weeklyLevel = 220},
    {level = 12, firstWeek = 203, endofRunLevel = 207, weeklyLevel = 223},
    {level = 13, firstWeek = 203, endofRunLevel = 207, weeklyLevel = 223},
    {level = 14, firstWeek = 203, endofRunLevel = 207, weeklyLevel = 226},
    {level = 15, firstWeek = 203, endofRunLevel = 210, weeklyLevel = 226},
}

__Async__()
function OnEnable(self)
    if not IsAddOnLoaded('Blizzard_ChallengesUI') then
        while NextEvent("ADDON_LOADED") ~= 'Blizzard_ChallengesUI' do end
    end
    CreateRewardFrames()
end

function IsFirstWeek()
    local dateTable = {year=2020,month=12,day=17,hour=7,min=0,sec=0}
    return GetServerTime() < time(dateTable)
end

__AsyncSingle__()
function CreateRewardFrames()
    if not ChallengesFrame then 
        Log("ChallengesFrame is nil")
        return
    end
    if RewardContainer then return end
    Log("CreateRewardFrames")

    RewardContainer = Frame("SpaUIChallengesRewardContainer",ChallengesFrame,"BasicFrameTemplateWithInset")
    RewardContainer.TitleText:SetText(L["key_stone_reward_title"])

    local DifficultyTextTitle =  FontString("DifficultyTextTitle", RewardContainer)
    DifficultyTextTitle:SetPoint("LEFT",RewardContainer.LeftBorder,"RIGHT",0,0)
    DifficultyTextTitle:SetPoint("TOP",RewardContainer.LeftBorder,"TOP",0,-RewardItemMargin)
    DifficultyTextTitle:SetPoint("RIGHT",RewardContainer,"CENTER",0,0)

    local RewardTextTitle = FontString("RewardTextTitle", RewardContainer)
    RewardTextTitle:SetPoint("RIGHT",RewardContainer.RightBorder,"LEFT",0,0)
    RewardTextTitle:SetPoint("TOP",RewardContainer.RightBorder,"TOP",0,-RewardItemMargin)
    RewardTextTitle:SetPoint("LEFT",RewardContainer,"CENTER",0,0)

    Style[RewardContainer] = {
        width               = 200,
        location            = {
            Anchor("LEFT", 0, 0, ChallengesFrame:GetName(), "RIGHT"),
            Anchor("TOP", 0, 0, ChallengesFrame:GetName(), "TOP"),
            Anchor("BOTTOM", 0, 2, ChallengesFrame:GetName(), "BOTTOM")
        },

        DifficultyTextTitle = {
            text            = L["key_stone_reward_title_difficulty"],
            fontobject      = GameFontNormal
        },
        
        RewardTextTitle     = {
            text            = L["key_stone_reward_title_level"],
            fontobject      = GameFontNormal
        }
    }

    local isFirstWeek = IsFirstWeek()
    for i = #REWARD_LEVELS, 1, -1 do
        local rewardInfo = REWARD_LEVELS[i]
        local DifficultyTextLevel = FontString("DifficultyText"..i, RewardContainer,nil,"GameFontHighlight")

        if i == #REWARD_LEVELS then
            DifficultyTextLevel:SetPoint("TOP", DifficultyTextTitle,"BOTTOM",0,-RewardItemMargin)
        else
            DifficultyTextLevel:SetPoint("TOP", RewardContainer["DifficultyText"..(i+1)],"BOTTOM",0,-RewardItemMargin)
        end
        DifficultyTextLevel:SetPoint("LEFT",RewardContainer.LeftBorder,"RIGHT",0,0)
        DifficultyTextLevel:SetPoint("RIGHT",RewardContainer,"CENTER",0,0)
        DifficultyTextLevel:SetText(rewardInfo.level)
        
        local RewardTextLevel = FontString("RewardText"..i,RewardContainer,nil,"GameFontHighlight")
        if i == #REWARD_LEVELS then
            RewardTextLevel:SetPoint("TOP",RewardTextTitle,"BOTTOM",0,-RewardItemMargin)
        else
            RewardTextLevel:SetPoint("TOP",RewardContainer["RewardText"..(i+1)],"BOTTOM",0,-RewardItemMargin)
        end
        RewardTextLevel:SetPoint("RIGHT",RewardContainer.RightBorder,"LEFT",0,0)
        RewardTextLevel:SetPoint("LEFT",RewardContainer,"CENTER",0,0)
        RewardTextLevel:SetText(("%d(%d)"):format(isFirstWeek and rewardInfo.firstWeek or rewardInfo.endofRunLevel,rewardInfo.weeklyLevel))
    end

    local CurrentDifficultyText = FontString("CurrentDifficultyText",RewardContainer,nil,"GameFontGreen")
    CurrentDifficultyText:SetText(L["key_stone_current_owned"])
    CurrentDifficultyText:SetPoint("LEFT",RewardContainer.LeftBorder,"RIGHT",0,0)
    CurrentDifficultyText:SetPoint("TOP",RewardContainer["RewardText1"],"BOTTOM",0,-RewardItemMargin)

    local CurrentDifficultyLevel = FontString("CurrentDifficultyLevel",RewardContainer,nil,"GameFontGreen")
    CurrentDifficultyLevel:SetPoint("LEFT",RewardContainer.LeftBorder,"RIGHT",0,0)
    CurrentDifficultyLevel:SetPoint("TOP",RewardContainer["DifficultyText1"],"BOTTOM",0,-RewardItemMargin)
    CurrentDifficultyLevel:SetPoint("RIGHT",RewardContainer,"CENTER",0,0)

    local CurrentReward = FontString("CurrentReward",RewardContainer,nil,"GameFontGreen")
    CurrentReward:SetPoint("RIGHT",RewardContainer.RightBorder,"LEFT",0,0)
    CurrentReward:SetPoint("TOP",RewardContainer["RewardText1"],"BOTTOM",0,-RewardItemMargin)
    CurrentReward:SetPoint("LEFT",RewardContainer,"CENTER",0,0)

    UpdateCurrentReward()

    ChallengesFrame:HookScript("OnShow",UpdateCurrentReward)
end

__Async__()
function UpdateCurrentReward()
    if not RewardContainer then return end
    RewardContainer:Show()
    local keyStoneLevel = GetOwnedKeystoneLevel()
    if keyStoneLevel then
        local rewardInfo
        for _,info in ipairs(REWARD_LEVELS) do
            if info.level == keyStoneLevel then  
                rewardInfo = info
                break
            end
        end
        if not rewardInfo then
            local last = REWARD_LEVELS[#REWARD_LEVELS]
            if keyStoneLevel > last.level then
                rewardInfo = last
            end
        end
        if rewardInfo then
            local isFirstWeek = IsFirstWeek()
            RewardContainer.CurrentReward:SetText(("%d(%d)"):format(isFirstWeek and rewardInfo.firstWeek or rewardInfo.endofRunLevel,rewardInfo.weeklyLevel))
            RewardContainer.CurrentDifficultyLevel:SetText(tostring(rewardInfo.level))
        end
    else
        RewardContainer.CurrentReward:SetText("")
        RewardContainer.CurrentDifficultyLevel:SetText("")
    end
end


