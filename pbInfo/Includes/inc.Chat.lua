--[[
pbInfo - Includes/inc.Chat.lua
	v0.55-fix
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/
]]
-- Teh oldsql way in chat window
function pbInfo.Chat(chatframe)
	if (UnitName("target") ~= nil) then
		local name = UnitName("target");
		local mC, sC = UnitClass("target");
		local mL, sL = UnitLevel("target");
		local health, healthRatio = 0, 0;
		local sub, message = "", "";

		if (not UnitIsPlayer("target")) then
			pbInfo.MobDB.Update("target");
			healthRatio = UnitHealth("target");
			health = (((type(pbInfo.MobDB.Mobs[name]) == "table" and type(pbInfo.MobDB.Mobs[name][mL]) == "table") and type(pbInfo.MobDB.Mobs[name][mL][mC]) == "table") and pbInfo.MobDB.Mobs[name][mL][mC]["healthpoints"]) and math.ceil(pbInfo.MobDB.Mobs[name][mL][mC]["healthpoints"] * healthRatio / 100)) or UnitChangeHealth("target");
		else
			health = UnitHealth("target");
			healthRatio = math.ceil(1000 * UnitHealth("target")/UnitMaxHealth("target")) / 10;
		end;

		if ((UnitInRaid("raid1") or UnitInParty("party1")) and pbIsEmpty(chatframe)) then
			chatframe = "PARTY";
		end;
		if (not pbIsEmpty(chatframe)) then
			if (sL > 0 and sC ~= "") then
				sub = " / " .. sC .. " (" .. sL .. ")";
			end;
			message = "[ " .. name .. " - " .. pbInfo.Locale["Tooltip"]["HP"] .. ": " .. health .. " (" .. healthRatio .. "%) - " .. mC .. " (" .. mL .. ")" .. sub .. " ]";
			
			-- thx to sanix for the idea!
			local frames = {PARTY = true, GUILD = true, ZONE = true, GLOBAL = true};
			local chat = string.upper(chatframe);
			if (frames[chat] == true) then
				SendChatMessage(message, chat);
            else
                SendChatMessage(message, "WHISPER", 0, chatframe);
            end;
		else
			local mColor = (type(pbInfo.Classes[mC]) == "table" and pbInfo.Classes[mC]["color"]) or "";
			if (sL > 0 and not pbIsEmpty(sC)) then
				local sColor = (type(pbInfo.Classes[sC]) == "table" and pbInfo.Classes[sC]["color"]) or "";
				sub = " / " .. pbColor(sC, sColor) .. " (" .. pbColor(sL, sColor) .. ")";
			end;
			message = "[pbInfo]: [ " .. UnitName("target") .. " - " .. pbInfo.Locale["Tooltip"]["HP"] .. ": " .. health .. " (" .. healthRatio .. "%) - " .. pbColor(mC, mColor) .. " (" .. pbColor(mL, mColor) .. ")" .. sub .. " ]";
			DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 1);
		end;
	else
		local message = "[pbInfo]: " .. pbInfo.Locale["Messages"]["NVT"];
		DEFAULT_CHAT_FRAME:AddMessage(message, 1, 1, 1);
	end;
end;

function pbInfo.ChatHandler(ebox, arguments)
	pbInfo.Chat(arguments);
end;
SLASH_pbInfoChat1 = "/mobinfo"; -- thx to gastro19 for the idea!
SlashCmdList["pbInfoChat"] = pbInfo.ChatHandler;