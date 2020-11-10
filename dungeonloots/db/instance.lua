--[[
	[zid] = { -- name
		zone=*open world zone*,
		lvl=*itemlevel*,
		raid=*instanceplayernum*,
		boss={
			[*num*] = {
				id=*id*,--*name*
				pos = {x=*x*, y=*y*,*map*},
				loot=*value*,
				box=*value*,
				visible=*value*,
				nocount=*value*,
				id2={
					[*num*] = {
						id=*id*,--*name*
						pos = {x=*x*, y=*y*,*map*},
						loot=*value*,
						box=*value*,
						visible=*value*,
					},
					},
				},
			},
		}
	}
]]
return {
	[2] = { -- Silverspring
		boss = {
			[1] = {
				id=100075,--giant guardian
				pos = {x=0.414, y=0.198,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
			[2] = {
				id=100692,--scooray
				pos = {x=0.633, y=0.334,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},
	[4] = { -- Aslan
		boss = {
			[1] = {
				id=100629,-- Perodia
				pos = {x=0.466, y=0.690,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},
	[5] = { -- Ystra
		boss = {
			[1] = {
				id=100625,--Locface
				pos = {x=0.242, y=0.144,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
			[2] = {
				id=101342,--Aisha
				pos = {x=0.234, y=0.489,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
			[3] = {
				id=101023,--Worr Binpike
				pos = {x=0.515, y=0.802,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
			[4] = {
				id=101222,--Lynn Binpike
				pos = {x=0.543, y=0.818,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
			[5] = {
				id=101344,--Anselve
				pos = {x=0.462, y=0.458,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
			[6] = {
				id=100200,--Akeli
				pos = {x=0.737, y=0.387,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},
	[6] = { -- dustdevil canyon
		boss = {
			[1] = {
				id=100627,--turssi
				pos = {x=0.426, y=0.643,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
			[2] = {
				id=100626,--turstan
				pos = {x=0.433, y=0.643,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},	
	[7] = { -- weeping coast
		boss = {
			[1] = {
				id=101784,--bisang
				pos = {x=0.507, y=0.866,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},	
	[9] = { -- Aotulia Volcano
		boss = {
			[1] = {
				id=102740,--Sharleedah
				pos = {x=0.341, y=0.116,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},
	[15] = { -- Thunderhoof Hills
		boss = {
			[1] = {
				id=107183,--Furious Wodjin
				pos = {x=0.413, y=0.702,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
			[2] = {
				id=103580,--Wodjin
				pos = {x=0.389, y=0.702,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},
	[16] = { -- southern Janothar Forest
		boss = {
			[1] = {
				id=107185,--Furious Hackman
				pos = {x=0.764, y=0.716,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
			[2] = {
				id=103583,--Hackman
				pos = {x=0.740, y=0.716,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},
	[17] = { -- Northern Janothar Forest
		boss = {
			[1] = {
				id=104039,--Griffith
				pos = {x=0.511, y=0.417,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},
	[18] = { -- Limo
		boss = {
			[1] = {
				id=103129,--Zanka
				pos = {x=0.663, y=0.75,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},
	[19] = { -- Land of Malovence
		boss = {
			[1] = {
				id=107792,--Furious Mandara
				pos = {x=0.412, y=0.152,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
			[2] = {
				id=104705,--Mandara
				pos = {x=0.388, y=0.152,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},
	[21] = { -- Tergothen Bay
		boss = {
			[1] = {
				id=107192,--Furious Lagusen
				pos = {x=0.516, y=0.845,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
			[2] = {
				id=105894,--Lagusen
				pos = {x=0.492, y=0.845,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
			[3] = {
				id=107190,--Furious Targonharl
				pos = {x=0.776, y=0.174,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
			[4] = {
				id=105893,--Targonharl
				pos = {x=0.752, y=0.174,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},
	[22] = { -- Rorazan
		boss = {
			[1] = {
				id=103585,--Krolin
				pos = {x=0.361, y=0.404,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},
	[24] = { -- Merdhin
		boss = {
			[1] = {
				id=107375,--Verlorene Komponente
				pos = {x=0.282, y=0.407,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
				id2={
					[1] = {
						id=107213, --Zalkenrys
						pos = {x=0.295, y=0.393,},
						loot=false,
						box=false,
						worldboss = true,
						visible=true,
					},
				},
			},
		},
	},
	[25] = { -- Syrbal Pass
		boss = {
			[1] = {
				id=107476,--frantic yasheedee
				pos = {x=0.666, y=0.777,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
			[2] = {
				id=107477,--drake yapherian
				pos = {x=0.517, y=0.268,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
			[3] = {
				id=107672,--Farentel
				pos = {x=0.235, y=0.745,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},
	[26] = { -- Sarlo
		boss = {
			[1] = {
				id=107698,--kolanda
				pos = {x=0.543, y=0.579,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},
	[27] = { -- Wayling Fjord
		boss = {
			[1] = {
				id=107934,--taren
				pos = {x=0.435, y=0.225,},
				loot=true,
				box=false,
				worldboss = true,
				visible=true,
			},
		},
	},
	[30] = { -- Kashaylan
		boss = {
			[1] = {
				id=109240,--Energiespeicherrune
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.572, y=0.272,},
				id2={
					[1] = {
						id= 108400, --Sismond
						pos = {x=0.548, y=0.272,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
		},
	},
	[105] = { -- queen chamber
		zone=8,
		lvl=50,
		boss = {
			[1] = {
				id=100160,--queen
				pos = {x=0.487, y=0.390,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[250] = { -- Windmill Basement
		zone=1,
		lvl=15,
		raid=6,
		boss = {
			[1] = {
				id=100998,--Hodu Hammerzahn
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=100649,--Knochenbrecher
				pos = {x=0.5, y=0.5,},
				loot=true,
				box=false,
				visible=false,
			},
		},
	},
	[251] = { -- Arkane Kammer des Sathkur
		zone = 10,
		lvl = 16,
		raid=6,
		boss={
			[1] = {
				id=100922,--Hüter der verlorenen Geistergegenstände
				pos = {x=0.50, y=0.16,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=100919,--Hüter des Abenteurerschatzes
				pos = {x=0.54, y=0.16,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=100921,--Hüter des magischen Schatzes
				pos = {x=0.46, y=0.16,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=100925,--Hüter der alten Schätze
				pos = {x=0.50, y=0.12,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=100920,--Hüter der Plündererbeute
				pos = {x=0.50, y=0.20,},
				loot=true,
				box=false,
				visible=true,
			},
			[6] = {
				id=100918,--Hüter der Kriegsbeute
				pos = {x=0.54, y=0.12,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[102] = { -- Verlassene Abtei
		zone=2,
		lvl=25,
		raid=6,
		boss={
			[1] = {
				id=100073,--Ghul duke
				pos = {x=0.42, y=0.60,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=100561,--Fließendes Chaos
				pos = {x=0.68, y=0.71,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=100562, --Gräuelfresser
				pos = {x=0.73, y=0.53,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=100563,--Leere Hülle
				pos = {x=0.73, y=0.33,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=100074,--Dämonenhexe Ancalon
				pos = {x=0.88, y=0.45,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[103] = { -- Gräberstadt der Spiegel
		zone=4,
		lvl=35,
		raid=6,
		boss={
			[1] = {
				id=100264,--Magister Gumas
				pos = {x=0.31, y=0.79,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=100166,--Androliers Stärke
				pos = {x=0.608, y=0.91,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=100233, --Androliers Schatten
				pos = {x=0.33, y=0.41,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=100236,--Androliers Gefangener
				pos = {x=0.73, y=0.50,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=100261,--Krodamon
				pos = {x=0.57, y=0.10,},
				loot=true,
				box=false,
				visible=true,
			},
			[6] = {
				id=100262,--Krodamar
				pos = {x=0.53, y=0.10,},
				loot=true,
				box=false,
				visible=true,
			},
			[7] = {
				id=100566,--Spiegeltruhe
				pos = {x=0.55, y=0.10,},
				loot=true,
				box=true,
				visible=true,
			},
		},
	},
	[113] = { -- 35er Zi
		zone=11,
		lvl=35,
		raid=6,
		boss={
			[1] = {
				id=101588,--Maulwurkönig
				pos = {x=0.39098134636879, y=0.51327240467072,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=101587,--Crasset Fellfuß
				pos = {x=0.31745654344559, y=0.75468969345093,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=101585, --Eiswächter
				pos = {x=0.53932827711105, y=0.52559304237366,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=101586,--Mula Kupfernagel
				pos = {x=0.57593947649002, y=0.2521967035532,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[104] = { -- Mystischer Altar
		zone=5,
		lvl=40,
		raid=6,
		boss={
			[1] = {
				id=100374,--Böser Eisgeist
				pos = {x=0.40, y=0.90,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=100159,--Flammender Albtraum
				visible=true,
				pos = {x=0.667, y=0.874,},
				loot=true,
				box=false,
			},
			[3] = {
				id=100138, --Verwünschter Eisengolem
				pos = {x=0.65, y=0.247,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=100154,--Razeela
				pos = {x=0.25, y=0.37,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=100611,--Dorlos
				pos = {x=0.48, y=0.11,},
				loot=true,
				box=false,
				visible=true,
			},
			[6] = {
				id=100274,--Aukuda der verwünschte
				pos = {x=0.24, y=0.11,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[106] = { -- Schrein von Pasper
		zone=10,
		lvl=45,
		raid=6,
		boss={
			[1] = {
				id=101020,--Schwarzhorn Nisorn
				pos = {x=0.59, y=0.555,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=101021,--Schwarzhorn Dorglas
				pos = {x=0.29, y=0.44,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=101019, --SChwarzhorn Bareth
				pos = {x=0.75, y=0.38,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=101018,--SChwarzhorn Afalen
				pos = {x=0.75, y=0.44,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=100794,--SChwarzhorn Hafiz
				pos = {x=0.78, y=0.16,},
				loot=true,
				box=false,
				visible=true,
				},
			},
		},
	[252] = { -- Höhle der Zyklopen
		zone=11,
		lvl=50,
		raid=6,
		boss={
			[1] = {
				id=101346,--Podag
				pos = {x=0.47053158283234, y=0.57465767860413,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=101354,--Geschenk der Zurhidon
				pos = {x=0.82181692123413, y=0.49173578619957,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=101347, --Zurhidon Unterhändler
						pos = {x=0.81304883956909, y=0.48467266559601,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[3] = {
				id=101351, --Ortiga
				pos = {x=0.38406723737717, y=0.38553294539452,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=101349, --Masso
				pos = {x=0.37250864505768, y=0.39455908536911,},
				nocount = true,
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=101350, --Gaia
				pos = {x=0.38719379901886, y=0.40410578250885,},
				nocount = true,
				loot=true,
				box=false,
				visible=true,
			},
			[6] = {
				id=101352,--Uguda
				pos = {x=0.63237774372101, y=0.14337907731533,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[107] = { -- Schrein von Kalin
		zone=6,
		lvl=50,
		raid=6,
		boss={
			[1] = {
				id=101507,--Eiserner Runenkrieger
				pos = {x=0.47415089607239, y=0.81250506639481,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=101501,--Yusalien
				pos = {x=0.43530842661858, y=0.73397046327591,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=101502,--Locatha
				pos = {x=0.38117551803589, y=0.54316133260727,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=101500,--Adept der Göttin der Künste
				pos = {x=0.41975358128548, y=0.35330092906952,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=101503,--Ensia
				pos = {x=0.43066248297691, y=0.30587646365166,},
				loot=true,
				box=false,
				visible=true,
			},
			[6] = {
				id=100237,--Regin
				pos = {x=0.39948895573616, y=0.1038221567892,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[108] = { -- Schatzhöhle
		zone=3,
		lvl=50,
		raid=6,
		boss={
			[1] = {
				id=101531,--Wills Fluch
				pos = {x=0.678627967834473, y=0.50208562612534,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=101532,--Treuer Talomo
				pos = {x=0.37419587373734, y=0.43385580182076,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=101533,--Fels Sidaar
				pos = {x=0.54211926460266, y=0.11533584445715,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=101534,--Dreiaugen Luke
				pos = {x=0.34873354434967, y=0.18463589251041,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=101535,--Snow Blake
				pos = {x=0.4554015997072, y=0.16783984005451,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[114] = { -- Ruinen des Eiszwergenkönigreichs
		zone=11,
		lvl=50,
		raid=6,
		boss={
			[1] = {
				id=101884,--Maulwurfkönig
				pos = {x=0.39098134636879, y=0.51327240467072,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=101883,--Crasset Fellfuß
				pos = {x=0.31745654344559, y=0.75468969345093,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=101881,--Eiswächter
				pos = {x=0.53932827711105, y=0.52559304237366,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=101586,--Mula Kupfernagel
				pos = {x=0.57593947649002, y=0.2521967035532,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=102015,--Schatztruhe
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.57688999176025, y=0.22979760169983,},
				id2={
					[1] = {
						id=101586,--Mula Kupfernagel
						loot=true,
						box=false,
						visible=false,
					},
				},
			},
			[6] = {
				id=102014,--Schatztruhe
				pos = {x=0.55898456811905, y=0.22979760169983,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=101586, --Mula Kupfernagel
						pos = {x=0.55898456811905, y=0.22979760169983,},
						loot=true,
						box=false,
						visible=false,
					},
				},
			},
			[7] = {
				id=101268,--Pangkor
				pos = {x=0.67829298973083, y=0.62988090515137,},
				loot=true,
				box=false,
				visible=true,
			},
			[8] = {
				id=101584,--Thynos
				pos = {x=0.77752363681793, y=0.8991950750351,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[126] = { -- Herz des Ozeans (easy)
		zone=7,
		lvl=55,
		raid=6,
		boss={
			[1] = {
				id=103488,--Blutrünstige Klaue
				pos = {x=0.69196224212646, y=0.33060431480408,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=103487,--Riffzahn
				pos = {x=0.85573816299438, y=0.47797501087189,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=103485,--Jiasha
				pos = {x=0.73499935865402, y=0.67670911550522,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=103489,--Geba
				pos = {x=0.353325009340601, y=0.8441558480268,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=103486,--Medusa
				pos = {x=0.48747956752777, y=0.4825513958931,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[115] = { -- Herz des Ozeans
		zone=7,
		lvl=55,
		raid=6,
		boss={
			[1] = {
				id=102046,--Blutrünstige Klaue
				pos = {x=0.69196224212646, y=0.33060431480408,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=102041,--Riffzahn
				pos = {x=0.85573816299438, y=0.47797501087189,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=102021,--Jiasha
				pos = {x=0.73499935865402, y=0.67670911550522,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=102063,--Geba
				pos = {x=0.353325009340601, y=0.8441558480268,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=102040,--Medusa
				pos = {x=0.48747956752777, y=0.4825513958931,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[116] = { -- Ursprung
		zone=4,
		lvl=55,
		raid=6,
		boss={
			[1] = {
				id=102349,--Lebensdieb
				pos = {x=0.28300353884697, y=0.615393,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=102341,-- Riesenkäferkönig Beute
				pos = {x=0.44295173, y=0.8194386,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id= 102295, --Klingenschleicher
						pos = {x=0.430847243, y=0.810581,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[3] = {
				id=102358,--Aslan Geschenk
				pos = {x=0.8321, y=0.87829,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=102348, --Lorlin
						pos = {x=0.816544413, y=0.876066,},
						loot=false,
						box=false,
						visible=true,
						},
					[2] = {
						id=102356, --Taburen
						pos = {x=0.822109043, y=0.893426,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[4] = {
				id=102388,--Geschenk vom heiligen Baum Falynum
				pos = {x=0.823, y=0.50,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id= 102307, --Heiliger Baum Falynum
						pos = {x=0.823, y=0.47,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
		},
	},
	[123] = { -- Halle der Überlebenden (easy)
		zone=2,
		lvl=55,
		raid=12,
		boss={
			[1] = {
				id=103263,--Andriol
				pos = {x=0.43281656503677, y=0.60752946138382,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=103241,--Glamo
				pos = {x=0.26641446352005, y=0.45453426241875,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=103266,--Guldamor
				pos = {x=0.27648541331291, y=0.30960023403168,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=103205,--Vrantal
				pos = {x=0.41247734427452, y=0.16303437948227,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=103230,--Zygro
				pos = {x=0.71794748306274, y=0.27568218111992,},
				loot=true,
				box=false,
				visible=true,
			},
			[6] = {
				id=103198,--Sydaphex
				pos = {x=0.61213380098343, y=0.61291539669037,},
				loot=true,
				box=false,
				visible=true,
				id2={
					[1] = {
						id=102452, --Mantarick
						pos = {x=0.64410555362701, y=0.61732006072998,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[7] = {
				id=103212,--Andaphelmor
				pos = {x=0.4684584736824, y=0.798768106842,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[117] = { -- Halle der Überlebenden (normal)
		zone=2,
		lvl=55,
		raid=12,
		boss={
			[1] = {
				id=102421,--Andriol
				pos = {x=0.43281656503677, y=0.60752946138382,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=102475,--Glamo
				pos = {x=0.26641446352005, y=0.45453426241875,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=102395,--Guldamor
				pos = {x=0.27648541331291, y=0.30960023403168,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=102558,--Vrantal
				pos = {x=0.41247734427452, y=0.16303437948227,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=102425,--Zygro
				pos = {x=0.71794748306274, y=0.27568218111992,},
				loot=true,
				box=false,
				visible=true,
			},
			[6] = {
				id=102446,--Sydaphex
				pos = {x=0.61213380098343, y=0.61291539669037,},
				loot=true,
				box=false,
				visible=true,
				id2={
					[1] = {
						id=102452, --Mantarick
						pos = {x=0.64410555362701, y=0.61732006072998,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[7] = {
				id=102430,--Andaphelmor
				pos = {x=0.4684584736824, y=0.798768106842,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[118] = { -- Höhle des Wasserdrachen
		zone=1,
		lvl=55,
		raid=6,
		boss={
			[1] = {
				id=102564,--Zanordoths Gabe
				pos = {x=0.61889946460724, y=0.26336407661438,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=102623, --Lytfir
						pos = {x=0.66418892145157, y=0.25170883536000,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
		},
	},
	[119] = { -- Hort des Dämonendrachen
		zone=9,
		lvl=55,
		raid=12,
		boss={
			[1] = {
				id=102670,--Gestero
				pos = {x=0.4883046746254, y=0.37429708242416,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[120] = { -- Zurhidonfeste
		zone=9,
		lvl=55,
		raid=12,
		boss={
			[1] = {
				id=102706,--Charionys
				pos = {x=0.5745724439621, y=0.6322928071022,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=102683,--Fürstin Hansis
				pos = {x=0.63042056560516, y=0.3000470995903,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=102944,--Zurhidon Tribut
				pos = {x=0.45134982466698, y=0.1986391544342,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=102872, --Balothar
						pos = {x=0.44452118873596, y=0.19789420068264,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[4] = {
				id=102708,--Neuer Bote
				pos = {x=0.26491478085518, y=0.42700219154358,},
				loot=true,
				box=false,
				visible=true,
				},
			},
		},
	[122] = { -- Halle des Dämonenfürsten
		zone=9,
		lvl=55,
		raid=12,
		boss={
			[1] = {
				id=102701,--Naos
				pos = {x=0.20088239014149, y=0.60684859752655,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=102969,--Yash
				pos = {x=0.13740946352482, y=0.5232738256454,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=102705,--Aosniya
				pos = {x=0.20049379765987, y=0.30599775910378,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=102707,--Androlier
				pos = {x=0.51312506198883, y=0.3743143081665,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=102438,--Sirloth
				pos = {x=0.91017663478851, y=0.4261229634285,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[128] = { -- Kerker von Dalanis (easy)
		zone=209,
		lvl=57,
		raid=6,
		boss={
			[1] = {
				id=103857,--Okander Mallen
				pos = {x=0.20723322033882, y=0.39362975955009,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=103869,--Experiment Nr.81
				pos = {x=0.43828865885735, y=0.20780299603939,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=103861,--Experiment Nr 203
				pos = {x=0.68690490722656, y=0.45632693171501,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=103873,--Prototyp 114
				pos = {x=0.88295274972916, y=0.63324642181396,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=103866,--Maxim Erekat
				pos = {x=0.62333124876022, y=0.78634738922119,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[127] = { -- Kerker von Dalanis
		zone=209,
		lvl=57,
		raid=6,
		boss={
			[1] = {
				id=103169,--Okander Mallen
				pos = {x=0.20723322033882, y=0.39362975955009,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=103170,--Experiment Nr.81
				pos = {x=0.43828865885735, y=0.20780299603939,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=103153,--Experiment Nr 203
				pos = {x=0.68690490722656, y=0.45632693171501,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=103171,--Prototyp 114
				pos = {x=0.88295274972916, y=0.63324642181396,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=103155,--Maxim Erekat
				pos = {x=0.62333124876022, y=0.78634738922119,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[131] = { -- Arena von Warnorken (easy)
		zone=16,
		lvl=58,
		raid=6,
		boss={
			[1] = {
				id=104045,--Arena Beute
				pos = {x=0.48360896110535, y=0.45379441976547,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=104046, --Manticos
						pos = {x=0.43683993816376, y=0.46520060300827,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[2] = {
				id=104047,--Arena Beute
				pos = {x=0.46087718009949, y=0.42806667089462,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=104044,--Mukhan
						pos = {x=0.44159311056137, y=0.38945549726486,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[3] = {
				id=104049,--Arena Beute
				pos = {x=0.48429074883461, y=0.49561622738838,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=103934,--Magistratin Marachi
						pos = {x=0.39789971709251, y=0.44492590427399,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[4] = {
				id=104051,--Arena Beute
				pos = {x=0.46409499645233, y=0.52389788627625,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=103935, --Baron Reuen
						pos = {x=0.4149195253849, y=0.42349535226822,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[5] = {
				id=104054,--Arena Beute
				pos = {x=0.45290365815163, y=0.48540034890175,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=104053, --Magistratin Marachi
						pos = {x=0.41358813643456, y=0.46773993968964,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id=103942, --Baron Reuen
						pos = {x=0.43242213129997, y=0.43668898940086,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
		},
	},
	[129] = { -- Arena von Warnorken
		zone=16,
		lvl=58,
		raid=6,
		boss={
			[1] = {
				id=103840,--Arena Beute
				pos = {x=0.48360896110535, y=0.45379441976547,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=104046, --Manticos
						pos = {x=0.43683993816376, y=0.46520060300827,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[2] = {
				id=103955,--Arena Beute
				pos = {x=0.46087718009949, y=0.42806667089462,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=104044,--Mukhan
						pos = {x=0.44159311056137, y=0.38945549726486,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[3] = {
				id=103957,--Arena Beute
				pos = {x=0.48429074883461, y=0.49561622738838,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=103934, --Magistratin Marachi
						pos = {x=0.39789971709251, y=0.44492590427399,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[4] = {
				id=103958,--Arena Beute
				pos = {x=0.46409499645233, y=0.52389788627625,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=103935,--Baron Reuen
						pos = {x=0.4149195253849, y=0.42349535226822,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[5] = {
				id=103959,--Arena Beute
				pos = {x=0.45290365815163, y=0.48540034890175,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=104053, --Magistratin Marachi
						pos = {x=0.41358813643456, y=0.46773993968964,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id=103942, --Baron Reuen
						pos = {x=0.43242213129997, y=0.43668898940086,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
		},
	},
	[132] = { -- Tempel der Raksha (easy)
		zone=17,
		lvl=60,
		raid=6,
		boss={
			[1] = {
				id=104184,--Yawaka
				pos = {x=0.5419088602066, y=0.71070396900177,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=104187,--Shadoj
				pos = {x=0.48281052708626, y=0.87809973955151,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=104182,--Paicha
				pos = {x=0.35670357942581, y=0.82576954364777,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=104165,--Lijinda
				pos = {x=0.30310562252998, y=0.64534455537796,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=104174,--Raksha
				pos = {x=0.37126696109772, y=0.40988439321518,},
				loot=true,
				box=false,
				visible=true,
			},
			[6] = {
				id=104475,--Naylodas
				pos = {x=0.40833228826523, y=0.2592985033989,},
				loot=true,
				box=false,
				visible=true,
			},
			[7] = {
				id=104094,--Tyda
				pos = {x=0.42331737279892, y=0.11484033614397,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[130] = { -- Tempel der Raksha
		zone=17,
		lvl=60,
		raid=6,
		boss={
			[1] = {
				id=104461,--Yawaka
				pos = {x=0.5419088602066, y=0.71070396900177,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=103946,--Shadoj
				pos = {x=0.48281052708626, y=0.87809973955151,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=103947,--Paicha
				pos = {x=0.35670357942581, y=0.82576954364777,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=103948,--Lijinda
				pos = {x=0.30310562252998, y=0.64534455537796,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=103949,--Raksha
				pos = {x=0.37126696109772, y=0.40988439321518,},
				loot=true,
				box=false,
				visible=true,
			},
			[6] = {
				id=104465,--Naylodas
				pos = {x=0.40833228826523, y=0.2592985033989,},
				loot=true,
				box=false,
				visible=true,
			},
			[7] = {
				id=104096,--Tyda
				pos = {x=0.42331737279892, y=0.11484033614397,},
				loot=true,
				box=false,
				visible=true,
			},
			[8] = {
				id=104675,--Bronzene Truhe von Raksha
				pos = {x=0.35854694247246, y=0.79294520616531,},
				loot=true,
				box=true,
				visible=true,
				note = "RAKSHA_CHEST_NOTE",
			},
			[9] = {
				id=104679,--Silberne Truhe von Raksha
				pos = {x=0.31051176786423, y=0.63855195045471,},
				loot=true,
				box=true,
				visible=true,
				note = "RAKSHA_CHEST_NOTE",
			},
			[10] = {
				id=104683,--Goldene Truhe von Raksha
				pos = {x=0.38099053502083, y=0.42078402638435,},
				loot=true,
				box=true,
				visible=true,
				note = "RAKSHA_CHEST_NOTE",
			},
			[11] = {
				id=104687,--Platintruhe von Raksha
				pos = {x=0.39149960875511, y=0.2437955737114,},
				loot=true,
				box=true,
				visible=true,
				note = "RAKSHA_CHEST_NOTE",
			},
			[12] = {
				id=104691,--Diamantene Truhe von Raksha
				pos = {x=0.40848886966705, y=0.13180127739906,},
				loot=true,
				box=true,
				visible=true,
				note = "RAKSHA_CHEST_NOTE",
			},
		},
	},
	[135] = { -- Grabmal von Kawak (easy)
		zone=18,
		lvl=62,
		raid=6,
		raid=6,
		boss={
			[1] = {
				id=104656,--Guzala Grollfang
				pos = {x=0.37, y=0.70,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=104624,--Tygistor
				pos = {x=0.264, y=0.614,},
				loot=true,
				box=false,
				visible=true,
			 },
			[3] = {
				id=104663,--Geheimnisvolle Schatulle
				pos = {x=0.10, y=0.58,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=104228,--Linobia
						pos = {x=0.14, y=0.58,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[4] = {
				id=104511,--Yinha
				pos = {x=0.32, y=0.43,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=104653,--Anubis
				pos = {x=0.418, y=0.22,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[134] = { -- Grabmal von Kawak
		zone=18,
		lvl=62,
		raid=6,
		raid=6,
		boss={
			[1] = {
				id=104458,--Guzala Grollfang
				pos = {x=0.37, y=0.70,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=104225,--Tygistor
				pos = {x=0.264, y=0.614,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=104534,--Geheimnisvolle SChatulle	pos = {x=0.10, y=0.58,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=104228, --Linobia
						pos = {x=0.14, y=0.58,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[4] = {
				id=104227,--Yinha
				pos = {x=0.32, y=0.43,},
				loot=true,
				box=false,
				visible=true,
			 },
			[5] = {
				id=104224,--Anubis
				pos = {x=0.418, y=0.22,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[191] = { -- Osalontal
		zone=10000,
		lvl=62,
		raid=12,
		boss={
			[1] = {
				id=104951,--Munik Dunkelstern
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.22560724616051, y=0.42710679769516,},
			},
			[2] = {
				id=105111,--Monroe Walkers Effekte
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=105112,--Gantiks Effekte
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=104667,--Großer Luhng
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=104984,--Natasha Kleane
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[208] = { -- Albtraum von Varanas
		zone=10000,
		lvl=62,
		raid=150,
		boss={
			[1] = {
				id=102386,--Nachtmahr Androlier
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.53378677368164, y=0.38477584719658,},
			},
			[2] = {
				id=105220,--Albtraumkiste
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.53245085477829, y=0.28498294949532,},
				id2={
					[1] = {
						id=102386, --Nachtmahr Androlier
						pos = {x=0.53378677368164, y=0.38477584719658,},
						loot=true,
						box=false,
						visible=false,
					},
				},
			},
		},
	},
	[190] = { -- Graben von Bolynthia
		zone=6,
		lvl=65,
		raid=12,
		boss={
			[1] = {
				id=104920,--Lanka
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=105063,--Woozilla
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=105039,--Tanboli
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=104897,--Giftige Tealiss
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[138] = { -- Burg Grafu (easy)
		zone=19,
		lvl=65,
		raid=6,
		boss={
			[1] = {
				id=105617,--Cayus
				pos = {x=0.40677818655968, y=0.71660387516022,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=105559,--Geheimnis des Tierbändigers	
				pos = {x=0.28344831824303, y=0.77453345060349,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=104590, --Ardmond
						pos = {x=0.26286822557449, y=0.78070474624634,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id=104591, --Isaac
						pos = {x=0.26317358016968, y=0.76070474624634,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[3] = {
				id=105226,--Boro-Boro Brüder
				pos = {x=0.16205085813999, y=0.602535232717514,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=105578,--Zauberer Chapeaunoir
				pos = {x=0.2368144549788, y=0.34942665696144,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=105352,--Larvanger Barkud
				pos = {x=0.41286158561707, y=0.37903317809105,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[137] = { -- Burg Grafu Normal
		zone=19,
		lvl=65,
		raid=6,
		boss={
			[1] = {
				id=105616,--Cayus
				pos = {x=0.40677818655968, y=0.71660387516022,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=105558,--Geheimnis des Tierbändigers	
				pos = {x=0.28344831824303, y=0.77453345060349,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=104590, --Ardmond
						pos = {x=0.26286822557449, y=0.78070474624634,},
						loot=false,
						box=false,
						visible=true,
						},
					[2] = {
						id=104591, --Isaac
						pos = {x=0.26317358016968, y=0.76070474624634,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[3] = {
				id=105224,--Boro-Boro Brüder
				pos = {x=0.16205085813999, y=0.602535232717514,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=105560,--Zauberer Chapeaunoir
				pos = {x=0.2368144549788, y=0.34942665696144,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=105351,--Larvanger Barkud
				pos = {x=0.41286158561707, y=0.37903317809105,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[136] = { -- Burg Grafu HM
		zone=19,
		lvl=65,
		raid=12,
		boss={
			[1] = {
				id=105200,--Cayus
				pos = {x=0.40677818655968, y=0.71660387516022,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=105456,--Geheimnis des Tierbändigers
				pos = {x=0.28344831824303, y=0.77453345060349,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=104590, --Ardmond
						pos = {x=0.26286822557449, y=0.78070474624634,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id=104591, --Isaac
						pos = {x=0.26317358016968, y=0.76070474624634,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[3] = {
				id=104605,--Boro-Boro-Brüder
				pos = {x=0.16205085813999, y=0.602535232717514,},
				loot=true,box=false, visible=true,
			},
			[4] = {
				id=105204,--Zauberer Chapeaunoir
				pos = {x=0.2368144549788, y=0.34942665696144,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=105099,--Larvanger Barkud
				pos = {x=0.41286158561707, y=0.37903317809105,},
				loot=true,
				box=false,
				visible=true,
			},
			[6] = {
				id=104592,--Herl Grafu
				pos = {x=0.54717659950256, y=0.41799855232239,},
				loot=true,
				box=false,
				visible=true,
			},
			[7] = {
				id=104582,--Annelia
				pos = {x=0.5504310131073, y=0.18283513188362,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[140] = { -- Burg Sardo (easy)
		zone=20,
		lvl=67,
		raid=6,
		boss={
			[1] = {
				id=105859,--Versteckte Kiste
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.45128905773163, y=0.725526034832,},
				id2={
					[1] = {
						id= 105389, --Horatio Tia
						pos = {x=0.4521459370956, y=0.69518750905991,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[2] = {
				id=105880,--Jacklin Sardo
				pos = {x=0.19961301982403, y=0.82420980930328,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=105514,--Lanaik
				pos = {x=0.11988351494074, y=0.40951028466225,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=105864,--Versuchsobjekt Nr.374
				pos = {x=0.3223070204258, y=0.20452934503555,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=105523,--Reliquie des Generals
				pos = {x=0.66936165094376, y=0.30353060364723,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id= 105374, --Skelettgeneral
						pos = {x=0.68936165094376, y=0.30353060364723,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
		},
	},
	[139] = { -- Burg Sardo
		zone=20,
		lvl=67,
		raid=6,
		boss={
			[1] = {
				id=105460,--Versteckte Kiste
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.45128905773163, y=0.725526034832,},
				id2={
					[1] = {
						id= 105389, --Horatio Tia
						pos = {x=0.4521459370956, y=0.69518750905991,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[2] = {
				id=105515,--Jacklin Sardo
				pos = {x=0.19961301982403, y=0.82420980930328,},
				loot=true,
				box=false,
				visible=true,
			},
			[3] = {
				id=105267,--Lanaik
				pos = {x=0.11988351494074, y=0.40951028466225,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=105382,--Versuchsobjekt Nr.374
				pos = {x=0.3223070204258, y=0.20452934503555,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=105523,--Reliquie des Generals
				pos = {x=0.66936165094376, y=0.30353060364723,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id= 105374, --Skelettgeneral
						pos = {x=0.68936165094376, y=0.30353060364723,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
		},
	},
	[143] = { -- Grab der sieben Helden easy
		zone=15,
		lvl=70,
		raid=6,
		boss={
			[1] = {
				id=106044,--Jenny Giant
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.26052516698837, y=0.51905292272568,},
			},
			[2] = {
				id=106023,--Letin Mocliff
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.18079479038715, y=0.3094574213028,},
			},
			[3] = {
				id=106028,--Lekani
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.38290730118752, y=0.1637471765298,},
			},
			[4] = {
				id=106054,--Heurton
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.46457663178444, y=0.45283222198486,},
			},
			[5] = {
				id=106049,--thanteos kalume
				--[[ ]]--
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.62996536493301, y=0.56197905540466,},
			},
		},
	},
	[142] = { -- Grab der sieben Helden
		zone=15,
		lvl=70,
		raid=6,
		boss={
			[1] = {
				id=106043,--Jenny Giant
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.26052516698837, y=0.51905292272568,},
			},
			[2] = {
				id=106015,--Letin Mocliff
				--25
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.18079479038715, y=0.3094574213028,},
			},
			[3] = {
				id=106021,--Lekani
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.38290730118752, y=0.1637471765298,},
			},
			[4] = {
				id=106052,--Heurton
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.46457663178444, y=0.45283222198486,},
			},
			[5] = {
				id=106048,--thanteos kalume
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.62996536493301, y=0.56197905540466,},
			},
		},
	},
	[141] = { -- Grab der sieben Helden HM
		zone=15,
		lvl=70,
		raid=12,
		boss={
			[1] = {
				id=105807,--Jenny Giant
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.26052516698837, y=0.51905292272568,},
			},
			[2] = {
				id=105366,--Letin Mocliff
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.18079479038715, y=0.3094574213028,},
			},
			[3] = {
				id=105641,--Lekani
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.38290730118752, y=0.1637471765298,},
			},
			[4] = {
				id=105517,--Heurton
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.46457663178444, y=0.45283222198486,},
			},
			[5] = {
				id=105452,--Shint Kanches
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.40896880626678, y=0.6598733663559,},
			},
			[6] = {
				id=105520,--thanteos kalume
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.62996536493301, y=0.54197905540466,},
			},
			[7] = {
				id=105677,--Verfluchter Gesichtsverschlinger
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.62996536493301, y=0.58197905540466,},
			},
		},
	},
	[145] = { -- 10002-10006 --> Ewiger Kreis easy
		zone=22,
		lvl=72,
		raid=6,
		boss={
			[1] = {
				id=106442,--Kraftgolem Wachposten
				pos={x=0.387, y=0.536, map=10002,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=106708,--Eisfeuerkristall
				pos = {x=0.444, y=0.25, map=10003,},
				loot=true,
				box=false,
				visible=true,
				id2={
					[1] = {
						id=105934, --Eis
						pos = {x=0.429, y=0.23, map=10003,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id=105933, --Feuer
						pos = {x=0.455, y=0.23, map=10003,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[3] = {
				id=106206,--Foltergolem Wachposten
				pos = {x=0.44, y=0.222, map=10004,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=106740,--Runengolem Wachposten
				pos = {x=0.475, y=0.45, map=10005,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=106735,--Da'dalodin
				pos = {x=0.45, y=0.427, map=10006,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[144] = { -- 10002-10006 --> Ewiger Kreis
		zone=22,
		lvl=72,
		raid=6,
		boss={
			[1] = {
				id=105931,--Kraftgolem Wachposten
				pos = {x=0.371, y=0.537, map=10002,},
				loot=true,
				box=false,
				visible=true,
			},
			[2] = {
				id=106100,--Eisfeuerkristall
				pos = {x=0.444, y=0.323, map=10003,},
				loot=true,
				box=false,
				visible=true,
				id2={
					[1] = {
						id=105934, --Eis
						pos = {x=0.429, y=0.30, map=10003,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id=105933, --Feuer
						pos = {x=0.455, y=0.30, map=10003,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[3] = {
				id=105935,--Foltergolem Wachposten
				pos = {x=0.438, y=0.271, map=10004,},
				loot=true,
				box=false,
				visible=true,
			},
			[4] = {
				id=105964,--Runengolem Wachposten
				pos = {x=0.45, y=0.45, map=10005,},
				loot=true,
				box=false,
				visible=true,
			},
			[5] = {
				id=105976,--Da'dalodin
				pos = {x=0.426, y=0.427, map=10006,},
				loot=true,
				box=false,
				visible=true,
			},
		},
	},
	[194] = { -- Chaoswirbel: Böse
		zone=10000,--Varanas
		lvl=72,
		raid=6,
		boss={
			[1] = {
				id=106625,--Periehr
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.0, y=0.0,},
			},
			[2] = {
				id=106635,--Sormyn
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.0, y=0.0,},
			},
			[3] = {
				id=106572,--Gorlo
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.0, y=0.0,},
			},
			[4] = {
				id=106550,--Palogis
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.0, y=0.0,},
			},
		},
	},
	[148] = { -- Knochennest der Kulech (easy)
		zone=23,--Chrysalia
		lvl=75,
		raid=6,
		boss={
			[1] = {
				id=107307,--Andoneo
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.0, y=0.0,},
			},
			[2] = {
				id=107199,--Riesenfleischmade
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.0, y=0.0,},
			},
			[3] = {
				id=107223,--Assimilierter Shetamb
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.0, y=0.0,},
			},
			[4] = {
				id=107321,--Kulech-Königin Bodana
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.0, y=0.0,},
			},
			[5] = {
				id=107234,--Neue Myrmex-Königin Balenq
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.0, y=0.0,},
			},
		},
	},
	[147] = { -- Knochennest der Kulech
		zone=23,--Chrysalia
		lvl=75,
		raid=6,
		boss={
			[1] = {
				id=107302,--Andoneo
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.0, y=0.0,},
			},
			[2] = {
				id=107196,--Riesenfleischmade
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.0, y=0.0,},
			},
			[3] = {
				id=107218,--Assimilierter Shetamb
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.0, y=0.0,},
			},
			[4] = {
				id=107314,--Kulech-Königin Bodana
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.0, y=0.0,},
			},
			[5] = {
				id=106656,--Neue Myrmex-Königin Balenq
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.0, y=0.0,},
			},
		},
	},
	[146] = { -- Knochennest von Kulech HM
		zone=23,--Chrysalia
		lvl=75,
		raid=12,
		boss={
			[1] = {
				id=106382,--Andoneo
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.496, y=0.626,},
			},
			[2] = {
				id=106307,--Riesenfleischmade
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.328, y=0.414,},
			},
			[3] = {
				id=106604,--Assimilierter Shetamb
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.63, y=0.429,},
			},
			[4] = {
				id=106292,--Kulech Königin Bodana
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.834, y=0.283,},
			},
			[5] = {
				id=106300,--Neue Myrmex Königin Balenq
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.751, y=0.709,},
			},
			[6] = {
				id=106299,--Bestraferteile
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.751, y=0.75,},
				id2={
					[1] = {
						id=106297, --Tysen
						pos = {x=0.77, y=0.75,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[7] = {
				id=106414,--Shetamb
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.751, y=0.80,},
			},
		},
	},
	[150] = { -- Bedim easy
		zone=24,--Merdhin Tundra
		lvl=77,
		raid=6,
		boss={
			[1] = {
				id=107453, -- Shismon (80)
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.174, y=0.673,},
			},
			[2] = {
				id=107454, --Magier�berreste lvl 80
				pos = {x=0.329, y=0.404,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1]={
						id = 107455, --Sair (80)
						pos={x=0.329, y=0.404,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[3] = {
				id=107459, -- Garmel (80)
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.445, y=0.154,},
			},
			[4] = {
				id=107465,-- Geheimer Schatz von Myloden (80)
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.62, y=0.482,},
				id2={
					[1]={
						id=107462,-- Myloden Dayson (80)
						loot=false,
						box=false,
						visible=true,
						pos = {x=0.61, y=0.482,},
					},
				},
			},
			[5] = {
				id=106816,-- Salingdon (80)
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.602, y=0.621,},
			},
		},
	},
	[149] = { -- Bedim
		zone=24,--Merdhin Tundra
		lvl=77,
		raid=6,
		boss={
			[1] = {
				id=106609, -- Shismon (80)
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.174, y=0.673,},
			},
			[2] = {
				id=105812, --Magier�berreste lvl 80
				pos = {x=0.329, y=0.404,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1]={
						id = 106198, --Sair (80)
						pos={x=0.329, y=0.404,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[3] = {
				id=106596, -- Garmel (80)
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.445, y=0.154,},
			},
			[4] = {
				id=107370,-- Geheimer Schatz von Myloden (80)
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.62, y=0.482,},
				id2={
					[1]={
						id=106900,-- Myloden Dayson (80)
						loot=false,
						box=false,
						visible=true,
						pos = {x=0.61, y=0.482,},
					},
				},
			},
			[5] = {
				id=106814,-- Salingdon (80)
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.602, y=0.621,},
			},
		},
	},
	[153] = { -- Bethomia easy
		zone=25,--Syrbalpass
		lvl=80,
		raid=6,
		boss={
			[1] = {
				id=107583, --Hoson
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.486, y=0.456,},
			},
			[2] = {
				id=107605,--Sandos
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.321, y=0.513,},
			},
			[3] = {
				id=107607,--Verlorene Waren
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.210, y=0.411,},
				id2={
					[1] = {
						id= 107606, --Fayleod
						pos = {x=0.21, y=0.429,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[4] = {
				id=107608,--Tatha
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.295, y=0.373,},
			},
			[5] = {
				id=107615,--Lasoyl
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.374, y=0.198,},
			},
		},
	},
	[151] = { -- Bethomia normal
		zone=25,--Syrbalpass
		lvl=80,
		raid=6,
		boss={
			[1] = {
				id=106853, --Hoson
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.486, y=0.456,},
			},
			[2] = {
				id=106890,--Sandos
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.321, y=0.513,},
			},
			[3] = {
				id=106201,--Verlorene Waren
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.210, y=0.411,},
				id2={
					[1] = {
						id= 106444, --Fayleod
						pos = {x=0.21, y=0.429,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[4] = {
				id=107593,--Tatha
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.295, y=0.373,},
			},
			[5] = {
				id=106450,--Lasoyl
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.374, y=0.198,},
			},
		},
	},
	[152] = { -- Bethomia hm
		zone=25,--Syrbalpass
		lvl=80,
		raid=12,
		boss={
			[1] = {
				id=107581, --Hoson
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.486, y=0.456,},
			},
			[2] = {
				id=107589,--Sandos
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.321, y=0.513,},
			},
			[3] = {
				id=107590,--Verlorene Waren
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.210, y=0.411,},
				id2={
					[1] = {
						id= 107591, --Fayleod
						pos = {x=0.21, y=0.429,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[4] = {
				id=107228,--Tatha
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.295, y=0.373,},
			},
			[5] = {
				id=107592,--Lasoyl
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.374, y=0.198,},
			},
			[6] = {
				id=106640,--Lyong
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.481, y=0.308,},
			},
			[7] = {
				id=106833,--Krynor
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.509, y=0.149,},
			},
		},
	},
	[156] = { -- Belathis easy
		zone=26,--Sarlo
		lvl=82,
		raid=6,
		boss={
			[1] = {
				id=108041,--Sagwyth
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.6, y=0.74, map = 156},
			},
			[2] = {
				id=108045,--Jolytta
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.59, y=0.516, map = 156},
			},
			[3] = {
				id=108054,--Drachenseelenschatz
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.689, y=0.432, map = 10007},
				id2={
					[1] = {
						id=108049, --Sayafiz
						pos = {x=0.717, y=0.516, map = 10007},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[4] = {
				id=108061,--Brennender Energiewürfel des Wächters
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.369, y=0.288, map = 156},
				id2={
					[1] = {
						id=108055, --Manipulierter Farutor
						pos = {x=0.358, y=0.358, map = 156},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[5] = {
				id=108069,--Runendimension des Dämonenkaisers
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.373, y=0.122, map = 156},
				id2={
					[1] = {
						id=108062, --Maderoth
						pos = {x=0.373, y=0.084, map = 156},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
		},
	},
	[155] = { -- Belathis normal
		zone=26,--Sarlo
		lvl=82,
		raid=6,
		boss={
			[1] = {
				id=107978,--Sagwyth
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.6, y=0.74, map = 155},
			},
			[2] = {
				id=107982,--Jolytta
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.59, y=0.516, map = 155},
			},
			[3] = {
				id=107991,--Drachenseelenschatz
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.678, y=0.405, map = 10007},
				id2={
					[1] = {
						id=107986, --Sayafiz
						pos = {x=0.707, y=0.489, map = 10007},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[4] = {
				id=107998,--Brennender Energiewürfel des Wächters
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.369, y=0.288, map = 155},
				id2={
					[1] = {
						id=107992, --Manipulierter Farutor
						pos = {x=0.358, y=0.358, map = 155},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[5] = {
				id=108006,--Runendimension des Dämonenkaisers
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.373, y=0.122, map = 155},
				id2={
					[1] = {
						id=107999, --Maderoth
						pos = {x=0.373, y=0.084, map = 155},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
		},
	},
	[154] = { -- Belathis hard
		zone=26,--Sarlo
		lvl=82,
		raid=12,
		boss={
			[1] = {
				id=102987,--Sagwyth
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.6, y=0.74, map = 154},
			},
			[2] = {
				id=102990,--Jolytta
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.59, y=0.516, map = 154},
			},
			[3] = {
				id=107822,--Drachenseelenschatz
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.699, y=0.405, map = 10007},
				id2={
					[1] = {
						id=102835,--Sayafiz
						pos = {x=0.727, y=0.489, map = 10007},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[4] = {
				id=107866,--Brennender Energiewürfel des Wächters
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.369, y=0.288, map = 154},
				id2={
					[1] = {
						id=102993, --Manipulierter Farutor
						pos = {x=0.358, y=0.358, map = 154},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[5] = {
				id=107867,--Runendimension des Dämonenkaisers
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.373, y=0.122, map = 154},
				id2={
					[1] = {
						id=102995, --Maderoth
						pos = {x=0.373, y=0.084, map = 154},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
		},
	},
	[159] = { -- Grotto of Horror easy
		zone=27,--Wailing Fjord
		lvl=85,
		raid=6,
		boss={
			[1] = {
				id=108177,--Aggregat der Verzweiflung
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.564, y=0.714,},
			},
			[2] = {
				id=108160,--Nabukos
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.408, y=0.466,},
			},
			[3] = {
				id=108169,--Yinajo
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.551, y=0.203,},
			},
			[4] = {
				id=108178,--Yifirus
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.536, y=0.16,},
			},
			[5] = {
				id=108164,--Tabokake
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.7150, y=0.446,},
			},
		},
	},
	[158] = { -- Grotto of Horror normal
		zone=27,--Wailing Fjord
		lvl=85,
		raid=6,
		boss={
			[1] = {
				id=108175,--Aggregat der Verzweiflung
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.564, y=0.714,},
			},
			[2] = {
				id=108157,--Nabukos
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.408, y=0.466,},
			},
			[3] = {
				id=108166,--Yinajo
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.551, y=0.203,},
			},
			[4] = {
				id=107834,--Sys107834_name Yifirus
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.536, y=0.16,},
			},
			[5] = {
				id=108163,--Tabokake
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.7150, y=0.446,},
			},
		},
	},
	[157] = { -- Grotto of Horror hm
		zone=27,--Wailing Fjord
		lvl=85,
		raid=12,
		boss={
			[1] = {
				id=108150,--Sys108150_name Aggregat der Verzweiflung
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.564, y=0.714,},
			},
			[2] = {
				id=108144,--Sys108144_name Nabukos
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.408, y=0.466,},
			},
			[3] = {
				id=107836,--Sys107836_name Yinajo
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.551, y=0.203,},
			},
			[4] = {
				id=107834,--Sys107834_name Yifirus
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.536, y=0.16,},
			},
			[5] = {
				id=107852,--Sys107852_name Tabokake
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.7150, y=0.446,},
			},
			[6] = {
				id=107832,--Sys107832_name Tekoli Wussa
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.569, y=0.514,},
			},
			[7] = {
				id=107871,--Sys107871_name Pikusate
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.549, y=0.514,},
			},
		},
	},
	[162] = { -- Pillars of Morfan easy
		zone=28,--Hurtekke Jungle
		lvl=87,
		raid=6,
		boss={
			[1] = {
 			id=108309,--Gorligen
 			loot=true,
				box=false,
				visible=true,
 			pos = {x=0.687, y=0.663,},
			},
			[2] = {
 			id=108292,--Kerkolon
 			loot=true,
				box=false,
				visible=true,
 			pos = {x=0.617, y=0.339,},
			},
			[3] = {
 			id=108294,--Sarsidan
 			loot=true,
				box=false,
				visible=true,
 			pos = {x=0.471, y=0.369,},
			},
			[4] = {
 			id=108314,--Yarlis
 			loot=true,
				box=false,
				visible=true,
 			pos = {x=0.292, y=0.626,},
			},
			[5] = {
 			id=108296,--Horban
 			loot=true,
				box=false,
				visible=true,
 			pos = {x=0.187, y=0.499,},
			},
		},
	},
	[161] = { -- Pillars of Morfan normal
		zone=28,--Hurtekke Jungle
		lvl=87,
		raid=6,
		boss={
			[1] = {
				id=108302,--Gorligen
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.687, y=0.663,},
			},
			[2] = {
				id=108291,--Kerkolon
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.617, y=0.339,},
			},
			[3] = {
				id=108293,--Sarsidan
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.471, y=0.369,},
			},
			[4] = {
 			id=108307,--Yarlis
 			loot=true,
				box=false,
				visible=true,
 			pos = {x=0.292, y=0.626,},
			},
			[5] = {
 			id=108295,--Horban
 			loot=true,
				box=false,
				visible=true,
 			pos = {x=0.187, y=0.499,},
			},
		},
	},
	[160] = { -- Pillars of Morfan hm
		zone=28,--Hurtekke Jungle
		lvl=87,
		raid=12,
		boss={
			[1] = {
				id=107964,--Gorligen
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.687, y=0.663,},
			},
			[2] = {
				id=107965,--Kerkolon
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.617, y=0.339,},
			},
			[3] = {
				id=107966,--Sarsidan
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.471, y=0.369,},
			},
			[4] = {
				id=107967,--Yarlis
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.292, y=0.626,},
			},
			[5] = {
				id=107968,--Horban
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.187, y=0.499,},
			},
		},
	},
	[196] = { -- Hall of Earth
		zone=81,--Arkanium kammer
		lvl=87,
		raid=12,
		boss={
			[1] = {
				id=108947,--Gugolar
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.33394, y=0.48298,},
			},
			[2] = {
				id=108948,--Mao
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.55645, y=0.49191,},
			},
			[3] = {
 			id=108949,--Mo
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.43344, y=0.79064,},
			},
			[4] = {
				id=108950,--Sankeniya
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.82846, y=0.88865,},
			},
		},
	},
	[197] = { -- Hall of Water
		zone=81,--Arkanium kammer
		lvl=87,
		raid=12,
		boss={
			[1] = {
				id=108962,--Thallas
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.7004, y=0.32679,},
			},
			[2] = {
				id=108963,--Durlas
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.73465, y=0.68315,},
			},
			[3] = {
				id=108964,--Hazzua
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.44595, y=0.69717,},
			},
			[4] = {
				id=108965,--Kalashia
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.4884, y=0.4805,},
			},
		},
	},
	[198] = { -- Hall of Fire
		zone=81,--Arkanium kammer
		lvl=90,
		raid=12,
		boss={
			[1] = {
				id=108974,--Anzuyas
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.40292, y=0.44338,},
			},
			[2] = {
				id=108975,--Yashiz
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.64137, y=0.37384,},
			},
			[3] = {
				id=108976,--Lithoman
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.45128, y=0.60702,},
			},
			[4] = {
				id=108977,--Zabuna
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.48935, y=0.37671,},
			},
		},
	},
	[199] = { -- Hall of Chaos
		zone=81,--Arkanium kammer
		lvl=90,
		raid=12,
		boss={
			[1] = {
				id=108458,--Mysterium des Chaos
				pos = {x=0.604, y=0.417,},
				loot=true,
				box=true,
				visible=true,
				id2={
					[1] = {
						id=108988, --Biyanna
						pos = {x=0.61568, y=0.42489,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id=108989, --Sadoya
						pos = {x=0.60831, y=0.39706,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[2] = {
				id=108990,--Pienna
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.86303, y=0.38031,},
			},
			[3] = {
				id=108991,--Zabo
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.59927, y=0.7382,},
			},
			[4] = {
				id=108992,--Warlin
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.36854, y=0.72643,},
			},
		},
	},
	[81]  = { -- Arkanium Chamber
		zone=10000,--Varanas
		lvl=87,
		boss={
			[1] = {
 			id=123644,--Amanda Logar
				loot=false,
				box=false,
				visible=false,
				pos = {x=0.0, y=0.0,},
			},
			[2] = {
				id=123645,--Fern Weik
				loot=false,
				box=false,
				visible=false,
				pos = {x=0.0, y=0.0,},
			},
			[3] = {
 			id=123646,--Naomi Liv
				loot=false,
				box=false,
				visible=false,
				pos = {x=0.0, y=0.0,},
			},
			[4] = {
				id=123647,--Felin Gordon
				loot=false,
				box=false,
				visible=false,
				pos = {x=0.0, y=0.0,},
			},
		},
	},
	[165] = { -- Crypt of Eternity easy
		zone=29,--Salioca Basin
		lvl=90,
		raid=6,
		boss={
			[1] = {
				id=103391,--Adur
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.186, y=0.460,},
			},
			[2] = {
				id=108414,--Khalakli
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.3525, y=0.60392,},
			},
			[3] = {
				id=108483,--Mosfetto
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.43, y=0.73,},
			},
			[4] = {
				id=108417,--Katbalbus
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.53412, y=0.53843,},
			},
			[5] = {
				id=108488,--Thallsus
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.604, y=0.217,},
			},
		},
	},
	[164] = { -- Crypt of Eternity
		zone=29,--Salioca Basin
		lvl=90,
		raid=6,
		boss={
			[1] = {
				id=103387,--Adur
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.186, y=0.460,},
			},
			[2] = {
				id=108408,--Khalakli
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.3525, y=0.60392,},
			},
			[3] = {
				id=108482,--Mosfetto
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.43, y=0.73,},
			},
			[4] = {
				id=108411,--Katbalbus
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.53412, y=0.53843,},
			},
			[5] = {
				id=108485,--Thallsus
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.604, y=0.217,},
			},
		},
	},
	[163] = { -- Crypt of Eternity hm
		zone=29,--Salioca Basin
		lvl=90,
		raid=12,
		boss={
			[1] = {
				id=108276,--Adur
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.186, y=0.460,},
			},
			[2] = {
				id=108275,--Khalakli
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.3525, y=0.60392,},
			},
			[3] = {
				id=108481,--Mosfetto
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.43, y=0.73,},
			},
			[4] = {
				id=108279,--Katbalbus
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.53412, y=0.53843,},
			},
			[5] = {
				id=108280,--Thallsus
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.604, y=0.217,},
			},
			[6] = {
				id=108281,--Kulabis
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.749, y=0.279,},
			},
			[7] = {
				id=108282,--Kelopas
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.93, y=0.232,},
			},
		},
	},
	[168] = { -- Kashaylan easy
		zone=30,--Kashaylan
		lvl=92,
		raid=6,
		boss={
			[1] = {
				id=108644,--Lismomo
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.736, y=0.694,},
			},
			[2] = {
				id=103412,--Yarnatha
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.573, y=0.728,}, -- +-
			},
			[3] = {
				id=108584,--Tatarwiak
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.449, y=0.613,},
			},
			[4] = {
				id=108642,--Kinya
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.711, y=0.443,}, -- +-
			},
			[5] = {
				id=108595,--Wütender Manakaza
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.571, y=0.266,},
			},
		},
	},
	[167] = { -- Kashaylan
		zone=30,--Kashaylan
		lvl=92,
		raid=6,
		boss={
			[1] = {
				id=108634,--Lismomo
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.736, y=0.694,},
			},
			[2] = {
				id=103402,--Yarnatha
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.573, y=0.728,}, -- +-
			},
			[3] = {
				id=108572,--Tatarwiak
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.449, y=0.613,},
			},
			[4] = {
				id=108639,
				box=false,
				visible=true,
				pos = {x=0.711, y=0.443,}, -- +-
			},
			[5] = {
				id=108583,--Wütender Manakaza
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.571, y=0.266,},
			},
		},
	},
	[166] = { -- Kashaylan hm
		zone=30,--Kashaylan
		lvl=92,
		raid=12,
		boss={
			[1] = {
				id=108432,--Lismomo
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.736, y=0.694,},
			},
			[2] = {
				id=108434,--Yarnatha
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.573, y=0.728,}, -- +-
			},
			[3] = {
				id=108438,--Tatarwiak
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.449, y=0.613,},
			},
			[4] = {
				id=108440,--Kinya
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.711, y=0.443,}, -- +-
			},
			[5] = {
				id=108571,--Wütender Manakaza
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.571, y=0.266,},
			},
		},
	},
	[169] = { -- skull rock hm
		zone=32,--splitwater
		lvl=95,
		raid=12,
		boss={ -- boss missing
			[1] = {
				id=106134,--kostbarer schatz
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.557, y=0.435,},
				id2={
					[1] = {
						id= 108596, --Sanbrescha Gordy
						pos = {x=0.546, y=0.42,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id= 108597, --Lorl Gordy
						pos = {x=0.563, y=0.416,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[2] = {
				id=108616,--Nachtkerker Geheimtruhe
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.639, y=0.242,},
				id2={
					[1] = {
						id= 108684, --Hauptmann Maarsel Gordy
						pos = {x=0.646, y=0.258,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[3] = {
				id=108598,--Slogar
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.409, y=0.262,},
			},
			[4] = {
				id=108599,--Alter Dan Gordy
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.251, y=0.205,},
			},
			[5] = {
				id=108600,--Allseelensarg
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.147, y=0.086,},
			},
			[6] = {
				id=108601,--Shabdoo
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.116, y=0.404,},
			},
			[7] = {
				id=108602,--Istye
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.332, y=0.713,},
			},
		},
	},
	[170] = { -- skull rock
		zone=32,--splitwater
		lvl=95,
		raid=6,
		boss={ -- boss missing
			[1] = {
				id=106152,--kostbarer schatz
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.557, y=0.435,},
				id2={
					[1] = {
						id= 108697, --Sanbrescha Gordy
						pos = {x=0.546, y=0.42,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id= 108698, --Lorl Gordy
						pos = {x=0.563, y=0.416,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[2] = {
				id=106154,--Nachtkerker Geheimtruhe
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.639, y=0.242,},
				id2={
					[1] = {
						id= 108880, --Hauptmann Maarsel Gordy
						pos = {x=0.646, y=0.258,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[3] = {
				id=108703,--Slogar
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.409, y=0.262,},
			},
			[4] = {
				id=108685,--Alter Dan Gordy
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.251, y=0.205,},
			},
			[5] = {
				id=108687,--Allseelensarg
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.147, y=0.086,},
			},
		},
	},
	[171] = { -- skull rock easy
		zone=32,--splitwater
		lvl=95,
		raid=6,
		boss={
			[1] = {
				id=106153,--kostbarer schatz
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.557, y=0.435,},
				id2={
					[1] = {
						id= 108699, --Sanbrescha Gordy
						pos = {x=0.546, y=0.42,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id= 108700, --Lorl Gordy
						pos = {x=0.563, y=0.416,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[2] = {
				id=106155,--Nachtkerker Geheimtruhe
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.639, y=0.242,},
				id2={
					[1] = {
						id= 108886, --Hauptmann Maarsel Gordy
						pos = {x=0.646, y=0.258,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[3] = {
				id=108704,--Slogar
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.409, y=0.262,},
			},
			[4] = {
				id=108686,--Alter Dan Gordy
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.251, y=0.205,},
			},
			[5] = {
				id=108692,--Allseelensarg
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.147, y=0.086,},
			},
		},
	},
	[172] = { -- madroke hard
		zone=33,--farsitan
		lvl=97,
		raid=12,
		boss={ -- 
			[1] = {
				id=108800,--Charkor
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.505, y=0.645,},
			},
			[2] = {
				id=108804,--Genozan
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.489, y=0.286,},
			},
			[3] = {
				id=108809,--Kellas
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.678, y=0.265,},
			},
			[4] = {
				id=108814,--Mogmogur
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.536, y=0.16,},
			},
		},
	},
	[173] = { -- madroke
		zone=33,--farsitan
		lvl=97,
		raid=6,
		boss={ -- 
			[1] = {
				id=108912,--Charkor
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.505, y=0.645,},
			},
			[2] = {
				id=108916,--Genozan
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.489, y=0.286,},
			},
			[3] = {
				id=109002,--Kellas
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.678, y=0.265,},
			},
		},
	},
	[174] = { -- madroke easy
		zone=33,--farsitan
		lvl=97,
		raid=6,
		boss={ -- 
			[1] = {
				id=108914,--Charkor
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.505, y=0.645,},
			},
			[2] = {
				id=108921,--Genozan
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.489, y=0.286,},
			},
			[3] = {
				id=109006,--Kellas
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.678, y=0.265,},
			},
		},
	},
	[175] = { -- Raven Heart hard
		zone=33,--farsitan
		lvl=97,
		raid=12,
		boss={ -- 
			[1] = {
				id=108832,--Geheimobjekt des Rates
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.210, y=0.411,},
				id2={
					[1] = {
						id= 108819, --Tona
						pos = {x=0.413, y=0.602,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id= 108821, --Slacy
						pos = {x=0.425, y=0.602,},
						loot=false,
						box=false,
						visible=true,
					},
					[3] = {
						id= 108818, --Gokhur
						pos = {x=0.424, y=0.617,},
						loot=false,
						box=false,
						visible=true,
					},
					[4] = {
						id= 108820, --Mollok
						pos = {x=0.412, y=0.617,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[2] = {
				id=106289,--'Leerer Experimentalschatz'
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.210, y=0.411,},
				id2={
					[1] = {
						id= 108826, --Asoken
						pos = {x=0.208, y=0.483,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id= 108825, --Kenova
						pos = {x=0.208, y=0.508,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[3] = {
				id=108830,--Meshyah
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.678, y=0.265,},
			},
		},
	},
	[176] = { -- Raven Heart
		zone=33,--farsitan
		lvl=97,
		raid=6,
		boss={ -- 
			[1] = {
				id=108833,--Geheimobjekt des Rates
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.210, y=0.411,},
				id2={
					[1] = {
						id= 103762, --Tona
						pos = {x=0.413, y=0.602,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id= 103764, --Slacy
						pos = {x=0.425, y=0.602,},
						loot=false,
						box=false,
						visible=true,
					},
					[3] = {
						id= 103761, --Gokhur
						pos = {x=0.424, y=0.617,},
						loot=false,
						box=false,
						visible=true,
					},
					[4] = {
						id= 103763, --Mollok
						pos = {x=0.412, y=0.617,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[2] = {
				id=108835,--'Leerer Experimentalschatz'
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.210, y=0.411,},
				id2={
					[1] = {
						id= 103770, --Asoken
						pos = {x=0.208, y=0.483,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id= 103769, --Kenova
						pos = {x=0.208, y=0.508,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
		},
	},
	[177] = { -- Raven Heart easy
		zone=33,--farsitan
		lvl=97,
		raid=6,
		boss={ -- 
			[1] = {
				id=108834,--Geheimobjekt des Rates
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.210, y=0.411,},
				id2={
					[1] = {
						id= 103766, --Tona
						pos = {x=0.413, y=0.602,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id= 103768, --Slacy
						pos = {x=0.425, y=0.602,},
						loot=false,
						box=false,
						visible=true,
					},
					[3] = {
						id= 103765, --Gokhur
						pos = {x=0.424, y=0.617,},
						loot=false,
						box=false,
						visible=true,
					},
					[4] = {
						id= 103767, --Mollok
						pos = {x=0.412, y=0.617,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[2] = {
				id=108836,--'Leerer Experimentalschatz'
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.210, y=0.411,},
				id2={
					[1] = {
						id= 103772, --Asoken
						pos = {x=0.208, y=0.483,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id= 103771, --Kenova
						pos = {x=0.208, y=0.508,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
		},
	},
	[178] = { -- Tal der Riten hard
		zone=34,--Tasuq
		lvl=98,
		raid=12,
		boss={ --
			[1] = {
				id=101378,--'Gruppenbeute'
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.554, y=0.771,},
				id2={
					[1] = {
						id= 106258, --Unheilbringer
						pos = {x=0.53, y=0.76,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id= 106256, --Lichtschlucker
						pos = {x=0.537, y=0.769,},
						loot=false,
						box=false,
						visible=true,
					},
					[3] = {
						id= 106257, --Hoffnungslöscher
						pos = {x=0.536, y=0.778,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[2] = {
				id=106193,--Tasuqtentakel
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.729, y=0.318,},
			},
			[3] = {
				id=106175,--Kreyen
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.449, y=0.473,},
			},
			[4] = {
				id=109310,--Marissha
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.473, y=0.256,},
			},
			[5] = {
				id=106210,--Marwen
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.631, y=0.134,},
			},
		},
	},	
	[179] = { -- Tal der Riten
		zone=34,--Tasuq
		lvl=98,
		raid=6,
		boss={ --
			[1] = {
				id=107352,--'Gruppenbeute'
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.554, y=0.771,},
				id2={
					[1] = {
						id= 107355, --Unheilbringer
						pos = {x=0.53, y=0.76,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id= 107353, --Lichtschlucker
						pos = {x=0.537, y=0.769,},
						loot=false,
						box=false,
						visible=true,
					},
					[3] = {
						id= 107354, --Hoffnungslöscher
						pos = {x=0.536, y=0.778,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[2] = {
				id=109227,--Tasuqtentakel
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.729, y=0.318,},
			},
			[3] = {
				id=106283,--Kreyen
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.449, y=0.473,},
			},
			[4] = {
				id=109316,--Marissha
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.473, y=0.256,},
			},
			[5] = {
				id=109996,--Marwen
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.631, y=0.134,},
			},
		},
	},	
	[180] = { -- Tal der Riten easy
		zone=34,--Tasuq
		lvl=98,
		raid=6,
		boss={ --
			[1] = {
				id=107382,--'Gruppenbeute'
				loot=true,
				box=true,
				visible=true,
				pos = {x=0.554, y=0.771,},
				id2={
					[1] = {
						id= 107385, --Unheilbringer
						pos = {x=0.53, y=0.76,},
						loot=false,
						box=false,
						visible=true,
					},
					[2] = {
						id= 107383, --Lichtschlucker
						pos = {x=0.537, y=0.769,},
						loot=false,
						box=false,
						visible=true,
					},
					[3] = {
						id= 107384, --Hoffnungslöscher
						pos = {x=0.536, y=0.778,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[2] = {
				id=109155,--Tasuqtentakel
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.729, y=0.318,},
			},
			[3] = {
				id=106287,--Kreyen
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.449, y=0.473,},
			},
			[4] = {
				id=109317,--Marissha
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.473, y=0.256,},
			},
			[5] = {
				id=107356,--Marwen
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.631, y=0.134,},
			},
		},
	},
	[181] = { -- Eisklingen Plateau Hard
		zone=35,--Korris
		lvl=99,
		raid=6,
		boss={ --
			[1] = {
				id=100032,--'Fursthor'
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.679, y=0.287,},
			},
			[2] = {
				id=100033,--Nex von Korris
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.555, y=0.448,},
			},
			[3] = {
				id=100034,--Zeyj
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.449, y=0.473,},
			},
			[4] = {
				id=109604,--Verschollener Beutel
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.861, y=0.732,},
				id2={
					[1] = {
						id= 100035, --Cibel
						pos = {x=0.862, y=0.721,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[5] = {
				id=100036,--Nasqtas
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.627, y=0.812,},
			},
		},
	},
	[182] = { -- Eisklingen Plateau
		zone=35,--Korris
		lvl=99,
		raid=6,
		boss={ --
			[1] = {
				id=100037,--'Fursthor'
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.679, y=0.287,},
			},
			[2] = {
				id=100038,--Nex von Korris
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.555, y=0.448,},
			},
			[3] = {
				id=100039,--Zeyj
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.449, y=0.473,},
			},
			[4] = {
				id=109604,--Verschollener Beutel
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.861, y=0.732,},
				id2={
					[1] = {
						id= 100040, --Cibel
						pos = {x=0.862, y=0.721,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[5] = {
				id=100041,--Nasqtas
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.627, y=0.812,},
			},
		},
	},
	[183] = { -- Eisklingen Plateau easy
		zone=35,--Korris
		lvl=99,
		raid=6,
		boss={ --
			[1] = {
				id=100045,--'Fursthor'
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.679, y=0.287,},
			},
			[2] = {
				id=100046,--Nex von Korris
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.555, y=0.448,},
			},
			[3] = {
				id=100047,--Zeyj
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.449, y=0.473,},
			},
			[4] = {
				id=109604,--Verschollener Beutel
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.861, y=0.732,},
				id2={
					[1] = {
						id= 100048, --Cibel
						pos = {x=0.862, y=0.721,},
						loot=false,
						box=false,
						visible=true,
					},
				},
			},
			[5] = {
				id=100049,--Nasqtas
				loot=true,
				box=false,
				visible=true,
				pos = {x=0.627, y=0.812,},
			},
		},
	},
}
	
