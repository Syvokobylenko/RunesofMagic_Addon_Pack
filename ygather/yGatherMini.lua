function yGatherIcon_OnClick(this, button, ignoreShift)
    if (button=="RBUTTON") then
        ToggleDropDownMenu(yGatherIconMenu);
    end
end

function yGatherIconMenu_OnLoad(this)
    UIDropDownMenu_Initialize( this, yGatherIconMenu_OnShow, "MENU");
end

local function RemoveMarker(info)
    local stackInfo = info.arg1;
    yGather.database.RemoveEntry(stackInfo[1], stackInfo[2], stackInfo[3] * 1000, stackInfo[4] * 1000);
end;

local function EditDescription(info)
    yGatherIconTextEdit.stackInfo = info.arg1;
    ShowUIPanel(yGatherIconTextEdit);
end;

function yGatherIconMenu_OnShow(this)
    local icon = this.icon;
    if (icon ~= nil) then
        local info = {};
        if( UIDROPDOWNMENU_MENU_LEVEL == 1 ) then
            yGatherIconMenu:ClearAllAnchors();
            yGatherIconMenu:SetAnchor("TOPLEFT", "TOPRIGHT", icon, 0, -40);

            info = {};
            info.text = yGather.matdb.GetResourceName(icon.yGMatId);
            info.isTitle = 1;
            info.value    = 1;
            info.notCheckable = 1;
            UIDropDownMenu_AddButton( info, 1 );
            
            info = {};
            info.text     = yGather.translate("iconContext/deleteMarker");
            info.arg1 = {icon.yGZoneId, icon.yGMatId, icon.yGWorldMapX, icon.yGWorldMapY};
            info.func     = RemoveMarker;
            info.owner    = DropDownframe;
            info.notCheckable = 1;
            UIDropDownMenu_AddButton( info, 1 );

            info = {};
            info.text     = yGather.translate("iconContext/editDescription");
            info.arg1 = {icon.yGZoneId, icon.yGMatId, icon.yGWorldMapX, icon.yGWorldMapY, icon.yGName};
            info.func     = EditDescription;
            info.owner    = DropDownframe;
            info.notCheckable = 1;
            UIDropDownMenu_AddButton( info, 1 );
        end
    end --nil icon    
end
