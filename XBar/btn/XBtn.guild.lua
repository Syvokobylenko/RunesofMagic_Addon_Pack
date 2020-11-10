local XBar = _G.XBar
local start=1
local max=20
local Guild={["rank"]=NONE}
local function GuildInfo(v)
	if GetNumGuildMembers()==0 then return NONE end
	local name,leader,recruit,_,MaxMember,score,_,_,_,_,_,level=GetGuildInfo()
	if v=="name" then return name end
	if v=="leader" then return leader end
	if v=="recruit" then if recruit then return GUILDBOARD_RECRUIT else return "|cff767676"..GUILDBOARD_NO_RECRUIT.."|r" end end
	if v=="MaxMember" then return MaxMember end
	if v=="score" then return score end
	if v=="level" then return level end
end

function XBar.Guild_OnEvent(this,event,tip)
	if event=="LOADED" and not tip then
		XBar.RegEvent(this, "UPDATE_GUILD_MEMBER", "GNAME%]", "GLVL%]", "GLEADER%]", "ONLINE%]", "MEMBER%]", "MAX%]", "RANK%]", "GOLD%]", "RUBY%]", "ORE%]", "WOOD%]", "HERB%]", "RUNE%]", "STONE%]")
		XBar.RegEvent(this, "GUILDHOUSEWAR_INFOS_UPDATE", "REC%]", "POINT%]", "WAR%]")
		GuildHousesWar_OpenMenu()
	end
	if event=="GUILDHOUSEWAR_INFOS_UPDATE" or event=="LOADED" then
		Guild["war"] = GetGuildInfo() and GuildHousesWar_GetInfo() or NONE
		if GetGuildInfo() then
			local index = GuildHousesWar_MyRegisterInfo()
			if index>0 and Guild["war"]~="Disable" then
				local _, _, _, _, _, _, _, state = GuildHousesWar_GetRegisterInfo(index)
				Guild["war"] = state
				if Guild["war"]=="Fight" and GuildHousesWar_IsInBattleGround() then
					Guild["war"] = "Fighting"
				end
			end
			local _, state = GuildHousesWar_GetRegisterCount()
			if state==0 then
				Guild["war"] = XBar.Lng["Ttip"]["Prepare"]
			elseif state==2 then
				Guild["war"] = XBar.Lng["Ttip"]["FightEnd"]
			else
				Guild["war"] = XBar.Lng["Ttip"][Guild["war"]] or NONE
			end
		end
	end
	if event=="UPDATE_GUILD_MEMBER" or event=="LOADED" then
		local rank = XBar.Guild_Roster(UnitName("player"))
		if rank then Guild["rank"] = rank.." - "..GF_GetRankStr(rank) end
		for i = 1, 7 do
			Guild[i]=XBar.Dec(GCB_GetGuildResource(i))
		end
	end
-- Output
	if not tip and GuildInfo("name") ~=nil then
		local usrtxt={[1]=XBSet["GuildV1"],[2]=XBSet["GuildV2"]}
		local output=""
		for i=1,2 do
			usrtxt[i],_=string.gsub(usrtxt[i],"%[GNAME%]",GuildInfo("name"))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[GLVL%]",GuildInfo("level"))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[GLEADER%]",GuildInfo("leader"))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[ONLINE%]",XBar.Guild_Roster("online"))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[MEMBER%]",GetNumGuildMembers())
			usrtxt[i],_=string.gsub(usrtxt[i],"%[MAX%]",GuildInfo("MaxMember"))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[REC%]",GuildInfo("recruit"))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[RANK%]",Guild["rank"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[GOLD%]",Guild[1])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[RUBY%]",Guild[2])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[ORE%]",Guild[3])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[WOOD%]",Guild[4])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[HERB%]",Guild[5])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[RUNE%]",Guild[6])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[STONE%]",Guild[7])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[POINT%]",GuildInfo("score"))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[WAR%]",Guild["war"])
		end
		if XBSet["GuildT1"] then output=usrtxt[1] end
		if XBSet["GuildT2"] then
			if XBSet["GuildT1"] then output=output.."\n"..usrtxt[2] else output=usrtxt[2] end
		end
		XBarGuild_F_S:SetText(output)
	end
end

function XBar.Guild_Roster(v)
	local online=0
	for i=1,GetNumGuildMembers() do
		local Name,Rank,MC,ML,SC,SL,_,_,_,_,On,_,Zone=GetGuildRosterInfo(i)
		if v==Name then return Rank,MC,ML,SC,SL,Zone end
		if On then online=online+1 end
	end
	if v=="online" then return online end
end

local function ClassIcon(class)
	if class==TEXT("SYS_CLASSNAME_WARRIOR") then return "Interface/TargetFrame/TargetFrameIcon-Warrior"
	elseif class==TEXT("SYS_CLASSNAME_RANGER") then return "Interface/TargetFrame/TargetFrameIcon-Ranger"
	elseif class==TEXT("SYS_CLASSNAME_THIEF") then return "Interface/TargetFrame/TargetFrameIcon-Thief"
	elseif class==TEXT("SYS_CLASSNAME_MAGE") then return "Interface/TargetFrame/TargetFrameIcon-Mage"
	elseif class==TEXT("SYS_CLASSNAME_AUGUR") then return "Interface/TargetFrame/TargetFrameIcon-Augur"
	elseif class==TEXT("SYS_CLASSNAME_KNIGHT") then return "Interface/TargetFrame/TargetFrameIcon-Knight"
	elseif class==TEXT("SYS_CLASSNAME_WARDEN") then return "Interface/TargetFrame/TargetFrameIcon-Warden"
	elseif class==TEXT("SYS_CLASSNAME_DRUID") then return "Interface/TargetFrame/TargetFrameIcon-Druid"
	elseif class==TEXT("SYS_CLASSNAME_HARPSYN") then return "Interface/TargetFrame/Targetframeicon-Harpsyn"
	elseif class==TEXT("SYS_CLASSNAME_PSYRON") then return "Interface/TargetFrame/TargetFrameIcon-Psyron"
	else return "Interface/TargetFrame/TargetFrameIcon-Runedancer" end
end

local function PopSelect(this,key)
	if key=="LBUTTON" then ChatFrame_SendTell(XBar_PopupMenu.Buttons[this:GetID()].CharName)
	else InviteByName(XBar_PopupMenu.Buttons[this:GetID()].CharName) end
end

local function PopScroll(delta)
	if delta>0 then if start>1 then start=start-1 end end
	if delta<0 then if start<XBar.Guild_Roster("online")-max+1 then start=start+1 end end
	XBar.Guild_OnClick(true)
end

function XBar.Guild_OnClick(wheel)
	local Buttons={}
	local count=0
	for i=1,GetNumGuildMembers() do
		local Name,Rank,MC,ML,SC,SL,_,_,_,_,Online,_,Zone,Note=GetGuildRosterInfo(i)
		if Online then
			count=count+1
			if SC=="" then SC = NONE end
			Rank = Rank.." - "..GF_GetRankStr(Rank)
			Buttons[count]={
				icon=ClassIcon(MC),
				CharName=Name,
				GetText=function() return XBar.ClassColor(MC)..Name.."|r" end,
				GetTooltip=function()
					info=""
					info=info.."|cffFFE855"..CLASS_CHANGE_CLASS1.." :|r "..XBar.ClassColor(MC)..MC.."|r "..ML.."\n"
					info=info.."|cffFFE855"..CLASS_CHANGE_CLASS2.." :|r "..XBar.ClassColor(SC)..SC.."|r "..SL.."\n"
					info=info.."\n"
					info=info.."|cffFFE855"..XBar.Lng["Ttip"]["Loc"].."|r "..Zone.."\n"
					info=info.."|cffFFE855"..C_RANK.." :|r "..Rank.."\n"
					if Note and Note~="" then info=info.."|cff857318"..XBar.Lng["Ttip"]["Note"].."|r |cff767676"..tostring(Note).."|r\n" end
					info=info.."\n"
					info=info.."|cff00B2E5"..XBar.Lng["Ttip"]["LMOUSE_WSP"].."|r\n"
					info=info.."|cff00B2E5"..XBar.Lng["Ttip"]["RMOUSE_INV"].."|r\n"
					info=info.."|cff00B2E5"..XBar.Lng["Ttip"]["SCROLL_ON"].."|r\n"
					return info end,
				OnClick=function(this,key) PopSelect(this,key) end,
				OnScroll=function(delta) PopScroll(delta) end,
			}
		end
	end
	if start>1 then for i=1,start-1 do table.remove(Buttons,1) end end
	while #Buttons>max do table.remove(Buttons) end
	XBar_PopupMenu.Buttons=Buttons
	XBar.PopupMenu_Toggle(XBarGuild,(wheel and 1) or false)
end

function XBar.Guild_OnEnter(this)
	XBar.Guild_OnEvent(XBarGuild,"LOADED",true)
	XBar.TooltipMod(this)
	GameTooltip:SetText(GUILD)
	GameTooltip:AddLine(XBar.Lng["Ttip"]["Guild1"],0,.7,.9)
	if GetGuildInfo() then
		GameTooltip:AddSeparator()
		GameTooltip:AddDoubleLine("|cffFFE855"..OBJ_NAME.."|r","Lv"..GuildInfo("level").." "..GetGuildInfo())
		GameTooltip:AddDoubleLine("|cffFFE855"..TEXT("GUILD_STR_LEADER").."|r",GuildInfo("leader"))
		GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Ttip"]["Guild2"].."|r","|cff8DE668"..XBar.Guild_Roster("online").."|r / "..GetNumGuildMembers().." /|cffE66868 "..GuildInfo("MaxMember").."|r")
		GameTooltip:AddDoubleLine("|cffFFE855"..GUILDBOARD_RECRUIT_TEXT.."|r",GuildInfo("recruit"))
		GameTooltip:AddDoubleLine("|cffFFE855"..C_RANK.."|r",Guild["rank"])
		GameTooltip:AddSeparator()
		GameTooltip:AddDoubleLine("|cffFFE855"..C_GUILDHOUSEWAR_GUILDSCORE.."|r",GuildInfo("score"))
		GameTooltip:AddDoubleLine("|cffFFE855"..SYS_GUILD_RESOURCE_STR_13.."|r",Guild["war"])
		GameTooltip:AddSeparator()
		for i = 1, 7 do
			GameTooltip:AddDoubleLine("|cffFFE855"..TEXT("SYS_GUILD_RESOURCE_STR_"..i).."|r",XBar.Dec(Guild[i]))
		end
	end
end