--[[ ä

	Name: Advanced Questbook
	By: Crypton

]]
if (AdvQuestBookPatterns == nil) then
	AdvQuestBookPatterns = {
		["AQB_QUEST_ACCEPT"] = TEXT("QUEST_MSG_GET"),
		["AQB_QUEST_MET"] = TEXT("QUEST_MSG_CONDITION_FINISHED"),
		["AQB_QUEST_ABANDON"] = TEXT("QUEST_MSG_ALREADY_GIVEUP"),
		["AQB_QUEST_UPDATED"] = TEXT("QUEST_MSG_GET_ITEM"),
		["AQB_QUEST_COMPLETE1"] = string.format(" (%s)", TEXT("QUEST_S_REQUEST_COMPLETE")),
		["AQB_QUEST_COMPLETE2"] = TEXT("QUEST_MSG_FINISHED"),
		["AQB_MATCH_AMOUNT1"] = TEXT("QUEST_MSG_GET_ITEM"),
		["AQB_COMPLETE_TEXT"] = string.format(" (%s)", TEXT("QUEST_S_REQUEST_COMPLETE")),
		["PARTY_JOIN"] = TEXT("SYS_ADD_PARTY"),
		["PARTY_YOU_LEFT"] = TEXT("SYS_PARTY_LEAVE"),
		["PARTY_MEMBER_LEAVES"] = TEXT("SYS_PARTY_UNINVITE"),
		["AQB_UPDATE_ITEM1"] = "(.+):%s?",
		["AQB_UPDATE_ITEM2"] = "%s(%d+)/(%d+)",
		["AQB_UPDATE_AMOUNT"] = "(.+):%s(.+)%s",
		["AQB_UPDATE_AMOUNT1"] = "/(%d+)",
		["AQB_UPDATE_AMOUNT2"] = "(%d+)/",
		["PARTY_LBRACKET"] = "%[?",
		["PARTY_RBRACKET"] = "%]?",
		["AQB_PING1"] = "AQB Ping",
		["AQB_PING2"] = "AQB%sPing",
		["AQB_SHARE1"] = "AQB List: ",
		["AQB_SHARE2"] = "AQB%sList:%s",
		["SHARED_CSV"] = "(%d)",
		["COMMA_DELIMIT"] = ",",
	};
end
