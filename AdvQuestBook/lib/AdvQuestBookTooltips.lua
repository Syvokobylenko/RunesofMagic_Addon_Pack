--[[ ä

	Name: Advanced Questbook
	By: Crypton

]]
function AdvQuestBookIcon_OnDirection(this, itype, direction)
	if (direction == "in") then
		if (AdvQuestBook_Config["iconsettings"][1]["value"]) then
			local text = "";
			local line = "";
			local det;
			local icon = getglobal(this);
			if (itype == "idx" or itype == "fin" or itype == "sha") then
				AdvQuestBook_ClearIcons("items");
				if (itype == "idx") then
					AdvQuestBook_DynIcons(icon.qid);
				end
				text = AdvQuestBookText[icon.qid]["name"];
				if (itype == "fin" and text ~= "") then
					text = text..AdvQuestBookPatterns["AQB_COMPLETE_TEXT"];
				end
				if (AdvQuestBook_Config["iconsettings"][5]["value"]) then
					local qlevel = AdvQuestBookCoords[icon.qid]["info"]["level"];
					local qcolor = AdvQuestBook_LevelTextColor(qlevel);
					line = AdvQuestBook_Messages["AQB_RECLEVEL"].." |cff"..qcolor..qlevel.."+|r";
				end
				if (AdvQuestBook_Config["iconsettings"][4]["value"]) then
					det = AdvQuestBook_ZoneParse(AdvQuestBookText[icon.qid]["det"]);
					det = AdvQuestBook_IDParse(det);
					line = line.."\n\n"..string.gsub(det, "0122ed+", "ffa304");
				end
				if (AdvQuestBook_Config["iconsettings"][6]["value"]) then
					line = line.."\n\n|cffF6FF04"..AdvQuestBook_Messages["AQB_REWARDS"]..":|r\n "..AdvQuestBook_Messages["AQB_XP"]..": "..AdvQuestBookCoords[icon.qid]["info"]["xp"].."\n "..AdvQuestBook_Messages["AQB_TP"]..": "..AdvQuestBookCoords[icon.qid]["info"]["tp"].."\n "..AdvQuestBook_Messages["AQB_GOLD"]..": "..AdvQuestBookCoords[icon.qid]["info"]["gold"];
				end
				if (AdvQuestBook_Config["iconsettings"][7]["value"]) then
					line = line.."\n\n|cffF6FF04"..AdvQuestBook_Messages["AQB_COORDS"]..":|r "..AQB_DecMagic(icon.x, 2)..", "..AQB_DecMagic(icon.y, 2);
				end
			elseif (itype == "inf") then
				text = AdvQuestBook_IDtoName(icon.iid, true);
				if (AdvQuestBook_Config["iconsettings"][7]["value"]) then
					line = AdvQuestBook_Messages["AQB_COORDS"]..": "..AQB_DecMagic(icon.x, 2)..", "..AQB_DecMagic(icon.y, 2);
				end
			elseif (itype == "sno") then
				text = icon.name.." "..AdvQuestBook_Messages["AQB_TRANSPORT"];
				if (AdvQuestBook_Config["iconsettings"][5]["value"]) then
					line = AdvQuestBook_Messages["AQB_RECLEVEL"].." "..icon.level.."+";
				end
				line = line.."\n\n|cffFFFF00"..AdvQuestBook_Messages["AQB_LINKSTO"]..":|r\n"..icon.links;
				if (AdvQuestBook_Config["iconsettings"][7]["value"]) then
					line = line.."\n\n|cffFFFF00"..AdvQuestBook_Messages["AQB_COORDS"]..":|r "..AQB_DecMagic(icon.x, 2)..", "..AQB_DecMagic(icon.y, 2);
				end
			elseif (itype == "ash") then
				text = icon.name;
				line = "\n|cffFFFF00"..AdvQuestBook_Messages["AQB_LINKSTO"]..":|r\n"..icon.links;
				if (AdvQuestBook_Config["iconsettings"][7]["value"]) then
					line = line.."\n\n|cffFFFF00"..AdvQuestBook_Messages["AQB_COORDS"]..":|r "..AQB_DecMagic(icon.x, 2)..", "..AQB_DecMagic(icon.y, 2);
				end
			elseif (itype == "etr" or itype == "note") then
				text = icon.name;
				if (AdvQuestBook_Config["iconsettings"][7]["value"]) then
					line = "\n"..icon.items.."\n\n|cffFFFF00"..AdvQuestBook_Messages["AQB_COORDS"]..":|r "..AQB_DecMagic(icon.x, 2)..", "..AQB_DecMagic(icon.y, 2);
				end
			end
			if (text ~= "") then
				GameTooltip:SetOwner(this, "TOPLEFT" and "ANCHOR_LEFT", -6, 0 or "TOPRIGHT" and "ANCHOR_RIGHT", 0, 6);
				if (itype == "idx" or itype == "fin" or itype == "sha") then
					if (AdvQuestBookCoords[icon.qid]["info"]["daily"]) then
						GameTooltip:SetText("|cff72d2ff"..text.."|r");
					else
						GameTooltip:SetText("|cffFFFF00"..text.."|r");
					end
				else
					GameTooltip:SetText("|cffFFFF00"..text.."|r");
				end
				GameTooltip:AddLine(line);
				AdvQuestBook_Checktooltip();
				GameTooltip:Show();
			end
		end
	else
		if (not AdvQuestBook_Config["iconsettings"][2]["value"]) then
			GameTooltip:Hide();
		end
		if (not AdvQuestBook_Config["iconsettings"][3]["value"]) then
			AdvQuestBook_ClearIcons("items");
		end
	end
end
