--[[
    CharPlan - DB

    Item Database
]]


local DB = {}
local CP = _G.Charplan
CP.DB = DB

--[[ [ DataBase Format ]]
    -- Items
    local I_SLOT=1
    -- Armor: 0=Head; 1=Hands; 2=Feets; 3=Breast; 4=Legs; 5=Cape; 6=Wraist; 7=Shoulder; 8=kette; 11=Ring; 13=earring; 16=shield; 12=amulet; 21=back
    -- Weapon: 32-Haupthand; 33-Nebenhand; 34-Einhand; 35-Zweihand; 36-Munition; 37-Fernkampf; 38-Fertigungswerkzeuge
    local I_TYPE=2
    local I_LEVEL=3
    local I_ICON=4
    local I_REFINE=5
    local I_REFINE2=6
    local I_DURA=7
    local I_EFFECT=8 -- optional
    local I_STATS=9 -- optional
    local I_SET=10 -- optional
    local I_WEAPONSPEED = 11 -- optional
    local I_LIMITSEX = 12 -- optional

    -- Bonus
    local B_EFFECT=1 -- optional
    local B_GROUP=2 -- optional

--[[ ] ]]


local function LoadTable(fname)
    local fn, err = loadfile("interface/addons/charplan/item_data/"..fname..".luc")
    assert(fn,err)
    return fn()
end

local function loadEffects()
	local cache = {}
	for i=0,300 do
		local n = "SYS_WEAREQTYPE_" .. i
		cache[i] = TEXT(n)
	end
	return cache
end

function DB.Load()
    if DB.LoadCount then
        DB.LoadCount = DB.LoadCount + 1
        return
    end
    DB.LoadCount = 1

    DB.classes= LoadTable("classes")
    DB.images = LoadTable("images")
    DB.items = LoadTable("items")
    DB.bonus = LoadTable("addpower")
    DB.refines = LoadTable("refines")
    DB.cards = LoadTable("cards")
    DB.skills = LoadTable("spells")
    DB.set_skills = LoadTable("set_skills")
    DB.spell_effects = LoadTable("spell_effects")
    DB.sets = LoadTable("sets")
    DB.archievements = LoadTable("archievements")
    DB.learn = LoadTable("skills")
    DB.tpcosts = LoadTable("tpcost")
    DB.shop_items = LoadTable("shop_items")
    DB.shop_index = LoadTable("shop_index")
    DB.recipe_items = LoadTable("recipe_items")
    DB.effects = loadEffects()
end

function DB.Release()
    DB.LoadCount = DB.LoadCount-1

    if DB.LoadCount ==0 then
        -- local mem1 = collectgarbage("count")
            DB.LoadCount = nil
            DB.images = nil
            DB.items = nil
            DB.bonus = nil
            DB.refines = nil
            DB.cards = nil
            DB.skills = nil
            DB.spell_effects = nil
            DB.sets = nil
            DB.archievements = nil
            DB.effects = nil
            DB.classes = nil
            DB.learn = nil
            DB.tpcosts = nil
            DB.shop_items = nil
            DB.shop_index = nil
            DB.recipe_items = nil
            DB.set_skills = nil
        collectgarbage("collect")
        -- local mem2 = collectgarbage("count")
        -- CP.Debug("DB Released. Freed memory: "..(math.floor(mem1-mem2)/1000).."mb")
    end
end

function DB.IsLoaded()
    return DB.LoadCount
end

function DB.GetCardEffect(card_id)
    local boni_id = DB.cards[card_id]
    if boni_id then
        return DB.GetBonusEffect(boni_id)
    end
end

function DB.GetArchievementEffect(title_id)
    return DB.archievements[title_id] or {}
end

function DB.GetItemEffect(item_id)
    local item = DB.items[item_id]
    if item then
        return item[I_EFFECT] or {}
    else
        CP.Debug("Item not in DB: "..item_id)
    end
end

function DB.GetItemUsualDropEffects(item_id)
    local item = DB.items[item_id]
    if item then
        if item[I_STATS] then
            local all_effects={}
            for _,stats in ipairs(item[I_STATS]) do
                local ea = DB.GetBonusEffect(stats)
                for _,v in ipairs(ea or {}) do
                    table.insert(all_effects,v)
                end
            end
            return all_effects
        end
    else
        CP.Debug("Item not in DB: "..item_id)
    end
end

function DB.GetBonusEffect(boni_id)
    if DB.bonus[boni_id] then
        return DB.bonus[boni_id][B_EFFECT]
    else
        CP.Debug("Bonus not in DB: "..boni_id)
    end
end

function DB.GetPlusEffect(item_id, plus)
    assert(plus>=0 and plus<=CP.MAX_PLUS)

    if plus==0 then return {},0 end

    local item = DB.items[item_id]
    if item then

        local refineIdx = item[I_REFINE]+plus-1
        if plus>20 then
            if item[I_REFINE2] then
                refineIdx = item[I_REFINE2]+plus-21
            else
                refineIdx = item[I_REFINE]+19
            end
        end

        local eff = DB.refines[refineIdx]
        if eff then
            return eff[1] or {}, eff[2] or 0
        else
            CP.Debug(string.format("Plus table not defined: (%i/%i)+%i item:%i",item[I_REFINE],item[I_REFINE2],plus,item_id))
        end
    else
        CP.Debug("Item not in DB: "..item_id)
    end
    return {},0
end

function DB.hasItem20PlusEffect(item_id)
    local item = DB.items[item_id]
    if item then
        return DB.items[item_id][I_REFINE2]
    end
end

function DB.GetSetEffect(set_id, item_count)

    local eff = {}

    for count,data in pairs(DB.sets[set_id] or {}) do
        if count<item_count then
            for _,v in ipairs(data) do
                table.insert(eff,v)
            end
        end
    end

    return eff,eff_val
end

function DB.GetItemName(item_id)
	if item_id >= 550000 and item_id < 560000 then
		local name = DB.GetRecipeName(item_id)
		if name then return name end
	end
	return TEXT("Sys"..item_id.."_name")
end

function DB.GetItemIcon(item_id)
    local item = DB.items[item_id]
    if item then
        local icon = DB.GetIcon(item[I_ICON])
        if not icon then
            CP.Debug("..for Item: "..item_id)
        end
        return icon
    else
        CP.Debug("Item not in DB: "..item_id)
    end
end

function DB.GetIcon(icon_id)
    local icon = DB.images[ icon_id ]
    if icon then
        return "interface/icons/" .. icon
    else
        CP.Debug("No Icon: "..icon_id)
    end
end

function DB.FindItemsOfIcon(icon_path)
		-- 1. replace '\' to '/'
		-- 2. lower
		-- 3. remove 'interface/icons' prefix
		-- 4. remove file extension
    local name = icon_path:gsub('\\','/'):lower():gsub("^/?interface/icons/",""):gsub("%.(%w+)$", "")
    local res = {}
    for id,data in pairs(DB.items) do
        if name == DB.images[data[I_ICON]] then
            table.insert(res,id)
        end
    end
    return res
end

function DB.GetItemDura(item_id)
    local item = DB.items[item_id]
    if item then
        return math.abs(item[I_DURA])
    end
    return 100
end

function DB.GetItemMaxDura(item_id, item_max_dura)
    local item = DB.items[item_id]
    if item then
        if item[I_DURA]<0 then
            return -item[I_DURA]
        else
            return math.floor(item[I_DURA]*item_max_dura/100)
        end
    end
end

function DB.HasFixedMaxDura(item_id)
    local item = DB.items[item_id]
    if item then
        return (item[I_DURA]<0)
    end
end

function DB.CalcMaxDura(item_id, dura)
    local item = DB.items[item_id]
    if item and item[I_DURA]>0 then
        return math.floor(dura*100/item[I_DURA]+0.5)
    end
    return 100
end

function DB.IsItemAllowedInSlot(item_id, slot)
    local a,b = DB.GetItemPositions(item_id)

    return slot==a or slot==b
end

function DB.GetItemPositions(item_id)
    local item = DB.items[item_id]
    if not item then return end

    local slot = item[I_SLOT]
    if slot>31 then
        if slot == 32 then return 15 end -- Haupthand
        if slot == 33 then return 16 end -- Nebenhand
        if slot == 34 then return 15,16 end -- Einhand
        if slot == 35 then return 15,16,true end -- Zweihand
        if slot == 37 then return 10 end -- Fernkampf
    else
        if slot==11 or slot==12 then return 11,12 end
        if slot==13 or slot==14 then return 13,14 end
        return slot
    end
end

function DB.GetItemTypesForSlot(slot)

    if slot==15 then     return {32,34,35}
    elseif slot==16 then return {16,33,34}
    elseif slot==10 then return 37
    elseif slot==12 then return 11
    elseif slot==14 then return 13
    end

    return slot
end

function DB.IsWeapon(item_id)
    local item = DB.items[item_id]
    if item then
        return item[I_SLOT]>31
    end
end

function DB.IsWeaponSlot(id)
  return id == 10 or id == 15 or id == 16
end

function DB.IsWeapon2Hand(item_id)
    local item = DB.items[item_id]
    if item then
        return (item[I_SLOT] == 35)
    end
end

function DB.GetWeaponType(item_id)
	local item = DB.items[item_id]
	return item[I_TYPE]-9
end

function DB.IsShield(item_id)
    local item = DB.items[item_id]
    if item then
        return (item[I_TYPE] == 5)
    end
end

function DB.IsSlotType(slot_id)
    local slots={
    [0]=1, -- Head
    [1]=1, -- Hands
    [2]=1, -- Feets
    [3]=1, -- Body
    [4]=1, -- Legs
    [5]=2, -- Cloak
    [6]=1, -- Wraist
    [7]=1, -- Shoulders
    [8]=3, -- Necklace
    [10]=6, -- Ranges Weapon
    [11]=3, -- Ring
    [12]=3, -- Ring
    [13]=3, -- Earring
    [14]=3, -- Earring
    [15]=4, -- Primary Weapon
    [16]=5, -- Secondary Weapon
    [21]=7, -- Back
    }

    return  slots[slot_id]
end

function DB.ItemSkinPosition(item_id)
    local item_pos = DB.GetItemPositions(item_id)
    if not item_pos then return end

    local mslots={0,1,2,3,4,5,6,7,10,15,16,21}
    for _,i in ipairs(mslots) do
        if  i==item_pos then
            return i
        end
    end
end

--------
-- stat search
local function GetBonusName(id)
    local name = TEXT("Sys"..id.."_name")
    local gname, lvl = string.match(name,"^(.-)%s+([IVX]+)$")
    if not gname then
        return name, ""
    end
    return gname, lvl
end

function DB.GetBonusGroupList(runes, filter)

    runes = runes and true or false

    if filter then
        filter = filter:lower()
    end

    local done={}
    local res={}
    for id,rdata in pairs(DB.bonus) do

        local group = rdata[B_GROUP]

        if group then
            if not done[group] then

                if DB.IsRuneGroup(group)==runes then
                    local name = GetBonusName(id)

                    local filter_found = (not filter) or string.find(name:lower(),filter)

                    eff = {}
                    for i=1,#rdata[B_EFFECT],2 do
                        local n = DB.GetEffectName(rdata[B_EFFECT][i])
                        if n then
                            table.insert(eff,n)
                            if not filter_found then
                                filter_found = string.find(n:lower(),filter)
                            end
                        end
                    end

                    if filter_found then
                        table.insert(res,{id,name,eff})
                    end
                end

                done[group]=1
            end
        end
    end

    table.sort(res, function (a,b) return a[2]<b[2] end)

    return res
end

function DB.GetBonusFilteredList(is_rune, existingStats, statName, name1, name2, minValue, maxValue)
	is_runs = is_rune and true or false
	minValue = minValue and tonumber(minValue)
	maxValue = maxValue and tonumber(maxValue)

	-- convert existing stats to lookup table
	local exists = {}
	if existingStats then
		for i,v in pairs(existingStats) do
			if v then
				exists[v] = true
			end
		end
	end

	-- filter out stat and bonus names
	local result, done = {},{}
	for id,rdata in pairs(DB.bonus) do
		local group = rdata[B_GROUP]
		if group and not done[group] and not exists[id] then
			if DB.IsRuneGroup(group) == is_rune then
				local name = GetBonusName(id)
				local found, found1, found2 = (not statName) or name:lower():find(statName)		-- filter by stat name
				local eff = {}
				local bonus = rdata[B_EFFECT]
				for i=1,#bonus,2 do
					local effect = DB.effects[ bonus[i] ]
					local value = bonus[i+1]
					if not effect then break end
					table.insert(eff, effect)
					if name1 and i == 1 then								-- filter by effect1
						found1 = effect:lower():find(name1)
					end
					if name2 and i == 3 then								-- filter by effect2
						found2 = effect:lower():find(name2)
					end
				end
				if found and (not name1 or found1) and (not name2 or found2) then
					table.insert(result,{id,name,eff})
				end
			end
			done[group] = true
		end
	end

	-- filter out min values and existing stats
	local function first_of_group(id)
		local group = DB.bonus[id][B_GROUP]
		for i = id-1,(520000-1),-1 do
			local stat = DB.bonus[i]
			if not stat or stat[B_GROUP] ~= group then
				return i + 1
			end
		end
		return id
	end

	local function is_include_stat(id)
		if exists[id] then
			return false
		elseif not minValue and not maxValue then
			return true
		else
			-- filter by min of all stat values to prevent 105+700 with minValue 116
			-- and filter by max to prevent 156+900 with maxValue = 150
			-- NOTE: it would be nice to filter by stat level instead of values to filter the plain values like 290Patk+754HP, which belongs to the 116 base stat.
			local bonus = DB.bonus[id][B_EFFECT]
			local min = 0xffffFFFF
			for i=2,#bonus,2 do
				min = math.min(min, bonus[i])
			end
			if (minValue and min < minValue) or (maxValue and min > maxValue) then
				return false
			end
			return true
		end
	end

	done = {}
	for i,stat in pairs(result) do
		local id = stat[1]
		local group = DB.bonus[id][B_GROUP]
		local include = false
		if not is_rune then
			-- item stats always are single
			include = is_include_stat(id)
		else
			-- its a random-choosed rune from list, and we must enumerate all similar of same group
			local rid = first_of_group(id)
			while DB.bonus[rid] do
				if DB.bonus[rid][B_GROUP] ~= group then
					break
				elseif exists[rid] then
					-- force exclude
					include = false
					break
				end
				include = is_include_stat(rid)
				rid = rid + 1
			end
		end
		if include then
			table.insert(done, stat)
		end
	end

	table.sort(done, function (a,b) return a[2]<b[2] end)
	return done
end

function DB.GetBonusGroupLevels(grp)
    local res={}
    for id,rdata in pairs(DB.bonus) do
        if rdata[B_GROUP]==grp then
            local name, lvl = GetBonusName(id)
            table.insert(res,{lvl,id})
        end
    end
    table.sort(res, function (a,b) return CP.Utils.RomanToNum(a[1])<CP.Utils.RomanToNum(b[1]) end)
    return res
end

function DB.GetBonusInfo(id)
    local name, lvl = GetBonusName(id)
    local grp = DB.bonus[id] and DB.bonus[id][B_GROUP]
    return name, lvl, grp
end

function ReplaceNumbersWithRomans(text,cur_level)

    local level = tonumber(string.match(text,".*[^%d](%d+)%s*$"))
    if level then
        local match_canidate = string.gsub(text, "^(.*[^%d])%d+%s*$","%1")
        text = match_canidate..CP.Utils.ToRoman(level):lower()

        return  text, "^"..match_canidate, level
    end

    return text, "^"..text,cur_level
end

function DB.FindBonus(text, cur_level, is_rune)

    text = text:lower()

    text,match_canidate,cur_level = ReplaceNumbersWithRomans(text,cur_level)

    local good_match = nil
    for id,rdata in pairs(DB.bonus) do

        if rdata[B_GROUP] and DB.IsRuneGroup(rdata[B_GROUP])==is_rune then

            local fulltext = TEXT("Sys"..id.."_name"):lower()
            local _, lvl = GetBonusName(id)

            if text==fulltext then
                return id
            elseif string.find(fulltext, match_canidate) then
                if lvl == cur_level then
                    return id
                else
                    good_match = id
                end
            end
        end
    end

    return good_match
end

function DB.IsRuneGroup(id)
    return id>=10000
end

--------
-- item search
function DB.PrimarAttributes(item_id)
    local item = DB.items[item_id]
    if not item then return end

    local s = CP.Calc.STATS
    if item[I_SLOT]>31 then
        return s.PDMG, s.MDMG
    else
        return s.PDEF, s.MDEF
    end
end

local function GetFilterFunction(info)
--[[
 info.slot
 info.types
 info.name
 info.rarity
 info.level_min
 info.level_max
 info.no_empty_items
 info.itemset_only
 info.unique_skin
 info.stat_name
 info.stat_min
 info.stat_max
 info.limitsex
]]
    local code = {"return function (id,data)","local CP = _G.Charplan"}

    if info.unique_skin then
    	CP.DB.UniqueSkinsCache = {}
    	table.insert(code, string.format('local icon = data[%i]; if CP.DB.UniqueSkinsCache[icon] then return false else CP.DB.UniqueSkinsCache[icon] = true end', I_ICON))
    end

    if info.slot then
        local slots = CP.DB.GetItemTypesForSlot(info.slot)
        if type(slots)=="number" then
            table.insert(code, string.format('if data[%i]~=%i then return false end',I_SLOT,slots))
        else
            assert(type(slots)=="table")
            table.insert(code, 'if data[1]~='..table.concat(slots,' and data[1]~=')..' then return false end')
        end
    end

    if info.itemset_only then
        table.insert(code, 'if not data['..I_SET..'] then return false end')
    end

    if info.types then
        table.insert(code, 'if data[2]~='..table.concat(info.types,' and data[2]~=')..' then return false end')
    end

    if info.level_min then
        table.insert(code, string.format('if data[%i]<%i then return false end',I_LEVEL,info.level_min))
    end

    if info.level_max then
        table.insert(code, string.format('if data[%i]>%i then return false end',I_LEVEL,info.level_max))
    end

    if info.no_empty_items then
        table.insert(code, 'local eff=CP.DB.GetItemEffect(id) if not eff or #eff==0 then return false end')
    end

    if info.rarity then
        if info.rarity_single then
            table.insert(code, 'if GetQualityByGUID(id)~='..info.rarity..' then return false end')
        else
            table.insert(code, 'if GetQualityByGUID(id)<'..info.rarity..' then return false end')
        end
    end

    if info.limitsex then
        table.insert(code, 'local sex=CP.DB.GetLimitedSex(id) if sex and sex~='..info.limitsex..' then return false end')
    end


    if (info.name and info.name~="") or not info.include_unnamed then
        table.insert(code, 'local txtname = "Sys"..id.."_name"')
    end

    if info.name and info.name~="" then
        local name = string.lower(info.name)
        local suit_test = string.format('if not data[%i] or not string.find(TEXT("Sys"..data[%i].."_name"):lower(),"%s") then return false end',I_SET,I_SET,name)
        table.insert(code, 'if not string.find(TEXT(txtname):lower(),"'..name..'") then '..suit_test..' end')
    end

    if not info.include_unnamed then
        table.insert(code, 'if TEXT(txtname)==txtname then return false end')
    end

    if info.stat_name and info.stat_name ~= "" then
    	local effect_name = string.lower(info.stat_name)
    	local effect_min = info.stat_min or 0
    	local effect_max = info.stat_max or 0

    	local code_text = string.format([=[
    		local effect_name = "%s"
    		local effect_min, effect_max = %d, %d
	    	local item_data = CP.Search.GetPimpedItemData(id)
	    	local boni = CP.Calc.GetItemBonus(item_data)
	    	local found = false
	    	for eff,value in pairs(boni) do
	    		if value ~= 0 then
	    			local effect = string.lower(CP.DB.GetEffectName(eff))
	    			if effect:find(effect_name) and (value >= effect_min or effect_min == 0) and (value <= effect_max or effect_max == 0) then
	    				found = true
	    				break
	    			end
	    		end
	    	end
	    	if not found then
	    		return false
	    	end
	    ]=],
	    	effect_name, effect_min, effect_max);
	    table.insert(code, code_text)
    end

    table.insert(code,"return true end")

    local code_text = table.concat(code," ")

    local fct,err = loadstring(code_text)
    assert(fct,tostring(err).."\n"..code_text)
    return fct()
end

function DB.FindItems(info)

    local filter_function =  GetFilterFunction(info)

    local res={}
    for id,data in pairs(DB.items) do
        if filter_function(id,data) then
            table.insert(res,id)
        end
    end

    return res
end

function DB.GetItemInfo(item_id)

    local item = DB.items[item_id]
    if not item then return end

    return  item[I_LEVEL],item[I_SET]
end

function DB.GenerateItemDataByID(item_id)

    local data = {
        name = TEXT("Sys"..item_id.."_name"),
        icon = DB.GetItemIcon(item_id),
        id = item_id,
        bind = 0,   -- INVALID
        bind_flag = 0, -- INVALID
        plus = 0,
        rarity = 0,
        tier = 0,
        dura = 100,
        max_dura = 100,
        stats = {0,0,0,0,0,0},
        max_runes = 0,
        runes = {0,0,0,0},
        unk1 = 0, -- INVALID/UNKNOWN
    }

    local item = DB.items[item_id]
    if item then
        for i,stat in ipairs(item[I_STATS] or {}) do
            data.stats[i]=stat
        end

        data.dura = math.abs(item[I_DURA])
    end

    return data
end

function DB.GetSuitItems(suit_id)
    assert(suit_id)
    local set = {}
    for item_id, v in pairs(DB.items) do
        if suit_id == v[I_SET] then
            table.insert(set, item_id)
    end
  end

    return set
end

function DB.IsSuitItem(item_id)
  local _, suit = DB.GetItemInfo(item_id)
  return suit
end

function DB.GetClassInfo(token)
	return DB.classes[token]
end

function DB.GetWeaponSpeed(item_id)
	-- weapon speed stored as integer value like `24` for speed `2.4`
	local item = DB.items[item_id]
	if item and DB.IsWeapon(item_id) then return item[I_WEAPONSPEED] end
end

function DB.GetLimitedSex(item_id)
	local item = DB.items[item_id]
	if item and not DB.IsWeapon(item_id) then return item[I_LIMITSEX] end
end

function DB.GetShopsForItem(item_id)
	return DB.shop_index[item_id]
end

local function price2table(price)
	if price then
		return { ['type'] = price[1], ['cost'] = price[2] }
	end
end

function DB.GetShopItemInfo(item_id)
	-- return map of shopID => {money type,price}
	local shops = DB.shop_index[item_id]
	if not shops then return nil end
	local re = {}
	for _,shop_id in pairs(shops) do
		for _,entry in pairs(DB.shop_items[shop_id]) do
			if entry[1] == item_id then
				-- shop ID => { {type1,price1}, {type2,price2}opt }
				re[shop_id] = { price2table(entry[2]), price2table(entry[3]) }
			end
		end
	end
	return re
end

function DB.GetShopInfo(shop_id)
	-- return map of itemID => {money type,price}
	local shop = DB.shop_items[shop_id]
	if not shop then return nil end
	local re = {}
	for _,entry in pairs(shop) do
		local item_id = entry[1]
		re[item_id] = { price2table(entry[2]), price2table(entry[3]) }
	end
	return re
end

function DB.GetMoneyName(money_type)
    return TEXT("SYS_MONEY_TYPE_" .. money_type)
end

function DB.GetRecipeName(recipe_id)
    for item,rec in pairs(DB.recipe_items) do
        if rec==recipe_id then
            return TEXT("SYS_RECIPE_TITLE") .. DB.GetItemName(item)
        end
    end
end

function DB.GetRecipeOfItem(item_id)
	return DB.recipe_items[item_id]
end

function DB.GetTPCosts(spell_id,level)
    level = level or 0

    local rate = (DB.skills[spell_id] and DB.skills[spell_id][S_TP_RATE]) or 1
    return DB.tpcosts[math.min(level+rate,#DB.tpcosts)]
end

function DB.GetTPTotalCosts(spell_id,level)
    level = level or 0
    local rate = (DB.skills[spell_id] and DB.skills[spell_id][S_TP_RATE]) or 1
    local sum =0
    for l =0,level-1 do
        sum = sum+DB.tpcosts[math.min(l+rate,#DB.tpcosts)]
    return
    end
    return sum
end

function DB.GetEffectName(id)
	return DB.effects[id] or ""
end
