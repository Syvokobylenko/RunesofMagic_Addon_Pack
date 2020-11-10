--[[ 1. addon variables ]]

-- namespaces
GuildPanel = {};
GuildPanel.Permissions = {};
GuildPanel.MemberTable = {};
GuildPanel.currentMemberTable = {};
GuildPanel.RankList = {};
GuildPanel.helpers = {};

-- addon detail
GuildPanel.AddonVersion = "0.34";
GuildPanel.AddonAuthor = "Amiya";
GuildPanel.AddonName = "GuildPanel";

-- variables
GuildPanel.SelectedMember = {};
GuildPanel.ownRank = 0;
GuildPanel.onlineCount = 0;
GuildPanel.enabled = false;
GuildPanel.initDone = false;
GuildPanel.ResourceLoaded = false;
GuildPanel.ResourcePage = 0;
GuildPanel.currentCount = 0;
GuildPanel.updatePending = 0;
GuildPanel.nextUpdate = 30; -- initial value will catch more, later time is set to 15 sec.
GuildPanel.selectionLock = false;

GuildPanel.Settings = {
    sortOrder = 2,
    sortOnlineTop = 0,
    lastRow = "rank",
    showColors = 1,
    showColorsOffline = 1,
    colorType = "class",
    showOnline = 1,
    showOffline = 1,
    showMIA = 1,
    swapDruidWarden = 1,
    swapDruidWardenRaid = 0,
    showOffline = 1
};

-- number of entries in member list
GuildPanel_Length = 16;

numGuildMembers = GetNumGuildMembers();

local guildName, leaderName, _, alreadyCreate, maxMemberCount, guildScore, guildNotice, _,
                _, _, _, guildLevel, _, _ = GetGuildInfo();

GuildPanel.Permissions["alreadyCreate"] = alreadyCreate;


--[[ language var init ]]
	    local gamelang = GetLanguage():upper();
	    local language = "";

	    if(gamelang == "DE") then
	        language = "de";
	    elseif(gamelang == "ENUS" or gamelang == "ENEU") then
	        language = "en";
	    elseif(gamelang == "ES") then
	        language = "es";
	    elseif(gamelang == "FR") then
	        language = "fr";
	    elseif(gamelang == "RU") then
			language = "ru";
		elseif(gamelang == "KR") then
			language = "kr";
		elseif(gamelang == "PL") then
			language = "pl";
		elseif(gamelang == "TW") then
			language = "tw";
	    else
	        -- fallback
	        language = "en";
	    end;

	    dofile("Interface/AddOns/GuildPanel/locale/language."..language..".lua");

--[[ slash commands ]]

    SLASH_GuildPanel1 = "/gp";
    SLASH_GuildPanel2 = "/guildpanel";

SlashCmdList["GuildPanel"] = function(editBox, msg)
    if(msg == "toggle") then
         if(GuildPanel.enabled) then
             GuildPanel.UnHook();
             GuildPanel.SendMsg("|cff00ff00"..GuildPanel.locale["GP_Unloaded"]);
         else
             GuildPanel.Hook();
             GuildPanel.SendMsg("|cff00ff00"..GuildPanel.locale["GP_Loaded"]);
         end;
    else
        GuildPanelConfigFrame:Show();
    end;
end;


--[[ 2. event handlers ]]

--[[ addon ]]
function GuildPanel_OnLoad(frame)
		-- config and init
        frame:RegisterEvent("VARIABLES_LOADED");
        frame:RegisterEvent("LOADING_END");
        frame:RegisterEvent("SAVE_VARIABLES");
        
        -- list updates
        --frame:RegisterEvent("UPDATE_GUILD_INFO");
        --frame:RegisterEvent("UPDATE_GUILD_MEMBER"); 
		--frame:RegisterEvent("UPDATE_GUILD_MEMBER_INFO");
		
		frame:RegisterEvent("GUILD_INVITE_REQUEST"); 
		frame:RegisterEvent("GUILD_KICK");

		-- war frames, not registered here, they have their own frame
		-- frame:RegisterEvent("GUILDHOUSEWAR_STATE_CHANGE");
		-- frame:RegisterEvent("GUILDHOUSEWAR_INFOS_UPDATE");

        
        -- leader change
		frame:RegisterEvent("GUILD_ASK_LEADERCHANGE");
		frame:RegisterEvent("GUILD_ASK_LEADERCHANGE_RESULT");


        SaveVariables("GuildPanel_SavedSettings");
end;

--[[ load addon ]]--

function GuildPanel.Initialize()

    if(GuildPanel.InitDone) then return end;

    -- check for guild
    if(numGuildMembers < 1) then
        -- we're inactive
        GuildPanel.active = false;
        GuildPanel.SendMsg("|cff00ff00"..GuildPanel.locale["GP_LoadedInactive"].." (v"..GuildPanel.AddonVersion..")");
    else
        -- hook guild frame
        GuildPanel.Hook();

        GuildPanel.active = true;
        if not AddonManager then
			-- show message only without addon manager
			GuildPanel.SendMsg("|cff00ff00"..GuildPanel.locale["GP_Loaded"].." (v"..GuildPanel.AddonVersion..")");
		end;
    end;

    GuildPanel.InitDone = true;

end;

-- create hooks
function GuildPanel.Hook()

    --[[ hook UI display function for guild panel ]]
    GuildPanel.ToggleUIFrame = ToggleUIFrame;
    GuildPanel.GF_SortName = GuildFrame_sortOpName;

    function ToggleUIFrame(frame)
        if(frame == GuildFrame) then frame = GuildPanelFrame; end;
        GuildPanel.ToggleUIFrame(frame);
    end;
    
    -- sort: 1) is match, then: 2) alphabetical
    function GuildFrame_sortOpName(m1,m2)
		-- wtf?
		if(m1 == nil or m2 == nil) then return false end;
    
		if(GuildPanel.SelectedMember["name"] == m1.name) then return true end;
		return GuildPanel.GF_SortName(m1,m2);
    end;
    
   

    -- initialize original game frames
    local success,errmsg = pcall(GuildPanel.InitGameFrames);
    if not success then 
		GuildPanel.SendMsg("|cffbbbbbbGuildPanel - FrameInit: "..errmsg); -- should never happen
    end;    
    

    GuildPanel.enabled = true;
    GuildPanel.InitList();

end;

function GuildPanel.InitGameFrames()
    -- initialize original game frames
	GuildFrame.class.sort = 1;
	GuildFrame.class.SortT = 0;

    GuildFrame.class:UpDate();
    GuildFrame.class.TotalMember = numGuildMembers; -- workaround, this is otherwise not available here
    
    GuildLeaderFrame:SetParent(UIParent);
    GuildLeaderFrame.class:LoadDate();

    GuildBoardFrame:SetParent(UIParent);
    GuildBoardFrame_OnShow(GuildBoardFrame);

    GuildWarFrame:SetParent(UIParent);
    GuildOutdoorsWarFrame_OnShow(GuildOutdoorsWarFrame);    
    
	GuildFrame:UnregisterEvent("UPDATE_GUILD_MEMBER");	
	GuildFrame:UnregisterEvent("UPDATE_GUILD_MEMBER_INFO");	
	GuildFrame:UnregisterEvent("GUILD_INVITE_REQUEST");	
	GuildFrame:UnregisterEvent("GUILD_KICK");	
	GuildFrame:UnregisterEvent( "UPDATE_GUILD_INFO" );
	
	GuildFrame:UnregisterEvent("GUILDINVITE_SELF");	
	GuildFrame:UnregisterEvent("ZONE_CHANGED");
    GuildFrame:UnregisterEvent("GUILD_ASK_LEADERCHANGE");
    GuildFrame:UnregisterEvent("GUILD_ASK_LEADERCHANGE_RESULT");
	GuildFrame:UnregisterEvent("GUILDHOUSEWAR_STATE_CHANGE");
	GuildFrame:UnregisterEvent("GUILDHOUSEWAR_INFOS_UPDATE");    
    
    
end;

--[[ unload addon ]]--
function GuildPanel.UnHook()
    -- return game frames to their original state
    GuildLeaderFrame:SetParent(GuildFrame);
    GuildBoardFrame:SetParent(GuildFrame);
    GuildWarFrame:SetParent(GuildFrame);

    -- return default frame hook
    ToggleUIFrame = GuildPanel.ToggleUIFrame;

    GuildPanel.enabled = false;

end;

function GuildPanel.CheckPendingUpdates(elapsedTime)
	if(GuildPanel.updatePending == 0) then return end;
	
	GuildPanel.nextUpdate = GuildPanel.nextUpdate - elapsedTime;
	
	if(GuildPanel.nextUpdate > 0) then
		return
	end;
	
	GuildPanel.updatePending = 0;
	GuildPanel.nextUpdate = 15;
	
	GuildPanel_OnShow(GuildPanelFrame);
end;


--[[ event handler ]]
function GuildPanel_OnEvent(frame,event)

    if(event == "VARIABLES_LOADED") then
        if(GuildPanel_SavedSettings) then
           for k,v in pairs(GuildPanel.Settings) do
               if(GuildPanel_SavedSettings[k] ~= nil) then
                   GuildPanel.Settings[k] = GuildPanel_SavedSettings[k];
               end;
           end;
        end;

        -- register with addon manager

            if AddonManager then
				local addon =
					{
					name = "|cffE6FF05"..GuildPanel.AddonName.."|r",
					description = GuildPanel.locale.GP_Description,
					category = "Interface",
					version = "|cffE6FF05 "..GuildPanel.AddonVersion.."|r",
					author = GuildPanel.AddonAuthor,
					icon = "Interface/Addons/GuildPanel/resources/icon.tga",
					configFrame = GuildPanelConfigFrame,
					slashCommands = SLASH_GuildPanel2,
					}
				if AddonManager.RegisterAddonTable then
					AddonManager.RegisterAddonTable(addon)
				else
					AddonManager.RegisterAddon(addon.name, addon.description, addon.icon, addon.category, addon.configFrame, addon.slashCommands, addon.miniButton, addon.onClickScript)
				end
			end
			
			g_ClassColors["WARDEN_ORIG"] = g_ClassColors["WARDEN"];
			g_ClassColors["DRUID_ORIG"] = g_ClassColors["DRUID"];
			
			-- trigger our druid/warden switch for the raidframe
			if(GuildPanel.Settings["swapDruidWardenRaid"] == 1) then
				g_ClassColors["WARDEN"] = g_ClassColors["DRUID_ORIG"];
				g_ClassColors["DRUID"] = g_ClassColors["WARDEN_ORIG"];
			end;

	elseif(event == "UPDATE_GUILD_INFO" or event == "GUILD_INVITE_REQUEST" or event == "GUILD_KICK") then
		if GuildPanel.active then
        	GuildPanel.InitList();
		end;	
		
		
	-- warning: this will fire a lot on game starts
    elseif(event == "UPDATE_GUILD_MEMBER" or event == "UPDATE_GUILD_MEMBER_INFO") then
		if GuildPanel.active then
        	GuildPanel.updatePending = GuildPanel.updatePending + 1;
		end;
		
	elseif(event == "GUILD_ASK_LEADERCHANGE") then
		StaticPopup_Show("GUILD_ASK_LEADERCHANGE",arg1);

	elseif(event == "GUILD_ASK_LEADERCHANGE_RESULT") then
		StaticPopup_Show("GUILD_ASK_LEADERCHANGE_RESULT",arg1);
	
    elseif(event == "SAVE_VARIABLES") then
        GuildPanel_SavedSettings = GuildPanel.Settings;

    elseif(event == "LOADING_END") then
        GuildPanel.Initialize();
    end;
end;

--[[ show main frame ]]
function GuildPanel_OnShow(frame)
    
    numGuildMembers = GetNumGuildMembers();
	guildName, leaderName, _, _, maxMemberCount, guildScore, guildNotice, _, _, _, _, guildLevel = GetGuildInfo();

    GuildPanel_MemberListSlider:SetValueStepMode("INT");
    GuildPanel_MemberListSlider:SetMinValue(1);
    GuildPanel_MemberListSlider:SetMaxValue(1);
    GuildPanel_MemberListSlider:SetValue(1);

    -- init addon lists
    GuildPanel.InitList();
    GuildPanel.InitRanks();
    GuildPanel.InitPermissions();
    GuildPanel_Sort(GuildPanel.Settings["sortOrder"]);

    UIDropDownMenu_Initialize(GuildPanel_Dropdown, GuildPanel_Dropdown_Show);
    UIDropDownMenu_SetSelectedID(GuildPanel_Dropdown, GuildPanel.Settings["sortOrder"]);

    GuildPanelFrame_Title:SetText(string.format(GuildPanel.locale["MainTitleText"],guildName,GuildPanel.onlineCount,numGuildMembers,maxMemberCount,guildLevel,leaderName));
    GuildPanel_MemberListTitle:SetText(GuildPanel.locale["MemberList"]);
    GuildPanel_GuildNotice:SetText(guildNotice);

    GuildPanelFrame_ButtonToMembers:SetText(GuildPanel.locale["MemberList"]);
	GP_Button_ToGPConfig:SetText(GuildPanel.locale["Config_Name"])

    GuildPanel_Dropdown_Title:SetText(GuildPanel.locale["SortTitle"]);

	GuildPanelConfig_ShowOffline_Text:SetText(GuildPanel.locale["OfflineDesc"]);
	if(GuildPanel.Settings["showOffline"] == 1) then
		GuildPanelConfig_ShowOffline:SetChecked(true);
	else
		GuildPanelConfig_ShowOffline:SetChecked(false);
	end;



    -- disable scroll buttons first
    getglobal("GuildPanel_MemberListSlider".."ScrollUpButton"):Disable();
    getglobal("GuildPanel_MemberListSlider".."ScrollDownButton"):Disable();

    -- create list entry
    GuildPanel.PopulateList();
    GuildPanel.CheckScrollPosition("GuildPanel_MemberListSlider");

    -- hide buttons without permissions
    if(not GuildPanel.Permissions["leader"]) then
        GP_Button_Leader:Hide();
    else
        GP_Button_Leader:Show();
    end;

    if(not GuildPanel.Permissions["invite"]) then
        GP_Button_Add:Hide();
    else
        GP_Button_Add:Show();
    end;
end;

--[[ member selected ]]
function GuildPanel_MemberList_OnClick(button,key)
    
	-- cancel when GuildFrame is in locked mode (while showing some StaticPopups)
	if(GuildPanel.selectionLock == true) then return end;
	
	GuildPanel.SelectedMember = GuildPanel.currentMemberTable[button.id];
	SetGuildRosterSelection(GuildPanel.SelectedMember["index"]);
    
    local note = "";

    if(GuildPanel.SelectedMember["guildNote"] ~= nil and GuildPanel.SelectedMember["guildNote"] ~= "") then
        note = " - "..GuildPanel.SelectedMember["guildNote"];
    else
        note = "";
    end;

    getglobal("GuildPanelFrame_SelectedMember_Content"):SetText(GuildPanel.SelectedMember["name"]..note);
    getglobal("GuildPanelFrame_SelectedMember_Content2"):SetText(GuildPanel.SelectedMember["rankname"]);

    if (key=="RBUTTON") then
        UIDropDownMenu_SetAnchor(GP_Frame_Menu, 20, 0, "TOP", "CENTER", button);
        ToggleDropDownMenu(GP_Frame_Menu);
    else
        CloseDropDownMenus();
    end
end;

--[[ this will change the scroll bar value when somebody scrolls ]]
function GuildPanel_MemberList_OnMouseWheel(slider,delta)
    if (delta > 0) then
        slider:SetValue(slider:GetValue() - 1);
    else
        slider:SetValue(slider:GetValue() + 1);
    end
end;

--[[ scroll bar value change: adjust list items]]
function GuildPanel_MemberList_OnValueChanged(frame,arg1)
    local val = frame:GetValue();
    GuildPanel.PopulateList();
    GuildPanel.CheckScrollPosition("GuildPanel_MemberListSlider");
end;


--[[ panel functions ]]--

function GuildPanel.PopulateList()

   local x,y = 9,13;
   local num = 1;
   
   local from = getglobal("GuildPanel_MemberListSlider"):GetValue();
   local to = from + GuildPanel_Length - 1;
   
   local fields = {"Name","Classes","Levels","Status","RankNote"};

   -- check if we want to show more than possible
   if(to > GuildPanel.currentCount) then to = GuildPanel.currentCount; end;

   -- populate buttons
   for i = from, to, 1 do

        local member = GuildPanel.currentMemberTable[i];
        local memberstatus, lastrow;

		framename = "GuildPanel_MemberList_Member_"..num;

		if(member["isOnline"] == 1) then
			memberstatus = member["currentZone"];
		else
			memberstatus = member["logoutString"];
		end;

		if(GuildPanel.Settings["lastRow"] == "note") then
			lastrow = member["guildNote"];
		else
			lastrow = member["rankname"];
		end;

		--[[ coloring ]]
		local r,g,b = 1,1,1;

		if(GuildPanel.Settings["showColors"] == 1) then
			if(GuildPanel.Settings["showColorsOffline"] == 1 or member["isOnline"] == 1) then
				-- online or overriden by setting
				if(GuildPanel.Settings["colorType"] == "rank") then
					r,g,b = GuildPanel.GetRankColor(member["rank"]);
				end;

				if(GuildPanel.Settings["colorType"] == "class") then
					r,g,b = GuildPanel.GetClassColor(member["class"]);
				end;
			else
				-- offline
				r,g,b = 0.6,0.6,0.6;
			end;
		else
			-- no specific coloring
			if(member["isOnline"] == 1) then
				r,g,b = 1,1,1;
			else
				r,g,b = 0.6,0.6,0.6;
			end;
		end;

		--[[ end colors ]]


		for k,v in ipairs(fields) do
			 getglobal(framename.."_"..v):SetColor(r,g,b);
		end;


		btn = getglobal(framename);

		getglobal(framename.."_Name"):SetText(member["name"]);
		getglobal(framename.."_Classes"):SetText(member["classCom"]);
		getglobal(framename.."_Levels"):SetText(member["levelCom"]);
		getglobal(framename.."_Status"):SetText(memberstatus);
		getglobal(framename.."_RankNote"):SetText(lastrow);


		btn.memberid = member["index"];
		btn.id = i;
		btn.num = num;

		btn:ClearAllAnchors();
		btn:SetAnchor("TOPLEFT", "TOPLEFT", "GuildPanel_MemberList", x, (21 * num) + y);

		btn:Show();
		num = num + 1;
   end;
   
   if(num < GuildPanel_Length) then
	-- hide empty fields
		for i = num, GuildPanel_Length do
			getglobal("GuildPanel_MemberList_Member_"..i):Hide();
		end;
   end;
   
end;

--[[ check for scroll buttons: disable/enable ]]
function GuildPanel.CheckScrollPosition(this)
    local scrollbar = getglobal(this);
    local currentval = scrollbar:GetValue();
    local minval,maxval = scrollbar:GetMinMaxValues();

    -- Check for list end
    if (currentval == maxval) then
        getglobal(this.."ScrollDownButton"):Disable();
    else
        getglobal(this.."ScrollDownButton"):Enable();
    end

    -- check for list start
    if (currentval == 1) then
        getglobal(this.."ScrollUpButton"):Disable();
    else
        getglobal(this.."ScrollUpButton"):Enable();
    end

    -- check for list length below border
    --if (maxval <= GuildPanel_Length) then
    --    getglobal(this.."ScrollDownButton"):Disable();
    --    getglobal(this.."ScrollUpButton"):Disable();
    --end
end

--[[ init member list ]]
function GuildPanel.InitList()

	GuildPanel.currentCount = 0;
    GuildPanel.onlineCount = 0;
    GuildPanel.currentMemberTable = {};
    
    GF_ReadAllDate();

    if(type(numGuildMembers) ~= "number" or numGuildMembers < 1) then return; end;

    for i = 1, numGuildMembers, 1 do

        -- online status
        -- SetGuildRosterSelection(i);

        local a,b,c,d,e,f,g,h,j,k,l,m,n,o = GetGuildRosterInfo(i);
        local classCombination = tostring(c);
        local levelCombination = tostring(d);

        if(e~="") then classCombination = classCombination.." / "..tostring(e); end;
        if(f > 0) then levelCombination = levelCombination.." / "..tostring(f); end;

        if(m == "??:??:??") then m = "99:99:99"; end;

        if(UnitName("player") == a) then
            GuildPanel.ownRank = b;
        end;

        if(l) then GuildPanel.onlineCount = GuildPanel.onlineCount + 1; end;

        local p,r = GuildPanel.helpers.ParseTime(m);

        GuildPanel.MemberTable[i] = {
                 name = a,
                 rank = b,
                 rankname = GF_GetRankStr(b),
                 class = c,
                 level = d,
                 subClass = e,
                 subLevel = f,
                 isHeader = g and 1 or 0,
                 isCollapsed = h and 1 or 0,
                 dbid = j,
                 guildTitle = k,
                 isOnline = l and 1 or 0,
                 logoutTime = m,
                 currentZone = n,
                 guildNote = o,
                 levelCom = levelCombination,
                 classCom = classCombination,
                 index = i,
                 logoutSort = p,
                 logoutString = r
        }
        
        if(GuildPanel.MemberTable[i]["isOnline"] == 1 or GuildPanel.Settings["showOffline"] == 1) then
			GuildPanel.currentCount = GuildPanel.currentCount + 1;
			GuildPanel.currentMemberTable[GuildPanel.currentCount] = GuildPanel.MemberTable[i];
		end;
	end;
	
	local slideMax = 1;
	-- set values for slider ( 16 members, slideMax = 1; 18 members, slideMax = 3; etc...)
    if(GuildPanel.currentCount > GuildPanel_Length) then slideMax = GuildPanel.currentCount - GuildPanel_Length + 1; end;
    
    GuildPanel_MemberListSlider:SetMaxValue(slideMax);      
	
end;

-- [[ load all guild ranks and their permissions ]]
function GuildPanel.InitRanks()
    --local rankCount = GF_GetRankCount();
    local rankCount = 10;

    for i = 1, rankCount, 1 do
            local t1,t2,t3,t4,t5,t6,t7,t8,t9,t10 = GF_GetRankInfo(i);
            local rname = GF_GetRankStr(i);

            if(rname ~= nil and rname ~= "") then
                GuildPanel.RankList[i] = {
                    recruit = t1,
                    kick = t2,
                    changerank = t3,
                    changenote = t4,
                    announce = t5,
                    guildboard = t6,
                    gbmanage = t7,
                    castle = t8,
                    placeinventory = t9,
                    unknown = t10,
                    rankname = rname
                }
            end;
    end;
end;

--[[ call this only when InitList and InitRanks are done at least once]]--
function GuildPanel.InitPermissions()
    local bKick,bInvite,bNote,bPost,bBBSManage,bLeader = GF_GetGuildFunc();

        GuildPanel.Permissions["kick"]   = bKick;
        GuildPanel.Permissions["invite"] = bInvite;
        GuildPanel.Permissions["note"]   = bNote;
        GuildPanel.Permissions["post"]   = bPost;
        GuildPanel.Permissions["board"]  = bBBSManage;
        GuildPanel.Permissions["leader"] = bLeader;

    if(GuildPanel.ownRank > 0) then
        GuildPanel.Permissions["rank"] = GuildPanel.RankList[GuildPanel.ownRank]["changerank"];
    end;
end;

function GuildPanel.GetRankColor(rank)
    if rank == 10 then
            return .8,0,0;
    elseif rank == 9 then
            return .8,.4,0;
    elseif rank == 8 then
            return .8,.4,.4;
    elseif rank == 7 then
            return .8,.8,.4;
    elseif rank == 6 then
            return .4,.8,.8;
    elseif rank == 5 then
            return .4,.4,.8;
    elseif rank == 4 then
            return .4,.8,.4;
    elseif rank == 3 then
            return 0,.8,.8;
    elseif rank == 2 then
            return 0,.4,.8;
    elseif rank == 1 then
            return 0,.8,.4;
    else
            return 1,1,1;
    end;
end;

function GuildPanel.GetClassColor(class)
    -- modified version of pbInfo addon function
    -- by p.b. a.k.a. novayuna
    -- released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/

    local ctable = {
        [GetSystemString("SYS_CLASSNAME_WARRIOR")]      = {r = 1, g = 0, b = 0},
        [GetSystemString("SYS_CLASSNAME_RANGER")]       = {r = 0.65, g = 0.84, b = 0.01},
        [GetSystemString("SYS_CLASSNAME_THIEF")]        = {r = 0, g = 0.84, b = 0.77},
        [GetSystemString("SYS_CLASSNAME_MAGE")]         = {r = 1, g = 0.75, b = 0},
        [GetSystemString("SYS_CLASSNAME_AUGUR")]        = {r = 0.04, g = 0.55, b = 0.93},
        [GetSystemString("SYS_CLASSNAME_KNIGHT")]       = {r = 1, g = 1, b = 0.28},
        [GetSystemString("SYS_CLASSNAME_WARDEN")]   	= {r = 0.757 , g = 0.290 , b = 0.819},
        [GetSystemString("SYS_CLASSNAME_DRUID")]        = {r = 0.380 , g = 0.819 , b = 0.378},
        [GetSystemString("SYS_CLASSNAME_HARPSYN")]      = {r = 0.38, g = 0.17, b = 0.91},
		[GetSystemString("SYS_CLASSNAME_PSYRON")]       = {r = 0.19, g = 0.15, b = 0.95},
        [GetSystemString("SYS_CLASSNAME_GM")]           = {r = 1, g = 1, b = 1},
        ["WARDEN_TMP"] = {r = 0.757 , g = 0.290 , b = 0.819},
        ["DRUID_TMP"] = {r = 0.380 , g = 0.819 , b = 0.378}
    };
    
    if(GuildPanel.Settings["swapDruidWarden"] == 1) then
		ctable[GetSystemString("SYS_CLASSNAME_WARDEN")] = ctable["DRUID_TMP"];
		ctable[GetSystemString("SYS_CLASSNAME_DRUID")] = ctable["WARDEN_TMP"];
	else
		ctable[GetSystemString("SYS_CLASSNAME_WARDEN")] = ctable["WARDEN_TMP"];
		ctable[GetSystemString("SYS_CLASSNAME_DRUID")] = ctable["DRUID_TMP"];	
    end;

    -- end extract pbInfo

    if(type(ctable[class]) == "table") then
        return ctable[class]["r"],ctable[class]["g"],ctable[class]["b"];
    else
        return 1,1,1;
    end;
end;

--[[ reload the guild member list at its current position]]
function GuildPanel.ReloadList()
    local val = GuildPanel_MemberListSlider:GetValue();

    GuildPanel.InitList();
    GuildPanel_Sort(GuildPanel.Settings["sortOrder"]);

    GuildPanel.PopulateList();

    GuildPanel_MemberListSlider:SetValue(val);
    GuildPanel.CheckScrollPosition("GuildPanel_MemberListSlider");
end;

--[[ Dropdown functions ]]--


--[[ load dropdown ]]--
function GuildPanel_Dropdown_Onload(this)
    UIDropDownMenu_SetWidth(this, 92);
    UIDropDownMenu_Initialize(this, GuildPanel_Dropdown_Show);
    UIDropDownMenu_SetSelectedID(this, GuildPanel.Settings["sortOrder"]);
end;

--[[ init dropdown values ]]
function GuildPanel_Dropdown_Show()
    local info = {};
    local clickfunc = GuildPanel_Dropdown_Click;

    info[1] = { value = 1, text = GuildPanel.locale["dropdown_name"], func = clickfunc };
    info[2] = { value = 2, text = GuildPanel.locale["dropdown_online"], func = clickfunc };
    info[3] = { value = 3, text = GuildPanel.locale["dropdown_zone"], func = clickfunc };
    info[4] = { value = 4, text = GuildPanel.locale["dropdown_rank"], func = clickfunc };
    info[5] = { value = 5, text = GuildPanel.locale["dropdown_level"], func = clickfunc };
    info[6] = { value = 6, text = GuildPanel.locale["dropdown_class"], func = clickfunc };

    for i,v in ipairs(info) do UIDropDownMenu_AddButton(v) end;
end;

--[[ dropdown click handler ]]
function GuildPanel_Dropdown_Click(button)
    GuildPanel.Settings["sortOrder"] = button.value;
    GuildPanel_Sort(GuildPanel.Settings["sortOrder"]);

    -- Liste neu initialisieren
    GuildPanel.PopulateList();
    UIDropDownMenu_SetSelectedID(GuildPanel_Dropdown, GuildPanel.Settings["sortOrder"]);

end;

--[[ sort function ]]
function GuildPanel_Sort(field)
    --[[
      1 = name
      2 = online
      3 = zone
      4 = rank
      5 = level
      6 = class
    ]]

    if(field == 1) then
        table.sort(GuildPanel.currentMemberTable,GuildPanel.helpers.SortName);
    elseif(field == 2) then
        table.sort(GuildPanel.currentMemberTable,GuildPanel.helpers.SortOnline);
    elseif(field == 3) then
        table.sort(GuildPanel.currentMemberTable,GuildPanel.helpers.SortZone);
    elseif(field == 4) then
        table.sort(GuildPanel.currentMemberTable,GuildPanel.helpers.SortRank);
    elseif(field == 5) then
        table.sort(GuildPanel.currentMemberTable,GuildPanel.helpers.SortLevel);
    elseif(field == 6) then
        table.sort(GuildPanel.currentMemberTable,GuildPanel.helpers.SortClass);
    end;

    if(field > 0) then
        GuildPanel_MemberListSlider:SetValue(1);
    end;
end;
