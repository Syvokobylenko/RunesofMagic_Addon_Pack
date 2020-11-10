local XBar = _G.XBar
local start=1
local max=20
local function FriendGroup(v1,v2)
	local Groups={}
	local count=GetSocalGroupCount("Friend")
	if not count or count==0 then count=0
	else
		for i=1,count do
			local ID,Name,Sort=GetSocalGroupInfo("Friend",i)
			Groups[ID]={["Name"]=Name,["Sort"]=Sort}
		end
	end
	if v1=="COUNT" then return count end
	if v1=="NAME" and count then return Groups[v2]["Name"] end
end

function XBar.Friend_OnEvent(this,event,tip)
	if event=="LOADED" and not tip then
		XBar.RegEvent(this, "RESET_FRIEND", "ONLINE%]", "COUNT%]")
	end
-- Output
	if not tip then
		local usrtxt={[1]=XBSet["FriendV1"],[2]=XBSet["FriendV2"]}
		local output=""
		for i=1,2 do
			usrtxt[i],_=string.gsub(usrtxt[i],"%[ONLINE%]",XBar.Friend_Info("OnlineCount"))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[COUNT%]",XBar.Friend_Info("FriendCount"))
			--usrtxt[i],_=string.gsub(usrtxt[i],"%[GROUPS%]",tostring(FriendGroup("COUNT")))
		end
		if XBSet["FriendT1"] then output=usrtxt[1] end
		if XBSet["FriendT2"] then
			if XBSet["FriendT1"] then output=output.."\n"..usrtxt[2] else output=usrtxt[2] end
		end
		XBarFriend_F_S:SetText(output)
	end
end

function XBar.Friend_Info(v)
	if GetFriendCount("Friend")==0 then return 0 end
	if v=="FriendCount" then return GetFriendCount("Friend") end
	if v=="OnlineCount" then
		local online=0
		for i=1,GetFriendCount("Friend") do
			local _,_,On=GetFriendInfo("Friend",i)
			if On then online=online+1 end
		end
		return online
	end
end

local function FriendIcon(both)
	if both then return "Interface/Icons/Pet_Froster01"
	else return "Interface/Icons/Pet_Froster02" end
	return "Interface/Icons/Item_Mea_011"
end

local function PopSelect(this,key)
	if key=="LBUTTON" then ChatFrame_SendTell(XBar_PopupMenu.Buttons[this:GetID()].CharName)
	else InviteByName(XBar_PopupMenu.Buttons[this:GetID()].CharName) end
end

local function PopScroll(delta)
	if delta>0 then if start>1 then start=start-1 end end
	if delta<0 then if start<XBar.Friend_Info("OnlineCount")-max+1 then start=start+1 end end
	XBar.Friend_OnClick(true)
end

function XBar.Friend_OnClick(wheel)
	local Buttons={}
	local count=0
	for i=1,GetFriendCount("Friend") do
		local Name,GroupID,Online,Friends=GetFriendInfo("Friend",i)
		if Online then
			count=count+1
			local _,MC,ML,SC,SL,Zone=XBar.Guild_Roster(Name)
			local Map, Title, Guild, Main, MainLV, Sub, SubLV = GetFriendDetail(Name)
			MC = MC or Main ML = ML or MainLV SC = SC or Sub SL = SL or SubLV Zone = Zone or Map
			if SC=="" then SC = NONE end
			Buttons[count]={
				icon=FriendIcon(Friends),
				CharName=Name,
				GetText=function() return Name end,
				GetTooltip=function()
					info=""
					info=info.."|cffFFE855"..XBar.Lng["Ttip"]["Friend3"].."|r "..FriendGroup("NAME",GroupID).."\n"
					if MC~=nil then
						info=info.."|cffFFE855"..C_CLASS1.." :|r "..XBar.ClassColor(MC)..MC.."|r ("..ML..")\n"
						info=info.."|cffFFE855"..C_CLASS2.." :|r "..XBar.ClassColor(SC)..SC.."|r ("..SL..")\n"
						info=info.."|cffFFE855"..XBar.Lng["Ttip"]["Loc"].."|r "..Zone.."\n"
					end
					if Guild~=nil and Guild~="" then info=info.."|cffFFE855"..GUILD.." :|r "..Guild.."\n" end
					if Title~=nil and Title~="" then info=info.."|cffFFE855"..C_TITLE.." :|r "..Title.."\n" end
					--info=info.."|cff857318"..XBar.Lng["Ttip"]["Friend5"].."|r "..tostring(DiedOf).."\n"
					--info=info.."|cff857318"..XBar.Lng["Ttip"]["Friend6"].."|r"..tostring(Kills).."\n"
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
	XBar.PopupMenu_Toggle(XBarFriend,(wheel and 1) or false)
end