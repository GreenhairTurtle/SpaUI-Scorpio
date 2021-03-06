Scorpio "SpaUI.Social" ""

BIG_FOOT_CHANNEL_NAME = "大脚世界频道"

-- 找到大脚世界频道的频道id
function GetWorldChannelID()
    local num = C_ChatInfo.GetNumActiveChannels()
    for i = 1, num do
        local _, name = GetChannelName(i)
        if name == BIG_FOOT_CHANNEL_NAME then return i end
    end
end

-- 切换到大脚世界频道
function ChangeToWorldChannel(editbox)
    local channelTarget = GetWorldChannelID()
    if channelTarget then
        editbox:SetAttribute("chatType", "CHANNEL")
        editbox:SetAttribute("channelTarget", channelTarget)
    else
        editbox:SetAttribute("chatType", "SAY")
    end
end