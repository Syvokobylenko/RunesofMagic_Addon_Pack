--/run dofile("interface/addons/ItemPreview2/lua/plus.lua") IP2.plus.Init(IP2_db)

local parent = DL
--[[
	parent table
	There will be a subtable "plus" created:
	CreateItem = function(id, NotToChat, notooltip)
		Args:	id -> Itemid
				NotToChat -> if false or nil Item will be Sent to Systemchat
				notooltip if false or nil, Item will be shown as Tooltip
	CalculateItemLinkHash = function (link) -> returns has
	Init = function(data)
		data must be table with the following format:
		[id] = {
			name = string -> itemname
			rarity = number -> raritycolor
		}

]]

local GetColorByNum = nil
--[[
	function has to return 3 numeric values (r, g, b)
	one argument -> color
	if nil the default game function will be used (GetItemQualityColor)
]]

local frames = {
	--[[
		Values for plussing will be taken from these frames
	]]
	stats = { -- up to 6 EditBoxes; Edit Boxes for the name of the stat
		DL_adv_frame_plus_STAT1_Edit,
		DL_adv_frame_plus_STAT2_Edit,
		DL_adv_frame_plus_STAT3_Edit,
		DL_adv_frame_plus_STAT4_Edit,
		DL_adv_frame_plus_STAT5_Edit,
		DL_adv_frame_plus_STAT6_Edit,
	},
	runes = { --up to 4 EditBoxes; Edit Boxes for the name of the Rune
		DL_adv_frame_plus_RUNE1_Edit,
		DL_adv_frame_plus_RUNE2_Edit,
		DL_adv_frame_plus_RUNE3_Edit,
		DL_adv_frame_plus_RUNE4_Edit,
	},
	bind = { -- CheckBoxes
		[1] = DL_adv_frame_plus_bind, -- Is Bound
		[2] = DL_adv_frame_plus_eqbind, -- Is bind on equip
		[3] = DL_adv_frame_plus_locked, -- Is locked
		[4] = DL_adv_frame_plus_itemprotect, -- Is itemprotection
		[5] = DL_adv_frame_plus_pkprotect, -- Is pkprotect
		[6] = DL_adv_frame_plus_suitskillextracted, -- Is suitskill extracted
		[7] = nil, -- Is nodura
	},
	tier = DL_adv_frame_plus_TIER_Edit, -- numeric edit box
	plus = DL_adv_frame_plus_PLUS_Edit, -- numeric edit box
	dura = DL_adv_frame_plus_DURA_Edit, -- numeric edit box
	rarity = DL_adv_frame_plus_RARITY_Edit, -- numeric edit box

	skillevel = nil, --DL_adv_frame_plus_SKILLLEVEL_Edit, -- numeric edit box
	Tooltip = DLTooltip, -- Tooltip, if nil GameTooltip will be used
}

--[[

	DO NOT CHANGE STUFF BELOW!

]]--
----------------------------------------------------------------------------------------------------------------------------
if not parent.plus then
	parent.plus = {}
end

local me = parent.plus

local DATA = {}

local function ReturnEditBoxValue(frame, IsNumeric)
	local value= ""
	if frame then
		value = frame:GetNumber()
	end
	if IsNumeric then
		value = tonumber(value) or 0
	end
	return value
end

local function SendToChatAndTT(msg, IsTooltip)
	for i = 1, 8 do
		local MTL = _G["ChatFrame" .. i].messageTypeList
		for z = 1, #MTL do
			if MTL[z] == "SYSTEM" then
				_G["ChatFrame" .. i]:AddMessage(msg)
			end
		end
	end
	if IsTooltip then
		if frames.Tooltip then
			frames.Tooltip:SetHyperLink(msg)
		else
			GameTooltip:SetHyperLink(msg)
		end
	end
end

local function GetStats(ItemID)
	local s = {}
	for i = 1, 6 do
		if frames.stats[i] then
			local txt = frames.stats[i]:GetText():lower()
			if txt:match("^%s*(%d%d%d%d%d%d)%s*$") then
				s[i] = tonumber(txt:match("^%s*(%d%d%d%d%d%d)%s*$"))
			else
				s[i] = txt
			end
		else
			s[i] = "0"
		end
	end
	for i = 1, 6 do
		if not (type(s[i])=="number") then
			for j = 510000, 520000 do
				if TEXT("Sys" .. j .. "_name"):lower() == s[i] then
					s[i] = j
					break
				end
			end
		end
	end
	for i = 1, 6 do
		if type(s[i]) == "number" then -- if statid is found then
			if ItemID >= 202840 and ItemID <= 202859 then --manasteine
				s[i] = string.format("%04x", s[i] - 500000);
			else
				s[i] = string.match(string.format("%x", s[i]), "^7(%x+)");
			end
		else -- if statid isn't found
			s[i] = nil
		end
	end
	--nil, 00 Prevention
	for i = 1, 6, 2 do
		if type(s[i + 1]) == "nil" then
			if s[i] then
				s[i + 1] = ""
			else
				s[i] = 0 s[i + 1] = ""
			end
		end
	end
	return string.format("%s%s %s%s %s%s", unpack(s))
end

local function GetRunes()
	local r = {}
	for i = 1, 4 do
		if frames.runes[i] then
			local txt = frames.runes[i]:GetText():lower()
			if txt:match("^%s*(%d%d%d%d%d%d)%s*$") then
				r[i] = tonumber(txt:match("^%s*(%d%d%d%d%d%d)%s*$"))
			else
				r[i] = txt
			end
		else
			r[i] = "0"
		end
	end

	for i = 1, 4 do
		if not (type(r[i])=="number") then
			for j = 520000, 530000 do
				if TEXT("Sys" .. j .. "_name"):lower() == r[i] then
					r[i] = j
					break
				end
			end
		end
	end
	for i = 1, 4 do
		if type(r[i]) == "number" then
			r[i] = string.format("%x", r[i]);
		else
			r[i] = 0
		end
	end
	return string.format("%s %s %s %s", unpack(r))
end

local function GetBindStruct()
	local translate = {
		[1] = {0x2, true}, -- bindequip
		[2] = {0x2 + 0x1, true}, -- bind on equip
		[3] = {0x8, true}, -- locked
		[4] = {0x10, }, -- itemprotect
		[5] = {0x100, }, -- pkprotect
		[6] = {0x400, }, -- suitskillextracted
		[7] = {0x200, }, -- nodura
	}
	local bind = 0x1 -- not bound
	for i = 1, 7 do
		if frames.bind[i] then
			if frames.bind[i]:IsChecked() then
				if translate[i][2] then
					bind = translate[i][1]
				else
					bind = bind + translate[i][1]
				end
			end
		end
	end
	return bind
end

local function GetSkillBuffLink(id, r, g, b, name, plus)
	local link= ""
	if plus >= 0 then
		link = string.format("|Hskill:%d %d|h|cff%02x%02x%02x[%s + %d]|r|h", id, plus, r*0xff, g*0xff, b*0xff, name, plus)
	else
		link = string.format("|Hskill:%d 0|h|cff%02x%02x%02x[%s]|r|h", id, r*0xff, g*0xff, b*0xff, name)
	end
	return link
end

local function GetItemTier(id,lvl)
	for i=1,10 do
		if lvl <= i * 20 then
			return i
		end
	end
	return 0
end

local function CalculateItemTier(id)
	-- Returns new tier of Item
	if frames.tier then
		local tier = ReturnEditBoxValue(frames.tier, true)
		local basetier = GetItemTier(id, DATA[id].level or 0);
		if tier < basetier then
			tier = basetier
		end
		tier = tier - basetier + 10
		return tier
	else
		return 0
	end
end

function me.CreateItem(id, NotToChat, notooltip)
	--[[
		id = itemid
		ret = boolean if ret then return link, else send to System and as Tootlip
		notooltip = boolean -> no tooltip if true
	]]
	if id and DATA[id] then
		local r, g, b = 1, 1, 1
		if GetColorByNum then
			r, g, b = GetColorByNum(DATA[id].rarity or 0)
		else
			r, g, b = GetItemQualityColor(DATA[id].rarity or 0)
		end
		local name = DATA[id].name
		if name == nil then
			name = id
		end
		-- skills and buffs
		if (id > 490000 and id <= 500000) or -- skills
			(id > 850000 and id <= 860000) or --skills
			(id > 500000 and id <= 510000) or --buffs
			(id > 620000 and id <= 630000) then --buffs
			local plus = ReturnEditBoxValue(frames.skillevel, true)
			local itemLink = GetSkillBuffLink(id, r, g, b, name, plus)
			if not NotToChat then
				SendToChatAndTT(itemLink, not notooltip)
			end
			return itemLink
		end
		-- not an Item
		if (200000 > id or id >= 240000) then
			local itemLink= ""
			if id < 200000 then -- NPCs
				itemLink = string.format("|Hnpc:%d|h|cffffffff[%s]|r|h", id, name)
			elseif 420000 <= id and id < 430000 then -- Quests
				itemLink = string.format("|Hquest:%x|h|cffffffff[%s]|r|h", id, name)
			elseif id >= 510000 and id <= 520000 then -- stats
				local link = string.format("%x 1 0 %04x 0 0 0 0 0 0 0", 202840, id - 500000) -- Manastein
				local hash = me.CalculateItemLinkHash(link)
				itemLink = string.format("|Hitem:%s %x|h|cff%02x%02x%02x[%s]|r|h", link, hash, r*0xFF, g*0xFF, b*0xFF, name)
			else -- all Other
				itemLink = string.format("|Hitem:%x|h|cff%02x%02x%02x[%s]|r|h", id, r*0xFF, g*0xFF, b*0xFF, name)
			end
			if not NotToChat then
				SendToChatAndTT(itemLink, not notooltip)
			end
			return itemLink
		end
		--------------- Items/Armor/Weapons -------------------------
		local plus = ReturnEditBoxValue(frames.plus, true)
		local dura = ReturnEditBoxValue(frames.dura, true)
		local rarity = ReturnEditBoxValue(frames.rarity, true)

		local tier = CalculateItemTier(id)
		local bind = GetBindStruct()
		local empty_runeslots = 0

		local maxdura = dura
		if maxdura < 80 then maxdura = 80 end
		if plus > 31 then plus = 31 end
		if empty_runeslots > 7 then empty_runeslots = 7 end
		if tier > 31 then tier = 31 end
		if rarity > 7 then rarity = 7 end
		if DATA[id].rarity then
			if DATA[id].rarity + rarity > 9 then rarity = 9 - DATA[id].rarity end
			r, g, b = GetItemQualityColor(DATA[id].rarity + rarity)
		end

		if maxdura > 255 then maxdura = 255 end

		local stats_runes = string.format("%s %s", GetStats(id), GetRunes())
		local misc = string.format("%02x%02x%02x", plus + 0x20*empty_runeslots, tier + 0x20*rarity, maxdura)
		local itemLink = string.format("%x %x %s %s %04x", id, bind, misc, stats_runes, dura*100)
		local hash = DL.plus.CalculateItemLinkHash(itemLink)
		itemLink = string.format("|Hitem:%s %x|h|cff%02x%02x%02x[%s]|r|h", itemLink, hash, r*0xff, g*0xff, b*0xff, name)
		if not NotToChat then
			SendToChatAndTT(itemLink, not notooltip)
		end
		return itemLink
	end
end

function me.Init(data)
	DATA = data
end

--[[ Item link data --------------------------------------------------------------------------------

|Hitem:<itemid><bind><unknown& runePlus& tier& max dura><statAB >x3 < runes >x4 < current dura><hash>|h|cff < color>[<name>]|r|h

Ex: |Hitem:33E7E 2 2c8c1064 0 0 0 0 0 0 0 2EE0 < hash>|h|cffc805f8[Yawaka Guard]|r|h
Ex: |Hitem:33E7E 2 2c 8c 10 64 0 0 0 0 0 0 0 2EE0 < hash>|h|cffc805f8[Yawaka Guard]|r|h
Yawaka Guard, + 12, T9, 4 empty rune slots, Dura: 120/100

itemid : length 5

ItemID in hex (Ex: Yawaka Guard, ItemID: 212606, Hex: 33E7E)

bind : length 1 - 3

1 = nonbindable
2 = bound
3 = boe
10 = Equipment Protection (equipment locked?)
30 = Equipment Protection
50 = Equipment Protection
70 = Equipment Protection
90 = Equipment Protection
100 = prevent hijack (don't drop on PK death)
201 = seen when linking an item from craft frame (hides bind status and dura on the tooltip)
400 = set skill extracted
500 = set skill extracted and prevent hijack

unknown : length 0 - 2

unknown, but it seems to be used to differentiate two identical items in the backpack. linking two identical items will make
the same link but if you get the links (GetBagItemLink(invIndex)) of each item they will be different.
Leaving it off doesn't affect any of the vital stats.

Ex: 2 identical Fine Leather Belts
1st: 36de9 1 a64 0 0 0 0 0 0 0 2710 5a6f
2nd: 36de9 1 2f00a64 0 0 0 0 0 0 0 2710 d13e

1st + 1: 36de9 1 10a64 0 0 0 0 0 0 0 2710 da7a
2nd + 1: 36de9 1 2e010a64 0 0 0 0 0 0 0 2710 61d4

runePlus : length 0 - 2

empty rune slots & plus

00/20/40/60/80h = 0 - 4 empty rune slots
00h - 1Fh = + 0 - 31

41 = 2 empty rune slots, + 1
8C = 4 empty rune slots, + 12

4 x 20h = 80h
+ 12 = 0Ch
80 + 0C = 8Ch

90 = 4 empty rune slots, + 16

4 x 20h = 80h
+ 16 = 10h
80h + 10h = 90h

Ex: 9Fh = 4 empty rune slots, + 31
Ex: 70h = 3 empty rune slots, + 16
Ex: 00h = no empty rune slots, + 0
Ex: 26h = 1 empty rune slot, + 6

"Rune: x/y" on the tooltip
x = number of rune slots that are filled (up to 4, since there are only 4 spaces in the for runes stats)
y=<# empty rune slots > + x

tier : length 1 - 2

0A = not tiered, + to default tier (0Bh - 1Fh = 1 - 21)
2A = + 1 rarity level, base tier
4A = + 2 rarity level, base tier
+ rarity level is seen in crafted items

Ex: Brown Hailstone at T9 (rarity level 5 i.e. + 2 above base of 3) = 50h
4Ah + 06h = 50h

maxdura : length 2

this is the visible max dura, straight Dec to Hex
Ex: 100 dura = 64h

stats : length (4x2) x3

4 each, 2 combine into an 8 - hexadecimal digit string, 3 strings separated by spaces, or 0s if no stats there.

Tooltip / hex string - Stat Order
statB
statA
statD
statC
statF
statE

hex string
< statA/statB><statC/statD><statE/statF >

runes : length 5 x4

5 per rune, 4 seperated by spaces, 0s if no rune
Ex: Fatal I, ItemID: 520761, Hex: 7F239

current dura : length 4

this is current dura.<current dura>*100 converted to hex
Ex: 8000 [1F40h in hex] for 80 current dura
Ex: 10000 [2710h in hex] for 100 current dura
Ex: 12000 [2EE0h in hex] for 120 current dura

hash : length 4

Search for 'Runes of Magic item link hash calculation code' in 'ItemPreview/Lua/Main.lua' to view the code.
Thanks to 'ohos' for getting the ball rolling and Valacar (Duppy of Osha - US) for completing the code.
thread that started it all: https://forum.runesofmagic.com/showthread.php?p = 2368150#post2368150
code from: https://forum.runesofmagic.com/showthread.php?t = 280594

----------------------------------------------------------------------------------]]
--//////////////////////////////////////////////////////////////////

-- Runes of Magic item link hash calculation code

-- Author: Valacar (aka Duppy of the Runes of Magic US Osha server)
-- Release Date: September 12th, 2010

-- Credit goes to Neil Richardson for the xor, lshift, and rshift function
-- which I slightly modified. The original code can be found at:
-- http://luamemcached.googlecode.com/svn/trunk/CRC32.lua

-- I could care less what anyone does with the code (i.e. it's public domain),
-- but I'd very much appreciate being given credit (to me Valacar) if you do
-- use the code in any way.


-- Exclusive OR
local function xor(a, b)
	local calc = 0
	for i = 32, 0, - 1 do
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

-- binary shift left
local function lshift(num, left)
	local res = num * (2 ^ left)
	return res % (2 ^ 32)
end

-- binary shift right
local function rshift(num, right)
	right = right % 0x20
	local res = num / (2 ^ right)
	return math.floor(res)
end

-- get lower word of a 32 - bit number
local function loword(num)
	return rshift(lshift(num, 16), 16)
end

-- get high word of a 32 - bit number
local function hiword(num)
	return rshift(num, 16) % 2^16
end

-- multiply two 32 - bit numbers, but returns only the low dword of the 64 - bit result
local function mymul(num1, num2)
	local x = loword(num2) * num1
	local y=(hiword(num2) * num1) * 2^16
	local a = hiword(x) + hiword(y)
	local b = loword(x)

	return (a * 2^16) + b
end

--//////////////////////////////////////////////////////////////////

-- Calculates hash value of an item based on first 11 hex numbers of an item link
function me.CalculateItemLinkHash(values)
	assert(type(values) == "string", "Must pass a string to CalculateItemLinkHash consisting of 11 hex values separated by a space.")

	local num = { values:match("^(%x+)%s+(%x+)%s+(%x+)%s+(%x+)%s+(%x+)%s+(%x+)%s+(%x+)%s+(%x+)%s+(%x+)%s+(%x+)%s+(%x+)") }
	assert(#num == 11, "11 hex values required!")

	local sum = 0
	for s = 1, 11 do
		num[s] = tonumber(num[s], 16)
		sum = sum + num[s]
	end

	local a, b, c, d, e, x, i = sum, 0, 0, 0, 0, 0, 0

	repeat
		d = num[x + 1]
		b = d
		b = b * x
		b = b % 2^32
		e = d
		e = rshift(e, i)
		i = i + 0x10
		x = x + 1
		e = e + a
		e = e % 2^32
		b = b + e
		b = b % 2^32
		b = xor(b, d)
		a = b
	until (i >= 0xB0)

	local j = 0

	repeat
		d = num[j + 1]
		c = d + 1
		c = mymul(c, a)
		c = c % 2^32
		a = d
		a = mymul(a, c)
		a = a % 2^32
		a = rshift(a, 16)
		a = a + c
		j = j + 1
		a = xor(a, d)
	until (j >= 0x0B)

	hash = loword(a)

	return hash
end

parent.plus = me
