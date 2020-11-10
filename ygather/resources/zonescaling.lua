yGather.zonescaling = {}

setfenv(1, yGather.zonescaling);

-- minimap-to-zone ratios
-- i.e. (pseudocode) silverspring.dx * yGather_Zones[2][1] = minimap.dx
local data = {
    [1]={858,644,"Howling Mountains"},
    [2]={1256,942,"Silverspring"},
    [3]={1550,1163,"Ravenfell"},
    [4]={1228,921,"Aslan Valley"},
    [5]={1532,1149,"Ystra Highlands"},
    [6]={1830,1373,"Dust Devil Canyon"},
    [7]={1504,1128, "Weeping Coast"},
    [8]={1755,1316, "Savage Lands"},
    [9]={1875,1406, "Aotulia Vulcano"},
    [10]={1923,1442,"Sascilia Steppes"},
    [11]={1600,1200,"Dragonfang Ridge"},
    [12]={803,602,"Elven Island"},
    [13]={2011,1509,"Coast of Opportunity"},
    [14]={1658,1200,"Xaviera"},
    [15]={1956,1467,"Thunderhoof Hills"},
    [16]={1249,937,"Southern Janost Forest"},
    [17]={1136,852,"Northern Janost Forest"},
    [18]={1864,1398,"Limo Desert"},
    [19]={1164,871,"Land of Malevolence"},
    [20]={1261,946,"Redhill Mountains"},
	[21]={1736,1302,"Tergothen Bay"},
	[22]={1395,1040,"Ancient Kingdom of Rorazan"},
	[23]={1139,854,"Chrysalia"},
	[24]={1445,1084,"Merdhin Tundra"},
	[25]={1225,919,"Syrbal Pass"},
	[26]={1494,1121,"Sarlo"},
	[27]={1468,1101,"Wailing Fjord"},
	[28]={1295,971,"Jungle of Hortek"},
	[29]={1681,1261,"Salioca Basin"},
	[30]={1488,1116,"Kashaylan"},
	[31]={906,680,"Yrvandis Hollows"},
	[32]={1507,1130,"Splitwater Coast"},
	[33]={1504,1128,"The Moorlands of Farsitan"},
	[34]={1024,768,"Tasuq"},
	[35]={998,749,"Korris"},
	[36]={920,690,"Enoch"},
	[37]={924,691,"Vortex"},
	[38]={895,671,"Chassizz"},
    [10001]={539,404,"Obsidian Stronghold City"},
};

function GetScaling(zoneId)
	-- Deal with Ystra clone
	 if zoneId == 358 then
		 zoneId = 5;
	 end;
    local zoneScaling = data[zoneId];
    if (nil == zoneScaling) then
        return nil;
    end;
    
    return {x = zoneScaling[1], y = zoneScaling[2]};
end;
