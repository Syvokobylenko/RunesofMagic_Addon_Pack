--/run dofile("interface/addons/DungeonLoots/lua/ui.lua")
local me = DL.ui

function me.OnUpdate()
	if me.update then
		if me.update + 0.2 < GetTime() then
			me.FilterList()
			me.update = nil
		end
	end
end

function me.Init()
	me.InitTabs()
	me.InitFrames()
	me.LoadData()
	DL.plus.Init(DL.tbls.items)
end

-------------------------------------------------------
--------------- Load Data function --------------------
-------------------------------------------------------
function me.LoadData()
	for name, b in pairs(DL.tbls) do
		if name ~= "items" then
			local fn, err = loadfile("interface/addons/DungeonLoots/db/"..name..".lua")
			if fn then
				DL.tbls[name] = fn()
			end
			if err then
				print(err)
			end
		end
	end
	DL.tbls.items = {}
	for a,b in pairs(DL.tbls.armor) do
		DL.tbls.items[a]={rarity=GetQualityByGUID(a),name = DL.helper.GetName(a), level = b[2],pos = b[1]}
	end
	for a,b in pairs(DL.tbls.weapon) do
		DL.tbls.items[a]={rarity=GetQualityByGUID(a),name = DL.helper.GetName(a), level = b[2],pos = b[1]}
	end
end

-------------------------------------------------------
--------------- Scrollbar funtions --------------------
-------------------------------------------------------
function me.Scroll(this, delta)
	if (delta > 0) then
		this:SetValue(this:GetValue() - 2);
	elseif (delta < 0) then
		this:SetValue(this:GetValue() + 2);
	end;
end;

function me.OnValueChanged(this)
	local min, max = this:GetMinMaxValues()
	DL_main_frame_ScrollBarScrollDownButton:Enable()
	DL_main_frame_ScrollBarScrollUpButton:Enable()
	if this:GetValue() == min then
		DL_main_frame_ScrollBarScrollUpButton:Disable()
	end
	if this:GetValue() == max then
		DL_main_frame_ScrollBarScrollDownButton:Disable()
	end
	me.RedrawList()
	me.ShowHighlight()
end

-------------------------------------------------------
----------------- List function -----------------------
-------------------------------------------------------

function me.OnEnter(this, id, override)
	if id == nil then return end
	local tt = GameTooltip
	if override then
		tt = DLTooltip
	else
		tt:ClearAllAnchors();
		tt:SetAnchor("CENTER", "CENTER", this:GetName(), 2, 0);
		tt:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 0, 0);
	end
	tt:Hide();
	if id <= 200000 then
		local txt,tbl,tooltip = "", {}, nil
		
		if me.listtype == 3 then -- sufu
			txt,tbl, tooltip = DL.helper.GetSearchTooltip(id)
			if tooltip then
				tt:SetHyperLink(("|Hitem:%x|h|h"):format(tooltip));
				tt:AddSeparator()
				tt:AddLine(txt)
			end
		elseif me.listtype == 1 then -- Bosslist
			if me.listid == 1 then -- bosses		
				txt,tbl = DL.helper.GetBossTooltip(id)
			end		
		elseif me.listtype == 0 then -- instancelist
			if me.listid == 0 then -- instances
				txt,tbl = DL.helper.GetInstanceTooltip(id)
			elseif me.listid == 1 then -- bosses
				txt,tbl = DL.helper.GetBossTooltip(id, true, me.instanceid)			
			end
		end
		if not (me.listtype == 3 and tooltip) then
			tt:SetText(txt);
		end
		for i=1,#tbl do
			if tbl[i] == "<SEP>" then
				tt:AddSeparator()
			else
				tt:AddLine(tbl[i])
			end
		end
	elseif id >= 510000 and id < 520000 then
		local link = string.format("%x 1 0 %04x 0 0 0 0 0 0 0", 202840, id - 500000) -- Manastein
		local hash = DL.plus.CalculateItemLinkHash(link)
		link = string.format("|Hitem:%s %x|htest|h", link, hash)
		tt:SetHyperLink(link)	
	else
		tt:SetHyperLink(("|Hitem:%x|h|h"):format(id));
	end
	local r, g, b = GetItemQualityColor(GetQualityByGUID(id))
	tt:AddLine(string.format("|cff%02x%02x%02xID: %d", r*0xff, g*0xff, b*0xff, id))
	GameTooltip1:Hide()
	GameTooltip2:Hide()
end

function me.HeaderOnEnter(this, id)
	if me.listid <= 0 then
		GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 0, 0);
		GameTooltip:SetText(DL.lang.ChangeSortOrder)
		if not DL_Settings.SortByName then
			GameTooltip:AddLine(string.format(DL.lang.InstanceOrder, TEXT("C_NAME")))		
		else
			GameTooltip:AddLine(string.format(DL.lang.InstanceOrder, TEXT("C_LEVEL")))		
		end
		GameTooltip:AddLine(this:GetText())
		GameTooltip:Show();
	end
end

function me.SetHeaderText()
	if me.listtype == 3 then
		DL_main_frame_list_Button0:SetText(DL.lang.SearchList)
	else
		if me.listtype == 0 then
			DL_main_frame_list_Button0:SetText(DL.lang.InstanceList)
		elseif me.listtype == 1 then
			DL_main_frame_list_Button0:SetText(DL.lang.BossList)
		elseif me.listtype == 2 then
			DL_main_frame_list_Button0:SetText(DL.lang.ItemList)
		elseif me.listtype == 4 then
			DL_main_frame_list_Button0:SetText(DL.lang.TreasureList)
		end
		local txt = nil
		if me.instanceid then
			txt = GetZoneLocalName( me.instanceid )
		end
		if me.bossid then
			if txt then txt = txt .. ": " end
			txt = string.format("%s%s", txt or "", TEXT("Sys"..me.bossid .."_name") or "")
		end
		if me.itemid then
			txt = string.format("%s (%d)", TEXT("Sys"..me.itemid .."_name"), me.itemid)
		end
		if txt then
			DL_main_frame_list_Button0:SetText(txt)
		end
	end
end

--/run print(DL.ui.listtype..DL.ui.listid )
function me.OnClick(id, this, key, double)
	local old_listid = me.listid
	if key == "LBUTTON" then
		local itemLink = nil
		local r, g, b = GetItemQualityColor(GetQualityByGUID(this.id))
		if me.listtype == 3 then -- sufu
			DL.helper.OnSearchResultClick(this.id, key, double)
		elseif me.listtype == 1 or me.listtype == 0 or me.listtype == 2 or me.listtype==4  then -- Bosslist / instancelist / Itemlist /treasurelist
			if me.listid == 0 then -- instances
				if IsAltKeyDown() then -- ShowOnMap
					DL.worldmap.Show(this.id, nil)
					return
				end
				me.instanceid = this.id;
				DL_main_frameSearch:SetText("")
			elseif me.listid == 1 then -- bosses
				if IsAltKeyDown() then -- ShowOnMap
					if IsCtrlKeyDown() then
						GC_OpenWebRadio("http://www.rom-welten.de/database/view.php?id="..this.id)
						return
					end
					DL.worldmap.Show(me.instanceid, this.id)
					return
				end
				if (not IsCtrlKeyDown() and not IsShiftKeyDown())  then
					me.bossid = this.id	
				end
				itemLink = string.format("|Hnpc:%d|h|cffffffff[%s]|r|h", this.id, DL.helper.GetName(this.id) )
				DL_main_frameSearch:SetText("")
			elseif me.listid == 2 then -- items
				if IsCtrlKeyDown() and IsAltKeyDown() then
					GC_OpenWebRadio("http://www.rom-welten.de/database/view.php?id="..this.id)
					return
				end
				if double then
					if DL.tbls.armor[this.id] or DL.tbls.weapon[this.id] then
						me.itemid = this.id
					else
						me.itemid = nil
					end
				else
					if not DL.tbls.treasure[this.id] then
						itemLink = string.format("|Hitem:%x|h|cff%02x%02x%02x[%s]|r|h", this.id, r*0xFF, g*0xFF, b*0xFF, DL.helper.GetName(this.id))
						me.ListSelect = this.id
					end
				end
				DL_main_frameSearch:SetText("")
			elseif me.listid == 3 then -- stats
				-- do nothing
			end
			if not itemLink or (not IsCtrlKeyDown() and not IsShiftKeyDown()) then
				if me.listid < 2 or (me.listid==2 and me.itemid and  me.itemid == this.id) then
					me.listid = me.listid + 1
				end
			end
		end
		if itemLink then
			if( IsShiftKeyDown() ) then
				if( ITEMLINK_EDITBOX )then
					ChatEdit_AddItemLink( itemLink );
					return;
				end
			elseif( IsCtrlKeyDown() ) then
				if this.id < 200000 then
					DL_PreviewFrame:Show()
					DL_PreviewFrameModel:SetModel(this.id)
				else
					ItemPreviewFrame_SetItemLink(DL_PreviewFrame, itemLink );
					me.ChangeModel(this.id)
				end
			end
		end
	elseif key == "RBUTTON" then
		if me.listtype == 3 then -- sufu
			-- do nothing
		else
			me.ListSelect = nil
			if me.listid <= 0 then
				DL_Settings.SortByName = not DL_Settings.SortByName
				me.FilterList()
			elseif me.listid <= 1 then
				me.instanceid = nil;
			elseif me.listid <= 2 then
				me.bossid = nil;			
			elseif me.listid <= 3 then
				me.itemid = nil;
			end
			DL_main_frameSearch:SetText("")
			local listtype = me.listtype
			if listtype ==4 then listtype = 1 end
			if me.listid > listtype then
				me.listid = me.listid - 1
			end
		end
	end
	if me.listid==old_listid then
		me.ShowHighlight()
		return
	else
		me.ListSelect = nil
	end
	me.ShowHighlight()
	me.SetHeaderText()
	me.FilterList()
end

----------------- change functions --------------------
function me.ShowHighlight()
	DL_main_frame_list_Highlight:Hide();
	if me.listtype == 3 then
		if (me.ListSelectSearch ~= nil) then
			for i = 1, 20 do
				if _G["DL_main_frame_list_Button" .. i].id == me.ListSelectSearch then
					DL_main_frame_list_Highlight:ClearAllAnchors();
					DL_main_frame_list_Highlight:SetAnchor("TOPLEFT", "TOPLEFT", DL_main_frame_list, 5, 20 + (i - 1)*20);
					DL_main_frame_list_Highlight:SetAnchor("BOTTOMRIGHT", "TOPRIGHT", DL_main_frame_list, - 5, 40 + (i - 1)*20);
					DL_main_frame_list_Highlight:Show();
				end
			end
		end	
	else
		if (me.ListSelect ~= nil) then
			for i = 1, 20 do
				if _G["DL_main_frame_list_Button" .. i].id == me.ListSelect then
					DL_main_frame_list_Highlight:ClearAllAnchors();
					DL_main_frame_list_Highlight:SetAnchor("TOPLEFT", "TOPLEFT", DL_main_frame_list, 5, 20 + (i - 1)*20);
					DL_main_frame_list_Highlight:SetAnchor("BOTTOMRIGHT", "TOPRIGHT", DL_main_frame_list, - 5, 40 + (i - 1)*20);
					DL_main_frame_list_Highlight:Show();
				end
			end
		end
	end
end

local function FilterName(id, txt)
	local name_id_search = string.lower(DL_main_frameSearch:GetText())
	if string.match(string.lower(txt), name_id_search) then --Clientname search
		return true
	end
	if string.match(id, name_id_search) then -- id search
		return true
	end
	return false
end

function me.FilterList()
	local lst = {}
	-- /run DL.ui.listtype = 4;DL.ui.FilterList()
	
	if me.listtype == 4 then 
		if me.listid == 1 then --treasurelist "boss" (hidden)
			for a,b in pairs(DL.tbls.treasure) do
				table.insert(lst, DL.helper.GetNameRarityByID(a))
			end		
			local function fn(v1,v2)
				if v1.id < v2.id then
					return true
				end
			end
			table.sort(lst,fn)
		elseif me.listid == 2 then -- itemlist
			lst = DL.helper.GetBossLootSortedValues(me.bossid)
		elseif me.listid == 3 then -- stats
			lst = DL.helper.GetItemValues(me.itemid)
		end
	elseif me.listtype == 3 then -- sufu
		lst = DL.helper.GetSearchValues(DL.search.onlyinstance)
	elseif me.listtype == 2 then -- itemlist
		if me.listid == 2 then -- items
			for a,b in pairs(DL.tbls.armor) do
				table.insert(lst, DL.helper.GetNameRarityByID(a))
			end
			for a,b in pairs(DL.tbls.weapon) do
				table.insert(lst, DL.helper.GetNameRarityByID(a))
			end
			local function fn(v1,v2)
				if v1.id < v2.id then
					return true
				end
			end
			table.sort(lst,fn)	
		elseif me.listid == 3 then -- stats
			lst = DL.helper.GetItemValues(me.itemid)
		end
	elseif me.listtype == 1 then -- Bosslist
		if me.listid == 1 then -- bosses
			for a,b in pairs(DL.tbls.npc) do
				table.insert(lst, DL.helper.GetNameRarityByID(a))
			end
			local function fn(v1,v2)
				if v1.id < v2.id then
					return true
				end
			end
			table.sort(lst,fn)
		elseif me.listid == 2 then -- items
			lst = DL.helper.GetBossLootSortedValues(me.bossid)			
		elseif me.listid == 3 then -- stats
			lst = DL.helper.GetItemValues(me.itemid)
		end
	elseif me.listtype == 0 then -- instancelist
		if me.listid == 0 then -- instances
			for a,b in pairs(DL.tbls.instance) do
				table.insert(lst, DL.helper.GetInstanceValues(a))
			end
			local function fn(v1,v2)
				if not DL_Settings.SortByName then
					if v1.level > v2.level then
						return true
					elseif v1.level == v2.level then
						if v1.id > v2.id then
							return true
						end
					end
				else
					if v1.text < v2.text then
						return true
					end				
				end
			end
			table.sort(lst,fn)
		elseif me.listid == 1 then -- bosses
			for i=1, #DL.tbls.instance[me.instanceid].boss do
				local boss = DL.tbls.instance[me.instanceid].boss[i]
				table.insert(lst, DL.helper.GetBossValues(boss.id, true, boss))
			end
		elseif me.listid == 2 then -- items
			lst = DL.helper.GetBossLootSortedValues(me.bossid)
		elseif me.listid == 3 then -- stats
			lst = DL.helper.GetItemValues(me.itemid)		
		end
	end
	me.FilteredList = {} --reset list
	for i=1,#lst do
		if FilterName(lst[i].id,lst[i].text) then
			table.insert(me.FilteredList,lst[i])
		end
	end
	me.ShowHighlight()
	DL.ui.RedrawList()
end

function me.RedrawList()
	local tbl = me.FilteredList
	local maxval = #tbl - 20 + 1
	if (maxval < 1) then maxval = 1; end;
	DL_main_frame_ScrollBar:SetMinMaxValues(1, maxval);
	local val = DL_main_frame_ScrollBar:GetValue();
	for i = 1, 20 do
		local index = i + val - 1;
		if tbl[index] then
			_G["DL_main_frame_list_Button" .. i .. "_txt"]:SetColor(tbl[index].r, tbl[index].g, tbl[index].b)
			_G["DL_main_frame_list_Button" .. i .. "_txt"]:SetText(tbl[index].text)
			_G["DL_main_frame_list_Button" .. i].id = tbl[index].id
			_G["DL_main_frame_list_Button" .. i]:Show()
		else
			_G["DL_main_frame_list_Button" .. i]:Hide()
			_G["DL_main_frame_list_Button" .. i].id = nil
		end
	end
end

function me.CurrentInstanceBossButtonOnClick(zone, boss)
	local zid = GetZoneID() % 1000
	if zone then
		if DL.tbls.instance[zid] then
			DL.helper.ShowInDL(zid, nil, nil)
		end
	end
	if boss then
		local tgt = UnitName("target") 
		if tgt then
			if DL.tbls.instance[zid] then
				for num, boss in pairs(DL.tbls.instance[zid].boss) do
					if TEXT("Sys"..boss.id.."_name") == tgt then
						DL.helper.ShowInDL(zid, boss.id, nil)
						return
					end
					if boss.id2 then
						for i=1,#boss.id2 do
							if TEXT("Sys"..boss.id2[i].id.."_name") == tgt then
								DL.helper.ShowInDL(zid, boss.id, nil)
								return
							end
						end
					end
				end
			end
			
			DL.search.Search(tgt,true, false,true,false,false)
			me.SetListType(3)
			
			me.SetChangerText()
			me.SetHeaderText()
			me.FilterList()
			me.ShowHighlight()
			return				
		end
		if DL.tbls.instance[zid] then
			DL.helper.ShowInDL(zid, nil, nil)
		end		
	end
end

local change_buttons = {	
	"DL_adv_frame_search_Instance",
	"DL_adv_frame_search_Boss",
	"DL_adv_frame_search_Items",
	"DL_adv_frame_search_Search",
	"DL_adv_frame_search_Treasure",
}

function me.SetListType(typ)
	if typ == me.listtype then return end
	DL_main_frameSearch:SetText("")
	me.ListSelect = nil
	me.ListSelectSearch = nil
	if me.listtype==4 then me.listtype = 1 end -- treasure workaround
	if me.listtype <= 0 then
		me.instanceid = nil		
	end
	if me.listtype <= 1 then
		me.bossid = nil
	end
	if me.listtype <= 2 then
		me.itemid = nil
	end
	for i=1,#change_buttons do
		if i==typ+1 then
			_G[change_buttons[i]]:Disable()
		else
			_G[change_buttons[i]]:Enable()
		end
	end
	me.listtype = typ
	
	if typ == 4 then typ=1 end --treasure workaround
	me.listid = typ
end
-------------------------------------------------------------------------
------------------------------- Advanced UI -----------------------------
-------------------------------------------------------------------------

function me.InitTabs()
	local maintabs = {
		{text = TEXT("SOCIAL_SEARCH_PLAYER"), frame = "DL_adv_frame_search", visibleOnShow = true },
		{text = DL.lang.TabTier, frame = "DL_adv_frame_plus"},
		{text = TEXT("CLOSE"), func = loadstring("ToggleUIFrame(DL_adv_frame)")},
	}
	DL_button_SetTab(DL_adv_frame_tabHeader, maintabs)
end

function me.InitFrames()
	me.SetListType(0)
	me.SetHeaderText()
	DL_main_frame_MoreButton:SetText(DL.lang.MoreButton)
	DL_main_frame_info:SetText(string.format(DL.lang.Version, DL.name, DL.version))
	
	DL_main_frame_list_Button0.func = function () me.OnClick(0, 0, "RBUTTON", false) end
	DL_main_frame_list_Button0.ttfunc = function (this, id) me.HeaderOnEnter(this, id) end
	
	me.OnClick(0, 0, "RBUTTON", false)
	
	-- Search Frame ---------------------------------------
	DL_adv_frame_search_CUR_INSTANCE:SetText(DL.lang.ShowInstance)
	DL_adv_frame_search_CUR_Boss:SetText(DL.lang.ShowBoss)
	
	DL_adv_frame_search_Instance:SetText(DL.lang.InstanceList)
	DL_adv_frame_search_Boss:SetText(DL.lang.BossList)
	DL_adv_frame_search_Items:SetText(DL.lang.ItemList)
	DL_adv_frame_search_Treasure:SetText(DL.lang.TreasureList)
	
	DL_adv_frame_search_ColorhelmetDesc:SetText(TEXT(string.format("SYS_EQWEARPOS_%02i", 0)))
	DL_adv_frame_search_ColortorsoDesc:SetText(TEXT(string.format("SYS_EQWEARPOS_%02i", 3)))
	DL_adv_frame_search_ColorbeltDesc:SetText(TEXT(string.format("SYS_EQWEARPOS_%02i", 6)))
	DL_adv_frame_search_ColorlegDesc:SetText(TEXT(string.format("SYS_EQWEARPOS_%02i", 4)))
	DL_adv_frame_search_ColorshoulderDesc:SetText(TEXT(string.format("SYS_EQWEARPOS_%02i", 7)))
	DL_adv_frame_search_ColorhandDesc:SetText(TEXT(string.format("SYS_EQWEARPOS_%02i", 1)))
	DL_adv_frame_search_ColorfootDesc:SetText(TEXT(string.format("SYS_EQWEARPOS_%02i", 2)))
	DL_adv_frame_search_ColorbackDesc:SetText(TEXT(string.format("SYS_EQWEARPOS_%02i", 5)))

	DL_adv_frame_search_OPPOSITE_SEX:SetText(DL.lang.OtherSex)
	DL_adv_frame_search_SEX:SetText(TEXT("SEX"))
	
	----------------------------
	DL_adv_frame_search_Search:SetText(DL.lang.SearchList)
	DL_adv_frame_search_search_Edit_layer:SetText(TEXT("C_SEARCH")..":")
	DL_adv_frame_search_search_boss_Label:SetText(DL.lang.SearchBoss)
	DL_adv_frame_search_search_instance_Label:SetText(DL.lang.SearchInstance)
	DL_adv_frame_search_search_item_Label:SetText(DL.lang.SearchItem)
	DL_adv_frame_search_search_treasure_Label:SetText(DL.lang.SearchTreasure)
	
	DL_adv_frame_search_search_bossinstance_Label:SetText(DL.lang.BossInstance)
	DL_adv_frame_search_search_onlyinstance_Label:SetText(DL.lang.OnlyInstance)
	
	DL_adv_frame_search_search_boss:SetChecked(DL.search.boss)
	DL_adv_frame_search_search_instance:SetChecked(DL.search.instance)
	DL_adv_frame_search_search_item:SetChecked(DL.search.item)
	DL_adv_frame_search_search_treasure:SetChecked(DL.search.treasure)
	
	DL_adv_frame_search_search_bossinstance:SetChecked(DL.search.bossinstance)
	DL_adv_frame_search_search_onlyinstance:SetChecked(DL.search.onlyinstance)
	
	-- Plus Frame ---------------------------------------
	DL_adv_frame_plus_PLUS_layer:SetText(DL.lang.Itemplus)
	DL_adv_frame_plus_TIER_layer:SetText(TEXT("_glossary_00703") .. ":")
	DL_adv_frame_plus_DURA_layer:SetText(TEXT("SYS_ITEM_DURABLE"))
	DL_adv_frame_plus_DURA_Edit:SetText(120)
	DL_adv_frame_plus_RARITY_layer:SetText(DL.lang.Rarity)
	DL_adv_frame_plus_STAT1_layer:SetText(string.format(DL.lang.Stat, 1))
	DL_adv_frame_plus_STAT2_layer:SetText(string.format(DL.lang.Stat, 2))
	DL_adv_frame_plus_STAT3_layer:SetText(string.format(DL.lang.Stat, 3))
	DL_adv_frame_plus_STAT4_layer:SetText(string.format(DL.lang.Stat, 4))
	DL_adv_frame_plus_STAT5_layer:SetText(string.format(DL.lang.Stat, 5))
	DL_adv_frame_plus_STAT6_layer:SetText(string.format(DL.lang.Stat, 6))
	DL_adv_frame_plus_RUNE1_layer:SetText(string.format(DL.lang.Rune, 1))
	DL_adv_frame_plus_RUNE2_layer:SetText(string.format(DL.lang.Rune, 2))
	DL_adv_frame_plus_RUNE3_layer:SetText(string.format(DL.lang.Rune, 3))
	DL_adv_frame_plus_RUNE4_layer:SetText(string.format(DL.lang.Rune, 4))

	DL_adv_frame_plus_bind_Label:SetText(TEXT("SOULBOUND_SOULBOUND"))
	DL_adv_frame_plus_bind.tooltip = TEXT("SOULBOUND_SOULBOUND")
	DL_adv_frame_plus_eqbind_Label:SetText(TEXT("SOULBOUND_EQUIP"))
	DL_adv_frame_plus_eqbind.tooltip = TEXT("SOULBOUND_EQUIP")
	DL_adv_frame_plus_locked_Label:SetText(TEXT("TOOLTIP_LOCKED_ITEM"))
	DL_adv_frame_plus_locked.tooltip = TEXT("TOOLTIP_LOCKED_ITEM")
	DL_adv_frame_plus_itemprotect_Label:SetText(TEXT("SYS_ITEM_PROTECT"))
	DL_adv_frame_plus_itemprotect.tooltip = TEXT("SYS_ITEM_PROTECT")
	DL_adv_frame_plus_pkprotect_Label:SetText(TEXT("SYS_PKPROTECT"))
	DL_adv_frame_plus_pkprotect.tooltip = TEXT("SYS_PKPROTECT")
	DL_adv_frame_plus_suitskillextracted_Label:SetText(TEXT("SYS_SUITSKILL_LOCKED"))
	DL_adv_frame_plus_suitskillextracted.tooltip = TEXT("SYS_SUITSKILL_LOCKED")
	DL_adv_frame_plus_GO:SetText(DL.lang.StartPlus)
end

function me.SetChangerText()
	me.ListSelect = nil
	me.ListSelectSearch = nil
	
	me.SetHeaderText()
	me.FilterList()
	me.ShowHighlight()
end

function me.StartSearchOnClick()
	local searchtxt = DL_adv_frame_search_search_Edit_Edit:GetText()
	if string.len(string.gsub(searchtxt," ","")) < 5 then
		SendWarningMsg(string.format(DL.lang.SearchMinLength, 5))
		return
	end
	DL.search.Search(searchtxt)
	DL_main_frameSearch:SetText("")

	me.SetListType(3)
	me.SetHeaderText()
	me.FilterList()
	me.ShowHighlight()
	me.SetChangerText()
end
-- Model/Colorpicker
local ModelParts = {
	--slotid=[slotname, itemid, r, g, b, r, g, b],
	[0] = {"helmet", nil, nil, nil, nil, nil, nil, nil},
	[1] = {"hand", nil, nil, nil, nil, nil, nil, nil},
	[2] = {"foot", nil, nil, nil, nil, nil, nil, nil},
	[3] = {"torso", nil, nil, nil, nil, nil, nil, nil},
	[4] = {"leg", nil, nil, nil, nil, nil, nil, nil},
	[5] = {"back", nil, nil, nil, nil, nil, nil, nil},
	[6] = {"belt", nil, nil, nil, nil, nil, nil, nil},
	[7] = {"shoulder", nil, nil, nil, nil, nil, nil, nil},
}

function me.ChangeModel(id)
	if DL.tbls.items[id] then
		if DL.tbls.items[id].pos then
			local pos = DL.tbls.items[id].pos 
			local pos = 0
			if ModelParts[pos] then
				if id ~= ModelParts[pos][2] then
					local part = ModelParts[pos][1]
					ModelParts[pos] = {part, id, nil, nil, nil, nil, nil, nil}
					_G["DL_adv_frame_search_Color" .. part .. "c1Block"]:SetColor(1, 1, 1)
					_G["DL_adv_frame_search_Color" .. part .. "c2Block"]:SetColor(1, 1, 1)
				end
			end
		end
	end
end

function me.OnColorClick(this)
	if DL_PreviewFrameModel:GetMaterialCount() == 0 then
		DL_PreviewFrameModel:SetModel(100001)
	end
	local slot = this:GetParent():GetID()
	local Modelinfo = ModelParts[slot]
	local name = TEXT(string.format("SYS_EQWEARPOS_%02i", slot)) .. " - "
	local cidx = 3

	if this:GetID() == 1 then
		name = name .. C_MAIN_COLOR
	else
		name = name .. C_SUB_COLOR
		cidx = 6
	end
	local oldval = ModelParts[slot]
	local info = {
		parent = this,
		titleText = name,
		alphaMode = nil,
		r = Modelinfo[cidx] or 1,
		g = Modelinfo[cidx + 1] or 1,
		b = Modelinfo[cidx + 2] or 1,

		callbackFuncUpdate = function ()
			local r = ColorPickerFrame.r
			local g = ColorPickerFrame.g
			local b = ColorPickerFrame.b
			if this:GetID() == 1 then
				DL_PreviewFrameModel:SetComponentColors(ModelParts[slot][1], r, g, b, Modelinfo[6] or 1, Modelinfo[7] or 1, Modelinfo[8] or 1)
			else
				DL_PreviewFrameModel:SetComponentColors(ModelParts[slot][1], Modelinfo[3] or 1, Modelinfo[4] or 1, Modelinfo[5] or 1, r, g, b)
			end
			DL_PreviewFrameModel:Build()
			_G[this:GetName() .. "Block"]:SetColor(r, g, b)
		end,

		callbackFuncOkay = function ()
			ModelParts[slot][cidx] = ColorPickerFrame.r
			ModelParts[slot][cidx + 1] = ColorPickerFrame.g
			ModelParts[slot][cidx + 2] = ColorPickerFrame.b
		end,

		callbackFuncCancel = function()
			ModelParts[slot] = oldval
			r = ModelParts[slot][cidx] or 1
			g = ModelParts[slot][cidx + 1] or 1
			b = ModelParts[slot][cidx + 2] or 1
			if ModelParts[slot][2] then
				DL_PreviewFrameModel:SetItemLink(string.format("|Hitem:%x|h|h", ModelParts[slot][2]))
			end
			DL_PreviewFrameModel:SetComponentColors(ModelParts[slot][1], ModelParts[slot][3] or 1, ModelParts[slot][4] or 1, ModelParts[slot][5] or 1,
																			ModelParts[slot][6] or 1, ModelParts[slot][7] or 1, ModelParts[slot][8] or 1)
			DL_PreviewFrameModel:Build()
			_G[this:GetName() .. "Block"]:SetColor(r, g, b)
		end,
	}
	ColorPickerFrame:ClearAllAnchors()
	ColorPickerFrame:SetAnchor("LEFT", "RIGHT", this:GetName(), 20, 0)
	OpenColorPickerFrameEx( info )
end


DL.ui = me
