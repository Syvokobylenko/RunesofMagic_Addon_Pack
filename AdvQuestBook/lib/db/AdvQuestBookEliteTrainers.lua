--[[ ä

	Name: Advanced Questbook
	By: Crypton

]]
if (AdvQuestBook_EliteTrainers == nil) then
	AdvQuestBook_EliteTrainers = {
		[2] = {
			[1] = {
				["name"] = TEXT("Sys111614_name") or TEXT("Sys111614_name_plural"),
				["items"] = "|cffFFFF00Level 25:|r\n20,000 "..AdvQuestBook_Messages["AQB_GOLD"].."\n\n"..AQB_CLASSES["AQB_KNIGHT"].." "..AdvQuestBook_Messages["AQB_AND"].." "..AQB_CLASSES["AQB_PRIEST"].." - 15 |cff0072bc["..AQB_ITEM_STRINGS["AQB_LC"].."]|r\n"..AQB_CLASSES["AQB_SCOUT"].." "..AdvQuestBook_Messages["AQB_AND"].." "..AQB_CLASSES["AQB_ROGUE"].." - 15 |cff0072bc["..AQB_ITEM_STRINGS["AQB_IC"].."]|r\n"..AQB_CLASSES["AQB_MAGE"].." "..AdvQuestBook_Messages["AQB_AND"].." "..AQB_CLASSES["AQB_WARRIOR"].." - 15 |cff0072bc["..AQB_ITEM_STRINGS["AQB_TC"].."]|r",
				["x"] = 0.43351477384567,
				["y"] = 0.6645764708519,
			},
		},
		[4] = {
			[1] = {
				["name"] = TEXT("Sys111615_name") or TEXT("Sys111615_name_plural"),
				["items"] = "|cffFFFF00Level 30:|r\n28,000 "..AdvQuestBook_Messages["AQB_GOLD"].."\n\n3 |cff0072bc["..AQB_ITEM_STRINGS["AQB_OL"].."]|r\n3 |cff0072bc["..AQB_ITEM_STRINGS["AQB_CN"].."]|r\n3 |cff0072bc["..AQB_ITEM_STRINGS["AQB_MSAP"].."]|r",
				["x"] = 0.55227172374725,
				["y"] = 0.66024005413055,
			},
			[2] = {
				["name"] = TEXT("Sys111616_name") or TEXT("Sys111616_name_plural"),
				["items"] = "|cffFFFF00Level 35:|r\n35,000 "..AdvQuestBook_Messages["AQB_GOLD"].."\n\n"..AQB_CLASSES["AQB_KNIGHT"].." "..AdvQuestBook_Messages["AQB_AND"].." "..AQB_CLASSES["AQB_PRIEST"].." - 15 |cff0072bc["..AQB_ITEM_STRINGS["AQB_ASE"].."]|r\n"..AQB_CLASSES["AQB_SCOUT"].." "..AdvQuestBook_Messages["AQB_AND"].." "..AQB_CLASSES["AQB_ROGUE"].." - 15 |cff0072bc["..AQB_ITEM_STRINGS["AQB_SE"].."]|r\n"..AQB_CLASSES["AQB_MAGE"].." "..AdvQuestBook_Messages["AQB_AND"].." "..AQB_CLASSES["AQB_WARRIOR"].." - 15 |cff0072bc["..AQB_ITEM_STRINGS["AQB_ME"].."]|r",
				["x"] = 0.6266096830368,
				["y"] = 0.86356127262115,
			},
		},
		[10000] = {
			[1] = {
				["name"] = TEXT("Sys111454_name") or TEXT("Sys111454_name_plural"),
				["items"] = "|cffFFFF00Level 15:|r\n8,000 "..AdvQuestBook_Messages["AQB_GOLD"].."\n\n3 |cff0072bc["..AQB_ITEM_STRINGS["AQB_AL"].."]|r\n3 |cff0072bc["..AQB_ITEM_STRINGS["AQB_ZN"].."]|r\n3 |cff0072bc["..AQB_ITEM_STRINGS["AQB_MDGS"].."]|r\n\n|cffFFFF00Level 20:|r\n15,000 "..AdvQuestBook_Messages["AQB_GOLD"].."\n\n3 |cff0072bc["..AQB_ITEM_STRINGS["AQB_WL"].."]|r\n3 |cff0072bc["..AQB_ITEM_STRINGS["AQB_TN"].."]|r\n3 |cff0072bc["..AQB_ITEM_STRINGS["AQB_BSAP"].."]|r",
				["x"] = 0.5528512597084,
				["y"] = 0.76271718740463,
			},
			[2] = {
				["name"] = TEXT("Sys113021_name") or TEXT("Sys113021_name_plural"),
				["items"] = "|cffFFFF00Level 50:|r\n\n"..AdvQuestBook_Messages["AQB_L50ET"].."|r",
				["x"] = 0.53489792346954,
				["y"] = 0.76414239406586,
			},
		},
		[10001] = {
			[1] = {
				["name"] = TEXT("Sys111617_name") or TEXT("Sys111617_name_plural"),
				["items"] = "|cffFFFF00Level 40:|r\n42,000 "..AdvQuestBook_Messages["AQB_GOLD"].."\n\n10 |cff0072bc["..AQB_ITEM_STRINGS["AQB_MS"].."]|r\n10 |cff0072bc["..AQB_ITEM_STRINGS["AQB_SOW"].."]|r\n\n|cffFFFF00Level 45:|r\n58,000 "..AdvQuestBook_Messages["AQB_GOLD"].."\n\n20 |cff0072bc["..AQB_ITEM_STRINGS["AQB_HHS"].."]|r",
				["x"] = 0.39602008461952,
				["y"] = 0.29261755943298,
			},
		},
	};
end
