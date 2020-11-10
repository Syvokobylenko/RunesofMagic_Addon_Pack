--[[
File-Author: Pyrr
File-Hash: 8ff1c09e6901ad8f19e16942bf88c24694ef06fa
File-Date: 2018-01-31T11:48:22Z
]]
local lib,name,path = ...

------------------------------------------------------ lib.item ------------------------------------------------------
local me = {
	imports = {
		[lib.color:GetFullTableName()] = true,
		[lib.callback:GetFullTableName()] = true,
		[lib.hash:GetFullTableName()] = true,
	},
}
local dbs = {
	{100000,109999,"npcobject"},
	{130000,139999,"npcobject"},
	{110000,129999,"questnpcobject"},
	{200000,209999,"itemobject"},
	{240000,249999,"itemobject"},
	{210000,219999,"weaponobject"},
	{220000,239999,"armorobject"},
	{610000,619999,"suitobject"},
	{550000,559999,"recipeobject"},
	{770000,779999,"cardobject"},
	{520000,529999,"runeobject"},
	{420000,429999,"questdetailobject"},
	{490000,499999,"magiccollectobject"},
	{850000,859999,"magiccollectobject"},
	{500000,509999,"magicobject"},
	{620000,629999,"magicobject"},
	{530000,549999,"titleobject"},
	{510000,519999,"addpowerobject"},
	{540000,549999,"keyitemobject"},
	{640000,649999,"keyitemobject"},
	{720000,729999,"treasureobject"},
	{790000,799999,"treasureobject"},
}
me.GetItemDB = function(id)
	local ret = me.Call("GetDBByID",nil, id)
	if ret then return ret end
	for _, data in pairs(dbs) do
		if data[1]<=id and id<=data[2] then
			return data[3]
		end
	end
end
me.GetIDRangesByDB = function(db)
	local ret = nil
	for _, data in pairs(dbs) do
		if data[3]==db then
			ret = ret or {}
			table.insert(ret, {data[1], data[2]})
		end
	end
	return ret
end


local function GetStats(str)
	local id
	local stats = {}
	for i=1,6 do
		id, str = string.match(str or "","^%s*(%x%x?%x?%x?)(.*)")
		if id and (tonumber(id, 16) or 0)>0 then
			if i%2==0 then
				table.insert(stats,i-1, tonumber("7"..id,16))
			else
				table.insert(stats, tonumber("7"..id,16))
			end
		else
			break;
		end
	end
	return stats
end
local function GetRunes(str)
	local runes = {}
	local id
	for i=1, 4 do
		id, str = string.match(str or "","^(%x+)%s*(.*)")
		id = tonumber(id or "",16)
		if id and id > 0 then
			table.insert(runes, id)
		else
			break;
		end
	end
	return runes
end
local function ReadMulti(str)
	str = sprintf("%08x", tonumber(str, 16))
	local _,plus,tier,maxdura=string.match(str,"(%x%x)(%x%x)(%x%x)(%x%x)")
	plus = tonumber(plus, 16)
	local freeruneslots = math.floor(plus/32)
	plus = plus % 32
	
	tier = tonumber(tier, 16)
	local rarity = math.floor(tier/32)
	tier =( tier % 32) - 10
	
	maxdura=tonumber(maxdura,16)
	return plus, tier, maxdura, rarity, freerune
end
local function ReadFlags(str)
	local flags = {}
	str = tonumber(str, 16)
	local val
	for i=1,32 do
		val = 2^(i-1)
		if str % (2*val) >= val then
			table.insert(flags, i)
		end
	end
	return flags
end
me.GetItemValuesFromHyperlink = function(str)
	local id, str, name = string.match(str, "^|Hitem:(%x+)(.*)|h(.+)|h$")
	if not id then return nil end
	id = tonumber(id, 16)
	local flags, multistuff, stats, runes, dura, hash = string.match(str, " (%x+) (%x+) (%x+ %x+ %x+) (%x+ %x+ %x+ %x+) (%x+) (%x+)")
	if not flags then
		return id, name
	end
	dura = tonumber(dura, 16)/100
	stats = GetStats(stats)
	runes = GetRunes(runes)
	local plus, tier, maxdura, rarity, freerune = ReadMulti(multistuff)
	flags = ReadFlags(flags) 
	return id, name, stats, runes, flags, plus, tier, dura, maxdura, rarity, freerune
end

me.GetItemTier= function(id)
	AssertType(id, "id", me:GetFullTableName()..".GetItemTier", "number");
	return math.ceil(me.Call("GetLevelByID", 0, id)/20)
end
me.GetItemIdByName = function(name, min, max, regex)
	AssertType(name, "name", me:GetFullTableName()..".GetItemIdByName", "string");
	AssertType(min, "min", me:GetFullTableName()..".GetItemIdByName", "number");
	AssertType(max, "max", me:GetFullTableName()..".GetItemIdByName", "number");
	name = name:lower()
	if regex then
		for i = min, max do
			if string.match(TEXT("Sys" .. i .. "_name"):lower(), name) then
				return i
			end
		end
	else
		for i = min, max do
			if TEXT("Sys" .. i .. "_name"):lower() == name then
				return i
			end
		end
	end
end
me.GetStatStruct = function(stats, itemid)
	itemid = itemid or 0
	local ids = {}
	for i=1, 6 do
		if stats==nil then
			ids[i] = nil
		elseif stats[i]==nil then
			ids[i] = nil
		elseif string.match(stats[i], "^%s*(%d%d%d%d%d%d)%s*$") then
			ids[i] = tonumber(string.match(stats[i], "^%s*(%d%d%d%d%d%d)%s*$"))
		else
			ids[i] = me.GetItemIdByName(stats[i], 510000, 520000)
		end
	end
	for i = 1, 6 do
		if type(ids[i]) == "number" then -- if statid is found then
			if itemid >= 202840 and itemid <= 202859 then --manasteine
				ids[i] = string.format("%04x", ids[i] - 500000);
			else
				ids[i] = string.match(string.format("%x", ids[i]), "^7(%x+)");
			end
		else -- if statid isn't found
			ids[i] = "0"
		end
	end
	local ret = {}
	for i = 1, 6 do
		if type(ids[i])=="string" and ids[i]~="0" then
			table.insert(ret, ids[i])
		end
	end
	local retstring = ""
	for i=1,3 do
		retstring = retstring..tostring(ret[i*2-1] or "0")..(ret[i*2] or "")
		if i<3 then retstring=retstring.." " end
	end
	return retstring
end
me.GetRuneStruct = function(runes)
	local ids = {}
	for i=1, 4 do
		if runes==nil then
			ids[i] = nil
		elseif runes[i]==nil then
			ids[i] = nil
		elseif string.match(runes[i], "^%s*(%d%d%d%d%d%d)%s*$") then
			ids[i] = tonumber(string.match(runes[i], "^%s*(%d%d%d%d%d%d)%s*$"))
		else
			ids[i] = me.GetItemIdByName(runes[i], 520000, 530000)
		end
	end
	for i = 1, 4 do
		if type(ids[i]) == "number" then
			ids[i] = string.format("%x", ids[i]);
		else
			ids[i] = 0
		end
	end
	return string.format("%s %s %s %s", unpack(ids))
end
me.GetBindStruct = function(binds)
	binds = binds or {}
	local translate = {
		[1] = {"bound",	 0x2, true}, -- bindequip
		[2] = {"boe",	 0x2 + 0x1, true}, -- bind on equip
		[3] = {"locked",	0x8, true}, -- locked
		[4] = {"protect", 0x10, }, -- itemprotect
		[5] = {"pkprotect", 0x100, }, -- pkprotect
		[7] = {"nodura",	0x200, }, -- nodura
		[6] = {"sse",	 0x400, }, -- suitskillextracted
	}
	local bind = 0x1 -- not bound
	for i = 1, 7 do
		if binds[translate[i][1]] then
			if translate[i][3] then
				bind = translate[i][2]
			else
				bind = bind + translate[i][2]
			end
		end
	end
	return bind
end
me.CalculateItemTier = function(id, newtier)
	-- Returns new tier of Item
	local tier = newtier or 0
	local basetier = me.GetItemTier(id);
	if tier < basetier then
		return 10
	end
	return tier - basetier + 10
end
--[[
	values:
		plus = number [0-20] items
		level = number [0-x] skills, buffs
		tier = number [0,20]items
		dura = number [0,255]
		maxdura = number [0,255]
		rarity = number [0,7]
		runeslots = number [0,7]
		bind = {
			bound = boolean	 -- bindequip
			boe = boolean	 -- bind on equip
			locked = boolean	-- locked
			protect = boolean -- itemprotect
			pkprotect = boolean -- pkprotect
			nodura = boolean	-- nodura
			sse = boolean	 -- suitskillextracted
		}
		stat = table
		rune = table
]]
me.PlusItem = function(id, values)
	if type(id)~="number" then return nil end
	if id<100000 or id>999999 then return nil end
	values = type(values)=="table" and values or {}
	-- name --
	local name = me.Call("GetItemName", nil, id) or TEXT("Sys"..id.."_name")
	name = name~="" and name or tostring(id)
	local basequality = me.Call("GetItemQuality", nil, id) or GetQualityByGUID(id)
	local r,g,b = me.GetColorByItemRarity(basequality or 0)
	local itemdb = me.GetItemDB(id)
	if itemdb=="npcobject" or itemdb=="questnpcobject" then -- NPC, Questnpc
		return string.format("|Hnpc:%d|h|cffffffff[%s]|r|h", id, name)
	elseif itemdb=="questdetailobject" then	-- Quests
		return string.format("|Hquest:%x|h|cffffffff[%s]|r|h", id, name)
	elseif itemdb=="addpowerobject" then	-- stats
		local link = string.format("%x 1 0 %04x 0 0 0 0 0 0 0", 202840, id - 500000) -- manastone
		local hash = me.CalculateItemLinkHash(link)
		return string.format("|Hitem:%s %x|h|c%s[%s]|r|h", link, hash, me.RGBAtoHEX(r,g,b,1), name)
	elseif itemdb=="magicobject" or itemdb=="magiccollectobject" then	-- skills, buffs
		if type(values.level)=="number" then
			return string.format("|Hskill:%d %d|h|c%s[%s + %d]|r|h", id, values.level, me.RGBAtoHEX(r,g,b,1), name, values.level)
		else
			return string.format("|Hskill:%d 0|h|c%s[%s]|r|h", id, me.RGBAtoHEX(r,g,b,1), name)
		end
	elseif itemdb=="weaponobject" or itemdb=="armorobject" then
				--------------- Armor/Weapons -------------------------
			local plus = values.plus or 0
			plus = (plus<0 and 0) or (plus>31 and 31) or plus
			local dura = values.dura or 100
			dura = (dura<0 and 0) or (dura>255 and 255) or dura
			local maxdura = values.maxdura or dura
			maxdura = (maxdura<0 and 0) or (maxdura>255 and 255) or maxdura
			local rarity = values.rarity or 0
			rarity = (rarity<0 and 0) or (rarity>7 and 7) or rarity
			local runeslots = values.runeslots or 0
			runeslots = (runeslots<0 and 0) or (runeslots>7 and 7) or runeslots
			local tier = me.CalculateItemTier(id, values.tier)
			local bind = me.GetBindStruct(values.bind)
			local r,g,b = me.GetColorByItemRarity(rarity+basequality)
			local stats_runes = string.format("%s %s", me.GetStatStruct(values.stats, id), me.GetRuneStruct(values.runes))
			local misc = string.format("%02x%02x%02x", plus + 0x20*runeslots, tier + 0x20*rarity, maxdura)
			local itemLink = string.format("%x %x %s %s %04x", id, bind, misc, stats_runes, dura*100)
			local hash = me.CalculateItemLinkHash(itemLink)
			itemLink = string.format("|Hitem:%s %x|h|c%s[%s]|r|h", itemLink, hash, me.RGBAtoHEX(r,g,b,1), name)
			return itemLink
	end
	return string.format("|Hitem:%x|h|c%s[%s]|r|h", id, me.RGBAtoHEX(r,g,b,1), name)
end
lib.CreateTable(me,name,path, lib)
