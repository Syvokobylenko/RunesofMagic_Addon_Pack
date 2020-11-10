--############# Variables #############
XBSet = {
	["Bag_X"] = 315,
	["GuildT2"] = false,
	["Ammo"] = false,
	["PingV1"] = "Ping: [MS]",
	["FriendV2"] = "[COUNT]",
	["BagT1"] = true,
	["ClockT1"] = true,
	["PingT2"] = true,
	["DpsT1"] = true,
	["MailV1"] = "[UNREAD]",
	["ClockV1"] = "Time: [TIME24]",
	["PlayedDays"] = 0,
	["Clock_X"] = 920,
	["Dps"] = true,
	["Alpha"] = 0.6,
	["MainMenuFrame"] = true,
	["CraftV2"] = "Wood: [WOODRE]/[WOODXP]%",
	["ClassT1"] = true,
	["Mail"] = true,
	["Craft_X"] = 717,
	["Bag"] = true,
	["AmmoT2"] = false,
	["Class"] = true,
	["Class_X"] = 135,
	["MailT1"] = true,
	["CraftT1"] = false,
	["Guild_X"] = 641,
	["CraftV1"] = "Mine: [MINERE]/[MINEXP]%",
	["EQDmg_C"] = true,
	["Ping"] = true,
	["Money"] = true,
	["Main_X"] = 26,
	["DpsT2"] = true,
	["Money_X"] = 405,
	["Style"] = 2,
	["Position"] = "BOTTOM",
	["MoneyV2"] = "Dias: [DIAS]",
	["Exp_X"] = 195,
	["Guild"] = true,
	["DpsV1"] = "DPS: [DPS]",
	["PlayedMins"] = 291,
	["MoneyV1"] = "Gold: [GOLD]",
	["EquipDameFrame"] = true,
	["ExpT2"] = false,
	["Mail_X"] = 750,
	["ClockT2"] = true,
	["ClockV3"] = "Date: [DATE]",
	["ClassT2"] = true,
	["BagT2"] = true,
	["PlayedHour"] = 0,
	["Ammo_X"] = 780,
	["ClockV2"] = "Time: [TIME12]",
	["Main"] = 4,
	["ExpV2"] = "XP: [PER]%",
	["ExpT1"] = true,
	["Enable"] = true,
	["AmmoV1"] = "[COUNT]",
	["MoneyT1"] = true,
	["ClassV1"] = "[QUEST]",
	["ClockV5"] = "Total: [TOTALONLINE]",
	["MailT2"] = false,
	["GuildV2"] = "[ONLINE]",
	["BagV1"] = "Bag: [USED]/[TOTAL]",
	["MailV2"] = "",
	["Friend"] = true,
	["EQDmg_X"] = -675,
	["GuildT1"] = true,
	["Dps_X"] = 540,
	["ClassV2"] = "[DAY]",
	["Exp"] = true,
	["Clock"] = true,
	["BagV2"] = "Shop: [SUSED]",
	["Ping_X"] = 835,
	["ExpV1"] = "TP: [TP]",
	["AmmoV2"] = "[BAG]",
	["ExperienceFrame"] = true,
	["FriendT1"] = false,
	["CraftT2"] = false,
	["FriendT2"] = false,
	["EQDmg_Y"] = -100,
	["ClockV4"] = "Game: [ONLINE]",
	["PingV2"] = "FPS: [FPS]",
	["PingT1"] = true,
	["DpsV2"] = "DMG: [DMG]",
	["Friend_X"] = 690,
	["GuildV1"] = "[GNAME]",
	["MoneyT2"] = true,
	["FriendV1"] = "[ONLINE]",
	["AmmoT1"] = true,
	["Craft"] = false,
}
local XBar = {
	--version=2.0 --will add
}
_G.XBar = XBar
_G.XBARVERSION=1.75 --will deleted
local pStart=1
local pMax=20
local xwindow
local xdsgn={"Blockz","Black","Tribal","AdPanel","Gloss"}
local def={
	["PlayedDays"]=0,["PlayedHour"]=0,["PlayedMins"]=0,
	["Enable"]=true,["Alpha"]=0.60,["Position"]="BOTTOM",["Style"]=2,["Lng"]=loc,
	["MainMenuFrame"]=true,["ExperienceFrame"]=false,["EquipDameFrame"]=true,
	["Main"]=2,["Main_X"]=26,
	["Ammo"]=false,["Ammo_X"]=780,
		["AmmoT1"]=true,["AmmoV1"]="[COUNT]",
		["AmmoT2"]=false,["AmmoV2"]="[BAG]",
	["Bag"]=true,["Bag_X"]=315,
		["BagT1"]=true,["BagV1"]="Bag: [USED]/[TOTAL]",
		["BagT2"]=true,["BagV2"]="Shop: [SUSED]",
	["Class"]=true,["Class_X"]=135,
		["ClassT1"]=true,["ClassV1"]="[QUEST]",
		["ClassT2"]=true,["ClassV2"]="[DAY]",
	["Clock"]=true,["Clock_X"]=920,
		["ClockT1"]=true,["ClockV1"]="Time: [TIME24]",["ClockV2"]="Time: [TIME12]",["ClockV3"]="Date: [DATE]",
		["ClockT2"]=true,["ClockV4"]="Game: [ONLINE]",["ClockV5"]="Total: [TOTALONLINE]",
	["Craft"]=false,["Craft_X"]=720,
		["CraftT1"]=false,["CraftV1"]="Mine: [MINERE]/[MINEXP]%",
		["CraftT2"]=false,["CraftV2"]="Wood: [WOODRE]/[WOODXP]%",
	["Dps"]=true,["Dps_X"]=540,
		["DpsT1"]=true,["DpsV1"]="DPS: [DPS]",
		["DpsT2"]=true,["DpsV2"]="DMG: [DMG]",
	["Exp"]=true,["Exp_X"]=195,
		["ExpT1"]=true,["ExpV1"]="TP: [TP]",
		["ExpT2"]=true,["ExpV2"]="XP: [PER]%",
	["Friend"]=true,["Friend_X"]=690,
		["FriendT1"]=false,["FriendV1"]="[ONLINE]",
		["FriendT2"]=false,["FriendV2"]="[COUNT]",
	["Guild"]=true,["Guild_X"]=660,
		["GuildT1"]=false,["GuildV1"]="[GNAME]",
		["GuildT2"]=false,["GuildV2"]="[ONLINE]",
	["Mail"]=true,["Mail_X"]=750,
		["MailT1"]=false,["MailV1"]="[UNREAD]",
		["MailT2"]=false,["MailV2"]="",
	["Money"]=true,["Money_X"]=405,
		["MoneyT1"]=true,["MoneyV1"]="Gold: [GOLD]",
		["MoneyT2"]=true,["MoneyV2"]="Dias: [DIAS]",
	["Ping"]=true,["Ping_X"]=835,
		["PingT1"]=true,["PingV1"]="Ping: [MS]",
		["PingT2"]=true,["PingV2"]="FPS: [FPS]",
	["EQDmg_C"]=true,["EQDmg_X"]=-675,["EQDmg_Y"]=-100,
}

local function Print(str, ...)
	DEFAULT_CHAT_FRAME:AddMessage(str:format(...), 1, 1, 1)
end

function XBar.UpF(str)
	return str:sub(1,1):upper()..str:sub(2)
end

XAddons={ --XBar.AM
	btn={"Main","Ammo","Bag","Class","Clock","Craft","Dps","Exp","Friend","Guild","Mail","Money","Ping"},
	gui={{
		name="XBar",children=true,title="XBar",
		type="TopMenu",
		window="XBarCfg_Info",
	},{
		name=GENERAL,title="XBar - "..GENERAL,
		type="SubMenu",
		window="XBarCfg_G",
	},{
		name=TEXT("SYS_EQWEARPOS_09"),title="XButtons - "..TEXT("SYS_EQWEARPOS_09"),
		type="SubMenu",
		window="XBarCfg_B_Ammo",
	},{
		name=BACKPACK,title="XButtons - "..BACKPACK,
		type="SubMenu",
		window="XBarCfg_B_Bag",
	},{
		name=CLASS,title="XButtons - "..CLASS,
		type="SubMenu",
		window="XBarCfg_B_Class",
	},{
		name=TIMEFLAG_STATE,title="XButtons - "..TIMEFLAG_STATE,
		type="SubMenu",
		window="XBarCfg_B_Clock",
	},{
		name=XBar.UpF(_glossary_00858),title="XButtons - "..XBar.UpF(_glossary_00858),
		type="SubMenu",
		window="XBarCfg_B_Craft",
	},{
		name=C_DPS,title="XButtons - "..C_DPS,
		type="SubMenu",
		window="XBarCfg_B_Dps",
	},{
		name=PET_EXPERIENCE,title="XButtons - "..PET_EXPERIENCE,
		type="SubMenu",
		window="XBarCfg_B_Exp",
	},{
		name=C_RELATION_FRIEND,title="XButtons - "..C_RELATION_FRIEND,
		type="SubMenu",
		window="XBarCfg_B_Friend",
	},{
		name=GUILD,title="XButtons - "..GUILD,
		type="SubMenu",
		window="XBarCfg_B_Guild",
	},{
		name=MAIL,title="XButtons - "..MAIL,
		type="SubMenu",
		window="XBarCfg_B_Mail",
	},{
		name=TEXT("SYS_ITEMTYPE_23"),title="XButtons - "..TEXT("SYS_ITEMTYPE_23"),
		type="SubMenu",
		window="XBarCfg_B_Money",
	},{
		name=UI_TITLE_TYPE_3,title="XButtons - "..UI_TITLE_TYPE_3,
		type="SubMenu",
		window="XBarCfg_B_Ping",
	}},
	popup={{
		icon="Interface/Addons/XBar/img/btns/CfgBtn_Normal",
		GetText=function() return "XBar "..XBARVERSION end,
		GetTooltip=function() return "/xb, /xbar" end,
		OnClick=function() XBar.ToggleUI(XAddonMngr) end,
	},{
		icon="Interface/Addons/XBar/Img/Bonus",
		GetText=function() return XBar.Lng["Ttip"]["Bon_Bu1"] end,
		OnClick=function()
			Print(XBar.Lng["X3"]["Msg1"])
			Print(XBar.Lng["X3"]["Msg2"])
			Print(XBar.Lng["X3"]["Msg3"])
			Print(XBar.Lng["X3"]["Msg4"])
			Print(XBar.Lng["X3"]["Msg5"])
			Print(XBar.Lng["X3"]["Msg6"])
			Print(XBar.Lng["X3"]["Msg7"])
			Print(XBar.Lng["X3"]["Msg8"])
			Print(XBar.Lng["X3"]["Msg9"])
			Print(XBar.Lng["X3"]["Msg10"])
		end
	},{
		icon="Interface/Addons/XBar/Img/Bonus",
		GetText=function() return XBar.Lng["Ttip"]["Bon_Bu2"] end,
		OnClick=function()
			GC_OpenWebRadio("http://www.runesdatabase.com/")
			SendChatMessage("XBar III:  << AFK >> ", "SAY")
			SendChatMessage("XBar III:  << AFK >> ", "PARTY")
		end
	},{
		icon="Interface/Addons/XBar/Img/Bonus",
		GetText=function() return XBar.Lng["Ttip"]["Bon_Bu3"] end,
		OnClick=function()
			if XBSet["ThreatInP"]==false then
				XBSet["ThreatInP"] = true
				Print(XBar.Lng["X3"]["InParty"])
			else
				XBSet["ThreatInP"] = false
				Print(XBar.Lng["X3"]["InCombat"])
			end
		end
	},{
		icon="Interface/Addons/XBar/Img/Bonus",
		GetText=function() return C_HIDE.." CastingBar" end,
		OnClick=function()
			if XBSet["HideCast"]==true then
				CastingBarFrame:RegisterEvent("CASTING_START")
				XBSet["HideCast"] = false
				Print("CastingBar "..OBJ_SHOW)
			else
				CastingBarFrame:UnregisterEvent("CASTING_START")
				XBSet["HideCast"] = true
				Print("CastingBar "..C_HIDE)
			end
		end
	},{
		icon="Interface/Addons/XBar/Img/Bonus",
		GetText=function() return XBar.Lng["Ttip"]["Bon_Bu4"] end,
		OnClick=function() XBar.preview() end
	},{
		icon="Interface/Addons/XBar/Img/Bonus",
		GetText=function() return XBar.Lng["Ttip"]["Bon_Bu5"] end,
		OnClick=function() XBar.pet3() end
	},{
		icon="Interface/Addons/XBar/Img/Bonus",
		GetText=function() return XBar.Lng["Ttip"]["Bon_Bu6"] end,
		OnClick=function() XBar.pet2() end
	},{
		icon="Interface/Addons/XBar/Img/Bonus",
		GetText=function() return XBar.Lng["Ttip"]["Bon_Bu7"] end,
		OnClick=function() XBar.pet1() end
	},{
		icon="Interface/Addons/XBar/Img/Bonus",
		GetText=function() return XBar.Lng["Ttip"]["Bon_Bu8"] end,
		OnClick=function() XBar.switch() end
	},{
		icon="Interface/Addons/XBar/Img/Bonus",
		GetText=function() return XBar.Lng["Ttip"]["Bon_Bu9"] end,
		OnClick=function() SlashCmdList.RdSave() end
	},{
		icon="Interface/Addons/XBar/Img/Bonus",
		GetText=function() return XBar.Lng["Ttip"]["Bon_Bu10"] end,
		OnClick=function() SlashCmdList.RdDisband() end
	},{
		icon="Interface/Addons/XBar/Img/Bonus",
		GetText=function() return XBar.Lng["Ttip"]["Bon_Bu11"] end,
		OnClick=function() SlashCmdList.RdInvite() end
	},{
		icon="Interface/Addons/XBar/Img/Bonus",
		GetText=function() return XBar.Lng["Ttip"]["Bon_Bu12"] end,
		OnClick=function() SlashCmdList.RdReload() end
}}}

SLASH_XBAR1="/xbar"
SLASH_XBAR2="/xb"
SlashCmdList["XBAR"]=function(editBox,msg)
	msg=string.lower(msg)
	if msg=="" then
		Print(XBar.Lng["Config"]["help"])
		Print(XBar.Lng["Config"]["toggle_xbar"])
		Print(XBar.Lng["Config"]["toggle_main"])
		Print(XBar.Lng["Config"]["toggle_expf"])
		XBar.ToggleUI(XAddonMngr)
	elseif msg=="on" then ToggleUIFrame(XBarFrame)
	elseif msg=="main" then
		if MainMenuFrame:IsVisible() then MainMenuFrame:Hide() XBSet["MainMenuFrame"]=true
		else MainMenuFrame:Show() XBSet["MainMenuFrame"]=false end
	elseif msg=="exp" then
		if ExperienceFrame:IsVisible() then ExperienceFrame:Hide() XBSet["ExperienceFrame"]=true
		else ExperienceFrame:Show() XBSet["ExperienceFrame"]=false end
	end
end

--############# Events #############
local function BarTexture(ctrl_name,image)
	if _G[ctrl_name] then
		_G[ctrl_name]:SetTexture("Interface/Addons/XBar/Img/Bar/"..xdsgn[XBSet["Style"]].."/"..image)
	end
end

local function MoveVar()
	local w = GetScreenWidth()/1024
	if XBSet["Position"]=="TOP" then
		for i,v in pairs(XAddons.btn) do
			local b = _G["XBar"..v]
			if b then
				BarTexture("XBar"..v.."_BG_T", "Bar_Btn")
				b:ClearAllAnchors()
				b:SetAnchor("LEFT","LEFT","XBarFrame",XBSet[v.."_X"]*w,-2)
			end
		end
	else
		for i,v in pairs(XAddons.btn) do
			local b = _G["XBar"..v]
			if b then
				BarTexture("XBar"..v.."_BG_T", "BarU_Btn")
				b:ClearAllAnchors()
				b:SetAnchor("LEFT","LEFT","XBarFrame",XBSet[v.."_X"]*w,2)
			end
		end
	end
end

local function BarVar()
	if XBSet["Enable"] then
		if not XFrameGUI then
			if XBSet["MainMenuFrame"] then MainMenuFrame:Hide() else MainMenuFrame:Show() end
			if XBSet["ExperienceFrame"] then ExperienceFrame:Hide() else ExperienceFrame:Show() end
		end
		if XBSet["EquipDameFrame"] then
			EquipDameFrame:UnregisterEvent("PLAYER_INVENTORY_CHANGED")
			EquipDameFrame:Hide()
		else
			EquipDameFrame:RegisterEvent("PLAYER_INVENTORY_CHANGED")
		end
		XBarFrame:SetAlpha(XBSet["Alpha"])
		XBarFrame:Show()
		if XBSet["Muted"] then
			XBarSnd_nTex:SetTexture("Interface/Addons/XBar/Img/btns/SndBtn_Muted")
		else
			XBarSnd_nTex:SetTexture("Interface/Addons/XBar/Img/btns/Sndbtn_Normal")
		end
		if XBSet["LowD"] then
			XBarDsp_nTex:SetTexture("Interface/Addons/XBar/Img/btns/DspBtn_Low")
		else
			XBarDsp_nTex:SetTexture("Interface/Addons/XBar/Img/btns/DspBtn_Normal")
		end
		local y = 32
		if XBSet["Style"]==3 then y = 26 end
		MoveVar()
		if XBSet["Position"]=="TOP" then
			XBarFrame:ClearAllAnchors()
			XBarFrame:SetAnchor("TOPLEFT","TOPLEFT","UIParent",0,0)
			XBarFrame:SetAnchor("TOPRIGHT","TOPRIGHT","UIParent",0,0)
			BarTexture("XBarFrame_BgndL", "Bar_BgndL")
			BarTexture("XBarFrame_BgndM", "Bar_BgndM")
			BarTexture("XBarFrame_BgndR", "Bar_BgndR")
			if not XFrameGUI then
				ExperienceFrame:ClearAllAnchors()
				ExperienceFrame:SetAnchor("BOTTOMLEFT","BOTTOMLEFT","UIParent",0,0)
				ExperienceFrame:SetAnchor("BOTTOMRIGHT","BOTTOMRIGHT","UIParent",0,0)
				MainMenuFrame:ClearAllAnchors()
				MainMenuFrame:SetAnchor("BOTTOM","BOTTOM","UIParent",0,0)
				PlayerFrame:ClearAllAnchors()
				PlayerFrame:SetAnchor("TOPLEFT","TOPLEFT","UIParent",0,y)
				TargetFrame:ClearAllAnchors()
				TargetFrame:SetAnchor("TOP","TOP","UIParent",-64,2+y)
				PlayerBuffButton1:ClearAllAnchors()
				PlayerBuffButton1:SetAnchor("TOPRIGHT","TOPRIGHT","UIParent",-200,10+y)
				UnitFrame_party1:ClearAllAnchors()
				UnitFrame_party1:SetAnchor("TOPLEFT","TOPLEFT","UIParent",2,118+y)
			end
			if not XMinimapGUI1 then
				MinimapFrame:ClearAllAnchors()
				MinimapFrame:SetAnchor("TOPRIGHT","TOPRIGHT","UIParent",-12,32+y)
				MinimapFrameBorder:ClearAllAnchors()
				MinimapFrameBorder:SetAnchor("TOPRIGHT","TOPRIGHT","UIParent",0,-1+y)
			end
		else
			XBarFrame:ClearAllAnchors()
			XBarFrame:SetAnchor("BOTTOMLEFT","BOTTOMLEFT","UIParent",0,0)
			XBarFrame:SetAnchor("BOTTOMRIGHT","BOTTOMRIGHT","UIParent",0,0)
			BarTexture("XBarFrame_BgndL", "BarU_BgndL")
			BarTexture("XBarFrame_BgndM", "BarU_BgndM")
			BarTexture("XBarFrame_BgndR", "BarU_BgndR")
			if not XFrameGUI then
				ExperienceFrame:ClearAllAnchors()
				ExperienceFrame:SetAnchor("BOTTOMLEFT","BOTTOMLEFT","UIParent",0,-y)
				ExperienceFrame:SetAnchor("BOTTOMRIGHT","BOTTOMRIGHT","UIParent",0,-y)
				MainMenuFrame:ClearAllAnchors()
				MainMenuFrame:SetAnchor("BOTTOM","BOTTOM","UIParent",0,-y)
				PlayerFrame:ClearAllAnchors()
				PlayerFrame:SetAnchor("TOPLEFT","TOPLEFT","UIParent",0,0)
				TargetFrame:ClearAllAnchors()
				TargetFrame:SetAnchor("TOP","TOP","UIParent",-64,2)
				PlayerBuffButton1:ClearAllAnchors()
				PlayerBuffButton1:SetAnchor("TOPRIGHT","TOPRIGHT","UIParent",-200,10)
				UnitFrame_party1:ClearAllAnchors()
				UnitFrame_party1:SetAnchor("TOPLEFT","TOPLEFT","UIParent",2,118)
			end
			if not XMinimapGUI1 then
				MinimapFrame:ClearAllAnchors()
				MinimapFrame:SetAnchor("TOPRIGHT","TOPRIGHT","UIParent",-12,32)
				MinimapFrameBorder:ClearAllAnchors()
				MinimapFrameBorder:SetAnchor("TOPRIGHT","TOPRIGHT","UIParent",0,-1)
			end
		end
		if XBSet["Main"]==4 then
			XBarMain:Show() XBarMenu:Show() XBarDsp:Show() XBarSnd:Show()
		elseif XBSet["Main"]==0 then
			XBarMain:Hide() XBarMenu:Hide() XBarDsp:Hide() XBarSnd:Hide()
		else
			XBarMain:Show() XBarMenu:Show() XBarDsp:Hide() XBarSnd:Hide()
		end
		for i,v in pairs(XAddons.btn) do
			local b = _G["XBar"..v]
			if b and i~=1 then if XBSet[v]==false then b:Hide() _G["XBar"..v.."_BG"]:Hide()
			else b:Show() _G["XBar"..v.."_BG"]:Show() end end
		end
	else
		MainMenuFrame:Show() ExperienceFrame:Show()
		XBarFrame:Hide() XBarMain:Hide()
		XBarMenu:Hide() XBarDsp:Hide() XBarSnd:Hide()
		for i,v in pairs(XAddons.btn) do local b = _G["XBar"..v] if b and i~=1 then b:Hide() _G["XBar"..v.."_BG"]:Hide() end end
	end
end

local function RimEvent()
	if XBSet["Dps"] then
		XBarFrame:RegisterEvent("PLAYER_INVENTORY_CHANGED")
	else
		XBarFrame:UnregisterEvent("PLAYER_INVENTORY_CHANGED")
	end
end

function XBar.OnEvent(event)
	if event=="VARIABLES_LOADED" then
		local lang = GetLanguage():upper()
		local _, err = loadfile("Interface/AddOns/XBar/Lng/"..lang..".lua")
		if err then
			Print("|cff993333BXBar can't find translation, ENUS.lua loaded.|r")
			dofile("Interface/AddOns/XBar/Lng/ENUS.lua")
		else
			dofile("Interface/AddOns/XBar/Lng/"..lang..".lua")
		end
		for k,v in pairs(def) do if XBSet[k]==nil then XBSet[k]=v end end
		BarVar()
		Print("%s%s%s", XBar.Lng["Config"]["loaded1"], XBARVERSION, XBar.Lng["Config"]["loaded2"])
		UIDropDownMenu_SetWidth(XBarCfg_G_Style,200)
		UIDropDownMenu_Initialize(XBarCfg_G_Style,XBar.BarDesign_OnShow)
		UIDropDownMenu_SetSelectedID(XBarCfg_G_Style,XBSet["Style"])
		RimEvent()
	end
	if event=="SCREEN_RESIZE" then
		MoveVar()
	end
	if event=="PLAYER_INVENTORY_CHANGED" or event=="VARIABLES_LOADED" then
		local curD, maxD
		XBarDps_BD:Hide()
		for i = 0, 21 do
			curD, maxD = GetInventoryItemDurable("player", i)
			if maxD~=0 and i~=18 and i~=19 and i~=20 and i~=9 then
				if GetInventoryItemInvalid("player", i) or (math.ceil((curD/maxD)*1000)/10)<50 then
					XBarDps_BD:Show()
					break
				end
			end
		end
	end
end

function XBar.ToggleUI(this)
	PlaySoundByPath("sound/interface/ui_generic_click.mp3")
	if not IsShiftKeyDown() then ToggleUIFrame(this) end
end

function XBar.ToggleBgnd()
	PlaySoundByPath("sound/interface/ui_generic_click.mp3")
	if XBSet["Style"]<#xdsgn then XBSet["Style"]=XBSet["Style"]+1 else XBSet["Style"]=1 end
	UIDropDownMenu_SetSelectedID(XBarCfg_G_Style, XBSet["Style"])
	BarVar()
end

function XBar.RoMMenu(this, key)
	PlaySoundByPath("sound/interface/ui_generic_click.mp3")
	if key=="LBUTTON" then
		XBar_PopupMenu.Buttons={{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-Character",
			GetText=function() return SYSTEM_CHARACTER end,
			OnClick=function() ToggleCharacter("EquipmentFrame") end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-Skill",
			GetText=function() return SYSTEM_SKILL end,
			OnClick=function() ToggleUIFrame(UI_SkillBook) end
			},{
			icon="Interface/MainMenuFrame/Mainpopupbutton-Icon-Title",
			GetText=function() return SYSTEM_TITLE end,
			OnClick=function() ToggleUIFrame(AchievementTitleFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-Quest",
			GetText=function() return SYSTEM_QUEST end,
			OnClick=function() ToggleUIFrame(UI_QuestBook) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-Quild",
			GetText=function() return SYSTEM_GUILD end,
			OnClick=function() ToggleUIFrame(GuildFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-Contacts",
			GetText=function() return SYSTEM_SOCIAL end,
			OnClick=function() ToggleSocialFrame("Friend") end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-Card",
			GetText=function() return SYSTEM_CARDBOOK end,
			OnClick=function() ToggleUIFrame(CardBookFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-Beauty",
			GetText=function() return SYSTEM_BEAUTY end,
			OnClick=function() ToggleUIFrame(BeautyStudioFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-Merchant",
			GetText=function() return SYSTEM_MERCHANT end,
			OnClick=function() ToggleUIFrame(ItemMallFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-InstanceRecord",
			GetText=function() return SYSTEM_INSTANCE_RECORD end,
			OnClick=function() ToggleUIFrame(InstanceRecordFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-SortBoard",
			GetText=function() return SORT_SCOREBOARD_TITLE end,
			OnClick=function() ToggleUIFrame(SortScoreBoard) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-SuitSkill",
			GetText=function() return SUITSKILL_FRAME end,
			OnClick=function() ToggleUIFrame(SkillSuitFrame) end
			},{
			icon="Interface/DrawruneFrame/DrawRuneFrame-Icon",
			GetText=function() return BINDING_NAME_TOGGLEDRAWOUTRUNE end,
			OnClick=function() ToggleUIFrame(DrawRuneFrame) end
			},{
			icon="Interface/Addons/XBar/Img/TB_Button",
			GetText=function() return TB_TITLE end,
			OnClick=function() ToggleUIFrame(TeleportBook) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-Clock",
			GetText=function() return "|cffFFE855"..TIMEFLAG_TITLE end,
			GetTooltip=function() return TIMEFLAG_TIP end,
			OnClick=function() ToggleUIFrame(TimeFlagFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-Bank",
			GetText=function()
				if TimeLet_GetLetTime("BankLet")>=0 then return "|cffCFCF76  "..TIMEFLAG_HANDY_BANK
				else return "  |cff808080"..TIMEFLAG_HANDY_BANK end
			end,
			GetTooltip=function() return TIMEFLAG_HANDY_BANK_TIP end,
			OnClick=function()
				if TimeLet_GetLetTime("BankLet")<0 then StaticPopup_Show("TIMEFLAG_FAIL1") return
				else OpenBank() end
			end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-Auction",
			GetText=function()
				if TimeLet_GetLetTime("AuctionLet")>=0 then return "  |cffFCFC76"..TIMEFLAG_HANDY_AUCTION
				else return "  |cff808080"..TIMEFLAG_HANDY_AUCTION end
			end,
			GetTooltip=function() return TIMEFLAG_HANDY_AUCTION_TIP end,
			OnClick=function()
				if TimeLet_GetLetTime("AuctionLet")<0 then StaticPopup_Show("TIMEFLAG_FAIL1") return
				else OpenAuction() end
			end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-Mail",
			GetText=function()
				if TimeLet_GetLetTime("MailLet")>=0 then return "  |cffFCFC76"..TIMEFLAG_HANDY_MAIL
				else return "  |cff808080"..TIMEFLAG_HANDY_MAIL end
			end,
			GetTooltip=function() return TIMEFLAG_HANDY_MAIL_TIP end,
			OnClick = function()
				if TimeLet_GetLetTime("MailLet")<0 then StaticPopup_Show("TIMEFLAG_FAIL1") return
				else OpenMail() end
			end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return ACCOUNTBAG end,
			OnClick=function() ToggleUIFrame(AccountBagFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return ACCOUNTBOOK_TITLE end,
			OnClick=function() ToggleUIFrame(AccountBookFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return "|cffE66868"..SYSTEM_OPTION end,
			OnClick=function() ToggleGameMenu() end
		}}
		XBar.PopupMenu_Toggle(this)
	elseif key=="RBUTTON" then
		XBar_PopupMenu.Buttons={{
			icon="Interface/PetFrame/PetFrameShow_Normal",
			GetText=function() return PET_FRAME_BUTTON end,
			OnClick=function() ToggleUIFrame(PetFrame) end
			},{
			icon="Interface/PetBookFrame/PetBookbutton",
			GetText=function() return SYSTEM_PETBOOK end,
			OnClick=function() ToggleUIFrame(PetBookFrame) end
			},{
			icon="Interface/PartyBoardFrame/OpenBoardButton_Normal",
			GetText=function() return PARTY_BOARD_TITLE1 end,
			OnClick=function() ToggleUIFrame(PartyBoardFrame) end
			},{
			icon="Interface/Minimap/MinimapButton_BattleGround_Normal",
			GetText=function() return BATTLE_GROUND_NAME end,
			OnClick=function() if GuildHousesWar_IsInBattleGround() then OpenGuildHouseWarPlayerScoreFrame()
			elseif GetBattleGroundType()>0 and GetBattleGroundType()~=350 then OpenBattleGroundPlayerScoreFrame()
			elseif not GuildHousesWar_IsInBattleGround() then ToggleUIFrame(BattleGroundQueueFrame) end end
			},{
			icon="Interface/WorldBattleGround/OpenFrame_normal",
			GetText=function() return WORLD_BATTLE_GROUND_BUTTON end,
			OnClick=function() ToggleUIFrame(WorldBattleGroundFrame) end
			},{
			icon="Interface/Minimap/MinimapButton_NpcTrack_Normal",
			GetText=function() return UI_NPCTRACK_TITLE end,
			OnClick=function() OnClick_MinimapNpcTrackButton() end
			},{
			icon="Interface/Minimap/MinimapButton_QuestTrack_Checked",
			GetText=function() return UI_MINIMAP_QUESTSCHEDULE end,
			OnClick=function() if MinimapFrameQuestTrackButton:IsChecked() then
			MinimapFrameQuestTrackButton:SetChecked(false)
			else MinimapFrameQuestTrackButton:SetChecked(true) end OnClick_QuestTrackButton2(MinimapFrameQuestTrackButton) end
			},{
			icon="Interface/Minimap/MinimapButton_Option_Checked",
			GetText=function() return UI_MINIMAP_OPTION end,
			OnClick=function() ToggleDropDownMenu(MinimapFrameOptionMenu, 1, nil, "cursor" , 0 , 0) end
			},{
			icon="Interface/Minimap/MinimapButton_RestoreUI_Normal",
			GetText=function() return GCF_TEXT_RESTORE end,
			OnClick=function() UIPanelAnchorFrame_ResetAnchorAll() end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return PB_DROPDOWN_MISSION.." "..FOCUSFRAME_OPTION end,
			OnClick=function() ToggleUIFrame(SYS_QuestTrackSetting) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return FOCUSOPTIONFRAME_TITLE end,
			OnClick=function() if FocusOptionFrame:IsVisible() then FocusOptionFrame:Hide()
			else FocusOptionFrame_Open(FocusFrame, g_FocusFrameOption, FocusFrame_OptionsCahngedCallBack) end end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return RAIDFRAME_OPTION_TITLE end,
			OnClick=function() ToggleUIFrame(RaidOptionFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return GAME_MENU_DISPLAYOPTION end,
			OnClick=function() GameMenuFrame.SSFTab = 1 ToggleUIFrame(SYS_Settings_Frame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return GAME_MENU_MUSICOPTION end,
			OnClick=function() GameMenuFrame.SSFTab = 2 ToggleUIFrame(SYS_Settings_Frame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return SSF_TEXT_PAGE3 end,
			OnClick=function() GameMenuFrame.SSFTab = 3 ToggleUIFrame(SYS_Settings_Frame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return GAME_MENU_UIOPTION end,
			OnClick=function() ToggleUIFrame(GameConfigFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return GAME_MENU_KEYBINDING end,
			OnClick=function() ToggleUIFrame(KeyDefineFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return GAME_MENU_MACRO end,
			OnClick=function() ToggleUIFrame(MacroFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return GAME_MENU_PATTERN end,
			OnClick=function() ToggleUIFrame(CoverStringFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return GAME_MENU_TUTORIAL end,
			OnClick=function() ToggleUIFrame(TeachingFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return GAME_MENU_GM_NOTIFICATION end,
			OnClick=function() ToggleUIFrame(GmNotificationFrame) end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return GAME_MENU_WEDGE_REPORT end,
			OnClick=function() SendWedgePointReport() end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-System",
			GetText=function() return XBar.Lng["Ttip"]["Sys_SC1"] end,
			OnClick=function() Logout() end
			},{
			icon="Interface/MainMenuFrame/MainPopupButton-Icon-Close",
			GetText=function() return "|cffE66868"..GAME_MENU_QUIT end,
			OnClick=function() StaticPopup_Show("QUIT") end
		}}
		XBar.PopupMenu_Toggle(this)
	else
		ReloadUI()
	end
end

function XBar.ToggleSound()
	PlaySoundByPath("sound/interface/ui_generic_click.mp3")
	if XBSet["Muted"] then
		SYS_AudioSettings_MasterVolumeSlider:SetValue(XBSet["Muted1"])
		SYS_AudioSettings_MusicVolumeSlider:SetValue(XBSet["Muted2"])
		SYS_AudioSettings_AmbienceVolumeSlider:SetValue(XBSet["Muted3"])
		SYS_AudioSettings_SoundFXVolumeSlider:SetValue(XBSet["Muted4"])
		SYS_AudioSettings_InterfaceSFXVolumeSlider:SetValue(XBSet["Muted5"])
		XBarSnd_nTex:SetTexture("Interface/Addons/XBar/Img/btns/SndBtn_Normal")
		XBSet["Muted"]=nil
	else
		XBSet["Muted1"]=MasterVolumeSlider_GetValue()
		XBSet["Muted2"]=MusicVolumeSlider_GetValue()
		XBSet["Muted3"]=AmbienceVolumeSlider_GetValue()
		XBSet["Muted4"]=SoundFXVolumeSlider_GetValue()
		XBSet["Muted5"]=InterfaceSFXVolumeSlider_GetValue()
		SYS_AudioSettings_MasterVolumeSlider:SetValue(0)
		SYS_AudioSettings_MusicVolumeSlider:SetValue(0)
		SYS_AudioSettings_AmbienceVolumeSlider:SetValue(0)
		SYS_AudioSettings_SoundFXVolumeSlider:SetValue(0)
		SYS_AudioSettings_InterfaceSFXVolumeSlider:SetValue(0)
		XBarSnd_nTex:SetTexture("Interface/Addons/XBar/Img/btns/SndBtn_Muted")
		XBSet["Muted"]=true
	end
	SSF_AudioSettings_OnApply()
end

function XBar.ToggleDisplay()
	PlaySoundByPath("sound/interface/ui_generic_click.mp3")
	if XBSet["LowD"] then
		SYS_DisplaySettings_RTLightMapCheckBox:SetChecked(XBSet["LowD1"])
		SYS_DisplaySettings_TerrainShaderDetailSlider:SetValue(XBSet["LowD2"])
		SYS_DisplaySettings_ShadowDetailSlider:SetValue(XBSet["LowD3"])
		SYS_DisplaySettings_WaterReflectionCheckButton:SetChecked(XBSet["LowD4"])
		SYS_DisplaySettings_WaterRefractionCheckButton:SetChecked(XBSet["LowD5"])
		SYS_DisplaySettings_BloomCheckButton:SetChecked(XBSet["LowD6"])
		SYS_DisplaySettings_PaperdollDetailSlider:SetValue(XBSet["LowD7"])
		SYS_DisplaySettings_ViewDistanceSlider:SetValue(XBSet["LowD8"])
		SYS_DisplaySettings_WorldDetailSlider:SetValue(XBSet["LowD9"])
		SYS_DisplaySettings_SkyDetailSlider:SetValue(XBSet["LowD10"])
		SYS_DisplaySettings_TextureDetailSlider:SetValue(XBSet["LowD11"])
		SYS_DisplaySettings_TerrainTextureDetailSlider:SetValue(XBSet["LowD12"])
		SYS_DisplaySettings_SpecularHighlightCheckButton:SetChecked(XBSet["LowD13"])
		SYS_DisplaySettings_DistortFXCheckButton:SetChecked(XBSet["LowD14"])
		SYS_DisplaySettings_DebaseTextureCheckButton:SetChecked(XBSet["LowD15"])
		SYS_DisplaySettings_HideOtherPlayerEffectCheckButton:SetChecked(XBSet["LowD16"])
		SYS_DisplaySettings_UIScaleCheckButton:SetChecked(XBSet["LowD17"])
		SYS_DisplaySettings_UIScaleSlider:SetValue(XBSet["LowD18"])
		XBarDsp_nTex:SetTexture("Interface/Addons/XBar/Img/btns/DspBtn_Normal")
		XBSet["LowD"]=nil
	else
		XBSet["LowD1"]=RTLightMapCheckBox_IsChecked()
		XBSet["LowD2"]=TerrainShaderDetailSlider_GetValue()
		XBSet["LowD3"]=ShadowDetailSlider_GetValue()
		XBSet["LowD4"]=WaterReflectionCheckButton_IsChecked()
		XBSet["LowD5"]=WaterRefractionCheckButton_IsChecked()
		XBSet["LowD6"]=BloomCheckButton_IsChecked()
		XBSet["LowD7"]=PaperdollDetailSlider_GetValue()
		XBSet["LowD8"]=ViewDistanceSlider_GetValue()
		XBSet["LowD9"]=WorldDetailSlider_GetValue()
		XBSet["LowD10"]=SkyDetailSlider_GetValue()
		XBSet["LowD11"]=TextureDetailSlider_GetValue()
		XBSet["LowD12"]=TerrainTextureDetailSlider_GetValue()
		XBSet["LowD13"]=SpecularHighlightCheckButton_IsChecked()
		XBSet["LowD14"]=DistortFXCheckButton_IsChecked()
		XBSet["LowD15"]=DebaseTextureCheckButton_IsChecked()
		XBSet["LowD16"]=IsHideOtherPlayerEffect()
		XBSet["LowD17"]=UIScaleCheckButton_IsChecked()
		XBSet["LowD18"]=UIScaleSlider_GetValue()
		SYS_DisplaySettings_WorstRadioButton_OnClick()
		XBarDsp_nTex:SetTexture("Interface/Addons/XBar/Img/btns/DspBtn_Low")
		XBSet["LowD"]=true
	end
	SSF_DisplaySettings_OnApply()
end

function XBar.MoveStart(this)
	if IsShiftKeyDown() then this:StartMoving() end
end

function XBar.MoveEnd(this)
	this:StopMovingOrSizing()
	local _, _, _, x = this:GetAnchor()
	XBSet[this:GetName():sub(5).."_X"]=math.ceil(x/(GetScreenWidth()/1024))
	if XBSet["Position"]=="TOP" then
		this:ClearAllAnchors()
		this:SetAnchor("LEFT","LEFT","XBarFrame",x,-2)
	else
		this:ClearAllAnchors()
		this:SetAnchor("LEFT","LEFT","XBarFrame",x,2)
	end
end

function XBar.TooltipMod(this)
	local anc
	if XBSet["Position"]=="TOP" then
		anc = "BOTTOM"
	else
		anc = "TOP"
	end
	if this:GetPos()<GetScreenWidth()/2 then
		GameTooltip:SetOwner(this,"ANCHOR_"..anc.."RIGHT", -28,0)
	else
		GameTooltip:SetOwner(this,"ANCHOR_"..anc.."LEFT", 28,0)
	end
end

function XBar.Dec(value)
	local k
	if not value then return "" end
	while true do
		value, k = string.gsub(value, "^(-?%d+)(%d%d%d)", '%1,%2')
		if k==0 then
			break
		end
	end
	return value
end

function XBar.ClassColor(class)
	local c = "FFFFFF"
	if class==TEXT("SYS_CLASSNAME_WARRIOR") then c = "FF0033"
	elseif class==TEXT("SYS_CLASSNAME_RANGER") then c = "A5D603"
	elseif class==TEXT("SYS_CLASSNAME_THIEF") then c = "00D6C5"
	elseif class==TEXT("SYS_CLASSNAME_MAGE") then c = "FF9100"
	elseif class==TEXT("SYS_CLASSNAME_AUGUR") then c = "288CEC"
	elseif class==TEXT("SYS_CLASSNAME_KNIGHT") then c = "FFFF70"
	elseif class==TEXT("SYS_CLASSNAME_WARDEN") then c = "8B35FF"
	elseif class==TEXT("SYS_CLASSNAME_DRUID") then c = "0CF360"
	elseif class==TEXT("SYS_CLASSNAME_HARPSYN") then c = "BF30E7"
	elseif class==TEXT("SYS_CLASSNAME_PSYRON") then c = "5677DD" end
	return "|cff"..c
end

function XBar.RegEvent(this, event, ...)
	local v = this:GetName():sub(5)
	local reg
	for i = 1, 2 do
		if XBSet[v.."T"..i] then
			for j = 1, #arg do
				if XBSet[v.."V"..i]:find(arg[j]) then
					reg = true
					break
				end
			end
		end
	end
	if reg then
		this:RegisterEvent(event)
	else
		this:UnregisterEvent(event)
	end
end

--############# XBar Configuration #############
function XBar.Cfg_Show()
	if XBSet["Position"]=="TOP" then XBarCfg_G_CB_XE_T:SetChecked(true)
	else XBarCfg_G_CB_XE_B:SetChecked(true) end
	XBarCfg_G_CB_XE:SetChecked(XBSet["Enable"])
	_G["XBarCfg_G_CB_MB_"..XBSet["Main"]]:SetChecked(true)
	XBarCfg_G_CB_EF:SetChecked(XBSet["ExperienceFrame"])
	XBarCfg_G_CB_DF:SetChecked(XBSet["EquipDameFrame"])
	XBarCfg_G_SR_Alpha:SetValue(XBSet["Alpha"])
	for i,v in pairs(XAddons.btn) do
		if i<14 and i~=1 then
			_G["XBarCfg_B_"..v.."_Show"]:SetChecked(XBSet[v])
			_G["XBarCfg_B_"..v.."_Text1"]:SetChecked(XBSet[v.."T1"])
			_G["XBarCfg_B_"..v.."_Text2"]:SetChecked(XBSet[v.."T2"])
			_G["XBarCfg_B_"..v.."_Value1"]:SetText(XBSet[v.."V1"])
			_G["XBarCfg_B_"..v.."_Value2"]:SetText(XBSet[v.."V2"])
			_G["XBarCfg_B_"..v.."_Text1_Text"]:SetText(XBar.Lng["Config"]["Text1"])
			_G["XBarCfg_B_"..v.."_Text2_Text"]:SetText(XBar.Lng["Config"]["Text2"])
			_G["XBarCfg_B_"..v.."_Value1_Text"]:SetText(XBar.Lng["Config"]["Value"])
			_G["XBarCfg_B_"..v.."_Value2_Text"]:SetText(XBar.Lng["Config"]["Value"])
		end
	end
	XBarCfg_B_Clock_Value3:SetText(XBSet["ClockV3"])
	XBarCfg_B_Clock_Value4:SetText(XBSet["ClockV4"])
	XBarCfg_B_Clock_Value5:SetText(XBSet["ClockV5"])
	XBarCfg_Info_Text:SetText(XBar.Lng["Config"]["Info"])
	XBarCfg_G_CB_XE_Text:SetText(XBar.Lng["Config"]["EnableXBar"])
	XBarCfg_G_CB_XE_T_Text:SetText(XBar.Lng["Config"]["Top"])
	XBarCfg_G_CB_XE_B_Text:SetText(XBar.Lng["Config"]["Bottom"])
	XBarCfg_G_CB_MB_4_Text:SetText(XBar.Lng["Config"]["Main4"])
	XBarCfg_G_CB_MB_2_Text:SetText(XBar.Lng["Config"]["Main2"])
	XBarCfg_G_CB_MB_0_Text:SetText(XBar.Lng["Config"]["Main0"])
	XBarCfg_G_Style_Text:SetText(XBar.Lng["Config"]["Style"])
	XBarCfg_G_CB_EF_Text:SetText(XBar.Lng["Config"]["HideOriginalXP"])
	XBarCfg_G_CB_DF_Text:SetText(XBar.Lng["Config"]["HideOriginalED"])
	XBarCfg_B_Clock_Value1_Text:SetText(XBar.Lng["Config"]["ValueL1"])
	XBarCfg_B_Clock_Value2_Text:SetText(XBar.Lng["Config"]["ValueL2"])
	XBarCfg_B_Clock_Value3_Text:SetText(XBar.Lng["Config"]["ValueR"])
	XBarCfg_B_Clock_Value4_Text:SetText(XBar.Lng["Config"]["ValueSL1"])
	XBarCfg_B_Clock_Value5_Text:SetText(XBar.Lng["Config"]["ValueSL2"])
end

function XBar.Cfg_Save()
	if XBarCfg_G_CB_XE_T:IsChecked() then XBSet["Position"]="TOP" else XBSet["Position"]="BOTTOM" end
	XBSet["Enable"]=XBarCfg_G_CB_XE:IsChecked()
	if XBarCfg_G_CB_MB_4:IsChecked() then
		XBSet["Main"] = 4
	elseif XBarCfg_G_CB_MB_0:IsChecked() then
		XBSet["Main"] = 0
	else
		XBSet["Main"] = 2
	end
	XBSet["Style"]=UIDropDownMenu_GetSelectedID(XBarCfg_G_Style)
	XBSet["ExperienceFrame"]=XBarCfg_G_CB_EF:IsChecked()
	XBSet["EquipDameFrame"]=XBarCfg_G_CB_DF:IsChecked()
	for i,v in pairs(XAddons.btn) do
		if i<14 and i~=1 then
			XBSet[v]=_G["XBarCfg_B_"..v.."_Show"]:IsChecked()
			XBSet[v.."T1"]=_G["XBarCfg_B_"..v.."_Text1"]:IsChecked()
			XBSet[v.."T2"]=_G["XBarCfg_B_"..v.."_Text2"]:IsChecked()
			XBSet[v.."V1"]=_G["XBarCfg_B_"..v.."_Value1"]:GetText()
			XBSet[v.."V2"]=_G["XBarCfg_B_"..v.."_Value2"]:GetText()
			if _G["XBar"..v]:IsVisible() then
				if _G.XBar[v.."_OnEvent"] then
					_G.XBar[v.."_OnEvent"](_G["XBar"..v], "LOADED")
				end
			end
		end
	end
	XBSet["ClockV3"]=XBarCfg_B_Clock_Value3:GetText()
	XBSet["ClockV4"]=XBarCfg_B_Clock_Value4:GetText()
	XBSet["ClockV5"]=XBarCfg_B_Clock_Value5:GetText()
	Print(XBar.Lng["Config"]["saved"])
	BarVar()
	RimEvent()
end

function XBar.Default()
	for i,v in pairs(def) do XBSet[i]=v end
	XBar.Cfg_Show() BarVar()
	for i,v in pairs(XAddons.btn) do
		if i<14 and i~=1 then
			if _G["XBar"..v]:IsVisible() then
				if _G.XBar[v.."_OnEvent"] then
					_G.XBar[v.."_OnEvent"](_G["XBar"..v], "LOADED")
				end
			end
		end
	end
	RimEvent()
end

local function DesignOnClick(s)
	UIDropDownMenu_SetSelectedID(XBarCfg_G_Style,s:GetID())
end

function XBar.BarDesign_OnShow()
	for i,v in pairs(xdsgn) do UIDropDownMenu_AddButton({text=v,func=DesignOnClick}) end
end

function XBar.Legend_OnShow(frame)
	local Keys=""
	if frame=="Ammo" then
		Keys=Keys.."|cff8DE668[COUNT]|r\n"..XBar.Lng["Config"]["Count"]:format(TEXT("SYS_EQWEARPOS_09")).."\n\n"
		Keys=Keys.."|cff8DE668[NAME]|r\n"..XBar.Lng["Config"]["Name"]:format(TEXT("SYS_EQWEARPOS_09")).."\n\n"
		Keys=Keys.."|cff8DE668[EQUIP]|r\n"..XBar.Lng["Config"]["Count"]:format(BACKPACK_EQUIP.." "..TEXT("SYS_EQWEARPOS_09")).."\n\n"
		Keys=Keys.."|cff8DE668[BAG]|r\n"..XBar.Lng["Config"]["Count"]:format(GCF_TEXT_BAG.." "..TEXT("SYS_EQWEARPOS_09")).."\n"
	elseif frame=="Bag" then
		Keys=Keys.."|cff8DE668[USED]|r\n"..XBar.Lng["Config"]["Bag1"]:format(GCF_TEXT_BAG).."\n\n"
		Keys=Keys.."|cff8DE668[TOTAL]|r\n"..XBar.Lng["Config"]["Bag2"].."\n\n"
		Keys=Keys.."|cff8DE668[LOAD]|r\n"..XBar.Lng["Config"]["Bag3"]:format(GCF_TEXT_BAG).."\n\n"
		Keys=Keys.."|cff8DE668[SUSED]|r\n"..XBar.Lng["Config"]["Bag1"]:format(GOODSPACK).."\n\n"
		Keys=Keys.."|cff8DE668[SLOAD]|r\n"..XBar.Lng["Config"]["Bag3"]:format(GOODSPACK).."\n\n"
		Keys=Keys.."|cff8DE668[AUSED]|r\n"..MAGICBOX_TITLE.."\n\n"
	elseif frame=="Class" then
		Keys=Keys.."|cff8DE668[MCLASS]|r "..XBar.Lng["Config"]["Name"]:format(C_CLASS1).."\n"
		Keys=Keys.."|cff8DE668[MLVL]|r "..XBar.Lng["Config"]["Class2"]:format(C_CLASS1).."\n"
		Keys=Keys.."|cff8DE668[SCLASS]|r "..XBar.Lng["Config"]["Name"]:format(C_CLASS2).."\n"
		Keys=Keys.."|cff8DE668[SLVL]|r "..XBar.Lng["Config"]["Class2"]:format(C_CLASS2).."\n"
		Keys=Keys.."|cff8DE668[TCLASS]|r "..XBar.Lng["Config"]["Name"]:format(XBar.Lng["Config"]["Class1"]).."\n"
		Keys=Keys.."|cff8DE668[TLVL]|r "..XBar.Lng["Config"]["Class2"]:format(XBar.Lng["Config"]["Class1"]).."\n"
		Keys=Keys.."|cff8DE668[HONOR]|r "..C_HONOR_POINT.."\n"
		Keys=Keys.."|cff8DE668[SPIRIT]|r "..C_HONOR.."\n"
		Keys=Keys.."|cff8DE668[BADGE]|r "..SYS_DUELIST_REWARD.."\n"
		Keys=Keys.."|cff8DE668[DAY]|r "..XBar.Lng["Config"]["Count"]:format(TEXT("Sys546101_name")).."\n"
		Keys=Keys.."|cff8DE668[QUEST]|r "..XBar.Lng["Config"]["Class3"].."\n"
		Keys=Keys.."|cff8DE668[CQUEST]|r "..BILLBOARD_015.."\n"
		Keys=Keys.."|cff8DE668[CARD]|r "..UI_TITLE_TYPE_2_3.."\n"
		Keys=Keys.."|cff8DE668[TITLE]|r "..C_TITLE.."\n"
		Keys=Keys.."|cff8DE668[TITLEC]|r "..XBar.Lng["Config"]["Count"]:format(C_TITLE).."\n"
		Keys=Keys.."|cff8DE668[POINT]|r "..XBar.UpF(_glossary_00824).."\n"
		Keys=Keys.."|cff8DE668[GOOD]|r "..C_GOODEVIL.."\n"
	elseif frame=="Clock" then
		Keys=Keys.."|cff8DE668[TIME12]|r "..TIMEFLAG_STATE.." (12)\n"
		Keys=Keys.."|cff8DE668[TIME24]|r "..TIMEFLAG_STATE.." (24)\n"
		Keys=Keys.."|cff8DE668[DATE]|r "..GUILD_RESOURCE_DATE.."\n"
		Keys=Keys.."|cff8DE668[ONLINE]|r "..XBar.Lng["Config"]["Clock1"].."\n\n"
		Keys=Keys.."|cff8DE668[TOTALONLINE]|r\n"..XBar.Lng["Config"]["Clock2"].."\n"
	elseif frame=="Craft" then
		Keys=Keys.."|cff8DE668[MINELV]|r "..XBar.Lng["Config"]["Craft1"]:format(MINING).."\n"
		Keys=Keys.."|cff8DE668[MINEXP]|r "..XBar.Lng["Config"]["Craft2"]:format(MINING).."\n\n"
		Keys=Keys.."|cff8DE668[MINERE]|r\n"..XBar.Lng["Config"]["Craft3"]:format(MINING).."\n\n"
		Keys=Keys.."|cff8DE668[MINEL]|r "..XBar.Lng["Config"]["Craft4"]:format(MINING).."\n"
		Keys=Keys.."|cff8DE668[WOODLV]|r "..XBar.Lng["Config"]["Craft1"]:format(WOOD).."\n"
		Keys=Keys.."|cff8DE668[WOODXP]|r "..XBar.Lng["Config"]["Craft2"]:format(WOOD).."\n\n"
		Keys=Keys.."|cff8DE668[WOODRE]|r\n"..XBar.Lng["Config"]["Craft3"]:format(WOOD).."\n\n"
		Keys=Keys.."|cff8DE668[WOODL]|r "..XBar.Lng["Config"]["Craft4"]:format(WOOD).."\n"
		Keys=Keys.."|cff8DE668[HERBLV]|r "..XBar.Lng["Config"]["Craft1"]:format(HERB).."\n"
		Keys=Keys.."|cff8DE668[HERBXP]|r "..XBar.Lng["Config"]["Craft2"]:format(HERB).."\n\n"
		Keys=Keys.."|cff8DE668[HERBRE]|r\n"..XBar.Lng["Config"]["Craft3"]:format(HERB).."\n\n"
		Keys=Keys.."|cff8DE668[HERBL]|r "..XBar.Lng["Config"]["Craft4"]:format(HERB).."\n"
	elseif frame=="Dps" then
		Keys=Keys.."|cff8DE668[DPS]|r\n"..XBar.Lng["Config"]["Dps1"]:format(BG_STATUS_FRAME_COL_DMG).."\n\n"
		Keys=Keys.."|cff8DE668[DMG]|r "..XBar.Lng["Config"]["Dps2"]:format(BG_STATUS_FRAME_COL_DMG).."\n"
		Keys=Keys.."|cff8DE668[HPS]|r "..XBar.Lng["Config"]["Dps1"]:format(BG_STATUS_FRAME_COL_HEAL).."\n"
		Keys=Keys.."|cff8DE668[HEAL]|r "..XBar.Lng["Config"]["Dps2"]:format(BG_STATUS_FRAME_COL_HEAL).."\n"
		Keys=Keys.."|cff8DE668[KILLS]|r "..XBar.Lng["Config"]["Dps3"].."\n"
		Keys=Keys.."|cff8DE668[DURAL]|r "..XBar.Lng["Ttip"]["LowDur"].."\n"
		Keys=Keys.."|cff8DE668[DURA]|r "..XBar.Lng["Ttip"]["AvgDur"].."\n"
	elseif frame=="Exp" then
		Keys=Keys.."|cff8DE668[XP]|r "..PET_EXPERIENCE.."\n"
		Keys=Keys.."|cff8DE668[TP]|r "..PET_SKILLPOINT.."\n"
		Keys=Keys.."|cff8DE668[XPN]|r "..XBar.Lng["Config"]["Exp1"].."\n"
		Keys=Keys.."|cff8DE668[XPM]|r "..XBar.Lng["Config"]["Exp2"].."\n"
		Keys=Keys.."|cff8DE668[PER]|r "..XBar.Lng["Config"]["Exp3"].."\n"
		Keys=Keys.."|cff8DE668[PERN]|r "..XBar.Lng["Config"]["Exp4"].."\n"
		Keys=Keys.."|cff8DE668[RE]|r "..XBar.Lng["Config"]["Exp5"].."\n"
		Keys=Keys.."|cff8DE668[XPL]|r "..XBar.Lng["Config"]["Exp6"]:format(_glossary_02634).."\n"
		Keys=Keys.."|cff8DE668[XPS]|r "..XBar.Lng["Config"]["Exp7"]:format(_glossary_02634).."\n"
		Keys=Keys.."|cff8DE668[TPL]|r "..XBar.Lng["Config"]["Exp6"]:format(_glossary_02635).."\n"
		Keys=Keys.."|cff8DE668[TPS]|r "..XBar.Lng["Config"]["Exp7"]:format(_glossary_02635).."\n"
		Keys=Keys.."|cff8DE668[TPA]|r "..XBar.Lng["Config"]["Exp8"].."\n"
		Keys=Keys.."|cff8DE668[TPU]|r "..XBar.Lng["Config"]["Exp9"].."\n"
		Keys=Keys.."|cff8DE668[XPB]|r "..XBar.Lng["Config"]["Exp10"]:format(_glossary_02634).."\n"
		Keys=Keys.."|cff8DE668[TPB]|r "..XBar.Lng["Config"]["Exp10"]:format(_glossary_02635).."\n"
		Keys=Keys.."|cff8DE668[XPD]|r "..XBar.Lng["Config"]["Exp11"]:format(_glossary_02634).."\n"
		Keys=Keys.."|cff8DE668[TPD]|r "..XBar.Lng["Config"]["Exp11"]:format(_glossary_02635).."\n"
		Keys=Keys.."|cff8DE668[SXP]|r "..XBar.Lng["Config"]["Exp12"]:format(C_CLASS2).."\n"
		Keys=Keys.."|cff8DE668[SMXP]|r "..XBar.Lng["Config"]["Exp13"]:format(C_CLASS2).."\n"
		Keys=Keys.."|cff8DE668[SPER]|r "..C_CLASS2.." "..XBar.Lng["Config"]["Exp3"].."\n"
		Keys=Keys.."|cff8DE668[SXPD]|r "..C_CLASS2.." "..XBar.Lng["Config"]["Exp11"]:format(_glossary_02634).."\n"
		Keys=Keys.."|cff8DE668[STPD]|r "..C_CLASS2.." "..XBar.Lng["Config"]["Exp11"]:format(_glossary_02635).."\n"
		Keys=Keys.."|cff8DE668[TXP]|r "..XBar.Lng["Config"]["Exp12"]:format(XBar.Lng["Config"]["Class1"]).."\n"
		Keys=Keys.."|cff8DE668[TMXP]|r "..XBar.Lng["Config"]["Exp13"]:format(XBar.Lng["Config"]["Class1"]).."\n"
		Keys=Keys.."|cff8DE668[TPER]|r "..XBar.Lng["Config"]["Class1"].." "..XBar.Lng["Config"]["Exp3"].."\n"
		Keys=Keys.."|cff8DE668[TXPD]|r "..XBar.Lng["Config"]["Class1"].." "..XBar.Lng["Config"]["Exp11"]:format(_glossary_02634).."\n"
		Keys=Keys.."|cff8DE668[SCLASS], [TCLASS]|r "..CLASS.."\n"
		Keys=Keys.."|cff8DE668[SLVL], [TLVL]|r "..C_LEVEL.."\n"
	elseif frame=="Friend" then
		Keys=Keys.."|cff8DE668[ONLINE]|r\n"..XBar.Lng["Config"]["Friend1"].."\n\n"
		Keys=Keys.."|cff8DE668[COUNT]|r\n"..XBar.Lng["Config"]["Friend2"].."\n\n"
	elseif frame=="Guild" then
		Keys=Keys.."|cff8DE668[GNAME]|r "..UI_GUILDLISTBOARD_NAME.."\n"
		Keys=Keys.."|cff8DE668[GLVL]|r "..GUILD_LEVEL_MSG.."\n"
		Keys=Keys.."|cff8DE668[GLEADER]|r\n"..XBar.Lng["Config"]["Name"]:format(TEXT("GUILD_STR_LEADER")).."\n\n"
		Keys=Keys.."|cff8DE668[ONLINE]|r\n"..XBar.Lng["Config"]["Guild1"].."\n\n"
		Keys=Keys.."|cff8DE668[MEMBER]|r "..XBar.Lng["Config"]["Guild2"].."\n\n"
		Keys=Keys.."|cff8DE668[MAX]|r\n"..XBar.Lng["Config"]["Guild3"].."\n\n"
		Keys=Keys.."|cff8DE668[REC]|r "..GUILDBOARD_RECRUIT_SITUATION_COLON.."\n"
		Keys=Keys.."|cff8DE668[RANK]|r "..C_RANK.."\n"
		Keys=Keys.."|cff8DE668[POINT]|r "..C_GUILDHOUSEWAR_GUILDSCORE.."\n"
		Keys=Keys.."|cff8DE668[WAR]|r "..SYS_GUILD_RESOURCE_STR_13.."\n"
		Keys=Keys.."|cff8DE668[GOLD]|r "..SYS_GUILD_RESOURCE_STR_1.."\n"
		Keys=Keys.."|cff8DE668[RUBY]|r "..SYS_GUILD_RESOURCE_STR_2.."\n"
		Keys=Keys.."|cff8DE668[ORE]|r "..SYS_GUILD_RESOURCE_STR_3.."\n"
		Keys=Keys.."|cff8DE668[WOOD]|r "..SYS_GUILD_RESOURCE_STR_4.."\n"
		Keys=Keys.."|cff8DE668[HERB]|r "..SYS_GUILD_RESOURCE_STR_5.."\n"
		Keys=Keys.."|cff8DE668[RUNE]|r "..SYS_GUILD_RESOURCE_STR_6.."\n"
		Keys=Keys.."|cff8DE668[STONE]|r "..SYS_GUILD_RESOURCE_STR_7.."\n"
	elseif frame=="Mail" then
		Keys=Keys.."|cff8DE668[UNREAD]|r "..XBar.Lng["Config"]["Mail1"].."\n"
	elseif frame=="Money" then
		Keys=Keys.."|cff8DE668[GOLD]|r "..MONEY_GOLD.."\n"
		Keys=Keys.."|cff8DE668[DIAS]|r "..MONEY_RUNE.."\n"
		Keys=Keys.."|cff8DE668[RUBY]|r "..BILLBOARD_003.."\n"
		Keys=Keys.."|cff8DE668[COIN]|r ".._glossary_00844.."\n"
		Keys=Keys.."|cff8DE668[AM]|r "..TEXT("Sys206879_name").."\n"
		Keys=Keys.."|cff8DE668[AMC]|r "..TEXT("Sys206879_name").." "..XBar.Lng["Ttip"]["Money4"].."\n"
		Keys=Keys.."|cff8DE668[PS]|r "..TEXT("Sys240181_name").."\n"
		Keys=Keys.."|cff8DE668[EJ]|r "..TEXT("Sys201545_name").."\n"
		Keys=Keys.."|cff8DE668[PM]|r "..TEXT("Sys241706_name").."\n"
		Keys=Keys.."|cff8DE668[DS]|r "..TEXT("Sys208681_name").."\n"
		Keys=Keys.."|cff8DE668[BT]|r "..TEXT("Sys206686_name").."\n"
		Keys=Keys.."|cff8DE668[HP]|r "..TEXT("Sys203944_name").."\n"
	elseif frame=="Ping" then
		Keys=Keys.."|cff8DE668[MS]|r Ping\n"
		Keys=Keys.."|cff8DE668[FPS]|r FPS\n"
	end
	XBarCfg_Legend:Show()
	XBarCfg_Legend_Head:SetText(XBar.Lng["Config"]["Head"])
	XBarCfg_Legend_Keys:SetText(Keys)
end

--############# XAddon Manager #############
function XBar.AM_OnShow(this)
	XAddonMngr_Header:SetText(XBar.Lng["Config"]["Title"])
	XAddonMngr_Header_Name:SetText("XBar")
	XAddonMngr_Header_Version:SetText(XBARVERSION)
	XAddonMngr_Info_Title:SetText(XBar.Lng["Config"]["Title"])
	XAddonMngr_Info_Description:SetText(XBar.Lng["Config"]["Descr"])
	XAddonMngr_Info:Show()
	for i,v in pairs(XAddons.gui) do if v.open then v.open=false end end
 	XBar.AM_ListBtn_Update(this)
end

function XBar.AM_OnHide()
	for i=1, #XAddons.gui do _G[XAddons.gui[i].window]:Hide() end
end

function XBar.AM_ListBtn_OnClick(this)
	XBarCfg:Show()
	local title
	local version=XBARVERSION
	local selected=this:GetID()
	for i,v in pairs(XAddons.gui) do
		if v.open then
			if (v.type=="TopMenu" or v.type=="SubMenu") and not v.children then v.open=false end
			if v.type=="ItemBtn" then v.open=false end
		end
	end
	if xwindow then _G[xwindow]:Hide() end
	if XAddons.gui[selected].window then xwindow=XAddons.gui[selected].window end
	if XAddons.gui[selected].title then title=XAddons.gui[selected].title end
	if XAddons.gui[selected].version then version=XAddons.gui[selected].version end
	if XAddons.gui[selected].OnClick then XAddons.gui[selected].OnClick() end
	if XAddons.gui[selected].open then
		XAddons.gui[selected].open=false
		_G[xwindow]:Hide()
	 	XAddonMngr_Header_Name:SetText("XBar")
	 	XAddonMngr_Header_Version:SetText(XBARVERSION)
		XAddonMngr_Info:Show()
	else
		XAddons.gui[selected].open=true
		_G[xwindow]:Show()
		XAddonMngr_Header_Name:SetText(title)
		XAddonMngr_Header_Version:SetText(version)
		XAddonMngr_Info:Hide()
	end
	XBar.AM_ListBtn_Update(this:GetID())
	for i,v in pairs(XAddons.btn) do if not _G["XBar"..v] and i<14 and i~=1 then _G["XBarCfg_B_"..v]:Hide() end end
end

function XBar.AM_ListBtn_Update(nowid)
	local btn
	local btn_width=135
	local btn_text={r=1,g=1,b=1}
	local btn_list=0
	local btn_count=1
	local showsub=false
	local showitem=false
	XAddonMngr_Menu_ScrollBar:SetMaxValue(table.getn(XAddons.gui))
	XAddonMngr_Menu_ScrollBar:SetMinValue(1)
	XAddonMngr_Menu_ScrollBar:Show()
	for i=1,20 do
		_G["XAddonMngr_List_Btn"..i]:UnlockHighlight()
		_G["XAddonMngr_List_Btn"..i.."_OpenedArrow"]:Hide()
		_G["XAddonMngr_List_Btn"..i.."_ExpandArrow"]:Hide()
		_G["XAddonMngr_List_Btn"..i]:Hide()
	end
	for i,v in pairs(XAddons.gui) do
		if btn_count>20 then return end
		btn=_G["XAddonMngr_List_Btn"..btn_count]
		if v.type then
			if v.type=="TopMenu" then
				if v.children then
					if v.open then
						showsub=true showitem=true
						btn_text={r=.9,g=.41,b=.41}
					else
						showsub=false showitem=false
						btn_text={r=.7,g=.7,b=1}
					end
				else
					btn_text={r=.8,g=.8,b=.8}
				end
				btn_width=135
				btn_list=btn_list+1
			elseif v.type=="SubMenu" and showsub then
				if v.children then
					if v.open then
						showitem=true
						btn_text={r=.9,g=.41,b=.41}
					else
						showitem=false
						btn_text={r=.62,g=.62,b=1}
					end
				else
					btn_text={r=.8,g=.8,b=.8}
				end
				btn_width=130
				btn_list=btn_list+1
			elseif v.type=="ItemBtn" and showitem then
				if v.open then
					btn_text={r=1,g=1,b=.45}
				else
					btn_text={r=.8,g=.8,b=.8}
				end
				btn_width=125
				btn_list=btn_list+1
			end
		end
		if btn_list>=XAddonMngr_Menu_ScrollBar:GetValue() then
			if v.open and v.children then btn:LockHighlight() else btn:UnlockHighlight() end
			if v.name then btn:SetText(v.name) else btn:SetText(i) end
			if (v.type=="ItemBtn" and showitem) or (v.type=="SubMenu" and showsub) or (v.type=="TopMenu") then
				if i==nowid then btn:SetTextColor(1,.91,.33)
				else btn:SetTextColor(btn_text.r,btn_text.g,btn_text.b) end
				if v.children then
					if v.open then
						_G[btn:GetName().."_OpenedArrow"]:Show()
						_G[btn:GetName().."_ExpandArrow"]:Hide()
					else
						_G[btn:GetName().."_OpenedArrow"]:Hide()
						_G[btn:GetName().."_ExpandArrow"]:Show()
					end
				end
				btn:SetWidth(btn_width)
				btn:SetID(i)
				btn:Show()
				btn_count=btn_count+1
			end
		end
	end
	if btn_list<20 then
		XAddonMngr_Menu_ScrollBar:SetValue(0)
		XAddonMngr_Menu_ScrollBar:Hide()
	end
end

local function PopScroll(delta)
	if delta>0 then if pStart>1 then pStart = pStart - 1 end end
	if delta<0 then if pStart<#XAddons.popup-(pMax-1) then pStart = pStart + 1 end end
	XBar.AM_PopClick(nil, true)
end

function XBar.AM_PopClick(this, wheel)
	local popup = {}
	for i = 1, #XAddons.popup do
		table.insert(popup, XAddons.popup[i])
		popup[i].OnScroll = function(delta) PopScroll(delta) end
	end
	if pStart>1 then for i = 1, pStart-1 do table.remove(popup, 1) end end
	while #popup>pMax do table.remove(popup) end
	XBar_PopupMenu.Buttons = popup
	XBar.PopupMenu_Toggle(this, (wheel and 1) or false)
end

function XAddon_Register(add) --XBar.AM_Register
	if add.gui then
		for i, v in ipairs(add.gui) do
			if not v.window then error("XBar: Third-party addon's ['gui']['window'] is required", 2) end
			v.title = v.title or v.name
			v.version = v.version or add.gui[1].version or ""
			v.type = v.type or "TopMenu"
			v.OnClick = function() XBarCfg:Hide() end
			table.insert(XAddons.gui, v)
		end
	end
	if add.popup then
		for i, v in ipairs(add.popup) do
			if not v.GetText then error("XBar: Third-party addon's ['popup']['GetText'] is required", 2) end
			table.insert(XAddons.popup, v)
		end
	end
	if add.btn then
		local m = "XBar"..add.btn.name
		local bg = "XBar"..add.btn.name.."_BG"
		local bt = "XBar"..add.btn.name.."_B"
		local fn = "XBar"..add.btn.name.."_F"
		local lbg = CreateUIComponent("Frame", bg, "XBarFrame")
		lbg:SetSize(128, 32)
		lbg:ClearAllAnchors()
		lbg:SetAnchor("LEFT", "LEFT", _G[m], -28, 0)
		lbg:SetFrameStrata("BACKGROUND")
		local lbgt = CreateUIComponent("Texture", "XBar"..add.btn.name.."_BG_T", bg)
		lbgt:SetSize(128, 32)
		lbgt:SetTexture("Interface/Buttons/ListBox-Highlight")
		lbg:SetLayers(1, lbgt)
		local lbt = CreateUIComponent("Button", bt, m)
		lbt:SetSize(20, 20)
		lbt:ClearAllAnchors()
		lbt:SetAnchor("LEFT", "LEFT", _G[m], 0, 0)
		local lbtt = CreateUIComponent("Texture", "XBar"..add.btn.name.."_B_T", bt)
		lbtt:SetSize(20, 20)
		lbtt:SetTexture(add.btn.texture)
		lbt:SetLayers(1, lbtt)
		lbt:SetMouseEnable(true)
		lbt:SetScripts("OnLoad", [=[this:RegisterForClicks("LeftButton","RightButton","MiddleButton") this:RegisterForDrag("RightButton")]=])
		lbt:SetScripts("OnDragStart", [=[XBar.MoveStart(this:GetParent())]=])
		lbt:SetScripts("OnDragStop", [=[XBar.MoveEnd(this:GetParent())]=])
		local lfn = CreateUIComponent("Frame", fn, m)
		lfn:SetSize(512, 24)
		lfn:ClearAllAnchors()
		lfn:SetAnchor("LEFT", "LEFT", _G[m], 26, 0)
		local lfns = CreateUIComponent("FontString", "XBar"..add.btn.name.."_F_S", fn)
		lfns:SetSize(512, 24)
		lfns:SetFont("Fonts/DFHEIMDU.TTF", 12, "NORMAL", "NORMAL")
		lfns:SetJustifyHType("LEFT")
		lfn:SetLayers(1, lfns)
		table.insert(XAddons.btn, add.btn.name)
		MoveVar()
	end
end

function XAddon_ShowPage(v) --XBar.AM_ShowPage
	XAddonMngr:Show()
	XAddonMngr_Info:Hide()
	if xwindow then _G[xwindow]:Hide() end
	_G[v]:Show()
	xwindow = v
	local s = 13
	for i = 1, #XAddons.gui do if XAddons.gui[i].window==v then s = i break end end
	if XAddons.gui[s].type=="ItemBtn" then
		local Sub = s
		for i = 1, #XAddons.gui do
			if XAddons.gui[s-i].type=="SubMenu" then
				XAddons.gui[s-i].open = true
				Sub = s - i break
			end
		end
		for i = 1, #XAddons.gui do
			if XAddons.gui[Sub-i].type=="TopMenu" then
				XAddons.gui[Sub-i].open = true break
			end
		end
	end
	if XAddons.gui[s].type=="SubMenu" then
		for i = 1, #XAddons.gui do
			if XAddons.gui[s-i].type=="TopMenu" then
				XAddons.gui[s-i].open = true break
			end
		end
	end
	XAddons.gui[s].open=true
	XAddonMngr_Header_Name:SetText(XAddons.gui[s].title)
	XAddonMngr_Header_Version:SetText(XAddons.gui[s].version)
	XBar.AM_ListBtn_Update(s)
end

function XAddon_Page(this) --XBar.AM_Page
	this:ClearAllAnchors()
	this:SetAnchor("TOPLEFT", "TOPLEFT", "XBarCfg", -10, -10)
end

function XAddon_HideBack1(this) --XBar.AM_HideBack1
	UIPanelBackdropFrame_SetTexture(this, "", 256, 256)
	_G[this:GetName().."CloseButton"]:Hide()
	_G[this:GetName().."TitlebarFrame"]:Hide()
end

function XAddon_HideBack2(this) --XBar.AM_HideBack2
	this:SetBackdropEdgeAlpha(0)
	this:SetBackdropTileAlpha(0)
end

--############# XBar PopupMenu #############
function XBar.PopupMenu_Toggle(parent,scroll)
	if not scroll then
		if XBar_PopupMenu:IsVisible() then
			XBar_PopupMenu:Hide()
		else
			if parent:GetPos()<GetScreenWidth()/2 then
				x = -8
			else
				x = -176
			end
			if XBSet["Position"]=="TOP" then
				XBar_PopupMenu:ClearAllAnchors() XBar_PopupMenu:SetAnchor("TOPLEFT","TOPLEFT",parent,x,32)
			else
				XBar_PopupMenu:ClearAllAnchors() XBar_PopupMenu:SetAnchor("BOTTOMLEFT","BOTTOMLEFT",parent,x,-32)
			end
			XBar_PopupMenu:Show()
		end
	else
		XBar_PopupMenu:Hide()
		XBar_PopupMenu:Show()
	end
end

function XBar.PopupMenu_OnShow()
	local button="XBar_PopupMenu_Button"
	for i=1,25 do _G[button..i]:Hide() end
	for i,v in pairs(XBar_PopupMenu.Buttons) do
		local ico=_G[button..i.."Icon"]
		if v.icon then
			ico:SetTexture(v.icon)
		else
			ico:SetTexture("Interface/MainMenuFrame/MainPopupButton-Icon-InstanceRecord")
		end
		_G[button..i.."Text"]:SetText(v.GetText())
		_G[button..i]:Show()
	end
	XBar_PopupMenu:SetHeight(20+(table.getn(XBar_PopupMenu.Buttons)*22))
end

function XBar.PopupButton_OnEnter(this)
	PlaySoundByPath("sound/interface/ui_navbar_open.mp3")
	local info=XBar_PopupMenu.Buttons[this:GetID()]
	if info.GetTooltip then
		local text=info.GetTooltip()
		if text then
			GameTooltip:ClearAllAnchors()
			GameTooltip:SetAnchor("TOPRIGHT","TOPLEFT",this,0,30)
			GameTooltip:SetText(text)
		end
	end
end

--############# XBar III - Bonus #############

function XBar.heal()
	TargetUnit("player")
	for a=1,GetNumPartyMembers()-1 do p="party"..a t="target"
		if UnitHealth(p)>1 and UnitHealth(p)/UnitMaxHealth(p)<UnitHealth(t)/UnitMaxHealth(t) then
			TargetUnit(p)
		end
	end
	local mc, sc = UnitClass("player")
	if mc==C_AUGUR then
		CastSpellByName(TEXT("Sys490269_name"))
	elseif mc==C_DRUID then
		CastSpellByName(TEXT("Sys493528_name"))
	end
end

function XBar.rogue()
	local c, d = 0, 0
	for i = 1, 24 do
		if UnitDebuff("target", i)~=nil then
			if UnitDebuff("target",i)==TEXT("Sys500081_name") then c=1 end --Bleed
			if UnitDebuff("target",i)==TEXT("Sys500704_name") then d=1 end --Grievous Wound
		end
	end
	local _, left = GetSkillCooldown(4,3) 
	if d==1 and left<0.9 and UnitMana("player")/UnitMaxMana("player")>=.35 then
		CastSpellByName(TEXT("Sys490313_name")) --Wound Attack
	elseif d==1 and left>1 and UnitMana("player")/UnitMaxMana("player")>=.30 then
		CastSpellByName(TEXT("Sys490323_name")) --Low Blow
	elseif c==1 and d==0 and UnitMana("player")/UnitMaxMana("player")>=.30 then
		CastSpellByName(TEXT("Sys490323_name")) --Low Blow
	elseif c==0 and d==0 and UnitMana("player")/UnitMaxMana("player")>=.20 then
		CastSpellByName(TEXT("Sys490581_name")) --Shadowstab
	else CastSpellByName(TEXT("Sys497222_name")) --Assault
	end
end

function XBar.party()
	local c=1
	local m=GetNumPartyMembers()-1
	for i=1, m do
		if UnitName("party"..i)==UnitName("target") then
			c=i+1
			break
		end
	end
	if c>m then c=1 end
	TargetUnit("party"..c)
end

function XBar.preview()
	if ItemPreviewFrame:IsVisible() then
		ItemPreviewFrame:Hide()
	else
		ItemPreviewFrame:Show()
	end
	ItemPreviewFrame:SetSize(260, 350)
	ItemPreviewFrameModel:SetUnit("target", 1)
end

function XBar.strip()
	EquipItem(16, GetBagItemInfo(57))
	EquipItem(17, GetBagItemInfo(58))
	EquipItem(1, GetBagItemInfo(56))
	EquipItem(2, GetBagItemInfo(55))
	EquipItem(3, GetBagItemInfo(54))
	EquipItem(4, GetBagItemInfo(53))
	EquipItem(5, GetBagItemInfo(52))
	EquipItem(6, GetBagItemInfo(51))
	EquipItem(7, GetBagItemInfo(50))
	EquipItem(8, GetBagItemInfo(49))
	EquipItem(9, GetBagItemInfo(48))
	EquipItem(11, GetBagItemInfo(60))
	EquipItem(12, GetBagItemInfo(46))
	EquipItem(13, GetBagItemInfo(45))
	EquipItem(14, GetBagItemInfo(44))
	EquipItem(15, GetBagItemInfo(47))
end

function XBar.switch()
	EquipItem(16, GetBagItemInfo(57))
	EquipItem(17, GetBagItemInfo(58))
	EquipItem(11, GetBagItemInfo(60))
	--SwapEquipmentItem(n)
	--XFuncs_wait(0.5)
	--EquipItem(16, GetBagItemInfo(57))
	--EquipItem(17, GetBagItemInfo(58))
	--EquipItem(11, GetBagItemInfo(60))
	Print(XBar.Lng["X3"]["AngelSwitch"])
end

function XBar.pet1()
	if IsPetSummoned(1)==false then SummonPet(1) else ReturnPet(1) end
end

function XBar.pet2()
	if IsPetSummoned(2)==false then SummonPet(2) else ReturnPet(2) end
end

function XBar.pet3()
	if IsPetSummoned(3)==false then SummonPet(3) else ReturnPet(3) end
end

function XBar.III_OnEvent()
	PlaySoundByPath("sound/interface/refine_fail.mp3")
	Print("XBar III - PetCraftReminder")
end