--/run dofile("interface/addons/DungeonLoots/lua/worldmap.lua")
local me = DL.worldmap

local lastmapID = GetCurrentWorldMapID()

function me.Show(instance, npc)
	if instance then
		WorldMapFrame:Show()
		if npc then
			if DL.tbls.instance[instance] then
				for i=1,#DL.tbls.instance[instance].boss do
					if DL.tbls.instance[instance].boss[i].id == npc then
						WorldMapFrame_SetWorldMapID(DL.tbls.instance[instance].boss[i].pos.map or instance)
						return
					end
				end
				WorldMapFrame_SetWorldMapID(instance)
			end	
		else
			if DL.tbls.instance[instance] then
				WorldMapFrame_SetWorldMapID(DL.tbls.instance[instance].zone)			
			end
		end
	end
end

function me.ShowInDL(map, boss)
	DL.ui.listtype = 0 -- instancelist
	if boss then
		DL.ui.listid = 2 -- items
	else
		DL.ui.listid = 1 -- bosses
	end
	DL.ui.instanceid = map
	DL.ui.bossid = boss
	if DL_main_frame:IsVisible() then
		DL.ui.FilterList()
	else
		DL_main_frame:Show()
	end
	DL.ui.SetChangerText()
end

function me.OnClick(this, key)
	if key == "LBUTTON" then
		if this.vars.zone then
			if DL.tbls.instance[this.vars.zone] then
				if IsAltKeyDown() then
					me.ShowInDL(this.vars.map_id, this.vars.main or this.vars.id)
				else
					if DL.tbls.instance[this.vars.zone].boss[1].pos.map	then
						WorldMapFrame_SetWorldMapID(DL.tbls.instance[this.vars.zone].boss[1].pos.map)
						return
					end
				end
			end
			WorldMapFrame_SetWorldMapID(this.vars.zone)
		elseif this.vars.id then
			if IsAltKeyDown() then
				if IsCtrlKeyDown() then
					GC_OpenWebRadio("http://www.rom-welten.de/database/view.php?id="..this.vars.id)
					return
				end
				me.ShowInDL(this.vars.map_id, this.vars.main or this.vars.id)
			elseif IsShiftKeyDown() then
				DL_PreviewFrame:Show()
				DL_PreviewFrameModel:SetModel(this.vars.id)
			end
		end
	else -- RBUTTON
		if this.vars.zone then -- Instanceportal
			DL_WorldMap_Instance_Dropdown.vars = this.vars
			ToggleDropDownMenu( DL_WorldMap_Instance_Dropdown, 1, nil, "cursor", 1 ,1 )
		elseif this.vars.id then -- Bosspos
			DL_WorldMap_Boss_Dropdown.vars = this.vars
			ToggleDropDownMenu( DL_WorldMap_Boss_Dropdown, 1, nil, "cursor", 1 ,1 )
		end
	end
end

function me.OnEnter(this)
	if not this.vars then
		return
	end
	GameTooltip:SetOwner(WorldMapViewFrame, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:ClearAllAnchors()
	GameTooltip:SetAnchor("BOTTOMRIGHT", "BOTTOMRIGHT", WorldMapViewFrame, 0, 0)
	GameTooltip:Show();
	local txt,tbl = "", {}
	if this.vars.zone then
		txt,tbl = DL.helper.GetInstanceTooltip(this.vars.zone)
		if me.tp.instance[this.vars.zone] then -- teleport tooltip
			table.insert(tbl,"<SEP>")
			table.insert(tbl,TEXT("_glossary_00803"))
		
			for i=1,#me.tp.instance[this.vars.zone] do
				table.insert(tbl,me.tp.instance[this.vars.zone][i].note)
			end
		end
	elseif this.vars.id then
		txt,tbl = DL.helper.GetBossMapTooltip(this.vars)
		if me.tp.instance[this.vars.id] then -- teleport tooltip
			table.insert(tbl,"<SEP>")
			table.insert(tbl,TEXT("_glossary_00803"))
		
			for i=1,#me.tp.instance[this.vars.id] do
				table.insert(tbl,me.tp.instance[this.vars.id][i].note)
			end
		end
	end
	GameTooltip:SetText(txt);
	for i=1,#tbl do
		if tbl[i] == "<SEP>" then
			GameTooltip:AddSeparator()
		else
			GameTooltip:AddLine(tbl[i])
		end
	end
end

function me.GetPOISByMap(MapID, map_id2)
	local tbl = {}
	if DL.tbls.zone[MapID] and not map_id2 then
		for zid,pos in pairs(DL.tbls.zone[MapID]) do
			if type(pos) =="table" then
				if DL_Settings.DLInstanceEnabled then
					table.insert(tbl,{zone=zid,pos={x=pos.x,y=pos.y},instance = true})
					if pos.val then
						local t2 = me.GetPOISByMap(zid, MapID)
						for i=1,#t2 do
							table.insert(tbl,t2[i])
						end			
					end
				end
			else
				local t2 = me.GetPOISByMap(zid, MapID)
				for i=1,#t2 do
					table.insert(tbl,t2[i])
				end
			end
		end
	end
	if DL.tbls.instance[MapID] and DL_Settings.DLBossesEnabled then
		local bosses = DL.tbls.instance[MapID].boss
		local minus = 0
		for i=1,#bosses do
			if bosses[i].nocount then
				minus = minus +1
			end
			if bosses[i].pos and (not bosses[i].pos.map or (bosses[i].pos.map and map_id2 and bosses[i].pos.map==map_id2)) then
				table.insert(tbl,{
					id=bosses[i].id,
					pos = bosses[i].pos,
					loot = bosses[i].loot,
					box = bosses[i].box,
					worldboss = bosses[i].worldboss,
					note = bosses[i].note,
					visible = bosses[i].visible,
					num=i-minus,
					map_id = MapID,
					}
				)
				if bosses[i].id2 then
					for j=1,#bosses[i].id2 do
						table.insert(tbl,{
							id=bosses[i].id2[j].id,
							pos = bosses[i].id2[j].pos,
							loot = bosses[i].id2[j].loot,
							worldboss = bosses[i].id2[j].worldboss,
							box = bosses[i].id2[j].box,
							visible = bosses[i].id2[j].visible,
							num=i-minus,
							main = bosses[i].id,
							map_id = MapID,
							}
						)
					end
				end
			end
		end
	end
	return tbl
end

function me.DrawPOIS(MapID)
	if not MapID then
		MapID = GetCurrentWorldMapID()
	end
	lastmapID = MapID
	if DL_Settings.DLWorldmapEnabled then
		local tbl = me.GetPOISByMap(MapID)
		for i=1,30 do
			if tbl[i] and tbl[i].pos and tbl[i].pos.x and tbl[i].pos.y then -- Instance entrance
				_G["DungeonLoot_WM_POI_Tex"..i]:ClearAllAnchors()
				local xx,yy=WorldMapViewFrame:GetSize()
				_G["DungeonLoot_WM_POI_Tex"..i]:SetAnchor("CENTER","TOPLEFT","WorldMapViewFrame",xx*tbl[i].pos.x,yy*tbl[i].pos.y)
				if tbl[i].zone then
					_G["DungeonLoot_WM_POI_Tex"..i].vars = tbl[i]
					 me.SetTexture(i,true,nil,nil,true)
				elseif tbl[i].id then -- Boss
					_G["DungeonLoot_WM_POI_Tex"..i].vars = tbl[i]
					 me.SetTexture(i,false,tbl[i].loot,tbl[i].box,tbl[i].visible,tbl[i].worldboss)			
				end
				if me.tp.instance[tbl[i].zone] or me.tp.instance[tbl[i].id] then
					_G["DungeonLoot_WM_POI_Tex"..i.."Teleport"]:Show()
				else
					_G["DungeonLoot_WM_POI_Tex"..i.."Teleport"]:Hide()			
				end
				_G["DungeonLoot_WM_POI_Tex"..i]:Show()
			else
				_G["DungeonLoot_WM_POI_Tex"..i].vars = nil
				_G["DungeonLoot_WM_POI_Tex"..i]:Hide()
			end
		end
	else
		for i=1,30 do
			_G["DungeonLoot_WM_POI_Tex"..i].vars = nil
			_G["DungeonLoot_WM_POI_Tex"..i]:Hide()
		end
	end
end

function me.SetTexture(id,instance,loot,box,visible, worldboss)
	if not(id>30 or id <=0 or type(id)~="number") then
		local frame = _G["DungeonLoot_WM_POI_Tex"..id]
		if visible then
			frame:Show()
		else
			frame:Hide()
		end
		if instance then
			_G[frame:GetName().."Tex"]:SetFile("interface/addons/DungeonLoots/images/ini.tga")
		else
			if loot then
				if box then
					if worldboss then
						_G[frame:GetName().."Tex"]:SetFile("interface/addons/DungeonLoots/images/kiste.tga")				
					else
						_G[frame:GetName().."Tex"]:SetFile("interface/addons/DungeonLoots/images/kiste.tga")
					end
				else
					if worldboss then
						_G[frame:GetName().."Tex"]:SetFile("interface/targetframe/targetframe-bossicon.tga")						
					else
						_G[frame:GetName().."Tex"]:SetFile("interface/addons/DungeonLoots/images/boss2.tga")
					end
				end
			else
				if worldboss then
					_G[frame:GetName().."Tex"]:SetFile("interface/targetframe/targetframe-bossicon.tga")					
				else
					_G[frame:GetName().."Tex"]:SetFile("interface/addons/DungeonLoots/images/boss1.tga")	
				end
			end
		end
	end
end
-- /run local aa = WorldMapFrame_SetWorldMapID WorldMapFrame_SetWorldMapID=function(id) aa(id) print(id) end
local DL_WorldMapFrame_SetWorldMapID = WorldMapFrame_SetWorldMapID
function WorldMapFrame_SetWorldMapID( MapID )
	DL_WorldMapFrame_SetWorldMapID( MapID )
	if DL.tbls.zoneoverride[MapID] then
		MapID = DL.tbls.zoneoverride[MapID]
	end
	me.DrawPOIS(MapID)
end

function me.Init()
	me.WoWMap()

	DL_WorldMap_Setting_DropdownButton:SetText(DL.lang.WorldmapButton or "")
	if yGather_WorldmapButton then
		DL_WorldMap_Setting_DropdownButton:ClearAllAnchors()
		DL_WorldMap_Setting_DropdownButton:SetAnchor("LEFT","RIGHT","yGather_WorldmapButton",20,0)
	end
	UIDropDownMenu_Initialize(DL_WorldMap_Instance_Dropdown, me.InstanceDropdown);
	UIDropDownMenu_Initialize(DL_WorldMap_Boss_Dropdown, me.Bossdropdown);
	UIDropDownMenu_Initialize(DL_WorldMap_Setting_Dropdown, me.SettingDropdown);
	me.CollectTransport()
end

function me.CheckDistance(x1,y1,x2,y2)
	local x = x1-x2
	local y = y1-y2
	local dist = math.sqrt((x*x)+(y*y))
	if dist < 4 then
		return true
	end
end

function me.CollectTransport()
	me.tp = {instance={}, porter={}}
	for i=1,49 do
		local IconType,Note,ZoneID,X,Y,Z,Name,file=TB_GetTeleportInfo(i);
		if ZoneID < 10000 then
			ZoneID = ZoneID % 1000
		end
		if ZoneID==0 then
		
		else
			local zone = DL.tbls.zone[ZoneID] 
			if zone then --instance check
				for instance, pos in pairs(zone) do
					if type(pos)== "table" then
						local x,y = string.match(Name, "(%d+%.%d),(%d+%.%d)")
						if x and y then
							if me.CheckDistance(x,y,pos.x*100,pos.y*100) then
								me.tp.porter[i]=true
								if not me.tp.instance[instance] then
									me.tp.instance[instance] = {}
								end
								table.insert(me.tp.instance[instance],
									{tpid = i, zone=ZoneID, name = Name, note= Note}
								)
							end
						end
					end
				end
			end
			local zone = DL.tbls.instance[ZoneID]
			if zone then
				local boss = zone.boss
				for z=1,#boss do
					local pos = boss[z].pos
					if pos then
						local x,y = string.match(Name, "(%d%d.%d),(%d%d.%d)")
						if x and y then
							if me.CheckDistance(x,y,pos.x*100,pos.y*100) then
								me.tp.porter[i]=true
								if not me.tp.instance[boss[z].id] then
									me.tp.instance[boss[z].id] = {}
								end
								table.insert(me.tp.instance[boss[z].id],
									{tpid = i, zone=ZoneID, name = Name, note= Note}
								)
							end
						end
					end
				end
			end

			if DL.tbls.translate_table[ZoneID] then
				for zid, val in pairs(DL.tbls.translate_table[ZoneID]) do
					local x1 = val[1]
					local x2 = val[3]
					local y1 = val[2]
					local y2 = val[4]
					local x,y = nil, nil
                    if x1-x2~=0 then
                        x=math.abs((1-(X-x2)/(x1-x2))*100)
					end
                    if y1-y2~=0 then
                        y=math.abs((1-(Z-y2)/(y1-y2))*100)
					end
					local zone = DL.tbls.zone[zid] 
					if zone then --instance check
						for instance, pos in pairs(zone) do
							if type(pos)== "table" then
								if x and y then
									if me.CheckDistance(x,y,pos.x*100,pos.y*100) then
										--me.tp.porter[i]=true -- don't hide these pois
										if not me.tp.instance[instance] then
											me.tp.instance[instance] = {}
										end
										table.insert(me.tp.instance[instance],
											{tpid = i, zone=zid, name = Name, note= Note}
										)
									end
								end
							end
						end
					end
					local zone = DL.tbls.instance[zid]
					if zone then
						local boss = zone.boss
						for z=1,#boss do
							local pos = boss[z].pos
							if pos then
								if x and y then
									if me.CheckDistance(x,y,pos.x*100,pos.y*100) then
										--me.tp.porter[i]=true -- don't hide these pois
										if not me.tp.instance[boss[z].id] then
											me.tp.instance[boss[z].id] = {}
										end
										table.insert(me.tp.instance[boss[z].id],
											{tpid = i, zone=zid, name = Name, note= Note}
										)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function me.Bossdropdown()
	local vars = DL_WorldMap_Boss_Dropdown.vars
	if not vars then return end
	local menuitem = {};
	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
		menuitem.notCheckable = 1;
		menuitem.text = TEXT("Sys"..vars.id.."_name")
		menuitem.isTitle = 1
		UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL);

		menuitem = {}
		--------------------------- ShowInDL ---------------------------
		menuitem.text = DL.lang.ShowInDL
		menuitem.func = function() 
			me.ShowInDL(vars.map_id, vars.main or vars.id)
		end
		UIDropDownMenu_AddButton(menuitem,UIDROPDOWNMENU_MENU_LEVEL)
	
	
		--------------------------- RomWelten ---------------------------
		menuitem.text = DL.lang.ShowInDB
		menuitem.func = function() 
			GC_OpenWebRadio("http://www.rom-welten.de/database/view.php?id="..vars.id)
		end
		UIDropDownMenu_AddButton(menuitem,UIDROPDOWNMENU_MENU_LEVEL)
	
		--------------------------- Preview ---------------------------
		menuitem.text = TEXT("FST_PREVIEW")
		menuitem.func = function() 
			DL_PreviewFrame:Show()
			DL_PreviewFrameModel:SetModel(vars.id)
		end
		UIDropDownMenu_AddButton(menuitem,UIDROPDOWNMENU_MENU_LEVEL)
	
			--------------------------- Teleport ---------------------------
		menuitem = {}
		menuitem.hasArrow = 1
		if vars.id and me.tp.instance[vars.id] and #me.tp.instance[vars.id]>0 then
			for i=1, #me.tp.instance[vars.id] do
				menuitem.text = me.tp.instance[vars.id][i].note --del port
				menuitem.value = i
				UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL)
			end
		end
	elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then -- tp
		menuitem.notCheckable = 1;
		menuitem.text = me.tp.instance[vars.id][UIDROPDOWNMENU_MENU_VALUE].name
		menuitem.isTitle = 1
		UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL);

		local tp_id = me.tp.instance[vars.id][UIDROPDOWNMENU_MENU_VALUE].tpid
        menuitem = {}
        menuitem.text   = TEXT("TB_EDITNOTE_TIP")
        menuitem.func = function ()
                TeleportBook.select = tp_id
                TB_EditNote_OnClick(nil)
            end
        UIDropDownMenu_AddButton( menuitem, UIDROPDOWNMENU_MENU_LEVEL )
	
        menuitem = {}
        menuitem.text   = TEXT("TB_DELETE_TIP")
        menuitem.hasArrow = 1
		menuitem.value = tp_id
        UIDropDownMenu_AddButton( menuitem, UIDROPDOWNMENU_MENU_LEVEL )
	
        local _, transport,portal,passageway=TB_GetTeleportItem()
        menuitem = {}
        menuitem.text = TEXT("TB_TELEPORT_TYPE1")
        menuitem.tooltipTitle = string.format(TB_TELEPORT_TIP,TB_GetItemName(2))
        menuitem.disabled = 1
        if transport then menuitem.disabled = nil end
        menuitem.func = function ()
            TB_Teleport(0, tp_id)
            HideUIPanel( WorldMapFrame )
        end
        UIDropDownMenu_AddButton( menuitem, UIDROPDOWNMENU_MENU_LEVEL )
	
        menuitem.text = TEXT("TB_TELEPORT_TYPE2")
        menuitem.tooltipTitle = string.format(TB_TELEPORT_TIP,TB_GetItemName(3))
        menuitem.disabled = 1
        if portal then menuitem.disabled = nil end
        menuitem.func = function ()
            TB_Teleport(1, tp_id)
            HideUIPanel( WorldMapFrame )
        end
        UIDropDownMenu_AddButton( menuitem, UIDROPDOWNMENU_MENU_LEVEL )
	
        menuitem.text = TEXT("TB_TELEPORT_TYPE3")
        menuitem.tooltipTitle = string.format(TB_TELEPORT_TIP,TB_GetItemName(4))
        menuitem.disabled = 1
        if passageway then menuitem.disabled = nil end
        menuitem.func = function ()
            TB_Teleport(2, tp_id)
            HideUIPanel( WorldMapFrame )
        end
        UIDropDownMenu_AddButton( menuitem, UIDROPDOWNMENU_MENU_LEVEL )
	
	elseif UIDROPDOWNMENU_MENU_LEVEL == 3 then -- delete
        menuitem = {}
        menuitem.text   = TEXT("TB_DELETE_TIP")
        menuitem.func = function ()
            TB_DeleteTeleport(UIDROPDOWNMENU_MENU_VALUE)
			ToggleDropDownMenu(DL_WorldMap_Instance_Dropdown)
        end
        UIDropDownMenu_AddButton( menuitem, UIDROPDOWNMENU_MENU_LEVEL )
	end
end

function me.InstanceDropdown()
	local menuitem = {};
	local vars = DL_WorldMap_Instance_Dropdown.vars

	if not vars then return end
	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
		menuitem.notCheckable = 1;
		menuitem.text = GetZoneLocalName(vars.zone or 1)
		menuitem.isTitle = 1
		UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL);

		menuitem = {}
		--------------------------- ChangeMap ---------------------------
		menuitem.text = TEXT("UI_WORLDMAP_SELECT_MAP") -- ChangeMap
		menuitem.func = function()
			if DL.tbls.instance[vars.zone] and DL.tbls.instance[vars.zone].boss[1].pos.map	then
				WorldMapFrame_SetWorldMapID(DL.tbls.instance[vars.zone].boss[1].pos.map)
				return
			end
			WorldMapFrame_SetWorldMapID(vars.zone)
		end
		UIDropDownMenu_AddButton(menuitem,UIDROPDOWNMENU_MENU_LEVEL)
	
		--------------------------- ShowInDL ---------------------------
		if not DL.tbls.instance[vars.zone or 0] then
			menuitem.disabled = 1
		end
		menuitem.text = DL.lang.ShowInDL
		menuitem.func = function() 
			me.ShowInDL(vars.zone, nil)
		end
		UIDropDownMenu_AddButton(menuitem,UIDROPDOWNMENU_MENU_LEVEL)
	
		--------------------------- Teleport ---------------------------
		menuitem = {}
		menuitem.hasArrow = 1
		local pos = vars.pos
		if vars.zone and me.tp.instance[vars.zone] and #me.tp.instance[vars.zone]>0 then
			for i=1, #me.tp.instance[vars.zone] do
				menuitem.text = me.tp.instance[vars.zone][i].note --del port
				menuitem.value = i
				UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL)
			end
		end
	elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then -- tp
		menuitem.notCheckable = 1;
		menuitem.text = me.tp.instance[vars.zone][UIDROPDOWNMENU_MENU_VALUE].name
		menuitem.isTitle = 1
		UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL);

		local tp_id = me.tp.instance[vars.zone][UIDROPDOWNMENU_MENU_VALUE].tpid
        menuitem = {}
        menuitem.text   = TEXT("TB_EDITNOTE_TIP")
        menuitem.func = function ()
                TeleportBook.select = tp_id
                TB_EditNote_OnClick(nil)
            end
        UIDropDownMenu_AddButton( menuitem, UIDROPDOWNMENU_MENU_LEVEL )
	
        menuitem = {}
        menuitem.text   = TEXT("TB_DELETE_TIP")
        menuitem.hasArrow = 1
		menuitem.value = tp_id
        UIDropDownMenu_AddButton( menuitem, UIDROPDOWNMENU_MENU_LEVEL )
	
        local _, transport,portal,passageway=TB_GetTeleportItem()
        menuitem = {}
        menuitem.text = TEXT("TB_TELEPORT_TYPE1")
        menuitem.tooltipTitle = string.format(TB_TELEPORT_TIP,TB_GetItemName(2))
        menuitem.disabled = 1
        if transport then menuitem.disabled = nil end
        menuitem.func = function ()
            TB_Teleport(0, tp_id)
            HideUIPanel( WorldMapFrame )
        end
        UIDropDownMenu_AddButton( menuitem, UIDROPDOWNMENU_MENU_LEVEL )
	
        menuitem.text = TEXT("TB_TELEPORT_TYPE2")
        menuitem.tooltipTitle = string.format(TB_TELEPORT_TIP,TB_GetItemName(3))
        menuitem.disabled = 1
        if portal then menuitem.disabled = nil end
        menuitem.func = function ()
            TB_Teleport(1, tp_id)
            HideUIPanel( WorldMapFrame )
        end
        UIDropDownMenu_AddButton( menuitem, UIDROPDOWNMENU_MENU_LEVEL )
	
        menuitem.text = TEXT("TB_TELEPORT_TYPE3")
        menuitem.tooltipTitle = string.format(TB_TELEPORT_TIP,TB_GetItemName(4))
        menuitem.disabled = 1
        if passageway then menuitem.disabled = nil end
        menuitem.func = function ()
            TB_Teleport(2, tp_id)
            HideUIPanel( WorldMapFrame )
        end
        UIDropDownMenu_AddButton( menuitem, UIDROPDOWNMENU_MENU_LEVEL )
	
	elseif UIDROPDOWNMENU_MENU_LEVEL == 3 then -- delete
        menuitem = {}
        menuitem.text   = TEXT("TB_DELETE_TIP")
        menuitem.func = function ()
            TB_DeleteTeleport(UIDROPDOWNMENU_MENU_VALUE)
			ToggleDropDownMenu(DL_WorldMap_Instance_Dropdown)
        end
        UIDropDownMenu_AddButton( menuitem, UIDROPDOWNMENU_MENU_LEVEL )
	end
end

function me.SettingDropdown()
	local menuitem = {};
	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
		menuitem.notCheckable = 1;
		menuitem.text = DL.lang.WorldmapButton
		menuitem.isTitle = 1
		UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL);

		menuitem = {}
		menuitem.keepShownOnClick = 1;
		menuitem.text = DL.lang.HideWoWMapZone
		menuitem.checked = DL_Settings.WoWMapInstanceDisabled
		menuitem.func = function()
			DL_Settings.WoWMapInstanceDisabled=not DL_Settings.WoWMapInstanceDisabled
		end
		UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL);
	
		menuitem = {};
		menuitem.keepShownOnClick = 1;
		menuitem.text = DL.lang.HideWoWMapTeleport
		menuitem.checked = DL_Settings.WoWMapTPPOIDisabled
		menuitem.func = function()
			DL_Settings.WoWMapTPPOIDisabled=not DL_Settings.WoWMapTPPOIDisabled
			WoWMapPOI.CollectTransportPOIs()
			WorldMapFrame_SetWorldMapID(lastmapID)
		end
		UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL);
	
		menuitem = {};
		menuitem.keepShownOnClick = 1;
		menuitem.text = DL.lang.UseDLPoi
		menuitem.checked = DL_Settings.DLWorldmapEnabled
		menuitem.func = function()
			DL_Settings.DLWorldmapEnabled=not DL_Settings.DLWorldmapEnabled
			if DL_Settings.DLWorldmapEnabled then
				DropDownList1Button5:Enable()
				DropDownList1Button6:Enable()
			else
				DropDownList1Button5:Disable()
				DropDownList1Button6:Disable()
			end
			me.DrawPOIS(lastmapID)
		end
		UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL);
	
		menuitem = {};
		menuitem.keepShownOnClick = 1;
		menuitem.text = DL.lang.UseDLInstancePoi
		if not DL_Settings.DLWorldmapEnabled then
			menuitem.disabled = 1
		end
		menuitem.checked = DL_Settings.DLInstanceEnabled
		menuitem.func = function()
			DL_Settings.DLInstanceEnabled=not DL_Settings.DLInstanceEnabled
			me.DrawPOIS(lastmapID)
		end
		UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL);
	
		menuitem = {};
		menuitem.keepShownOnClick = 1;
		menuitem.text = DL.lang.UseDLBossPoi
		if not DL_Settings.DLWorldmapEnabled then
			menuitem.disabled = 1
		end
		menuitem.checked = DL_Settings.DLBossesEnabled
		menuitem.func = function()
			DL_Settings.DLBossesEnabled=not DL_Settings.DLBossesEnabled
			me.DrawPOIS(lastmapID)
		end
		UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL);
	end
end

function me.CollectTransportPOIs()
	assert(WoWMap and WoWMap.Data and WoWMap.Data.POIs) -- call it only if WoWMap-POI is loaded
	me.CollectTransport()
	for i, poi_cat in pairs(WoWMap.Data.POIs) do
		if poi_cat.maps then
			for map_id ,tbl in pairs(poi_cat.maps) do
				local tbl_len = #tbl
				for j=1, tbl_len do
					for a,b in pairs(tbl[tbl_len-j+1]) do
						if a=="TBNr" then
							if me.tp.porter[b] then
								table.remove(WoWMap.Data.POIs[i].maps[map_id], tbl_len-j+1)
							end
						end
					end
				end
			end
		end
	end
end

function me.WoWMap()
--WoWMap workaround
	if WoWMap and WoWMap.Data then
		local version= tonumber(string.match(WoWMap.Data.Version,"v(%d+).+"))
		if version >=4 then
			local DungeonLoot_WorldMapFrame_OnUpdate = WorldMapFrame_OnUpdate
			function WorldMapFrame_OnUpdate(elapsedTime)
				DungeonLoot_WorldMapFrame_OnUpdate(elapsedTime)
				if DL_Settings.WoWMapInstanceDisabled then
					if WoWMap.Data.ZoneID then
						local zid = WoWMap.Data.ZoneID
						if DL.tbls.zone[zid] then
							for a,b in pairs(DL.tbls.zone[zid]) do
								if type(b)=="boolean" and b==true then
									WoWMapHighlight:Hide()
								end
							end
						elseif DL.tbls.instance[zid] and WoWMap.GetCurrentMapID()==DL.tbls.instance[zid].zone then
							WoWMapHighlight:Hide()
						end
						if DL.tbls.zoneoverride[WoWMap.GetCurrentMapID()] then
							zid = DL.tbls.zoneoverride[WoWMap.GetCurrentMapID()]
							if DL.tbls.instance[zid] and WoWMap.GetCurrentMapID()==DL.tbls.instance[zid].zone then
								WoWMapHighlight:Hide()
							end
						end
					end
				end
			end
			if WoWMapPOI then
			    local ori_CollectTransportPOIs =  WoWMapPOI.CollectTransportPOIs
				function WoWMapPOI.CollectTransportPOIs()
					ori_CollectTransportPOIs()
					if DL_Settings.WoWMapTPPOIDisabled then
						me.CollectTransportPOIs()
					end
				end
			end
		end
	end
end
DL.worldmap = me
