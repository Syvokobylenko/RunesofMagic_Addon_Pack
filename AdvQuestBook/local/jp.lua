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
AQB_XML_QDTAILS = "クエスト詳細";
AQB_XML_DESCR = "クエスト内容:";
AQB_XML_REWARDS = "報酬:";
AQB_XML_DETAILS = "完了条件:";
AQB_XML_LOCATIONS = "場所:";
AQB_XML_CONFIG = "設定";
AQB_XML_HSECTION = "ヘルプセクション";
AQB_XML_OPENHELP = "Open Help";
AQB_XML_CLOSEHELP = "Close Help";
AQB_XML_SHARERES = "Share Results";
AQB_XML_SHOWSHARE = "Show Shared";
AQB_XML_HIDESHARE = "Hide Shared";
AQB_XML_BACK = "戻る";
AQB_XML_TYPEKEYWORD = "キーワード検索";
AQB_XML_SEARCH = "検索";
AQB_XML_SEARCHRES = "検索結果";
AQB_XML_CONFIG2 = "設定";
AQB_XML_CONFIG3 = "Icon Configuration"; -- New
AQB_XML_RELOADUI1 = "ReloadUI";
AQB_XML_RELOADUI2 = "地図がおかしくなったらリロードしてください";
AQB_XML_RELOADUI3 = "AQB 動作中, ReloadUI 無効.";
AQB_XML_SHTOOLTIPS = "Tooltips"; -- Edited
AQB_XML_STTOOLTIPS = "ツールチップを表示したままにする";
AQB_XML_STICONS = "アイコンを表示したままにする";
AQB_XML_QDONTIPS = "Quest Description"; -- Edited
AQB_XML_RLONTIPS = "Recommended Level"; -- Edited
AQB_XML_REWONTIPS = "Rewards"; -- Edited
AQB_XML_COORDONTIPS = "Coordinates"; -- Edited
AQB_XML_PREINC = "未完了クエストを保持する";
AQB_XML_AQD = "Advanced Quest Dumper";
AQB_XML_QS = "クエストを共有する";
AQB_XML_TMBTN = "ミニボタンを表示";
--AQB_XML_SAVECLOSE = "保存して閉じる";
--AQB_XML_CLOSECONFIG = "閉じる";
AQB_XML_PURGE = "データ破棄";
AQB_XML_STPORT = "Snoop Transports"; -- Edited
AQB_XML_ETRAIN = "Elite Trainers"; -- Edited
AQB_XML_SHOWSHARED = "Shared Quests"; -- Edited
AQB_XML_SHOWDAILY = "Daily Quests"; -- New
AQB_XML_SHOWQUESTS = "Quests"; -- New
AQB_XML_AIRPORT = "Airships"; -- New
AQB_XML_MSGONDUMP = "クエストダンプ時にメッセージを表示する";
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
	["AQB_AMINFO"] = "ゲーム内でクエストの情報を検索、追跡、管理するための豊富な手段を提供します。",
	["AQB_AMNOTFOUND"] = "AddonManager 未検出。%s を使用するのに便利でとてもお勧めです。AddonManager がインストールされていない場合、%s とタイプするかボタンを使用することで %s のパネルを表示できます。",
	["AQB_ERRFILELOAD"] = "ファイルのロードに失敗しました",
	["AQB_DFAULTSETLOAD"] = "デフォルト設定をロードしました",
	["AQB_SETSUPDATE"] = "設定を更新しました",
	["AQB_GET_PQUEST"] = "パーティクエストを取得",
	["AQB_SHIFT_RIGHT"] = "Shift + 右クリックでミニボタンを移動できます。",
	["AQB_RCLICK"] = "右クリック",
	["AQB_MOVE_BTN"] = "ドラッグしてボタンを移動できます。",
	["AQB_L50ET"] = "メイン/サブクラスの45エリートスキルを覚えていなければなりません。",
	["AQB_LIST_RECIEVED"] = "クエスト共有リストを受信しました。%s を開いて共有クエストを確認してください。",
	["AQB_NOLIST_RECIEVED"] = "共有クエストデータはありませんでした。",
	["AQB_RECLEVEL"] = "推奨レベル",
	["AQB_UNKNOWNQID"] = "不明なクエストID",
	["AQB_COORDS"] = "座標",
	["AQB_NEW_QD"] = "新規クエストをダンプしました: %s.";
	["AQB_CLEARED_DATA"] = "%s クエストを消去、%s クエストを保持しています。",
	["AQB_CLEANED_ALL"] = "全クエストデータを消去しました。",
	["AQB_UPLOAD"] = "ゲーム終了後に %s を %s にアップロードしてください。",
	["AQB_MIN_CHARS"] = "最低限 %s 文字以上入力してください...",
	["AQB_TOOMANY"] = "%s 件以上見つかりました。別なキーワードを使用して件数を減らすことで、検索結果を見やすくできます。",
	["AQB_SEARCHING"] = "%s を検索中...",
	["AQB_FOUND_RESULTS"] = "検索結果: %s 件, キーワード: %s",
	["AQB_NOTSUB"] = "このクエストはまだ情報提供されていません。",
	["AQB_RECLEVEL"] = "推奨レベル",
	["AQB_START"] = "開始",
	["AQB_END"] = "終了",
	["AQB_REWARDS"] = "報酬",
	["AQB_COORDS"] = "座標",
	["AQB_TRANSPORT"] = "ワープポータル",
	["AQB_LINKSTO"] = "接続先",
	["AQB_DUMPED"] = "をダンプしました",
	["AQB_GOLD"] = "ゴールド",
	["AQB_XP"] = "経験値",
	["AQB_TP"] = "テクニックポイント",
	["AQB_MAP"] = "マップ",
	["AQB_AND"] = "および",
	["AQB_OPEN"] = "Open",
	["AQB_LOCK"] = "ロック",
	["AQB_UNLOCK"] = "ロック解除",
	["AQB_QSTATUS0"] = "このクエストは未完了です。",
	["AQB_QSTATUS1"] = "このクエストは進行中です。",
	["AQB_QSTATUS2"] = "このクエストは完了済みです。",
};
-- Help topics will be added back later. I need to rewrite them.
