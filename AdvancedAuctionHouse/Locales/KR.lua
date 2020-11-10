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
	ADDON_MANAGER_DESCRIPTION = [=[Advanced AuctionHouse 애드온이 기본 경매장 화면으로 변경되었습니다. 검색 및 경매 거래를 더 편리하고, 더욱 편안하게 해주는 몇가지 유용한 기능들이 추가되었습니다.

모든 기능들을 경매장 화면에 넣었으므로 더 이상 경매장 화면을 여는 것 이외에 다른 일을 할 필요가 없이 새로운 기능을 곧바로 사용할 수 있습니다.]=],
	AUCTION_EXCHANGE_RATE = "교환 비율",
	AUCTION_FORUMS_BUTTON = "AAH 포럼",
	AUCTION_FORUMS_BUTTON_TOOLTIP_HEADER = "Advanced AuctionHouse 포럼 웹링크",
	AUCTION_FORUMS_BUTTON_TOOLTIP_TEXT = "기본 웹브라우저로 Advanced AuctionHouse 포럼 홈페이지에 방문합니다.",
	AUCTION_FRAME_TITLE = "Advanced AuctionHouse <VERSION> by Mavoc (KR)",
	AUCTION_LOADED_MESSAGE = "애드온이 로드됨 : Advanced AuctionHouse <VERSION> by Mavoc (KR)",
	BROWSE_CANCELLING = "이전 검색 결과를 취소하는 중입니다.",
	BROWSE_CLEAR_BUTTON = "초기화",
	BROWSE_CLEAR_BUTTON_TOOLTIP_HEADER = "검색어와 필터 지우기",
	BROWSE_CLEAR_BUTTON_TOOLTIP_TEXT = "이 버튼을 누르면 검색에 반영된 모든 검색어와 필터링 변수(키워드)가 삭제됩니다. 검색된 결과를 지우지 않습니다.",
	BROWSE_CREATE_FOLDER_POPUP = "폴더 이름 생성",
	BROWSE_FILTER = "필터",
	BROWSE_FILTER_OR_TOOLTIP_HEADER = "OR (또는) 으로 키워드 연결",
	BROWSE_FILTER_OR_TOOLTIP_TEXT = [=[체크하면 AND(그리고) 대신 OR(또는)으로 여러 키워드를 연결할 수 있습니다.
(필터#1 and/or 필터#2) and/or 필터#3]=],
	BROWSE_FILTER_PRICERANGE_BID_TOOLTIP_HEADER = "입찰 가격 필터링",
	BROWSE_FILTER_PRICERANGE_BID_TOOLTIP_TEXT = "거래 가격 대신 입찰 가격을 기준으로 하려면 여기를 선택하세요.",
	BROWSE_FILTER_PRICERANGE_MAX_TOOLTIP_HEADER = "최대 가격 필터링",
	BROWSE_FILTER_PRICERANGE_MAX_TOOLTIP_TEXT = "아이템 필터링을 위해 최대값 입력",
	BROWSE_FILTER_PRICERANGE_MIN_TOOLTIP_HEADER = "최소 가격 필터링",
	BROWSE_FILTER_PRICERANGE_MIN_TOOLTIP_TEXT = "아이템 필터링을 위해 최소값 입력",
	BROWSE_FILTER_PRICERANGE_PPU_TOOLTIP_HEADER = "가격/낱개별 필터링",
	BROWSE_FILTER_PRICERANGE_PPU_TOOLTIP_TEXT = "전체 가격 대신 낱개별 가격을 기준으로 하면 여기를 체크하세요.",
	BROWSE_FILTER_TOOLTIP_HEADER = "필터 키워드 #",
	BROWSE_FILTER_TOOLTIP_TEXT1 = [=[검색 결과에 대한 필터링 키워드를 입력하세요. 역순으로 하려면 키워드 앞에 !를 쓰세요. 기본적으로 AND(그리고)를 사용하여 각각의 입력란에 입력된 키워드를 연결합니다.

아래와 같이 특별한 필터를 사용할 수 있습니다.]=],
	BROWSE_FILTER_TOOLTIP_TEXT2 = [=[|cffffd200$green|r - 1급 희소
|cffffd200$yellow|r - 2급 희소
|cffffd200$orange|r - 3급 희소
|cffffd200$zero|r - 4급 희소
|cffffd200$one|r - 5급 희소
|cffffd200$two|r - 6급 희소
|cffffd200$three|r - 7급 희소
|cffffd200$four|r - 8급 희소
|cffffd200$five|r - 9급 희소
|cffffd200$six|r - 10급 희소]=],
	BROWSE_FILTER_TOOLTIP_TEXT3 = [=[|cffffd200$dura|r - items with dura >= 101
--( $dura/110으로 설정하면 내구 110 이상)
|cffffd200$tier|r - items with tier >= 1
--( $tier/3으로 설정하면 룬 공간 3이상)
|cffffd200$plus|r - items with a plus >= 1
--( $plus/6으로 설정하면 아이템 등급 희소 6이상)
|cffffd200$egglvl|r - pet eggs with level >= 1
--( $egglvl/30으로 설정하면 펫 30레벨 이상)
|cffffd200$eggapt|r - pet eggs with aptitude >= 1
--( $eggapt/80으로 설정하면 펫 자질 80 이상)
|cffffd200$vendor|r - sell to vendor for profit.
--( 사용법은 curse.com을 봐주세요 )
|cffffd200$bargain|r - resell on AH for profit
--( 사용법은 curse.com을 봐주세요 )]=],
	BROWSE_HEADER_CUSTOM_TITLE = "경매 물품 형식 선택",
	BROWSE_INFO_LABEL = "<MAXITEMS>개 찾음 - <SCANPERCENT>% 읽음 - <FILTEREDITEMS>개 일치함 - <FILTERPERCENT>% 필터링됨",
	BROWSE_INFO_LABEL_TOOLTIP_HEADER = "캐싱과 필터링 진행률",
	BROWSE_INFO_LABEL_TOOLTIP_TEXT = [=[아래의 정보들을 보여줍니다:

- 전체 검색 결과 (최대 500)
- 검색 결과 진행률
- 지정한 키워드에 맞는 아이템 수량
- 필터링 작업의 진행률]=],
	BROWSE_MAX = "최대",
	BROWSE_MIN = "최소",
	BROWSE_NAME_SEARCH_POPUP = "검색 결과 저장",
	BROWSE_NO_RESULTS = "검색 조건에 맞는 결과가 없습니다.",
	BROWSE_OR = "또는",
	BROWSE_PPU = "낱개별 가격",
	BROWSE_RENAME = "이름 재설정",
	BROWSE_RENAME_SAVED_SEARCH_POPUP = "검색 결과 삭제",
	BROWSE_SAVED_SEARCH_TITLE = "검색 결과 저장",
	BROWSE_SEARCHING = "검색 진행중 ... 기다려 주세요.",
	BROWSE_SEARCH_PARAMETERS = "검색 변수",
	BROWSE_USABLE = "사용가능",
	COMMAND_BARGAIN_DESCRIPTION = "Resell on AH for profit", -- Requires localization
	COMMAND_DURA_DESCRIPTION = "내구 101이상 아이템; 내구 123이상 검색시 '/123' 추가",
	COMMAND_EGGAPTITUDE_DESCRIPTION = "펫의 자질; 최소 자질 80이상은 '/80' 추가",
	COMMAND_EGGLEVEL_DESCRIPTION = "펫의 레벨; 최소 30레벨 이상은 '/30' 추가",
	COMMAND_FIVE_DESCRIPTION = "9급 희소", -- Needs review
	COMMAND_FOUR_DESCRIPTION = "8급 희소", -- Needs review
	COMMAND_GREEN_DESCRIPTION = "1급 희소", -- Needs review
	COMMAND_ONE_DESCRIPTION = "5급 희소", -- Needs review
	COMMAND_ORANGE_DESCRIPTION = "3급 희소", -- Needs review
	COMMAND_PLUS_DESCRIPTION = "items with a plus >= 1; add '/6' to set minimum to 6", -- Requires localization
	COMMAND_SIX_DESCRIPTION = "10급 희소", -- Needs review
	COMMAND_THREE_DESCRIPTION = "7급 희소", -- Needs review
	COMMAND_TIER_DESCRIPTION = "티어 아이템; 최소 6티어 이상 '/6' 추가",
	COMMAND_TWO_DESCRIPTION = "6급 희소", -- Needs review
	COMMAND_VENDOR_DESCRIPTION = "sell to vendor for profit", -- Requires localization
	COMMAND_YELLOW_DESCRIPTION = "2급 희소", -- Needs review
	COMMAND_ZERO_DESCRIPTION = "4급 희소", -- Needs review
	GENERAL_ATTRIBUTES = "속성",
	GENERAL_AVERAGE = "평균",
	GENERAL_AVERAGE_PRICE_PER_UNIT = "낱개별 가격 평균",
	GENERAL_CUSTOM_HEADER_TOOLTIP_HEADER = "행 지정",
	GENERAL_CUSTOM_HEADER_TOOLTIP_TEXT = [=[왼쪽 클릭 :  행 정렬
오른쪽 클릭 : 행 변경]=],
	GENERAL_DECIMAL_POINT = ".",
	GENERAL_DEX_HEADER = "민첩",
	GENERAL_DPS_HEADER = "DPS",
	GENERAL_DURA_HEADER = "내구",
	GENERAL_GENERAL = "전체",
	GENERAL_HEAL_HEADER = "치유량 증가",
	GENERAL_HP_HEADER = "생명력",
	GENERAL_INTEL_HEADER = "지능",
	GENERAL_MACC_HEADER = "마법 명중률",
	GENERAL_MATT_HEADER = "마법 추가 공격력",
	GENERAL_MCRIT_HEADER = "마법 치명타 적중률",
	GENERAL_MDAM_HEADER = "마법 공격력",
	GENERAL_MDEF_HEADER = "마법 방어",
	GENERAL_MEDIAN_PRICE_PER_UNIT = "개별 가격 중간값",
	GENERAL_MP_HEADER = "마력",
	GENERAL_OTHER = "기타",
	GENERAL_PACC_HEADER = "물리 명중률",
	GENERAL_PARRY_HEADER = "무기 막기",
	GENERAL_PATT_HEADER = "물리 추가 공격력",
	GENERAL_PCRIT_HEADER = "물리 치명타 적중률",
	GENERAL_PDAM_HEADER = "물리 공격력",
	GENERAL_PDEF_HEADER = "물리 방어",
	GENERAL_PDOD_HEADER = "물리 회피율",
	GENERAL_PLUS_HEADER = "추가",
	GENERAL_PRICE_PER_UNIT_HEADER = "가격/낱개별",
	GENERAL_SPEED_HEADER = "공격 속도",
	GENERAL_STAM_HEADER = "체력",
	GENERAL_STATS = "스탯",
	GENERAL_STR_HEADER = "힘",
	GENERAL_TIER_HEADER = "티어",
	GENERAL_UNITS_PER_PRICE_HEADER = "개별/가격",
	GENERAL_WIS_HEADER = "정신",
	GENERAL_WORTH_HEADER = "등급",
	HISTORY_NO_DATA = "이 아이템은 가격 기록이 없습니다!",
	HISTORY_SUMMARY_AVERAGE = [=[중간 가격 : <MEDIAN>
평균 가격 : <AVERAGE>]=],
	HISTORY_SUMMARY_MINMAX = [=[최소 가격 : <MINIMUM>
최대 가격 : <MAXIMUM>]=],
	HISTORY_SUMMARY_NUMHISTORY = " (<NUMHISTORY> 거래)",
	LUNA_NEW_VERSION_FOUND = "rom.curse.com 홈페이지에 dvanced AuctionHouse 새로운 버전이 업데이트 되었습니다.",
	LUNA_NOT_FOUND = "Luna 애드온이 필요합니다. Luna는 curse홈페이지(rom.curseforge.com)에서 찾을 수 있습니다.",
	SELL_AUTO_BID_PRICE_TOOLTIP_HEADER = "입찰 가격 자동입력 모드",
	SELL_AUTO_BID_PRICE_TOOLTIP_TEXT = [=[이 모드를 선택하면 경매 입찰 가격을 자동으로 입력해줍니다. 모드:

|cffffd200입력 없음|r  가격이 자동 입력되지 않습니다.

|cffffd200마지막|r 거래의 가격과 동일한 가격이 입력됩니다. (가격 기록이 존재한다면)

|cffffd200평균|r은 거래된 가격의 평균 가격을 입력해줍니다.

|cffffd200공식|r은 사용자가 정의한 공식으로 계산하여 입력해줍니다.]=],
	SELL_AUTO_BUYOUT_PRICE_TOOLTIP_HEADER = "즉시구매 가격 자동입력 모드",
	SELL_AUTO_BUYOUT_PRICE_TOOLTIP_TEXT = [=[여기를 선택하면 즉시구매 가격을 자동 입력할 수 있습니다. 모드:

|cffffd200입력 없음|r 가격이 자동 입력되지 않습니다.

|cffffd200마지막|r 거래의 가격과 동일한 가격이 입력됩니다. (가격 기록이 존재한다면)

|cffffd200평균|r은 거래된 가격의 평균 가격을 입력해줍니다.

|cffffd200공식|r은 사용자가 정의한 공식으로 계산하여 입력해줍니다.]=],
	SELL_AUTO_PRICE_FORMULA_TOOLTIP_HEADER = "사용자 정의 가격",
	SELL_AUTO_PRICE_FORMULA_TOOLTIP_TEXT = [=[입찰 가격 자동 입력에 사용될 사용자 공식을 정의합니다. 아래와 같은 연산자로 사용할 수 있습니다..

AVG - 평균 가격
MEDIAN - 중간 가격
MIN - 최소 가격
MAX - 최대 가격

예: AVG - ((AVG - MIN) / 3)]=],
	SELL_AUTO_PRICE_HEADER = "자동 가격 설정",
	SELL_AUTO_PRICE_PERCENT_TOOLTIP_HEADER = "평균 비율",
	SELL_AUTO_PRICE_PERCENT_TOOLTIP_TEXT = "평균 기록 %를 기준으로 자동 가격 입력",
	SELL_FORMULA = "공식",
	SELL_LAST = "마지막",
	SELL_NONE = "없음",
	SELL_NUM_AUCTION = "경매 거래 수량",
	SELL_PERCENT = "평균 %",
	SELL_PER_UNIT = "낱개별",
	SETTINGS_AVG_DEFAULT_LAST_PRICE = "Without last price suggest the average", -- Requires localization
	SETTINGS_AVG_DEFAULT_LAST_PRICE_HEADER = "Without last price suggest the average", -- Requires localization
	SETTINGS_AVG_DEFAULT_LAST_PRICE_TEXT = [=[활성 : 마지막 판매가격없이 아아템을 팔 때 평균가를 입력합니다.
비활성 : 판매가격이 비워집니다.]=],
	SETTINGS_BROWSE = "검색 설정",
	SETTINGS_CLEAR_ALL_SUCCESS = "모든 가격 기록 데이터가 성공적으로 삭제되었습니다.",
	SETTINGS_CLEAR_SUCCESS = "가격 기록 삭제: |cffffffff",
	SETTINGS_FILTER_SPEED = "필터 설정",
	SETTINGS_FILTER_SPEED_HEADER = "필터 속도",
	SETTINGS_FILTER_SPEED_TEXT = [=[이 설정은 각 업데이트 때마다 필터링하는 아이템 수량을 조절합니다. 높게 설정할수록 더 빨라지지만 필터링 때문에 렉이 발생할 수 있습니다.
마우스 휠 기능을 지원합니다.]=],
	SETTINGS_GENERAL = "일반 설정",
	SETTINGS_HISTORY = "기록 설정",
	SETTINGS_MAX_SAVED_HISTORY = "최대 기록 저장 (태만)",
	SETTINGS_MAX_SAVED_HISTORY_HEADER = "최대 기록 저장 (태만)",
	SETTINGS_MAX_SAVED_HISTORY_TEXT = [=[아이템 별로 저장된 기록 최대한으로 설정
(마우스 휠을 지원합니다)]=],
	SETTINGS_MAX_SAVED_HISTORY_RESET_BUTTON = "모두 기본값으로 설정하십시오.",
	SETTINGS_MAX_SAVED_HISTORY_RESET_HEADER = "모두 기본값으로 설정하십시오.",
	SETTINGS_MAX_SAVED_HISTORY_RESET_TEXT = "이 버튼을 누르면 모든 항목의 최대 저장된 이력 항목을 기본값으로 설정합니다.",
	SETTINGS_MIN_WARNING_PRICE = "경매 확정을 위한 최소가격",
	SETTINGS_MIN_WARNING_PRICE_HEADER = "경매 확정을 위한 최소가격",
	SETTINGS_MIN_WARNING_PRICE_TEXT = "표시된 입찰 확인 대화 상자에 최소 금액을 설정합니다.",
	SETTINGS_MISSING_PARAMETER = "기록 데이터를 지우기 위한 변수가 없습니다.",
	SETTINGS_PRICE_HISTORY_TOOLTIP = "항상 가격 기록 툴팁 보기",
	SETTINGS_PRICE_HISTORY_TOOLTIP_HEADER = "가격 기록 툴립 보기",
	SETTINGS_PRICE_HISTORY_TOOLTIP_TEXT = [=[체크 : 기본 툴립 표시 (ALT 키를 누르고 있으면 사라짐)
체크 해제 :  ALT키를 누르고 있을 때만 툴팁 표시]=],
	SETTINGS_PRICE_PER_UNIT_PER_WHITE = "가격/낱개별/순수 원재료",
	SETTINGS_PRICE_PER_UNIT_PER_WHITE_HEADER = "가격/낱개별/원재료",
	SETTINGS_PRICE_PER_UNIT_PER_WHITE_TEXT = [=[이 기능을 사용하면 순수 원재료의 낱개별 가격으로 모든 재료를 다룰 수 있게 됩니다.
다른 등급의 재료 가격을 좀 더 쉽게 비교할 수 있게 됩니다.
판매 가격을 포함한 낱개별 가격을 사용할 수 있도록 합니다.

Green = 2x White Mats (녹색 = 원재료x2)
Blue = 12x White Mats (파랑 = 원재료x12)
Purple = 72x White Mats (보라 = 원재료x72)

사용 예시 :
|cff0072bc[주석 모래]|r 100개 (120,000골드로 하려면)
가격/낱개별 = 1,200
가격/낱개별/원재료 = 100]=],
	TOOLS_DAY_ABV = "일",
	TOOLS_GOLD_BASED = "골드로 판매되는 경매 아이템에서 <SCANNED> 검색된 것을 기준으로 합니다.",
	TOOLS_HOUR_ABV = "시간",
	TOOLS_ITEM_NOT_FOUND = "기록을 찾을 수 없습니다. : |cffffffff",
	TOOLS_MIN_ABV = "분",
	TOOLS_NO_HISTORY_DATA = "데이터가 없습니다.",
	TOOLS_POWERED_BY = "(powered by Advanced AuctionHouse)",
	TOOLS_PRICE_HISTORY = "가격 기록",
	TOOLS_UNKNOWN_COMMAND = [=[알 수 없는 명령어입니다. 명령어는 : 
|cffffffff/aah numhistory <max history entries to save per item>|r
|cffffffff/aah clear <item>|r
|cffffffff/aah clearall|r
|cffffffff/aah pricehistory|r]=],
}
