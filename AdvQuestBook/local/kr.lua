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
AQB_XML_QDTAILS = "퀘스트 상세 정보";
AQB_XML_DESCR = "퀘스트 내용:";
AQB_XML_REWARDS = "보상:";
AQB_XML_DETAILS = "퀘스트 요약:";
AQB_XML_LOCATIONS = "위치:";
AQB_XML_CONFIG = "설정";
AQB_XML_HSECTION = "도움말 섹션";
AQB_XML_OPENHELP = "도움말 열기";
AQB_XML_CLOSEHELP = "도움말 닫기";
AQB_XML_SHARERES = "공유 결과";
AQB_XML_SHOWSHARE = "공유 보기";
AQB_XML_HIDESHARE = "공유 숨기기";
AQB_XML_BACK = "뒤로";
AQB_XML_TYPEKEYWORD = "검색어를 입력하세요";
AQB_XML_SEARCH = "검색";
AQB_XML_SEARCHRES = "검색 결과";
AQB_XML_CONFIG2 = "환경 설정";
AQB_XML_CONFIG3 = "Icon Configuration"; -- New
AQB_XML_RELOADUI1 = "UI새로고침";
AQB_XML_RELOADUI2 = "맵 아이콘이 망가지면 UI새로고침을 실행!!!";
AQB_XML_RELOADUI3 = "AQD는 사용중, UI새로고침은 사용불가.";
AQB_XML_SHTOOLTIPS = "Tooltips"; -- Edited
AQB_XML_STTOOLTIPS = "툴팁 고정";
AQB_XML_STICONS = "아이콘 고정";
AQB_XML_QDONTIPS = "Quest Description"; -- Edited
AQB_XML_RLONTIPS = "Recommended Level"; -- Edited
AQB_XML_REWONTIPS = "Rewards"; -- Edited
AQB_XML_COORDONTIPS = "Coordinates"; -- Edited
AQB_XML_PREINC = "미완료 퀘스트를 유지";
AQB_XML_AQD = "향상된 퀘스트 Dumper";
AQB_XML_QS = "퀘스트 공유";
AQB_XML_TMBTN = "미니 버튼 토글";
--AQB_XML_SAVECLOSE = "저장후 닫기";
--AQB_XML_CLOSECONFIG = "설정 닫기";
AQB_XML_PURGE = "데이터 정리";
AQB_XML_STPORT = "Snoop Transports"; -- Edited
AQB_XML_ETRAIN = "Elite Trainers"; -- Edited
AQB_XML_SHOWSHARED = "Shared Quests"; -- Edited
AQB_XML_SHOWDAILY = "Daily Quests"; -- New
AQB_XML_SHOWQUESTS = "Quests"; -- New
AQB_XML_AIRPORT = "Airships"; -- New
AQB_XML_MSGONDUMP = "퀘스트 덤프시 메세지 표시";
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
	["AQB_AMINFO"] = "게임 내에서 퀘스트의 정보를 검색, 추적, 관리 할 수 있는 다양한 방법을 제공합니다.",
	["AQB_AMNOTFOUND"] = "AddonManager가 발견되지 않았습니다. 이 애드온은 %s 을 사용하는데 매우 유용하며, 이 애드온의 사용을 권장합니다. AddonManager가 설치되어 있지 않은 경우, %s를 입력해서 %s의 패널을 열거나 제공된 버튼을 사용해서 열 수 있습니다.",
	["AQB_ERRFILELOAD"] = "파일을 불러오는중에, 오류가 발생했습니다.",
	["AQB_DFAULTSETLOAD"] = "기본 설정을 불러왔습니다.",
	["AQB_SETSUPDATE"] = "설정을 업데이트 했습니다.",
	["AQB_GET_PQUEST"] = "파티 퀘스트를 얻었습니다.",
	["AQB_SHIFT_RIGHT"] = "Shift + 마우스 오른쪽 버튼을 이용해서 미니맵 버튼을 이동할 수 있습니다.",
	["AQB_RCLICK"] = "마우스 오른쪽 클릭",
	["AQB_MOVE_BTN"] = "마우스 왼쪽 버튼을 이용해서 버튼을 이동할 수 있습니다.",
	["AQB_L50ET"] = "주직업과 부직업의 레벨 45 엘리트 스킬이 있어야 합니다.",
	["AQB_LIST_RECIEVED"] = "공유 퀘스트 목록을 받았습니다. %s을 열고 공유 퀘스트를 확인하세요.",
	["AQB_NOLIST_RECIEVED"] = "공유 퀘스트 데이터가 없습니다.",
	["AQB_RECLEVEL"] = "권장레벨",
	["AQB_UNKNOWNQID"] = "알 수 없는 퀘스트 ID",
	["AQB_COORDS"] = "좌표값",
	["AQB_NEW_QD"] = "새로운 퀘스트를 덤프했습니다: %s.";
	["AQB_CLEARED_DATA"] = "%s개의 퀘스트와 %s개의 저장된 퀘스트를 삭제했습니다.",
	["AQB_CLEANED_ALL"] = "저장된 모든 퀘스트 데이터를 삭제했습니다.",
	["AQB_UPLOAD"] = "게임 종료 후에 %s를 %s에 업로드 하세요.",
	["AQB_MIN_CHARS"] = "최소한 검색어를 %s글자 이상 입력하세요...",
	["AQB_TOOMANY"] = "%s개 이상의 결과를 찾았습니다. 다른 검색어를 이용하여 검색 결과를 줄임으로써, 검색 결과를 쉽게 볼 수 있습니다.",
	["AQB_SEARCHING"] = "%s 검색어를 찾는중입니다. 잠시만 기다려주세요...",
	["AQB_FOUND_RESULTS"] = "%s개의 %s 검색어 결과를 찾았습니다.",
	["AQB_NOTSUB"] = "아직 이 퀘스트를 받지 못했습니다.",
	["AQB_RECLEVEL"] = "권장레벨",
	["AQB_START"] = "시작",
	["AQB_END"] = "종료",
	["AQB_REWARDS"] = "보상",
	["AQB_COORDS"] = "좌표값",
	["AQB_TRANSPORT"] = "텔레포트",
	["AQB_LINKSTO"] = "연결지역",
	["AQB_DUMPED"] = "덤프됨",
	["AQB_GOLD"] = "골드",
	["AQB_XP"] = "경험치",
	["AQB_TP"] = "스킬포인트",
	["AQB_MAP"] = "맵",
	["AQB_AND"] = "그리고",
	["AQB_OPEN"] = "열기",
	["AQB_LOCK"] = "잠금",
	["AQB_UNLOCK"] = "잠금 해제",
	["AQB_QSTATUS0"] = "당신은 이 퀘스트를 완료하지 않았습니다.",
	["AQB_QSTATUS1"] = "현재 당신은 이 퀘스트를 가지고 있습니다.",
	["AQB_QSTATUS2"] = "당신은 이 퀘스트를 완료했습니다.",
};
-- Help topics will be added back later. I need to rewrite them.
