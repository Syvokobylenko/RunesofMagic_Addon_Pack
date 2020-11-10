--[[ ä

	Name: Advanced Questbook
	By: Crypton

]]
if (AdvQuestBook_Snoop == nil) then
	AdvQuestBook_Snoop = {
		[1] = {
			["mapid"] = 1,
			["name"] = AQB_SNOOP_NAMES[1],
			["x"] = 0.46998280286789,
			["y"] = 0.37397345900536,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[2].."|r",
			["level"] = 5;
		},
		[2] = {
			["mapid"] = 2,
			["name"] = AQB_SNOOP_NAMES[2],
			["x"] = 0.4834298491478,
			["y"] = 0.78336870670319,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[8].."\n"..AQB_SNOOP_NAMES[1].."\n"..AQB_SNOOP_NAMES[4].."\n"..AQB_SNOOP_NAMES[3].."\n"..AQB_SNOOP_NAMES[10].."\n"..AQB_SNOOP_NAMES[16].."\n"..AQB_SNOOP_NAMES[17].."|r",
			["level"] = 9;
		},
		[3] = {
			["mapid"] = 3,
			["name"] = AQB_SNOOP_NAMES[3],
			["x"] = 0.45890966057777,
			["y"] = 0.53898543119431,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[2].."\n"..AQB_SNOOP_NAMES[9].."|r",
			["level"] = 45;
		},
		[4] = {
			["mapid"] = 4,
			["name"] = AQB_SNOOP_NAMES[4],
			["x"] = 0.52934771776199,
			["y"] = 0.6696320772171,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[2].."\n"..AQB_SNOOP_NAMES[5].."|r",
			["level"] = 27;
		},
		[5] = {
			["mapid"] = 5,
			["name"] = AQB_SNOOP_NAMES[5],
			["x"] = 0.46344605088234,
			["y"] = 0.20441222190857,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[4].."\n"..AQB_SNOOP_NAMES[8].."\n"..AQB_SNOOP_NAMES[7].."|r",
			["level"] = 30;
		},
		[6] = {
			["mapid"] = 10,
			["name"] = AQB_SNOOP_NAMES[6],
			["x"] = 0.25387254357338,
			["y"] = 0.35077610611916,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[8].."\n"..AQB_SNOOP_NAMES[7].."\n"..AQB_SNOOP_NAMES[16].."|r",
			["level"] = 12;
		},
		[7] = {
			["mapid"] = 11,
			["name"] = AQB_SNOOP_NAMES[7],
			["x"] = 0.47316959500313,
			["y"] = 0.60910665988922,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[5].."\n"..AQB_SNOOP_NAMES[6].."|r",
			["level"] = 20;
		},
		[8] = {
			["mapid"] = 10001,
			["name"] = AQB_SNOOP_NAMES[8],
			["x"] = 0.75358253717422,
			["y"] = 0.1908452808857,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[2].."\n"..AQB_SNOOP_NAMES[5].."\n"..AQB_SNOOP_NAMES[6].."\n"..AQB_SNOOP_NAMES[16].."|r",
			["level"] = 40;
		},
		[9] = {
			["mapid"] = 7,
			["name"] = AQB_SNOOP_NAMES[9],
			["x"] = 0.5593449473381,
			["y"] = 0.4484880566597,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[3].."\n"..AQB_SNOOP_NAMES[11].."|r",
			["level"] = 50;
		},
		[10] = {
			["mapid"] = 12,
			["name"] = AQB_SNOOP_NAMES[10],
			["x"] = 0.29714351892471,
			["y"] = 0.59347915649414,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[2].."|r",
			["level"] = 1,
		},
		[11] = {
			["mapid"] = 8,
			["name"] = AQB_SNOOP_NAMES[11],
			["x"] = 0.7342084646225,
			["y"] = 0.52280008792877,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[9].."\n"..AQB_SNOOP_NAMES[12].."|r",
			["level"] = 53,
		},
		[12] = {
			["mapid"] = 9,
			["name"] = AQB_SNOOP_NAMES[12],
			["x"] = 0.61615657806396,
			["y"] = 0.70311480760574,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[11].."|r",
			["level"] = 55,
		},
		[13] = {
			["mapid"] = 15,
			["name"] = AQB_SNOOP_NAMES[13],
			["x"] = 0.54752147197723,
			["y"] = 0.5829798579216,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[14].."\nCandara|r",
			["level"] = 55,
		},
		[14] = {
			["mapid"] = 16,
			["name"] = AQB_SNOOP_NAMES[14],
			["x"] = 0.3467920422554,
			["y"] = 0.54170697927475,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[15].."\n"..AQB_SNOOP_NAMES[13].."|r",
			["level"] = 55,
		},
		[15] = {
			["mapid"] = 17,
			["name"] = AQB_SNOOP_NAMES[15],
			["x"] = 0.5162108540535,
			["y"] = 0.53891122341156,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[14].."\n"..AQB_SNOOP_NAMES[24].."|r",
			["level"] = 59,
		},
		[16] = {
			["mapid"] = 6,
			["name"] = AQB_SNOOP_NAMES[8],
			["x"] = 0.35262790925312,
			["y"] = 0.64380785900031,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[2].."\n"..AQB_SNOOP_NAMES[5].."\n"..AQB_SNOOP_NAMES[6].."\n"..AQB_SNOOP_NAMES[16].."|r",
			["level"] = 40;
		},
		[17] = {
			["mapid"] = 10,
			["name"] = AQB_SNOOP_NAMES[16],
			["x"] = 0.57427155971527,
			["y"] = 0.36702969670296,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[2].."\n"..AQB_SNOOP_NAMES[6].."\n"..AQB_SNOOP_NAMES[8].."|r",
			["level"] = 1;
		},
		[18] = {
			["mapid"] = 13,
			["name"]  = AQB_SNOOP_NAMES[17],
			["x"] = 0.3782399892807,
			["y"] = 0.62733268737793,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[2].."\n"..AQB_SNOOP_NAMES[18].."|r",
			["level"] = 10;		
		},
		[19] = {
			["mapid"] = 13,
			["name"]  = AQB_SNOOP_NAMES[18],
			["x"] = 0.59053289890289,
			["y"] = 0.50407189130783,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[17].."\n"..AQB_SNOOP_NAMES[19].."|r",
			["level"] = 27;		
		},
		[20] = {
			["mapid"] = 13,
			["name"]  = AQB_SNOOP_NAMES[19],
			["x"] = 0.34307935833931,
			["y"] = 0.40166586637497,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[18].."\n"..AQB_SNOOP_NAMES[20].."|r",
			["level"] = 34;		
		},
		[21] = {
			["mapid"] = 13,
			["name"]  = AQB_SNOOP_NAMES[20],
			["x"] = 0.58859401941299,
			["y"] = 0.23157142102718,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[19].."\n"..AQB_SNOOP_NAMES[21].."|r",
			["level"] = 40;		
		},
		[22] = {
			["mapid"] = 14,
			["name"]  = AQB_SNOOP_NAMES[21],
			["x"] = 0.34108936786652,
			["y"] = 0.10256910324097,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[20].."\n"..AQB_SNOOP_NAMES[22].."\n"..AQB_SNOOP_NAMES[2].."|r",
			["level"] = 44;		
		},
		[23] = {
			["mapid"] = 14,
			["name"]  = AQB_SNOOP_NAMES[22],
			["x"] = 0.81886148452759,
			["y"] = 0.71528571844101,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[23].."\n"..AQB_SNOOP_NAMES[21].."|r",
			["level"] = 48;		
		},
		[24] = {
			["mapid"] = 14,
			["name"]  = AQB_SNOOP_NAMES[23],
			["x"] = 0.57386833429337,
			["y"] = 0.4827686548233,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[22].."|r",
			["level"] = 50;		
		},
		[25] = {
			["mapid"] = 18,
			["name"]  = AQB_SNOOP_NAMES[24],
			["x"] = 0.30069226026535,
			["y"] = 0.53257608413696,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[15].."\n"..AQB_SNOOP_NAMES[25].."|r",
			["level"] = 60;		
		},
		[26] = {
			["mapid"] = 19,
			["name"]  = AQB_SNOOP_NAMES[25],
			["x"] = 0.63140106201172,
			["y"] = 0.39663609862328,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[24].."\n"..AQB_SNOOP_NAMES[26].."|r",
			["level"] = 62;
		},
		[27] = {
			["mapid"] = 20,
			["name"]  = AQB_SNOOP_NAMES[26],
			["x"] = 0.2960376739502,
			["y"] = 0.40536606311798,
			["links"] = "|cFFffffff"..AQB_SNOOP_NAMES[25].."|r",
			["level"] = 65;
		},
	};
end
