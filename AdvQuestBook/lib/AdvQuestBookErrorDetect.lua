--[[ ä

	Name: Advanced Questbook
	By: Crypton

]]
AQBDebugErr = false;

function AQBErrorDetect_OnLoad(this)
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("SCRIPT_RUNTIME_ERROR");
end

function AQBErrorDetect_OnEvent(this, event)
	if (event == "VARIABLES_LOADED") then
		AQB_BUGS = {};
	elseif (event == "SCRIPT_RUNTIME_ERROR" and not ABugCatcher) then
		if (string.find(arg1, "%sAdvQuestBook(.+)") or string.find(arg1, "(.+)AQB(.+)")) then
			if (AQB_BUGS == nil) then
				AQB_BUGS = {};
			end
			BugMessageFrame:Hide();
			table.insert(AQB_BUGS, arg1);
			SaveVariables("AQB_BUGS");
			if (AQBDebugErr) then
				DEFAULT_CHAT_FRAME:AddMessage("|cFFffffffAdvQuestBook Error:|r "..arg1);
			end
		end
	end
end
