if (yGather.worldmap == nil) then
    yGather.worldmap = {};
end

--[[ moves global icon references into more local context for faster access]]
function yGather.worldmap:InitializeIcons()
    local icons = {};
    self.icons = icons;
    for i = 0, 5 do
        for j = 0, 9 do
            for k = 0, 9 do
                local index = 100 * i + 10 * j + k
                icons[index + 1] = {
                    icon = getglobal("yGather_WorldmapResourceIcon" .. i .. j .. k),
                    texture = getglobal("yGather_WorldmapResourceIcon" .. i .. j .. k .. "_Texture"),
                }
                -- remove icon and textures from global table - not needed (there) anymore
                _G["yGather_WorldmapResourceIcon" .. i .. j .. k] = nil;
                _G["yGather_WorldmapResourceIcon" .. i .. j .. k .. "_Texture"] = nil;
            end
        end
    end
end

function yGather.worldmap:HideAllIcons()
    for _, icon in pairs(self.icons) do
        icon.icon:Hide();
    end
end

function yGather.worldmap:UpdateIcons()
    local zoneId = WorldMapFrame.mapID;
    
    self.statistics = nil;
    
    if (zoneId == nil) then
        yGather.logger.debug("[worldmap] zoneId = nil");
        self:HideAllIcons();
        return;
    end
	-- fix worldmap Ystra
	if (GetCurrentWorldMapID()~=5) and (zoneId==5) then 	
		zoneId = 358;
		yGather.logger.info("[worldmap] changed to zone: " .. zoneId);
    end
	--end fix
    
    if (not yGather.settings.GetValue("worldmap/showResources")) then
        yGather.logger.debug("[worldmap] showing resources disabled");
        self:HideAllIcons();
        return;
    end

    local zoneData = yGather.database.GetZoneData(zoneId);
    if (zoneData == nil) then
        yGather.logger.debug("[worldmap] no data in zone: " .. zoneId);
        self:HideAllIcons();
        return;
    end

    yGather.logger.info("[worldmap] showing resources in zone: " .. zoneId);
    
    self.updatedIcons = {};
    self.locationCount = 0;
    self.stacksFiltered = 0;
    local iconIndex = 1;
    for matId, resources in pairs(zoneData) do
        if (not yGather.filter.IsFiltered(matId)) then
            iconIndex = self:ShowMaterialIcons(matId, resources, iconIndex);
        else
            self.stacksFiltered = self.stacksFiltered + #resources;
        end
        if (iconIndex > #self.icons) then
            break;
        end
    end

    self.statistics = {
        stacksShown = self.locationCount,
        stacksFiltered = self.stacksFiltered,
        iconsShown = iconIndex - 1,
    }

    for i = iconIndex, #self.icons do
        self.icons[i].icon:Hide();
    end
end

function yGather.worldmap:ShowMaterialIcons(matId, resources, iconIndex)
    yGather.logger.debug("[worldmap] showing resources with id " .. matId);
    for i, entry in ipairs(resources) do
        local x = entry[1];
        local y = entry[2];
        
        self.locationCount = self.locationCount + 1;
        
        local existingIcon = self:GetUpdatedIconAt(math.floor(x + 0.5), math.floor(y + 0.5), matId);
        
        if (existingIcon == nil) then
            self:ShowMaterialIconAt(x, y, matId, self.icons[iconIndex]);
            iconIndex = iconIndex + 1;
            if (iconIndex > #self.icons) then
                break;
            end
        else
            existingIcon.yGName = existingIcon.yGName .. ", " .. yGather.matdb.GetResourceName(matId);
            local skillLevel = yGather.matdb.GetSkillLevel(matId);
            if ((skillLevel ~= nil) and (skillLevel > 0)) then
                existingIcon.yGName = existingIcon.yGName .. " (" .. skillLevel .. ")";
            end
            yGather.logger.debug("[worldmap] added resource to exising icon: " .. existingIcon.yGName);
        end;
    end
    return iconIndex;
end

function yGather.worldmap:GetUpdatedIconAt(x, y, matId)
    local skill = yGather.matdb.GetResourceSkill(matId);
    local skillIcons = self.updatedIcons[skill];
    if (skillIcons == nil) then
        return nil;
    end
    
    local skillXIcons = skillIcons[x];
    if (skillXIcons == nil) then
        return nil;
    end
    
    return skillXIcons[y];
end

function yGather.worldmap:AddUpdatedIcon(skill, x, y, icon)
    
    if (self.updatedIcons[skill] == nil) then
        self.updatedIcons[skill] = {};
    end
    local skillIcons = self.updatedIcons[skill];
    
    if (skillIcons[x] == nil) then
        skillIcons[x] = {};
    end
    local skillXIcons = skillIcons[x];
    
    skillXIcons[y] = icon;
end

function yGather.worldmap:ShowMaterialIconAt(x, y, matId, iconData)
    local skill = yGather.matdb.GetResourceSkill(matId);
    local icon = iconData.icon;
    local texture = iconData.texture;
    local frameWidth = yGather_WorldmapViewFrame:GetWidth();
    local frameHeight = yGather_WorldmapViewFrame:GetHeight();
    local iconSize = yGather.settings.GetValue("worldmap/iconSize");

    yGather.logger.debug("[worldmap] showing new icon: " .. matId .. " (" .. x .. ", " .. y .. ")");
    
    local name = yGather.matdb.GetResourceName(matId);
    icon.yGName = name;
    icon.yGMatId = matId;
    icon.yGWorldMapX = x / 1000;
    icon.yGWorldMapY = y / 1000;
    icon.yGZoneId = WorldMapFrame.mapID;
    local skillLevel = yGather.matdb.GetSkillLevel(matId);
    if ((skillLevel ~= nil) and (skillLevel > 0)) then
        icon.yGName = icon.yGName .. " (" .. skillLevel .. ")";
    end
    self:ConfigureTexture(texture, matId, skill);
    icon:ClearAllAnchors();
    icon:SetAnchor("CENTER", "TOPLEFT", "yGather_WorldmapViewFrame", x / 1000 * frameWidth, y / 1000 * frameHeight);
    icon:SetWidth(iconSize);
    icon:SetHeight(iconSize);
    icon:Show();
    yGather.logger.debug("showing on worldmap: " .. name .. " at (" .. x .. "," .. y .. ")");
    self:AddUpdatedIcon(skill, math.floor(x + 0.5), math.floor(y + 0.5), icon);
end

function yGather.worldmap:ConfigureTexture(texture, matid, skill)
    local setName = yGather.settings.GetValue("worldmap/iconSet");
    local transparency = yGather.settings.GetValue("worldmap/iconTransparency");
    local color = self:GetColorForSkill(skill);
    yGather.iconsets.SetupTexture(texture, setName, matid, skill, color, transparency);
end

function yGather.worldmap:GetColorForSkill(skill)
    if (skill == "LUMBERING") then 
        return yGather.settings.GetValue("worldmap/iconWoodColor");
    elseif (skill == "MINING") then
        return yGather.settings.GetValue("worldmap/iconOreColor");
    elseif (skill == "HERBLISM") then
        return yGather.settings.GetValue("worldmap/iconHerbsColor");
    else
        return nil;
    end
end
