XBtnChars={}
local XBar = _G.XBar
local Chars={["mc"]=NONE,["ml"]=0,["tc"]=NONE,["tl"]=0,["CQuest"]=0}
local function Daily()
	local dailyCount, dailyPerDay = Daily_count()
	if dailyCount==dailyPerDay then
		Chars["daily"] = "|cffFFAA00"..dailyCount.."/"..dailyPerDay.."|r"
	else
		Chars["daily"] = dailyCount.."/"..dailyPerDay
	end
end

local function Quest()
	local totalQuest = GetNumQuestBookButton_QuestBook()
	if totalQuest>0 then
		local finishQuest = 0
		for i = 1, totalQuest do
			local _, _, _, _, _, _, _, _, _, Complete = GetQuestInfo(i)
			if Complete then
				finishQuest = finishQuest + 1
			end
		end
		Chars["quest"] = finishQuest.."/"..totalQuest
	else
		Chars["quest"] = NONE
	end
end

function XBar.Class_OnEvent(this,event,tip)
	if event=="LOADED" then
		if not tip then
			XBar.RegEvent(this, "UNIT_LEVEL", "LVL%]")
			XBar.RegEvent(this, "EXCHANGECLASS_SUCCESS", "CLASS%]")
			this:RegisterEvent("CHAT_MSG_SYSTEM")
			XBar.RegEvent(this, "PLAYER_GET_TITLE", "TITLEC%]")
			XBar.RegEvent(this, "PLAYER_TITLE_ID_CHANGED", "TITLE%]")
			XBar.RegEvent(this, "CARDBOOKFRAME_UPDATE", "CARD%]")
			XBar.RegEvent(this, "PLAYER_HONOR_CHANGED", "HONOR%]", "BADGE%]")
			XBar.RegEvent(this, "PLAYER_HONORPOINT_CHANGED", "SPIRIT%]")
			XBar.RegEvent(this, "PLAYER_GOODEVIL_CHANGED", "GOOD%]")
			if Chars["CQuest"]==0 then
				for i = 420034, 426149 do
					if CheckQuest(i)==2 then
						Chars["CQuest"] = Chars["CQuest"] + 1
					end
				end
			end
			if not XBtnChars[UnitName("player")] then
				XBtnChars[UnitName("player")] = NONE
			end
		end
		Quest()
		Daily()
	end
	if event=="EXCHANGECLASS_SUCCESS" or (event=="UNIT_LEVEL" and arg1=="player") or event=="LOADED" then
		local mainC, subC = UnitClass("player")
		local count = GetPlayerNumClasses()
		for i = 1, count do
			local class, _, level = GetPlayerClassInfo(i, true)
			if class~=nil then
				if class==mainC then
					Chars["mc"] = XBar.ClassColor(class)..class.."|r"
					Chars["ml"] = level
				elseif class==subC then
					Chars["sc"] = XBar.ClassColor(class)..class.."|r"
					Chars["sl"] = level
				elseif count==3 then
					Chars["tc"] = XBar.ClassColor(class)..class.."|r"
					Chars["tl"] = level
				end
			end
		end
		if subC=="" or subC==nil then
			Chars["sc"] = NONE
			Chars["sl"] = 0
		end
	end
	if event=="CHAT_MSG_SYSTEM" then
		local regpoint = TEXT("SC_TRANSFER_SAVEHOME_MEG"):gsub("%[$VAR1]", "(.*)")
		if string.find(arg1, TEXT("QUEST_MSG_GET"):format("(.*)"))
		or string.find(arg1, TEXT("QUEST_MSG_CONDITION_FINISHED"):format("(.*)")) then
			Quest()
		elseif string.find(arg1:gsub("%d", "1"), TEXT("QUEST_MSG_DAILYGROUP_COMPLETE"):format("(.*)", 1, "(.*)"))
		or string.find(arg1, TEXT("QUEST_MSG_DAILYGROUP_DONE"):format("(.*)", "(.*)"))
		or string.find(arg1, TEXT("QUEST_MSG_DAILY_COMPLETE"):format("(.*)"))
		or string.find(arg1, TEXT("QUEST_MSG_DAILYRESET")) then
			Daily()
		elseif string.find(arg1, TEXT("QUEST_MSG_FINISHED"):format("(.*)")) then
			Quest()
			Chars["CQuest"] = Chars["CQuest"] + 1
		elseif string.find(arg1, regpoint) then
			XBtnChars[UnitName("player")] = string.match(arg1, regpoint)
		elseif string.find(arg1, TEXT("SC_SETRECORDPOINT")) then
			XBtnChars[UnitName("player")] = GetZoneName()
		end
	end
	if event=="PLAYER_HONOR_CHANGED" or event=="LOADED" then
		Chars["honor"] = XBar.Dec(math.floor(GetPlayerPointInfo(3, 1, " ")))
		Chars["badge"] = XBar.Dec(math.floor(GetPlayerPointInfo(3, 3, " ")))
	end
	if event=="PLAYER_HONORPOINT_CHANGED" or event=="LOADED" then
		Chars["spirit"] = XBar.Dec(GetPlayerMedalCount())
	end
	if event=="PLAYER_TITLE_ID_CHANGED" or event=="LOADED" then
		local ID = GetCurrentTitle()
		if ID==0 then Chars["title"] = NONE end
		if event=="LOADED" then Chars["titleC"] = 0 end
		UpdateTitleInfo()
		for i = 1, GetTitleCount() do
			local tname, tID, tgeted = GetTitleInfoByIndex(i - 1)
			if tgeted then
				if event=="LOADED" then Chars["titleC"] = Chars["titleC"] + 1 end
				if tID==ID then
					Chars["title"] = tname
					if event~="LOADED" then break end
				end
			end
		end
	end
	if event=="PLAYER_GET_TITLE" then
		Chars["titleC"] = Chars["titleC"] + 1
	end
	if event=="CARDBOOKFRAME_UPDATE" or event=="LOADED" then
		local cardMax, cardCount = 0, 0
		for i = 0, 16 do
			local GMax = LuaFunc_GetCardMaxCount(i)
			if GMax~=nil and GMax>0 then
				cardMax = cardMax + GMax
				cardCount = cardCount + LuaFunc_GetCardCount(i)
			end
		end
		Chars["card"] = cardCount.."/"..cardMax
	end
	if event=="PLAYER_GOODEVIL_CHANGED" or event=="LOADED" then
		local value = GetPlayerGoodEvil()
		if value>-0.01 and value<0 then
			value = -0.01
		end
		Chars["good"] = string.format("%.2f", value)
		--GetGoodEvilTypeColor(type)
	end
-- Output
	if not tip then
		local usrtxt={[1]=XBSet["ClassV1"],[2]=XBSet["ClassV2"]}
		local output=""
		for i=1,2 do
			usrtxt[i],_=string.gsub(usrtxt[i],"%[MLVL%]",Chars["ml"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[MCLASS%]",Chars["mc"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[SLVL%]",Chars["sl"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[SCLASS%]",Chars["sc"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TLVL%]",Chars["tl"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TCLASS%]",Chars["tc"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[HONOR%]",Chars["honor"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[SPIRIT%]",Chars["spirit"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[BADGE%]",Chars["badge"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[CARD%]",Chars["card"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TITLE%]",Chars["title"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TITLEC%]",Chars["titleC"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[QUEST%]",Chars["quest"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[DAY%]",Chars["daily"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[CQUEST%]",Chars["CQuest"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[POINT%]",XBtnChars[UnitName("player")] or NONE)
			usrtxt[i],_=string.gsub(usrtxt[i],"%[GOOD%]",Chars["good"])
		end
		if XBSet["ClassT1"] then output=usrtxt[1] end
		if XBSet["ClassT2"] then
			if XBSet["ClassT1"] then output=output.."\n"..usrtxt[2] else output=usrtxt[2] end
		end
		XBarClass_F_S:SetText(output)
	end
end

--Thanks for McBen!
local ItemDailyQuest = DailyNotes and function ()
	local Nyx = LibStub and LibStub("Nyx")
	DailyNotes.item_counts = Nyx.GetBagItemCounts()
	local count = 0
	for _, v in pairs(DailyNotes.DB_Quests) do
		local finished = DailyNotes.GetQuestItems_FromTempTable(v)
		count = count + finished
	end
	return count
end

function XBar.Class_OnEnter(this)
	XBar.Class_OnEvent(XBarClass,"LOADED",true)
	XBar.TooltipMod(this)
	GameTooltip:SetText(CLASS)
	GameTooltip:AddLine(XBar.Lng["Ttip"]["Class1"],0,.7,.9)
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cffFFE855"..CLASS.."|r", Chars["mc"].." "..Chars["ml"].."|r / "..Chars["sc"].." "..Chars["sl"])
	GameTooltip:AddDoubleLine("|cffFFE855"..C_HONOR_POINT.."|r", Chars["honor"])
	GameTooltip:AddDoubleLine("|cffFFE855"..C_HONOR.."|r", Chars["spirit"])
	GameTooltip:AddDoubleLine("|cffFFE855"..SYS_DUELIST_REWARD.."|r", Chars["badge"])
	GameTooltip:AddDoubleLine("|cffFFE855"..UI_TITLE_TYPE_2_3.."|r", Chars["card"])
	GameTooltip:AddDoubleLine("|cffFFE855"..C_TITLE.."|r", Chars["title"])
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Config"]["Count"]:format(C_TITLE).."|r", Chars["titleC"])
	if GetPlayerGoodEvil()~=0 then
		GameTooltip:AddDoubleLine("|cffFFE855"..C_GOODEVIL.."|r", Chars["good"])
	end
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Config"]["Class3"].."|r", Chars["quest"])
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Config"]["Count"]:format(TEXT("Sys546101_name")).."|r", Chars["daily"])
	GameTooltip:AddDoubleLine("|cffFFE855"..BILLBOARD_015.."|r", Chars["CQuest"])
	if DailyNotes then
		GameTooltip:AddDoubleLine("|cff8DE668DN|r |cffFFE855"..DailyNotes.L.DN_F_FINISHED:gsub(":", "").."|r", ItemDailyQuest())
	end
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.UpF(_glossary_00824).."|r", XBtnChars[UnitName("player")])
end