-- last changes     by: Tinsus     at: 2016-05-05T15:16:51Z     project-version: v1.9beta1     hash: dbc2c56b08c765c0ba1f897f442100369ffc9e3c

local len, lend = string.find("v1.9beta1", "%d+%.%d+")

if string.find("v1.9beta1", "g") then
	lend = string.find("v1.9beta1", "g") - 2
end

local LI = {
	version = string.sub("v1.9beta1", len or 1, lend or 17),
	Path = "Interface/Addons/LootIt/",
	Language = "EN",
}

--[===[@debug@
LI.debugmode = true
--@end-debug@]===]

LI.Language = string.upper(GetLanguage())

_G.LI = LI

SLASH_LootIt1 = "/LI"
SLASH_LootIt2 = "/li"
SLASH_LootIt3 = "/lootit"
SLASH_LootIt4 = "/LootIt"

SlashCmdList["LootIt"] = function(editBox, command)
	command = string.lower(command)

	if command == "show" or command == "" then
		ToggleUIFrame(LootIt_Optionen)

	elseif command == "reload" then
		LI.io("Reloading...")

		local files = {"LootIt", "lua/IO", "lua/Filterconfig", "lua/Kernel", "lua/Helper", "lua/hook", "lua/Config", "lua/Menues", "lua/Filter", "language/default", "lua/Loader", "lua/DKP"}

		for _, path in ipairs(files) do
			dofile((LI.Path)..path..".lua")
		end

		LI.IntData(true)

		LI.io("LOADED")

	elseif command == "replace" then
		LootIt_History_Move:ClearAllAnchors()
		LootIt_History_Move:SetAnchor("CENTER", "CENTER", UIParent, 0, 0)

		LootIt_History_Move:Show()

	elseif command == "stop" then
		LootIt_EventFrame:Hide()
	else
		LI.io("#UNKNOWN_COMMAND# >"..tostring(command).."<")
	end
end

function LI.OnLoad(this)
	this:RegisterEvent("LOADING_END")
	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("BOOTY_SHOW")
	this:RegisterEvent("PARTY_MEMBER_CHANGED")
	this:RegisterEvent("BAG_ITEM_UPDATE")
	this:RegisterEvent("CHAT_MSG_SYSTEM_GET")
	this:RegisterEvent("UNIT_TARGET_CHANGED")
	this:RegisterEvent("UPDATE_LOOT_ASSIGN")

	SaveVariablesPerCharacter("LI_DKP")
	SaveVariablesPerCharacter("LI_DKP_web")

	SaveVariablesPerCharacter("LI_Data")
	SaveVariablesPerCharacter("LI_ItemRow_Blacklist")

	SaveVariablesPerCharacter("LI_MasterFilterChar")
	SaveVariablesPerCharacter("LI_MasterFilterCharSpezial")
	SaveVariablesPerCharacter("LI_FilterChar")
	SaveVariablesPerCharacter("LI_FilterCharSpezial")
	SaveVariables("LI_FilterAll")
	SaveVariables("LI_FilterAllSpezial")

	if not LI_Data then
		LI_Data = {}
	end

	if not LI_FilterChar then
		LI_FilterChar = {}
	end

	if not LI_FilterAll then
		LI_FilterAll = {
			["Nightmare Essence"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Dread Essence"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Guild Rune"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Handcrafted Ruby"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Dauntless Core"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Flawless Ruby"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Herb Essence"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Guild Stone"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Ruby Stone"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Golden Ear of Grain"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Wood Essence"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Moonlight Pearl"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Dark Night Pearl"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Star Pearl"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Soul Core"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Fortune Grass"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Exquisite Wooden Chest"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Sunset Ear of Grain"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Original Sin Essence"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Ore Essence"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
			["Wisdom Core"] = {
				[1] = 4,
				[2] = 1,
				[3] = 0,
			},
		}
	end

	if not LI_FilterCharSpezial then
		LI_FilterCharSpezial = {}
	end

	if not LI_FilterAllSpezial then
		LI_FilterAllSpezial = {}
	end

	if not LI_MasterFilterChar then
		LI_MasterFilterChar = {}
	end

	if not LI_MasterFilterCharSpezial then
		LI_MasterFilterCharSpezial = {}
	end

	if not LI_DKP then
		LI_DKP = {}
	end

	if not LI_DKP_web then
		LI_DKP_web = {
			["spin"] = "",
			["system"] = 0,
			["name"] = "",
		}
	else
		LI_DKP_web.name = ""
	end

	LI.GenQualityColor()
end

function LI.GenQualityColor(int)
	if int ~= nil then
		LI.QualityCount = int
	end

	LI.QualityColors = {"ffffff"}

	for i = 1, LI.QualityCount do
		local r, g, b = GetItemQualityColor(i)

		table.insert(LI.QualityColors, LI.DecToHex(r * 256, true)..LI.DecToHex(g * 256, true)..LI.DecToHex(b * 256, true))
	end
end