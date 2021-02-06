-- 来源于插件开发教程及翻译 https://bbs.nga.cn/read.php?tid=24295645
Scorpio "SpaUI.Chat.ChatLinkTooltips" ""

ShowTooltipTypes = {
    item                = true,
    spell               = true,
    enchant             = true,
    quest               = true,
    talent              = true,
    glyph               = true,
    unit                = true,
    achievement         = true,
    mawpower            = true,--心能
    keystone            = true,--钥石
    currency            = true,
    conduit             = true --导灵器
}

function ShowTooltip(frame, link)
    if _Config.Chat.ChatLinkTooltips.Enable and link then
        local type = strsplit(":", link)
        if ShowTooltipTypes[type] then
            GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
            GameTooltip:SetHyperlink(link)
            GameTooltip:Show()
        end
    end
end

function OnEnable()
    for i = 1, NUM_CHAT_WINDOWS do
        local frame = _G["ChatFrame" .. i]
        frame:HookScript("OnHyperLinkEnter",ShowTooltip)
        frame:HookScript("OnHyperLinkLeave",function(self)         
            GameTooltip:Hide()
        end)
    end 
end
