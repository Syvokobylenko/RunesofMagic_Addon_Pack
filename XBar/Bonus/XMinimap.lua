local XMinimap = {
	version = 1.11,
}
_G.XMinimap = XMinimap
local mapbtn = {"Bull", "Npc", "BS", "Store", "QT", "Option", "BG", "RUI", "Plus", "Minus", "PB", "Pet", "PCard", "WBG"}
local frames = {"Title", "Time", "Coord"}
local pre
local def={
	["Enable"] = true,
	["Anchor"] = true,
	["X"] = 0,
	["Y"] = 24,
	["Style"] = 2,
	["Size"] = 180,
	["Time"] = true,
	["Time_Anchor"] = false,
	["Time_X"] = 68,
	["Time_Y"] = -68,
	["Title"] = true,
	["Title_Anchor"] = false,
	["Title_X"] = 0,
	["Title_Y"] = -100,
	["Coord"] = true,
	["Coord_Anchor"] = false,
	["Coord_X"] = 0,
	["Coord_Y"] = 90,
}
XMinimapSet = {
	["MB_Plus"] = true,
	["Title_Anchor"] = false,
	["MB_Pet"] = false,
	["MB_PB"] = false,
	["Enable"] = true,
	["MB_Store"] = true,
	["Anchor"] = true,
	["Time_X"] = 68,
	["MB_BG"] = false,
	["Title_Y"] = -100,
	["Time"] = false,
	["MB_RUI"] = true,
	["Time_Anchor"] = false,
	["Title_X"] = 0,
	["Style"] = 2,
	["Size"] = "180",
	["MB_Minus"] = true,
	["Coord_Y"] = 90,
	["MB_QT"] = true,
	["MB_Option"] = false,
	["MB_BS"] = true,
	["MB_Npc"] = true,
	["MB_Bull"] = true,
	["Coord"] = false,
	["Y"] = 2,
	["X"] = 1,
	["Title"] = false,
	["MB_WBG"] = false,
	["Coord_Anchor"] = false,
	["Coord_X"] = 0,
	["MB_PCard"] = false,
	["Time_Y"] = -68,
}
XMinimapSkin = {"Default"}

SlashCmdList["XMINIMAP"] = function ()
	if XBARVERSION and XBARVERSION>=1.51 then
		XAddon_ShowPage("XMinimapGUI1")
	else
		ToggleUIFrame(XMinimapGUI1)
	end
end
SLASH_XMINIMAP1 = "/xm"
SLASH_XMINIMAP2 = "/xminimap"

local function Print(str, ...)
	DEFAULT_CHAT_FRAME:AddMessage(str:format(...), 1, 1, 1)
end

function XMinimap.OnEvent()
	for k, v in pairs(def) do
		if XMinimapSet[k]==nil then
			XMinimapSet[k] = v
		end
	end
	SaveVariables("XMinimapSet")
	if XBARVERSION and XBARVERSION>=1.51 then
		XAddon_Register(
		{gui={{
			name = "XMinimap",
			children = true,
			version = XMinimap.version,
			window = "XBarCfg_Info",
		},{
			name = OBJ_MINEMAP,
			title = "XMinimap - "..OBJ_MINEMAP,
			type = "SubMenu",
			window = "XMinimapGUI1",
		},{
			name = C_HIDE,
			title = "XMinimap - "..C_HIDE,
			type = "SubMenu",
			window = "XMinimapGUI2",
		}},
		popup={{
			GetText = function() return "XMinimap" end,
			GetTooltip = function() return "/xm, /xminimap" end,
			OnClick = function() XAddon_ShowPage("XMinimapGUI1") end,
		}}})
	end
	XMinimap.Var()
	Print("|cffFFBB55XMinimap %s|r %s |cffFFBB55/xm|r %s", XMinimap.version, XBar.Lng["XM"]["Load"], XBar.Lng["XM"]["ToConfig"])
end

local function DefaultSkin()
	MinimapFrame:SetSize(150, 150)
	MinimapFrameBorder:ClearAllAnchors()
	MinimapFrameBorder:SetAnchor("BOTTOMRIGHT", "TOPRIGHT", "MinimapFrame", 11, 268)
	MinimapRimFrame:SetSize(256, 256)
	MinimapRimFrame:ClearAllAnchors()
	MinimapRimFrame:SetAnchor("TOPRIGHT", "TOPRIGHT", MinimapFrame, 5, 0)
	MinimapRimFrameTexture1:SetSize(256, 64)
	MinimapRimFrameTexture2:SetSize(256, 128)
	MinimapViewFrame:SetSize(150, 150)
	MinimapViewFrame:ClearAllAnchors()
	MinimapViewFrame:SetAnchor("TOP", "TOP", MinimapFrame, 0, 0)
	MinimapFramePlusButton:SetScale(1)
	MinimapFramePlusButton:ClearAllAnchors()
	MinimapFramePlusButton:SetAnchor("CENTER", "CENTER", MinimapViewFrame, 64.301, 47.595)
	MinimapFrameMinusButton:SetScale(1)
	MinimapFrameMinusButton:ClearAllAnchors()
	MinimapFrameMinusButton:SetAnchor("CENTER", "CENTER", MinimapViewFrame, 44.328, 66.595)
	MinimapRimFrameTexture1:SetTexture("Interface/Minimap/MinimapBorder_Middle")
	MinimapRimFrameTexture2:SetTexture("Interface/Minimap/MinimapBorder_Buttom")
	InitializeMiniMap("MinimapViewFrame", "Interface/Minimap/MinimapBorder_Mask", "MinimapFramePlayerCursor", "MinimapFrameDuelRange", "MinimapFrame_Icon", 30)
end

local function Hide(set, frame)
	if set then
		frame:Hide()
	else
		frame:Show()
	end
end

local function ButtonToggle()
	if not MinimapFrame:IsVisible() then
		MinimapFramePlayerPosition:Hide()
		MinimapBeautyStudioButton:Hide()
		MinimapFrameBulletinButton:Hide()
		MinimapFrameOptionButton:Hide()
		MinimapFrameQuestTrackButton:Hide()
		MinimapFrameRestoreUIButton:Hide()
		MinimapFrameStoreButton:Hide()
		MinimapNpcTrackButton:Hide()
		MinimapFrameBattleGroundButton:Hide()
		MinimapFramePlusButton:Hide()
		MinimapFrameMinusButton:Hide()
	else
		if XMinimapSet["Coord"]==false then MinimapFramePlayerPosition:Hide() else MinimapFramePlayerPosition:Show() end
		Hide(XMinimapSet["MB_BS"], MinimapBeautyStudioButton)
		Hide(XMinimapSet["MB_Bull"], MinimapFrameBulletinButton)
		Hide(XMinimapSet["MB_Option"], MinimapFrameOptionButton)
		Hide(XMinimapSet["MB_QT"], MinimapFrameQuestTrackButton)
		Hide(XMinimapSet["MB_RUI"], MinimapFrameRestoreUIButton)
		Hide(XMinimapSet["MB_Store"], MinimapFrameStoreButton)
		Hide(XMinimapSet["MB_Npc"], MinimapNpcTrackButton)
		Hide(XMinimapSet["MB_BG"], MinimapFrameBattleGroundButton)
		Hide(XMinimapSet["MB_Plus"], MinimapFramePlusButton)
		Hide(XMinimapSet["MB_Minus"], MinimapFrameMinusButton)
		Hide(XMinimapSet["MB_PB"], PlayerFramePartyBoardButton)
		Hide(XMinimapSet["MB_Pet"], PlayerFramePetButton)
		Hide(XMinimapSet["MB_PCard"], PetBookFrameButton)
		Hide(XMinimapSet["MB_WBG"], PlayerFrameWorldBattleGroundButton)
	end
end

function XMinimap.Var()
	ButtonToggle()
	if XMinimapSet["Enable"] then
		if XMinimapSkin[XMinimapSet["Style"]]==nil then XMinimapSet["Style"] = 1 end
		if XMinimapSet["Anchor"] then
			XMinimapF:Show()
		else
			XMinimapF:Hide()
		end
		if XMinimapSet["Title"] then
			if XMinimapSet["Style"]>1 then
				XMinimapFTitle:Show()
				MinimapFrameBorder:Hide()
			else
				XMinimapFTitle:Hide()
				MinimapFrameBorder:Show()
			end
			XMinimapFTitle:SetMouseEnable(XMinimapSet["Title_Anchor"])
		else
			XMinimapFTitle:Hide()
			MinimapFrameBorder:Hide()
		end
		if XMinimapSet["Time"] then
			if XMinimapSet["Time_Anchor"] then
				XMinimapFTime:Show()
			else
				XMinimapFTime:Hide()
			end
			MinimapFrameTime:Show()
		else
			MinimapFrameTime:Hide()
		end
		if XMinimapSet["Coord"] then
			if XMinimapSet["Coord_Anchor"] then
				XMinimapFCoord:Show()
			else
				XMinimapFCoord:Hide()
			end
			MinimapFramePlayerPosition:Show()
		else
			MinimapFramePlayerPosition:Hide()
		end
		if XMinimapSet["Style"]>1 then
			MinimapFrame:SetSize(XMinimapSet["Size"], XMinimapSet["Size"])
			MinimapRimFrame:SetSize(XMinimapSet["Size"], XMinimapSet["Size"])
			MinimapRimFrame:ClearAllAnchors()
			MinimapRimFrame:SetAnchor("CENTER", "CENTER", MinimapFrame, 0, 0)
			MinimapRimFrameTexture1:SetSize(XMinimapSet["Size"], XMinimapSet["Size"]/2)
			MinimapRimFrameTexture2:SetSize(XMinimapSet["Size"], XMinimapSet["Size"]/2)
			MinimapViewFrame:SetSize(XMinimapSet["Size"], XMinimapSet["Size"])
			MinimapViewFrame:ClearAllAnchors()
			MinimapViewFrame:SetAnchor("CENTER", "CENTER", MinimapFrame, 0, 0)
			XMinimapFTitle:ClearAllAnchors()
			XMinimapFTitle:SetAnchor("CENTER", "CENTER", "MinimapViewFrame", XMinimapSet["Title_X"], XMinimapSet["Title_Y"])
			MinimapFramePlusButton:SetScale(.7)
			MinimapFramePlusButton:ClearAllAnchors()
			MinimapFramePlusButton:SetAnchor("LEFT", "RIGHT", MinimapFramePlayerPosition, 0, 0)
			MinimapFrameMinusButton:SetScale(.7)
			MinimapFrameMinusButton:ClearAllAnchors()
			MinimapFrameMinusButton:SetAnchor("RIGHT", "LEFT", MinimapFramePlayerPosition, 0, 0)
			MinimapRimFrameTexture1:SetTexture("Interface/AddOns/XBar/img/map/"..XMinimapSkin[XMinimapSet["Style"]].."/rim1")
			MinimapRimFrameTexture2:SetTexture("Interface/AddOns/XBar/img/map/"..XMinimapSkin[XMinimapSet["Style"]].."/rim2")
			InitializeMiniMap("MinimapViewFrame", "Interface/AddOns/XBar/img/map/"..XMinimapSkin[XMinimapSet["Style"]].."/mask", "MinimapFramePlayerCursor", "MinimapFrameDuelRange", "MinimapFrame_Icon", 30)
		else
			DefaultSkin()
		end
		MinimapFrame:ClearAllAnchors()
		MinimapFrame:SetAnchor("TOPRIGHT", "TOPRIGHT", "UIParent", XMinimapSet["X"], XMinimapSet["Y"])
		MinimapFrameTime:ClearAllAnchors()
		MinimapFrameTime:SetAnchor("CENTER", "CENTER", "MinimapViewFrame", XMinimapSet["Time_X"], XMinimapSet["Time_Y"])
		MinimapFramePlayerPosition:ClearAllAnchors()
		MinimapFramePlayerPosition:SetAnchor("CENTER", "CENTER", "MinimapViewFrame", XMinimapSet["Coord_X"], XMinimapSet["Coord_Y"])
	else
		DefaultSkin()
		XMinimapF:Hide()
		XMinimapFTitle:Hide()
		XMinimapFTime:Hide()
		XMinimapFCoord:Hide()
		MinimapFrameBorder:Show()
		MinimapFrameTime:Show()
		MinimapFramePlayerPosition:Show()
		MinimapFrame:ClearAllAnchors()
		MinimapFrame:SetAnchor("TOPRIGHT", "TOPRIGHT", "UIParent", -12, 32)
		MinimapFrameTime:ClearAllAnchors()
		MinimapFrameTime:SetAnchor("CENTER", "CENTER", "MinimapViewFrame", 57, -56)
		MinimapFramePlayerPosition:ClearAllAnchors()
		MinimapFramePlayerPosition:SetAnchor("CENTER", "BOTTOM", MinimapViewFrame, 0, 0)
	end
end

function XMinimap.Toggle(key)
	if key=="RBUTTON" then
		if not IsShiftKeyDown() then
			ToggleDropDownMenu(XMinimapFMenu)
		end
	elseif key=="LBUTTON" then
		if MinimapFrame:IsVisible() then
			XMinimapFN:SetTexture("Interface/AddOns/XBar/img/map/map_shadow")
			MinimapFrame:Hide()
			MinimapViewFrame:Hide()
		else
			XMinimapFN:SetTexture("Interface/AddOns/XBar/img/map/map_normal")
			MinimapFrame:Show()
			MinimapViewFrame:Show()
		end
		ButtonToggle()
	elseif key=="MBUTTON" then
		ToggleUIFrame(WorldMapFrame)
	end
end

function XMinimap.ButtonMenu()
	if UIDROPDOWNMENU_MENU_LEVEL==1 then
		UIDropDownMenu_AddButton({
			text = BULLETINBOARD,
			notCheckable = 1,
			func = OnClick_MinimapBulletinButton,
		})
		UIDropDownMenu_AddButton({
			text = UI_NPCTRACK_TITLE,
			notCheckable = 1,
			func = OnClick_MinimapNpcTrackButton,
		})
		UIDropDownMenu_AddButton({
			text = BSF_STR_TITLE,
			notCheckable = 1,
			func = OnClick_MinimapBeautyStudioButton,
		})
		UIDropDownMenu_AddButton({
			text = MERCHANT,
			notCheckable = 1,
			func = OnClick_MinimapStoreButton,
		})
		local info = {
			text = UI_MINIMAP_QUESTSCHEDULE,
			func = function() if MinimapFrameQuestTrackButton:IsChecked() then
				MinimapFrameQuestTrackButton:SetChecked(false)
				else MinimapFrameQuestTrackButton:SetChecked(true) end
				OnClick_QuestTrackButton2(MinimapFrameQuestTrackButton) end,
		}
		if MinimapFrameQuestTrackButton:IsChecked() then info.checked = false else info.checked = true end
		UIDropDownMenu_AddButton(info)
		UIDropDownMenu_AddButton({
			text = BATTLE_GROUND_NAME,
			notCheckable = 1,
			func = function() if GuildHousesWar_IsInBattleGround() then OpenGuildHouseWarPlayerScoreFrame()
				elseif GetBattleGroundType()>0 and GetBattleGroundType()~=350 then OpenBattleGroundPlayerScoreFrame()
				elseif not GuildHousesWar_IsInBattleGround() then ToggleUIFrame(BattleGroundQueueFrame) end end,
		})
		UIDropDownMenu_AddButton({
			text = UI_MINIMAP_RESTORE_UI,
			notCheckable = 1,
			func = UIPanelAnchorFrame_ResetAnchorAll,
		})
		UIDropDownMenu_AddButton({
			text = PET_FRAME_BUTTON,
			notCheckable = 1,
			func = function() ToggleUIFrame(PetFrame) end,
		})
		UIDropDownMenu_AddButton({
			text = SYSTEM_PETBOOK,
			notCheckable = 1,
			func = function() ToggleUIFrame(PetBookFrame) end,
		})
		UIDropDownMenu_AddButton({
			text = PARTY_BOARD_TITLE1,
			notCheckable = 1,
			func = function() ToggleUIFrame(PartyBoardFrame) end,
		})
		UIDropDownMenu_AddButton({
			text = WORLD_BATTLE_GROUND_BUTTON,
			notCheckable = 1,
			func = function() ToggleUIFrame(WorldBattleGroundFrame) end,
		})
	end
	OnShow_MiniMap_OptionMenu()
end

function XMinimap.MoveStart(this, dummy)
	if IsShiftKeyDown() then
		if dummy then
			this:GetParent():StartMoving()
		else
			this:StartMoving()
		end
	end
end

function XMinimap.MoveEnd(this)
	local tx, ty
	this:StopMovingOrSizing()
	this:GetParent():StopMovingOrSizing()
	_, _, _, XMinimapSet["X"], XMinimapSet["Y"] = MinimapFrame:GetAnchor()
	_, _, _, XMinimapSet["Title_X"], XMinimapSet["Title_Y"] = XMinimapFTitle:GetAnchor()
	_, _, _, tx, ty = MinimapFrameTime:GetAnchor()
	_, _, _, XMinimapSet["Coord_X"], XMinimapSet["Coord_Y"] = MinimapFramePlayerPosition:GetAnchor()
	XMinimapSet["Time_X"] = math.floor(tx)
	XMinimapSet["Time_Y"] = math.floor(ty)
	XMinimapGUI1_X:SetText(XMinimapSet["X"])
	XMinimapGUI1_Y:SetText(XMinimapSet["Y"])
	XMinimapGUI1_Title_X:SetText(XMinimapSet["Title_X"])
	XMinimapGUI1_Title_Y:SetText(XMinimapSet["Title_Y"])
	XMinimapGUI1_Time_X:SetText(XMinimapSet["Time_X"])
	XMinimapGUI1_Time_Y:SetText(XMinimapSet["Time_Y"])
	XMinimapGUI1_Coord_X:SetText(XMinimapSet["Coord_X"])
	XMinimapGUI1_Coord_Y:SetText(XMinimapSet["Coord_Y"])
end

function XMinimap.Tooltip(this)
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT", 0, 0)
	GameTooltip:SetText("XMinimap")
	GameTooltip:AddLine(UIPANELANCHORFRAME_TOOLTIP, 0, .7, .9)
end

local function StyleOnClick(s)
	UIDropDownMenu_SetSelectedID(XMinimapGUI1_Style, s:GetID())
end

function XMinimap.Style_Show()
	for i, s in ipairs(XMinimapSkin) do
		UIDropDownMenu_AddButton({text = s, func = StyleOnClick})
	end
end

function XMinimap.Switch()
	PlaySoundByPath("sound/interface/ui_generic_click.mp3")
	if XMinimapSet["Style"]<#XMinimapSkin then
		XMinimapSet["Style"] = XMinimapSet["Style"] + 1
	else
		XMinimapSet["Style"] = 1
	end
	UIDropDownMenu_SetSelectedID(XMinimapGUI1_Style, XMinimapSet["Style"])
	XMinimap.Var()
end

function XMinimap.OnShow()
	XMinimapGUI1_CB:SetChecked(XMinimapSet["Enable"])
	XMinimapGUI1_XA:SetChecked(XMinimapSet["Anchor"])
	XMinimapGUI1_X:SetText(XMinimapSet["X"])
	XMinimapGUI1_Y:SetText(XMinimapSet["Y"])
	XMinimapGUI1_Size:SetText(XMinimapSet["Size"])
	UIDropDownMenu_SetSelectedID(XMinimapGUI1_Style, XMinimapSet["Style"])
	for i, v in ipairs(frames) do
		_G["XMinimapGUI1_"..v.."_CB"]:SetChecked(XMinimapSet[v])
		_G["XMinimapGUI1_"..v.."_XA"]:SetChecked(XMinimapSet[v.."_Anchor"])
		_G["XMinimapGUI1_"..v.."_X"]:SetText(XMinimapSet[v.."_X"])
		_G["XMinimapGUI1_"..v.."_Y"]:SetText(XMinimapSet[v.."_Y"])
		_G["XMinimapGUI1_"..v.."_XA_Text"]:SetText(XBar.Lng["XM"]["Anchor"])
	end
	for i, v in ipairs(mapbtn) do
		_G["XMinimapGUI2_"..v]:SetChecked(XMinimapSet["MB_"..v])
	end
	XMinimap.Disable(XMinimapSet["Enable"])
	XMinimapGUI1_Version:SetText("XMinimap "..XMinimap.version)
	XMinimapGUI2_Version:SetText("XMinimap "..XMinimap.version)
	XMinimapGUI1_XA_Text:SetText(XBar.Lng["XM"]["Anchor"])
	XMinimapGUI1_Size_Text:SetText(XBar.Lng["XM"]["Size"])
	XMinimapGUI1_Style_Text:SetText(XBar.Lng["XM"]["Style"])
	XMinimapGUI1_Title_CB_Text:SetText(XBar.Lng["XM"]["Zone"])
	XMinimapGUI1_Time_CB_Text:SetText(XBar.Lng["XM"]["Time"])
	XMinimapGUI1_Coord_CB_Text:SetText(XBar.Lng["XM"]["Coord"])
	XMinimapGUI2_Bull_Text:SetText(BULLETINBOARD)
	XMinimapGUI2_Npc_Text:SetText(UI_NPCTRACK_TITLE)
	XMinimapGUI2_BS_Text:SetText(BSF_STR_TITLE)
	XMinimapGUI2_Store_Text:SetText(ACCOUNT_SHOP)
	XMinimapGUI2_QT_Text:SetText(UI_MINIMAP_QUESTSCHEDULE)
	XMinimapGUI2_Option_Text:SetText(UI_MINIMAP_OPTION)
	XMinimapGUI2_BG_Text:SetText(BATTLE_GROUND_NAME)
	XMinimapGUI2_RUI_Text:SetText(GCF_TEXT_RESTORE)
	XMinimapGUI2_Plus_Text:SetText(BINDING_NAME_MINIMAPZOOMIN)
	XMinimapGUI2_Minus_Text:SetText(BINDING_NAME_MINIMAPZOOMOUT)
	XMinimapGUI2_PB_Text:SetText(PARTY_BOARD_TITLE1)
	XMinimapGUI2_Pet_Text:SetText(PET_FRAME_BUTTON)
	XMinimapGUI2_PCard_Text:SetText(SYSTEM_PETBOOK)
	XMinimapGUI2_WBG_Text:SetText(WORLD_BATTLE_GROUND_BUTTON)
	XMinimapTab_1:SetText(XBar.Lng["XM"]["Tab1"])
	XMinimapTab_2:SetText(XBar.Lng["XM"]["Tab2"])
end

function XMinimap.Disable(on)
	if on==false then
		XMinimapGUI1_XA:Disable()
		XMinimapGUI1_Size:Disable()
		XMinimapGUI1_X:Disable()
		XMinimapGUI1_Y:Disable()
		XMinimapGUI1_Switch:Disable()
		XMinimapGUI1_StyleButton:Disable()
		for i, v in ipairs(frames) do
			_G["XMinimapGUI1_"..v.."_CB"]:Disable()
			_G["XMinimapGUI1_"..v.."_XA"]:Disable()
			_G["XMinimapGUI1_"..v.."_X"]:Disable()
			_G["XMinimapGUI1_"..v.."_Y"]:Disable()
		end
	else
		XMinimapGUI1_XA:Enable()
		XMinimapGUI1_Size:Enable()
		XMinimapGUI1_X:Enable()
		XMinimapGUI1_Y:Enable()
		XMinimapGUI1_Switch:Enable()
		XMinimapGUI1_StyleButton:Enable()
		for i, v in ipairs(frames) do
			_G["XMinimapGUI1_"..v.."_CB"]:Enable()
			_G["XMinimapGUI1_"..v.."_XA"]:Enable()
			_G["XMinimapGUI1_"..v.."_X"]:Enable()
			_G["XMinimapGUI1_"..v.."_Y"]:Enable()
		end
	end
end

function XMinimap.Save()
	XMinimapSet["Enable"] = XMinimapGUI1_CB:IsChecked()
	XMinimapSet["Anchor"] = XMinimapGUI1_XA:IsChecked()
	XMinimapSet["X"] = tonumber(XMinimapGUI1_X:GetText())
	XMinimapSet["Y"] = tonumber(XMinimapGUI1_Y:GetText())
	XMinimapSet["Size"] = XMinimapGUI1_Size:GetText()
	XMinimapSet["Style"] = UIDropDownMenu_GetSelectedID(XMinimapGUI1_Style)
	for i, v in ipairs(frames) do
		XMinimapSet[v] = _G["XMinimapGUI1_"..v.."_CB"]:IsChecked()
		XMinimapSet[v.."_Anchor"] = _G["XMinimapGUI1_"..v.."_XA"]:IsChecked()
		XMinimapSet[v.."_X"] = tonumber(_G["XMinimapGUI1_"..v.."_X"]:GetText())
		XMinimapSet[v.."_Y"] = tonumber(_G["XMinimapGUI1_"..v.."_Y"]:GetText())
	end
	for i, v in ipairs(mapbtn) do
		XMinimapSet["MB_"..v] = _G["XMinimapGUI2_"..v]:IsChecked()
	end
	Print("|cffFFBB55XMinimap|r %s", XBar.Lng["XM"]["Saved"])
	XMinimap.Var()
end

function XMinimap.Default()
	for k, v in pairs(def) do
		XMinimapSet[k] = v
	end
	XMinimap.OnShow()
	XMinimap.Var()
end

function XMinimap.Pre(this)
	pre = this:GetName()
end

function XMinimap.OnHide()
	XMinimapGUI1:Hide()
	XMinimapGUI2:Hide()
	XMinimapTab:Hide()
end

function XMinimap.Page(v)
	if pre then
		_G[pre]:Hide()
	end
	_G[v]:Show()
	pre = v
end

function XMinimap.Pos(this, v)
	if not XBARVERSION then
		this:StopMovingOrSizing()
		local point, relativeP, relativeTo, x, y = this:GetAnchor()
		_G[v]:ClearAllAnchors()
		_G[v]:SetAnchor(point, relativeP, relativeTo, x, y)
	end
end

function XMinimap.Title(v)
	XMinimapFTitle_Text:SetText("")
	XMinimapFTitle_Text:SetText(v or GetZoneName())
	local w = XMinimapFTitle_Text:GetWidth()
	if w>170 then
		XMinimapFTitle:SetHeight(math.ceil(w/160)*20+6)
		XMinimapFTitle_Text:SetSize(170, math.ceil(w/160)*20+6)
	else
		XMinimapFTitle:SetHeight(24)
		XMinimapFTitle_Text:SetSize(170, 24)
	end
end

-- wrote by ibuffyou, I fixed.
local function ZoomOut()
	if g_MinimapDate.ZoomIndex>table.getn(g_minimapZooms) then
		g_MinimapDate.ZoomIndex = table.getn(g_minimapZooms)
	end
	if g_MinimapDate.ZoomIndex>1 then
		g_MinimapDate.ZoomIndex = g_MinimapDate.ZoomIndex - 1
		SetMiniMapZoomValue(g_minimapZooms[g_MinimapDate.ZoomIndex])
	end
end

local function ZoomIn()
	if g_MinimapDate.ZoomIndex<table.getn(g_minimapZooms) then
		g_MinimapDate.ZoomIndex = g_MinimapDate.ZoomIndex + 1
		SetMiniMapZoomValue(g_minimapZooms[g_MinimapDate.ZoomIndex])
	end
end

function MinimapZoomOverlayFrame_OnLoad()
	if adMinimapHealRange then
		g_minimapZooms = { 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6 }
	elseif not Streamline then
		g_minimapZooms = { 0.18, 0.28, 0.38, 0.49, 0.61, 0.74, 0.88, 1.03, 1.2, 1.38, 1.59, 1.82, 2.09, 2.4, 2.79, 3.2, 3.6, 4, 4.5, 5, 5.5, 6 }
	end
end

function MinimapZoomOverlayFrame_OnMouseWheel(delta)
	if delta<0 then
		ZoomOut()
	else
		ZoomIn()
	end
end

OnClick_MinimapPlusButton = ZoomIn
OnClick_MinimapMinusButton = ZoomOut