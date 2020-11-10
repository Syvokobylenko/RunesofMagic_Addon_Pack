
local resourceColors = {
    ["LUMBERING"] = "ffe6ccaa",
    ["MINING"] = "ffc1dfee",
    ["HERBLISM"] = "ffc2edc4",
};

function yGatherMenu_OnLoad(this)
    UIDropDownMenu_Initialize( this, yGatherMenu_OnShow, "MENU");
end

local function SortResources(zoneData)
    if (zoneData == nil) then
        return {};
    end;
    
    local resources = {};
    for matId, matData in pairs(zoneData) do
        if ((yGather.matdb.GetResourceSkill(matId) ~= "USER") and (#matData > 0)) then
            table.insert(resources, matId);
        end;
    end;
    table.sort(resources, function(mat1, mat2) return mat1 < mat2; end);
    return resources;
end;

local function AddUserMarkFunction(info)
    local x, y = GetPlayerWorldMapPos();
    yGather.database.AddStackLocation(info.arg1, WorldMapFrame.mapID, x * 1000, y * 1000);
end;

local function CreateAddUserMarkMenu()
    local info = {};
    for _, entry in yGather.matdb.UserIterator() do
        local name = entry[2]; 
        info.text = name;
        info.arg1 = entry[1];
        info.func = AddUserMarkFunction;
        info.owner = DropDownframe;
        UIDropDownMenu_AddButton( info, 2 );
    end;
end;

local function CreateHighlightOnMinimapMenu()
    local info = {};

    info.text = "|c" .. resourceColors["LUMBERING"] .. yGather.translate("common/wood");
    info.hasArrow = 1;
    info.value = 100;
    info.owner = DropDownframe;
    UIDropDownMenu_AddButton( info, 2 );

    info.text = "|c" .. resourceColors["MINING"] .. yGather.translate("common/ore");
    info.hasArrow = 1;
    info.value = 200;
    info.owner = DropDownframe;
    UIDropDownMenu_AddButton( info, 2 );

    info.text = "|c" .. resourceColors["HERBLISM"] .. yGather.translate("common/herbs");
    info.hasArrow = 1;
    info.value = 300;
    info.owner = DropDownframe;
    UIDropDownMenu_AddButton( info, 2 );
end;

local function SetMinimapHighlightFunc(info)
    local matId = info.value;
    local highlighted = yGather.minimapHighlight.GetHighlight(matId);
    yGather.minimapHighlight.SetHighlight(matId, not highlighted);
end;
        
local function CreateHighlightOnMinimapLumberingMenu()
    local info = {};
    local color = "|c" .. resourceColors["LUMBERING"];
    for _, entry in yGather.matdb.LumIterator() do
        info = {
            text = color .. entry[2] .. " (" .. entry[3] .. ")";
            value = entry[1];
            checked = yGather.minimapHighlight.GetHighlight(entry[1]);
            func = SetMinimapHighlightFunc;
            keepShownOnClick = 1;
            owner = DropDownframe;
        };
        UIDropDownMenu_AddButton(info, 3);
    end;
end;

local function CreateHighlightOnMinimapMiningMenu()
    local info = {};
    local color = "|c" .. resourceColors["MINING"];
    for _, entry in yGather.matdb.MinIterator() do
        info = {
            text = color .. entry[2] .. " (" .. entry[3] .. ")";
            value = entry[1];
            checked = yGather.minimapHighlight.GetHighlight(entry[1]);
            func = SetMinimapHighlightFunc;
            keepShownOnClick = 1;
            owner = DropDownframe;
        };
        UIDropDownMenu_AddButton(info, 3);
    end;
end;

local function CreateHighlightOnMinimapHerblismMenu()
    local info = {};
    local color = "|c" .. resourceColors["HERBLISM"];
    for _, entry in yGather.matdb.HerbIterator() do
        info = {
            text = color .. entry[2] .. " (" .. entry[3] .. ")";
            value = entry[1];
            checked = yGather.minimapHighlight.GetHighlight(entry[1]);
            func = SetMinimapHighlightFunc;
            keepShownOnClick = 1;
            owner = DropDownframe;
        };
        UIDropDownMenu_AddButton(info, 3);
    end;
end;

local function ShowAllFunction()
    yGather.filter.ClearFilters();
    yGather.settings.SetValue("worldmap/showResources", true);
end;

function yGatherMenu_OnShow(this)
    local info = {};
	local wmapid = 0 
    if (UIDROPDOWNMENU_MENU_LEVEL == 1) then
        info = {
            text = yGather.translate("worldmap/menu/title");
            isTitle = 1;
            value = 1;
        }
        UIDropDownMenu_AddButton(info, 1);
        
		-- Ystra Event Zone and fix worldmap Ystra
		-- use of wmapid insead of WorldMapFrame.mapID
		if (GetCurrentWorldMapID()~=5) and (WorldMapFrame.mapID == 5) then
			wmapid = 358
			yGather.logger.info("[WorldMapFrame.mapID] changed to zone: " .. wmapid);
		else	
			wmapid = WorldMapFrame.mapID
		end
		--end fix
		
		
        local zoneData = yGather.database.GetZoneData(wmapid)
        local resources = SortResources(zoneData);
        local filterMatFunc = function(info)
            local matId = info.value;
            local filtered = yGather.filter.IsFiltered(matId);
            yGather.filter.SetFilter(not filtered, matId);
        end;
        
        for _, matId in ipairs(resources) do
            local color = "|c" .. resourceColors[yGather.matdb.GetResourceSkill(matId)];
            info = {

                text = color .. yGather.matdb.GetResourceName(matId) .. " (" .. yGather.matdb.GetSkillLevel(matId) .. ")";
                value = matId;
                checked = not yGather.filter.IsFiltered(matId);
                func = filterMatFunc;
                keepShownOnClick = 1;
                owner = DropDownframe;
            };
            UIDropDownMenu_AddButton(info, 1);
        end;

        info = {
            text = "";
            isTitle = 1;
            value    = 1;
        }
        UIDropDownMenu_AddButton(info, 1);
        
        info = {
            text = "|c" .. resourceColors["LUMBERING"] .. yGather.translate("worldmap/menu/hideLumber");
            value = 0;
            checked = yGather.filter.IsActiveLumberingFilter();
            func = function() yGather.filter.SetLumberingFilter(not yGather.filter.IsActiveLumberingFilter()); end;
            owner    = DropDownframe;
        };
        UIDropDownMenu_AddButton(info, 1);
            
        info = {
            text = "|c" .. resourceColors["MINING"] .. yGather.translate("worldmap/menu/hideOre");
            value = 0;
            checked = yGather.filter.IsActiveMiningFilter();
            func = function() yGather.filter.SetMiningFilter(not yGather.filter.IsActiveMiningFilter()); end;
            owner    = DropDownframe;
        };
        UIDropDownMenu_AddButton(info, 1);
            
        info = {
            text = "|c" .. resourceColors["HERBLISM"] .. yGather.translate("worldmap/menu/hideHerbs");
            value = 0;
            checked = yGather.filter.IsActiveHerblismFilter();
            func = function() yGather.filter.SetHerblismFilter(not yGather.filter.IsActiveHerblismFilter()); end;
            owner    = DropDownframe;
        };
        UIDropDownMenu_AddButton(info, 1);

        info = {
            text = yGather.translate("worldmap/menu/hideAboveLevel");
            value = 0;
            checked = yGather.filter.IsActiveAboveLevelFilter();
            func = function() yGather.filter.SetAboveLevelFilter(not yGather.filter.IsActiveAboveLevelFilter()); end;
            tooltipText = yGather.translate("worldmap/menu/hideAboveLevel/tooltip");
            owner    = DropDownframe;
        };
        UIDropDownMenu_AddButton(info, 1);

        info = {
            text = yGather.translate("worldmap/menu/showAll");
            func = ShowAllFunction;
            owner = DropDownframe;
        };
        UIDropDownMenu_AddButton( info, 1 );

        info = {
            text = "";
            isTitle = 1;
            value    = 1;
        }
        UIDropDownMenu_AddButton(info, 1);
        
        if (yGather.database.GetZoneData(wmapid) ~= nil) then
            info = {
                text = yGather.translate("worldmap/menu/addUserMark");
                hasArrow = 1;
                value = 100;
                owner = DropDownframe;
            };
            UIDropDownMenu_AddButton( info, 1 );
        end;

        info = {
            text = yGather.translate("worldmap/menu/highlightOnMinimap");
            hasArrow = 1;
            value = 200;
            owner = DropDownframe;
        };
        UIDropDownMenu_AddButton( info, 1 );

        info = {
                text = "";
                isTitle = 1;
                value    = 1;
        }
        UIDropDownMenu_AddButton(info, 1);
        
        info = {
            text = yGather.translate("worldmap/menu/settings") .. "...";
            func = function() yGather.config:ShowConfigDialog(); end;
            owner = DropDownframe;
        };
        UIDropDownMenu_AddButton( info, 1 );
    elseif (UIDROPDOWNMENU_MENU_LEVEL == 2) then
        if (UIDROPDOWNMENU_MENU_VALUE == 100) then
            CreateAddUserMarkMenu();
        elseif (UIDROPDOWNMENU_MENU_VALUE == 200) then
            CreateHighlightOnMinimapMenu();
        end
    elseif (UIDROPDOWNMENU_MENU_LEVEL == 3) then
        if (UIDROPDOWNMENU_MENU_VALUE == 100) then
            CreateHighlightOnMinimapLumberingMenu();
        elseif (UIDROPDOWNMENU_MENU_VALUE == 200) then
            CreateHighlightOnMinimapMiningMenu();
        elseif (UIDROPDOWNMENU_MENU_VALUE == 300) then
            CreateHighlightOnMinimapHerblismMenu();
        end
    end;
end;
