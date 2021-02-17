Scorpio "SpaUI.Config.ChangeLog" ""

ChangeLogPageSize = 5

function OnLoad(self)
    _Enabled = false
end

function Show()
    if not ChangeLogContainer then _Enabled = true return end
    ChangeLogContainer:Show()
end

function Hide()
    if not ChangeLogContainer then return end
    ChangeLogContainer:Hide()
end

function OnEnable(self)
    CreateChangeLogContent()
    -- 介绍页
    ChangeLogContainer = FauxScrollFrame("ChangeLogContainer", ConfigContainer)
    LoadChangeLogItems()

    Style[ChangeLogContainer] = {
        location                = {
            Anchor("TOPLEFT", 15, -15),
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
end

-- 加载更新日志
-- 不考虑复用了，以后只显示最近的10条就好了
function LoadChangeLogItems()
    if not ChangeLogContent or #ChangeLogContent <= 0 then return end
    local currentSize = ChangeLogContainer.CurrentSize or 0
    local loadIdx = currentSize
    for index = currentSize + 1, currentSize + ChangeLogPageSize do
        local changeLogItem = ChangeLogContent[index]
        if not changeLogItem then break end
        local title = FontString("Title"..index, ChangeLogContainer.ScrollChild, "GameFontNormal")
        local content = FontString("Content"..index, ChangeLogContainer.ScrollChild, nil, "GameFontWhite")
        title:SetText(("%s %s"):format(changeLogItem.version, changeLogItem.date))
        content:SetText(changeLogItem.content)
        title:SetJustifyH("LEFT")
        content:SetJustifyH("LEFT")
        title:SetPoint("LEFT",ChangeLogContainer.ScrollChild,"LEFT")
        title:SetPoint("TOP",index==1 and ChangeLogContainer.ScrollChild or ChangeLogContainer.ScrollChild:GetChild("Content"..(index-1)),"BOTTOM",0,index==1 and 0 or -15)
        title:SetPoint("RIGHT",ChangeLogContainer.ScrollBar,"Left",-15,0)
        content:SetPoint("TOPLEFT",title,"BOTTOMLEFT",20,-10)
        content:SetPoint("RIGHT",ChangeLogContainer.ScrollBar,"Left",-15,0)
        loadIdx = index
    end
    ChangeLogContainer.CurrentSize = loadIdx

    local LoadMoreButton = ChangeLogContainer.ScrollChild:GetChild("LoadMoreButton")

    if not LoadMoreButton then
        LoadMoreButton = UIPanelButton("LoadMore", ChangeLogContainer.ScrollChild)
        LoadMoreButton:SetText(L["config_load_more"])
        LoadMoreButton.OnClick = function(self)
            LoadChangeLogItems()
        end
    end

    if loadIdx > 0 then
        LoadMoreButton:SetPoint("TOP",ChangeLogContainer.ScrollChild:GetChild("Content"..loadIdx),"BOTTOM",0,-20)
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