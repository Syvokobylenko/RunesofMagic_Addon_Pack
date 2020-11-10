-- Normal - comb 5 = 0
-- Deactive - comb 5 = 2
-- NoMake - comb 5 = 3
-- TreasureHunt - comb 5 = 4
-- NoMakeTreasureHunt - comb 5 = 5
-- AltMake - comb 5 = 6
return {
	{
		-- number for comb: 1; Vigor
		Name = string.gsub( TEXT("Sys520021_name") , " I", ""),
		Type = 0,
		Icon = "run_wea_001",
		ID   = "7EF55",
		Comb = {2,4,0,0,0}
	},
	{
		-- number for comb: 2; Resistance
		Name = string.gsub( TEXT("Sys520041_name") , " I", ""),
		Type = 0,
		Icon = "run_hea_001",
		ID   = "7EF69",
		Comb = {5,1,0,0,0}
	},
	{
		-- number for comb: 3; Mind
		Name = string.gsub( TEXT("Sys520061_name") , " I", ""),
		Type = 0,
		Icon = "run_leg_001",
		ID   = "7EF7D",
		Comb = {9,4,0,0,0}
	},
	{
		-- number for comb: 4; Vitality
		Name = string.gsub( TEXT("Sys520081_name") , " I", ""),
		Type = 0,
		Icon = "run_tel_001",
		ID   = "7EF91",
		Comb = {3,11,0,0,0}
	},
	{
		-- number for comb: 5; Quickness
		Name = string.gsub( TEXT("Sys520101_name") , " I", ""),
		Type = 0,
		Icon = "run_cra_001",
		ID   = "7EFA5",
		Comb = {3,2,0,0,0}
	},
	{
		-- number for comb: 6; Endurance
		Name = string.gsub( TEXT("Sys520121_name") , " I", ""),
		Type = 0,
		Icon = "run_hea_020",
		ID   = "7EFB9",
		Comb = {10,2,0,0,0}
	},
	{
		-- number for comb: 7; Magic
		Name = string.gsub( TEXT("Sys520141_name") , " I", ""),
		Type = 0,
		Icon = "run_tor_001",
		ID   = "7EFCD",
		Comb = {11,4,0,0,0}
	},
	{
		-- number for comb: 8; Harm
		Name = string.gsub( TEXT("Sys520161_name") , " I", ""),
		Type = 0,
		Icon = "run_wea_054",
		ID   = "7EFE1",
		Comb = {3,1,0,0,0}
	},
	{
		-- number for comb: 9; Strike
		Name = string.gsub( TEXT("Sys520181_name") , " I", ""),
		Type = 0,
		Icon = "run_leg_011",
		ID   = "7EFF5",
		Comb = {7,3,0,0,0}
	},
	{
		-- number for comb: 10; Defense
		Name = string.gsub( TEXT("Sys520201_name") , " I", ""),
		Type = 0,
		Icon = "run_hea_011",
		ID   = "7F009",
		Comb = {5,2,0,0,0}
	},
	{
		-- number for comb: 11; Shell
		Name = string.gsub( TEXT("Sys520221_name") , " I", ""),
		Type = 0,
		Icon = "run_tor_011",
		ID   = "7F01D",
		Comb = {7,4,0,0,0}
	},
	{
		-- number for comb: 12; Atonement
		Name = string.gsub( TEXT("Sys520241_name") , " I", ""),
		Type = 1,
		Icon = "runes_stone01_01",
		ID   = "7F031",
		Comb = {6,2,0,0,0}
	},
	{
		-- number for comb: 13; Payback
		Name = string.gsub( TEXT("Sys520261_name") , " I", ""),
		Type = 1,
		Icon = "runes_stone01_02",
		ID   = "7F045",
		Comb = {3,4,0,0,0}
	},
	{
		-- number for comb: 14; Excite
		Name = string.gsub( TEXT("Sys520281_name") , " I", ""),
		Type = 1,
		Icon = "runes_stone01_03",
		ID   = "7F059",
		Comb = {1,4,0,0,0}
	},
	{
		-- number for comb: 15; Guts
		Name = string.gsub( TEXT("Sys520301_name") , " I", ""),
		Type = 1,
		Icon = "runes_stone01_04",
		ID   = "7F06D",
		Comb = {7,2,0,0,0}
	},
	{
		-- number for comb: 16; Rouse
		Name = string.gsub( TEXT("Sys520321_name") , " I", ""),
		Type = 1,
		Icon = "runes_stone01_05",
		ID   = "7F081",
		Comb = {6,5,0,0,0}
	},
	{
		-- number for comb: 17; Triumph
		Name = string.gsub( TEXT("Sys520341_name") , " I", ""),
		Type = 1,
		Icon = "runes_stone01_06",
		ID   = "7F095",
		Comb = {6,3,0,0,0}
	},
	{
		-- number for comb: 18; Anger
		Name = string.gsub( TEXT("Sys520361_name") , " I", ""),
		Type = 2,
		Icon = "runes_stone02_01",
		ID   = "7F0A9",
		Comb = {14,17,0,0,0}
	},
	{
		-- number for comb: 19; Barrier
		Name = string.gsub( TEXT("Sys520381_name") , " I", ""),
		Type = 2,
		Icon = "runes_stone02_02",
		ID   = "7F0BD",
		Comb = {15,17,0,0,0}
	},
	{
		-- number for comb: 20; Resistor
		Name = string.gsub( TEXT("Sys520401_name") , " I", ""),
		Type = 2,
		Icon = "runes_stone02_03",
		ID   = "7F0D1",
		Comb = {15,16,0,0,0}
	},
	{
		-- number for comb: 21; Mayhem
		Name = string.gsub( TEXT("Sys520421_name") , " I", ""),
		Type = 2,
		Icon = "runes_stone02_04",
		ID   = "7F0E5",
		Comb = {14,15,0,0,0}
	},
	{
		-- number for comb: 22; Passion
		Name = string.gsub( TEXT("Sys520441_name") , " I", ""),
		Type = 3,
		Icon = "runes_stone03_01",
		ID   = "7F0F9",
		Comb = {18,19,0,0,4}
	},
	{
		-- number for comb: 23; Fountain
		Name = string.gsub( TEXT("Sys520461_name") , " I", ""),
		Type = 3,
		Icon = "runes_stone03_02",
		ID   = "7F10D",
		Comb = {21,20,0,0,4}
	},
	{
		-- number for comb: 24; Fearless
		Name = string.gsub( TEXT("Sys520481_name") , " I", ""),
		Type = 3,
		Icon = "runes_stone03_03",
		ID   = "7F121",
		Comb = {19,20,0,0,4}
	},
	{
		-- number for comb: 25; Might
		Name = string.gsub( TEXT("Sys520501_name") , " I", ""),
		Type = 4,
		Icon = "runes_stone04_01",
		ID   = "7F135",
		Comb = {24,22,0,0,4}
	},
	{
		-- number for comb: 26; Agile
		Name = string.gsub( TEXT("Sys520521_name") , " I", ""),
		Type = 4,
		Icon = "runes_stone04_02",
		ID   = "7F149",
		Comb = {23,22,0,0,4}
	},
	{
		-- number for comb: 27; Sorcery
		Name = string.gsub( TEXT("Sys520541_name") , " I", ""),
		Type = 4,
		Icon = "runes_stone04_03",
		ID   = "7F15D",
		Comb = {24,23,0,0,4}
	},
	{
		-- number for comb: 28; Aggression
		Name = string.gsub( TEXT("Sys520561_name") , " I", ""),
		Type = 5,
		Icon = "runes_stone05_01",
		ID   = "7F171",
		Comb = {26,25,0,0,0}
	},
	{
		-- number for comb: 29; Advance
		Name = string.gsub( TEXT("Sys520581_name") , " I", ""),
		Type = 5,
		Icon = "runes_stone05_02",
		ID   = "7F185",
		Comb = {25,27,0,0,4}
	},
	{
		-- number for comb: 30; Revolution
		Name = string.gsub( TEXT("Sys520601_name") , " I", ""),
		Type = 5,
		Icon = "runes_stone05_03",
		ID   = "7F199",
		Comb = {26,27,0,0,4}
	},
	{
		-- number for comb: 31; Block
		Name = string.gsub( TEXT("Sys520621_name") , " I", ""),
		Type = 5,
		Icon = "runes_stone05_04",
		ID   = "7F1AD",
		Comb = {22,27,0,0,5}
	},
	{
		-- number for comb: 32; Shield
		Name = string.gsub( TEXT("Sys520641_name") , " I", ""),
		Type = 5,
		Icon = "runes_stone05_05",
		ID   = "7F1C1",
		Comb = {25,23,0,0,5}
	},
	{
		-- number for comb: 33; Potential
		Name = string.gsub( TEXT("Sys520661_name") , " I", ""),
		Type = 3,
		Icon = "runes_stone06_01",
		ID   = "7F1D5",
		Comb = {18,21,0,0,4}
	},
	{
		-- number for comb: 34; Hatred
		Name = string.gsub( TEXT("Sys520681_name") , " I", ""),
		Type = 6,
		Icon = "runes_stone06_02",
		ID   = "7F1E9",
		Comb = {28,31,0,0,0}
	},	
	{
		-- number for comb: 35; Reconciliation
		Name = string.gsub( TEXT("Sys520701_name") , " I", ""),
		Type = 6,
		Icon = "runes_stone06_03",
		ID   = "7F1FD",
		Comb = {29,32,0,0,0}
	},
	{
		-- number for comb: 36; Loot
		Name = string.gsub( TEXT("Sys520721_name") , " I", ""),
		Type = 6,
		Icon = "runes_stone06_04",
		ID   = "7F211",
		Comb = {29,30,0,0,3} 
	},
	{
		-- number for comb: 37; Experience
		Name = string.gsub( TEXT("Sys520741_name") , " I", ""),
		Type = 6,
		Icon = "runes_stone06_05",
		ID   = "7F225",
		Comb = {28,30,0,0,3}
	},
	{
		-- number for comb: 38; Fatal
		Name = string.gsub( TEXT("Sys520761_name") , " I", ""),
		Type = -1,
		Icon = "runes_stone07_01",
		ID   = "7F239",
		Comb = {0,0,0,0,3}
	},
	{
		-- number for comb: 39; Burst
		Name = string.gsub( TEXT("Sys520781_name") , " I", ""),
		Type = -1,
		Icon = "runes_stone07_02",
		ID   = "7F24D",
		Comb = {0,0,0,0,3}
	},
	{
		-- number for comb: 40; Wrath
		Name = string.gsub( TEXT("Sys520801_name") , " I", ""),
		Type = -1,
		Icon = "runes_stone08_01",
		ID   = "7F261",
		Comb = {0,0,0,0,3}
	},
	{
		-- number for comb: 41; Miracle
		Name = string.gsub( TEXT("Sys520821_name") , " I", ""),
		Type = -1,
		Icon = "runes_stone08_02",
		ID   = "7F275",
		Comb = {0,0,0,0,3}
	},
	{
		-- number for comb: 42; Savage
		Name = string.gsub( TEXT("Sys520871_name") , " I", ""),
		Type = 1,
		Icon = "power_stone92",
		ID   = "7f2a7",
		Comb = {2,1,1,4,0}
	},
	{
		-- number for comb: 43; Stamina
		Name = string.gsub( TEXT("Sys520891_name") , " I", ""),
		Type = 1,
		Icon = "power_stone94",
		ID   = "7f2bb",
		Comb = {5,2,2,1,0}
	},
	{
		-- number for comb: 44; Intellect
		Name = string.gsub( TEXT("Sys520911_name") , " I", ""),
		Type = 1,
		Icon = "power_stone96",
		ID   = "7f2cf",
		Comb = {3,3,9,4,0}
	},
	{
		-- number for comb: 45; Spirit
		Name = string.gsub( TEXT("Sys520931_name") , " I", ""),
		Type = 1,
		Icon = "power_stone98",
		ID   = "7f2e3",
		Comb = {3,11,4,4,0}
	},
	{
		-- number for comb: 46; Dexterity
		Name = string.gsub( TEXT("Sys520951_name") , " I", ""),
		Type = 1,
		Icon = "power_stone100",
		ID   = "7f2f7",
		Comb = {3,5,5,2,0}
	},
	{
		-- number for comb: 47; Life
		Name = string.gsub( TEXT("Sys520971_name") , " I", ""),
		Type = 1,
		Icon = "power_stone102",
		ID   = "7f30b",
		Comb = {10,6,6,2,0}
	},
	{
		-- number for comb: 48; Spell
		Name = string.gsub( TEXT("Sys520991_name") , " I", ""),
		Type = 1,
		Icon = "power_stone104",
		ID   = "7f31f",
		Comb = {7,7,11,4,0}
	},
	{
		-- number for comb: 49; Cruelty
		Name = string.gsub( TEXT("Sys521011_name") , " I", ""),
		Type = 1,
		Icon = "power_stone106",
		ID   = "7f333",
		Comb = {8,8,3,1,0}
	},
	{
		-- number for comb: 50; Charm
		Name = string.gsub( TEXT("Sys521031_name") , " I", ""),
		Type = 1,
		Icon = "power_stone108",
		ID   = "7f347",
		Comb = {7,3,9,9,0}
	},
	{
		-- number for comb: 51; Safeguard
		Name = string.gsub( TEXT("Sys521051_name") , " I", ""),
		Type = 1,
		Icon = "power_stone110",
		ID   = "7f35b",
		Comb = {10,10,5,2,0}
	},
	{
		-- number for comb: 52; Ward
		Name = string.gsub( TEXT("Sys521071_name") , " I", ""),
		Type = 1,
		Icon = "power_stone112",
		ID   = "7f36f",
		Comb = {7,11,11,4,0}
	},
	{
		-- number for comb: 53; Ferocity
		Name = string.gsub( TEXT("Sys521091_name") , " I", ""),
		Type = 2,
		Icon = "power_stone114",
		ID   = "7f383",
		Comb = {12,12,6,2,4}
	},
	{
		-- number for comb: 54; Devil
		Name = string.gsub( TEXT("Sys521111_name") , " I", ""),
		Type = 2,
		Icon = "power_stone116",
		ID   = "7f397",
		Comb = {13,13,3,4,0}
	},
	{
		-- number for comb: 55; Grasp
		Name = string.gsub( TEXT("Sys521131_name") , " I", ""),
		Type = 2,
		Icon = "power_stone118",
		ID   = "7f3ab",
		Comb = {14,14,1,4,4}
	},
	{
		-- number for comb: 56; Capability
		Name = string.gsub( TEXT("Sys521151_name") , " I", ""),
		Type = 2,
		Icon = "power_stone120",
		ID   = "7f3bf",
		Comb = {15,15,7,2,4}
	},
	{
		-- number for comb: 57; Keenness
		Name = string.gsub( TEXT("Sys521171_name") , " I", ""),
		Type = 2,
		Icon = "power_stone122",
		ID   = "7f3d3",
		Comb = {6,16,16,5,4}
	},
	{
		-- number for comb: 58; Comprehension
		Name = string.gsub( TEXT("Sys521191_name") , " I", ""),
		Type = 2,
		Icon = "power_stone124",
		ID   = "7f3e7",
		Comb = {6,3,17,17,4}
	},
	{
		-- number for comb: 59; Madness
		Name = string.gsub( TEXT("Sys521211_name") , " I", ""),
		Type = 3,
		Icon = "power_stone126",
		ID   = "7f3fb",
		Comb = {55,58,0,0,0}
	},
	{
		-- number for comb: 60; Madness
		Name = string.gsub( TEXT("Sys521211_name") , " I", "") .. " ("..RCText.Runes.ShortAlt..")",
		Type = 3,
		Icon = "power_stone126",
		ID   = "7f3fb",
		Comb = {18,18,14,17,6}
	},
	{
		-- number for comb: 61; Dauntlessness
		Name = string.gsub( TEXT("Sys521231_name") , " I", ""),
		Type = 3,
		Icon = "power_stone128",
		ID   = "7f40f",
		Comb = {56,58,0,0,0}
	},
	{
		-- number for comb: 62; Dauntlessness
		Name = string.gsub( TEXT("Sys521231_name") , " I", "") .. " ("..RCText.Runes.ShortAlt..")",
		Type = 3,
		Icon = "power_stone128",
		ID   = "7f40f",
		Comb = {19,19,15,17,6}
	},
	{
		-- number for comb: 63; Enchantment
		Name = string.gsub( TEXT("Sys521251_name") , " I", ""),
		Type = 3,
		Icon = "power_stone130",
		ID   = "7f423",
		Comb = {56,57,0,0,0}
	},
	{
		-- number for comb: 64; Enchantment
		Name = string.gsub( TEXT("Sys521251_name") , " I", "") .. " ("..RCText.Runes.ShortAlt..")",
		Type = 3,
		Icon = "power_stone130",
		ID   = "7f423",
		Comb = {15,20,20,16,6}
	},
	{
		-- number for comb: 65; Destruction
		Name = string.gsub( TEXT("Sys521271_name") , " I", ""),
		Type = 3,
		Icon = "power_stone132",
		ID   = "7f437",
		Comb = {55,56,0,0,0}
	},
	{
		-- number for comb: 66; Destruction
		Name = string.gsub( TEXT("Sys521271_name") , " I", "") .. " ("..RCText.Runes.ShortAlt..")",
		Type = 3,
		Icon = "power_stone132",
		ID   = "7f437",
		Comb = {14,15,21,21,6}
	},
	{
		-- number for comb: 67; Raid
		Name = string.gsub( TEXT("Sys521291_name") , " I", ""),
		Type = 4,
		Icon = "power_stone134",
		ID   = "7f44b",
		Comb = {18,19,22,22,0}
	},
	{
		-- number for comb: 68; Curse
		Name = string.gsub( TEXT("Sys521311_name") , " I", ""),
		Type = 4,
		Icon = "power_stone136",
		ID   = "7f45f",
		Comb = {23,23,21,20,0}
	},
	{
		-- number for comb: 69; Accuracy
		Name = string.gsub( TEXT("Sys521331_name") , " I", ""),
		Type = 4,
		Icon = "power_stone138",
		ID   = "7f473",
		Comb = {19,24,24,20,0}
	},
	{
		-- number for comb: 70; Enlightenment
		Name = string.gsub( TEXT("Sys521351_name") , " I", ""),
		Type = 4,
		Icon = "power_stone140",
		ID   = "7f487",
		Comb = {18,21,33,33,0}
	},
	{
		-- number for comb: 71; Tyrant
		Name = string.gsub( TEXT("Sys521371_name") , " I", ""),
		Type = 5,
		Icon = "power_stone142",
		ID   = "7f49b",
		Comb = {69,67,0,0,0}
	},
	{
		-- number for comb: 72; Tyrant
		Name = string.gsub( TEXT("Sys521371_name") , " I", "") .. " ("..RCText.Runes.ShortAlt..")",
		Type = 5,
		Icon = "power_stone142",
		ID   = "7f49b",
		Comb = {25,25,24,22,6}
	},
	{
		-- number for comb: 73; Assassin
		Name = string.gsub( TEXT("Sys521391_name") , " I", ""),
		Type = 5,
		Icon = "power_stone144",
		ID   = "7f4af",
		Comb = {68,67,0,0,0}
	},
	{
		-- number for comb: 74; Assassin
		Name = string.gsub( TEXT("Sys521391_name") , " I", "") .. " ("..RCText.Runes.ShortAlt..")",
		Type = 5,
		Icon = "power_stone144",
		ID   = "7f4af",
		Comb = {26,26,23,22,6}
	},
	{
		-- number for comb: 75; Sage
		Name = string.gsub( TEXT("Sys521411_name") , " I", ""),
		Type = 5,
		Icon = "power_stone146",
		ID   = "7f4c3",
		Comb = {69,68,0,0,0}
	},
	{
		-- number for comb: 76; Sage
		Name = string.gsub( TEXT("Sys521411_name") , " I", "") .. " ("..RCText.Runes.ShortAlt..")",
		Type = 5,
		Icon = "power_stone146",
		ID   = "7f4c3",
		Comb = {27,27,24,23,6}
	},
	{
		-- number for comb: 77; Enigma
		Name = string.gsub( TEXT("Sys521431_name") , " I", ""),
		Type = 6,
		Icon = "power_stone148",
		ID   = "7f4d7",
		Comb = {73,71,0,0,0}
	},
	{
		-- number for comb: 78; Judge
		Name = string.gsub( TEXT("Sys521451_name") , " I", ""),
		Type = 6,
		Icon = "power_stone150",
		ID   = "7f4eb",
		Comb = {75,71,0,0,0}
	},
	{
		-- number for comb: 79; Massacre
		Name = string.gsub( TEXT("Sys521471_name") , " I", ""),
		Type = 6,
		Icon = "power_stone152",
		ID   = "7f4ff",
		Comb = {73,75,0,0,0}
	}
}