AAHLocale = {}
AAHLocale.Commands = {
	BARGAIN = "$bargain,$店売", -- Needs review
	DURA = "$dura,$耐久", -- Needs review
	EGGAPTITUDE = "$eggapt,$資質", -- Needs review
	EGGLEVEL = "$egglvl,$レベル", -- Needs review
	FIVE = "$five,$5", -- Needs review
	FOUR = "$four,$4", -- Needs review
	GREEN = "$緑,$green", -- Needs review
	ONE = "$one,$1", -- Needs review
	ORANGE = "$orange,$橙", -- Needs review
	PLUS = "$plus", -- Requires localization
	SIX = "$six,$6", -- Needs review
	THREE = "$three,$3", -- Needs review
	TIER = "$ML,$tier", -- Needs review
	TWO = "$two,$2", -- Needs review
	VENDOR = "$vendor,$npc,$店売", -- Needs review
	YELLOW = "$yellow,$黄,$黄色", -- Needs review
	ZERO = "$clean,$zero,$0,$クリーン", -- Needs review
}
AAHLocale.Messages = {
	ADDON_MANAGER_DESCRIPTION = [=[Advanced AuctionHouseは、標準のオークション窓の機能を拡張します。
		機能は全てオークション窓に表示されるので、特に設定などは必要ありません。]=],
	AUCTION_EXCHANGE_RATE = "レート",
	AUCTION_FORUMS_BUTTON = "公式フォーラム",
	AUCTION_FORUMS_BUTTON_TOOLTIP_HEADER = "公式フォーラムへのリンク",
	AUCTION_FORUMS_BUTTON_TOOLTIP_TEXT = "Webブラウザを使って、このアドオンの公式フォーラムを開きます",
	AUCTION_FRAME_TITLE = "Advanced AuctionHouse <VERSION> by Mavoc (日本語版 by TBDjp)", -- Needs review
	AUCTION_LOADED_MESSAGE = "ロード完了: AdvancedAuctionHouse <VERSION> by Mavoc (日本語版 by TBDjp)", -- Needs review
	BROWSE_CANCELLING = "前回の検索をキャンセルしています",
	BROWSE_CLEAR_BUTTON = "リセット",
	BROWSE_CLEAR_BUTTON_TOOLTIP_HEADER = "フィルタ初期化",
	BROWSE_CLEAR_BUTTON_TOOLTIP_TEXT = "ダウンロードした検索結果は保持したまま、フィルタのみ解除します。",
	BROWSE_CREATE_FOLDER_POPUP = "フォルダ名設定",
	BROWSE_FILTER = "フィルタ",
	BROWSE_FILTER_OR_TOOLTIP_HEADER = "キーワードをORで結合します",
	BROWSE_FILTER_OR_TOOLTIP_TEXT = [=[ここにチェックをいれると、複数のキーワードがORで結合されるようになります。
デフォルトではAND結合です。]=],
	BROWSE_FILTER_PRICERANGE_BID_TOOLTIP_HEADER = "入札/即決切替",
	BROWSE_FILTER_PRICERANGE_BID_TOOLTIP_TEXT = "チェックを入れると、入札価格ではなく即決価格で検索します",
	BROWSE_FILTER_PRICERANGE_MAX_TOOLTIP_HEADER = "価格上限",
	BROWSE_FILTER_PRICERANGE_MAX_TOOLTIP_TEXT = "検索のための価格の上限を入力します",
	BROWSE_FILTER_PRICERANGE_MIN_TOOLTIP_HEADER = "価格下限",
	BROWSE_FILTER_PRICERANGE_MIN_TOOLTIP_TEXT = "検索のための価格の下限を入力します",
	BROWSE_FILTER_PRICERANGE_PPU_TOOLTIP_HEADER = "価格/単価切替",
	BROWSE_FILTER_PRICERANGE_PPU_TOOLTIP_TEXT = "チェックを入れると、価格ではなく単価で検索します",
	BROWSE_FILTER_TOOLTIP_HEADER = "フィルタ　キーワード#",
	BROWSE_FILTER_TOOLTIP_TEXT1 = [=[検索結果を更に絞り込むためのフィルタを設定できます。キーワードの前に!(半角)をつけると、否定になります。それぞれの枠に記入したキーワードすべてを結合(デフォルトはAND)した結果で絞り込みます。

以下の特殊キーワードが使用できます：]=], -- Needs review
	BROWSE_FILTER_TOOLTIP_TEXT2 = [=[|cffffd200$緑|r - 緑オプ付き
|cffffd200$黄|r - 黄色オプ付き
|cffffd200$橙|r - 橙色オプ付き
|cffffd200$0|r - オプなし
|cffffd200$1|r - オプ1個
|cffffd200$2|r - オプ2個
|cffffd200$3|r - オプ3個
|cffffd200$4|r - オプ4個
|cffffd200$5|r - オプ5個
|cffffd200$6|r - オプ6個]=],
	BROWSE_FILTER_TOOLTIP_TEXT3 = [=[|cffffd200$耐久|r - 耐久指定(数字なしの場合101以上)
--(例 $耐久110 耐久110以上)
|cffffd200$ML|r - ML指定
--(例 $ML3 ML3以上)
|cffffd200$レベル|r - ペット卵のレベル
--(例 $レベル30 レベル30以上)
|cffffd200$資質|r - ペット卵の資質
--(例 $資質80 資質80以上)
|cffffd200$店売|r - 店売りで儲けが出る価格
--(詳細はcurse参照)
|cffffd200$転売|r - 転売で儲けが出る価格
--(詳細はcurse参照)]=], -- Needs review
	BROWSE_HEADER_CUSTOM_TITLE = "Select Auction Data Type:", -- Requires localization
	BROWSE_INFO_LABEL = "総数 <MAXITEMS> 件. <SCANPERCENT>% ロード済. フィルタ合致 <FILTEREDITEMS> 件. フィルタリング <FILTERPERCENT>% 終了.",
	BROWSE_INFO_LABEL_TOOLTIP_HEADER = "処理進行度",
	BROWSE_INFO_LABEL_TOOLTIP_TEXT = [=[まず検索結果に合致するものをダウンロードし、それからフィルタ処理を行います。
- ヒット総数 
(サーバ側の制約で最大500件しか処理できません)
- 検索結果ダウンロードの進行度
- フィルタに合致したアイテム数
- フィルタリングの進行度]=],
	BROWSE_MAX = "Max",
	BROWSE_MIN = "Min",
	BROWSE_NAME_SEARCH_POPUP = "検索条件に名前をつけて下さい",
	BROWSE_NO_RESULTS = "条件に合うアイテムはありませんでした",
	BROWSE_OR = "or",
	BROWSE_PPU = "単価",
	BROWSE_RENAME = "名前変更",
	BROWSE_RENAME_SAVED_SEARCH_POPUP = "検索条件の名前変更",
	BROWSE_SAVED_SEARCH_TITLE = "検索条件",
	BROWSE_SEARCHING = "検索中です ... しばらくお待ち下さい",
	BROWSE_SEARCH_PARAMETERS = "検索条件",
	BROWSE_USABLE = "使用可",
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
	GENERAL_ATTRIBUTES = "Attributes", -- Requires localization
	GENERAL_AVERAGE = "平均",
	GENERAL_AVERAGE_PRICE_PER_UNIT = "平均単価:",
	GENERAL_CUSTOM_HEADER_TOOLTIP_HEADER = "Custom Column", -- Requires localization
	GENERAL_CUSTOM_HEADER_TOOLTIP_TEXT = [=[Left-Click: Sort Column
Right-Click: Change Column]=], -- Requires localization
	GENERAL_DECIMAL_POINT = ".",
	GENERAL_DEX_HEADER = "Dex", -- Requires localization
	GENERAL_DPS_HEADER = "DPS", -- Requires localization
	GENERAL_DURA_HEADER = "Dura", -- Requires localization
	GENERAL_GENERAL = "General", -- Requires localization
	GENERAL_HEAL_HEADER = "Heal", -- Requires localization
	GENERAL_HP_HEADER = "HP", -- Requires localization
	GENERAL_INTEL_HEADER = "Intel", -- Requires localization
	GENERAL_MACC_HEADER = "M Acc", -- Requires localization
	GENERAL_MATT_HEADER = "M Att", -- Requires localization
	GENERAL_MCRIT_HEADER = "M Crit", -- Requires localization
	GENERAL_MDAM_HEADER = "M Dam", -- Requires localization
	GENERAL_MDEF_HEADER = "M Def", -- Requires localization
	GENERAL_MEDIAN_PRICE_PER_UNIT = "価格中央値",
	GENERAL_MP_HEADER = "MP", -- Requires localization
	GENERAL_OTHER = "Other", -- Requires localization
	GENERAL_PACC_HEADER = "P Acc", -- Requires localization
	GENERAL_PARRY_HEADER = "Parry", -- Requires localization
	GENERAL_PATT_HEADER = "P Att", -- Requires localization
	GENERAL_PCRIT_HEADER = "P Crit", -- Requires localization
	GENERAL_PDAM_HEADER = "P Dam", -- Requires localization
	GENERAL_PDEF_HEADER = "P Def", -- Requires localization
	GENERAL_PDOD_HEADER = "Dodge", -- Requires localization
	GENERAL_PLUS_HEADER = "Plus", -- Requires localization
	GENERAL_PRICE_PER_UNIT_HEADER = "単価",
	GENERAL_SPEED_HEADER = "Speed", -- Requires localization
	GENERAL_STAM_HEADER = "Stam", -- Requires localization
	GENERAL_STATS = "Stats", -- Requires localization
	GENERAL_STR_HEADER = "Str", -- Requires localization
	GENERAL_TIER_HEADER = "Tier", -- Requires localization
	GENERAL_UNITS_PER_PRICE_HEADER = "Units/Price", -- Requires localization
	GENERAL_WIS_HEADER = "Wis", -- Requires localization
	GENERAL_WORTH_HEADER = "Worth", -- Requires localization
	HISTORY_NO_DATA = "価格履歴がありません!",
	HISTORY_SUMMARY_AVERAGE = [=[中央値: <MEDIAN>
平均値: <AVERAGE>]=],
	HISTORY_SUMMARY_MINMAX = [=[最安値: <MINIMUM>
最高値: <MAXIMUM>]=],
	HISTORY_SUMMARY_NUMHISTORY = "(<NUMHISTORY> 件)",
	LUNA_NEW_VERSION_FOUND = "Advanced AuctionHouse の新バージョンが curseに公開されています",
	LUNA_NOT_FOUND = "アドオンLunaが実装されていません。Curseからダウンロードできます。",
	SELL_AUTO_BID_PRICE_TOOLTIP_HEADER = "開始価格自動設定",
	SELL_AUTO_BID_PRICE_TOOLTIP_TEXT = [=[開始価格の自動設定モードの設定をします。以下の4種類から選択です。

|cffffd200なし|r 自動設定をしません

 |cffffd200直近|r に設定した価格を引き継ぎます。

|cffffd200平均|r 売買履歴の平均値に設定します。

|cffffd200計算式|rを自分で設定することも出来ます]=],
	SELL_AUTO_BUYOUT_PRICE_TOOLTIP_HEADER = "即決価格自動設定",
	SELL_AUTO_BUYOUT_PRICE_TOOLTIP_TEXT = [=[即決価格の自動設定モードの設定をします。以下の4種類から選択です。

|cffffd200なし|r 自動設定をしません

 |cffffd200前回|r に設定した価格を引き継ぎます。

|cffffd200平均|r 売買履歴の平均値に設定します。

|cffffd200計算式|rを自分で設定することも出来ます。]=],
	SELL_AUTO_PRICE_FORMULA_TOOLTIP_HEADER = "計算式",
	SELL_AUTO_PRICE_FORMULA_TOOLTIP_TEXT = [=[自動設定で用いる計算式を設定します。 以下の変数が使えます。

AVG - 平均価格

例: AVG+((AVG)/3) * 1.2]=],
	SELL_AUTO_PRICE_HEADER = "自動価格設定",
	SELL_AUTO_PRICE_PERCENT_TOOLTIP_HEADER = "相対価格設定",
	SELL_AUTO_PRICE_PERCENT_TOOLTIP_TEXT = "平均価格の何パーセントにするかを設定します",
	SELL_FORMULA = "計算式",
	SELL_LAST = "前回",
	SELL_NONE = "なし",
	SELL_NUM_AUCTION = "オークション出品数:",
	SELL_PERCENT = "% 安く",
	SELL_PER_UNIT = "単価",
	SETTINGS_AVG_DEFAULT_LAST_PRICE = "Without last price suggest the average", -- Requires localization
	SETTINGS_AVG_DEFAULT_LAST_PRICE_HEADER = "Without last price suggest the average", -- Requires localization
	SETTINGS_AVG_DEFAULT_LAST_PRICE_TEXT = [=[Active: Insert the average when selling an item without a last sell price.
Inactive: The field sell price will be left empty.]=], -- Requires localization
	SETTINGS_BROWSE = "Browse Settings", -- Requires localization
	SETTINGS_CLEAR_ALL_SUCCESS = "すべての価格データを消去しました",
	SETTINGS_CLEAR_SUCCESS = "価格データを消去しました: |cffffffff",
	SETTINGS_FILTER_SPEED = "Filter Speed", -- Requires localization
	SETTINGS_FILTER_SPEED_HEADER = "Filter Speed", -- Requires localization
	SETTINGS_FILTER_SPEED_TEXT = [=[This sets the amount of items to filter per update. The higher the setting the faster the speed but the higher the lag caused from filtering.
Supports mouse-wheel]=], -- Requires localization
	SETTINGS_GENERAL = "General Settings", -- Requires localization
	SETTINGS_HISTORY = "History Settings", -- Requires localization
	SETTINGS_MAX_SAVED_HISTORY = "Max Saved History (デフォルト)", -- Requires localization
	SETTINGS_MAX_SAVED_HISTORY_HEADER = "Max Saved History (デフォルト)", -- Requires localization
	SETTINGS_MAX_SAVED_HISTORY_TEXT = [=[Set the max amount of saved history per item.
Supports mouse-wheel]=], -- Requires localization
	SETTINGS_MAX_SAVED_HISTORY_RESET_BUTTON = "Set all to default",
	SETTINGS_MAX_SAVED_HISTORY_RESET_HEADER = "Set all to default",
	SETTINGS_MAX_SAVED_HISTORY_RESET_TEXT = "Press this button to set the max saved history entries for all items to default.",
	SETTINGS_MIN_WARNING_PRICE = "Minimum price for bid confirmation", -- Requires localization
	SETTINGS_MIN_WARNING_PRICE_HEADER = "Minimum price for bid confirmation", -- Requires localization
	SETTINGS_MIN_WARNING_PRICE_TEXT = "Sets the minimum amount of money for which a bid confirmation dialog is being displayed.", -- Requires localization
	SETTINGS_MISSING_PARAMETER = "履歴消去のためのパラメータが欠けています",
	SETTINGS_PRICE_HISTORY_TOOLTIP = "Always Show Price History Tooltip", -- Requires localization
	SETTINGS_PRICE_HISTORY_TOOLTIP_HEADER = "Show Price History Tooltip", -- Requires localization
	SETTINGS_PRICE_HISTORY_TOOLTIP_TEXT = [=[Checked: Display Tooltip by Default. Hold ALT to hide
Unchecked: Only Display Tooltip if ALT is held down]=], -- Requires localization
	SETTINGS_PRICE_PER_UNIT_PER_WHITE = "Price/Unit/White For Materials", -- Requires localization
	SETTINGS_PRICE_PER_UNIT_PER_WHITE_HEADER = "Price/Unit/White", -- Requires localization
	SETTINGS_PRICE_PER_UNIT_PER_WHITE_TEXT = [=[Enabling this will cause all Materials to used Price Per Unit Per White Material. This will allow you to more easily compare prices of Materials at different levels of refinement. This will apply to all areas that use Price/Unit including selling prices.
Green = 2x White Mats
Blue = 12x White Mats
Purple = 72x White Mats
Example
100x |cff0072bc[Zinc Ingot]|r at 120,000 for the stack
Price/Unit = 1,200
Price/Unit/White = 100]=], -- Requires localization
	TOOLS_DAY_ABV = "日",
	TOOLS_GOLD_BASED = "(最近 <SCANNED> 件のゴールド販売価格平均)",
	TOOLS_HOUR_ABV = "時間",
	TOOLS_ITEM_NOT_FOUND = "販売履歴がありません: |cffffffff",
	TOOLS_MIN_ABV = "分",
	TOOLS_NO_HISTORY_DATA = "価格データがありません",
	TOOLS_POWERED_BY = "(powered by Advanced AuctionHouse)",
	TOOLS_PRICE_HISTORY = "履歴",
	TOOLS_UNKNOWN_COMMAND = [=[不明なコマンドです. 有効なコマンドは:
|cffffffff/aah numhistory 数値   　|r履歴保持件数設定(デフォルト100)
|cffffffff/aah clear アイテムリンク　|r個別アイテム毎の履歴削除
|cffffffff/aah clearall　　　　　　　　|r全履歴データクリア
|cffffffff/aah pricehistory           |r価格履歴表示・非表示切り替え]=],
}
