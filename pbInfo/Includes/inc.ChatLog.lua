--[[
pbInfo - Includes/inc.ChatLog.lua
	v0.51-fix
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/
]]

function pbInfo.ChatLog.GetTarget(this)
	local chatType, target;
	_, _, chatType, _, _, _, target, _ = Chat_GetMsnInfo(this:GetID());
	if (chatType == 5) then -- private channel
		target = target..CRG_GetChannelName(this:GetID()); -- e.g. "Channel".."foo"
	end
	-- DEFAULT_CHAT_FRAME:AddMessage("GetTarget: "..target);
	return target;
end;

function pbInfo.ChatLog.Scripts.OnLoad()
	pbInfo.ChatLog.Timer = {};
	pbInfo.ChatLog.DB = {{},{},{},{},{},{},{},{},{},{}};
	pbInfo.ChatLog.Data = {};
end;

function pbInfo.ChatLog.Scripts.OnEvent(this, event, arg1, arg2)
	if (event == "CHAT_MSG_WHISPER") then
		local text, target = arg1, arg2:match("%[(.-)%]");
		-- DEFAULT_CHAT_FRAME:AddMessage("debug: "..event..": "..target..": "..text);
		pbInfo.ChatLog.SaveMessage(target, target, text);
	-- elseif (event == "CHAT_MSG_WHISPER_INFORM") then -- arg1: text, arg2: target link, arg3...arg5 nil
		-- local text, target = arg1, arg2:match("%[(.-)%]");
		-- DEFAULT_CHAT_FRAME:AddMessage("debug: "..event..": "..target..": "..text);
		-- pbInfo.ChatLog.SaveMessage(target, UnitName("player"), text);
	end
end;

function pbInfo.ChatLog.Scripts.OnUpdate()
	local remainingDelays = false;
	for k, v in pairs(pbInfo.ChatLog.Timer) do
		if (type(v) == "table") then
			if (GetTime() >= v[1]) then
				pbInfo.ChatLog.Timer[k] = true;
				pbInfo.ChatLog.ShowHistory(unpack(v[2]));
			else
				remainingDelays = true;
			end;
		end;
	end;
	if (remainingDelays == false) then
		pbInfoChatLogTimer:Hide(); -- hiding frames disables their OnUpdate :).
	end;
end;

function pbInfo.ChatLog.SaveMessage(target, writer, text)
	-- DEFAULT_CHAT_FRAME:AddMessage("debug: ".."SaveMessage: "..tostring(target)..", "..tostring(writer)..", "..tostring(text));
	if (pbIsEmpty(target) or pbIsEmpty(writer) or pbIsEmpty(text)) then return; end;
	if (type(pbInfo.ChatLog.Data[target]) ~= "table") then
		pbInfo.ChatLog.Data[target] = {};
	end;
	table.insert(
		pbInfo.ChatLog.Data[target],
		{
			["time"] = (os and os.time) and os.time() or 0,
			["writer"] = writer,
			-- ["text"] = string.gsub(text, "|c%w%w%w%w%w%w%w%w(.-)|r", "%1");
			["text"] = text;
		}
	);
	table.sort(pbInfo.ChatLog.Data[target], function(a, b) return a["time"] > b["time"] end);
	for k, _ in pairs(pbInfo.ChatLog.Data[target]) do
		if (k > pbInfoSettings["ChatLogMaxLinesPerChat"] + 1) then
			table.remove(pbInfo.ChatLog.Data[target], k);
		end;
	end;
--	TableTools.saveTable(pbInfo.ChatLog.Data["Whispers"], pbInfo.ChatLog.File);
end;

-- show history after the TalkFrame initialized
function pbInfo.ChatLog.ShowHistory(this, target, history)
	local id = this:GetID();
	if (pbInfo.ChatLog.Timer[id] == true and not pbInfo.ChatLog.DB[id]["historyapplied"]) then
		-- DEFAULT_CHAT_FRAME:AddMessage("debug: ".."ShowHistory, "..this:GetName()..", "..target);
		table.sort(history, function(a, b) return a["time"] < b["time"] end);
		local num = #history;
		pbInfo.ChatLog.DB[id]["historyapplied"] = true;
		for k, v in pairs(history) do
			pbInfo.ChatLog.AddMessage(this, v["time"], v["writer"], v["text"], (k < num));
		end;
		pbInfo.ChatLog.Timer[id] = false;
	else
		local _this = this;
		pbInfo.ChatLog.Timer[id] = {GetTime() + 0.2, {_this, target, history}};
		pbInfoChatLogTimer:Show();
	end;
end;

-- AddMessage to TalkFrame with formatting.
function pbInfo.ChatLog.AddMessage(this, timestamp, writer, message, history)
	if (pbIsEmpty(this) or pbIsEmpty(writer) or pbIsEmpty(message)) then return; end;
	local header = writer ..":";
	if (os and os.date) then
		header = "[" .. os.date("%Y-%m-%d " .. pbInfoSettings["TimeStampFormat"], timestamp):lower() .. "] " .. writer ..":";
	end;
	local hr, hg, hb = 0x00, 0xDD, 0xFF; -- for header
	local mr, mg, mb = 0xFF, 0xFF, 0xFF; -- for message
	local alpha = 0xFF;
	if (writer == UnitName("player")) then
		hr, hg, hb = 0xDD, 0xFF, 0x00;
		if (this.info ~= nil) then -- user color setting; change message color
			mr, mg, mb = this.info.r, this.info.g, this.info.b;
		end;
	end;
	if (history) then
		alpha = 0xAA;
	end;
	CRF_MsnWnd_AddMessage(this, header, BSF_RGBA2number(hr, hg, hb, alpha));
	CRF_MsnWnd_AddMessage(this, message, BSF_RGBA2number(mr, mg, mb, alpha));
--	Chat_AddMessage(id, pbColor("[" .. os.date("%Y-%m-%d %H:%M:%S", timestamp) .. "] " .. writer, colors[1], colors[3])  .. ":\n" .. pbColor(message, colors[2], colors[3]), -1);
end;

-- "Hooking" some functions by copying them; sorry for that... :/
--[[
pbInfo.Hooked.ChatEdit_SendText = ChatEdit_SendText;
function ChatEdit_SendText(editBox, addHistory)
	if (editBox.chatType == "WHISPER" and pbInfoSettings["CHATLOG"]) then
--		local chatID = editBox:GetParent():GetParent():GetID();
		local text, buddy = tostring(editBox:GetText()), tostring(editBox.tellTarget);
		if (string.len(string.gsub(text, "%s*(.+)", "%1")) > 0) then
			pbInfo.ChatLog.SaveMessage(buddy, UnitName("player"), text);
		end;
	end;
	pbInfo.Hooked.ChatEdit_SendText(editBox, addHistory);
end;
]]

-- hook for AddMessage and/or SaveMessage
pbInfo.Hooked.CRF_TalkFrame_AddMessage = CRF_TalkFrame_AddMessage;
function CRF_TalkFrame_AddMessage(this, who, msg)
	-- DEFAULT_CHAT_FRAME:AddMessage("debug: ".."CRF_TalkFrame_AddMessage, "..this:GetName().."["..this:GetID().."]"..who..":"..msg);
	local target = pbInfo.ChatLog.GetTarget(this);
	
	if (type(pbInfoSettings) == "table" and pbInfoSettings["CHATLOG"] and type(pbInfo.ChatLog.DB) == "table" and type(pbInfo.ChatLog.DB[this:GetID()]) == "table") then
		if (pbInfoChatLogTimer:IsVisible() == false and pbInfo.ChatLog.DB[this:GetID()]["historyapplied"]) then 
			if (os and os.time) then
				pbInfo.ChatLog.AddMessage(this, os.time(), who, msg);
			else
				pbInfo.ChatLog.AddMessage(this, GetTime(), who, msg); -- using GetTime() for sorting
			end;
		end;
		pbInfo.ChatLog.SaveMessage(target, who, msg);
		return;
	end;
	pbInfo.Hooked.CRF_TalkFrame_AddMessage(this, who, msg);
end;

-- hook for show history flag to false
pbInfo.Hooked.CRF_MsnWnd_OnHide = CRF_MsnWnd_OnHide;
function CRF_MsnWnd_OnHide(this)
	pbInfo.ChatLog.DB[this:GetID()]["historyapplied"] = false;
	return pbInfo.Hooked.CRF_MsnWnd_OnHide(this);
end;

-- hook for show history
pbInfo.Hooked.CRF_MsnWnd_OnShow = CRF_MsnWnd_OnShow;
function CRF_MsnWnd_OnShow(this)
	local target = pbInfo.ChatLog.GetTarget(this);
	pbInfo.Hooked.CRF_MsnWnd_OnShow(this);
	if (type(pbInfo.ChatLog.Data[target]) == "table") then
		pbInfo.ChatLog.ShowHistory(this, target, pbInfo.ChatLog.Data[target]);
	else
		pbInfo.ChatLog.DB[this:GetID()]["historyapplied"] = true;
	end;
end;
