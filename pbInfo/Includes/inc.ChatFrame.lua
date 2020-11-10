--[[
pbInfo - Includes/inc.ChatFrame.lua
	v0.51-fix
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/-
]]
function pbInfo.ChatFrame.AddMessage(this, message, r, g, b)
-- Info: maybe use AskPlayerInfo() for player information
	if (not pbIsEmpty(message) and type(message) ~= "nil") then
		message = tostring(message);
		if (pbInfoSettings["CHATFRAMEHIDEXPTP"] and
			(message:match(pbInfo.ChatFrame.XPTP[1]) ~= nil or
			 message:match(pbInfo.ChatFrame.XPTP[2]) ~= nil)) then
			return;
		end;
		if (pbInfoSettings["CHATFRAMEHIDEXPTPDEBT"] and
			(message:match(pbInfo.ChatFrame.XPTPDebt[1]) ~= nil or
			 message:match(pbInfo.ChatFrame.XPTPDebt[2]) ~= nil)) then
			return;
		end;
		if (pbInfoSettings["CHATFRAMEHIDEPROGRESS"]) then
			local ctype = message:match(pbInfo.ChatFrame.Progress[1]); -- match craftItemType
			if (ctype) then
				if (pbInfoSettings["CHATFRAMEHIDEPROGRESSGATHER"]) then
					local i = 1;
					-- suppress 21:Mining, 22:Woodcutting, 23:Herbalism progress message
					local _cid, _ctype = GetCraftItemType(i); -- return nil while loading
					while ((type(_cid) == "number") and (type(_ctype) == "string")) do
						if (21 <= _cid and _cid <= 23) then
							if (ctype:match(_ctype)) then
								return;
							end;
						end;
						i = i + 1;
						_cid, _ctype = GetCraftItemType(i);
					end;
				else
					return; -- hide all progress messages
				end;
			end;
		end;
		if (pbInfoSettings["CHATFRAMEFILTERTITLES"]) then
			-- first gsub() remove chat titles with chat hyperlink, you can tweak it.
			-- second gsub() clean up spaces if exist.
			message = message:gsub("^(|Hchat:.-|h).-|h", ""):gsub("^%s+", "");
		end;
		if (pbInfoSettings["CHATFRAMESHOWPLAYERINFO"]) then
			local main, sub = "|cffffffff--|r", "|cffffffff--|r";
			name = message:match("|Hplayer:.-|h%[(.-)%]|h");
			if (not pbIsEmpty(name)) then
				if (type(pbInfo.PlayerDB.Players[pbInfo.RealmName][name]) == "table") then
					local player = pbInfo.PlayerDB.Players[pbInfo.RealmName][name];
					local mColor = (type(pbInfo.Classes[player.mC]) == "table" and pbInfo.Classes[player.mC]["color"]) or "";
					main = pbColor((player.mL < 10 and "0" .. player.mL) or player.mL, mColor);
					if (player.sL > 0 and player.sC ~= "") then
						local sColor = (type(pbInfo.Classes[player.sC]) == "table" and pbInfo.Classes[player.sC]["color"]) or "";
						sub = pbColor((player.sL < 10 and "0" .. player.sL) or player.sL, sColor);
					end;
					message = "[" .. main .. "/" .. sub .. "] " .. message;
				end;
			end;
		end;
		if (pbInfoSettings["TIMESTAMP"]
			and not pbIsEmpty(message)
			and not (pbInfoSettings["TIMESTAMPNOTINCOMBATLOG"]
				and this:GetID() == 2
			)
			and os and os.date
		) then
			message = os.date("[|cffffffff" .. pbInfoSettings["TimeStampFormat"]:gsub(":", "|r:|cffffffff") .. "|r] "):lower() .. message;
		end;
		this:pbInfoChatFrame_OriginalAddMessage(message, r, g, b);
	end;
end;

function pbInfo.ChatFrame.Scripts.OnLoad()
	-- thx to Alleris for the idea!
	-- thx to Kathanis for the fix!
	local newOptions = {{"EMOTE", "Emote"},{"GM", "GM"},{"RAID", "Raid"},{"YELL", "World"},{"LOOT", "Loot"}};
	if (#DEFAULT_CHAT_CHANNEL == 7) then
		for i = 1, #newOptions, 1  do
			DEFAULT_CHAT_CHANNEL[#DEFAULT_CHAT_CHANNEL + 1] = newOptions[i][1];
			_G["MESSAGE_" .. newOptions[i][1]] = newOptions[i][2];
		end;
	end;
end;

ITEM_QUALITY0_DESC = "White";
UnitPopupButtons["ITEM_QUALITY0_DESC"] = { text = ITEM_QUALITY0_DESC };
UnitPopupMenus["LOOT_THRESHOLD"][0] = "ITEM_QUALITY0_DESC";

pbInfo.Hooked.ChatFrame_OnEvent = ChatFrame_OnEvent;
function ChatFrame_OnEvent(this, event)
	if (not this.pbInfoChatFrame_OriginalAddMessage) then
		this.pbInfoChatFrame_OriginalAddMessage = this.AddMessage;
		this.AddMessage = pbInfo.ChatFrame.AddMessage;
	end;
	pbInfo.Hooked.ChatFrame_OnEvent(this, event);
end;