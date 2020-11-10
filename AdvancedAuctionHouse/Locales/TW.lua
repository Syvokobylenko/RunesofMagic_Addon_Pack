AAHLocale = {}
AAHLocale.Commands = {
	BARGAIN = "$bargain",
	DURA = "$dura,$durability",
	EGGAPTITUDE = "$eggapt",
	EGGLEVEL = "$egglvl",
	FIVE = "$five,$quintuple",
	FOUR = "$four,$quadruple",
	GREEN = "$green",
	ONE = "$one,$single",
	ORANGE = "$orange",
	PLUS = "$plus",
	SIX = "$six,$sextuple",
	THREE = "$three,$triple",
	TIER = "$tier",
	TWO = "$two,$double",
	VENDOR = "$vendor",
	YELLOW = "$yellow",
	ZERO = "$zero,$clean",
}
AAHLocale.Messages = {
	ADDON_MANAGER_DESCRIPTION = [=[Advanced AuctionHouse 改變了預設的交易所介面，增加了一些有用的功能，讓你更容易瀏覽與拍賣。

所有的功能是建立在交易所介面上，所以你只要開啟交易所馬上就能使用新功能了！]=],
	AUCTION_EXCHANGE_RATE = "兌換比率",
	AUCTION_FORUMS_BUTTON = "網站",
	AUCTION_FORUMS_BUTTON_TOOLTIP_HEADER = "Advanced AuctionHouse 論壇網址",
	AUCTION_FORUMS_BUTTON_TOOLTIP_TEXT = "這將開啟您的預設瀏覽器到 Advanced AuctionHouse Forums",
	AUCTION_FRAME_TITLE = "Advanced AuctionHouse <VERSION> - Venice (Taiwan)", -- Needs review
	AUCTION_LOADED_MESSAGE = "已讀取：AdvancedAuctionHouse <VERSION> by Mavoc (TW)", -- Needs review
	BROWSE_CANCELLING = "正在移除上一次的搜尋資料...",
	BROWSE_CLEAR_BUTTON = "重設",
	BROWSE_CLEAR_BUTTON_TOOLTIP_HEADER = "重設過濾",
	BROWSE_CLEAR_BUTTON_TOOLTIP_TEXT = "這個按鈕可重設插件已應用的過濾條件，但不會重設交易所本身的搜尋結果。",
	BROWSE_CREATE_FOLDER_POPUP = "新增資料夾名稱",
	BROWSE_FILTER = "過濾",
	BROWSE_FILTER_OR_TOOLTIP_HEADER = "將關鍵字連結成「或」",
	BROWSE_FILTER_OR_TOOLTIP_TEXT = "在這裡打勾可以將多個關鍵字連結成「或」，代替原本的「且」。",
	BROWSE_FILTER_PRICERANGE_BID_TOOLTIP_HEADER = "Bid Price Filtering  起標價",
	BROWSE_FILTER_PRICERANGE_BID_TOOLTIP_TEXT = "Check this to filter items based on the Bid Price instead of the Buyout Price.          篩選物品之起標價格。",
	BROWSE_FILTER_PRICERANGE_MAX_TOOLTIP_HEADER = "最高價格過濾",
	BROWSE_FILTER_PRICERANGE_MAX_TOOLTIP_TEXT = "輸入過濾物品的最高價格。",
	BROWSE_FILTER_PRICERANGE_MIN_TOOLTIP_HEADER = "最低價格過濾",
	BROWSE_FILTER_PRICERANGE_MIN_TOOLTIP_TEXT = "輸入過濾物品的最低價格。",
	BROWSE_FILTER_PRICERANGE_PPU_TOOLTIP_HEADER = "Price/Unit Filtering  直購價",
	BROWSE_FILTER_PRICERANGE_PPU_TOOLTIP_TEXT = "Check this to filter items based on the PPU instead of the total price.                    篩選物品之直購價格。",
	BROWSE_FILTER_TOOLTIP_HEADER = "關鍵字過濾 #",
	BROWSE_FILTER_TOOLTIP_TEXT1 = [=[輸入關鍵字可過濾搜尋資料。在關鍵字前面輸入「!」可過濾出沒有此關鍵字的資料。預設在不同欄中的關鍵字會連結成「且」。

你可以使用下列特殊過濾：]=], -- Needs review
	BROWSE_FILTER_TOOLTIP_TEXT2 = [=[|cffffd200$green|r - 搜尋綠色屬性的物品
|cffffd200$yellow|r - 搜尋黃色屬性的物品
|cffffd200$orange|r - 搜尋橘色屬性的物品

|cffffd200$zero|r - 搜尋無屬性的物品
|cffffd200$one|r - 搜尋一屬性的物品
|cffffd200$two|r - 搜尋二屬性的物品
|cffffd200$three|r - 搜尋三屬性的物品
|cffffd200$four|r - 搜尋四屬性的物品
|cffffd200$five|r - 搜尋五屬性的物品
|cffffd200$six|r - 搜尋六屬性的物品
]=],
	BROWSE_FILTER_TOOLTIP_TEXT3 = [=[|cffffd200$dura|r - 搜尋耐久度 >= 101
--($dura/110 sets the min dura to 110)

|cffffd200$tier|r - 搜尋階層魔石 >= 1
--($tier/3 sets the min tier to 3)

|cffffd200$plus|r - 搜尋強化等級 >= 1
--($plus/6 sets the min plus to 6)

|cffffd200$egglvl|r - 搜尋寵物等級 >= 1
--($egglvl/30 sets the min level to 30)
|cffffd200$eggapt|r - 搜尋寵物資質 >= 1
--($eggapt/80 sets the min aptitude to 80)

|cffffd200$vendor|r - 搜尋可販賣商人獲取利潤的物品
--(see curse.com for usage)
|cffffd200$bargain|r - 搜尋較歷史平均價便宜的物品
--(see curse.com for usage)]=],
	BROWSE_HEADER_CUSTOM_TITLE = "選擇數據類型：",
	BROWSE_INFO_LABEL = "共 <MAXITEMS> 筆資料－已讀取 <SCANPERCENT>%－<FILTEREDITEMS> 個符合－<FILTERPERCENT>% 過濾完成",
	BROWSE_INFO_LABEL_TOOLTIP_HEADER = "緩存與過濾進度",
	BROWSE_INFO_LABEL_TOOLTIP_TEXT = [=[顯示下列資訊：

－已知的資料（最多 500 筆）
－交易所本身的搜尋進度
－符合的物品數量
－過濾的進度]=],
	BROWSE_MAX = "Max:",
	BROWSE_MIN = "Min:",
	BROWSE_NAME_SEARCH_POPUP = "命名您的儲存之搜尋紀錄檔",
	BROWSE_NO_RESULTS = "找不到符合的資料",
	BROWSE_OR = "或",
	BROWSE_PPU = "PPU",
	BROWSE_RENAME = "重新命名",
	BROWSE_RENAME_SAVED_SEARCH_POPUP = "重新命名您的儲存之搜尋紀錄檔",
	BROWSE_SAVED_SEARCH_TITLE = "儲存之搜尋紀錄檔",
	BROWSE_SEARCHING = "搜尋中請稍候...",
	BROWSE_SEARCH_PARAMETERS = "搜尋參數設定",
	BROWSE_USABLE = "可用",
	COMMAND_BARGAIN_DESCRIPTION = "Resell on AH for profit", -- Requires localization
	COMMAND_DURA_DESCRIPTION = "items with dura >= 101; add '/123' for dura >= 123", -- Requires localization
	COMMAND_EGGAPTITUDE_DESCRIPTION = "pet eggs with aptitude >= 1; add '/80' for min aptitude of 80", -- Requires localization
	COMMAND_EGGLEVEL_DESCRIPTION = "pet eggs with level >= 1; add '/30' for min level of 30", -- Requires localization
	COMMAND_FIVE_DESCRIPTION = "items with five stats", -- Requires localization
	COMMAND_FOUR_DESCRIPTION = "items with four stats", -- Requires localization
	COMMAND_GREEN_DESCRIPTION = "items with green stats", -- Requires localization
	COMMAND_ONE_DESCRIPTION = "items with one stat", -- Requires localization
	COMMAND_ORANGE_DESCRIPTION = "items with orange stats", -- Requires localization
	COMMAND_PLUS_DESCRIPTION = "items with a plus >= 1; add '/6' to set minimum to 6", -- Requires localization
	COMMAND_SIX_DESCRIPTION = "items with six stats", -- Requires localization
	COMMAND_THREE_DESCRIPTION = "items with three stats", -- Requires localization
	COMMAND_TIER_DESCRIPTION = "items with a tier >= 1; add '/6' to set minimum to 6", -- Requires localization
	COMMAND_TWO_DESCRIPTION = "items with two stats", -- Requires localization
	COMMAND_VENDOR_DESCRIPTION = "sell to vendor for profit", -- Requires localization
	COMMAND_YELLOW_DESCRIPTION = "items with yellow stats", -- Requires localization
	COMMAND_ZERO_DESCRIPTION = "items with zero stats", -- Requires localization
	GENERAL_ATTRIBUTES = "屬性",
	GENERAL_AVERAGE = "平均",
	GENERAL_AVERAGE_PRICE_PER_UNIT = "平均單價：",
	GENERAL_CUSTOM_HEADER_TOOLTIP_HEADER = "自訂數據",
	GENERAL_CUSTOM_HEADER_TOOLTIP_TEXT = [=[左鍵：數據排序
右鍵：變更數據]=],
	GENERAL_DECIMAL_POINT = ".",
	GENERAL_DEX_HEADER = "敏捷",
	GENERAL_DPS_HEADER = "每秒傷害",
	GENERAL_DURA_HEADER = "耐久",
	GENERAL_GENERAL = "一般",
	GENERAL_HEAL_HEADER = "治療加成",
	GENERAL_HP_HEADER = "生命",
	GENERAL_INTEL_HEADER = "智力",
	GENERAL_MACC_HEADER = "魔法命中力",
	GENERAL_MATT_HEADER = "魔法攻擊力",
	GENERAL_MCRIT_HEADER = "魔法爆擊力",
	GENERAL_MDAM_HEADER = "魔法傷害",
	GENERAL_MDEF_HEADER = "魔法防禦",
	GENERAL_MEDIAN_PRICE_PER_UNIT = "中間值：",
	GENERAL_MP_HEADER = "法力",
	GENERAL_OTHER = "其他",
	GENERAL_PACC_HEADER = "物理命中力",
	GENERAL_PARRY_HEADER = "格檔率",
	GENERAL_PATT_HEADER = "物理攻擊力",
	GENERAL_PCRIT_HEADER = "物理爆擊力",
	GENERAL_PDAM_HEADER = "物理傷害",
	GENERAL_PDEF_HEADER = "物理防禦",
	GENERAL_PDOD_HEADER = "閃躲率",
	GENERAL_PLUS_HEADER = "強化等級",
	GENERAL_PRICE_PER_UNIT_HEADER = "單價",
	GENERAL_SPEED_HEADER = "攻擊速度",
	GENERAL_STAM_HEADER = "耐力",
	GENERAL_STATS = "狀態",
	GENERAL_STR_HEADER = "力量",
	GENERAL_TIER_HEADER = "階層",
	GENERAL_UNITS_PER_PRICE_HEADER = "Units/Price", -- Requires localization
	GENERAL_WIS_HEADER = "精神",
	GENERAL_WORTH_HEADER = "販賣給商人的價格",
	HISTORY_NO_DATA = "此物品沒有歷史價格！",
	HISTORY_SUMMARY_AVERAGE = [=[中間值：<MEDIAN>
平均：<AVERAGE>]=],
	HISTORY_SUMMARY_MINMAX = [=[最低：<MINIMUM>
最高：<MAXIMUM>]=],
	HISTORY_SUMMARY_NUMHISTORY = "(基於搜尋到的 <NUMHISTORY> 筆交易)",
	LUNA_NEW_VERSION_FOUND = "您可在 rom.curse.com 獲得最新版本的 Advanced AuctionHouse",
	LUNA_NOT_FOUND = "這個功能需要安裝 Luna，你可以在 Curse 下載它。",
	SELL_AUTO_BID_PRICE_TOOLTIP_HEADER = "自動輸入起標價",
	SELL_AUTO_BID_PRICE_TOOLTIP_TEXT = [=[選擇自動輸入起標價的模式：

◎|cffffd200無|r－不輸入價格
◎這個物品|cffffd200上次|r拍賣的價格
（如果存在）
◎這個物品的歷史|cffffd200平均|r價格
◎自訂價格|cffffd200公式|r]=],
	SELL_AUTO_BUYOUT_PRICE_TOOLTIP_HEADER = "自動輸入直購價",
	SELL_AUTO_BUYOUT_PRICE_TOOLTIP_TEXT = [=[選擇自動輸入直購價的模式：

◎|cffffd200無|r－不輸入價格
◎這個物品|cffffd200上次|r拍賣的價格
（如果存在）
◎這個物品的歷史|cffffd200平均|r價格
◎自訂價格|cffffd200公式|r]=],
	SELL_AUTO_PRICE_FORMULA_TOOLTIP_HEADER = "自訂價格公式",
	SELL_AUTO_PRICE_FORMULA_TOOLTIP_TEXT = [=[自訂自動輸入價格的計算公式。
可使用下列代碼：

|cffffd200AVG|r－歷史平均價格

例：AVG+((AVG)/3) * 1.2]=],
	SELL_AUTO_PRICE_HEADER = "自動輸入價格",
	SELL_AUTO_PRICE_PERCENT_TOOLTIP_HEADER = "降價",
	SELL_AUTO_PRICE_PERCENT_TOOLTIP_TEXT = "定義平均價降價的百分比",
	SELL_FORMULA = "公式",
	SELL_LAST = "上次",
	SELL_NONE = "無",
	SELL_NUM_AUCTION = "已拍賣數量：",
	SELL_PERCENT = "% 降價",
	SELL_PER_UNIT = "單價",
	SETTINGS_AVG_DEFAULT_LAST_PRICE = "Without last price suggest the average", -- Requires localization
	SETTINGS_AVG_DEFAULT_LAST_PRICE_HEADER = "Without last price suggest the average", -- Requires localization
	SETTINGS_AVG_DEFAULT_LAST_PRICE_TEXT = [=[Active: Insert the average when selling an item without a last sell price.
Inactive: The field sell price will be left empty.]=], -- Requires localization
	SETTINGS_BROWSE = "瀏覽設定",
	SETTINGS_CLEAR_ALL_SUCCESS = "成功刪除所有歷史價格",
	SETTINGS_CLEAR_SUCCESS = "成功刪除歷史價格：|cffffffff",
	SETTINGS_FILTER_SPEED = "過濾速度：",
	SETTINGS_FILTER_SPEED_HEADER = "過濾速度",
	SETTINGS_FILTER_SPEED_TEXT = [=[每次搜尋即更新該物品的金額。設定越高速度越快，但越高也會造成搜尋的延遲。
支援滑鼠滾輪捲動。]=],
	SETTINGS_GENERAL = "一般設定",
	SETTINGS_HISTORY = "歷史價格設定",
	SETTINGS_MAX_SAVED_HISTORY = "儲存的歷史價格之最大單位： (默認)",
	SETTINGS_MAX_SAVED_HISTORY_HEADER = "儲存的歷史價格之最大單位 (默認)",
	SETTINGS_MAX_SAVED_HISTORY_TEXT = [=[設定最大單位的每件歷史價格。
支援滑鼠滾輪捲動。]=],
	SETTINGS_MAX_SAVED_HISTORY_RESET_BUTTON = "將所有設置為默認值",
	SETTINGS_MAX_SAVED_HISTORY_RESET_HEADER = "將所有設置為默認值",
	SETTINGS_MAX_SAVED_HISTORY_RESET_TEXT = "按此按鈕可將所有項目的最大保存歷史記錄條目設置為默認值",
	SETTINGS_MIN_WARNING_PRICE = "Minimum price for bid confirmation", -- Requires localization
	SETTINGS_MIN_WARNING_PRICE_HEADER = "Minimum price for bid confirmation", -- Requires localization
	SETTINGS_MIN_WARNING_PRICE_TEXT = "Sets the minimum amount of money for which a bid confirmation dialog is being displayed.", -- Requires localization
	SETTINGS_MISSING_PARAMETER = "找不到參數刪除歷史資料",
	SETTINGS_PRICE_HISTORY_TOOLTIP = "總是顯示歷史價格提示",
	SETTINGS_PRICE_HISTORY_TOOLTIP_HEADER = "顯示歷史價格提示",
	SETTINGS_PRICE_HISTORY_TOOLTIP_TEXT = [=[顯示：按住 Alt 才隱藏歷史價格。
隱藏：按住 Alt 才顯示歷史價格。]=],
	SETTINGS_PRICE_PER_UNIT_PER_WHITE = "以 白色材料 單價為單位",
	SETTINGS_PRICE_PER_UNIT_PER_WHITE_HEADER = "白色材料 單價",
	SETTINGS_PRICE_PER_UNIT_PER_WHITE_TEXT = [=[開啟這選項將導致所有材料以"白色材料"單價為單位。這將讓您更容易地比較材料的不同層次及價格。這也將適用於拍賣的銷售單價價格設定。
綠色 = 2個 "白色材料"
藍色 = 12個 "白色材料"
紫色 = 72個 "白色材料"
範例：
100 個 |cff0072bc[Zinc Ingot]|r 賣 120,000
單價 = 1,200
"白色材料"單價 = 100]=],
	TOOLS_DAY_ABV = "天",
	TOOLS_GOLD_BASED = "（基於搜尋到的 <SCANNED> 筆交易）",
	TOOLS_HOUR_ABV = "時",
	TOOLS_ITEM_NOT_FOUND = "找不到歷史價格：|cffffffff",
	TOOLS_MIN_ABV = "分",
	TOOLS_NO_HISTORY_DATA = "沒有可用的資料",
	TOOLS_POWERED_BY = "(Powered by Advanced AuctionHouse)",
	TOOLS_PRICE_HISTORY = "歷史價格",
	TOOLS_UNKNOWN_COMMAND = [=[未知的指令。指令為：
|cffffffff/aah numhistory <max history entries to save per item>|r
|cffffffff/aah clear <item>|r
|cffffffff/aah clearall|r
|cffffffff/aah pricehistory|r]=],
}
