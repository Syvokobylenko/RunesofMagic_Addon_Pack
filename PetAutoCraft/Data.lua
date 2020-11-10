local PetVendors = {																	--Table of Pet Vendor Locations
	[1] = {Name = TEXT("Sys114932_name"), X = 0.491, Y = 0.410},							--Howling Mountains - Matt Sorrun
	[2] = {Name = TEXT("Sys114936_name"), X = 0.597, Y = 0.879},							--Silverspring - Cruise Sorrun
	[4] = {Name = TEXT("Sys114937_name"), X = 0.564, Y = 0.662},							--Aslan Valley - Dier Sorrun
	[6] = {Name = TEXT("Sys114938_name"), X = 0.263, Y = 0.846},							--Dust Devil Canyon - Kelt Sorrun
	[12] = {Name = TEXT("Sys114939_name"), X = 0.575, Y = 0.593},							--Elven Island - Hammur Sorrun
	[10000] = {Name = TEXT("Sys114932_name"), X = 0.454, Y = 0.277},						--Varanas - Matt Sorrun
	[10001] = {Name = TEXT("Sys114938_name"), X = 0.442, Y = 0.860},						--Obsidian Stronghold - Kelt Sorrun
}

local Tools = {																			--Table of Tools
	[1] = {Name = TEXT("Sys204230_name"), ID = 204230, Type = "HERB", Vendor = true},		--Small Spade
	[2] = {Name = TEXT("Sys204232_name"), ID = 204232, Type = "WOOD", Vendor = true},		--Small Hatchet
	[3] = {Name = TEXT("Sys204228_name"), ID = 204228, Type = "MINING", Vendor = true},		--Small Hoe
	[4] = {Name = TEXT("Sys204231_name"), ID = 204231, Type = "HERB", Vendor = false},		--Lightweight Spade
	[5] = {Name = TEXT("Sys204233_name"), ID = 204233, Type = "WOOD", Vendor = false},		--Lightweight Hatchet
	[6] = {Name = TEXT("Sys204229_name"), ID = 204229, Type = "MINING", Vendor = false},	--Lightweight Hoe
}

local Mats = {
	TRASH = {
		[1] = {Name = TEXT("Sys204790_name"), ID = 204790, Lvl = 1, Value = 107},			--Mysterious Item
	},
	HERB = {
		[1] = {Name = TEXT("Sys200335_name"), ID = 200335, Lvl = 1, Value = 2},				--Mountain Demon Grass
		[2] = {Name = TEXT("Sys202552_name"), ID = 202552, Lvl = 1, Value = 3},				--Rosemary
		[3] = {Name = TEXT("Sys200334_name"), ID = 200334, Lvl = 8, Value = 4},				--Beetroot
		[4] = {Name = TEXT("Sys202553_name"), ID = 202553, Lvl = 11, Value = 45},			--Bison Grass
		[5] = {Name = TEXT("Sys200333_name"), ID = 200333, Lvl = 14, Value = 6},			--Bitterleaf
		[6] = {Name = TEXT("Sys200338_name"), ID = 200338, Lvl = 20, Value = 8},			--Moxa
		[7] = {Name = TEXT("Sys202554_name"), ID = 202554, Lvl = 21, Value = 83},			--Foloin Nut
		[8] = {Name = TEXT("Sys200343_name"), ID = 200343, Lvl = 26, Value = 10},			--Dusk Orchid
		[9] = {Name = TEXT("Sys202555_name"), ID = 202555, Lvl = 31, Value = 128},			--Green Thistle
		[10] = {Name = TEXT("Sys200342_name"), ID = 200342, Lvl = 32, Value = 12},			--Barsaleaf
		[11] = {Name = TEXT("Sys200345_name"), ID = 200345, Lvl = 38, Value = 14},			--Moon Orchid
		[12] = {Name = TEXT("Sys202556_name"), ID = 202556, Lvl = 41, Value = 180},			--Straw Mushroom
		[13] = {Name = TEXT("Sys200346_name"), ID = 200346, Lvl = 44, Value = 16},			--Sinners Palm
		[14] = {Name = TEXT("Sys200349_name"), ID = 200349, Lvl = 50, Value = 18},			--Dragon Mallow
		[15] = {Name = TEXT("Sys202557_name"), ID = 202557, Lvl = 51, Value = 248},			--Mirror Sedge
		[16] = {Name = TEXT("Sys200350_name"), ID = 200350, Lvl = 56, Value = 20},			--Thorn Apple
		[17] = {Name = TEXT("Sys208246_name"), ID = 208246, Lvl = 61, Value = 22},			--Verbena
		[18] = {Name = TEXT("Sys202558_name"), ID = 202558, Lvl = 61, Value = 315},			--Goblin Grass
	},
	WOOD = {
		[1] = {Name = TEXT("Sys200293_name"), ID = 200293, Lvl = 1, Value = 2},				--Ash Wood
		[2] = {Name = TEXT("Sys200508_name"), ID = 200508, Lvl = 1, Value = 3},				--Chime Wood
		[3] = {Name = TEXT("Sys200295_name"), ID = 200295, Lvl = 8, Value = 4},				--Willow Wood
		[4] = {Name = TEXT("Sys200509_name"), ID = 200509, Lvl = 11, Value = 45},			--Stone Rotan Wood
		[5] = {Name = TEXT("Sys200297_name"), ID = 200297, Lvl = 14, Value = 6},			--Maple Wood
		[6] = {Name = TEXT("Sys200300_name"), ID = 200300, Lvl = 20, Value = 8},			--Oak Wood
		[7] = {Name = TEXT("Sys200326_name"), ID = 200326, Lvl = 21, Value = 83},			--Redwood
		[8] = {Name = TEXT("Sys200304_name"), ID = 200304, Lvl = 26, Value = 10},			--Pine Wood
		[9] = {Name = TEXT("Sys200332_name"), ID = 200332, Lvl = 31, Value = 128},			--Dragon Beard Root Wood
		[10] = {Name = TEXT("Sys200298_name"), ID = 200298, Lvl = 32, Value = 12},			--Holly Wood
		[11] = {Name = TEXT("Sys200306_name"), ID = 200306, Lvl = 38, Value = 14},			--Yew Wood
		[12] = {Name = TEXT("Sys200331_name"), ID = 200331, Lvl = 41, Value = 180},			--Sagewood
		[13] = {Name = TEXT("Sys200307_name"), ID = 200307, Lvl = 44, Value = 16},			--Tarslin Demon Wood
		[14] = {Name = TEXT("Sys200310_name"), ID = 200310, Lvl = 50, Value = 18},			--Dragonlair Wood
		[15] = {Name = TEXT("Sys202317_name"), ID = 202317, Lvl = 51, Value = 248},			--Fairywood
		[16] = {Name = TEXT("Sys200312_name"), ID = 200312, Lvl = 56, Value = 20},			--Ancient Spirit Oak Wood
		[17] = {Name = TEXT("Sys208240_name"), ID = 208240, Lvl = 61, Value = 22},			--Fastan Banyan
		[18] = {Name = TEXT("Sys202318_name"), ID = 202318, Lvl = 61, Value = 315},			--Aeontree Wood
	},
	MINING = {
		[1] = {Name = TEXT("Sys200230_name"), ID = 200230, Lvl = 1, Value = 2},				--Zinc Ore
		[2] = {Name = TEXT("Sys200507_name"), ID = 200507, Lvl = 1, Value = 3},				--Flame Dust
		[3] = {Name = TEXT("Sys200232_name"), ID = 200232, Lvl = 8, Value = 4},				--Tin Ore
		[4] = {Name = TEXT("Sys200506_name"), ID = 200506, Lvl = 11, Value = 45},			--Cyanide
		[5] = {Name = TEXT("Sys200234_name"), ID = 200234, Lvl = 14, Value = 6},			--Iron Ore
		[6] = {Name = TEXT("Sys200236_name"), ID = 200236, Lvl = 20, Value = 8},			--Copper Ore
		[7] = {Name = TEXT("Sys200249_name"), ID = 200249, Lvl = 21, Value = 83},			--Rock Crystal
		[8] = {Name = TEXT("Sys200238_name"), ID = 200238, Lvl = 26, Value = 10},			--Dark Crystal
		[9] = {Name = TEXT("Sys200269_name"), ID = 200269, Lvl = 31, Value = 128},			--Mysticite
		[10] = {Name = TEXT("Sys200239_name"), ID = 200239, Lvl = 32, Value = 12},			--Silver Ore
		[11] = {Name = TEXT("Sys200242_name"), ID = 200242, Lvl = 38, Value = 14},			--Wizard-Iron Ore
		[12] = {Name = TEXT("Sys200265_name"), ID = 200265, Lvl = 41, Value = 180},			--Mithril
		[13] = {Name = TEXT("Sys200244_name"), ID = 200244, Lvl = 44, Value = 16},			--Moon Silver Ore
		[14] = {Name = TEXT("Sys200264_name"), ID = 200264, Lvl = 50, Value = 18},			--Abyss-Mercury
		[15] = {Name = TEXT("Sys202315_name"), ID = 202315, Lvl = 51, Value = 248},			--Frost Crystal
		[16] = {Name = TEXT("Sys200268_name"), ID = 200268, Lvl = 56, Value = 20},			--Rune Obsidian Ore
		[17] = {Name = TEXT("Sys208234_name"), ID = 208234, Lvl = 61, Value = 22},			--Olivine
		[18] = {Name = TEXT("Sys202316_name"), ID = 202316, Lvl = 61, Value = 315},			--Mica
	},
}

return PetVendors, Tools, Mats