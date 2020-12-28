Scorpio "SpaUI.Features.Movable" ""

MovableFrames = {
    -- 角色信息
    ["CharacterFrame"] = {
        movable             = true,
        Mover               = {}
    },
    -- 法术书
    ["SpellBookFrame"] = {
        movable             = true,
        Mover               = {}
    },
    -- NPC对话面板
    ["GossipFrame"]    = {
        movable             = true,
        Mover               = {}
    },
}

MovableFramesNeedWait = {
    -- 专精和天赋
    ["Blizzard_TalentUI"] = {
        ["PlayerTalentFrame"] = {
            movable           = true,
            Mover             = {}
        }
    },
    -- 成就
    ['Blizzard_AchievementUI'] = {
        ["AchievementFrame"]  = {
            movable           = true,
            Mover             = {
                location = {
                    Anchor("TOPLEFT",0,0,"AchievementFrameHeader","TOPLEFT"),
                    Anchor("TOPRIGHT",0,0,"AchievementFrameHeader","TOPRIGHT")
                },
                height = 56
            }
        }
    }
}

__Async__()
function OnEnable(self)
    for frame,info in pairs(MovableFrames) do
        print(frame)
        Style[_G[frame]] = info
        MovableFrames[frame] = nil
    end

    for addon,info in pairs(MovableFramesNeedWait) do
        if IsAddOnLoaded(addon) then
            for k,v in pairs(info) do
                Style[_G[k]] = v
            end
            MovableFramesNeedWait[addon] = nil
        end
    end

    while next(MovableFramesNeedWait) do
        local addon = NextEvent("ADDON_LOADED")
        local info = MovableFramesNeedWait[addon]
        if info then
            for k,v in pairs(info) do
                Style[_G[k]] = v
            end
            MovableFramesNeedWait[addon] = nil
        end
    end
    print(#MovableFrames,#MovableFramesNeedWait)
end