-- coding: utf-8
--[[

 Childs: sub-map coords
 Zones:  are used as a fallback coord if nothing is found in DB

 Porter -> Definition of transport notes
     {x,y, flag,name}
       -> flag indicates if porter is available
       -> name TEXT(name) is the text which is shown in porter-npc dialog

 link-> Transport notes
    { porter_nr, target_map, target_porter, type , costs, name }
        ->type = nil/0 -> walkway; costs = additional way
          type = 1 -> Porter  ; costs = Gold
          type = 2 -> in-map porter
        -> name TEXT(name) is the text which is shown in porter-npc dialog
            Note: use this in case the text is not always the same
--]]

return {

------------------------------------------------------
[9998] ={  -- Candara (Yggno Land)
    childs = {
        [1]   = {left = 0.430, top = 0.570, right = 0.630, bottom = 0.740},
        [2]   = {left = 0.475, top = 0.400, right = 0.640, bottom = 0.590},
        [3]   = {left = 0.563, top = 0.348, right = 0.800, bottom = 0.580},
        [4]   = {left = 0.375, top = 0.400, right = 0.555, bottom = 0.585},
        [5]   = {left = 0.250, top = 0.510, right = 0.490, bottom = 0.750},
        [6]   = {left = 0.230, top = 0.285, right = 0.470, bottom = 0.560},
        [7]   = {left = 0.600, top = 0.127, right = 0.860, bottom = 0.375},
        [8]   = {left = 0.390, top = 0.100, right = 0.650, bottom = 0.390},
        [9]   = {left = 0.250, top = 0.100, right = 0.400, bottom = 0.350},
        [10]  = {left = 0.040, top = 0.428, right = 0.350, bottom = 0.730},
        [11]  = {left = 0.070, top = 0.640, right = 0.340, bottom = 0.900},
        [12]  = {left = 0.810, top = 0.440, right = 0.940, bottom = 0.570},
        [22]  = {left = 0.630, top = 0.310, right = 0.740, bottom = 0.440},
        [23]  = {left = 0.740, top = 0.300, right = 0.820, bottom = 0.370},
        [24]  = {left = 0.840, top = 0.100, right = 0.950, bottom = 0.370}, -- TODO: coords
        [25]  = {left = 0.490, top = 0.220, right = 0.640, bottom = 0.400}, -- TODO: coords
        [26]  = {left = 0.310, top = 0.210, right = 0.480, bottom = 0.480}, -- TODO: coords
        [31]  = {left = 0.380, top = 0.590, right = 0.410, bottom = 0.620},
    },
    zones = {},
  },

[9997] ={   -- TODO: need data
    childs = {
        [13]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [14]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [15]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [16]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [17]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [18]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [19]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [20]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [21]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
    },
    zones = {},
  },

[9996] ={   -- TODO: need data
    childs = {
        [22]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [23]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [24]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [25]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [26]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
    },
    zones = {},
  },

[9995] ={   -- TODO: need data
    childs = {
        [27]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [28]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [29]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [30]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
    },
    zones = {},
  },
[9994] ={   -- TODO: need data -- dummy
    childs = {
        [32]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [33]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [34]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [35]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [36]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [37]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
        [38]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
    },
    zones = {},
  },

------------------------------------------------------
-- Zones
------------------------------------------------------
[1] = { -- Howling Mountains - Heulende Berge
    parent = 9998,
    childs = {
        [100] = {left = 0.02, top = 0.60, right = 0.14, bottom = 0.70},
        [101] = {left = 0.64, top = 0.28, right = 0.74, bottom = 0.38},
        [110] = {left = 0.15, top = 0.05, right = 0.25, bottom = 0.15},
        [118] = {left = 0.76, top = 0.30, right = 0.80, bottom = 0.34},
        [250] = {left = 0.50, top = 0.35, right = 0.60, bottom = 0.45},
        [301] = {left = 0.36, top = 0.53, right = 0.46, bottom = 0.63},
        },
    zones = {
        [ 1]={0.31,0.68}, -- Pioniersiedlung
        [2]={}, -- Talgrund-Mine
        [ 3]={0.50,0.42}, -- Logar
        [4]={}, -- Mondklamm
        [ 5]={0.32,0.39}, -- Sewaida-Wald
        [6]={},  -- Höhle im toten Baum
        [ 7]={0.36,0.19}, -- Hügelgrab
        [ 8]={0.22,0.12}, -- Karge Höhlen
        [16]={0.5, 0.5 }, -- Handwerk
        [96]={0.29,0.19}, -- Heulende Berge (Lomgartpass (?))
        [108]={}, -- Karge Höhlen
        },
    porter = {
        {0.515,-0.02}, -- [1] = Walkway to Silverspring
        {0.470,0.375,541313,"SC_111256_1"}, -- [2] = Porter
        {0.692,0.345}, -- [3] = Dgn: Cavern of Trials
        {0.232,0.142}, -- [4] = Dgn: Barren Caves
        {0.541,0.468}, -- [5] = Dgn: Windmill Basement
        {0.407,0.577}, -- [6] = Dgn: Fungus Habitat
        {0.750,0.366}, -- [7] = Dgn: Moonspring Hollow
        },
    link={
        {1, 2,1},
        {2, 2,6, 1, 10,"SC_111256_2"},
        {3, 101,1},
        {4, 110,1},
        {5, 250,1},
        {6, 301,1},
        {7, 118,1},
        },
  },

[2] = { -- Silverspring - Silberquell
    parent = 9998,
    childs = {
        [102] = {left = 0.30, top = 0.60, right = 0.40, bottom = 0.70},
        [117] = {left = 0.46, top = 0.05, right = 0.54, bottom = 0.11},
        [190] = {left = 0.33, top = 0.27, right = 0.37, bottom = 0.31},
        [201] = {left = 0.30, top = 0.60, right = 0.40, bottom = 0.70},
        [10000]= {left = 0.5, top = 0.78, right = 0.75, bottom = 1.00},
        },
    zones =  {
        [9] ={0.62, 0.90}, -- Varanas
        [10]={0.57, 0.72}, -- Peers Hof
        [11]={0.52, 0.58}, -- Maidges Hof
        [12]={}, -- Dorians Hof
        [13]={0.52, 0.24}, -- Tagena
        [97]={0.62, 0.41}, -- Ebene von Silberquell
      	[102]={0.55,0.20}, -- (Episch) Blutiges Dämonenschwert
        },
    porter = {
        {0.335,0.997},  -- [1] = Walkway to Howling Mountains
        {0.745,0.680},  -- [2] = Walkway to Ravenfell
        {0.303,0.213},  -- [3] = Walkway to Aslan
        {0.548,0.868},  -- [4] = Walkway to Varanas
        {0.512,0.021},  -- [5] = Walkway to Savage lands
        {0.483,0.784,541314, "SO_110944_4"},  -- [6] = Porter
        {0.379,0.666},  -- [7] = Dgn: Forsaken Abbey
        {0.336,0.664},  -- [8] = Dgn: Bloody Gallery
        {0.336,0.664},  -- [9] = Dgn: Hall of Survivors
        {0.507,0.798,0,"SO_110561_10"}, -- [10] = Tele: Varanas
        {0.372,0.301}, -- [11] = Dgn: Graben von Bolinthya
        },
    link={
        {1, 1,1},
        {2, 3,1},
        {3, 4,1},
        {4, 10000,1},
        {5, 8,2},
        {6, 1,2, 1,10},
        {6, 3,3, 1,750},
        {6, 4,3, 1,250},
        {6, 13,1, 1, 10},
        {6, 10001,3, 1,50, "SC_111256_6"},
        {6, 31,1, 1,10},
        {6, 12,2, 1,10},
        {7, 102,1},
        {8, 201,1},
        {9, 117,1},
        {10, 10000,5 ,2}, {10, 10000,6 ,2}, {10, 10000,7 ,2}, {10, 10000,8 ,2}, {10, 10000,9 ,2}, {10, 10000,10 ,2},
        {11, 190,1},
        },
  },

[3] = { -- Ravenfell - Rabenfeld
    parent = 9998,
    childs = {
        [108] = {left = 0.34, top = 0.78, right = 0.39, bottom = 0.84},
        },
    zones =  {
        [121]={0.23,0.83}, -- Hafen ohne Namen
        [122]={}, -- Sturmpass
        [123]={}, -- Haus Calamus
        [124]={}, -- Schwarzsegel-Lager
        [125]={}, -- Seemannsfriedhof
        [126]={0.42,0.54}, -- Verlassene Festung
        [127]={0.41,0.63}, -- Skorpionebene
        [128]={}, -- Flügelsee
        [129]={0.28,0.38}, -- Thron des Windes
        [130]={0.76,0.35}, -- Schattenmondbucht
        [131]={0.61,0.33}, -- Kettenkueste
        [132]={0.38,0.26}, -- Geisterstadt
        },
    porter = {
        {0.158,0.761},  -- [1] = Walkway to Silverspring
        {0.456,0.213},  -- [2] = Walkway to Weeping Coast
        {0.458,0.537,542297},  -- [3] = Porter
        {0.368,0.806},  -- [4] = Dgn: Treasure Trove
        },
    link={
        {1, 2,2},
        {2, 7,1},
        {3, 2,6, 1,750},
        {3, 7,3, 1,1000},
        {4, 108,1},
        },
  },

[4] = { -- Aslan - Aslan-Tal
    parent = 9998,
    childs = {
        [103] = {left = 0.60, top = 0.83, right = 0.70, bottom = 0.93},
        [116] = {left = 0.24, top = 0.31, right = 0.27, bottom = 0.35},
        },
    zones =  {
        [15]={0.56,0.63}, -- Aslantal
        [19]={}, -- Verfallene Mine
        [20]={0.62,0.44}, -- Waldland von Qilana
        [21]={0.42,0.27}, -- Bluthundberg
        [22]={}, -- Goblindorf
        [23]={}, -- Jade-Tal
        [24]={}, -- Qilana-See
        [25]={}, -- Neumondwald
        [26]={}, -- See des ewigen Schweigens
        [28]={0.56,0.64}, -- Silberfall
        [29]={}, -- Krawallmine
        },
    porter = {
        {0.791,0.209},  -- [1] = Walkway to Silverspring
        {0.400,0.944},  -- [2] = Walkway to Ystra
        {0.530,0.670,541315,"SC_111256_4"}, -- [3] = Porter
        {0.638,0.894},  -- [4] = Dgn: Necropolis
        {0.212,0.254},  -- [5] = Dgn: Origin
        },
    link={
        {1, 2,3},
        {2, 5,1},
        {3, 2,6, 1,250},
        {3, 5,4, 1,500},
        {4, 103,1},
        {5, 116,1},
        },
 },

[5] = { -- Ystra - Ystra-Hochland
    parent = 9998,
    childs = {
        [104] = {left = 0.48, top = 0.77, right = 0.58, bottom = 0.87},
        [205] = {left = 0.29, top = 0.47, right = 0.39, bottom = 0.57},
        [206] = {left = 0.17, top = 0.47, right = 0.27, bottom = 0.57},
        [207] = {left = 0.23, top = 0.40, right = 0.33, bottom = 0.50},
        },
    zones =  {
        [30]={0.48,0.23}, -- Ystra-Hochland
        [31]={0.43,0.15}, -- Khalara-Wachtturm
        [32]={0.49,0.23}, -- Harf-Handelsposten
        [33]={0.28,0.14}, -- Turm der tosenden Winde
        [34]={0.54,0.33}, -- Khazors Wachtturm
        [36]={0.59,0.70}, -- Schneehorn
        [37]={0.37,0.30}, -- Schneemeer
        [38]={}, -- Schneemeer-Lager
        [39]={0.26,0.56}, -- Winternacht-Tal
        [40]={0.73,0.40}, -- Frostholztal
        },
    porter = {
        {0.647,0.289},  -- [1] = Walkway to Aslan
        {0.329,0.625},  -- [2] = Walkway to Dragonfang
        {0.418,0.111},  -- [3] = Walkway to Dust Devil
        {0.464,0.203,541316,"ZONE_HAROLFE TRADING POST"}, -- [4] = Porter
        {0.530,0.835},  -- [5] = Dgn: Mystic Altar
        {0.463,0.203,0,"ZONE_HAROLFE TRADING POST"},  -- [6] = Dgn: Ystra-Lab
        {0.413,0.490},  -- [7] = Walkway to Ystra-Lab
        },
    link={
        {1, 4,2},
        {2, 11,1},
        {3, 6,3},
        {4, 4,3,  1,500},
        {4, 11,3, 1,500},
        {4, 10001,3, 1,750},
        {5, 104,1},
        {6, 205,1},
        {6, 206,1},
        {6, 207,1},
        {7, 205,1},
        },
  },

[6] = { -- Dust Devil Canyon - Staubteufel-Canyon
    parent = 9998,
    childs = {
        [105] = {left = 0.41, top = 0.58, right = 0.51, bottom = 0.68},
        [107] = {left = 0.37, top = 0.32, right = 0.42, bottom = 0.38},
        [302] = {left = 0.66, top = 0.24, right = 0.76, bottom = 0.34},
        [10001]=  {left = 0.15, top = 0.65, right = 0.40, bottom = 0.85},
        },
    zones =  {
        [41]={0.50,0.50}, -- Staubteufel-Canyon
        [42]={}, -- Große Mine
        [43]={0.44,0.62}, -- Kal-Turok-Bau
        [44]={}, -- Karzak-Lager
        [45]={0.56,0.49}, -- Plateau der Gefallenen
        [46]={0.60,0.40}, -- Schlachtfeld der Helden
        [47]={0.72,0.28}, -- Sturmhöhe
        [48]={}, -- Falkenklippe
        [50]={0.29,0.73}, -- Obsidianfeste
        [51]={}, -- Lagerplatz der Vender-Karawane
        [52]={}, -- Frostholztal-Lager
        [53]={}, -- Fuchsspurenhöhle
        [54]={0.43,0.38}, -- Ousul-See
        [55]={0.52,0.67}, -- Khalara Hochebene
        [56]={0.40,0.52}, -- Zwielichtminen
        [57]={0.50,0.63}, -- Garnision des Ordens der Dunklen Glorie
        },
    porter = {
        {0.104,0.813},  -- [1] = Walkway to Sascillia
        {0.282,0.868},  -- [2] = Walkway to Obsidian
        {0.611,0.885},  -- [3] = Walkway to Ystra
        {0.370,0.675},  -- [4] = Walkway to Obsidian
        {0.455,0.638},  -- [5] = Dgn: Queen's Chamber
        {0.435,0.375},  -- [6] = Dgn: Shrine of Kalin
        {0.700,0.320},  -- [7] = Dgn: Wind Wild Animus
        },
    link={
        {1, 10,2},
        {2, 10001,1},
        {3, 5,3},
        {4, 10001,2},
        {5, 105,1},
        {6, 107,1},
        {7, 302,1},
        },
  },

[7] = { -- Weeping Coast - Küste der Wehklagen
    parent = 9998,
    childs = {
        [115] = {left = 0.76, top = 0.58, right = 0.80, bottom = 0.64},
              },
    zones =  {
        [135]={0.50,0.50}, -- Küste des Wehklagens
        [136]={0.33,0.82}, -- Ayal-Aussenposten
        [137]={0.52,0.74}, -- Ayal-Klan
        [138]={0.38,0.70}, -- Schlammteichdorf
        [139]={0.39,0.40}, -- Ayak-Klan
        [140]={0.55,0.59}, -- Ayat-Klan
        [141]={0.71,0.54}, -- Ayam-Klan
        [142]={0.53,0.83}, -- Fischmaulbucht
        [143]={0.45,0.87}, -- Schmugglerlager
        [144]={0.59,0.42}, -- Windklippendorf
        [145]={}, -- Klippe des sprechenden Windes
        [146]={0.78,0.22}, -- Thron des Wassers
        [147]={0.52,0.22}, -- Murmelnder Wald
        [148]={0.47,0.34}, -- Hartschäl-Klan
        [149]={}, -- Blutzahn-Klan
        [150]={0.38,0.33}, -- Bungasee
        [151]={0.27,0.42}, -- Dschungelsumpf
	    [152]={}, -- Blutverschmutzter Tül
	    [153]={}, -- Heldengrab
        [154]={0.15,0.33}, -- Naga-Aussenposten
	    [199]={0.46,0.70}, -- Epic
        },
    porter = {
        {0.293,0.990},  -- [1] = Walkway to Ravenfell
        {0.078,0.316},  -- [2] = Walkway to Savage lands
        {0.561,0.447,542498,"SC_111256_3"}, -- [3] = Porter
        {0.782,0.600},  -- [4] = Dgn: Ocean's Heart
        },
    link={
        {1, 3,2},
        {2, 8,1},
        {3, 3,3, 1,1000},
        {3, 8,4, 1,1250},
        {4, 115,1},
        },
  },

[8] = { -- Savage lands - Wilde Lande
    parent = 9998,
    childs = {},
    zones =  {
        [162]={0.50,0.50}, -- Wilde Lande
        [163]={0.54,0.77}, -- Affenberg
        [164]={0.70,0.50}, -- Grüner Turm
        [165]={0.64,0.27}, -- Naga Versorgungslinie
        [166]={0.75,0.25}, -- Naga-Lager
        [167]={0.56,0.10}, -- Weissreihersee
        [168]={0.43,0.48}, -- Daemonennarbe
        [169]={0.46,0.61}, -- Luzan
        [170]={0.40,0.35}, -- Haz
        [171]={0.52,0.41}, -- Rufa
        [172]={0.40,0.66}, -- Eduth
        [173]={0.68,0.70}, -- Sanburs-Lager
      	[174]={}, -- Mirdor-Lager
        [175]={0.35,0.52}, -- Wayt-Lager
        [176]={0.50,0.33}, -- Norzen-Lager
        [177]={0.24,0.53}, -- Funguswalk Kilanche
        [178]={}, -- Bannmauer
        [200]={0.24,0.56}, -- (Episch)
        },
    porter = {
        {0.833,0.349},  -- [1] = Walkway to Weeping Coast
        {0.619,0.958},  -- [2] = Walkway to Silverspring
        {0.309,0.343},  -- [3] = Walkway to Aotulia
        {0.734,0.523,542744},  -- [4] = Porter
        },
    link={
        {1, 7,2},
        {2, 2,5},
        {3, 9,1},
        {4, 7,3, 1,1250},
        {4, 9,2, 1,1500},
        },
  },

[9] = { -- Aotulia Vulcano - Aotulia Vulka (not there yet)
    parent = 9998,
    childs = {
        [119] = {left = 0.27, top = 0.60, right = 0.38, bottom = 0.72},
        [120] = {left = 0.30, top = 0.23, right = 0.38, bottom = 0.31},
        [122] = {left = 0.30, top = 0.14, right = 0.38, bottom = 0.23},
        },
    zones =  {
        [182]={0.72,0.62}, -- Dimarka
        [183]={0.67,0.82}, -- Felder der toten Baeume
        [184]={0.63,0.89}, -- Hoellentor
        [185]={0.66,0.76}, -- Titanenhuegel
        [186]={0.59,0.60}, -- Teufelsmaul
	    [187]={0.50,0.83}, -- Tal des brennenden Fels
	    [188]={0.45,0.69}, -- Versorgungslinie der Naga
	    [189]={0.53,0.63}, -- Stahlbrücke
      	[190]={0.66,0.52}, -- Turm der Wut
        [191]={}, -- Blutbadtal
        [192]={}, -- Gesteros Schrein
        [193]={}, -- Hort des Dämonendrachens
        [194]={0.58,0.45}, -- Siedeblut-Außenposten
        [195]={}, -- Hüter-Friedhof
        [196]={0.33,0.30}, -- Naga-Akropolis
        [197]={}, -- Zerbrochene Grenze
        [198]={}, -- Aotulia-Vulkan
        },
    porter = {
        [1]={0.831,0.805},  -- Walkway to Savage lands
        [2]={0.616,0.702,542997},  -- Porter
        [3]={0.734,0.523},  -- Porter Thunderhuf -- TODO: see below
        [4]={0.350,0.660},  -- Dgn Hort des Dämonendrachen -- TODO: position
        [5]={0.340,0.290},  -- Dgn Zurhidonfeste -- TODO: position
        [6]={0.340,0.180},  -- Dgn Halle des Dämonenfürsten -- TODO: position
        },
    link={
        {1, 8,3},
        {2, 8,4, 1,1500},
        --{3,15,3}, -- TODO: remove 'cause it quest porter only
        {4,119,1},
        {5,120,1},
        {6,122,1},
        },
  },

[10] ={ -- Sascillia
    parent = 9998,
    childs = {
        [251] = {left = 0.21, top = 0.53, right = 0.31, bottom = 0.63},
        [106] = {left = 0.10, top = 0.24, right = 0.20, bottom = 0.34},
        [10001] = {left = 0.75, top = 0.15, right = 0.95, bottom = 0.40},
        },
    zones =  {
        [58]={0.58,0.34}, -- Reifort-Lager
        [59]={0.55,0.08}, -- Fugor-Sumpf
        [60]={0.34,0.22}, -- Gurla-Karawane
        [61]={0.27,0.35}, -- Ayren-Karawane
        [62]={0.18,0.26}, -- Khant
        [63]={}, -- Ruinen von Sathkur
        [64]={}, -- Vorhut des Ordens der dunklen Glorie
        [65]={0.65,0.60}, -- Ashlar-Lager
        [66]={0.51,0.80}, -- Dogamor
        [67]={0.64,0.79}, -- Mispelsumpf
        [68]={0.50,0.50}, -- Sascilia-Steppe
        [101]={0.43,0.19},-- Mentha-Karawane
        },
    porter = {
        {0.590,0.980},  -- [1] = Walkway to Dragonfang
        {0.647,0.278},  -- [2] = Walkway to Dust Devil
        {0.254,0.351,541318}, -- [3] = Porter
        {0.140,0.300},  -- [4] = Dgn: Pasper's Shrine
        {0.275,0.590},  -- [5] = Dgn: Arcane Chamber of Sathkur
        {0.573,0.367},  -- [6] = Porter (Reifort)
        },
   link={
        {1, 11,2},
        {2, 6,1},
        {3, 11,3, 1,250},
        {3, 10001,3, 1,10},
        {4, 106,1},
        {5, 251,1},
        {6, 10,3,1,10},
        {6, 10001,3,1,10},
        {6, 2,6,1,50},
        },
  },

[11] ={ -- Dragonfang - Drachenzahngebirge
    parent = 9998,
    childs = {
        [252] = {left = 0.06, top = 0.11, right = 0.16, bottom = 0.21},
        [113] = {left = 0.85, top = 0.80, right = 0.88, bottom = 0.84},
        [114] = {left = 0.85, top = 0.80, right = 0.88, bottom = 0.84},
        },
    zones =  {
        [69]={0.50,0.50}, -- Drachenzahngebierge
        [70]={}, -- Sergarth-Außenposten
        [71]={0.43,0.82}, -- Marl-Außenposten
        [72]={0.90,0.25}, -- Kadmos-Handelsposten
        [73]={0.45,0.55}, -- Lyk
        [74]={}, -- Schneeberg-Holzeinschlag
        [75]={0.23,0.38}, -- Feste der Zyklopen
        [76]={0.44,0.65}, -- Drachenzahnsee
        [77]={}, -- Ruinen des großen Tors
        [78]={}, -- Ruinen von Mithur
        [79]={0.30,0.65}, -- Runenthron
        [80]={0.52,0.74}, -- Drachenzahlhuegel
        [81]={0.57,0.49}, -- Drachenzahn-Eiswüste
        [82]={0.82,0.72}, -- Tal der Eiszwerge
        [83]={}, -- Drachenzahntal
        [84]={0.84,0.42}, -- Awerka-Tundra
        [85]={}, -- Fiergen-Tundra
        [86]={}, -- Lomgart
        [87]={}, -- Eiszwerg-Außenposten
        [88]={}, -- Runenkreis
        [89]={}, -- Tempel der Geheimnisse
        [90]={0.71,0.49}, -- Garnison der Eiszwerge
        [91]={0.64,0.43}, -- Moulton-Hof
        [92]={}, -- Dorf Xoci
        [93]={}, -- Lomgartpass
        [94]={}, -- Höhle der Zyklopen
        },
    porter = {
        {0.950,0.120},  -- [1] = Walkway to Ystra
        {0.487,0.240},  -- [2] = Walkway to Sascillia
        {0.473,0.608,541319}, -- [3] = Porter
        {0.865,0.815},  -- [4] = Dgn: Ruins of the Ice Dwarf Kingdom
        {0.115,0.170},  -- [5] = Dgn: Cyclops Lair
        },
    link={
        { 1, 5,2},
        { 2, 10,1},
        { 3,  5,4, 1,500},
        { 3, 10,3, 1,250},
        { 4, 113,1},
        { 4, 114,1},
        { 5, 252,1},
        },

  },

[12] ={ -- Elven Citadel - Elfeninsel
    parent = 9998,
    childs = {},
    zones =  {
        [156]={0.40,0.50}, -- Elfeninsel
        [157]={0.56,0.56}, -- Tal der Vorbereitung
        [158]={0.30,0.27}, -- Sabineanerbau
        [159]={0.34,0.75}, -- Sporenhain
        [160]={0.25,0.60}, -- Hafen des Aufbruchs
        },
    porter = {
        {0.270,0.600},  -- [1] = Walkway to Varanas
        {0.297,0.594,542557},  -- [2] = Porter
        },
    link={
        {1, 10000,2},
        {2, 2,6,1,10},
        },
  },

[13] ={ -- Küste der Gelegenheit
    parent = 9997,
    childs = {},
    zones =  {
        [225]={0.30,0.79}, -- Küste der Gelegenheit
        },
    porter = {
        {0.379,0.628,544980}, -- [1] Porter
        {0.537,0.032}, -- [2] Walkway Xaviera
        {0.591,0.504,544981}, -- [3] Porter Lyonsyde
        {0.343,0.402,544982}, -- [4] Porter Desert
        {0.589,0.231,545042}, -- [5] Porter Fangers
        },
    link={
        {1, 2,6, 1, 20},
        {1, 13,3,1, 50},
        {2, 14,1},
        {3, 13,1,1, 50},
        {3, 13,4,1, 800},
        {4, 13,3,1, 200},
        {4, 13,5,1, 1600},
        {5, 13,4,1, 800},
        {5, 14,2,1, 2000},
        },
  },

[14] ={ -- Xaviera
    parent = 9997,
    childs = {},
    zones =  {
        [226]={0.5,0.5}, -- Xaviera
        },
    porter = {
        {0.237,0.303}, -- [1] Walkway Coast
        {0.341,0.102,544983,"[SC_TRANSTO][ZONE_RUINS_TESTING_CAMP]"}, -- [2] Porter ruins
        {0.819,0.716,545043,"[SC_TRANSTO][ZONE_JINNERS_CAMP]"}, -- [3] Porter Jinners
        {0.574,0.483,545044,"[SC_TRANSTO][ZONE_FRONT_LINES_CAMP]"}, -- [4] Porter Front
        },
    link={
        {1, 13,2},
        {2, 13,5,1, 1600},
        {2,  2,6,1, 20},
        {2, 14,3,1, 2000},
        {3, 14,2,1, 2000},
        {3, 14,4,1, 2000}, -- TODO: price check
        {4, 14,3,1, 2000},
        },
  },

[15] ={ -- Thunderhoof
    parent = 9997,
    childs = {
        [142] = {left = 0.41, top = 0.12, right = 0.50, bottom = 0.20},
        [209] = {left = 0.56, top = 0.46, right = 0.59, bottom = 0.52},
    },
    zones =  {
       	[201]={0.50,0.50}, -- Die Ehre zurückbringen
	    [202]={0.55,0.55}, -- Gesandter der Drachen
       	[203]={0.50,0.50}, -- Donnerhufhügel
        },
    porter = {
        {0.384,0.055}, -- [1] = Walkway to South Janost forest
        {0.562,0.383}, -- [2] = Porter Thunderhuf
        {0.694,0.815}, -- [3] = Porter Aotulia
        {0.534,0.469,543704,"SC_114777_1"}, -- [4] = Obsidian
        {0.570,0.470}, -- [5] = Kanalisation -- TODO: position
        {0.384,0.365}, -- [6] = Victoria chamber
        {0.279,0.356}, -- [7] =
        {0.386,0.739}, -- [8] =
        {0.581,0.170}, -- [9] = Dgn: Grab der Sieben
        },
    link={
        {1, 16,1},
        {2, 10001,9},
        {2, 16,3,1,1500},
        {3,  9,3},
        {3, 15,4},
        {4, 15,3},
        {5,209,1},
        {7, 15,8},{8, 15,7},
        {8, 142,1},
        },
  },

[16] ={ -- South Janost forest
    parent = 9997,
    childs = {
        [129] = {left = 0.55, top = 0.75, right = 0.63, bottom = 0.83},
        [210] = {left = 0.80, top = 0.76, right = 0.87, bottom = 0.85},
    },
    zones =  {
        [204]={0.81,0.43}, -- Südlicher Janostwald
        [205]={0.26,0.63}, -- Shador
        [206]={0.39,0.69}, -- Nebelhain
        [207]={0.37,0.46}, -- Kandor
        [209]={0.59,0.73}, -- Arena von Warnorken
        [210]={0.81,0.50}, -- Ruinen von Bymorsh
        },
    porter = {
        {0.182,0.881}, -- [1] = Walkway to Thunderhooft
        {0.752,0.222}, -- [2] = Walkway to North Janost
        {0.346,0.541,543705}, -- [3] = Porter
        {0.742,0.428,543705}, -- [4] = Porter
        {0.817,0.781}, -- [5] = Dgn: Magnork - Entrance
        {0.771,0.589}, -- [6] = Dgn: Magnork - Out
        {0.586,0.770}, -- [7] = Dgn: Arena von Warnorken
    },
    link={
        {1, 15,1},
        {2, 17,1},
        {3, 15,2,1,1500},
        {3, 17,3,1,1500},
        {3, 16,4},
        {5,210,1},
        {7,129,1},
    },
  },
[17] ={ -- Northern Janost Forest
    parent = 9997,
    childs = {
        [130] = {left = 0.08, top = 0.38, right = 0.16, bottom = 0.49},
    },
    zones =  {
        [211]={0.48,0.38}, -- Nördlicher Janostwald
        [212]={0.45,0.40}, -- Nördlicher Janostwald
        [213]={0.67,0.60}, -- Zaramonde
        [214]={0.46,0.54}, -- Dorf der Rh'anka
        [215]={0.25,0.45}, -- Angren
        [216]={}, -- Farmen von Sley
        },
    porter = {
        {0.401,0.959}, -- [1] = Walkway to South Janost
        {0.470,0.001}, -- [2] = Walkway to Limo
        {0.515,0.539,544327}, -- [3] = Porter
        {0.099,0.438}, -- [4] = Dgn Raksha
    },
    link={
        {1, 16,2},
        {2, 18,1},
        {3, 16,3,1,1500},
        {3, 18,3,1,1500},
        {4, 130,1},
    },
  },
[18] ={ -- Wüste Limo
    parent = 9997,
    childs = {
        [134] = {left = 0.25, top = 0.39, right = 0.31, bottom = 0.45},
    },
    zones =  {
        [218]={0.5,0.5}, -- Wüste Limo
        },
    porter = {
        {0.302,0.939}, -- [1] = Walkway to Northern Janost Forest
        {0.205,0.338}, -- [2] = Walkway to Land des Unheils
        {0.301,0.532,544624}, -- [3] = Porter
        {0.295,0.482}, -- [4] = Dgn: Grabmal von Kawak
    },
    link={
        {1, 17,2},
        {2, 19,1},
        {3, 17,3,1,1500},
        {3, 19,3,1,1500},
        {4, 134,1},
    },
  },
[19] ={ -- Land des Unheils
    parent = 9997,
    childs = {
        [137]={left = 0.25, top = 0.68, right = 0.35, bottom = 0.77},
        },
    zones =  {
        [222]={0.5,0.5}, -- Land des Unheils
        },
    porter = {
        {0.865,0.228}, -- [1] = Walkway to Wüste Limo
        {0.190,0.900}, -- [2] = Walkway to Rothügelberge
        {0.630,0.397,544680}, -- [3] = Porter
        {0.312,0.714}, -- [4] = Dgn: Burg Grafu
    },
    link={
        {1, 18,2},
        {2, 20,1},
        {3, 18,3,1,1500},
        {3, 20,3,1,1500},
        {4, 137,1},
    },
  },
[20] ={ -- Rothügelberge
    parent = 9997,
    childs = {
        [ 80] = {left = 0.21, top = 0.13, right = 0.36, bottom = 0.24},
        [139] = {left = 0.24, top = 0.84, right = 0.30, bottom = 0.95},
        [211] = {left = 0.21, top = 0.13, right = 0.36, bottom = 0.24},
    },
    zones =  {
        [220]={0.44,0.40}, -- Magische Rekonstruktion
        [227]={0.5,0.5}, -- Rothügelberge
        },
    porter = {
        {0.610,0.270}, -- [1] = Walkway to Land des Unheils
        {0.200,0.900}, -- [2] = Walkway to Tergothenbay -- TODO Check coords
        {0.296,0.404,545465}, -- [3] = Porter
        {0.259,0.257}, -- [4] = Firefortrest
        {0.195,0.923}, -- [5] = Burg Sardo
    },
    link={
        {1, 19,2},
        {2, 21,1},
        {3, 19,3,1,1500},
        {3, 21,2,1,1500},
        {4, 211,1},
        {5, 139,1},
    },
  },
[21] ={ -- Tergothenbay
    parent = 9997,
    childs = {},
    zones =  {
        [230]={}, -- Tergothenbucht
        },
    porter = {
        {0.800,0.285}, -- [1] = Walkway to FIREBOOT_DWARF_FORTRESS -- TODO Check coords
        {0.640,0.540,545618}, -- [2] = Porter
    },
    link={
        {1, 20,2},
        {2, 20,3,1,1500},
    },
  },
[22] ={ -- Altes Königreich von Rorazan
    parent = 9996,
    childs = {
        [10002] = {left = 0.43, top = 0.16, right = 0.51, bottom = 0.27},
        [10003] = {left = 0.43, top = 0.16, right = 0.51, bottom = 0.27},
        [10004] = {left = 0.43, top = 0.16, right = 0.51, bottom = 0.27},
        [10005] = {left = 0.43, top = 0.16, right = 0.51, bottom = 0.27},
        [10006] = {left = 0.43, top = 0.16, right = 0.51, bottom = 0.27},
    },
    zones =  {
        [233]={0.5,0.5}, -- Altes Königreich von Rorazan
        },
    porter = {
        {0.360,0.582},-- [1] = Porter
        {0.470,0.260},-- [2] = Dgn: Ewiger Kreis -- TODO: coords
        {0.800,0.205},-- [3] = Walk: Chrysalia -- TODO: coords
        },
    link={
        {1,2,6,1,20},
        {1,15,4,1,2000},
        {1,23,4,1,2200},
        {2,10002,1},
        {2,10003,1},
        {2,10004,1},
        {2,10005,1},
        {2,10006,1},
        {3,23,1},
        },
  },
[23] ={ -- Chrysalia
    parent = 9996,
    childs = {
        [147] = {left = 0.55, top = 0.72, right = 0.63, bottom = 0.83},
    },
    zones =  {
        [236]={0.5,0.5}, -- Chrysalia
        },
    porter = {
        {0.070,0.470},-- [1] = Walk: Rorazan -- TODO: coords
        {0.800,0.193},-- [2] = Walk: Miran -- TODO: coords
        {0.590,0.733},-- [3] = Dgn: Knochennest der Kulech -- TODO: coords
        {0.367,0.390},-- [4] = Porter
    },
    link={
        {1,22,3},
        {2,24,1},
        {3,147,1},
        {4,22,1},
    },
  },
[24] ={ -- Meridan Tundra
    parent = 9996,
    childs = {
        [149] = {left = 0.55, top = 0.72, right = 0.63, bottom = 0.83}, -- TODO: coords
    },
    zones =  {
        [241]={},-- Meridan Tundra
        },
    porter = {
        {0.070,0.470},-- [1] = Walk: Chrysalia -- TODO: coords
        {0.166,0.310},-- [2] = Walk: Sarlo -- TODO: coords
        {0.529,0.391},-- [3] = Dgn: Berdin
--        {0.367,0.390},-- [4] = Porter
    },
    link={
        {1,23,2},
        {2,25,1},
        {3,149,1},
    },
  },
[25] ={ -- Syrbalpass
    parent = 9996,
    childs = {
        [151] = {left = 0.60, top = 0.22, right = 0.70, bottom = 0.31}, -- TODO: coords
    },
    zones =  {
        [244]={},-- Syrbalpass
        },
    porter = {
        {0.740,0.530},-- [1] = Walk: Meridan Tundra -- TODO: coords
        {0.090,0.250},-- [2] = Walk: Sarlo -- TODO: coords
        {0.644,0.318},-- [3] = Dgn: Bethomia  -- TODO: coords
    },
    link={
        {1,24,2},
        {2,26,1},
        {3,151,1},
    },
  },
[26] ={ -- Sarlo
    parent = 9996,
    childs = {
        [155] = {left = 0.47, top = 0.85, right = 0.57, bottom = 0.92}, -- TODO: coords
    },
    zones =  {
        [246]={},-- Sarlo
        [247]={0.53,0.90},-- Belathis-Festung
        },
    porter = {
        {0.070,0.470},-- [1] = Walk: Chrysalia -- TODO: coords
        {0.520,0.830},-- [2] = Dgn: Belathis
    },
    link={
        {1,25,2},
        {2,155,1}
    },
  },
[27] ={ -- Wailing Fjord
    parent = 9995,
    childs = {
        [157] = {left = 0.31, top = 0.47, right = 0.37, bottom = 0.55}, -- TODO: coords
        [158] = {left = 0.31, top = 0.47, right = 0.37, bottom = 0.55}, -- TODO: coords
        [159] = {left = 0.31, top = 0.47, right = 0.37, bottom = 0.55}, -- TODO: coords
    },
    zones =  {
        [248]={},-- Wailing Fjord
        [249]={},-- PiratenInsel
        },
    porter = {
        {0.540,0.074},-- [1] = Walk: Hortek -- TODO: coords
        {0.330,0.510},-- [2] = Dgn: Grotte -- TODO: coords
    },
    link={
        {1,28,1},
        {2,158,1},
        {2,157,1},
        {2,159,1},
    },
  },
[28] ={ -- Horttek jungle
    parent = 9995,
    childs = {
        [160] = {left = 0.64, top = 0.40, right = 0.71, bottom = 0.46}, -- TODO: coords
        [161] = {left = 0.64, top = 0.40, right = 0.71, bottom = 0.46}, -- TODO: coords
        [162] = {left = 0.64, top = 0.40, right = 0.71, bottom = 0.46}, -- TODO: coords
    },
    zones =  {
        [250]={},--
        },
    porter = {
        {0.440,0.940},-- [1] = Walk: Wailing Fjord
        {0.920,0.320},-- [2] = Walk:
        {0.690,0.440},-- [3] = Dgn:
    },
    link={
        {1,27,1},
        {2,29,1},
        {3,160,1},
        {3,161,1},
        {3,162,1}
    },
  },
[29] ={ -- XADIA_BASIN - Saliocabecken
    parent = 9995,
    childs = {
      [163]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [164]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [165]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
    },
    zones =  {
        [251]={},
        },
    porter = {
        {0.040,0.630},-- [1] = Walk: Hortek
        {0.580,0.110},-- [2] = Walk:
        {0.350,0.820},-- [3] = Dgn
    },
    link={
        {1,28,2},
        {2,30,1},
        {3,164,1},
    },
  },
[30] ={ -- KATHALAN
    parent = 9995,
    childs = {
      [166]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [167]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [168]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
    },
    zones =  {
        [252]={},
        },
    porter = {
        {0.640,0.920},-- [1] = Walk:
        {0.730,0.170},-- [2] = Dgn
    },
    link={
        {1,29,2},
        {2,167,1},
    },
  },
[31] ={ -- Höhlen von Yrvandis
    parent = 9998,
    childs = {
        [212] = {left = 0.66, top = 0.08, right = 0.75, bottom = 0.15},
    },
    zones =  {
        [234]={0.18,0.58}, -- Höhlen von Yrvandis
     },
    porter = {
        {0.436,0.795}, -- [1] Porter
        {0.708,0.808}, -- [2] Dgn: Südliches Stahlsfels
    },
    link={
        {1,2,6,1,10},
        {2,212,1}
    },
  },
[32] ={ -- Splitterstromküste
    parent = 9994,
    childs = {
      [169]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [170]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [171]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
    },
    zones =  {
        [253]={},
        [254]={},
        },
    porter = {
        {0.640,0.135},-- [1] = Walk:
        {0.670,0.260},-- [2] = Dgn: Knochenspite
    },
    link={
      {1,33,1},
      {2,170,1},
    },
  },
[33] ={ -- Hügelland von Farsitan
    parent = 9994,
    childs = {
      [172]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [173]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [174]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [175]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [176]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [177]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
    },
    zones =  {
        [255]={},
        },
    porter = {
        {0.300,0.860},-- [1] = Walk:
    },
    link={
      {1,32,1},
    },
  },

[34] ={ -- Tasuq
    parent = 9994,
    childs = {
      [178]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [179]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [180]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
    },
    zones =  {
        [256]={},
        },
    porter = {
--        {0.300,0.860},-- [1] = Walk:
    },
    link={
--      {1,32,1},
    },
  },
[35] ={ -- KulusIsland
    parent = 9994,
    childs = {
      [181]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [182]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [183]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
    },
    zones =  {
      [261]={},
        },
    porter = {
--        {0.300,0.860},-- [1] = Walk:
    },
    link={
--      {1,32,1},
    },
  },
[36] ={ -- EnochIsland
    parent = 9994,
    childs = {
      [184]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [185]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [186]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
    },
    zones =  {
      [262]={},
        },
    porter = {
--        {0.300,0.860},-- [1] = Walk:
    },
    link={
--      {1,32,1},
    },
  },
[37] ={ -- Vortis
    parent = 9994,
    childs = {
      [187]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [188]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
      [189]   = {left = 0.0, top = 0.0, right = 0.100, bottom = 0.100},
    },
    zones =  {
      [263]={},
        },
    porter = {
--        {0.300,0.860},-- [1] = Walk:
    },
    link={
--      {1,32,1},
    },
  },
[38] ={ -- Chassizz
    parent = 9994,
    childs = {
    },
    zones =  {
      [264]={},
        },
    porter = {
--        {0.300,0.860},-- [1] = Walk:
    },
    link={
--      {1,32,1},
    },
  },

[80] ={ -- Untergundfestung der Feuerstiefel
    parent = 20, childs = {}, zones = {},
  },
[211]={ -- Untergundfestung der Feuerstiefel
    parent = 20, childs = {}, zones = {},
    porter = {
        {0.279,0.263}, -- [1] = Rothügelberge
    },
    link = {
        {1, 20, 4},
    },
  },
------------------------------------------------------
-- Cities
------------------------------------------------------
[10000] ={ -- Varanas - Varanas
    parent = 2,
    childs = {
        [194] = {left = 0.5, top = 0.5, right = 0.5, bottom = 0.5}, -- TODO: coords
        [208] = {left = 0.220, top = 0.270, right = 0.270, bottom = 0.320},
        [350] = {left = 0.210, top = 0.250, right = 0.280, bottom = 0.300},
        [401] = {left = 0.100, top = 0.100, right = 0.101, bottom = 0.101},
        [402] = {left = 0.100, top = 0.100, right = 0.101, bottom = 0.101},
        },
    zones =  {
        [133]={0.5,0.5}, -- Episch
        [161]={0.5,0.5}, -- Episch
        [235]={0.41,0.38}, -- Wunschbrunnen
        [243]={0.5,0.5}, -- Fest-Event
        },
    porter = {
        {0.312,0.187}, -- [1] = Walkway to Silverspring
        {0.450,0.710}, -- [2] = Walkway to Elvencitadel
        {0.288,0.376}, -- [3] = Dgn: Varanas -  Nightmare
        {0.264,0.421}, -- [4] = Dgn: Guild
        {0.306,0.356,0,"SO_110561_9"},  -- [5] = Tele: West
        {0.456,0.257,0,"SO_110561_8"},  -- [6] = Tele: Ost
        {0.481,0.502,0,"SO_110561_7"},  -- [7] = Tele: Stadtplatz
        {0.531,0.748,0,"SO_110561_13"}, -- [8] = Tele: Klasse
        {0.689,0.569,0,"SC_111339_12"}, -- [9] = Tele: Auge der Weisheit
        {0.636,0.647,0,"SO_110561_6"},  -- [10]= Tele: Gilde
        {0.410,0.370},  -- [11]= Dgn: Chaoswirbel TODO: coords
        },
    link={
        { 1, 2,4},
        { 2, 12,1},
        { 3, 208,1},
        { 4, 401,1},{ 4, 402,1},
        { 5, 2,10 ,2}, { 5, 10000,6 ,2}, { 5, 10000,7 ,2}, { 5, 10000,8 ,2}, { 5, 10000,9 ,2}, { 5, 10000,10 ,2},
        { 6, 2,10 ,2}, { 6, 10000,5 ,2}, { 6, 10000,7 ,2}, { 6, 10000,8 ,2}, { 6, 10000,9 ,2}, { 6, 10000,10 ,2},
        { 7, 2,10 ,2}, { 7, 10000,5 ,2}, { 7, 10000,6 ,2}, { 7, 10000,8 ,2}, { 7, 10000,9 ,2}, { 7, 10000,10 ,2},
        { 8, 2,10 ,2}, { 8, 10000,5 ,2}, { 8, 10000,6 ,2}, { 8, 10000,7 ,2}, { 8, 10000,9 ,2}, { 8, 10000,10 ,2},
        { 9, 2,10 ,2}, { 9, 10000,5 ,2}, { 9, 10000,6 ,2}, { 9, 10000,7 ,2}, { 9, 10000,8 ,2}, { 9, 10000,10 ,2},
        {10, 2,10 ,2}, {10, 10000,5 ,2}, {10, 10000,6 ,2}, {10, 10000,7 ,2}, {10, 10000,8 ,2}, {10, 10000,9  ,2},
        {11, 194,1}
        },
  },


[10001] ={ -- Obsidian Stronghold - Obsidianfeste
    parent = 6,
    childs = {},
    zones =  {},
    porter = {
        {0.506,0.931}, -- [1] = Walkway to Dust Devil Canyon (south)
        {0.814,0.224}, -- [2] = Walkway to Dust Devil Canyon (north)
        {0.752,0.189,541317}, -- [3] = Porter
        {0.560,0.667,0,"SO_110944_8"}, -- [4] = Tele: Söldner
        {0.461,0.825,0,"SO_110944_2"}, -- [5] = Tele: Handels
        {0.361,0.308,0,"SO_110944_7"}, -- [6] = Tele: Handwerk
        {0.412,0.528,0,"SO_110944_3"}, -- [7] = Tele: Glorien
        {0.712,0.242,0,"SO_110944_6"}, -- [8] = Tele: Schlacht
        {0.736,0.577,0,"SC_114776_0"}, -- [9] = Porter: Thunderhuf
        },
    link={
        {1, 6,2},
        {2, 6,4},
        {3, 2,6,  1,50},
        {3, 5,4,  1,750},
        {3, 10,3, 1,10},
        {4, 10001,5 ,2}, {4, 10001,6 ,2}, {4, 10001,7 ,2}, {4, 10001,8 ,2},
        {5, 10001,4 ,2}, {5, 10001,6 ,2}, {5, 10001,7 ,2}, {5, 10001,8 ,2},
        {6, 10001,4 ,2}, {6, 10001,5 ,2}, {6, 10001,7 ,2}, {6, 10001,8 ,2},
        {7, 10001,4 ,2}, {7, 10001,5 ,2}, {7, 10001,6 ,2}, {7, 10001,8 ,2},
        {8, 10001,4 ,2}, {8, 10001,5 ,2}, {8, 10001,6 ,2}, {8, 10001,7 ,2},
        {9, 15, 2},
        },
  },


------------------------------------------------------
-- Dungeons
------------------------------------------------------
[100] ={ -- Tutorial - Einfuehrungsgebiet
    parent = 1, childs = {}, zones = {[105]={}},
  },

[101] ={ -- Cavern of Trials - Hoehle der Pruefungen
    parent = 1, childs = {}, zones = {[106]={}},
    porter = { {0.15,0.44}}, link = {{1, 1,3}} -- TODO: position
  },

[102] ={ -- Forsaken Abbey - Verlassene Abtei
    parent = 2, childs = {}, zones = {[14]={0.5,0.5}},
    porter = { {0.09,0.54}}, link = {{1, 2,7}} -- TODO: position
  },

[103] ={ -- Necropolis of Mirrors - Graeberstadt der Spiegel
    parent = 4, childs = {}, zones =  {[27]={0.5,0.5}},
    porter = { {0.197,0.892}}, link = {{1, 4,4}} -- TODO: position
  },

[104] ={ -- Mystic Altar - Mystischer Altar
    parent = 5, childs = {}, zones =  {[35]={}},
    porter = { {0.5,0.5}}, link = {{1, 5,5}} -- TODO: position
  },

[105] ={ -- Queen's Chamber - Koeniginnenkammer
    parent = 6, childs = {}, zones = {},
    porter = { {0.5,0.5}}, link = {{1, 6,5}} -- TODO: position
  },

[106] ={ -- Pasper's Shrine - Schrein von Pasper
    parent = 10, childs = {}, zones =  {[99]={}},
    porter = { {0.448,0.963}}, link = {{1, 10,4}}-- TODO: position
  },

[107] ={ -- Shrine of Kalin - Schrein von Kalin
    parent = 6, childs = {}, zones =  {[49]={0.5,0.5}},
    porter = { {0.686,0.922}}, link = {{1, 6,6}}
  },

[108] ={ -- Treasure Trove - Schatzhoehle
    parent = 3, childs = {}, zones =  {[95]={0.5,0.5}},
    porter = { {0.40,0.89}}, link = {{1, 3,4}} -- TODO: position
  },

[110] ={ -- Barren Caves - Karge Höhlen
    parent = 1, childs = {}, zones =  {},
    porter = { {0.32,0.51}}, link = {{1, 1,4}} -- TODO: position
  },

[113] ={ -- Ruins of the Ice Dwarf Kingdom - Ruinen des Eiszwergkoenigreiches
    parent = 11, childs = {}, zones =  {[134]={}},
    porter = { {0.48,0.72}}, link = {{1, 11,4}} -- TODO: position
  },

[114] ={ -- Ruins of the Ice Dwarf Kingdom - Ruinen des Eiszwergkoenigreiches
    parent = 11, childs = {}, zones =  {},
    porter = { {0.48,0.72}}, link = {{1, 11,4}} -- TODO: position
  },

[115] ={ -- Ocean's Heart - Herz des Ozeans
    parent = 7, childs = {},    zones =  {[155]={0.5,0.5}},
    porter = { {0.17,0.34}}, link = {{1, 7,4}} -- TODO: position
  },

[116] ={ -- Origin - Ursprung
    parent = 4,  childs = {}, zones =  {[181]={0.5,0.5}},
    porter = { {0.189,0.926}}, link = {{1, 4,5}}
  },

[117] ={ -- Hall of Survivors - Halle der Überlebenden
    parent = 2, childs = {}, zones = {[179]={0.5,0.5}},
    porter = { {0.308,0.777}}, link = {{1, 2,9}}
  },

[118] ={ -- Moonspring Hollow - Höhle des Wasserdrachen
    parent = 1, childs = {}, zones =  {},
    porter = { {0.378,0.914}}, link = {{1, 1,7}}
  },
[119] ={ -- Hort des Dämonendrachens
    parent = 9, childs = {}, zones = {},
    porter = { {0.50,0.87}}, link = {{1, 9,4}} -- TODO: position
  },
[120] ={ -- Zurhidonfeste
    parent = 9, childs = {}, zones = {},
    porter = { {0.50,0.50}}, link = {{1, 9,5}} -- TODO: position
  },
[122] ={ -- Halle des Dämonenfürsten
    parent = 9, childs = {}, zones = {},
    porter = { {0.50,0.50}}, link = {{1, 9,6}} -- TODO: position
  },
[127] ={ -- Kerker von Dalanis
    parent = 209, childs = {},
    zones = {
        [208]={0.5,0.5}, -- Kerker von Dalanis
    },
    porter = { {0.07,0.23}}, link = {{1, 209,2}} -- TODO: position
  },
[129] ={ -- Arena von Warnorken
    parent = 16, childs = {},zones = {},
    porter = { {0.346,0.486}}, link = {{1, 16,7}} -- TODO: position
  },
[130] ={ -- Temple von Raksha
    parent = 17, childs = {},
    zones = {
        [217]={0.5,0.5}, -- Tempel der Raksha
        },
    porter = { {0.595,0.531}}, link = {{1, 17,4}} -- TODO: position
  },
[134] ={ -- Grabmal von Kawak
    parent = 18, childs = {}, zones = {
        [219]={0.5,0.5},
    },
    porter = { {0.340,0.892}}, link = {{1, 18,4}}
  },
[137] ={ -- Burg Grafu
    parent = 19, childs = {}, zones =  {[223]={0.5,0.5},},
    porter = { {0.504,0.795}}, link = {{1, 19,4}}
  },
[139] ={ -- Burg Sardo
    parent = 20, childs = {}, zones =  { [228]={0.5,0.5}},
    porter = { {0.574,0.884}}, link = {{1, 20,5}}
  },
[142] ={ -- Grab der Sieben
    parent = 15, childs = {}, zones = {[231]={0.5,0.5},},
    porter = { {0.171,0.826}}, link = {{1, 15,8}} -- TODO: coords
  },

[147] ={ -- Knochennest der Kulech
    parent = 23, childs = {},
    zones =  { [237]={} },
    porter = { {0.300,0.730}}, link = {{1, 23,3}}
  },
[149] ={ -- Bedim
    parent = 24, childs = {}, zones =  { [242]={}},
    porter = { {0.500,0.500}}, link = {{1, 24,3}} -- TODO: coords
  },
[151] ={ -- Bethomia
    parent = 25, childs = {}, zones =  { [245]={}},
    porter = { {0.600,0.860}}, link = {{1, 25,3}} -- TODO: coords
  },
[155] ={ --
    parent = 26, childs = {}, zones =  {},
    porter = { {0.310,0.900}}, link = {{1, 26,2}} -- TODO: coords
  },
[157] ={ --
    parent = 27, childs = {}, zones =  {},
    porter = { {0.630,0.900}}, link = {{1, 27,2}} -- TODO: coords
  },
[158] ={ --
    parent = 27, childs = {}, zones =  {},
    porter = { {0.630,0.900}}, link = {{1, 27,2}} -- TODO: coords
  },
[159] ={ --
    parent = 27, childs = {}, zones =  {},
    porter = { {0.630,0.900}}, link = {{1, 27,2}} -- TODO: coords
  },

[160] ={ --
    parent = 28, childs = {}, zones =  {},
    porter = { {0.500,0.8300}}, link = {{1, 28,3}} -- TODO: coords
  },
[161] ={ --
    parent = 28, childs = {}, zones =  {},
    porter = { {0.500,0.8300}}, link = {{1, 28,3}} -- TODO: coords
  },
[162] ={ --
    parent = 28, childs = {}, zones =  {},
    porter = { {0.500,0.830}}, link = {{1, 28,3}} -- TODO: coords
  },
[164] ={ -- Krypta der Ewigkeit
    parent = 29, childs = {}, zones =  { [258]={}},
    porter = { {0.500,0.830}}, link = {{1, 29,3}} -- TODO: coords
  },
[163] ={ -- Krypta der Ewigkeit
  parent = 29, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 29,3}} -- TODO: coords
},
[165] ={ -- Krypta der Ewigkeit
    parent = 29, childs = {}, zones =  {},
    porter = { {0.500,0.830}}, link = {{1, 29,3}} -- TODO: coords
  },

[167] ={ -- Gewölbe Kashaylan
    parent = 30, childs = {}, zones =  { [259]={}},
    porter = { {0.500,0.830}}, link = {{1, 30,2}} -- TODO: coords
  },
[166] ={ -- Gewölbe Kashaylan
  parent = 30, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 30,2}} -- TODO: coords
},
[168] ={ -- Gewölbe Kashaylan
    parent = 30, childs = {}, zones =  {},
    porter = { {0.500,0.830}}, link = {{1, 30,2}} -- TODO: coords
  },
[170] ={ -- Knochenspitze
    parent = 32, childs = {}, zones =  { [260]={}},
    porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
  },
[169] ={ -- Knochenspitze
  parent = 32, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},
[171] ={ -- Knochenspitze
    parent = 32, childs = {}, zones =  {},
    porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
  },

[173] ={ -- Hort der Madro-Trolle
  parent = 33, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},
[172] ={ -- Hort der Madro-Trolle
  parent = 33, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},
[174] ={ -- Hort der Madro-Trolle
  parent = 33, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},

[176] ={ -- Rabenherz
  parent = 33, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},
[175] ={ -- Rabenherz
  parent = 33, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},
[177] ={ -- Rabenherz
  parent = 33, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},

[179] ={ -- Tal der Riten
  parent = 34, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},
[178] ={ -- Tal der Riten
  parent = 34, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},
[180] ={ -- Tal der Riten
  parent = 34, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},

[182] ={ -- Eisklingen Plateau
  parent = 35, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},
[181] ={ -- Eisklingen Plateau
  parent = 35, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},
[183] ={ -- Eisklingen Plateau
  parent = 35, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},

[185] ={ -- Sonnentemple
  parent = 36, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},
[184] ={ -- Sonnentemple
  parent = 36, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},
[186] ={ -- Sonnentemple
  parent = 36, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},

[188] ={ -- dead souls
  parent = 37, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},
[187] ={ -- dead souls
  parent = 37, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},
[189] ={ -- dead souls
  parent = 37, childs = {}, zones =  {},
  porter = { {0.500,0.830}}, link = {{1, 32,2}} -- TODO: coords
},

[190] ={ -- Graben von Bolinthya
    parent = 2, childs = {}, zones = {[224]={0.5,0.5}},
    porter = { {0.5,0.5}}, link = {{1, 2,11}} -- TODO: coords
  },
[194] ={ -- Chaoswirbel
    parent = 10000, childs = {}, zones = {},
    porter = { {0.5,0.5}}, link = {{1,10000,8}} -- TODO: coords
  },

[10002] ={ -- - Ewiger Kreis
    parent = 22, childs = {}, zones = {},
    porter = { {0.5,0.5}}, link = {{1, 22,2}} -- TODO: coords
  },
[10003] ={ -- - Ewiger Kreis
    parent = 22, childs = {}, zones = {},
    porter = { {0.5,0.5}}, link = {{1, 22,2}} -- TODO: coords
  },
[10004] ={ -- - Ewiger Kreis
    parent = 22, childs = {}, zones = {},
    porter = { {0.5,0.5}}, link = {{1, 22,2}} -- TODO: coords
  },
[10005] ={ -- - Ewiger Kreis
    parent = 22, childs = {}, zones = {},
    porter = { {0.5,0.5}}, link = {{1, 22,2}} -- TODO: coords
  },
[10006] ={ -- - Ewiger Kreis
    parent = 22, childs = {}, zones = {},
    porter = { {0.5,0.5}}, link = {{1, 22,2}} -- TODO: coords
  },
------------------------------------------------------
-- TileDungeons
-- TODO: all ystra labs porters
------------------------------------------------------
[201] ={ -- Bloody Gallery - Blutige Galerie
    parent = 2, childs = {}, zones = {[120]={0.5,0.5}},
    porter = { {0.5,0.5}}, link = {{1, 2,8}} -- TODO: position
  },

[205] ={ -- Revivers' Corridor - Auferstehungskorridor
    parent = 5, childs = {},
    zones =  {
        [103]={0.129,0.759},
        [109]={},},
    porter = {
        {0.129,0.759,0,"ZONE_TILEDGN_HYBORA_LABYRINTH_01"}, -- [1] = Entrance
        {0.830,0.127}, -- [2] = Walkway (guards)
        {0.123,0.727,0,"SC_205_GOTO_PP0"}, -- [3] = Tele: entrance
        {0.367,0.687,0,"SC_205_GOTO_PP1"}, -- [4] = Tele: first
        {0.799,0.785,0,"SC_205_GOTO_PP2"}, -- [5] = Tele: mid
        {0.905,0.408,0,"SC_205_GOTO_PP3"}, -- [6] = Tele: last
        },
    link = {
        {1, 5,6},
        {2, 206,1},
        {3, 5,6},
        {3, 206,1},
        {3, 207,1},
        {3, 205,4},{3, 205,5},{3, 205,6},
        {4, 205,3},{4, 205,5},{4, 205,6},
        {5, 205,3},{5, 205,4},{5, 205,6},
        {6, 205,3},{6, 205,4},{6, 205,5},
        }
  },

[206] ={ -- Guards' Corridor - Korridor der Waechter
    parent = 5, childs = {},
    zones =  {
        [110] = {},
        },
    porter = {
        {0.541,0.678,0,"ZONE_TILEDGN_HYBORA_LABYRINTH_02"}, -- [1] = Entrance
        {0.906,0.488}, -- [2] = Walkway (royal)
        {0.534,0.649,0,"SC_206_GOTO_PP0"}, -- [3] = Tele: entrance
        {0.175,0.759,0,"SC_206_GOTO_PP1"}, -- [4] = Tele: first
        {0.287,0.379,0,"SC_206_GOTO_PP2"}, -- [5] = Tele: mid1
        {0.530,0.383,0,"SC_206_GOTO_PP3"}, -- [6] = Tele: mid2
        {0.863,0.666,0,"SC_206_GOTO_PP4"}, -- [7] = Tele: last
        },
    link = {
        {1, 205,2},
        {2, 207,1},
        {3, 5,6},
        {3, 205,1},
        {3, 207,1},
        {3, 206,4},{3, 206,5},{3, 206,6},{3, 206,7},
        {4, 206,3},{4, 206,5},{4, 206,6},{4, 206,7},
        {5, 206,3},{5, 206,4},{5, 206,6},{5, 206,7},
        {6, 206,3},{6, 206,4},{6, 206,5},{6, 206,7},
        {7, 206,3},{7, 206,4},{7, 206,5},{7, 206,6},
        }
  },

[207] ={ -- Royals' Refuge - Korridor der Zuflucht
    parent = 5, childs = {},
    zones =  {
        [111]={}
        },
    porter = {
        {0.694,0.848,0,"ZONE_TILEDGN_HYBORA_LABYRINTH_03"}, -- [1] = Entrance & Walkway (guards)
        {0.688,0.820,0,"SC_207_GOTO_PP0"}, -- [2] = Tele: entrance
        {0.267,0.621,0,"SC_207_GOTO_PP1"}, -- [3] = Tele: first
        {0.340,0.290,0,"SC_207_GOTO_PP2"}, -- [4] = Tele: mid
        {0.694,0.848,0,"SC_207_GOTO_PP3"}, -- [5] = Tele: last
        },
    link = {
        {1, 206,2},
        {2, 5,6},
        {2, 205,1},
        {2, 206,1},
        {2, 207,3 ,2}, {2, 207,4 ,2}, {2, 207,5 ,2},
        {3, 207,2 ,2}, {3, 207,4 ,2}, {3, 207,5 ,2},
        {4, 207,2 ,2}, {4, 207,3 ,2}, {4, 207,5 ,2},
        {5, 207,2 ,2}, {5, 207,3 ,2}, {5, 207,4 ,2},
        }
  },

[208] ={ -- Varanas Nightmare - Albtraum von Varanas
    parent = 10000, childs = {}, zones =  {},
    porter = { {0.530,0.810}}, link = {{1, 10000,3}}
  },

[209] ={ -- Kanalisation von Dalanis
    parent = 15,
    childs = {
        [127] = {left = 0.50, top = 0.89, right = 0.57, bottom = 0.98},
    },
    zones = {},
    porter = {
        {0.320,0.120}, -- [1] = Thunderhoof
        {0.531,0.930}, -- [2] = Kerker von Dalanis
        {0.319,0.204}, -- [3] = start porter
        {0.524,0.900}, -- [4] = end porter
        },
   link={
        {1, 15, 5},
        {2, 127,1},
        {3, 209,4},
        {4, 209,3},
        },
  },
[210] ={ -- - Ruinen des Königreichs von Magnork
    parent = 16, childs = {}, zones = {[221]={0.5,0.5}},
    porter = { {0.663,0.508}}, link = {{1,16,6}}
  },
[212] ={ -- Südliches Stahlfels
    parent = 31, childs= {}, zones={},
    porter = { {0.608,0.858}}, link= {{1,31,2}}
  },
[250] ={ -- Windmill Basement - Windmuehlenkeller
    parent = 1, childs = {}, zones =  {[112]={}},
    porter = { {0.5,0.5}}, link = {{1, 1,5}} -- TODO: position
  },

[251] ={ -- Arcane Chamber of Sathkur - Arkane Kammer des Sathkur
    parent = 10, childs = {}, zones =  {[98]={}},
    porter = { {0.5,0.5}}, link = {{1, 10,5}} -- TODO: position
  },

[252] ={ -- Cyclops Lair - Hoehle der Zyklopen
    parent = 11, childs = {}, zones =  {},
    porter = { {0.5,0.5}}, link = {{1, 11,5}} -- TODO: position
  },

------------------------------------------------------
-- EventDungeon
------------------------------------------------------
[301] ={ -- Fungus Habitat - Pilzgarten
    parent = 1, childs = {}, zones =   {[114]={}},
    porter = { {0.290,0.750}}, link = {{1, 1,6}}
  },

[302] ={ -- Wind Wild Animus - Seele der Sturmhoehe
    parent = 6, childs = {}, zones =  {[115]={}},
    porter = { {0.5,0.5}}, link = {{1, 6,7}} -- TODO: position
  },

[303] ={ -- Wedding Hall - Hochzeitshalle  (not there yet)
    parent = nil, childs = {}, zones =  {[116]={}},
  },

[350] ={ -- Windrunner Race - Windläufer-Rennen
    parent = 10000, childs = {}, zones =  {},
  },

[351] ={ -- Maladina (no functional map in this zone)
    parent = nil, childs = {}, zones =  {},
  },
[352] ={ -- Goblin Mines - Goblin-Mine
    parent = nil, childs = {}, zones =  {},
  },

[353] ={ -- Maladina 2 (no functional map in this zone)
    parent = nil, childs = {}, zones =  {},
  },

[400] ={ -- House
    parent = nil, childs = {}, zones =  {[117]={}},
  },

[401] ={ -- Guild Castle - Gildenburg
    parent = 10000, childs = {}, zones =  {[118]={0.5,0.5}},
    porter = { {0.5,0.5}}, link = {{1, 10000,4}} -- TODO: position
  },

[402] ={ -- Guild Castle - Gildenburg
    parent = 10000, childs = {}, zones =  {},
    porter = { {0.5,0.5}}, link = {{1, 10000,4}} -- TODO: position
  },

------------------------------------------------------
-- BATTLEGROUNDS
------------------------------------------------------
[440] ={ parent = nil, childs = {}, zones = {}},
[441] ={ parent = nil, childs = {}, zones = {}},
[442] ={ parent = nil, childs = {}, zones = {}},
[443] ={ parent = nil, childs = {}, zones = {}},
[444] ={ parent = nil, childs = {}, zones = {}},
[445] ={ parent = nil, childs = {}, zones = {}},
[446] ={ parent = nil, childs = {}, zones = {}},
[447] ={ parent = nil, childs = {}, zones = {}},
[448] ={ parent = nil, childs = {}, zones = {}},
}

