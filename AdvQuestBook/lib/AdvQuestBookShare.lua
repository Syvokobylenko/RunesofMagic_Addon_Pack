--[[ ä

	Name: Advanced Questbook
	By: Crypton

]]
function AdvQuestBook_GetQuests(reply)
	local i;
	local tick = 0;
	local idx, catid, name, track, level, daily;
	local AQB_TOTALQUESTS = GetNumQuestBookButton_QuestBook();
	local AQB_SHARED_LIST = "";
	for i = 1, AQB_TOTALQUESTS do
		idx, catid, name, track, level, daily = GetQuestInfo(i);
		if (not string.match(name, AdvQuestBookPatterns["AQB_QUEST_COMPLETE1"])) then
			if (not AQB_IsEmpty(AdvQuestBookByName[name], true)) then
				if (tick == 8) then
					AQB_FLAG_WHISPER = true;
					SendChatMessage(AdvQuestBookPatterns["AQB_SHARE1"]..AQB_SHARED_LIST, "WHISPER", 0, reply);
					AQB_SHARED_LIST = "";
					AQB_SHARED_LIST = AQB_SHARED_LIST..AdvQuestBookByName[name]..",";
					tick = 0;
				else
					AQB_SHARED_LIST = AQB_SHARED_LIST..AdvQuestBookByName[name]..",";
					tick = tick + 1;
				end
			end
		end
	end
	if (not AQB_IsEmpty(AQB_SHARED_LIST, true)) then
		AQB_FLAG_WHISPER = true;
		SendChatMessage(AdvQuestBookPatterns["AQB_SHARE1"]..AQB_SHARED_LIST, "WHISPER", 0, reply);
	end
	return;
end

function AdvQuestBook_QuestPingRequest()
	AQB_SharedQuests = {};
	SaveVariables("AQB_SharedQuests");
	SendChatMessage(AdvQuestBookPatterns["AQB_PING1"], "PARTY", 0, 0);
	AQB_SENT_PING = true;
	AdvQuestBookMiniMapShareButton:Disable();
end

function AdvQuestBookQuestShare_OnLoad(this)
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("CHAT_MSG_SYSTEM");
	this:RegisterEvent("CHAT_MSG_PARTY");
	this:RegisterEvent("CHAT_MSG_WHISPER");
	this:RegisterEvent("PARTY_MEMBER_CHANGED");
end

function AdvQuestBookQuestShare_OnEvent(this, event, aqbqs1, aqbqs2, aqbqs3, aqbqs4)
	if (event == "VARIABLES_LOADED") then
		if (AQB_IsEmpty(AQB_SharedQuests, true)) then
			AQB_SharedQuests = {};
		end
		SaveVariables("AQB_SharedQuests");
		AQB_CLOSE_MSN_OPEN = false;
		AQB_CLOSE_MSN_POPUP = false;
		AQB_FLAG_WHISPER = false;
		AQB_SENT_PING = false;
		if (AdvQuestBook_Config["settings"][3]["value"]) then
			if (GetNumPartyMembers() > 0) then
				if (not AdvQuestBookMiniMapShareButton:IsVisible()) then
					AdvQuestBookMiniMapShareButton:Show();
				end
			elseif (GetNumPartyMembers() <= 0) then
				AQB_SharedQuests = {};
				SaveVariables("AQB_SharedQuests");
				AQB_LAST_SHARE = 0;
				AQB_SITEM_INDEX = {};
				AQB_SITEM_DATA = {};
				AQB_SOPEN_ITEMS = 0;
			end
		end
	end
	if (not AdvQuestBook_Config["settings"][3]["value"]) then
		if (AdvQuestBookMiniMapShareButton:IsVisible()) then
			AdvQuestBookMiniMapShareButton:Hide();
		end
		return;
	end
	if (event == "CHAT_MSG_PARTY") then
		if (string.find(aqbqs1, AdvQuestBookPatterns["AQB_PING2"])) then
			if (aqbqs4 ~= UnitName("player")) then
				AdvQuestBook_GetQuests(aqbqs4);
				AQB_CLOSE_MSN_OPEN = true;
			elseif (aqbqs4 ~= UnitName("player")) then
				AQB_CLOSE_MSN_POPUP = true;
			end
		end
	elseif (event == "CHAT_MSG_WHISPER") then
		if (string.find(aqbqs1, AdvQuestBookPatterns["AQB_SHARE2"])) then
			AQB_CLOSE_MSN_POPUP = true;
			local inshare = false;
			local pidx;
			local csv = string.gsub(aqbqs1, AdvQuestBookPatterns["AQB_SHARE2"], "");
			local qmatch;
			local playershared = table.getn(AQB_SharedQuests);
			local breakid = 0;
			for pidx = 1, playershared do
				if (not AQB_IsEmpty(AQB_SharedQuests[pidx], true)) then
					if (not AQB_IsEmpty(AQB_SharedQuests[pidx]["name"], true)) then
						if (AQB_SharedQuests[pidx]["name"] == aqbqs4) then
							inshare = true;
							break;
						end
					end
				end
			end
			if (not inshare) then
				local playertable = {
					["name"] = aqbqs4,
					["quests"] = {},
				};
				table.insert(AQB_SharedQuests, playertable);
			end
			playershared = table.getn(AQB_SharedQuests);
			for pidx = 1, playershared do
				if (not AQB_IsEmpty(AQB_SharedQuests[pidx], true)) then
					if (not AQB_IsEmpty(AQB_SharedQuests[pidx]["name"], true)) then
						if (AQB_SharedQuests[pidx]["name"] == aqbqs4) then
							breakid = pidx;
							break;
						end
					end
				end
			end
			if (breakid ~= 0) then
				AdvQuestBook_ConvertCSV(csv, AQB_SharedQuests[breakid]["quests"]);
			end
			AQB_FLAG_WHISPER = true;
			if (AQB_SENT_PING) then
				AQB_SENT_PING = false;
				DEFAULT_CHAT_FRAME:AddMessage(string.format(AdvQuestBook_Messages["AQB_LIST_RECIEVED"], "|cFFffffff"..AQB_ADDON_NAME.."|r"));
				AdvQuestBookMiniMapShareButton:Enable();
			end
		end
	elseif (event == "PARTY_MEMBER_CHANGED") then
		if (AQB_DEBUG_GAMESTRINGS) then
			local evstring = AdvQuestBook_DebugArgs(event, aqbqs1, aqbqs2, aqbqs3, aqbqs4);
			if (evstring ~= nil) then
				table.insert(AQB_DEBUG_LANG_STRINGS[AQB_LOCAL], "EVString: "..evstring);
				SaveVariables("AQB_DEBUG_LANG_STRINGS");
			end
		end
		if (GetNumPartyMembers() > 0) then
			if (not AdvQuestBookMiniMapShareButton:IsVisible()) then
				AdvQuestBookMiniMapShareButton:Show();
			end
		elseif (GetNumPartyMembers() <= 0 and AdvQuestBookMiniMapShareButton:IsVisible()) then
				AdvQuestBookMiniMapShareButton:Hide();
				AQB_SharedQuests = {};
				SaveVariables("AQB_SharedQuests");
				AQB_LAST_SHARE = 0;
				AQB_SITEM_INDEX = {};
				AQB_SITEM_DATA = {};
				AQB_SOPEN_ITEMS = 0;
		end
	elseif (event == "CHAT_MSG_SYSTEM") then
		if (AQB_DEBUG_GAMESTRINGS) then
			local evstring = AdvQuestBook_DebugArgs(event, aqbqs1, aqbqs2, aqbqs3, aqbqs4);
			if (evstring ~= nil) then
				table.insert(AQB_DEBUG_LANG_STRINGS[AQB_LOCAL], "EVString: "..evstring);
				SaveVariables("AQB_DEBUG_LANG_STRINGS");
			end
		end
		if (string.find(aqbqs1, AdvQuestBookPatterns["PARTY_YOU_LEFT"])) then
			AQB_SharedQuests = {};
			SaveVariables("AQB_SharedQuests");
			AQB_LAST_SHARE = 0;
			AQB_SITEM_INDEX = {};
			AQB_SITEM_DATA = {};
			AQB_SOPEN_ITEMS = 0;
		elseif (string.find(aqbqs1, AdvQuestBookPatterns["PARTY_MEMBER_LEAVES"])) then
			local player = string.gsub(aqbqs1, AdvQuestBookPatterns["PARTY_MEMBER_LEAVES"], "");
			player = string.gsub(player, AdvQuestBookPatterns["PARTY_LBRACKET"], "");
			player = string.gsub(player, AdvQuestBookPatterns["PARTY_RBRACKET"], "");
			if (player ~= UnitName("player")) then
				local pidx;
				local breakid = 0;
				local tmptable = AQB_SharedQuests;
				local playershared = table.getn(AQB_SharedQuests);
				local i, v;
				AQB_SharedQuests = {};
				for i, v in pairs(tmptable) do
					if (v["name"] ~= player) then
						table.insert(AQB_SharedQuests, v);
					end
				end
				SaveVariables("AQB_SharedQuests");
			end
		end
	end
end

AQB_CRF_OnEvent = CRF_OnEvent;

function CRF_OnEvent(this, event, arg1, arg2)
	if (AQB_CLOSE_MSN_POPUP and event == "CHAT_MSN_POPUP") then
		AQB_CLOSE_MSN_POPUP = false;
		return;
	elseif (AQB_CLOSE_MSN_OPEN and event == "CHAT_MSN_OPEN") then
		AQB_CLOSE_MSN_OPEN = false
		return;
	else
		AQB_CRF_OnEvent(this, event, arg1, arg2);
	end
end

AQB_ChatFrame_OnEvent = ChatFrame_OnEvent;

function ChatFrame_OnEvent(this, event)
	local chattype = string.sub(event, 10);
	if ((chattype == "WHISPER" or chattype == "WHISPER_INFORM") and string.find(arg1, AdvQuestBookPatterns["AQB_SHARE2"])) then
		return;
	else
		AQB_ChatFrame_OnEvent(this, event);
	end
end

function AdvQuestBookQuestShare_OnUpdate(curtimer)
	AQB_TTW = AQB_TTW - curtimer;
	if (AQB_TTW <= 0) then
		if (not AQB_SharedQuests) then
			AQB_SharedQuests = {};
		end
		local countshare = table.getn(AQB_SharedQuests);
		if (AQB_SENT_PING and countshare <= 0) then
			AQB_SENT_PING = false;
			DEFAULT_CHAT_FRAME:AddMessage("|cFFffffff"..AdvQuestBook_Messages["AQB_NOLIST_RECIEVED"].."|r");
		end
		AQB_TTW = 3;
		AdvQuestBookMiniMapShareButton:Enable();
	end
end
