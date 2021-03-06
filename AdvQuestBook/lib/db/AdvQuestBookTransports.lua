--[[ ä

	Name: Advanced Questbook
	By: Crypton

]]
if (AQB_SNOOP_NAMES == nil) then
	AQB_SNOOP_NAMES = {
		[1] = TEXT("ZONE_ROGSHIRE"),
		[2] = AQB_MAP_NAMES[10000],
		[3] = TEXT("ZONE_DUST HOLD"),
		[4] = TEXT("ZONE_ARGENFALL"),
		[5] = TEXT("ZONE_HAROLFE TRADING POST"),
		[6] = TEXT("ZONE_AYEN CARAVAN"),
		[7] = TEXT("ZONE_LAGO"),
		[8] = AQB_MAP_NAMES[10001],
		[9] = TEXT("ZONE_BOULDERWIND"),
		[10] = TEXT("ZONE_STONES FURLOUGH"),
		[11] = TEXT("ZONE_THE GREEN TOWER"),
		[12] = TEXT("ZONE_TITANS HILL"),
		[13] = TEXT("ZONE_DAELANIS"),
		[14] = TEXT("ZONE_KAIYA_VILLAGE"),
		[15] = TEXT("ZONE_LIANKA_VILLAGE"),
		[16] = TEXT("ZONE_REIFORT POINT"),
		[17] = TEXT("ZONE_HARFEN_CAMP"),
		[18] = TEXT("ZONE_LANZERD_HORDE"),
		[19] = TEXT("ZONE_WILDERNESS_RESEARCH_CAMP"),
		[20] = TEXT("ZONE_TEMPORARY_FANGT_CAMP"),
		[21] = TEXT("ZONE_RUINS_TESTING_CAMP"),
		[22] = TEXT("ZONE_JINNERS_CAMP"),
		[23] = TEXT("ZONE_FRONT_LINES_CAMP"),
		[24] = TEXT("ZONE_LYMUN_KINGDOM"),
		[25] = TEXT("ZONE_CAMPBELL_TOWNSHIP"),
		[26] = TEXT("ZONE_FIREBOOT_DWARF_FORTRESS"),
	};
end

if (AQB_AIRSHIP_NAMES == nil) then
	AQB_AIRSHIP_NAMES = {
		[1] = AQB_SNOOP_NAMES[10].."\n\n"..TEXT("Sys112797_name").."\n"..TEXT("Sys112797_titlename"),
		[2] = AQB_SNOOP_NAMES[2].."\n\n"..TEXT("Sys113398_name"),
	};
end
