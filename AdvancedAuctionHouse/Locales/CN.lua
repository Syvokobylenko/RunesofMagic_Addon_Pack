AAHLocale = {}
AAHLocale.Commands = {
	BARGAIN = "$bargain", -- Requires localization
	DURA = "$dura,$durability", -- Requires localization
	EGGAPTITUDE = "$eggapt", -- Requires localization
	EGGLEVEL = "$egglvl", -- Requires localization
	FIVE = "$five,$quintuple", -- Requires localization
	FOUR = "$four,$quadruple", -- Requires localization
	GREEN = "$green", -- Requires localization
	ONE = "$one,$single", -- Requires localization
	ORANGE = "$orange", -- Requires localization
	PLUS = "$plus", -- Requires localization
	SIX = "$six,$sextuple", -- Requires localization
	THREE = "$three,$triple", -- Requires localization
	TIER = "$tier", -- Requires localization
	TWO = "$two,$double", -- Requires localization
	VENDOR = "$vendor", -- Requires localization
	YELLOW = "$yellow", -- Requires localization
	ZERO = "$zero,$clean", -- Requires localization
}
AAHLocale.Messages = {
	ADDON_MANAGER_DESCRIPTION = [=[Advanced AuctionHouse alters the default auctionhouse frame. It adds several useful new functions to make browsing and auctioning easier and more comfortable.

All functionality is directly built into the auctionframe so you don't have to do anything but open the auctionhouse and you can use the new functions right away.]=], -- Requires localization
	AUCTION_EXCHANGE_RATE = "Exchange Rate", -- Requires localization
	AUCTION_FORUMS_BUTTON = "AAH Forums", -- Requires localization
	AUCTION_FORUMS_BUTTON_TOOLTIP_HEADER = "Advanced AuctionHouse Forums Weblink", -- Requires localization
	AUCTION_FORUMS_BUTTON_TOOLTIP_TEXT = "This will open up your default browser to the Advanced AuctionHouse Forums", -- Requires localization
	AUCTION_FRAME_TITLE = "Advanced AuctionHouse <VERSION> by <AUTHOR> (EN)", -- Requires localization
	AUCTION_LOADED_MESSAGE = "Addon loaded: Advanced AuctionHouse <VERSION> by <AUTHOR> (EN)", -- Requires localization
	BROWSE_CANCELLING = "Cancelling previous search", -- Requires localization
	BROWSE_CLEAR_BUTTON = "Clear", -- Requires localization
	BROWSE_CLEAR_BUTTON_TOOLTIP_HEADER = "Clear Search and Filters", -- Requires localization
	BROWSE_CLEAR_BUTTON_TOOLTIP_TEXT = "Press this button to reset all search and filter parameters applied to your search. This will not reset the search result itself.", -- Requires localization
	BROWSE_CREATE_FOLDER_POPUP = "Create a Folder Name", -- Requires localization
	BROWSE_FILTER = "Filters", -- Requires localization
	BROWSE_FILTER_OR_TOOLTIP_HEADER = "Link Keywords With OR", -- Requires localization
	BROWSE_FILTER_OR_TOOLTIP_TEXT = [=[Check this to link multiple keywords with OR instead of AND.
(Filter#1 and/or Filter#2) and/or Filter#3]=], -- Requires localization
	BROWSE_FILTER_PRICERANGE_BID_TOOLTIP_HEADER = "Bid Price Filtering", -- Requires localization
	BROWSE_FILTER_PRICERANGE_BID_TOOLTIP_TEXT = "Check this to filter items based on the Bid Price instead of the Buyout Price.", -- Requires localization
	BROWSE_FILTER_PRICERANGE_MAX_TOOLTIP_HEADER = "Maximum Price Filtering", -- Requires localization
	BROWSE_FILTER_PRICERANGE_MAX_TOOLTIP_TEXT = "Enter a maximum price for filtering items.", -- Requires localization
	BROWSE_FILTER_PRICERANGE_MIN_TOOLTIP_HEADER = "Minimum Price Filtering", -- Requires localization
	BROWSE_FILTER_PRICERANGE_MIN_TOOLTIP_TEXT = "Enter a minimum price for filtering items.", -- Requires localization
	BROWSE_FILTER_PRICERANGE_PPU_TOOLTIP_HEADER = "Price/Unit Filtering", -- Requires localization
	BROWSE_FILTER_PRICERANGE_PPU_TOOLTIP_TEXT = "Check this to filter items based on the PPU instead of the total price.", -- Requires localization
	BROWSE_FILTER_TOOLTIP_HEADER = "Filter Keyword #", -- Requires localization
	BROWSE_FILTER_TOOLTIP_TEXT1 = "Enter a keyword here to filter your search results. To invert the filter type an ! in front of the keyword. Using keywords in multiple keyword boxes will link them with AND by default.", -- Requires localization
	BROWSE_FILTER_TOOLTIP_TEXT2 = [=[|cffffd200$green|r - items with green stats
|cffffd200$yellow|r - items with yellow stats
|cffffd200$orange|r - items with orange stats
|cffffd200$zero|r - items with zero stats
|cffffd200$one|r - items with one stat
|cffffd200$two|r - items with two stats
|cffffd200$three|r - items with three stats
|cffffd200$four|r - items with four stats
|cffffd200$five|r - items with five stats
|cffffd200$six|r - items with six stats]=], -- Requires localization
	BROWSE_FILTER_TOOLTIP_TEXT3 = [=[|cffffd200$dura|r - items with dura >= 101
--($dura/110 sets the min dura to 110)
|cffffd200$tier|r - items with tier >= 1
--($tier/3 sets the min tier to 3)
|cffffd200$plus|r - items with a plus >= 1
--($plus/6 sets the min plus to 6)
|cffffd200$egglvl|r - pet eggs with level >= 1
--($egglvl/30 sets the min level to 30)
|cffffd200$eggapt|r - pet eggs with aptitude >= 1
--($eggapt/80 sets the min aptitude to 80)
|cffffd200$vendor|r - sell to vendor for profit.
--(see curse.com for usage)
|cffffd200$bargain|r - resell on AH for profit
--(see curse.com for usage)]=], -- Requires localization
	BROWSE_HEADER_CUSTOM_TITLE = "Select Auction Data Type:", -- Requires localization
	BROWSE_INFO_LABEL = "Found: <MAXITEMS> - Loaded: <SCANPERCENT>% - Matched: <FILTEREDITEMS> - Filtered: <FILTERPERCENT>%", -- Requires localization
	BROWSE_INFO_LABEL_TOOLTIP_HEADER = "Caching And Filtering Progress", -- Requires localization
	BROWSE_INFO_LABEL_TOOLTIP_TEXT = [=[Displays the following information:

- the total search results (max 500)
- the progress of the search itself
- number of items matching your keywords
- the progress of the filtering process]=], -- Requires localization
	BROWSE_MAX = "Max", -- Requires localization
	BROWSE_MIN = "Min", -- Requires localization
	BROWSE_NAME_SEARCH_POPUP = "Name your Saved Search", -- Requires localization
	BROWSE_NO_RESULTS = "There were no results for your search", -- Requires localization
	BROWSE_OR = "or", -- Requires localization
	BROWSE_PPU = "PPU", -- Requires localization
	BROWSE_RENAME = "Rename", -- Requires localization
	BROWSE_RENAME_SAVED_SEARCH_POPUP = "Rename your Saved Search", -- Requires localization
	BROWSE_SAVED_SEARCH_TITLE = "Saved Searchs", -- Requires localization
	BROWSE_SEARCHING = "Search in progress ... please wait.", -- Requires localization
	BROWSE_SEARCH_PARAMETERS = "Search Parameters", -- Requires localization
	BROWSE_USABLE = "Usable", -- Requires localization
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
	GENERAL_AVERAGE = "Average", -- Requires localization
	GENERAL_AVERAGE_PRICE_PER_UNIT = "Average price per unit:", -- Requires localization
	GENERAL_CUSTOM_HEADER_TOOLTIP_HEADER = "Custom Column", -- Requires localization
	GENERAL_CUSTOM_HEADER_TOOLTIP_TEXT = [=[Left-Click: Sort Column
Right-Click: Change Column]=], -- Requires localization
	GENERAL_DECIMAL_POINT = ".", -- Requires localization
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
	GENERAL_MEDIAN_PRICE_PER_UNIT = "Median price per unit:", -- Requires localization
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
	GENERAL_PRICE_PER_UNIT_HEADER = "Price/Unit", -- Requires localization
	GENERAL_SPEED_HEADER = "Speed", -- Requires localization
	GENERAL_STAM_HEADER = "Stam", -- Requires localization
	GENERAL_STATS = "Stats", -- Requires localization
	GENERAL_STR_HEADER = "Str", -- Requires localization
	GENERAL_TIER_HEADER = "Tier", -- Requires localization
	GENERAL_UNITS_PER_PRICE_HEADER = "Units/Price", -- Requires localization
	GENERAL_WIS_HEADER = "Wis", -- Requires localization
	GENERAL_WORTH_HEADER = "Worth", -- Requires localization
	HISTORY_NO_DATA = "This item has no pricing history!", -- Requires localization
	HISTORY_SUMMARY_AVERAGE = [=[Median Price: <MEDIAN>
Average Price: <AVERAGE>]=], -- Requires localization
	HISTORY_SUMMARY_MINMAX = [=[Min Price: <MINIMUM>
Max Price: <MAXIMUM>]=], -- Requires localization
	HISTORY_SUMMARY_NUMHISTORY = " (<NUMHISTORY> auctions)", -- Requires localization
	LUNA_NEW_VERSION_FOUND = "A newer version of Advanced AuctionHouse is available from rom.curse.com", -- Requires localization
	LUNA_NOT_FOUND = "Luna is needed for this feature to work. Luna can be found on curse.", -- Requires localization
	SELL_AUTO_BID_PRICE_TOOLTIP_HEADER = "Autofill Bidprice Mode", -- Requires localization
	SELL_AUTO_BID_PRICE_TOOLTIP_TEXT = [=[The mode for autofill of the bid-value can be selected here. Modes are:

|cffffd200None|r no price will be entered

same price as |cffffd200last|r time this item was auctioned (if present)

|cffffd200average|r price this item sells for

define a custom autofill |cffffd200formula|r]=], -- Requires localization
	SELL_AUTO_BUYOUT_PRICE_TOOLTIP_HEADER = "Autofill Buyoutprice Mode", -- Requires localization
	SELL_AUTO_BUYOUT_PRICE_TOOLTIP_TEXT = [=[The mode for autofill of the buyout-value can be selected here. Modes are:

|cffffd200None|r no price will be entered

same price as |cffffd200last|r time this item was auctioned (if present)

|cffffd200average|r price this item sells for

define a custom autofill |cffffd200formula|r]=], -- Requires localization
	SELL_AUTO_PRICE_FORMULA_TOOLTIP_HEADER = "Custom Price Formula", -- Requires localization
	SELL_AUTO_PRICE_FORMULA_TOOLTIP_TEXT = [=[Define a custom formula that will be used to calculate the autofill price. The following placeholders can be used

AVG - Average price
MEDIAN - Median price
MIN - Minimum price
MAX - Maximum price

Example: AVG - ((AVG - MIN) / 3)]=], -- Requires localization
	SELL_AUTO_PRICE_HEADER = "Auto price settings", -- Requires localization
	SELL_AUTO_PRICE_PERCENT_TOOLTIP_HEADER = "Percent Of Average", -- Requires localization
	SELL_AUTO_PRICE_PERCENT_TOOLTIP_TEXT = "Auto price the item based on a % of average history", -- Requires localization
	SELL_FORMULA = "Formula", -- Requires localization
	SELL_LAST = "Last", -- Requires localization
	SELL_NONE = "None", -- Requires localization
	SELL_NUM_AUCTION = "Number of auctions:", -- Requires localization
	SELL_PERCENT = "% of average", -- Requires localization
	SELL_PER_UNIT = "per unit", -- Requires localization
	SETTINGS_AVG_DEFAULT_LAST_PRICE = "Without last price suggest the average", -- Requires localization
	SETTINGS_AVG_DEFAULT_LAST_PRICE_HEADER = "Without last price suggest the average", -- Requires localization
	SETTINGS_AVG_DEFAULT_LAST_PRICE_TEXT = [=[Active: Insert the average when selling an item without a last sell price.
Inactive: The field sell price will be left empty.]=], -- Requires localization
	SETTINGS_BROWSE = "Browse Settings", -- Requires localization
	SETTINGS_CLEAR_ALL_SUCCESS = "Successfully wiped all price history data.", -- Requires localization
	SETTINGS_CLEAR_SUCCESS = "Sucessfully wiped price history for: |cffffffff", -- Requires localization
	SETTINGS_FILTER_SPEED = "Filter Speed", -- Requires localization
	SETTINGS_FILTER_SPEED_HEADER = "Filter Speed", -- Requires localization
	SETTINGS_FILTER_SPEED_TEXT = [=[This sets the amount of items to filter per update. The higher the setting the faster the speed but the higher the lag caused from filtering.
Supports mouse-wheel]=], -- Requires localization
	SETTINGS_GENERAL = "General Settings", -- Requires localization
	SETTINGS_HISTORY = "History Settings", -- Requires localization
	SETTINGS_MAX_SAVED_HISTORY = "Max Saved History (Default)", -- Requires localization
	SETTINGS_MAX_SAVED_HISTORY_HEADER = "Max Saved History (Default)", -- Requires localization
	SETTINGS_MAX_SAVED_HISTORY_TEXT = [=[Set the max amount of saved history per item.
Supports mouse-wheel]=], -- Requires localization
	SETTINGS_MAX_SAVED_HISTORY_RESET_BUTTON = "Set all to default",
	SETTINGS_MAX_SAVED_HISTORY_RESET_HEADER = "Set all to default",
	SETTINGS_MAX_SAVED_HISTORY_RESET_TEXT = "Press this button to set the max saved history entries for all items to default.",
	SETTINGS_MIN_WARNING_PRICE = "Minimum price for bid confirmation", -- Requires localization
	SETTINGS_MIN_WARNING_PRICE_HEADER = "Minimum price for bid confirmation", -- Requires localization
	SETTINGS_MIN_WARNING_PRICE_TEXT = "Sets the minimum amount of money for which a bid confirmation dialog is being displayed.", -- Requires localization
	SETTINGS_MISSING_PARAMETER = "Missing parameter for wiping history data.", -- Requires localization
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
	TOOLS_DAY_ABV = "d", -- Requires localization
	TOOLS_GOLD_BASED = "(Based on <SCANNED> scanned auctions sold for gold)", -- Requires localization
	TOOLS_HOUR_ABV = "h", -- Requires localization
	TOOLS_ITEM_NOT_FOUND = "No history data found for: |cffffffff", -- Requires localization
	TOOLS_MIN_ABV = "m", -- Requires localization
	TOOLS_NO_HISTORY_DATA = "No data available.", -- Requires localization
	TOOLS_POWERED_BY = "(powered by Advanced AuctionHouse)", -- Requires localization
	TOOLS_PRICE_HISTORY = "Price History", -- Requires localization
	TOOLS_UNKNOWN_COMMAND = [=[Unknown command. Commands are: 
|cffffffff/aah numhistory <max history entries to save per item>|r
|cffffffff/aah clear <item>|r
|cffffffff/aah clearall|r
|cffffffff/aah pricehistory|r]=], -- Requires localization
}
