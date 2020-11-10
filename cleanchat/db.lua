return {
	["Channel"] = {
		["ChatTypeGroup"]	= "CHANNEL",
		["Header"]			= TEXT( "USER_DEFINE_CHANNNEL" ),
		[1]	= {
			["ChatTypeGroup"]	= "CHANNEL",
			["Text"]			= "*".. TEXT( "SYS_JOIN_CHANNEL" ) .."*",
		},
		[2]	= {
			["ChatTypeGroup"]	= "CHANNEL",
			["Text"]			= "*".. TEXT( "SYS_LEAVE_CHANNEL" ) .."*",
		},
		[3]	= {
			["ChatTypeGroup"]	= "CHANNEL",
			["Text"]			= "*".. string.gsub( TEXT( "SYS_CHANNEL_LEADER" ), "%%s", "" ) .."*",
		},
	},
	["Festivals"] = {
		["ChatTypeGroup"]	= "SYSTEM",
		["Header"]			= TEXT( "UI_TITLE_TYPE_4_1" ),
		["Craft"] = {
			["ChatTypeGroup"]	= "SYSTEM",
			["Header"]			= TEXT( "_glossary_02633" ),
			[1]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "SC_SKILLEVENT_ALLCAST01" ),
			},
			[2]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "SC_SKILLEVENT_EV1_01" ),
			},
			[3]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "SC_SKILLEVENT_EV1_02" ),
			},
		},
		["FairyTale"] = {
			["ChatTypeGroup"]	= "SYSTEM",
			["Header"]			= TEXT( "_glossary_01083" ),
			[1]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "SC_0908SEANSON_CAST" ),
			},
			[2]	= {
				["ChatTypeGroup"]	= "SAY",
				["Text"]			= TEXT( "SC_0908SEANSON_NPCSAY01" ),
			},
			[3]	= {
				["ChatTypeGroup"]	= "SAY",
				["Text"]			= TEXT( "SC_0908SEANSON_NPCSAY02" ),
			},
		},
		["Pumpkin"] = {
			["ChatTypeGroup"]	= "SYSTEM",
			["Header"]			= TEXT( "_glossary_01179" ),
			[1]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "SC_YU_HW_111611_5" ),
			},
			[2]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "SC_PFES_KORS_Q2_21" ),
			},
			[3]	= {
				["ChatTypeGroup"]	= "SAY",
				["Text"]			= TEXT( "SC_YU_HW_111611_1" ),
			},
			[4]	= {
				["ChatTypeGroup"]	= "SAY",
				["Text"]			= TEXT( "SC_YU_HW_111611_2" ),
			},
			[5]	= {
				["ChatTypeGroup"]	= "SAY",
				["Text"]			= TEXT( "SC_YU_HW_111611_3" ),
			},
			[6]	= {
				["ChatTypeGroup"]	= "SAY",
				["Text"]			= TEXT( "SC_YU_HW_111611_4" ),
			},
			[7]	= {
				["ChatTypeGroup"]	= "SAY",
				["Text"]			= TEXT( "SC_111577_YU_10" ),
			},
			[8]	= {
				["ChatTypeGroup"]	= "SAY",
				["Text"]			= TEXT( "SC_TRICK_OR_TREAT" ),
			},
			[9]	= {
				["ChatTypeGroup"]	= "SAY",
				["Text"]			= TEXT( "SC_111575_FLAG_6" ),
			},
			[10]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "SC_PFES_KORS_QDX_00" ),
			},
		},
	},
	["PublicEvents"] = {
		["ChatTypeGroup"]	= "SYSTEM",
		["Header"]			= TEXT( "UI_TITLE_TYPE_4_0" ),
		["BloodyGallery"] = {
			["ChatTypeGroup"]	= "SYSTEM",
			["Header"]			= TEXT( "_glossary_01228" ),
			[1]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "BLOODYGALLERY_OPEN_1" ),
			},
			[2]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "BLOODYGALLERY_OPEN_2" ),
			},
			[3]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "BLOODYGALLERY_OPEN_3" ),
			},
			[4]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "BLOODYGALLERY_OPEN_4" ),
			},
		},
		["BolinthyaRift"] = {
			["ChatTypeGroup"]	= "SYSTEM",
			["ChatTypeColor"]	= { r = 0.91, g = 0.91, b = 0 },
			["Header"]			= TEXT( "_glossary_02541" ),
			[1]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["ChatTypeColor"]	= { r = 0.91, g = 0.91, b = 0 },
				["Text"]			= TEXT( "SC_PE_ZONE2_01_M01" ),
			},
			[2]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["ChatTypeColor"]	= { r = 0.91, g = 0.91, b = 0 },
				["Text"]			= TEXT( "SC_PE_ZONE2_01_M02" ),
			},
			[3]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["ChatTypeColor"]	= { r = 0.91, g = 0.91, b = 0 },
				["Text"]			= TEXT( "SC_PE_ZONE2_01_M03" ),
			},
			[4]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["ChatTypeColor"]	= { r = 0.91, g = 0.91, b = 0 },
				["Text"]			= TEXT( "SC_PE_ZONE2_01_M04" ),
			},
			[5]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["ChatTypeColor"]	= { r = 0.91, g = 0.91, b = 0 },
				["Text"]			= TEXT( "SC_PE_ZONE2_01_M05" ),
			},
		},
		["ArcaniumChamber"] = {
			["ChatTypeGroup"]	= "SYSTEM",
			["Header"]			= TEXT( "ZONE_BG_ARCANE_ARENA_01_AC2" ),
			[1]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "SC_AC2_PHASE_3" ),
			},
			[2]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "SC_AC2_PHASE_4" ),
			},
			[3]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "SC_AC2_PHASE_5" ),
			},
			[4]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "SC_AC2_PHASE_6" ),
			},
		},
	},
	["Others"] = {
		["ChatTypeGroup"]	= "SYSTEM",
		["Header"]			= "Others",
		["MagicCavy"] = {
			["ChatTypeGroup"]	= "SYSTEM",
			["Header"]			= TEXT( "_glossary_02308" ),
			[1]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= string.gsub( TEXT( "SC_PETSYS_28" ), "%[%$VAR1%]", "%*" ),
			},
			[2]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "SC_PETSYS_32" ),
			},
		},
		["SiegeWar"] = {
			["ChatTypeGroup"]	= "SYSTEM",
			["Header"]			= TEXT( "SYS_GUILD_RESOURCE_STR_13" ),
			[1]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "SYS_GUILDWARSTATUS_BEGIN" ),
			},
			[2]	= {
				["ChatTypeGroup"]	= "SYSTEM",
				["Text"]			= TEXT( "SYS_GUILDWARSTATUS_PREPARE" ),
			},
		},
		["Varanas"] = {
			["ChatTypeGroup"]	= "SAY",
			["Header"]			= TEXT( "_glossary_01259" ),
			[1]	= {
				["ChatTypeGroup"]	= "SAY",
				["Text"]			= TEXT( "SC_424976_09" ),
			},
			[2]	= {
				["ChatTypeGroup"]	= "SAY",
				["Text"]			= TEXT( "SC_424976_08" ),
			},
			[3]	= {
				["ChatTypeGroup"]	= "SAY",
				["Text"]			= TEXT( "SC_424976_07" ),
			},
			[4]	= {
				["ChatTypeGroup"]	= "SAY",
				["Text"]			= TEXT( "SC_424976_06" ),
			},
			[5]	= {
				["ChatTypeGroup"]	= "SAY",
				["Text"]			= TEXT( "SC_424976_05" ),
			},
		},
	},
};