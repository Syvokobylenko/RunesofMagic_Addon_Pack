-- ingame commandos
-- Reload this file:
--    /run dofile("interface/addons/wowmap/wowmap_data.lua")
-- Fake all quest's to one map:
--   /run DEBUG_FORCE_QUEST_MAP=35; WoWMap.CollectQuestPOIs()

WoWMap.MapData = {
--------------------------------------------------------------------------------------------------------------
--	LinkTable:
--		[ZoneID] =	{
--			{x1, y1, x2, y2, ZoneID, "highlightname", scale, posX, posY},
--			}
--
--		posX and posY are optional, when not given, midpoint of region is taken instead
--		coordinates are ranged from 0 to 1, 0/0 is at the topleft corner, 1/1 at the bottomright of the map
--------------------------------------------------------------------------------------------------------------
	LinkTable = {
		[9999] = {-- Worldmap Taborea
			{0.260, 0.580, 0.554, 0.827, 9998,  "candara",      3.6,0.385,0.775},     -- classic Worldmap
			{0.180, 0.736, 0.450, 0.990, 9998,  "candara",      3.6,0.385,0.775},     -- classic Worldmap
			{0.530, 0.700, 0.590, 0.775, 9998,  "candara",      3.6,0.385,0.775},     -- classic Worldmap
			{0.025, 0.223, 0.260, 0.580, 9997,  "zandorya",     2.8,0.145,0.410},		  -- Zandorya

			{0.030, 0.683, 0.100, 0.793, 13,  	"opportunity",	0.9},				-- Coast of Opportunity - K�ste der Gelegenheit (Zandorya)
			{0.083, 0.650, 0.160, 0.773, 14,    "xaviera",		0.9},					-- Xaviera - Xaviera (Zandorya)

			{0.377, 0.028, 0.583, 0.333, 9995,  "gerador",		1.83},				-- Gerador

			{0.660, 0.060, 0.937, 0.380, 9996,  "balanzasar",		2.78,0.796,0.214},		-- balanzasar
			{0.242, 0.500, 0.309, 0.567, 31,    "city",			0.6},					-- Yrvandis

			{0.628, 0.817, 0.715, 0.888, 32,  "zone32",		1.1},				-- Zone 32
			{0.660, 0.730, 0.730, 0.814, 33,  "zone33",		0.9},				-- Zone 33
   			{ 0.679, 0.460, 0.927, 0.698, 9993, "zone36",  1.9 },

		},
		[9998] = {-- Continent Candara
			{0.552, 0.535, 0.602, 0.598, 10000, "city",         0.7},					-- Varanas - Varanas
			{0.274, 0.459, 0.335, 0.520, 10001, "city",         0.8},					-- Obsidian Stronghold - Obsidianfeste
			{0.468, 0.552, 0.560, 0.736, 1,     "howling",      1.5},					-- Howling Mountains - Heulende Berge
			{0.507, 0.377, 0.598, 0.559, 2,     "silverspring", 1.6},					-- Silverspring - Silberquell
			{0.620, 0.372, 0.755, 0.540, 3,     "ravenfell",    1.7},					-- Ravenfell - Rabenfeld
			{0.425, 0.404, 0.510, 0.551, 4,     "aslan",        1.4},					-- Aslan Valley - Aslan-Tal
			{0.293, 0.528, 0.450, 0.702, 358,   "ystra",        1.7},					-- Ystra Highlands - Ystra-Hochland
			{0.278, 0.299, 0.441, 0.513, 6,     "dustdevil",    1.9},					-- Dust Devil Canyon - Staubteufel-Canyon
			{0.646, 0.149, 0.817, 0.367, 7,     "weepingcoast", 2.3},					-- Weeping Coast - K�ste der Wehklagen
			{0.459, 0.127, 0.612, 0.367, 8,     "savage",       2.1},					-- Savage Lands - Wilde Lande
			{0.247, 0.049, 0.453, 0.294, 9,     "aotulia",      2.4},					-- Aotulia Vulcano - Aotulia Vulkan
			{0.080, 0.425, 0.269, 0.688, 10,    "sascilia",     2.3},					-- Sascilia Steppes - Sascilia Steppe
			{0.089, 0.680, 0.371, 0.864, 11,    "dragonfang",   2.5},					-- Dragonfang Ridge - Drachenzahngebirge
			{0.835, 0.450, 0.911, 0.551, 12,    "elven",        1.3},					-- Elven Island - Elfeninsel
		},
		[9997] = {-- Continent Zandorya
			{0.440, 0.700, 0.630, 0.890, 15, "thunderhoof",     2.1},					-- Thunder - Donnerhufh�gel
			{0.475, 0.530, 0.640, 0.690, 16, "southernjanost",  2.0},					-- Southern Janost Forest - S�dlicher Janostwald
			{0.520, 0.400, 0.685, 0.520, 17, "northernjanost",  1.9},					-- Northern Janost Forest - N�rdlicher Janostwald
			{0.567, 0.180, 0.720, 0.390, 18, "limo",            1.8},					-- Limo Desert	- W�ste Limo
			{0.460, 0.110, 0.590, 0.265, 19, "malevolence", 	1.5},					-- Land of Malevolence - Land des Unheils
			{0.400, 0.270, 0.530, 0.430, 20, "redhill",			1.7},					-- Redhill Mountains - Roth�gelberge
			{0.172, 0.316, 0.405, 0.568, 21, "tergothen",		1.8},					-- Tergoth Bay
			{0.540, 0.730, 0.575, 0.783, 11002, "city",         0.9},					-- Dalanis - Dalanis
		},
		[9996] = {-- Continent Balanzasar
			{0.310, 0.502, 0.510, 0.724, 22,    "rorazan",		2.15},					-- Rorazan
			{0.480, 0.438, 0.657, 0.635, 23,    "chrysalia", 	2.3,0.560,0.539},		-- Chrysalia
			{0.640, 0.265, 0.800, 0.550, 24,    "merdhin", 	2.3},		        		-- Meridan
			{0.505, 0.225, 0.650, 0.415, 25,    "zone25", 	2.3},		        		-- Syrbalpass
			{0.300, 0.190, 0.507, 0.480, 26,    "zone26", 	2.3},		        		-- Sarlo
        },
		[9995] = {-- Continent Gerador
			{0.286, 0.520, 0.374, 0.795, 27,    "jammerfoerde",	2.1, 0.390, 0.659}, 	-- jammer1
			{0.286, 0.570, 0.500, 0.795, 27,    "jammerfoerde",	2.1, 0.390, 0.659},		-- jammer2

 			{0.375, 0.340, 0.540, 0.566, 28,    "hortek", 		1.8},					-- Hortek
 			{0.550, 0.280, 0.720, 0.477, 29,    "salioca", 		2.0},		        	-- Salioca
 			{0.560, 0.087, 0.710, 0.280, 30,    "kathalan", 	1.7},		        	-- Kathalan - Kashaylan
        },
		[9994] = {-- Continent Kolydia
			{0.286, 0.520, 0.374, 0.795, 32,    "jammerfoerde",	2.1, 0.390, 0.659},
			{0.286, 0.570, 0.500, 0.795, 33,    "jammerfoerde",	2.1, 0.390, 0.659},
        },

		[9993] = {-- Isles
			{ 0.098, 0.449, 0.278, 0.672, 34, "zone34", 1.5 },
			{ 0.278, 0.260, 0.500, 0.488, 35, "zone35", 1.6 },
			{ 0.544, 0.190, 0.668, 0.357, 36, "zone36", 1.0 },
			{ 0.432, 0.535, 0.606, 0.754, 37, "zone37", 1.2 },
			{ 0.650, 0.337, 0.854, 0.638, 38, "zone38", 1.7 },
		},

		[10000] = {-- Varanas - Varanas
			{0.231, 0.299, 0.328, 0.353, 208,   "dungeon",     0.2},					-- Varanas Nightmare - Albtraum von Varanas
			{0.205, 0.443, 0.269, 0.510, 401,   "castle",      0.4},					-- Guild Castle - Gildenburg
			{0.519, 0.147, 0.577, 0.227, 401,   "castle",      0.4},					-- Guild Castle - Gildenburg
		-- {0.226, 0.067, 0.341, 0.180, 2,     "zone",        0.3},					-- Silverspring - Silberquell
			{0.400, 0.360, 0.430, 0.390, 194,   "dungeon",     0.2},					-- Chaoswirbel
		},
		[10001] = {-- Obsidian Stronghold - Obsidianfeste
			{0.515, 0.166, 0.575, 0.244, 401,   "castle",      0.4},					-- Guild Castle - Gildenburg
		-- {0.730, 0.147, 0.798, 0.231, 6,     "zone",        0.3},					-- Dust Devil Canyon - Staubteufel-Canyon
		-- {0.466, 0.866, 0.526, 0.934, 6,     "zone",        0.3},					-- Dust Devil Canyon - Staubteufel-Canyon
		},
		[11002] = {-- Dalanis - Dalanis
			{0.550, 0.340, 0.585, 0.375, 401,   "castle",      0.4},					-- Guild Castle - Gildenburg
 			{0.780, 0.435, 0.805, 0.470, 209,   "dungeon",     0.4},					-- Sewers - Kanalisation
		--	{0.466, 0.866, 0.526, 0.934, 6,     "zone",        0.3},					-- Thunderhoof hills - Donnerhufh�gel
		},
		[1] = {-- Howling Mountains - Heulende Berge
			{0.657, 0.295, 0.706, 0.345, 101,   "dungeon",     0.3},					-- Cavern of Trials - H�hle der Pr�fungen
			{0.207, 0.105, 0.247, 0.154, 110,   "dungeon",     0.3},					-- Barren Caves - Karge H�hlen
			{0.741, 0.295, 0.790, 0.345, 118,   "dungeon",     0.3},					-- Moonspring Hollow - H�hle des Wasserdrachen
			{0.489, 0.440, 0.530, 0.491, 250,   "dungeon",     0.3},					-- Windmill Basement - Windm�hlenkeller
			{0.353, 0.500, 0.413, 0.568, 301,   "dungeon",     0.3},					-- Fungus Garden - Pilzgarten
			{0.440, 0.049, 0.583, 0.108, 2,     "zone",        0.3},					-- Silverspring - Silberquell
		},
		[2] = {-- Silverspring - Silberquell
			{0.540, 0.782, 0.724, 0.935, 10000, "city",        2.0},					-- Varanas - Varanas
			{0.298, 0.673, 0.339, 0.719, 102,   "dungeon",     0.3},					-- Forsaken Abbey - Verlassene Abtei
			{0.528, 0.045, 0.596, 0.140, 117,   "dungeon",     0.3},					-- Hall of Survivors - Halle der �berlebenden
			{0.298, 0.610, 0.339, 0.656, 201,   "dungeon",     0.3},					-- Bloody Gallery - Blutige Galerie
			{0.340, 0.280, 0.370, 0.320, 190,   "dungeon",     0.3},					-- Graben
			{0.301, 0.893, 0.444, 0.968, 1,     "zone",        0.3},					-- Howling Mountains - Heulende Berge
			{0.748, 0.614, 0.877, 0.702, 3,     "zone",        0.3},					-- Ravenfell - Rabenfeld
			{0.212, 0.169, 0.328, 0.265, 4,     "zone",        0.3},					-- Aslan Valley - Aslan-Tal
			{0.455, 0.045, 0.523, 0.140, 8,     "zone",        0.3},					-- Savage Lands - Wilde Lande
		},
		[3] = {-- Ravenfell - Rabenfeld
			{0.355, 0.789, 0.399, 0.842, 108,   "dungeon",     0.3},					-- Treasure Trove - Schatzh�hle
			{0.027, 0.740, 0.163, 0.826, 2,     "zone",        0.3},					-- Silverspring - Silberquell
			{0.305, 0.060, 0.574, 0.174, 7,     "zone",        0.3},					-- Weeping Coast - K�ste der Wehklagen
		},
		[4] = {-- Aslan Valley - Aslan-Tal
			{0.614, 0.872, 0.652, 0.922, 103,   "dungeon",     0.3},					-- Necropolis of Mirrors - Gr�berstadt der Spiegel
			{0.191, 0.212, 0.310, 0.374, 116,   "dungeon",     0.3},					-- Origin - Ursprung
			{0.512, 0.614, 0.556, 0.665, 352,   "dungeon",     0.3},					-- Goblin Mines - Goblin-Mine
			{0.812, 0.173, 0.944, 0.278, 2,     "zone",        0.3},					-- Silverspring - Silberquell
			{0.296, 0.884, 0.478, 0.971, 5,     "zone",        0.3},					-- Ystra Highlands - Ystra-Hochland
		},
		[5] = {-- Ystra Highlands - Ystra-Hochland
			{0.504, 0.820, 0.541, 0.872, 104,   "dungeon",     0.3},					-- Mystic Altar - Mystischer Altar
			{0.379, 0.454, 0.452, 0.537, 205,   "dungeon",     0.3},					-- Revivers' Corridor - Auferstehungskorridor
			{0.522, 0.614, 0.569, 0.670, 206,   "dungeon",     0.3},					-- Guards' Corridor - Korridor der W�chter
			{0.224, 0.146, 0.273, 0.203, 207,   "dungeon",     0.3},					-- Royals' Refuge - Korridor der Zuflucht
			{0.614, 0.171, 0.727, 0.283, 4,     "zone",        0.3, 0.639, 0.260},		-- Aslan Valley - Aslan-Tal
			{0.384, 0.011, 0.542, 0.111, 6,     "zone",        0.3, 0.411, 0.088},		-- Dust Devil Canyon - Staubteufel-Canyon
			{0.245, 0.629, 0.399, 0.755, 11,    "zone",        0.3, 0.356, 0.641},		-- Dragonfang Ridge - Drachenzahngebirge
		},
		[358] = {-- Ystra Highlands - Clone
			{0.504, 0.820, 0.541, 0.872, 104,   "dungeon",     0.3},					-- Mystic Altar - Mystischer Altar
			{0.379, 0.454, 0.452, 0.537, 205,   "dungeon",     0.3},					-- Revivers' Corridor - Auferstehungskorridor
			{0.522, 0.614, 0.569, 0.670, 206,   "dungeon",     0.3},					-- Guards' Corridor - Korridor der W�chter
			{0.224, 0.146, 0.273, 0.203, 207,   "dungeon",     0.3},					-- Royals' Refuge - Korridor der Zuflucht
			{0.614, 0.171, 0.727, 0.283, 4,     "zone",        0.3, 0.639, 0.260},		-- Aslan Valley - Aslan-Tal
			{0.384, 0.011, 0.542, 0.111, 6,     "zone",        0.3, 0.411, 0.088},		-- Dust Devil Canyon - Staubteufel-Canyon
			{0.245, 0.629, 0.399, 0.755, 11,    "zone",        0.3, 0.356, 0.641},		-- Dragonfang Ridge - Drachenzahngebirge
		},
		[6] = {-- Dust Devil Canyon - Staubteufel-Canyon
			{0.191, 0.666, 0.371, 0.808, 10001, "city",        2.0},					-- Obsidian Stronghold - Obsidianfeste
			{0.161, 0.879, 0.208, 0.944, 302,   "dungeon",     0.3},					-- Wind Wild Animus - Seele der Sturmh�he
			{0.426, 0.586, 0.470, 0.649, 105,   "dungeon",     0.3},					-- Queen's Chamber - K�niginnenkammer
			{0.406, 0.343, 0.444, 0.396, 107,   "dungeon",     0.3},					-- Shrine of Kalin - Schrein von Kalin
			{0.046, 0.797, 0.150, 0.894, 10,    "zone",        0.3},					-- Sascilia Steppes - Sascilia Steppe
			{0.515, 0.826, 0.706, 0.940, 5,     "zone",        0.3, 0.600, 0.859},		-- Ystra Highlands - Ystra-Hochland
		},
		[7] = {-- Weeping Coast - K�ste der Wehklagen
			{0.761, 0.578, 0.801, 0.639, 115,   "dungeon",     0.3},					-- Ocean's Heart - Herz des Ozeans
			{0.227, 0.874, 0.355, 0.952, 3,     "zone",        0.3},					-- Ravenfell - Rabenfeld
			{0.078, 0.287, 0.138, 0.362, 8,     "zone",        0.3},					-- Savage Lands - Wilde Lande
		},
		[8] = {-- Savage Lands - Wilde Lande
			{0.667, 0.896, 0.733, 0.971, 117,   "dungeon",     0.3},					-- Hall of Survivors - Halle der �berlebenden
			{0.792, 0.333, 0.958, 0.477, 7,     "zone",        0.3, 0.822, 0.363},		-- Weeping Coast - K�ste der Wehklagen
			{0.080, 0.191, 0.327, 0.351, 9,     "zone",        0.3, 0.295, 0.321},		-- Aotulia Vulcano - Aotulia Vulkan
			{0.596, 0.896, 0.662, 0.971, 2,     "zone",        0.3},					-- Silverspring - Silberquell
		},
		[9] = {-- Aotulia Vulcano - Aotulia Vulkan
			{0.302, 0.591, 0.387, 0.723, 119,   "dungeon",     0.3},					-- Lair of the Demon Dragon - Hort des D�monendrachen
			{0.295, 0.226, 0.401, 0.321, 120,   "dungeon",     0.3},					-- Zuridon Stronghold - Zurhidonfeste
			{0.286, 0.108, 0.411, 0.224, 122,   "dungeon",     0.3},					-- Demon Lair - D�monenfeste
			{0.771, 0.741, 0.984, 0.889, 8,     "zone",        0.3, 0.799, 0.780},		-- Savage Lands - Wilde Lande
		},
		[10] = {-- Sascilia Steppes - Sascilia Steppe
			{0.752, 0.147, 0.928, 0.333, 10001, "city",        2.0},					-- Obsidian Stronghold - Obsidianfeste
			{0.112, 0.275, 0.153, 0.323, 106,   "dungeon",     0.3},					-- Pasper's Shrine - Schrein von Pasper
			{0.245, 0.563, 0.287, 0.614, 251,   "dungeon",     0.3},					-- Arcane Chamber of Sathkur - Arkane Kammer des Sathkur
			{0.807, 0.057, 0.970, 0.166, 6,     "zone",        0.3},					-- Dust Devil Canyon - Staubteufel-Canyon
			{0.455, 0.893, 0.718, 0.969, 11,    "zone",        0.3},					-- Dragonfang Ridge - Drachenzahngebirge
		},
		[11] = {-- Dragonfang Ridge - Drachenzahngebirge
			{0.804, 0.786, 0.850, 0.845, 114,   "dungeon",     0.3},					-- Ruins of the Ice Dwarf Kingdom - Ruinen des Eiszwergk�nigreiches
			{0.090, 0.129, 0.136, 0.188, 252,   "dungeon",     0.3},					-- Cyclops Lair - H�hle der Zyklopen
			{0.471, 0.181, 0.588, 0.283, 10,    "zone",        0.3},					-- Sascilia Steppes - Sascilia Steppe
			{0.877, 0.052, 0.985, 0.151, 5,     "zone",        0.3},					-- Ystra Highlands - Ystra-Hochland
		},
		[13] = {-- Coast of Opportunity - K�ste der Gelegenheit
			{0.575, 0.050, 0.670, 0.130, 14,    "zone",        0.3},					-- Xaviera - Xaviera

		},
		[14] = {-- Xaviera - Xaviera
			{0.200, 0.400, 0.290, 0.560, 13,    "zone",        0.3},					-- Coast of Opportuntiy - K�ste der Gelegenheit

		},
		[15] = {-- Thunderhoof Hills - Donnerhufh�gel
			{0.460, 0.340, 0.610, 0.550, 11002, "city",   	   1.7},					-- Dalanis - Dalanis
		-- {0.514, 0.404, 0.556, 0.460, 401,   "castle",      0.4},					-- Guild Castle - Gildenburg
		-- {0.556, 0.498, 0.600, 0.552, 209,   "dungeon",     0.3},					-- Dalanis Sewers - Kanalisation von Dalanis
			{0.348, 0.021, 0.427, 0.106, 16,    "zone",        0.3},					-- Southern Janost Forest - S�dlicher Janostwald
			{0.440, 0.160, 0.470, 0.190, 142,   "dungeon",     0.3},					-- Tomb of seven Heroes
		},
		[16] = {-- Southern Janost Forest - S�dlicher Janostwald
			{0.569, 0.690, 0.612, 0.760, 129,   "dungeon",     0.3},					-- Warnorken Arena - Arena von Warnorken
			{0.071, 0.848, 0.278, 0.963, 15,    "zone",        0.3},					-- Thunderhoof Hills - Donnerhufh�gel
            {0.794, 0.711, 0.829, 0.747, 210,	"dungeon",	   0.3},					-- Ruines of Magnork - Ruinen von Magnork
			{0.744, 0.066, 0.915, 0.270, 17,    "zone",        0.3, 0.752, 0.263},		-- Northern Janost Forest - N�rdlicher Janostwald
		},
		[17] = {-- Northern Janost Forest - N�rdlicher Janostwald
			{0.094, 0.410, 0.175, 0.472, 130,   "dungeon",     0.3},					-- Raksha Temple - Tempel der Raksha
			{0.265, 0.871, 0.550, 0.980, 16,    "zone",        0.3},					-- Southern Janost Forest - S�dlicher Janostwald
			{0.425, 0.015, 0.480, 0.080, 18,    "zone",        0.3},					-- Limo desert
		},
		[18] = {-- Limo Desert - W�ste Limo
			{0.255, 0.455, 0.305, 0.505, 134,   "dungeon",     0.3},					-- Kawak's Tomb - Grabmal von Kawak
			{0.280, 0.880, 0.340, 0.960, 17,    "zone",        0.3},					-- Northern Janost Forest - N�rdlicher Janostwald
			{0.210, 0.310, 0.260, 0.360, 19,    "zone",        0.3},					-- Land of Malevolance - Land des Unheils
		},
		[19] = {-- Land of Malevolance - Land des Unheils
			{0.800, 0.200, 0.850, 0.250, 18,    "zone",        0.3},					-- Limo Desert - W�ste Limo
			{0.220, 0.865, 0.270, 0.915, 20,    "zone",        0.3},					-- Redhill Mountains - Roth�gelberge
			{0.290, 0.710, 0.340, 0.760, 137,   "dungeon",     0.3},					-- Grafus Castle - Burg Grafu
		},
		[20] = {-- Redhill Mountains - Roth�gelberge
			{0.580, 0.160, 0.700, 0.270, 19,    "zone",        0.3},					-- Land of Malevolance - Land des Unheils
			{0.240, 0.860, 0.300, 0.930, 139,   "dungeon",     0.3},					-- Sardos Castle - Burg Sardo
			{0.232, 0.150, 0.322, 0.270, 211,	"city",        1.5},					-- Underground of the fire... - Untergrund des Feuerstiefel
			{0.085, 0.780, 0.160, 0.850, 21,    "zone",        0.3},					-- Tergothenbucht
		},
		[21] = {-- Tergothen bay - Tergothenbucht
			{0.836, 0.056, 0.900, 0.130, 20,    "zone",        0.3},					-- Land of Malevolance - Land des Unheils
		},
		[22] = {-- Rorazan
			{0.450, 0.210, 0.490, 0.250, 10002, "dungeon",     0.3},			-- Ediger Kreis (1)
			{0.810, 0.090, 0.930, 0.240, 23,	"zone",    	   0.3},			-- Chrysialia
		},
		[23] = {-- Chrysalia
			{0.562, 0.723, 0.622, 0.800, 147, "dungeon",     0.3},				-- Knochennest der Kulech
			{0.010, 0.380, 0.097, 0.544, 22,	"zone",    	 0.3},				-- Rorazan
			{0.770, 0.150, 0.820, 0.230, 24,	"zone",    	 0.3},				-- Merdin Tundra
		},
		[24] = {-- Merdin Tundra
			{0.545, 0.340, 0.590, 0.410, 149, "dungeon",     0.3},				-- Burg von Bedim
			{0.060, 0.840, 0.150, 0.920, 23,	"zone",    	 0.3},				-- Chrysalia
			{0.070, 0.130, 0.150, 0.220, 25,	"zone",    	 0.3},				-- Syrbalpass
		},
 		[25] = {-- Syrbalpass
			{0.750, 0.470, 0.800, 0.550, 24,	"zone",    	 0.3},				-- Merdin Tundra
			{0.620, 0.260, 0.680, 0.283, 151,	"dungeon",   0.3},
			{0.020, 0.200, 0.100, 0.280, 26,	"zone",    	 0.3},				-- Sarlo
 		},
 		[26] = {-- Sarlo
			{0.82, 0.18, 0.93, 0.30, 25,	"zone",    	 0.3},  -- Syrbalpass
			{0.48, 0.85, 0.56, 0.92, 155,	"dungeon",   0.3},
 		},
 		[27] = {-- Wailing Fjord - Jammerf�rde
			{0.51, 0.03, 0.59, 0.13, 28,	"zone",    	 0.3},	-- Hurtekke jungle
			{0.31, 0.50, 0.37, 0.57, 158,	"dungeon",   0.3},
 		},
    	[28] = {-- Hurtekke jungle - Dschungel von Hortek
 			{0.40, 0.89, 0.47, 0.97, 27,	"zone",    	 0.3},	-- Wailing Fjord
 			{0.87, 0.29, 0.97, 0.37, 29,	"zone",    	 0.3},	-- XADIA_BASIN
			{0.64, 0.40, 0.71, 0.46, 161,	"dungeon",   0.3},
  		},
  		[29] = {-- XADIA_BASIN
 			{0.02, 0.58, 0.08, 0.66, 28,	"zone",    	 0.3},
 			{0.53, 0.07, 0.60, 0.14, 30,	"zone",    	 0.3},
  		},
  		[30] = {-- KATHALAN
 			{0.60, 0.87, 0.69, 0.97, 29,	"zone",    	 0.3},
  		},

		[31] = {-- H�hle von Yrvandis
			{0.680, 0.110, 0.740, 0.180, 212,    "zone",       0.3},					-- S�dlicher Stahlfels
		},
		[32] = {-- Splitwater
			{0.530, 0.010, 0.750, 0.160, 33,    "zone",       0.3},					-- Faytear uplands
			{0.652, 0.233, 0.700, 0.305, 170,   "dungeon",     0.3},				-- Knochenspitze
		},
		[33] = {-- Faytear uplands
			{0.22 , 0.860, 0.390, 0.980, 32,    "zone",       0.3},					-- Splitwater
			{0.237, 0.251, 0.285, 0.316, 173,   "dungeon",     0.3},				-- Hort der Madro-Trolle
			{0.470, 0.758, 0.514, 0.805, 176,   "dungeon",     0.3},				-- Rabenherz
		},
		[34] = {-- Tasqu
			{0.234, 0.204, 0.316, 0.250, 179,   "dungeon",     0.3},				-- Tal der Riten
		  },
    	[35] = {-- Korris
	      	{0.14, 0.24, 0.255, 0.275, 182,   "dungeon",     0.3},				-- Eisklingen Plateau
	    },
    	[36] = {--
	    	{0.44, 0.80, 0.51, 0.89, 185,   "dungeon",     0.3},				-- Sonnentemple
	    },
	  [37] = {-- Vortis
	    	{0.69, 0.28, 0.75, 0.37, 188,   "dungeon",     0.3},				-- Sonnentemple
	    },
	  [38] = {-- Chassizz
	    },
		[205] = {-- Revivers' Corridor - Auferstehungskorridor
			{0.782, 0.047, 0.878, 0.151, 206,   "dungeon",     0.3},					-- Guards' Corridor - Korridor der W�chter
			{0.074, 0.636, 0.184, 0.826, 5,     "zone",        0.3},					-- Ystra Highlands - Ystra-Hochland
		},
		[206] = {-- Guards' Corridor - Korridor der W�chter
			{0.488, 0.711, 0.594, 0.809, 205,   "dungeon",     0.3},					-- Revivers' Corridor - Auferstehungskorridor
			{0.858, 0.425, 0.956, 0.539, 207,   "dungeon",     0.3},					-- Royals' Refuge - Korridor der Zuflucht
			{0.488, 0.553, 0.594, 0.698, 5,     "zone",        0.3},					-- Ystra Highlands - Ystra-Hochland
		},
		[207] = {-- Royals' Refuge - Korridor der Zuflucht
			{0.654, 0.883, 0.736, 0.971, 206,   "dungeon",     0.3},					-- Guards' Corridor - Korridor der W�chter
			{0.654, 0.747, 0.736, 0.868, 5,     "zone",        0.3},					-- Ystra Highlands - Ystra-Hochland
		},
		[209] = {-- Dalanis Sewers - Kanalisation von Dalanis
			{0.458, 0.879, 0.604, 0.986, 127,   "dungeon",     0.3},					-- Dungeon of Dalanis - Kerker von Dalanis
			{0.275, 0.076, 0.366, 0.173, 15,    "zone",        0.3},					-- Thunderhoof Hills - Donnerhufh�gel
		},
		[209] = {-- Dalanis Sewers - Kanalisation von Dalanis
			{0.458, 0.879, 0.604, 0.986, 127,   "dungeon",     0.3},					-- Dungeon of Dalanis - Kerker von Dalanis
			{0.275, 0.076, 0.366, 0.173, 15,    "zone",        0.3},					-- Thunderhoof Hills - Donnerhufh�gel
		},

		},

--------------------------------------------------------------------------------------------------------------
--	ZoomOutTable: [ZoneID] = Zoom to ZoneID,
--------------------------------------------------------------------------------------------------------------
	ZoomOutTable = {
		[1] = 9998,			-- Howling Mountains - Heulende Berge
		[2] = 9998,			-- Silverspring - Silberquell
		[3] = 9998,			-- Ravenfell - Rabenfeld
		[4] = 9998,			-- Aslan - Aslan-Tal
		[5] = 9998,			-- Ystra - Ystra-Hochland
		[6] = 9998,			-- Dust Devil Canyon - Staubteufel-Canyon
		[7] = 9998,			-- Weeping Coast - K�ste der Wehklagen
		[8] = 9998,			-- Savage Lands - Wilde Lande
		[9] = 9998,			-- Aotulia Vulcano - Aotulia Vulkan
		[10] = 9998,		-- Sascilia Steppes - Sascilia Steppe
		[11] = 9998,		-- Dragonfang Ridge - Drachenzahngebirge
		[12] = 9998,		-- Elven Island - Elfeninsel
		[13] = 9999,		-- Coast of Opportunity
		[14] = 9999,		-- Xaviera
		[15] = 9997,		-- Thunderhoof Hills - Donnerhufh�gel
		[16] = 9997,		-- Southern Janost Forest - S�dlicher Janostwald
		[17] = 9997,		-- Northern Janost Forest - N�rdlicher Janostwald
		[18] = 9997,	    -- Limo Desert
		[19] = 9997,		-- Land of Malevolence - Land des Unheils
		[20] = 9997,		-- Redhill Mountains - Roth�gelberge
		[21] = 9997,		-- Tergothenbay
		[22] = 9996,		-- Altes K�nigreich von Rorazan
		[23] = 9996,		-- Chy
		[24] = 9996,		-- Merdin Tundra
		[25] = 9996,		-- Serbayt Pass
		[26] = 9996,		-- Sarlo
		[27] = 9995,		-- Wailing Fjord - Jammerf�rde
		[28] = 9995,		-- Hurtekke jungle - Dschungel von Hortek
		[29] = 9995,		-- XADIA_BASIN
		[30] = 9995,		-- KATHALAN
		[31] = 9999,		-- H�hlen von Yrvandis
		[32] = 9999,		-- Splitwater
		[33] = 9999,		-- Faytear uplands
		[34] = 9993,		-- Tasuq
		[35] = 9993,		-- KulusIsland
		[36] = 9993,		-- EnochIsland
		[37] = 9993,		-- Vortis
		[38] = 9993,		--

		[80] = 20,			-- BUGGY - Underground of the fire... - Untergrund des Feuerstiefel
		[100] = 1,			-- Tutorial - Einf�hrungsgebiet
		[101] = 1,			-- Cavern of Trials - H�hle der Pr�fungen
		[102] = 2,			-- Forsaken Abbey - Verlassene Abtei
		[103] = 4,			-- Necropolis of Mirrors - Gr�berstadt der Spiegel
		[104] = 5,			-- Mystic Altar - Mystischer Altar
		[105] = 6,			-- Queen's Chamber - K�niginnenkammer
		[106] = 10,			-- Pasper's Shrine - Schrein von Pasper
		[107] = 6,			-- Shrine of Kalin - Schrein von Kalin
		[108] = 3,			-- Treasure Trove - Schatzh�hle
		-- [109] = 206,		-- Troublemaker - Ghost Guard Creator
		[110] = 1,			-- Barren Caves - Karge H�hlen
		-- [111] = 207,		-- Ancient Rune Technology - Rune Guardian Leader
		-- [112] = 207,		-- A Sudden Setback - Raichika the Destroyer
		[113] = 11,			-- Ruins of the Ice Dwarf Kingdom - Ruinen des Eiszwergk�nigreiches (35)
		[114] = 11,			-- Ruins of the Ice Dwarf Kingdom - Ruinen des Eiszwergk�nigreiches (50)
		[115] = 7,			-- Ocean's Heart - Herz des Ozeans
		[116] = 4,			-- Origin - Ursprung
		[117] = 2,			-- Hall of Survivors - Halle der �berlebenden
		[118] = 1,			-- Cave of the Water Dragon - H�hle des Wasserdrachen
		[119] = 9,			-- Lair of the Demon Dragon - Hort des D�monendrachen
		[120] = 9,			-- Zuridon Stronghold - Zurhidonfeste
		[122] = 9,			-- Hall of the Demon Lord - D�monenfeste
		[123] = 2,			-- Hall of Survivors (easy) - Halle der �berlebenden (leicht)
		[126] = 7,			-- Ocean's Heart - Herz des Ozeans
		[127] = 209,		-- Dungeon of Dalanis - Kerker von Dalanis (normal and easy)
		[128] = 209,		-- Dungeon of Dalanis - Kerker von Dalanis (not used?)
		[129] = 16,			-- Warnorken Arena - Arena von Warnorken (normal and easy)
		[130] = 17,			-- Raksha Temple - Tempel der Raksha
		[131] = 16,			-- Warnorken Arena - Arena von Warnorken (not used?)
		[132] = 17,			-- Raksha Temple - Tempel der Raksha
		[133] = 17,			-- Raksha Temple - Tempel der Raksha
		[134] = 18,			-- Kawak's Tomb
		[135] = 18,			-- Kawak's Tomb
		[136] = 19,			-- Castle Grafu - Burg Grafu HM
		[137] = 19,			-- Castle Grafu - Burg Grafu
		[138] = 19,			-- Castle Grafu - Burg Grafu
		[139] = 20,			-- Castle Sardo - Burg Sardo
		[140] = 20,			-- Castle Sardo - Burg Sardo
		[141] = 15,			-- Tomb of seven hereos
		[142] = 15,			-- Tomb of seven hereos
		[143] = 15,			-- Tomb of seven hereos
		[146] = 23,			-- Knochennest der Kulech
		[147] = 23,			-- Knochennest der Kulech
		[148] = 23,			-- Knochennest der Kulech
		[149] = 24,			-- Burg von Bedim
		[150] = 24,			-- Burg von Bedim
		[151] = 25,         -- dgn_boutman_haunt
		[152] = 25,
		[153] = 25,
		[154] = 26,      -- Belathis
		[155] = 26,      -- Belathis
		[156] = 26,         -- Belathis
		[157] = 27,         -- Grotte des Grauens
		[158] = 27,         -- Grotte des Grauens
		[159] = 27,         -- Grotte des Grauens
		[160] = 28,         -- Muraifen
		[161] = 28,         -- Muraifen
		[162] = 28,         -- Muraifen
		[163] = 29,       -- Krypta der Ewigkeit
		[164] = 29,       -- Krypta der Ewigkeit
		[165] = 29,       -- Krypta der Ewigkeit
		[166] = 30,       -- Gew�lbe
		[167] = 30,       -- Gew�lbe
		[168] = 30,       -- Gew�lbe
		[169] = 32,       -- Knochenspitze
		[170] = 32,       -- Knochenspitze
		[171] = 32,       -- Knochenspitze
		[172] = 33,       -- Hort der Madro-Trolle
		[173] = 33,       -- Hort der Madro-Trolle
		[174] = 33,       -- Hort der Madro-Trolle
		[175] = 33,       -- Rabenherz
		[176] = 33,       -- Rabenherz
		[177] = 33,       -- Rabenherz
		[178] = 34,		  	-- Tal der Riten
		[179] = 34,			-- Tal der Riten
		[180] = 34,			-- Tal der Riten
		[181] = 35,		  	-- Eisklingen Plateau
		[182] = 35,			-- Eisklingen Plateau
		[183] = 35,			-- Eisklingen Plateau
   		[184] = 36,     -- Sonnentemple
    	[185] = 36,     -- Sonnentemple
    	[186] = 36,     -- Sonnentemple
   		[187] = 37,     -- dead souls
    	[188] = 37,     -- dead souls
    	[189] = 37,     -- dead souls
		[190] = 2,			-- Graben von Bolinthya
		[191] = 9998,		-- Osalontal
		[194] = 10000,		-- Chaoswirbel

		[201] = 2,			-- Bloody Gallery - Blutige Galerie
		[202] = 5,			-- Revivers' Corridor - Auferstehungskorridor
		[203] = 5,			-- Guards' Corridor - Korridor der W�chter
		[204] = 5,			-- Royals' Refuge - Korridor der Zuflucht
		[205] = 5,			-- Revivers' Corridor - Auferstehungskorridor
		[206] = 5,			-- Guards' Corridor - Korridor der W�chter
		[207] = 5,			-- Royals' Refuge - Korridor der Zuflucht
		[208] = 10000,	-- Varanas Nightmare - Albtraum von Varanas
		[209] = 11002,	-- Dalanis Sewers - Kanalisation von Dalanis
		[210] = 16,			-- Ruines of Magnork - Ruinen von Magnork
		[211] = 20,			-- Underground of the fire... - Untergrund des Feuerstiefel
		[212] = 31,     -- S�dlicher Stahlfels

		[250] = 1,			-- Windmill Basement - Windm�hlenkeller
		[251] = 10,			-- Arcane Chamber of Sathkur - Arkane Kammer des Sathkur
		[252] = 11,			-- Cyclops Lair - H�hle der Zyklopen

		[301] = 1,			-- Fungus Habitat - Pilzgarten
		[302] = 6,			-- Wind Wild Animus - Seele der Sturmh�he
		[303] = 10000,	-- Wedding Hall - Hochzeitssaal  (not there yet)
		[304] = 9999,		-- Miller's Farm (no functional map in this zone)
		[350] = 10000,	-- Windrunner Race - Windl�ufer-Rennen
		[351] = 10000,	-- Maladina (no functional map in this zone)
		[352] = 4,			-- Goblin Mines - Goblin-Mine
		[353] = 10000,	-- Maladina 2 (no functional map in this zone)

		[358] = 9998,		-- Ystra - Ystra-Hochland - Cloned

		[400] = 9999,		-- Residence (no functional map in this zone)
		[401] = 9999,		-- Guild Castle - Gildenburg
		[402] = 9999,		-- Guild Castle - Gildenburg
		[410] = 10001,		-- 1vs1 Arena - 1 gegen 1 Arena
		[411] = 10001,		-- 6vs6 Arena - 6 gegen 6 Arena
		[430] = 10001,		-- 3vs3 Arena - 3 gegen 3 Arena
		[431] = 10001,		-- Karros Canyon - Karros-Schlucht (CTF Battleground)
		[432] = 10001,		-- Visdun Fortress - Visdun-Festung (Tower Defense)
		[440] = 10001,		-- 1vs1 Arena - 1 gegen 1 Arena
		[441] = 10000,		-- Windrunner Race - Windl�ufer-Rennen
		[442] = 10001,		-- 3vs3 Arena - 3 gegen 3 Arena
		[443] = 10001,		-- 6vs6 Arena - 6 gegen 6 Arena
		[444] = 10001,		-- Karros Canyon - Karros-Schlucht (CTF Battleground)
		[445] = 10001,		-- Visdun Fortress - Visdun-Festung (Tower Defense)
		[446] = 10001,		-- Tyrefen Mountain Range - Tryefen Berge (??? Battleground)
		[450] = 10001,		-- Vermillia Basin (GvG Battleground) (not there yet)

		[9993] = 9999,		-- Isles (worldmap)
		[9995] = 9999,		-- Gerador (worldmap)
		[9996] = 9999,		-- Balanzasar (worldmap)
		[9997] = 9999,		-- Zandorya (worldmap)
		[9998] = 9999,		-- Candara (worldmap)
		[9999] = 9999,		-- Taborea (worldmap)

		[10000] = 2,		-- Varanas - Varanas
		[10001] = 6,		-- Obsidian Stronghold - Obsidianfeste
		[144] = 22,		-- Ewiger Kreis
		[145] = 22,		-- Ewiger Kreis
		[10002] = 22,		-- Ewiger Kreis
		[10003] = 22,		-- Ewiger Kreis
		[10004] = 22,		-- Ewiger Kreis
		[10005] = 22,		-- Ewiger Kreis
		[11002] = 15,		-- Dalanis - Dalanis
		},

--------------------------------------------------------------------------------------------------------------
-- CustomMaps
--		This is for custom sub/city maps
--      -> kind = see g_MapTypes in worldmap.lua (0=world(!), 1=zone,2=city,..)
--      -> coords_transpose = is used to calculate player position & Quest Icons
--                            [real_map] = {x1,y1,x2,y2}
--------------------------------------------------------------------------------------------------------------
    CustomMaps = {
        maps= {
--~             [9994] = {dir="kolydia", name=TEXT("ZONE_KOLYDIA"), kind=0,
--~                     },

			[9993] = {dir="isles", name="Isles", kind=0,
					coords_transpose={
						[34] = { 0.115, 0.477, 0.286, 0.651}, -- 34
						[35] = { 0.266, 0.237, 0.529, 0.507}, -- 35
						[36] = { 0.507, 0.160, 0.728, 0.383}, -- 36
						[37] = { 0.359, 0.523, 0.621, 0.775}, -- 37
						[38] = { 0.559, 0.315, 0.894, 0.651}, -- 38						
					}
			},
            [9995] = {dir="gerador", name=TEXT("SC_GDDR_00"), kind=0,
                      coords_transpose={[27]={0.286, 0.540, 0.560, 0.795},
										[28]={0.325, 0.325, 0.565, 0.570},
										[29]={0.520, 0.265, 0.775, 0.510},
										[30]={0.535, 0.080, 0.740, 0.300},
                                        }
                    },
            [9996] = {dir="balanzasar", name=TEXT("SC_BALANZASAR"), kind=0,
                      coords_transpose={[22]={0.327, 0.502, 0.530, 0.731},
										[23]={0.470, 0.405, 0.710, 0.665},
										[24]={0.629, 0.237, 0.880, 0.550},
										[25]={0.470, 0.180, 0.725, 0.455},
										[26]={0.280, 0.190, 0.550, 0.490},
                                        }
                    },
            [9997] = {dir="zandorya", name=TEXT("ZONE_SAVILLEPLAINS"), kind=0,
            coords_transpose={
                  [15]={0.400, 0.670, 0.670, 0.890},
                  [16]={0.455, 0.530, 0.655, 0.690},
                  [17]={0.520, 0.400, 0.685, 0.540},
                  [18]={0.537, 0.130, 0.768, 0.420},
                  [19]={0.460, 0.110, 0.590, 0.265},
                  [20]={0.400, 0.270, 0.530, 0.430},
                  [21]={0.195, 0.345, 0.400, 0.560},
                  }
            },

            [9998] = {dir="Candara",  name="Candara", kind=0,
					  coords_transpose={
                 [1]={0.460, 0.550, 0.580, 0.744},
                 [2]={0.485, 0.370, 0.617, 0.556},
                 [3]={0.596, 0.348, 0.783, 0.570},
                 [4]={0.397, 0.385, 0.526, 0.565},
                 [5]={0.284, 0.514, 0.468, 0.706},
                 [6]={0.264, 0.275, 0.458, 0.538},
                 [7]={0.616, 0.120, 0.838, 0.373},
                 [8]={0.430, 0.105, 0.640, 0.373},
                 [9]={0.211, 0.001, 0.464, 0.297},
                [10]={0.021, 0.410, 0.310, 0.715},
                [11]={0.080, 0.680, 0.340, 0.890},
                [12]={0.823, 0.428, 0.933, 0.574},
                [10001]={0.266, 0.442, 0.333, 0.528},
                [11002]={0.550, 0.531, 0.601, 0.601},
                }
					  },

            [9999] = {dir="Taborea",  name="Taborea", kind=-1,
					  coords_transpose={ --[9998] = {0.287,0.503,0.679,0.894},
										-- Candara
										 [1]={0.378, 0.810, 0.436, 0.893},
										 [2]={0.400, 0.722, 0.450, 0.807},
										 [3]={0.446, 0.722, 0.507, 0.815},
										 [4]={0.351, 0.737, 0.402, 0.817},
										 [5]={0.303, 0.794, 0.378, 0.879},
										 [6]={0.295, 0.701, 0.368, 0.798},
										 [7]={0.453, 0.632, 0.544, 0.727},
										 [8]={0.376, 0.619, 0.450, 0.731},
										 [9]={0.283, 0.579, 0.381, 0.699},
										[10]={0.204, 0.752, 0.305, 0.867},
										[11]={0.211, 0.861, 0.331, 0.964},
										[12]={0.545, 0.720, 0.594, 0.778},
										-- Xaviera/Oportunity
										[13]={0.020, 0.683, 0.130, 0.818},
										[14]={0.070, 0.677, 0.150, 0.773},
										-- Zandorya
										[15]={0.117, 0.490, 0.224, 0.590},
										[16]={0.137, 0.432, 0.212, 0.497},
										[17]={0.163, 0.371, 0.240, 0.436},
										[18]={0.184, 0.260, 0.258, 0.373},
										[19]={0.132, 0.240, 0.194, 0.300},
										[20]={0.098, 0.303, 0.180, 0.383},
										[21]={0.021, 0.331, 0.102, 0.453},
										-- Balanzasar
										[22]={0.679, 0.255, 0.790, 0.361},
										[23]={0.768, 0.205, 0.868, 0.335},
										[24]={0.850, 0.113, 0.961, 0.268},
										[25]={0.763, 0.079, 0.893, 0.207},
										[26]={0.673, 0.075, 0.790, 0.235},
										-- Gerador
										[27]={0.404, 0.220, 0.480, 0.300},
										[28]={0.417, 0.139, 0.492, 0.225},
										[29]={0.492, 0.138, 0.560, 0.203},
										[30]={0.485, 0.056, 0.552, 0.139},
										-- Yrvandis
										[31]={0.264, 0.520, 0.303, 0.574},
										-- Kolydia
										[32]={0.623, 0.805, 0.721, 0.912},
										[33]={0.655, 0.720, 0.735, 0.817},
										-- Isles
										[34] = { 0.679, 0.568, 0.737, 0.632}, -- 34
										[35] = { 0.726, 0.496, 0.803, 0.579}, -- 35
										[36] = { 0.784, 0.470, 0.864, 0.538}, -- 36
										[37] = { 0.761, 0.586, 0.837, 0.677}, -- 37
										[38] = { 0.815, 0.522, 0.919, 0.625}, -- 38										
										--[10001]={0.475, 0.708, 0.498, 0.748},
										--[11002]={0.749, 0.711, 0.601, 0.761},
										--[9997]={0, 		0.164, 	0.554, 0.755},
										--[9999]={0.445, 	0.417, 	1, 	   0.971},
										}
                    },

            [11002]= {dir="Dalanis",  name=TEXT("ZONE_DAELANIS"), kind=2,
                      coords_transpose={[15]={-1.4947,-1.4929,2.3574,2.507}
                                        }
                    },
            [400] = {dir="Taborea", name=TEXT("ZONE_DEFAULT"), kind=7,},
        },
--------------------------------------------------------------------------------------------------------------
--		"parents" defines sub-zones.
--      This is used to test if a player is in one of our custome subzones
--        [real_map_id] = { [sub_zone_id]={x1,y1,x2,y2}, ....}
--------------------------------------------------------------------------------------------------------------
        parents= {
           [15] = { [11002]={0.467, 0.404, 0.610, 0.581} },
           [400] = { [9998]={0, 0, 1, 1} },
        }
    }
}



local overrides, err = loadfile("Interface/Addons/WoWMap/overrides/".. (WoWMap.Data.Language)..".lua")
if not err then
    overrides()
else
    WoWMap.MapData.Overrides={}
end
