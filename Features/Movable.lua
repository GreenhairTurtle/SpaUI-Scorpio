Scorpio "SpaUI.Features.Movable" ""

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
                height = 56,
                frameStrata = "HIGH"
            }
        }
    },
    -- 公会与社区
    ['Blizzard_GuildRecruitmentUI'] = {
        ["CommunitiesFrame"] = {
            movable             = true,
            Mover               = {}
        },
        -- 公会设置
        ["GuildControlUI"] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 藏品
    ['Blizzard_Collections'] = {
        ["CollectionsJournal"] = {
            movable             = true,
            Mover               = {}
        },
        -- 幻化
        ["WardrobeFrame"] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 地下城手册 
    ['Blizzard_EncounterJournal'] = {
        ["EncounterJournal"] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 日历 
    ['Blizzard_Calendar'] = {
        ["CalendarFrame"] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 飞行地图
    ['Blizzard_FlightMap'] = {
        ["FlightMapFrame"] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 按键绑定
    ['Blizzard_BindingUI'] = {
        ["KeyBindingFrame"] = {
            movable             = true,
            Mover               = {}
        },
        -- 快速绑定
        ["QuickKeybindFrame"] = {
            movable             = true,
            Mover               = {}
        }
    }, 
    -- 宏命令
    ['Blizzard_MacroUI'] = {
        ["MacroFrame"] = {
            movable             = true,
            Mover               = {}
        },
        -- 新建宏
        ["MacroPopupFrame"] = {
            movable             = true,
            Mover               = {}
        }
    }, 
    -- 要塞报告
    ['Blizzard_GarrisonTemplates'] = {
        -- 小地图按钮面板
        ["GarrisonLandingPage"] = {
            movable             = true,
            Mover               = {
                height          = 40
            }
        },
        -- 盟约任务
        ["CovenantMissionFrame"] = {
            movable             = true,
            Mover               = {}
        },
        -- 8.0 指挥台
        ["BFAMissionFrame"]     = {
            movable             = true,
            Mover               = {}
        }
    }, 
    -- 名望
    ['Blizzard_CovenantRenown'] = {
        ["CovenantRenownFrame"] = {
            movable             = true,
            Mover               = {}
        }
    }, 
    -- 灵魂羁绊
    ['Blizzard_Soulbinds'] = {
        ["SoulbindViewer"] = {
            movable             = true,
            Mover               = {}
        }
    }, 
    -- 专业
    ['Blizzard_TradeSkillUI'] = {
        ["TradeSkillFrame"] = {
            movable             = true,
            Mover               = {}
        }
    }, 
    -- 考古
    ['Blizzard_ArchaeologyUI'] = {
        ["ArchaeologyFrame"] = {
            movable             = true,
            Mover               = {}
        }
    }, 
    -- 聊天频道
    ['Blizzard_Channels'] = {
        ["ChannelFrame"] = {
            movable             = true,
            Mover               = {}
        },
        -- 新建频道
        ["CreateChannelPopup"] = {
            movable             = true,
            Mover               = {}
        }
    }, 
    -- 宏伟宝库
    ['Blizzard_WeeklyRewards'] = {
        ["WeeklyRewardsFrame"] = {
            movable             = true,
            Mover               = {}
        }
    }, 
    -- 公会银行
    ['Blizzard_GuildBankUI'] = {
        ["GuildBankFrame"] = {
            movable             = true,
            Mover               = {
                location        = {
                    Anchor("TOP",0,0,"GuildBankEmblemFrame","TOP"),
                    Anchor("BOTTOM",0,0,"GuildBankEmblemFrame","BOTTOM"),
                    Anchor("LEFT",0,0,"GuildBankFrame","LEFT"),
                    Anchor("RIGHT",0,0,"GuildBankFrame","RIGHT")
                }
            }
        }
    }, 
    -- 圣所储备
    ['Blizzard_CovenantSanctum'] = {
        ["CovenantSanctumFrame"] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 心能导流器
    ['Blizzard_AnimaDiversionUI'] = {
        ["AnimaDiversionFrame"] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 制作橙装
    ['Blizzard_RuneforgeUI'] = {
        ['RuneforgeFrame'] = {
            movable             = true,
            Mover               = {
                height          = 56
            }
        }
    },
    -- 托加斯特难度选择
    ['Blizzard_TorghastLevelPicker'] = {
        ['TorghastLevelPickerFrame'] = {
            movable             = true,
            Mover               = {
                height          = 96
            }
        }
    },
    -- 职业大厅，BFA科技
    ['Blizzard_OrderHallUI'] = {
        ['OrderHallTalentFrame'] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 海岛
    ['Blizzard_IslandsQueueUI'] = {
        ['IslandsQueueFrame'] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 拆解机
    ['Blizzard_ScrappingMachineUI'] = {
        ['ScrappingMachineFrame'] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 训练师
    ['Blizzard_TrainerUI'] = {
        ['ClassTrainerFrame'] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 艾泽拉斯之心
    ['Blizzard_AzeriteEssenceUI'] = {
        ['AzeriteEssenceUI'] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 物品互动
    ['Blizzard_ItemInteractionUI'] = {
        ['ItemInteractionFrame'] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 物品升级
    ['Blizzard_ItemUpgradeUI'] = {
        ['ItemUpgradeFrame'] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 艾泽里特装备
    ['Blizzard_AzeriteUI'] = {
        ['AzeriteEmpoweredItemUI'] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 艾泽里特重铸
    ['Blizzard_AzeriteRespecUI'] = {
        ['AzeriteRespecFrame'] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 选择框
    ['Blizzard_PlayerChoiceUI'] = {
        ['PlayerChoiceFrame'] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- 虚空仓库
    ['Blizzard_VoidStorageUI'] = {
        ['VoidStorageFrame'] = {
            movable             = true,
            Mover               = {
                location = {
                    Anchor("TOPLEFT",0,0,"VoidStorageBorderFrameHeader","TOPLEFT"),
                    Anchor("BOTTOMRIGHT",0,0,"VoidStorageBorderFrameHeader","BOTTOMRIGHT")
                }
            }
        }
    },
    -- 同盟种族
    ['Blizzard_AlliedRacesUI'] = {
        ['AlliedRacesFrame'] = {
            movable             = true,
            Mover               = {}
        }
    },
    -- NPC对话框体
    ['Blizzard_TalkingHeadUI'] = {
        ['TalkingHeadFrame'] = {
            clampedToScreen     = true,
            movable             = true,
            Mover               = {
                location        = {
                    Anchor("TOPLEFT"),
                    Anchor("BOTTOMRIGHT")
                }
            }
        }
    },
    -- 观察
    ['Blizzard_InspectUI'] = {
        ['InspectFrame'] = {
            movable             = true,
            Mover               = {}
        }
    }
}

__Async__()
function OnEnable(self)
    SetMovableForDirectFrames()
    SetMovableForNeedWaitFrames()
end

function SetMovableForNeedWaitFrames()
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
        Log(addon)
        local info = MovableFramesNeedWait[addon]
        if info then
            for k,v in pairs(info) do
                Style[_G[k]] = v
            end
            MovableFramesNeedWait[addon] = nil
        end
    end
end

function SetMovableForDirectFrames()
    -- 角色信息
    Style[CharacterFrame] = {
        movable             = true,
        Mover               = {}
    }
    -- 法术书
    Style[SpellBookFrame] = {
        movable             = true,
        Mover               = {}
    }
    -- 世界地图
    Style[WorldMapFrame]  = {
        movable             = true,
        Mover               = {}
    }
    -- 队伍查找器
    Style[PVEFrame]  = {
        movable             = true,
        Mover               = {}
    }
    -- 系统菜单
    Style[GameMenuFrame] = {
        movable             = true,
        Mover               = {}
    }
    -- NPC对话面板
    Style[GossipFrame] = {
        movable             = true,
        Mover               = {}
    }
    -- 任务对话面板
    Style[QuestFrame] = {
        movable             = true,
        Mover               = {}
    }
    -- 商人面板
    Style[MerchantFrame] = {
        movable             = true,
        Mover               = {}
    }
     -- 客服支持
    Style[HelpFrame] = {
        movable             = true,
        Mover               = {}
    }
    -- 系统设置
    Style[VideoOptionsFrame] = {
        movable             = true,
        Mover               = {}
    }
    -- 界面
    Style[InterfaceOptionsFrame] = {
        movable             = true,
        Mover               = {}
    }
    -- 插件
    Style[AddonList] = {
        movable             = true,
        Mover               = {}
    }
    -- 好友名单
    Style[FriendsFrame] = {
        movable             = true,
        Mover               = {}
    }
    -- 聊天频道设置
    Style[ChatConfigFrame] = {
        movable             = true,
        Mover               = {}
    }
    -- 试衣间
    Style[DressUpFrame] = {
        movable             = true,
        Mover               = {}
    }
    Style[TaxiFrame] = {
        movable             = true,
        Mover               = {}
    }
end