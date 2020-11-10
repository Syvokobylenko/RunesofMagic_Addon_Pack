--[[ ä

	Name: Advanced Questbook
	By: Crypton

]]
--[[
	%s is a "Wild Card" character. AQB uses these to replace with data
	such as names of items, players, etc.. It is important not to remove
	them or you will receive errors. For translating, you can move them
	where they need to go in the sentence so the data forms a proper
	sentence in your language.
]]
AQB_XML_QDTAILS = "任务细节";
AQB_XML_DESCR = "描述:";
AQB_XML_REWARDS = "奖励:";
AQB_XML_DETAILS = "详细资料:";
AQB_XML_LOCATIONS = "坐标:";
AQB_XML_CONFIG = "设置";
AQB_XML_HSECTION = "帮助划分";
AQB_XML_OPENHELP = "打开帮助";
AQB_XML_CLOSEHELP = "关闭帮助";
AQB_XML_SHARERES = "共享结果";
AQB_XML_SHOWSHARE = "显示共享";
AQB_XML_HIDESHARE = "隐藏共享";
AQB_XML_BACK = "后退";
AQB_XML_TYPEKEYWORD = "输入关键词";
AQB_XML_SEARCH = "查找";
AQB_XML_SEARCHRES = "查找结果";
AQB_XML_CONFIG2 = "配置";
AQB_XML_CONFIG3 = "Icon Configuration"; -- New
AQB_XML_RELOADUI1 = "重载界面";
AQB_XML_RELOADUI2 = "如果小地图图标不见了，请重载界面.";
AQB_XML_RELOADUI3 = "AQD启用, 重载界面禁用.";
AQB_XML_SHTOOLTIPS = "Tooltips"; -- Edited
AQB_XML_STTOOLTIPS = "粘结鼠标提示";
AQB_XML_STICONS = "粘结图标";
AQB_XML_QDONTIPS = "Quest Description"; -- Edited
AQB_XML_RLONTIPS = "Recommended Level"; -- Edited
AQB_XML_REWONTIPS = "Rewards"; -- Edited
AQB_XML_COORDONTIPS = "Coordinates"; -- Edited
AQB_XML_PREINC = "保存不完整";
AQB_XML_AQD = "Advanced Quest Dumper";
AQB_XML_QS = "任务共享";
AQB_XML_TMBTN = "锁定小地图图标";
--AQB_XML_SAVECLOSE = "保存/关闭";
--AQB_XML_CLOSECONFIG = "关闭设置";
AQB_XML_PURGE = "清楚数据";
AQB_XML_STPORT = "Snoop Transports"; -- Edited
AQB_XML_ETRAIN = "Elite Trainers"; -- Edited
AQB_XML_SHOWSHARED = "Shared Quests"; -- Edited
AQB_XML_SHOWDAILY = "Daily Quests"; -- New
AQB_XML_SHOWQUESTS = "Quests"; -- New
AQB_XML_AIRPORT = "Airships"; -- New
AQB_XML_MSGONDUMP = "Quest Dump上显示消息";
AQB_XML_NOTE1 = "Drag this icon on the map to place an icon in that location."; -- New
AQB_XML_NOTE2 = "Shift+Left Click a Note to Edit It"; -- New
AQB_XML_NOTE3 = "Hold Shift+Right Mouse to Move a Note"; -- New
AQB_XML_NOTE4 = "CTRL+Left Click to Delete a Note"; -- New
AQB_XML_NOTE5 = "New Note"; -- New
AQB_XML_NOTE6 = "Edit Note"; -- New
AQB_XML_NOTE7 = "You currently have %s notes for the current map. Please remove a note before trying to add another."; -- New
AQB_XML_NOTE8 = "Map Notes:"; -- New
AQB_XML_NOTE9 = "Save Note"; -- New
AQB_XML_NOTE10 = "Edit Title"; -- New
AQB_XML_NOTE11 = "Edit Note"; -- New
AQB_XML_NOTE12 = "Custom Notes"; -- Edited

AdvQuestBook_Messages = {
	["AQB_AMINFO"] = "一个寻找信息，追踪，管理游戏内任务的工具.",
	["AQB_AMNOTFOUND"] = "未发现AddonManager. 它是个非常有用的插件，强烈建议您使用AddonManager来辅助 %s. 输入 %s 来打开 %s 面板 或者点击AQB图标开启设定面板.",
	["AQB_ERRFILELOAD"] = "读取档案错误",
	["AQB_DFAULTSETLOAD"] = "读取默认设置",
	["AQB_SETSUPDATE"] = "更新设定",
	["AQB_GET_PQUEST"] = "取得队伍任务信息",
	["AQB_SHIFT_RIGHT"] = "Shift + 鼠标右击  可移动小地图按钮.",
	["AQB_RCLICK"] = "鼠标右击",
	["AQB_MOVE_BTN"] = "按住鼠标左键可移动按钮.",
	["AQB_L50ET"] = "主职和副职都必须用友45精英技能.",
	["AQB_LIST_RECIEVED"] = "接收到任务共享列表. 请打开 %s 查看共享任务.",
	["AQB_NOLIST_RECIEVED"] = "没有接收到共享任务.",
	["AQB_RECLEVEL"] = "建议等级",
	["AQB_UNKNOWNQID"] = "未知任务编号",
	["AQB_COORDS"] = "C坐标",
	["AQB_NEW_QD"] = "New Quest Dumped for %s.";
	["AQB_CLEARED_DATA"] = "清除 %s 任务 储存 %s 任务",
	["AQB_CLEANED_ALL"] = "清除所有储存的任务.",
	["AQB_UPLOAD"] = "在你退出游戏的时候，确定要上传 %s 到 %s .",
	["AQB_MIN_CHARS"] = "请最少输入 %s 个字数来查询...",
	["AQB_TOOMANY"] = "找到超过 %s 个结果. 使用不同的关键词将可以更精确的查询.",
	["AQB_SEARCHING"] = "正在查询 %s. 请稍等...",
	["AQB_FOUND_RESULTS"] = "找到 %s 结果 从 %s.",
	["AQB_NOTSUB"] = "这个任务还未上传相关资料.",
	["AQB_RECLEVEL"] = "建议等级",
	["AQB_START"] = "开始",
	["AQB_END"] = "结束",
	["AQB_REWARDS"] = "奖励",
	["AQB_COORDS"] = "坐标",
	["AQB_TRANSPORT"] = "传送点",
	["AQB_LINKSTO"] = "传送到",
	["AQB_DUMPED"] = "Dumped",
	["AQB_GOLD"] = "金币",
	["AQB_XP"] = "经验",
	["AQB_TP"] = "天赋点",
	["AQB_MAP"] = "地图",
	["AQB_AND"] = "和",
	["AQB_OPEN"] = "打开",
	["AQB_LOCK"] = "锁定",
	["AQB_UNLOCK"] = "解锁",
	["AQB_QSTATUS0"] = "你还未完成此任务.",
	["AQB_QSTATUS1"] = "你已经有这个任务了.",
	["AQB_QSTATUS2"] = "你已经完成这个任务了.",
};
-- Help topics will be added back later. I need to rewrite them.
