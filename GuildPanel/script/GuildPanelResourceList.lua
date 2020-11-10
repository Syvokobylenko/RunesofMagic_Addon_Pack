local GP_RESOURCECOUNT = 20;

local GP_ResourceTable = {};
local GP_CurrentResourceTable = {};

local GP_CurrentResourceUser = "";

-- ## Ressourcen-Liste ##

function GuildPanel_ResourceList_OnValueChanged(slider,arg1)
	-- rebuild list.
	GuildPanel.PopulateResourceList();
end;

function GuildPanel_ResourceList_OnMouseWheel(slider,delta)
	if(delta > 0) then
    	slider:SetValue(slider:GetValue() - 1);
    else
    	slider:SetValue(slider:GetValue() + 1);
    end;

    GuildPanel_CheckResourceScrollPos(slider);

end;

function GuildPanel_CheckResourceScrollPos(slider)

	local fname = slider:GetName();
    local currentval = slider:GetValue();
    local minval,maxval = slider:GetMinMaxValues();

    -- Check for list end
    if (currentval == maxval) then
        getglobal(fname.."ScrollDownButton"):Disable();
    else
        getglobal(fname.."ScrollDownButton"):Enable();
    end

    -- check for list start
    if (currentval == 1) then
        getglobal(fname.."ScrollUpButton"):Disable();
    else
        getglobal(fname.."ScrollUpButton"):Enable();
    end

    if(maxval < GP_RESOURCECOUNT) then
        getglobal(fname.."ScrollUpButton"):Disable();
        getglobal(fname.."ScrollDownButton"):Disable();
    end;

end;

function GuildPanel_ResourceList_OnClick(frame,key)
    if(GP_CurrentResourceUser == "") then
		-- currently in overview, show clicked user
		local fname = frame:GetName();
		local user = getglobal(fname.."_Name"):GetText();
		GuildPanel.SelectResourceUser(user);
		GP_CurrentResourceUser = user;
	else
		GuildPanel.SelectResourceUser();
		GP_CurrentResourceUser = "";
    end;
    
    GuildPanel.PopulateResourceList();
    
end;

function GuildPanel.PopulateResourceList()
    local fname = GuildPanel_ResourceList:GetName();
    local num = 1;

    -- insert data from GP_CurrentResourceTable;

    local offset = GuildPanel_ResourceListSlider:GetValue();

    for i = offset, offset + GP_RESOURCECOUNT - 1 do

    	if(GP_CurrentResourceTable[i] == nil) then break; end;

        local btn = getglobal(fname.."_Resource"..num);
        local btname = btn:GetName();

        getglobal(btname.."_Name"):SetText(GP_CurrentResourceTable[i]["name"]);
        getglobal(btname.."_Resource"):SetText(GP_CurrentResourceTable[i]["count"].." "..GP_CurrentResourceTable[i]["resname"]);
        getglobal(btname.."_Date"):SetText(GP_CurrentResourceTable[i]["date"]);

        btn:Show();
        num = num + 1;
    end;
    
    -- hide other buttons
    if(num ~= GP_RESOURCECOUNT) then
        for j = num, GP_RESOURCECOUNT do
            local btn = getglobal(fname.."_Resource"..j);
            btn:Hide();
        end;
    end;
end;

function GuildPanel.SelectResourceUser(name)
	if(name ~= nil and name ~= "") then
        -- filter by name
        GP_CurrentResourceTable = {};
        local matches = 0;

        for k,v in pairs(GP_ResourceTable) do
            if(v["name"] == name) then
                table.insert(GP_CurrentResourceTable,v);                
                matches = matches + 1;
            end;
        end;
        
        if(matches == 0) then
			GP_CurrentResourceTable[1] = {
					    ["date"]    = "",
                        ["offset"]  = "",
                        ["name"]    = name,
                        ["type"]    = "",
                        ["resname"] = " - keine -",
                        ["count"]   = ""
            }
        end;


        local slidemax = 1;
        if(matches > GP_RESOURCECOUNT) then
        	slidemax = matches - GP_RESOURCECOUNT + 1;
    	end;

        GuildPanel_ResourceListSlider:SetMinMaxValues(1,slidemax);
        GuildPanel_ResourceListSlider:SetValue(1);

    else
    	-- sort by name and date, presenting all
        GP_CurrentResourceTable = GP_ResourceTable;

        -- number of entries: GP_ResListCount

        local slidemax = 1;
        if(GP_ResListCount > GP_RESOURCECOUNT) then
        	slidemax = GP_ResListCount - GP_RESOURCECOUNT + 1;
    	end;

        table.sort(GP_CurrentResourceTable,GuildPanel.helpers.SortResourceAll);

        GuildPanel_ResourceListSlider:SetMinMaxValues(1,slidemax);
        GuildPanel_ResourceListSlider:SetValue(1);

    end;
end;

function GuildPanel.FetchResourceList()

    local day,restype;
    GP_ResListCount = 0;

    for day = 0, 6 do
	    GCB_SetGuildResLogDay(day);

	    local icount = GCB_GetGuildResLogCount(day);

	    for restype = 1, 7 do
            for i = 1, icount do
				local name, count, date = GCB_GetGuildResLog(day,restype,i);
				if(count > 0) then
                    GP_ResListCount = GP_ResListCount + 1;

                    GP_ResourceTable[GP_ResListCount] = {
                    	["date"]    = date,
                        ["offset"]  = day,
                        ["name"]    = name,
                        ["type"]    = restype,
                        ["resname"] = GUILD_RESOURCE_STR[restype+1],
                        ["count"]   = count,
                    };
               end;
			end;
	    end;
    end;
end;

local GP_TimeRemaining = 1;
function GuildPanelResourceList_CheckUpdate(elapsedTime)

    GP_TimeRemaining = GP_TimeRemaining - elapsedTime

    if GP_TimeRemaining > 0 then
        -- cut out early, we're not ready yet
        return
    end

    GP_TimeRemaining = 1; -- reset


    if(GuildPanel.ResourceLoaded) then
    	return
    end;

    if(GuildPanel.ResourcePage >= 7) then
    	GuildPanel.ResourceLoaded = true;
        return;
    end;

    GCB_SetGuildResLogDay(GuildPanel.ResourcePage);
    GuildPanel.ResourcePage = GuildPanel.ResourcePage + 1;

end;
