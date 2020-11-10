local scrutinizer = scrutinizer

local ipairs = ipairs
local TEXT = TEXT
local tostring = tostring
local type = type
local pairs = pairs
local tonumber = tonumber
local math_floor = math.floor
local string_find = string.find
local table_insert = table.insert
local string_sub = string.sub
local UnitName = UnitName
local InPartyByName = InPartyByName
local GetNumPartyMembers = GetNumPartyMembers

scrutinizer.playerID = "player"
scrutinizer.playerPetID = "pet"
scrutinizer.partyID = {}
for i = 1, 5 do
	scrutinizer.partyID[i] = "party"..i
end

function scrutinizer:IsBossByName(name)
	if scrutinizer.bossids then
		for _, id in ipairs(scrutinizer.bossids) do
			if name == TEXT("Sys"..id.."_name") then
				return true
			end
		end
	end
	return false
end

function scrutinizer:Print(txt, r, g, b)
	DEFAULT_CHAT_FRAME:AddMessage(tostring(txt), r or 1, g or 1, b or 1)
end

function scrutinizer:IsPartyMemberByName(name)
	if (name == UnitName(scrutinizer.playerID)) or InPartyByName(name) or (name == UnitName(scrutinizer.playerPetID)) then
		return true
	end
	return false
end

function scrutinizer:IsPlayerPet(name)
	if name == UnitName(scrutinizer.playerPetID) then
		return true
	end
	return false
end

function scrutinizer:GetUID(name)
	if name == UnitName(scrutinizer.playerID) then
		return scrutinizer.playerID
	elseif name == UnitName(scrutinizer.playerPetID) then
		return scrutinizer.playerPetID
	else
		for i = 1, GetNumPartyMembers() do
			if name == UnitName(scrutinizer.partyID[i]) then
				return scrutinizer.partyID[i]
			end
		end
	end
	return false
end

function scrutinizer:Toggle(f)
	if _G[f] then
		if _G[f]:IsVisible() then
			_G[f]:Hide()
			return false
		else
			_G[f]:Show()
			return true
		end
	end
end

function scrutinizer:GetNumTable(t)
	local c = 0
	if type(t) == "table" then
		for k, v in pairs(t) do
			c = c + 1
		end
		return c
	end
	return c
end

function scrutinizer:FormatValue(v)
	if not v then
		return
	end
	if not tonumber(v) then
		return v
	end
	v = tonumber(v)
	if v >= 1000000 then
		if v >= 10000000 then
			v = scrutinizer:Round(v/10000)/(100)
		else
			v = scrutinizer:Round(v/1000)/(1000)
		end
		return v.."m"
	elseif v >= 1000 then
		if v >= 100000 then
			v = scrutinizer:Round(v/100)/(10)
		else
			v = scrutinizer:Round(v/10)/(100)
		end
		return v.."k"
	else
		return scrutinizer:Round(v)
	end
end

function scrutinizer:Round(v)
	local p = math_floor(v)
	local s = v - p
	if s >= 0.5 then
		v = p + 1
	else
		v = p
	end
	return v
end