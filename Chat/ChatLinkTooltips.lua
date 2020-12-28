-- 来源于插件开发教程及翻译 https://bbs.nga.cn/read.php?tid=24295645
Scorpio "SpaUI.Chat.ChatLinkTooltips" ""

function ShowTooltip(frame, link)
    if link then
        local type = strsplit(":", link)
        if type == "item" or type == "spell" or type == "enchant" or type ==
            "quest" or type == "talent" or type == "glyph" or type == "unit" or
            type == "achievement" or type == "mawpower" or type == "keystone" 
            or type == "currency" then
            GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
            GameTooltip:SetHyperlink(link)
            GameTooltip:Show()
        end
    end
end

function OnEnable()
    for i = 1, NUM_CHAT_WINDOWS do
        local frame = _G["ChatFrame" .. i]
        if frame ~= COMBATLOG then
            frame:HookScript("OnHyperLinkEnter",ShowTooltip)
            frame:HookScript("OnHyperLinkLeave",function(self)           
                GameTooltip:Hide()
            end)
        end
    end 
end
