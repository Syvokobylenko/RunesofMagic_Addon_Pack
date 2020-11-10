--/run dofile("interface/addons/DungeonLoots/lua/helper.lua")
local me = DL.helper

function me.AddThousandSeparator(str)
	while true do
		str, k =string.gsub(str, "(-?%d+)(%d%d%d)",'%1' .. "." .. '%2');
		if k == 0 then
			break;
		end;
	end;
	return str
end
function me.round(num, digits)
	local fac = math.pow(10,digits)
	num = math.floor(num*fac+0.5)/fac
	return num
end

function me.GetName(id)
	local name = TEXT(string.format("Sys%d_name",id))
	if DL.tbls.recipe[id] then
		name = TEXT("SYS_RECIPE_TITLE")..TEXT(string.format("Sys%d_name",DL.tbls.recipe[id]))
	elseif DL.tbls.cards[id] then
		name = TEXT("SYS_CARD_TITLE")..TEXT(string.format("Sys%d_name",DL.tbls.cards[id]))
	end
	if string.match(name,"Sys%d+_name") then
		name = tostring(id)
	end
	return name
end

function me.GetNumMems(bossid)
	local mems = 0
	local memsname = TEXT("Sys242441_name")
	local loots = {}
	if DL.tbls.npc[bossid] then
		loots = DL.tbls.npc[bossid][3] or {}
	end
	for j=1,#loots,2 do
		if loots[j]>720000 then
			local treasure = DL.tbls.treasure[loots[j]] or {}
			local val = 0;
			for k=1,#treasure,3 do
				if TEXT(string.format("Sys%d_name",treasure[k])) == memsname then
					if val < 100000 then
						mems = mems + treasure[k+2]
						val = val +treasure[k+1]
					end
				end
			end
		else
			if TEXT(string.format("Sys%d_name",loots[j])) == memsname then
				print(bossid, loots[j].."Mems") --should never happen
			end
		end
	end
	return mems
end

function me.GetLootRecursive(tbl,id,perc,rec)
	if rec >= 20 then
		return tbl
	else
		local treasure = DL.tbls.treasure[id] or {}
		local val = 0;
		for k=1,#treasure,3 do
			if val < 100000 then
				if DL.tbls.treasure[treasure[k]] then -- if treasureitem
					local ret = me.GetLootRecursive({},treasure[k],treasure[k+1],rec+1)
					for z=1,#ret do
						table.insert(tbl,ret[z])
					end
				else
					table.insert(tbl,{treasure[k],perc*treasure[k+1]/1000/100, treasure[k+2]})
				end
				val = val + treasure[k+1]
			end
		end
	end
	return tbl
end
function me.GetBossLoot(bossid)
	local list = {}
	local loots = {} --lootid list
	if DL.tbls.npc[bossid] then
		loots = DL.tbls.npc[bossid][3] or {}
	elseif DL.tbls.treasure[bossid] then
		loots = {bossid, 100000}
	end
	for j=1,#loots,2 do
		if me.treasure_cache[loots[j]] then
			list[loots[j]] = me.treasure_cache[loots[j]]
		elseif DL.tbls.treasure[loots[j]] then
			list[loots[j]]={ perc = loots[j+1]/1000}
			local treasure = DL.tbls.treasure[loots[j]] or {}
			local val = 0;
			for k=1,#treasure,3 do
				if val < 100000 then
					if DL.tbls.treasure[treasure[k]] then -- if treasureitem
						local tbl = me.GetLootRecursive({},treasure[k],treasure[k+1],0)
						for l = 1, #tbl do
							table.insert(list[loots[j]],{tbl[l][1],tbl[l][2], tbl[l][3]})
						end
					else
						table.insert(list[loots[j]],{treasure[k],treasure[k+1], treasure[k+2]})
					end
					val = val + treasure[k+1]
				end
			end
			me.treasure_cache[loots[j]] = list[loots[j]]
		else
			list[loots[j]]={ perc = loots[j+1]/1000}
			me.treasure_cache[loots[j]] = list[loots[j]]
		end
	end
	return list
end

function me.GetInstanceValues(id)
	local text = (GetZoneLocalName(id) or "unk")
	local r,g,b = 1,1,1
	local level = DL.tbls.instance[id].lvl or 0
	local num_mems = 0
	local data = DL.tbls.instance[id]
	for i=1,#data.boss do
		if not data.boss[i].nocount then
			num_mems = num_mems + me.GetNumMems(data.boss[i].id)
		end
	end
	if num_mems>0 then
		text = text .. string.format(" |cff00ff00%s %s|r",num_mems, TEXT("SYS_MONEY_TYPE_9"))
	end
	
	return {id=id, text=text, r=r,g=g,b=b, level = level}
end
function me.GetInstanceTooltip(id)
	local data = DL.tbls.instance[id]
	local txt = string.format("%s (%d)",(GetZoneLocalName(id) or "unk"), id)
	if not data then
		return txt,{}
	end
	local zone,zoneid,lv,raid = nil,nil,nil,nil
	if data.zone then
		zone = string.format("%s (%d)",(GetZoneLocalName(data.zone) or "unk"), data.zone)
		zoneid = data.zone
	end
	if data.lvl then
		lv = string.format(TEXT("FST_LEVEL"),data.lvl)
	end
	if data.raid then
		raid = DL.lang.RAIDSIZE:format(data.raid)
	end
	
	local x, y = nil,nil 
	local ztable = DL.tbls.zone[zoneid]
	if ztable then
		itable = ztable[id]
		if type(itable)=="table" then
			x=me.round(itable.x, 3)*100
			y=me.round(itable.y, 3)*100
		end
	end
	local pos = nil
	if zone then
		pos = string.format("%s: %s, %s", zone,x or 0, y or 0)
	end
	local num_mems = 0
	for i=1,#data.boss do
		num_mems = num_mems + me.GetNumMems(data.boss[i].id)
	end
	if num_mems>0 then
		num_mems = string.format("|cff00ff00%s: %s|r",TEXT("SYS_MONEY_TYPE_9"), num_mems)
	else
		num_mems = nil
	end
	return txt,{pos,lv,raid,num_mems}
end

function me.GetBossValues(id, instance, boss, nomems)
	id = id
	text = me.GetName(id)
	r,g,b = 1,1,1
	if instance then
		if boss.id2 then
			text = text..": "
			for i=1,#boss.id2 do
				if i>1 then
					text = text..", "
				end
				text = text..TEXT(string.format("Sys%d_name",boss.id2[i].id))
			end
		end
	end
	local num_mems = me.GetNumMems(id)
	if num_mems>0 then
		text = text .. string.format(": |cff00ff00%s %s|r",num_mems, TEXT("SYS_MONEY_TYPE_9"))
	end
	return {id=id, text=text, r=r,g=g,b=b}
end

function me.GetBossTooltip(id, instance, instance_id)
	local text = string.format("%s (%d)", TEXT(string.format("Sys%d_name",id)), id)
	local num_mems = me.GetNumMems(id)
	local mems = nil
	if num_mems>0 then
		mems = string.format("|cff00ff00%s: %s|r",TEXT("SYS_MONEY_TYPE_9"), num_mems)
	end
	
	local npc_data = nil
	local add_data = {}
	if  DL.tbls.npc[id] and not instance then
		npc_data = TEXT("FST_LEVEL"):format(DL.tbls.npc[id][1])
		npc_data = string.format("%s\n%s",npc_data,me.AddThousandSeparator(DL.lang.NPCTT:format(unpack(DL.tbls.npc[id][2]))))
	else
		local bosses = DL.tbls.instance[instance_id].boss
		local bossnum = nil
		for i=1,#(bosses or {}) do
			if bosses[i].id == id then
				bossnum = i;
			end
		end
		if not bosses[bossnum].box then
			if DL.tbls.npc[id] then
				npc_data = TEXT("FST_LEVEL"):format(DL.tbls.npc[id][1])
				npc_data = string.format("%s\n%s",npc_data,me.AddThousandSeparator(DL.lang.NPCTT:format(unpack(DL.tbls.npc[id][2]))))	
			end
		end
		if bosses[bossnum].id2 then
			for i =1,#bosses[bossnum].id2 do
				if not bosses[bossnum].id2[i].box then
					if DL.tbls.npc[bosses[bossnum].id2[i].id] then
						table.insert(add_data,"<SEP>")
						table.insert(add_data, string.format("%s (%d)", TEXT(string.format("Sys%d_name",bosses[bossnum].id2[i].id)), bosses[bossnum].id2[i].id))
						table.insert(add_data,TEXT("FST_LEVEL"):format(DL.tbls.npc[bosses[bossnum].id2[i].id][1]))
						table.insert(add_data,me.AddThousandSeparator(DL.lang.NPCTT:format(unpack(DL.tbls.npc[bosses[bossnum].id2[i].id][2]))))	
					end
				end
			end
		end
		if bosses[bossnum].note then
			table.insert(add_data,"<SEP>")
			table.insert(add_data, string.format("|cffff0000%s|r", DL.lang[bosses[bossnum].note] or ""))
		end
	end
	return text,{mems,npc_data,unpack(add_data)}
end

function me.GetBossMapTooltip(vars)
	--[[					id=bosses[i].id2[j].id,
							pos = bosses[i].id2[j].pos,
							loot = bosses[i].id2[j].loot,
							box = bosses[i].id2[j].box,
							worldboss
							visible = bosses[i].id2[j].visible,
							num=i-minus,
							main = bosses[i].id,
							map_id = MapID,]]
	
	local text = ""
	local num_mems = me.GetNumMems(vars.id)
	local mems = nil
	if num_mems>0 then
		mems = string.format("|cff00ff00%s: %s|r",TEXT("SYS_MONEY_TYPE_9"), num_mems)
	end
	------------------------------------------------------
	--text, mems
	local add_data = {}
	if vars.main then
		table.insert(add_data, string.format(DL.lang.Boss2_TT, TEXT(string.format("Sys%d_name",vars.main)) , vars.main))
	end
	if not vars.box then
		if vars.worldboss then
			text = string.format("%s (%d)", TEXT(string.format("Sys%d_name",vars.id)), vars.id)
		else
			text = string.format(DL.lang.Boss_TT,vars.num, TEXT(string.format("Sys%d_name",vars.id)), vars.id)
		end
		if DL.tbls.npc[vars.id] then
			table.insert(add_data, TEXT("FST_LEVEL"):format(DL.tbls.npc[vars.id][1]))
			table.insert(add_data, me.AddThousandSeparator(DL.lang.NPCTT:format(unpack(DL.tbls.npc[vars.id][2]))))	
		end
	else
		text = string.format("%s (%d)", TEXT(string.format("Sys%d_name",vars.id)), vars.id)
	end
	if vars.note then
		table.insert(add_data,"<SEP>")
		table.insert(add_data, string.format("|cffff0000%s|r", DL.lang[vars.note] or ""))
	end
	return text,{mems,unpack(add_data)}
end

function me.GetBossLootSortedValues(bossid)
	local tbl ={}
	if DL.tbls.special_loots[bossid] then
		loots = DL.tbls.special_loots[bossid] or {}
		for i=1,#loots do
			local r,g,b = GetItemQualityColor(GetQualityByGUID(loots[i]))
			table.insert(tbl,{id=loots[i], text=me.GetName(loots[i]), r=r,g=g,b=b})	
		end
	else
		local loots = me.GetBossLoot(bossid)
		local lootorder = {}
		for treasure,data in pairs(loots) do
			table.insert(lootorder,{treasure,data})
		end
		local function fn1(v1,v2)
			if v1[2].perc > v2[2].perc then
				return true
			end
		end
		local function fn2(v1,v2)
			if v1[2][1] and v2[2][1] then
				if GetQualityByGUID(v1[2][1][1]) > GetQualityByGUID(v2[2][1][1]) then
					return true
				end
				if GetQualityByGUID(v1[2][1][1]) == GetQualityByGUID(v2[2][1][1]) then
					if v1[2].perc > v2[2].perc then
						return true
					end
				end
			elseif not v1[2][1] and v2[2][1] then
				if GetQualityByGUID(v1[1]) > GetQualityByGUID(v2[2][1][1]) then
					return true
				end			
				if GetQualityByGUID(v1[1]) == GetQualityByGUID(v2[2][1][1]) then
					if v1[2].perc > v2[2].perc then
						return true
					end
				end
			elseif v1[2][1] and not v2[2][1] then
				if GetQualityByGUID(v1[2][1][1]) > GetQualityByGUID(v2[1]) then
					return true
				end
				if GetQualityByGUID(v1[2][1][1]) ==GetQualityByGUID(v2[1]) then
					if v1[2].perc > v2[2].perc then
						return true
					end
				end
			else
				if GetQualityByGUID(v1[1]) > GetQualityByGUID(v2[1]) then
					return true
				end
				if GetQualityByGUID(v1[1]) == GetQualityByGUID(v2[1]) then
					if v1[2].perc > v2[2].perc then
						return true
					end
				end
			end
		end
		table.sort(lootorder,fn1)
		table.sort(lootorder,fn2)
		for i=1,#lootorder do
			treasure = lootorder[i][1]
			local data = loots[treasure]
			if type(data) == "table" and data[1] then
				table.insert(tbl,{id=treasure, text="-- "..data.perc.."% --", r=1,g=1,b=0})
				for num, lootdata in pairs(data) do
					if type(num)=="number" then
						local r,g,b = GetItemQualityColor(GetQualityByGUID(lootdata[1]))
						local perc = math.floor(lootdata[2]/10+0.5)/100
						if lootdata[3]> 1 then
							table.insert(tbl,{id=lootdata[1], text=perc .."% " ..lootdata[3].."x".. me.GetName(lootdata[1]), r=r,g=g,b=b})
						else
							table.insert(tbl,{id=lootdata[1], text=perc .."% " .. me.GetName(lootdata[1]), r=r,g=g,b=b})
						end
					end
				end
			else
				local r,g,b = GetItemQualityColor(GetQualityByGUID(treasure))
				local txt = string.format("-- %s%% %s --", data.perc, me.GetName(treasure))
				table.insert(tbl,{id=treasure, text=txt, r=r,g=g,b=b})
			end
		end
	end
	return tbl
end

function me.GetNameRarityByID(id)
	local r,g,b = GetItemQualityColor(GetQualityByGUID(id))
	local text = me.GetName(id)
	return {id=id, text=text, r=r,g=g,b=b}
end

function me.GetItemValues(id)
	local item_values = {}
	if DL.tbls.armor[id] then
		item_values = DL.tbls.armor[id]		
	elseif DL.tbls.weapon[id] then
		item_values = DL.tbls.weapon[id]						
	end	
	local loots ={}
	for i=3,#item_values,2 do
		if DL.tbls.treasure[item_values[i]] then
			loots[item_values[i]]={ perc = item_values[i+1]/1000}
			local treasure = DL.tbls.treasure[item_values[i]] or {}
			local val = 0;
			for k=1,#treasure,3 do
				if val < 100000 then
					if DL.tbls.treasure[treasure[k]] then -- if treasureitem
						local tbl = me.GetLootRecursive({},treasure[k],treasure[k+1],0)
						for l = 1, #tbl do
							table.insert(loots[item_values[i]],{tbl[l][1],tbl[l][2], tbl[l][3]})
						end
					else
						table.insert(loots[item_values[i]],{treasure[k],treasure[k+1], treasure[k+2]})
					end
					val = val + treasure[k+1]
				end
			end
		else
			loots[item_values[i]]={ perc = item_values[i+1]/1000}
		end
	end
	tbl = {}
	for treasure,data in pairs(loots) do
		if type(data) == "table" and data[1] then
			table.insert(tbl,{id=treasure, text="-- "..data.perc .."% --", r=1,g=0,b=0})
			for num, lootdata in pairs(data) do
				if type(num)=="number" then
					local perc = math.floor(lootdata[2]/10+0.5)/100
					table.insert(tbl,{id=lootdata[1], text=perc .."% " .." ".. me.GetName(lootdata[1]), r=1,g=1,b=1})
				end
			end
		else
			local txt = string.format("-- %s%% %s --", data.perc, me.GetName(treasure))
			table.insert(tbl,{id=treasure, text=txt, r=1,g=0,b=0})
		end
	end
	--[[	id = tbl[i]
		text = string.format("%s (%s)", TEXT(string.format("Sys%d_name",id)), id)
		r,g,b = 1,1,1
		table.insert(out, {id=id, text=text, r=r,g=g,b=b} )]]
	return tbl
end

function me.GetSearchValues(only_instance)
	local out = {}
	for num=1,#DL.search.result do
		local tbl = DL.search.result[num]
		if not only_instance or tbl.instance_id then
			if tbl.id then
				local r,g,b = GetItemQualityColor(GetQualityByGUID(tbl.id))
				table.insert(out, {id=num, text=me.GetName(tbl.id) , r=r,g=g,b=b})
			elseif tbl.bossid then
				table.insert(out, {id=num, text=me.GetName(tbl.bossid), r=1,g=1,b=1})
			elseif tbl.instance_id then
				table.insert(out, {id=num, text=(GetZoneLocalName(tbl.instance_id)or "unk"), r=1,g=1,b=1})
			end
		end
	end
	return out
end

function me.GetSearchTooltip(num)
	local out = {}
	local tbl = DL.search.result[num]
	if tbl.id then
		text = string.format("%s (%d)", me.GetName(tbl.id), tbl.id)
		if tbl.bossid then
			table.insert(out, string.format("%s (%d)",me.GetName(tbl.bossid), tbl.bossid))
			if tbl.boss2_id then
				for i=1,#(tbl.boss2_id or {}) do
					table.insert(out, string.format("%s (%d)",me.GetName(tbl.boss2_id[i].id), tbl.boss2_id[i].id))
				end
			end
			if tbl.instance_id then
				table.insert(out, string.format("%s (%d)",(GetZoneLocalName(tbl.instance_id) or "unk"), tbl.instance_id))			
			end
		end
	elseif tbl.bossid then
		text = string.format("%s (%d)", me.GetName(tbl.bossid), tbl.bossid)
			if DL.tbls.npc[tbl.bossid] then
				table.insert(out,"<SEP>")
				table.insert(out,TEXT("FST_LEVEL"):format(DL.tbls.npc[tbl.bossid][1]))
				table.insert(out,me.AddThousandSeparator(DL.lang.NPCTT:format(unpack(DL.tbls.npc[tbl.bossid][2]))))	
				table.insert(out,"<SEP>")
			end
		if tbl.instance_id then
			table.insert(out, string.format("%s (%d)",(GetZoneLocalName(tbl.instance_id) or "unk"), tbl.instance_id))
		end
		if tbl.boss2_id then
			for i=1,#(tbl.boss2_id or {}) do
				table.insert(out, string.format("%s (%d)",me.GetName(tbl.boss2_id[i].id),tbl.boss2_id[i].id))
			end		
		end
	elseif tbl.instance_id then
		return me.GetInstanceTooltip(tbl.instance_id)
	end
	return text, out ,tbl.id
end

function me.ShowInDL(map, boss, item)
	if map then
		DL.ui.SetListType(0)
		DL.ui.listtype = 0 -- instancelist
	else
		if boss and DL.tbls.treasure[boss] then
			DL.ui.SetListType(4)
			DL.ui.listtype = 4 -- treasurelist
		else
			DL.ui.SetListType(1)
			DL.ui.listtype = 1 -- bosslist
		end
	end
	if item then
		DL.ui.listid = 3 -- stats		
	elseif boss then
		DL.ui.listid = 2 -- items
	else
		DL.ui.listid = 1 -- bosses		
	end
	DL.ui.instanceid = map
	DL.ui.bossid = boss
	DL.ui.itemid = item
	if DL_main_frame:IsVisible() then
		DL.ui.FilterList()
	else
		DL_main_frame:Show()
	end
	DL.ui.SetChangerText()
end

function me.OnSearchResultClick(num, key, double)
	local tbl = DL.search.result[num]
	local itemLink = nil
	if tbl.id then -- items
		DL.ui.ListSelectSearch = num
		DL.ui.ListSelect = tbl.id
		local r, g, b = GetItemQualityColor(GetQualityByGUID(tbl.id))
		itemLink = string.format("|Hitem:%x|h|cff%02x%02x%02x[%s]|r|h", tbl.id, r*0xFF, g*0xFF, b*0xFF, DL.helper.GetName(tbl.id)) -- item
		if IsCtrlKeyDown() and IsAltKeyDown() then
			GC_OpenWebRadio("http://www.rom-welten.de/database/view.php?id="..tbl.id)
			return
		end
	elseif tbl.bossid then -- bosse
		if IsAltKeyDown() and tbl.instance_id and not IsCtrlKeyDown() then -- ShowOnMap
			DL.worldmap.Show(tbl.instance_id, tbl.bossid)
			return
		elseif IsCtrlKeyDown() and IsAltKeyDown() then
			GC_OpenWebRadio("http://www.rom-welten.de/database/view.php?id="..tbl.bossid)
			return
		end
		DL.ui.ListSelectSearch = num
		DL.ui.ListSelect = nil
		itemLink = string.format("|Hnpc:%d|h|cffffffff[%s]|r|h", tbl.bossid, DL.helper.GetName(tbl.bossid) ) -- npc
	elseif tbl.instance_id then -- instanzen
		if IsAltKeyDown() then -- ShowOnMap
			DL.worldmap.Show(tbl.instance_id, tbl.bossid)
			return
		end
		DL.ui.ListSelectSearch = num
		DL.ui.ListSelect = nil
	end
	
	if double and not (IsShiftKeyDown() or IsCtrlKeyDown()) then
		local item = tbl.id
		if not DL.tbls.items[item] then item = nil end
		me.ShowInDL(tbl.instance_id , tbl.bossid, item)
	end
	if itemLink then
		if( IsShiftKeyDown() ) then
			if( ITEMLINK_EDITBOX )then
				ChatEdit_AddItemLink( itemLink );
			end
		elseif( IsCtrlKeyDown() ) then
			if not tbl.id and tbl.bossid then
				DL_PreviewFrame:Show()
				DL_PreviewFrameModel:SetModel(tbl.bossid)
			elseif tbl.id then
				ItemPreviewFrame_SetItemLink(DL_PreviewFrame, itemLink );
				DL.ui.ChangeModel(tbl.id)
			end
		end
	end
	DL.ui.SetHeaderText()
	DL.ui.FilterList()
	DL.ui.ShowHighlight()
end

DL.helper = me
