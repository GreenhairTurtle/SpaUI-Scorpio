Scorpio "SpaUI.Localization.zhCN" ""

local L = _Locale("zhCN",true)

if not L then return end

L["addon_name"] = "|cFF00FFFFS|r|cFFFFC0CBp|r|cFFFF6347a|rUI"
L["addon_loaded_tip"] = "|cFF00BFFF%s|r 已载入，你可以输入|cFF00BFFF/spa|r获取帮助"
L["debug_prefix"] = L["addon_name"].." Debug:"
L["message_format"] = L["addon_name"]..":%s"
L["minute_format"] = "%d分"
L["second_format"] = "%d秒"
L["module_enable"] = "启用模块"
L["combat_error"] = "你正在战斗中"

-- command
L["cmd_help"] = [[以下为常用命令：
|cFF00BFFF/rl|r 重载界面
|cFF00BFFF/spa news|r 显示更新日志
|cFF00BFFF/spa config|r 打开/关闭配置面板
|cFF00BFFF/spa align|r 显示/隐藏网格线
]]
L["cmd_error"] = "请输入正确的命令"

L["cmd_debug"] = "打开/关闭调试模式 0：关闭 1：打开"
L["cmd_news"] = "显示更新日志"
L["cmd_config"] = "打开/关闭配置面板"
L["cmd_align"] = "显示/隐藏网格线"

-- Bindings
L["toggle_raid_marker_frame"] = "打开/关闭世界标记窗口"


-- Config
L["config_version"] = "Scorpio:|cFF00BFFF%s|r "..L["addon_name"]..":|cFF00BFFF%s|r"
L["config_panel_title"] = L['addon_name'].."配置面板"
L["config_panel_show_after_combat"] = "配置面板将在战斗结束后显示"
L["config_addon_author"] = "作者：|cFFADD8E6%s|r"
L["config_char_indicator"] = "|TInterface\\Addons\\SpaUI\\Media\\char_indicator:18|t"
L["config_char"] = L["config_char_indicator"].."表示角色配置"
L["config_id_tip"] = "鼠标提示显示ID"
L["config_id_tip_tooltip"] = "在鼠标提示内显示任务ID，法术ID，货币ID，NPCID等"
L["config_debug"] = "调试模式"
L["config_debug_enable"] = "调试模式已启用，你可以输入命令\"/spa debug 0\"关闭"
L["config_debug_disable"] = "调试模式已关闭，你可以输入命令\"/spa debug 1\"启用"
L['config_load_more'] = "查看更多"
L["config_reload_confirm"] = "保存更改需要重载界面"
L["config_cancel_confirm"] = "部分更改还未保存，确定放弃？"
L["config_default_confirm"] = "确定重置所有配置么？"


-- Config Introduce
L["config_category_introduce"] = "介绍"
L["config_addon_introduct"] = [[
|cFF00FFFFS|r|cFFFFC0CBp|r|cFFFF6347a|rUI只对暴雪原生界面进行了功能增强，几乎没有任何"美化"，未来也不会考虑。
你可以输入命令 |cFF00BFFF/spa help|r 获取帮助
]]


-- Config ChangeLog
L["config_category_changelog"] = "更新日志"


-- Config Features
L["config_category_features"] = "综合"
L["config_category_features_title"] = "杂项"
L["config_category_features_esay_delete"] = "快速删除"
L["config_category_features_easy_delete_tooltip"] = "删除物品时自动填写DELETE"


-- Config AutoSell&Repair
L["config_category_features_auto_sell_repair"] = L["config_char_indicator"].."自动修理/出售"
L["config_features_auto_repair"] = "自动修理"
L["config_features_auto_repair_strategy"] = "修理方案："
L["config_features_auto_repair_strategy_guild"] = "使用公会修理"
L["config_features_auto_repair_strategy_guild_tooltip"] = "优先使用公会修理，然后再使用角色金币"
L["config_features_auto_repair_strategy_auto"] = "使用角色金币"
L["config_features_auto_repair_strategy_auto_tooltip"] = "直接使用角色金币修理"
L["config_features_auto_repair_strategy_none"] = "从不"
L["config_features_auto_repair_strategy_none_tooltip"] = "不启用自动修理"
L["config_features_auto_sell"] = "自动出售"
L["config_features_auto_sell_junk"] = "自动出售垃圾"


-- Config Chat
L["config_category_chat"] = "聊天"
L["config_chat_enhanced"] = "聊天增强"
L["config_chat_bar"] = "聊天栏"
L["config_chat_bar_tooltip"] = "启用/禁用聊天栏"
L["config_chat_emote"] = "聊天表情"
L["config_chat_emote_tooltip"] = "启用/禁用聊天表情"
L["config_chat_linktip"] = "聊天链接鼠标提示"
L["config_chat_linktip_tooltip"] = "启用/禁用聊天链接悬浮鼠标提示"
L["config_chat_tab"] = "快捷切换频道"
L["config_chat_tab_tooltip"] = "启用/禁用Tab快速切换频道"

-- Config Quest
L["config_category_quest"] = "任务"

-- Config AutoTurnIn
L["config_category_quest_auto_turn_in"] = L["config_char_indicator"].."自动交接任务"
L["config_quest_auto_turn_in_title"] = "自动交接任务"
L["config_quest_auto_turn_in_module_enable_tooltip"] = "启用/禁用自动交接任务模块\n|cFFFFFFFF禁用此模块会带来微不足道的性能提升|r"
L["config_quest_auto_turn_in_enable_tooltip"] = "打开/关闭自动交接任务"
L["config_quest_auto_turn_in_enable_key"] = "自动交接按键"
L["config_quest_auto_turn_in_enable_key_tooltip"] = "自动交接开启时，按住按键会临时关闭自动交接，自动交接关闭时，按住按键会临时开启自动交接"
L["config_quest_auto_turn_in_auto_weekly"] = "接受周常任务"
L["config_quest_auto_turn_in_auto_daily"] = "接受日常任务"
L["config_quest_auto_turn_in_auto_repeatable"] = "接受可重复任务"
L["config_quest_auto_turn_in_auto_trivial"] = "接受其它任务（低等级任务）"
L["config_quest_auto_turn_in_auto_trivial_weekly"] = "接受周常任务"
L["config_quest_auto_turn_in_auto_trivial_daily"] = "接受日常任务"
L["config_quest_auto_turn_in_auto_trivial_repeatable"] = "接受可重复任务"
-- 带有(任务)标题的选项直接点击，翻译的时候需要在具体的客户端用 C_GossipInfo.GetOptions()来查看对应字符串
L["config_quest_auto_turn_in_auto_gossip_pattern"] = "\124cFF0000FF%(任务%)\124r"

-- AutoRepair
L["auto_repair_guild_cost"] = "|cfff07100你本次修理消耗公会资金: %s|r"
L["auto_repair_cost"] = "|cffead000修理花费: %s|r"
L["auto_repair_no_money"] = "你没钱，穷逼！"


-- AutoSell
L["auto_sell_detail"] = "%s卖出了%s"
L["auto_sell_total"] = "共获得收入%s"


-- Tooltip
L["tooltip_spell_id"] = "法术ID："
L["tooltip_npc_id"] = "NpcID："
L["tooltip_currency_id"] = "货币ID："
L["tooltip_task_id"] = "任务ID："
L["tooltip_item_id"] = "物品ID："


-- MarkPosition
L["mp_button_text"] = "定位"
L["mp_cannot_mark"] = "当前地图无法标记！"
L["mp_button_tooltip"] = "左键显示输入框，右键取消位置标记"


-- Reputation
L["reputation_paragon"] = "巅峰x%d"
L["reputation_paragon_no_history"] = "巅峰"


-- MinimapPing
L["minimap_ping_who_group"] = "(%d队)%s"


-- FriendsList
L["friends_list_area"] = "|cFF7FFF00%s|r"


-- UnitFrames
L["uf_spell_source_prefix"] = "法术来源："
L["uf_buff_source_prefix"] = "增益来源："
L["uf_debuff_source_prefix"] = "减益来源："


-- KeystoneRewardLevel
L["key_stone_reward_title"] = "史诗钥石奖励"
L["key_stone_reward_title_difficulty"] = "层数"
L["key_stone_reward_title_level"] = "奖励(低保)"
L["key_stone_current_owned"] = "当前"
L["key_stone_reward_tooltip"] = "显示史诗钥石奖励对照表"


-- ChatBar
L["chat_bar_channel_say"] = "说"
L["chat_bar_channel_yell"] = "喊"
L["chat_bar_channel_party"] = "队"
L["chat_bar_channel_raid"] = "团"
L["chat_bar_channel_instance_chat"] = "副"
L["chat_bar_channel_guild"] = "公"
L["chat_bar_channel_world"] = "世"
L["chat_bar_outside"] = "频道切换栏似乎在屏幕外面？"
L["chat_bar_emote_table"] = "聊天表情"


-- ChatEmote
L["chat_emote_rt1"] = "{rt1}"
L["chat_emote_rt2"] = "{rt2}"
L["chat_emote_rt3"] = "{rt3}"
L["chat_emote_rt4"] = "{rt4}"
L["chat_emote_rt5"] = "{rt5}"
L["chat_emote_rt6"] = "{rt6}"
L["chat_emote_rt7"] = "{rt7}"
L["chat_emote_rt8"] = "{rt8}"
L["chat_emote_angle"] = "{天使}"
L["chat_emote_angry"] = "{生气}"
L["chat_emote_laugh"] = "{大笑}"
L["chat_emote_applause"] = "{鼓掌}"
L["chat_emote_cool"] = "{酷}"
L["chat_emote_cry"] = "{哭}"
L["chat_emote_lovely"] = "{可爱}"
L["chat_emote_despise"] = "{鄙视}"
L["chat_emote_dream"] = "{美梦}"
L["chat_emote_embarrassed"] = "{尴尬}"
L["chat_emote_evil"] = "{邪恶}"
L["chat_emote_excited"] = "{兴奋}"
L["chat_emote_dizzy"] = "{晕}"
L["chat_emote_fight"] = "{打架}"
L["chat_emote_influenza"] = "{流感}"
L["chat_emote_stay"] = "{呆}"
L["chat_emote_frown"] = "{皱眉}"
L["chat_emote_salute"] = "{致敬}"
L["chat_emote_grimace"] = "{鬼脸}"
L["chat_emote_barking_teeth"] = "{龇牙}"
L["chat_emote_happy"] = "{开心}"
L["chat_emote_heart"] = "{心}"
L["chat_emote_fear"] = "{恐惧}"
L["chat_emote_sick"] = "{生病}"
L["chat_emote_innocent"] = "{无辜}"
L["chat_emote_kung_fu"] = "{功夫}"
L["chat_emote_anthomaniac"] = "{花痴}"
L["chat_emote_mail"] = "{邮件}"
L["chat_emote_makeup"] = "{化妆}"
L["chat_emote_mario"] = "{马里奥}"
L["chat_emote_meditation"] = "{沉思}"
L["chat_emote_poor"] = "{可怜}"
L["chat_emote_good"] = "{好}"
L["chat_emote_beautiful"] = "{漂亮}"
L["chat_emote_spit"] = "{吐}"
L["chat_emote_shake_hands"] = "{握手}"
L["chat_emote_yell"] = "{喊}"
L["chat_emote_shut_up"] = "{闭嘴}"
L["chat_emote_shy"] = "{害羞}"
L["chat_emote_sleep"] = "{睡觉}"
L["chat_emote_smile"] = "{微笑}"
L["chat_emote_surprised"] = "{吃惊}"
L["chat_emote_failure"] = "{失败}"
L["chat_emote_sweat"] = "{流汗}"
L["chat_emote_tears"] = "{流泪}"
L["chat_emote_tragedy"] = "{悲剧}"
L["chat_emote_thinking"] = "{想}"
L["chat_emote_snicker"] = "{偷笑}"
L["chat_emote_wretched"] = "{猥琐}"
L["chat_emote_victory"] = "{胜利}"
L["chat_emote_lei_feng"] = "{雷锋}"
L["chat_emote_injustice"] = "{委屈}"


-- ChatCopy
L["chat_copy_dialog_title"] = "聊天复制"


-- RaidMarkers
L["raid_markers_clear_all"] = "清除全部"
L["raid_markers_tooltip"] = "（左键放置，右键清除）"
L["raid_markers_nopermission"] = "你不在队伍里或你不是团长（助理）！"


-- EJ SavedInstances
L["ej_loaded_fail"] = "地下城手册显示副本进度模块加载失败"
L["ej_savedinstance_progress"] = "%d/%d"
L['ej_savedinstance_boss_killed'] = "|cFFFF0000已击杀|r"
L['ej_savedinstance_boss_not_killed'] = "|cFF00FF00未击杀|r"


-- Quest
L["auto_quest_turnin_button_tooltip"] = "自动交接任务开关\n开启后按住Shift键可以暂时屏蔽"


-- CooldownAnnouncer
L["cooldown_announcer_spell_active"] = "%s已激活！"
L["cooldown_announcer_spell_ready"] = "%s准备就绪！"
L["cooldown_announcer_spell_not_ready"] = "%s还在冷却中，剩余%s"
L["cooldown_announcer_item_wait_cooldown"] = "%s正在等待冷却"
L["cooldown_announcer_item_ready"] = "%s准备就绪！"
L["cooldown_announcer_item_not_ready"] = "%s还在冷却中，剩余%s！"
L["cooldown_announcer_item_count"] = "剩余使用次数：%d"
L["cooldown_announcer_tooltip"] = "ALT+鼠标左键通报技能冷却信息"

-- GuildBank Sort
L["guild_bank_sort_button_tooltip"] = "鼠标左键点击整理\n右键点击打开物品转移对话框"
L["guild_bank_merge_items"] = "正在合并物品(%d/%d)"
L["guild_bank_move_items"] = "正在移动物品(%d/%d)"
L["guild_bank_cannot_withdraw"] = "你的提取额度不足！"
L["guild_bank_cannot_deposit"] = "该标签你无法存放物品！"
L["guild_bank_transfer_dialog_title"] = "公会银行物品转移"
L["guild_bank_transfer_src_title"] = "来源标签页：|T%s:15|t%s（第%d页）"
L["guild_bank_transfer_filter_default"] = "任意"
L["guild_bank_transfer_class_filter_title"] = "物品类型"
L["guild_bank_transfer_subclass_filter_title"] = "物品子类型"
L["guild_bank_transfer_expac_filter_title"] = "资料片"
L["guild_bank_transfer_quality_filter_title"] = "稀有程度"
L["guild_bank_transfer_add_item_tooltip"] = "右键添加此物品至待转移区域"
L["guild_bank_transfer_remove_item_tooltip"] = "右键从待转移区域中移除此物品"
L["guild_bank_transfer_src_transfer_all"] = "全部转移"
L["guild_bank_transfer_waiting_title"] = "待转移物品："
L["guild_bank_transfer_waiting_transfer_clear_all"] = "清除全部"
L["guild_bank_transfer_to_bag"] = "转移至背包"
L["guild_bank_transfer_to_bag_confirm"] = "确定转移至背包？"
L["guild_bank_transfer_to_bag_description"] = "提取物品(%d/%d)"
L["guild_bank_transfer_to_other_tab"] = "转移至其它标签"
L["guild_bank_transfer_to_other_tab_picker_label"] = "标签页："
L["guild_bank_transfer_to_other_tab_picker_default"] = "请选择"
L["guild_bank_transfer_to_other_tab_picker_text"] = "%s(%d)"
L["guild_bank_transfer_to_other_tab_retrive_data"] = "正在获取目标标签页信息，请稍等"
L["guild_bank_transfer_to_other_tab_full"] = "目标标签页没有空栏位？"
L["guild_bank_transfer_to_other_tab_description"] = "正在转移物品(%d/%d)"
L["guild_bank_transfer_to_other_tab_confirm"] = "确定转移物品至|T%s:15|t%s（第%d页）？"