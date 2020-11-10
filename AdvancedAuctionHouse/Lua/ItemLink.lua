local ItemLink={}
AAH.ItemLink = ItemLink

local ID_STATS_START = 510000
local ID_STATS_END   = 515000
local ID_RUNES_START = 520000
local ID_RUNES_END   = 522000
local ID_RECIPES_START = 550000
local ID_RECIPES_END   = 553000
local ID_ITEMS_START = 200000 -- Equipment, Questitems, Resources
local ID_ITEMS_END   = 250000

local DummyToolTip = "GameTooltip_SkillLevelUp"

local lookup_items=nil
local lookup_cards=nil
local lookup_recipes=nil
local recipes_full_included=nil

local function GetTooltipTitle(id)
    local ttip = _G[DummyToolTip]
    ttip:SetHyperLink(string.format("|Hitem:%x|h|h", id))
    ttip:Hide()
    return _G[DummyToolTip.."TextLeft1"]:GetText()
end

local function BuildTable_Cards()
    lookup_cards={}
    for i=0,15 do
        local cards_count=LuaFunc_GetCardMaxCount(i)
        for j=1,cards_count do
            local id=LuaFunc_GetCardInfo(i,j-1)
            local name=GetTooltipTitle(id)
            if name~="" then
                lookup_cards[name]=id
            end
        end
    end
end

local function BuildTable_Recipes()
    lookup_recipes = {}
    for id,_ in pairs(AAH.Data.Recipes) do
        local name = GetTooltipTitle(id)
        if name~="" then
            lookup_recipes[name]=id
        end
    end
end

local function BuildTable_Recipes_full()
    for id=ID_RECIPES_START,ID_RECIPES_END do
        if not AAH.Data.Recipes[id] then
            local name = GetTooltipTitle(id)
            if name~="" then
                lookup_recipes[name]=id
            end
        end
    end
    recipes_full_included=true
end

local function BuildTable_Items()
    lookup_items={}

    local function Add(id)
        local k = string.format("Sys%i_name",id)
        local name = TEXT(k)
        if name ~= k then
            if lookup_items[name] then
                if type(lookup_items[name])=="number" then
                    lookup_items[name] = {lookup_items[name]}
                end
                table.insert(lookup_items[name],id)
            else
                lookup_items[name]=id
            end
        end
    end

    for id =ID_ITEMS_START, ID_ITEMS_END do Add(id) end
    for id =ID_RUNES_START, ID_RUNES_END do Add(id) end
end

local function FindIDCanidates(name)

    local res

    -- Cards
    if string.find(name,"^"..TEXT("SYS_CARD_TITLE")) then
        if not lookup_cards then BuildTable_Cards() end
        res = lookup_cards[name]
    -- Recipes
    elseif string.find(name,"^"..TEXT("SYS_RECIPE_TITLE")) then
        if not lookup_recipes then BuildTable_Recipes() end
        res = lookup_recipes[name]

        if not res and not recipes_full_included then
            AAHDebug("BuildTable_Recipes_full")
            BuildTable_Recipes_full()
            res = lookup_recipes[name]
        end
    -- Standard
    else
        if not lookup_items then BuildTable_Items() end
        res = lookup_items[name]
    end

    local canidates={}
    if type(res)=="number" then
        canidates = {res}
    elseif type(res)=="table" then
        for _,i in ipairs(res) do
            table.insert(canidates,i)
        end
    end

    return canidates
end

local function FindStat(name)
    for id =ID_STATS_START,ID_STATS_END do
        if name == TEXT("Sys"..id.."_name") then
            return id
        end
    end
end

local function FindRune(name)
    for id =ID_RUNES_START,ID_RUNES_END do
        if name == TEXT("Sys"..id.."_name") then
            return id
        end
    end
end

local line_nr
local function GetTextAndColor(ctrl)
    if not ctrl:IsVisible() then return end

    local text = ctrl:GetText()
    if not text or text=="" then return end

    local color = string.match(text,"^|c%x%x(%x%x%x%x%x%x)")
    if color then
        text = string.sub(text,11)
        color = string.lower(color)
    else
		local r, g, b = ctrl:GetColor()
		if b == nil then
			color = "ffffff"
		else
			color = string.format("%02x%02x%02x",r*256,g*256,b*256)
		end
	end
    text = string.gsub(text,"|r","")

    return text,color
end

local function GetNextLine(tooltip)
    if line_nr>60 then return end

    local lt,lc = GetTextAndColor(_G[tooltip:GetName() .. "TextLeft" .. line_nr])
    local rt,rc = GetTextAndColor(_G[tooltip:GetName() .. "TextRight" .. line_nr])

    line_nr = line_nr+1
    return lt,rt,lc,rc
end



local function GetQualityByColor(color)
    for i = 1, 10 do
        local r,g,b = GetItemQualityColor(i)
        local hexcolor = string.format("%02x%02x%02x",r*256,g*256,b*256)

        if hexcolor==color then return i end
    end

    return 0
end


local function CompareTooltips(tooltip,item,id)
    assert(tooltip:GetName()~=DummyToolTip)

    local old_id = item.id
    item.id = id

    local new_link = ItemLink.GenerateLink(item)
    _G[DummyToolTip]:SetHyperLink(new_link)

    local match=0
    local l1 = tooltip:GetName().."TextLeft"
    local l2 = DummyToolTip.."TextLeft"
    local r1 = tooltip:GetName().."TextRight"
    local r2 = DummyToolTip.."TextRight"

    for line=1,60 do
        local t1 = GetTextAndColor(_G[l1..line])
        local t2 = GetTextAndColor(_G[l2..line])
        if t1==t2 then
            match = match+1
        end

        local t1 = GetTextAndColor(_G[r1..line])
        local t2 = GetTextAndColor(_G[r2..line])
        if t1==t2 then
            match = match+1
        end
    end

    item.id = old_id
    return match
end

function ItemLink.GetItemDataFromTooltip(tooltip)

    tooltip = tooltip or GameTooltip

    local item, alternate_ids = ItemLink.ParseTooltip(tooltip)

    if not item then return end

    if #alternate_ids>0 then
        item.best = CompareTooltips(tooltip,item,item.id)
        for _,id in ipairs(alternate_ids) do
            local m = CompareTooltips(tooltip,item,id)
            if m>item.best then
                item.id = id
                item.best = m
            end
        end
    end


    local base_item={
        unk1=0,
        id=item.id,
        plus=0,
        tier=0,
        dura=100,
        max_dura=100,
        bind=1,
        count=1,
        bind_flag=0,
        rarity=0,
        max_runes=0,
        stats={0,0,0,0,0,0},
        runes={0,0,0,0},
    }


    local base_link = ItemLink.GenerateLink(base_item)
    _G[DummyToolTip]:SetHyperLink(base_link)
    base_item = ItemLink.ParseTooltip(_G[DummyToolTip],{item.id})
    assert(base_item)
    item.tier = item.tier - base_item.tier
    -- TODO: recalculate DURA !

    return item
end

function ItemLink.ParseTooltip(tooltip, possible_ids)

    local item=
    {
        unk1=0,
        id=0,
        plus=0,
        count=1,
        tier=0,
        dura=0,
        max_dura=0,
        bind=1,
        bind_flag=0,
        rarity=0,
        max_runes=0,
        stats={0,0,0,0,0,0},
        runes={0,0,0,0},
    }

    line_nr = 1
    local left,right,left_color,right_color
    local function NextLine() left,right,left_color,right_color = GetNextLine(tooltip) end

    NextLine()
    if not left then return end


    -- 1) "equiped"
    if left == TEXT("NOW_EQUIP_MSG") then
        NextLine()
    end

    -- 2) Item Name: "<name> + <plus>"
    local name,plus = string.match(left,"^(.*)%s+%+%s+(%d+)$")
    if name then
        item.plus = plus
    else
        name = left
        item.plus = 0
    end

    if not possible_ids then
        possible_ids = FindIDCanidates(name)
    end

    if not possible_ids or #possible_ids==0 then
        AAHDebug("could't find ID for '"..name.."'")
        return
    end
    item.id = table.remove(possible_ids,1)
    -- 2b) rarity by color
    local base_rarity=GetQualityByGUID( item.id )
    item.rarity = GetQualityByColor(left_color) - base_rarity
    if item.rarity < 0 then
        if #possible_ids>0 then
            return ItemLink.ParseTooltip(tooltip, possible_ids)
        else
            item.rarity = GetQualityByColor(left_color)
        end
    end

    -- 3) Bound
    NextLine()
    if left == TEXT("TOOLTIP_SOULBOUND_ALREADY") then
        item.bind=2
        NextLine()
    elseif left == TEXT("TOOLTIP_SOULBOUND_EQ") then
        item.bind=3
        NextLine()
    end

    -- 4) Account item
    if left == TEXT("SYS_ACCOUNT_ITEM") then
        NextLine()
    end

    -- 5) PK death
    if left == TEXT("SYS_NOTDROP") then
        item.bind = item.bind+100
        NextLine()
    end

--~ 	if lines.left[index].text:find(TEXT("SYS_SUITSKILL_LOCKED"),1,true) then
--~         index = index + 1
--~         if index > numLines then
--~             return data
--~         end
--~     end

    -- ) Stack
    local count = string.match(left, TEXT("SYS_STACK").."(%d+)")
    if count then
        item.count = tonumber(count)
        NextLine()
    end

    -- ) can't sell
    if left == TEXT("SYS_CANT_SELL") then
        NextLine()
    end

--~     if lines.left[index].color == Sol.constants.FLAVOR_TEXT_COLOR then
--~         data.flavorText = lines.left[index].text
--~         if data.flavorText:find(TEXT("SC_DAILYQUEST_01"),1,true) then
--~             data.type = TEXT("SC_DAILYQUEST_01")
--~         end
--~         index = index + 1
--~         if index > numLines then
--~             return data
--~         end
--~     end

    -- ) tier + dura
    if left and string.find(left,TEXT("SYS_TOOLTIP_RUNE_LEVEL")) then
        item.tier = tonumber(string.match(left,"(%d+)"))

        if right then
            local currentDur, totalDur = string.match(right,TEXT("SYS_ITEM_DURABLE").." (%d+)/(%d+)")
            item.dura = tonumber(currentDur)
            item.max_dura = tonumber(totalDur)

            NextLine()
            if right and string.find(right, TEXT("SYS_POWER_MODIFY")) then
                NextLine()
            end
        else
            NextLine()
        end
    end

    -- .. skip rest and search stats
    local n_stat=1
    while left do
        if string.find(left,"^"..TEXT("SYS_ITEM_RUNE").."%s+%(%d/%d%)$") then
            item.max_runes = tonumber(string.match(left,"%(%d/(%d)%)$"))
            break
        end

        if right then
            local id = FindStat(right)
            if id then
                item.stats[n_stat] = id
                n_stat = n_stat+1
            end
        end

        NextLine()
    end

    -- runes
    local n_rune=1
    while left do
        if right then
            local id = FindRune(right)
            if id then
                item.runes[n_rune] = id
                n_rune = n_rune+1
            end
        end
        NextLine()
    end


    -- Mana & Fusion stones
    if  (item.id>=202840 and item.id<=202859) or -- Manastone
        (item.id>=202880 and item.id<=202885) then -- Fusionstone
        item.unk1=80

        for i=1,6 do
            if item.stats[i]>0 then
                item.stats[i] = item.stats[i]-41248
            end
        end
    end


    return item,possible_ids
end

-- based on Charplan src
local function UsedRunes(item_data)
    return   ( item_data.runes[1]~=0 and 1 or 0)
           + ( item_data.runes[2]~=0 and 1 or 0)
           + ( item_data.runes[3]~=0 and 1 or 0)
           + ( item_data.runes[4]~=0 and 1 or 0)

end

function ItemLink.GenerateLink(item_data)

    local free_slots = item_data.max_runes - UsedRunes(item_data)
    assert(free_slots>=0 and item_data.max_runes<5)

    local temphex= string.format("%x%02x%02x%02x",
        item_data.unk1,
        item_data.plus + 32*free_slots,
        (item_data.tier+10) + 32*item_data.rarity,
        item_data.max_dura)

    local function s(a,b)
        if a>0 then a=a-0x70000 end
        if b>0 then b=b-0x70000 end
        return a + (2^16)*b
    end

    local bind = item_data.bind+256*item_data.bind_flag

    local data=
    {
        item_data.id,
        bind,
        tonumber(temphex,16),
        s(item_data.stats[1],item_data.stats[2]),
        s(item_data.stats[3],item_data.stats[4]),
        s(item_data.stats[5],item_data.stats[6]),
        item_data.runes[1],
        item_data.runes[2],
        item_data.runes[3],
        item_data.runes[4],
        math.min(item_data.dura,9999999)*100
    }

    data[12] = ItemLink.CalculateItemLinkHash(data)

    local r,g,b = GetItemQualityColor(GetQualityByGUID( item_data.id ))

    local prefix=""
    if item_data.count>1 then
        prefix = string.format("%i x ",item_data.count)
    end

    local name = GetTooltipTitle(item_data.id)

    local link = string.format("|Hitem:%x %x %x %x %x %x %x %x %x %x %x %x|h|cff%02x%02x%02x[%s%s]|r|h",
        data[1], data[2], data[3], data[4],data[5], data[6], data[7], data[8],data[9], data[10], data[11], data[12],
        r*256,g*256,b*256,
        prefix,
        name
        )

    return link
end


--[[ [ Runes of Magic item link hash calculation code ]]
--//////////////////////////////////////////////////////////////////
-- Runes of Magic item link hash calculation code

-- Author: Valacar (aka Duppy of the Runes of Magic US Osha server)
-- Release Date: September 12th, 2010

-- Credit goes to Neil Richardson for the xor, and rshift function
-- which I slightly modified. The original code can be found at:
-- http://luamemcached.googlecode.com/svn/trunk/CRC32.lua

-- I could care less what anyone does with the code (i.e. it's public domain),
-- but I'd very much appreciate being given credit (to me Valacar) if you do
-- use the code in any way.


-- Exclusive OR
local function xor(a, b)
    local calc = 0
    for i = 32, 0, -1 do
        local val = 2 ^ i
        local aa = false
        local bb = false
        if a == 0 then
            calc = calc + b
            break
        end
        if b == 0 then
            calc = calc + a
            break
        end
        if a >= val then
            aa = true
            a = a - val
        end
        if b >= val then
            bb = true
            b = b - val
        end
        if not (aa and bb) and (aa or bb) then
             calc = calc + val
        end
    end
     return calc
end


-- binary shift right
local function rshift(num, right)
    right = right % 0x20
    local res = num / (2 ^ right)
    return math.floor(res)
end

-- get lower word of a 32-bit number
local function loword(num)
    return num % 2^16
end

-- get high word of a 32-bit number
local function hiword(num)
    return math.floor(num/2^16) % 2^16
end

-- multiply two 32-bit numbers, but returns only the low dword of the 64-bit result
local function mymul(num1, num2)
    -- Note: required for accuraty
    local x = loword(num2) * num1
    local y = (hiword(num2) * num1) * 2^16
    local a = hiword(x) + hiword(y)
    local b = loword(x)

    return ((a * 2^16) + b) % 2^32
end


--//////////////////////////////////////////////////////////////////
-- Calculates hash value of an item based on first 11 hex numbers of an item link
function ItemLink.CalculateItemLinkHash(num)

    assert(#num == 11, "11 values required!")

    local sum = 0
    for _,w in ipairs(num) do
        sum = sum + w
    end

    local a,b,c,e = sum,0,0,0,0,0

    for x,d in ipairs(num) do
        b = (d * (x-1)) % 2^32
        e = rshift(d, (x-1)*16)
        b = (b + e + a) % 2^32
        a = xor(b, d)
    end

    for _,d in ipairs(num) do
        c = d + 1
        c = mymul(c, a)
        a = mymul(d, c)
        a = math.floor(a/2^16)
        a = a + c
        a = xor(a, d)
    end

    hash = loword(a)

    return hash
end
--[[ ] Runes of Magic item link hash calculation code ]]

