--/run dofile("interface/addons/DungeonLoots/lua/search.lua")
local me = DL.search

local Name_tbl = {load=true, items= {}, zone = {}, npc = {}, treasure = {}}
function me.GetNames()
	Name_tbl.load = false
	for id, _ in pairs(DL.tbls.treasure) do --treasure
		local txt =  TEXT("Sys"..id.."_name")
		if txt ~= "Sys"..id.."_name" and txt ~= "--" then
			Name_tbl.treasure[id] = txt:lower()
		end
	end
	
	for i=200000,300000 do -- items
		local txt =  TEXT("Sys"..i.."_name")
		if txt ~= "Sys"..i.."_name" and txt ~= "--" then
			Name_tbl.items[i] = txt:lower()
		end
	end
	
	for i=520000,530000 do -- runen
		local txt =  TEXT("Sys"..i.."_name")
		if txt ~= "Sys"..i.."_name" and txt ~= "--" then
			Name_tbl.items[i] = txt:lower()
		end
	end

	local recipe = string.lower(TEXT("SYS_RECIPE_TITLE"))
	for id,mobid in pairs(DL.tbls.recipe) do -- rezepte
		local txt =  TEXT("Sys"..mobid.."_name")
		if txt ~= "Sys"..mobid.."_name" and txt ~= "--" then
			Name_tbl.items[id] = recipe..txt:lower()
		end
	end
	local card = string.lower(TEXT("SYS_CARD_TITLE"))
	for id,mobid in pairs(DL.tbls.cards) do -- karten
		local txt =  TEXT("Sys"..mobid.."_name")
		if txt ~= "Sys"..mobid.."_name" and txt ~= "--" then
			Name_tbl.items[id] = card..txt:lower()
		end
	end
	for i,_ in pairs(DL.tbls.npc) do --npcs
		local txt =  TEXT("Sys"..i.."_name")
		if txt ~= "Sys"..i.."_name" and txt ~= "--" then
			Name_tbl.npc[i] = txt:lower()
		end
	end
	for i=1,1000 do 
		if GetZoneLocalName(i) then
			Name_tbl.zone[i] = GetZoneLocalName(i):lower()
		end
	end
end

function me.SearchInstanceByName(name)
-- Returns instanceID or nil
	local tbl = {}
	if Name_tbl.load then
		me.GetNames()
	end
	local pattern = name:lower()
	for id,sysstring in pairs(Name_tbl.zone) do
		if string.match(sysstring,pattern) then
			--print(pattern,"'"..id.."'",sysstring)
			table.insert(tbl, {instance_id=id})
		end
	end
	return tbl
end

function me.GetInstanceNumByBossID(id)
-- Returns InstanceID of boss or nil
	local tbl = {}
	for instance_id, idata in pairs(DL.tbls.instance) do
		local bosses = idata.boss
		for i=1,#bosses do
			if bosses[i].id == id then
				--print(id,Name_tbl[id],instance_id,Name_tbl[instance_id])
				table.insert(tbl, {bossid = id, instance_id=instance_id, boss2_id = bosses[i].id2})
			end
		end
	end
	return tbl
end

function me.SearchBossByName(name)
-- Returns BossID or nil
	if Name_tbl.load then
		me.GetNames()
	end
	local tbl = {}
	local pattern = name:lower()
	for id,sysstring in pairs(Name_tbl.npc) do
		if string.match(sysstring,pattern) then
			--print(pattern,"'"..id.."'",sysstring)
			table.insert(tbl, {bossid=id})
		end
	end
	return tbl
end

function me.SearchTreasureByName(name)
	if Name_tbl.load then
		me.GetNames()
	end
	local tbl = {}
	local pattern = name:lower()
	for id,sysstring in pairs(Name_tbl.treasure) do
		if string.match(sysstring, pattern) then
			--print(pattern,"'"..id.."'",sysstring)
			table.insert(tbl, {bossid=id}) -- treasure
		end
	end
	return tbl
end

function me.SearchItemByID(id)
-- Returns a list with the Item and the Bosses where the item can be looted.
	local tbl = {}
	if DL.tbls.treasure[id] then return tbl end
	for bossid,_ in pairs(DL.tbls.npc) do
		local loottbl = DL.helper.GetBossLoot(bossid)
		for tid, data in pairs(loottbl) do
			if type(data) == "table" and data[1] then
				for num, lootdata in pairs(data) do
					if type(num)=="number" then
						if id == lootdata[1]then
							--print(id, bossid, TEXT("Sys"..bossid.."_name"))
							table.insert(tbl, {id=id, bossid=bossid})
						end
					end
				end
			else
				if id == tid then
					table.insert(tbl, {id=id, bossid=bossid})
					--print(id, bossid, TEXT("Sys"..bossid.."_name"))
				end
			end
		end
	end
	if #tbl==0 then
		table.insert(tbl, {id=id})
	end
	return tbl
end

function me.SearchItemByName(name)
-- returns ItemID or nil
	local tbl = {}
	if Name_tbl.load then
		me.GetNames()
	end
	local pattern = name:lower()
	for id,sysstring in pairs(Name_tbl.items) do
		if string.match(sysstring, pattern) then
			local tmp = me.SearchItemByID(id)
			for i=1,#tmp do
				table.insert(tbl, tmp[i])
			end
			--print(pattern,"'"..id.."'",sysstring)
		end
	end
	return tbl
end

function me.FormatSearch(lst)
	me.result = {}
	for i=1,#lst.item do
		if #(lst.item[i].instance or {})>0 then
			for j=1, #lst.item[i].instance do
				local data = {
					id = lst.item[i].id,
					bossid = lst.item[i].bossid,
					instance_id = lst.item[i].instance[j].instance_id,
					boss2_id = lst.item[i].instance[j].boss2_id,
				}
				table.insert(me.result,data)
			end
		else
			table.insert(me.result,lst.item[i])
		end
		--print(lst.item[i].id, lst.item[i].bossid, lst.item[i].instance)
	end
	for i=1,#lst.boss do
		if #(lst.boss[i].instance or {})>0 then
			for j=1, #lst.boss[i].instance do
				local data = {
					bossid = lst.boss[i].bossid,
					instance_id = lst.boss[i].instance[j].instance_id,
					boss2_id = lst.boss[i].instance[j].boss2_id,
				}
				table.insert(me.result,data)
			end
		else
			table.insert(me.result,lst.boss[i])
		end
		--print(lst.boss[i].bossid, lst.boss[i].instance)
	end
	for i=1,#lst.treasure do
		table.insert(me.result,lst.treasure[i])
	end
	for i=1,#lst.instance do
		table.insert(me.result,lst.instance[i])
		--print(lst.instance[i].instance_id)
	end
	--[[for i=1,#me.result do
		local txt = tostring(me.result[i].id)
		txt = txt.." "..tostring(me.result[i].bossid)
		txt = txt.." "..tostring(me.result[i].instance_id)
		txt = txt.." "..tostring(me.result[i].boss2_id)
		print(txt)
	end]]
end

--/run DL.search.Search("Chapeaunoir",true,true,true,true, true)
function me.Search(txt,flag, itemsearch,bosssearch,instancesearch, boss_instance, treasuresearch)
	local bosssearch = bosssearch or (DL.search.boss and not flag)
	local instancesearch = instancesearch or (DL.search.instance and not flag)
	local itemsearch = itemsearch or (DL.search.item and not flag)
	local treasuresearch = treasuresearch or (DL.search.treasure and not flag)
	
	local boss_instance = boss_instance or (DL.search.bossinstance and not flag)

	if Name_tbl.load then
		me.GetNames()
	end

	local text_id = tonumber(txt)
	if not text_id then
		text_id = 0
	end
	txt = string.gsub(txt,"%-","%%-") -- replace '-'
	--------------------------------------------------------------
	local lst = {item={},boss={},instance={}, treasure = {}}
	if treasuresearch then -- treasuresearch return list = treasure-id
		if DL.tbls.treasure[text_id] then
			lst.treasure = {{bossid = text_id}} -- treasure
		else
			lst.treasure = me.SearchTreasureByName(txt)
		end
	end	
	if itemsearch then -- itemsearch return list {itemid, boss-id}
		if string.match(txt, "^%d%d%d%d%d%d$") then
			lst.item = me.SearchItemByID(text_id)
		else
			lst.item = me.SearchItemByName(txt)
		end
	end
	if bosssearch then -- boss-search return list = boss-id
		if DL.tbls.npc[text_id] then
			lst.boss = {{bossid = text_id}}
		else
			lst.boss = me.SearchBossByName(txt)
		end
	end
	if instancesearch then -- instancesearch return list = instance-id
		if DL.tbls.instance[text_id] then
			lst.instance = {{instance_id = text_id}}
		else
			lst.instance = me.SearchInstanceByName(txt)
		end	
	end
	--------------------------------------------------------------
	if boss_instance then
		for i=1,#lst.item do
			lst.item[i].instance = me.GetInstanceNumByBossID(lst.item[i].bossid)
		end
		for i=1,#lst.boss do
			lst.boss[i].instance = me.GetInstanceNumByBossID(lst.boss[i].bossid)
		end
	end
	--------------------------------------------------------------
	me.FormatSearch(lst)
end

DL.search = me
