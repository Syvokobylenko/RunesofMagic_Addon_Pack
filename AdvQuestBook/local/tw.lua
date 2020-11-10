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
AQB_XML_QDTAILS = "任務細節";
AQB_XML_DESCR = "任務描述：";
AQB_XML_REWARDS = "獎勵：";
AQB_XML_DETAILS = "詳細資料：";
AQB_XML_LOCATIONS = "座標：";
AQB_XML_CONFIG = "設置";
AQB_XML_HSECTION = "部分幫助";
AQB_XML_OPENHELP = "打開幫助";
AQB_XML_CLOSEHELP = "關閉幫助";
AQB_XML_SHARERES = "分享成果";
AQB_XML_SHOWSHARE = "顯示共享";
AQB_XML_HIDESHARE = "隱藏共享";
AQB_XML_BACK = "前一頁";
AQB_XML_TYPEKEYWORD = "輸入關鍵字搜尋";
AQB_XML_SEARCH = "搜尋";
AQB_XML_SEARCHRES = "搜尋結果";
AQB_XML_CONFIG2 = "配置";
AQB_XML_CONFIG3 = "Icon Configuration"; -- New
AQB_XML_RELOADUI1 = "重載介面";
AQB_XML_RELOADUI2 = "如果AQB按鈕不見了，請重載介面.";
AQB_XML_RELOADUI3 = "AQD 啟用,重載介面 禁用.";
AQB_XML_SHTOOLTIPS = "Tooltips"; -- Edited
AQB_XML_STTOOLTIPS = "滑鼠移開不立刻移除 提示";
AQB_XML_STICONS = "滑鼠移開不立刻移除 圖標";
AQB_XML_QDONTIPS = "Quest Description"; -- Edited
AQB_XML_RLONTIPS = "Recommended Level"; -- Edited
AQB_XML_REWONTIPS = "Rewards"; -- Edited
AQB_XML_COORDONTIPS = "Coordinates"; -- Edited
AQB_XML_PREINC = "保存不完整";
AQB_XML_AQD = "進階的任務 Dumper";
AQB_XML_QS = "任務分享";
AQB_XML_TMBTN = "顯示 AQB按鈕";
--AQB_XML_SAVECLOSE = "儲存/關閉";
--AQB_XML_CLOSECONFIG = "關閉設置";
AQB_XML_PURGE = "清除資訊";
AQB_XML_STPORT = "Snoop Transports"; -- Edited
AQB_XML_ETRAIN = "Elite Trainers"; -- Edited
AQB_XML_SHOWSHARED = "Shared Quests"; -- Edited
AQB_XML_SHOWDAILY = "Daily Quests"; -- New
AQB_XML_SHOWQUESTS = "Quests"; -- New
AQB_XML_AIRPORT = "Airships"; -- New
AQB_XML_MSGONDUMP = "在任務Dump上顯示顯示訊息";
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
	["AQB_AMINFO"] = "一個尋找資訊, 追蹤, 和管理遊戲內的任務功能的工具.",
	["AQB_AMNOTFOUND"] = "沒有發現 AddonManager. 這是一個好用的插件，強烈建議您使用 AddonManager 來 輔助 %s。 當您未安裝 AddonManager時，可以輸入 %s 來打開 %s 設定面板，或者點擊 AQB按鈕 來開啟設定面板。",
	["AQB_ERRFILELOAD"] = "讀取檔案失敗",
	["AQB_DFAULTSETLOAD"] = "讀取預設值",
	["AQB_SETSUPDATE"] = "更新設定",
	["AQB_GET_PQUEST"] = "取得隊伍中任務資訊",
	["AQB_SHIFT_RIGHT"] = "Shift + 右鍵點擊 可移動小地圖按鈕.",
	["AQB_RCLICK"] = "右鍵點擊",
	["AQB_MOVE_BTN"] = "按下滑鼠左鍵來移動按鈕.",
	["AQB_L50ET"] = "主職跟副值都必須擁有45級菁英技能.",
	["AQB_LIST_RECIEVED"] = "接收任務共享列表. 請打開 %s 來確認共享的任務.",
	["AQB_NOLIST_RECIEVED"] = "沒有接收到共享的任務.",
	["AQB_RECLEVEL"] = "推薦等級",
	["AQB_UNKNOWNQID"] = "未知的任務編號",
	["AQB_COORDS"] = "座標",
	["AQB_NEW_QD"] = "新任務 Dumped for %s.";
	["AQB_CLEARED_DATA"] = "清除 %s 任務 並且 儲存 %s 任務",
	["AQB_CLEANED_ALL"] = "清除所有儲存的任務資料.",
	["AQB_UPLOAD"] = "確定要更新你的 %s 到 %s 在你退出遊戲後.",
	["AQB_MIN_CHARS"] = "請最少輸入 %s 個字元來搜尋...",
	["AQB_TOOMANY"] = "找到超過 %s 個結果 . 使用不同的關鍵字將可以更精確的搜尋.",
	["AQB_SEARCHING"] = "正在從 %s 搜尋. 請稍等...",
	["AQB_FOUND_RESULTS"] = "發現 %s 結果 從 %s.",
	["AQB_NOTSUB"] = "這個任務還沒有上傳相關資料.",
	["AQB_RECLEVEL"] = "推薦等級",
	["AQB_START"] = "開始",
	["AQB_END"] = "結束",
	["AQB_REWARDS"] = "獎勵",
	["AQB_COORDS"] = "座標",
	["AQB_TRANSPORT"] = "傳送點",
	["AQB_LINKSTO"] = "可傳送地點",
	["AQB_DUMPED"] = "Dumped",
	["AQB_GOLD"] = "金幣",
	["AQB_XP"] = "經驗值",
	["AQB_TP"] = "技能點數",
	["AQB_MAP"] = "地圖",
	["AQB_AND"] = "和",
	["AQB_OPEN"] = "打開",
	["AQB_LOCK"] = "鎖定",
	["AQB_UNLOCK"] = "解除鎖定",
	["AQB_QSTATUS0"] = "你還沒完成這個任務.",
	["AQB_QSTATUS1"] = "你目前擁有的任務.",
	["AQB_QSTATUS2"] = "你已經完成這個任務了.",
};
-- Help topics will be added back later. I need to rewrite them.
