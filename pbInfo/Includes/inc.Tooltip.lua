--[[
pbInfo - Includes/inc.Mouseover.lua
	v0.55-fix
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/
	
	contains changes by Fliewatuet: https://forum.runesofmagic.com/showthread.php?t=180013
]]
function pbInfo.Tooltip.Scripts.OnUpdate() -- thx to dr00gz for the idea and some hints!
	-- update player information
	if (UnitIsPlayer("mouseover") and pbInfoSettings["PLAYERINFO"]) then
		local mC, sC = UnitClass("mouseover");
		local mL, sL = UnitLevel("mouseover");
		pbInfo.Tooltip.getPlayerInfo(UnitName("mouseover"), mC, mL, sC, sL)
	end;
	-- real tooltip stuff
	if (pbInfoSettings["STICKYTOOLTIP"] == true) then
		if ((UnitExists("mouseover") and UnitLevel("mouseover") > 0) or pbInfoSettings["STICKYALLTOOLTIPS"]) then
			if (UnitExists("mouseover")) then
				GameTooltip["cursor"] = false;
			elseif (GameTooltip["cursor"] == false) then
				GameTooltip:Hide();
				GameTooltip["cursor"] = nil;
			end;
			local scale, x, y = GetUIScale(), unpack(pbInfoSettings["GameTooltipPosition"]);
			GameTooltip:ClearAllAnchors();
			GameTooltip:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", x / scale, y / scale);
		end;
	end;
    -------- <add source="fliewatuet" date="25.10.2009">
    -- (re-)adding quest information to GameTooltip, if available
    if (pbInfoSettings["MODIFYTOOLTIP"] and UnitExists("mouseover") and not UnitIsPlayer("mouseover") and not UnitIsMine("mouseover")) then
        local name = UnitName("mouseover");
        GameTooltip:ClearLines();
        GameTooltip:SetText(name, 1, 1, 0);
        local QuestMsg = UnitQuestMsg("mouseover");    
        if (QuestMsg) then
			local newQuestMsg = pbInfo.Tooltip.cleanUpQuestMsg(QuestMsg);
			GameTooltip:AddLine(newQuestMsg, 1, 1, 1);    
        end;
    end;
    -------- </add>
	if ((pbInfoSettings["MODIFYTOOLTIP"] or pbInfoSettings["SHOWMATERIALINFO"]) and UnitExists("mouseover") and UnitLevel("mouseover") > 0) then
		local name = UnitName("mouseover");
		if (pbInfoSettings["MODIFYTOOLTIP"] and (UnitIsPlayer("mouseover") or UnitCanAttack("player", "mouseover") or (pbInfoSettings["ALLNPC"] and type(pbInfo.MatDB[name]) ~= "table"))) then
			-- show detailed information if target is a mob that can attack the player, or if it's a player
			local nameText = name;
			local masterName = UnitMaster("mouseover");
			if (masterName) then
				nameText = string.format(TEXT("TOOLTIP_PET_NAME"), masterName, nameText);
			end;
			local mC, sC = UnitClass("mouseover");
			local mL, sL = UnitLevel("mouseover");
			local sex = UnitSex("mouseover");
			local race = UnitRace("mouseover");
			local health, healthMax, healthRatio = 0, 0, 0;
			local mana, manaMax, manaType = UnitMana("mouseover"), UnitMaxMana("mouseover"), UnitManaType("mouseover");
			local skill, skillMax, skillType = UnitSkill("mouseover"), UnitMaxSkill("mouseover"), UnitSkillType("mouseover");
			local healthText, manaText, skillText, distColor, healthColor = "", "", "", "FFFFFF", "FFFFFF";
			local mouseoverTarget = UnitName("mouseovertarget"); -- local distance = math.ceil(UnitDistance("mouseover")) - 1;
			local questMsg = UnitQuestMsg("mouseover");
			local difficulty, rgb = mL - UnitLevel("player"), {1.0, 1.0, 0.0};
			-- clears GameTooltip, adds elite/boss info and colors name in difficulty colors
			if (sex == 2) then
				nameText = nameText .. "|cffFFFFFF - |cffAAAA00Elite|r";
			elseif (sex > 2) then
				nameText = nameText .. "|cffFFFFFF - |cffFF0000Boss|r";
			end;
			if (UnitCanAttack("player", "mouseover")) then
				local i = 6;
				if (difficulty >= 7) then
					i = 1;
				elseif (difficulty >= 4) then
					i = 2;
				elseif (difficulty >= -3) then
					i = 3;
				elseif (difficulty >= -6) then
					i = 4;
				elseif (difficulty >= -9) then
					i = 5;
				end;
				rgb = {UnitDifficultyColor[i]["r"], UnitDifficultyColor[i]["g"], UnitDifficultyColor[i]["b"]}
			end;
			GameTooltip:ClearLines();
			GameTooltip:SetText(nameText, unpack(rgb));
--[[ Some stuff testing. May be available in upcoming versions.
if (pbInfoSettings["SHOWRELATION"]) then
	local relColor = 4;
	if (UnitCanAttack("mouseover", "player")) then
		if (UnitCanAttack("player","mouseover")) then
			relColor = 1;
		else
			relColor = 2;
		end;
	elseif (UnitCanAttack("player", "mouseover")) then
		relColor = 3;
	elseif (UnitInParty("mouseover")) then
		relColor = 5;
	end;
	GameTooltip:AddLine("... testing relation ...", UnitRelationColor[i]["r"], UnitRelationColor[i]["g"], UnitRelationColor[i]["b"]);
end; ]]

			-- adding class information to GameTooltip
			local mColor = (type(pbInfo.Classes[mC]) == "table" and pbInfo.Classes[mC]["color"]) or ""; -- color the following output for the primary class
			GameTooltip:AddLine(pbColor(mC, mColor) .. " (" .. pbInfo.Locale["Tooltip"]["LVL"] .. " " .. pbColor(mL, mColor) ..  ")", 1.0, 1.0, 1.0);
			if (sL > 0 and sC ~= "") then -- do the same for the secondary class, if available
				local sColor = (type(pbInfo.Classes[sC]) == "table" and pbInfo.Classes[sC]["color"]) or "";
				GameTooltip:AddLine(pbColor(sC, sColor) .. " (" .. pbInfo.Locale["Tooltip"]["LVL"] .. " " .. pbColor(sL, sColor) .. ")", 1.0, 1.0, 1.0);
			end;
			-- adding race information to GameTooltip
			if (race ~= "" and pbInfoSettings["TOOLTIPSHOWRACE"]) then
				GameTooltip:AddLine(race, 1.0, 1.0, 1.0);
			end
			-- adding healthpoint information to GameTooltip
			if (not UnitIsPlayer("mouseover")) then -- calculate or get the current healthpoints for mobs and NPCs
				pbInfo.MobDB.Update("mouseover");
				healthMax = (type(pbInfo.MobDB.Mobs[name]) == "table" and type(pbInfo.MobDB.Mobs[name][mL]) == "table" and type(pbInfo.MobDB.Mobs[name][mL][mC]) == "table" and pbInfo.MobDB.Mobs[name][mL][mC]["healthpoints"]) or 0;
				healthRatio = UnitHealth("mouseover");
				healthText = ((healthMax > 0) and pbAddThousandsSeparator(math.ceil(healthMax * healthRatio / 100)) .. " / " .. pbAddThousandsSeparator(healthMax) .. " (" .. healthRatio .. "%)") or healthRatio .. "%";
				manaText = mana .. "%";
				skillText = skill .. "%";
			else -- players? That's easy .. .
				health = UnitHealth("mouseover");
				healthMax = UnitMaxHealth("mouseover");
				healthRatio = math.ceil(100 * health / healthMax);
				healthText = pbAddThousandsSeparator(health) .. " / " .. pbAddThousandsSeparator(healthMax) .. " (" .. healthRatio .. "%)";
				manaText = pbAddThousandsSeparator(mana) .. " / " .. pbAddThousandsSeparator(manaMax);
				if (manaType == 1) then
					manaText = manaText .. " (" .. math.ceil(100 * mana / manaMax) .. "%)";
				end;
				skillText = skill .. " / " .. skillMax;
				if (skillType == 1) then
					skillText = skillText .. " (" .. math.ceil(100 * skill / skillMax) .. "%)";
				end;
				-- playerinfo like guild and title
				if (pbInfoSettings["TOOLTIPSHOWPLAYERINFO"]) then
					pbInfo.Tooltip.getPlayerInfo(name, mC, mL, sC, sL);
					if (type(pbInfo.PlayerDB.Players[pbInfo.RealmName][name]) == "table") then
						local player = pbInfo.PlayerDB.Players[pbInfo.RealmName][name];
						if (not pbIsEmpty(player["guild"])) then
							GameTooltip:AddLine(pbInfo.Locale["Tooltip"]["GUILD"] .. ": " .. player["guild"], 1.0, 1.0, 1.0);
						end;
						if (not pbIsEmpty(player["title"])) then
							GameTooltip:AddLine(pbInfo.Locale["Tooltip"]["TITLE"] .. ": " .. player["title"], 1.0, 1.0, 1.0);
						end;
						if ((pbInfo.PlayerDB.Players[pbInfo.RealmName][name]["_time"] - 60) < GetTime()) then
							pbInfo.PlayerDB.Players[pbInfo.RealmName][name]["name"] 	= name;
							pbInfo.PlayerDB.Players[pbInfo.RealmName][name]["mC"] 	= mC;
							pbInfo.PlayerDB.Players[pbInfo.RealmName][name]["mL"] 	= mL;
							pbInfo.PlayerDB.Players[pbInfo.RealmName][name]["sC"] 	= sC;
							pbInfo.PlayerDB.Players[pbInfo.RealmName][name]["sL"] 	= sL;
							pbInfo.PlayerDB.Players[pbInfo.RealmName][name]["_time"] = GetTime();
						end;
					end;

				end;
			end;
			if (pbInfoSettings["HEALTHCOLORFADE"] == true) then
				healthColor = HSBtoHEX(math.ceil((healthRatio / 100) * 127.5), 100, 100); -- FYI: local hueBase, saturation, brightness = 127.5, 100, 100;
			else
				if (healthRatio <= 20) then
					healthColor = "FF0000";
				elseif (healthRatio <= 40) then
					healthColor = "FF9900";
				elseif (healthRatio <= 60) then
					healthColor = "FFFF00";
				elseif (healthRatio <= 80) then
					healthColor = "99FF00";
				else
					healthColor = "00FF00";
				end;
			end;
			GameTooltip:AddLine(pbInfo.Locale["Tooltip"]["HP"] .. ": " .. pbColor(healthText, healthColor), 1.0, 1.0, 1.0);
			-- adding mana and skill information to GameTooltip, if available - unfortunately, UnitChangeMana() and UnitChangeSkill() don't work/exist
			if (pbInfoSettings["SHOWMANA"] == true) then
				if (manaMax > 0 and manaType > 0) then
					GameTooltip:AddLine(pbInfo.Locale["Tooltip"]["MANATYPE" .. manaType] .. ": " .. manaText, 1.0, 1.0, 1.0);
				end;
				if (skillMax > 0 and skillType > 0) then
					GameTooltip:AddLine(pbInfo.Locale["Tooltip"]["MANATYPE" .. skillType] .. ": " .. skillText, 1.0, 1.0, 1.0);
				end;
			end;
--[[ UnitDistance always returns 0 since RoM ver. 2.0.0.1811.en
			-- shows the distance to the target in different colors
			if (pbInfoSettings["SHOWDISTANCE"] == true) then
				if (distance > 217) then
					distColor = "FF0000";
				elseif (distance > 200) then
					distColor = "FFFF00";
				elseif (distance > 180) then
					distColor = "00FF00";
				elseif (distance > 150) then
					distColor = "00FFFF";
				end;
				GameTooltip:AddLine(pbInfo.Locale["Tooltip"]["DISTANCE"] .. ": " .. pbColor(distance, distColor), 1.0, 1.0, 1.0);
			end;
]]
            -- crit chance
            local critChanceMsg = nil
            if UnitCanAttack("player", "mouseover") then
                local class = UnitClass("player");
                local abi = 'MELEE_CRITICAL'
                if class == C_RANGER then
                    abi = 'RANGE_CRITICAL'
                elseif class == C_MAGE or class == C_DRUID or class == C_AUGUR then
                    abi = 'MAGIC_CRITICAL'
                end
                local k1,k2 = GetPlayerAbility(abi)
                local k = k1+k2
                local lvl = UnitLevel("player")
                local c = 30*mL+300 -- calculated chance depend of level
                local max = math.max(k,c)
                local chance = ((k-c)/max + 1.0) / 2
                local critChance = chance*100
                critChanceMsg = string.format(C_CRITICAL_PERCENTAGE, critChance)
                GameTooltip:AddLine(critChanceMsg, 1.0, 1.0, 1.0);
            end
			-- shows the target's target
			if (pbInfoSettings["SHOWMOUSEOVERTARGET"] == true and not pbIsEmpty(mouseoverTarget)) then
				GameTooltip:AddLine(pbInfo.Locale["Tooltip"]["TARGET"] .. ": " .. pbColor(mouseoverTarget, "FFFF00"), 1.0, 1.0, 1.0);
			end;
			-- ???
			if (UnitIsMine("mouseover")) then
				local MineMsg, iMineType, iSkillNow, iReqSkill = UnitMineMsg("mouseover");
				if (iSkillNow == 0) then
					GameTooltip:AddLine(MineMsg, 1, 0, 0);	
				else
					GameTooltip:AddLine(MineMsg, 1, 1, 1);	
				end;
				if (iReqSkill > iSkillNow) then
					GameTooltip:AddLine(string.gsub(LUA_GATHER_TIPS_LOWLV, "<POINT>", iReqSkill), 1, 0, 0);
				end;
			end;
			-- vyCardToolTip support
			if (not pbIsEmpty(_G["vyCardToolTip"])) then
				 GameTooltip:AddLine(_G["vyCardToolTip"]);
			end;
            -------- <add source="fliewatuet" date="20.10.2009">
            -- (re-)adding quest information to GameTooltip, if available
            if (not pbIsEmpty(questMsg)) then
				local newQuestMsg = pbInfo.Tooltip.cleanUpQuestMsg(questMsg);
				GameTooltip:AddLine("\n");
				GameTooltip:AddLine(newQuestMsg, 1, 1, 1);    
				--DEFAULT_CHAT_FRAME:AddMessage(questMsg);
            end;
            -------- </add>
		elseif (pbInfoSettings["SHOWMATERIALINFO"] and type(pbInfo.MatDB[name]) == "table") then
			-- show information about the material
			local matLevel, matType, skill = pbInfo.MatDB[name][1], pbInfo.MatDB[name][2], "";
			local playerLevel = GetPlayerCurrentSkillValue(matType);
			if (matType == "LUMBERING") then 
				skill = LIFESKILL_WOOD;
			elseif (matType == "MINING") then
				skill = LIFESKILL_MINING or LIFESKILL_MINE;
			elseif (matType == "HERBLISM") then
				skill = LIFESKILL_HERB;
			end;
			local skillLevel = math.floor(playerLevel);
			local skillProgress = math.floor((playerLevel - skillLevel) * 10000) / 100;
			GameTooltip:ClearLines();
			GameTooltip:SetText(name, 1.0, 1.0, 0.0);
			GameTooltip:AddLine(skill .. ": " .. pbColor(matLevel, ((playerLevel >= matLevel) and "00FF00") or "FF0000"), 1.0, 1.0, 1.0);
			GameTooltip:AddLine(pbInfo.Locale["Tooltip"]["LVL"] .. ": " .. skillLevel .. " - " .. pbInfo.Locale["Tooltip"]["PROGRESS"] .. ": " .. string.format("%0.2f", skillProgress) .. "%", 1.0, 1.0, 1.0);	
			if (pbInfoSettings["MATINFOITEMCOUNT"]) then
				GameTooltip:AddLine("\n", 1.0, 1.0, 1.0);
				local items = pbInfo.MatDB[name][3];
				for i, v in pairs(items) do
					if (not pbIsEmpty(v)) then
						if (type(pbInfo.MatDBitemCount[v]) ~= "table") then
							pbInfo.MatDBitemCount[v] = pbInfo.Tooltip.getItemCount(v);
						end;
						local color = "FFFFFF";
						if (i == 2) then
							color ="00FF00"; -- lime green
						elseif (i == 3) then
							color ="0072BC"; -- dark blue
						elseif (i == 4) then
							color ="C805F8"; -- purple
						end;
						GameTooltip:AddDoubleLine(pbColor(v, color) .. ": ",
							pbInfo.MatDBitemCount[v][1]
							.. ((pbInfoSettings["MATINFOITEMCOUNTBANK"] and " | " .. pbInfo.MatDBitemCount[v][2]) or "")
							.. ((type(pbInfo.MatDBitemCount[v][3]) == "string" and pbInfoSettings["MATINFOITEMCOUNTIV"] and " | " .. pbInfo.MatDBitemCount[v][3]) or "")
						, 1.0, 1.0, 1.0);
--[[						GameTooltip:AddLine(pbColor(v, color) .. ": "
							.. pbInfo.MatDBitemCount[v][1] .. " | " .. pbInfo.MatDBitemCount[v][2]
							.. ((type(pbInfo.MatDBitemCount[v][3]) == "string" and " | " .. pbInfo.MatDBitemCount[v][3]) or "")
						, 1.0, 1.0, 1.0);
]]
					end;
				end;
			end;
		end;
	end;
end;

function pbInfo.Tooltip.getItemCount(name)
	local count = {0, 0, false};
	local itemLink = false;
	if (not pbIsEmpty(name) and type(name) == "string") then
		for	i = 1, 240 do
			local item = {};
			item.texture, item.name, item.count, item.locked = GetGoodsItemInfo(i);
			if (item.name == name and item.count > 0) then
				count[1] = count[1] + item.count;
				if (not itemLink) then
					itemLink = GetBagItemLink(i);
				end;
			end;
		end;
		for	i = 1, 160 do
			local item = {};
			item.texture, item.name, item.count, item.locked = GetBankItemInfo(i);
			if (item.name == name and item.count > 0) then
				count[2] = count[2] + item.count;
				if (not itemLink) then
					itemLink = GetBankItemLink(i);
				end;
			end;
		end;
		if (itemLink and type(IV_GetListOfItems) == "function") then
			count[3] = string.match(IV_GetListOfItems(itemLink), "|c%w%w%w%w%w%w%w%w(%d-) total|r") or 0;
		elseif (type(IV_GetListOfItemsByName) == "function") then
			count[3] = string.match(IV_GetListOfItemsByName(name), "|c%w%w%w%w%w%w%w%w(%d-) total|r") or 0;
		end;
--[[		if (type(g_InventoryViewerTable) == "table"
			and type(g_InventoryViewerTable[pbInfo.Account]) == "table"
			and type(g_InventoryViewerTable[pbInfo.Account][pbInfo.RealmName]) == "table"
		) then
			count[3] = 0;
			for character, tables in pairs(g_InventoryViewerTable[pbInfo.Account][pbInfo.RealmName]) do
				if (type(tables) == "table") then
					for inventory, content in pairs(tables) do
						if (inventory == "Backpack" or inventory == "Bank") then
							for i, item in pairs(content) do
								if (string.match(item.itemLink, "%[(.-)%]") == name) then
									count[3] = count[3] + item.itemCount;
								end;
							end;
						end;
					end;
				end;
			end;
		end; ]]
	end;
	return count;
end;

function pbInfo.Tooltip.getPlayerInfo(name, mC, mL, sC, sL)
	if (type(pbInfo.PlayerDB.Players[pbInfo.RealmName][name]) == "table" and (pbInfo.PlayerDB.Players[pbInfo.RealmName][name]["_time"] + 60) > GetTime()) then -- building new table only every 60sec
		return pbInfo.PlayerDB.Players[pbInfo.RealmName][name];
	end;
	if (pbIsEmpty(mC) or type(pbInfo.Classes[mC]) ~= "table") then mC = -1; else mC = pbInfo.Classes[mC]["index"]; end;
	if (pbIsEmpty(sC) or type(pbInfo.Classes[sC]) ~= "table") then sC = -1; else sC = pbInfo.Classes[sC]["index"]; end;
	if (pbIsEmpty(mL)) then mLm = 0; mLx = 100; else mLm = tonumber(mL); mLx = tonumber(mL); end;
	if (pbIsEmpty(sL)) then sLm = 0; sLx = 100; else sLm = tonumber(sL); sLx = tonumber(sL); end;
	-- will be parsed in pbInfo.PlayerDB.ParseGroupSearch()
	SearchGroupPeople(mC, mLm, mLx, sC, sLm, sLx); -- SearchGroupPeople(mC, mLmin, mLmax, sC, sLmin, sLmax);
	return false;
end;

function pbInfo.Tooltip.Scripts.OnLoad()
	if ((pbInfoSettings["MODIFYTOOLTIP"] == false and pbInfoSettings["SHOWMATERIALINFO"] == false) or pbInfoSettings["ENABLE"] == false) then
		pbInfoTooltipTimer:Hide();
	else
		pbInfoTooltipTimer:Show();
	end;
	local scale, x, y = GetUIScale(), unpack(pbInfoSettings["GameTooltipPosition"]);
	pbInfoTooltipBorder:Hide();	
	pbInfoTooltipBorder:ClearAllAnchors();
	pbInfoTooltipBorder:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", x / scale, y / scale);
	pbInfoTooltipBorder_Title:SetText(		pbInfo.Locale["Config"]["TooltipBorderTitle"]);
	pbInfoTooltipBorder_Text:SetText(		pbInfo.Locale["Config"]["TooltipBorderText"]);
	pbInfoTooltipBorder_CloseButton:SetText(pbInfo.Locale["Config"]["CloseButton"]);
end;

pbInfo.Hooked.OnEnter_MinimapTimeIcon = OnEnter_MinimapTimeIcon;
function OnEnter_MinimapTimeIcon(icon)
	if (os and os.date and pbInfoSettings["SHOWCLOCKTOOLTIP"]) then
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(icon, "ANCHOR_LEFT", 4, 0);
		GameTooltip:SetText(os.date(pbInfoSettings["TimeStampFormat"]):lower());
		-- a copy of the original code:  0-29=morning, 30-119=day, 120-149=dusk, 150-239=night
		local gametime = GetCurrentGameTime();
		local candaratime = UI_MINIMAP_TIME_NIGHT; 
		if (gametime < 30) then
			candaratime = UI_MINIMAP_TIME_MORNING;
		elseif (gametime < 120) then
			candaratime = UI_MINIMAP_TIME_DAYTIME;
		elseif (gametime < 150) then
			candaratime = UI_MINIMAP_TIME_DUSK;
		end;
	--	GameTooltip:AddLine("Candara-Zeit: " .. os.date("%H:%M", (3600 * 5) + (360 * gametime)) .. " (" .. candaratime .. ")");
		GameTooltip:AddLine(pbInfo.Locale["ClockTooltip"]["CNDTIME"] .. ": " .. candaratime);
		GameTooltip:AddLine(pbInfo.Locale["ClockTooltip"]["ONLINE"] .. ": " .. os.date("!%H:%M"));
		GameTooltip:Show();
	else
		pbInfo.Hooked.OnEnter_MinimapTimeIcon(icon);
	end;
end;

-------- <add source="fliewatuet" date="20.10.2009">
--[[ here we will beautify a given QuestMsg, some examples of how they look before:

-- Mob-Tooltips:
    - "Damned Pirates Shabby Fishing Net( 1 / 1 ) Motley Fishing Pole( 0 / 1 ) Rusty Harpoon( 1 / 1 ) Fishy Smelling Rope( 1 / 1 )"
    - "Hidden in the Forest( 0 / 25 )"
    - "Time is Short Part Two Essence of Ice( 28 / 30 ) Essence of Ice( 28 / 30 )" <-- the repeated quest objective is frogsters fault

-- Thingie-Tooltips:
    - "The Blessing of the Wind God Complete the blessing of the God of Wind( 0 / 1 )"
]]
function pbInfo.Tooltip.cleanUpQuestMsg(questMsg)
	local newQuestMsgTable = { };
	local newQuestMsg = "";
	-- split up multiple quests (we get them from the game seperated with \n)
	for qline in string.gmatch(questMsg, "([^\n]+)\n?") do
		newQuestMsg = newQuestMsg .. pbInfo.Tooltip.cleanUpSingleQuestMsg(qline);
	end;
	return newQuestMsg;
end;

function pbInfo.Tooltip.cleanUpSingleQuestMsg(questMsg)
	local RED, GREEN, YELLOW, GRAY = "FF0000", "00FF00", "FFFF00", "DDDDDD";
	local newQuestMsg = "";
	--local p, q, r = string.match(questMsg, "([^(]+)%( (%d+) / (%d+) %)");
	local p = string.match(questMsg, "([^(]+)%(");
	local qRequestLine = "";
	-- if its not in the expected form just use what we get and be done with it
	if (type(p) == "nil") then
		return questMsg;
	end;
	-- We get the first line of every quest like this: "<QuestTitle> <QuestRequest>( x / y )"
	-- That means that we first have to find out, where exactly the QuestTitle ends
	-- and the QuestRequest starts. To do this, we check every quest we have and
	-- see if its title corresponds with the start of our questMsg
	local AQB_TQUESTS = GetNumQuestBookButton_QuestBook();
	local idx, catid, name, track, level, daily;
	local ret1, ret2, qRequest;
	for i = 1, AQB_TQUESTS do
		idx, catid, name, track, level, daily = GetQuestInfo(i);
		-- msg("idx: "..idx.." |name: "..name.." |track: "..track.." |level: "..level);
		ret1, ret2 = string.find(p, name, 1, true);

		-- if we find something, put together the new Quest Message to add to the tooltip
		if (not pbIsEmpty(ret1) and ret1 == 1) then
			--msg("ret1: "..ret1.." ret2: "..ret2);
			newQuestMsg = string.sub(p, ret1, ret2) .. "\n";

			qRequest = string.sub(p, ret2+1);
			qRequestLine = string.sub(questMsg, ret2+1);

			for p in string.gmatch(qRequestLine, "([^)]+%))\n?") do
				newQuestMsg = newQuestMsg .. pbInfo.Tooltip.cleanUpQuestMsgProcessQuestRequest(p);
			end;
		break;
		end;
	end;

	-- in case we did something wrong fall back to the input value
	if (string.len(newQuestMsg) <= 0) then
		local q, r;
		p, q, r = string.match(questMsg, "([^(]+)%( (%d+) / (%d+) %)");
		newQuestMsg = p .. "(" .. q .. "/" .. r .. ")";
	end;

	return newQuestMsg;
end;

function pbInfo.Tooltip.cleanUpQuestMsgProcessQuestRequest(qRequest)
	local RED, GREEN, YELLOW, GRAY = "FF0000", "00FF00", "FFFF00", "DDDDDD";
	local newQuestRequest = "";
	-- first cut away leading and trailing spaces
	qRequest = string.gsub(qRequest, "^%s*(.-)%s*$", "%1");
	--msg("c: "..qRequest);
	-- lets go to work
	local p, q, r = string.match(qRequest, "([^(]+)%( (%d+) / (%d+) %)");
	-- special case: we get something like "( 11 / 25 )", where the text before the number is missing
	q, r = string.match(qRequest, "%( (%d+) / (%d+) %)");
    -- print out a fine colored quest request 
	if (p == nil) then
		p = UnitName("mouseover");
	end;
	if (tonumber(q) >= tonumber(r)) then
		newQuestRequest = pbColor(" - ", GRAY) .. pbColor(p .. ": ", GREEN) .. pbColor(q .. "/" .. r, GREEN);
	else
		newQuestRequest = pbColor(" - ", GRAY) .. pbColor(p .. ": ", GRAY);

		-- color it
		if (tonumber(q) > 0) then
			newQuestRequest = newQuestRequest .. pbColor(q .. "/" .. r, YELLOW);
		else
			newQuestRequest = newQuestRequest .. pbColor(q .. "/" .. r, RED);
		end;
	end;
	return newQuestRequest .. "\n";
end;
-------- </add>