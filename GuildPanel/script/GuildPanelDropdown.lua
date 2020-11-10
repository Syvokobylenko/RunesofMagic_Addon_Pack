--[[ Guild member right-click dropdowns ]]



StaticPopupDialogs["GUILDPANEL_LEADERCHANGE"] = {
	text = GF_STR_LEADERCHANGE,
	button1 = BSF_STR_APPLY,
	button2 = TEXT("CANCEL"),
	OnAccept = function(this)
		StaticPopup_Show("GUILDPANEL_LEADERCHANGE2",GuildPanel.SelectedMember["name"]);
	end,
	OnCancel = function()
		GuildPanel.selectionLock = false;
	end,
	timeout = 0,
	hideOnEscape = 1
};

StaticPopupDialogs["GUILDPANEL_LEADERCHANGE2"] = {
	text = GF_STR_REALYLEADERCHANGE,
	button1 = BSF_STR_APPLY,
	button2 = TEXT("CANCEL"),
	OnAccept = function(this)
		GF_LeaderChange(GuildPanel.SelectedMember["dbid"]);		
		GuildPanel.selectionLock = false;
	end,
	OnCancel = function()
		GuildPanel.selectionLock = false;
	end,
	timeout = 0,
	hideOnEscape = 1
};


--[[ These functions handle the dropdown menu entries ]]--
function GPDropdown_LeaderChange()
    -- Lock frame selections (StaticPopup will reset this)
    GuildFrame.selectionLock = true;
    
    -- need at least name, dbid for legacy API functions
    StaticPopup_Show("GUILDPANEL_LEADERCHANGE",GuildPanel.SelectedMember["name"]);
end;

function GPDropdown_RankChange(this)
    GF_SetMemberRank(GuildPanel.SelectedMember["dbid"],this.value);
end;

function GPDropdown_KickGuildMember()
    GuildFrame.class.selectedName = GuildPanel.SelectedMember["name"];
    StaticPopup_Show("REMOVE_GUILDMEMBER",GuildPanel.SelectedMember["name"]);
end;

function GPDropdown_CadreNote(this)
    GuildFrame.class.dbid = GuildPanel.SelectedMember["dbid"];
    GuildFrame.class.Note = GuildPanel.SelectedMember["guildNote"];
    StaticPopup_Show("SET_GUILD_OFFICER_NOTE",GuildPanel.SelectedMember["name"],GuildPanel.SelectedMember["guildNote"]);
end;


function GPDropdown_SelfNote(this)
    --GuildPanel.SendMsg("This function should never be called, it's not in the menu.");
end;

function GPDropdown_Whisper(this)
    ChatFrame_SendTell(GuildPanel.SelectedMember["name"]);
end;

function GPDropdown_InviteToGroup(this)
    InviteByName(GuildPanel.SelectedMember["name"]);
end;

function GPDropdown_SelfLeave(this)
    StaticPopup_Show("GUILD_LEAVE_READY");
end;

function GP_AddMember(this)
    StaticPopup_Show("ADD_GUILDMEMBER");
end;

function GPDropdown_ShowResources(this)
	
	
	GuildPanel_ResourceFrame:Show();
	GuildPanel_MemberList:Hide();
	GuildPanel_Dropdown:Hide();
	GuildPanelConfig_ShowOffline:Hide();

	GuildPanel_ResourceList:Show();
	GuildPanel_ContribFrame:Show();
	GuildPanel_GuildFunctionsFrame:Hide();
	GuildPanel_RessStatus:Show();	
	
	GuildPanel.SelectResourceUser(GuildPanel.SelectedMember["name"]);
	GP_CurrentResourceUser = GuildPanel.SelectedMember["name"];
	GuildPanel.PopulateResourceList();
	
end;

--------------------------------------------------------------------------
-- Menu elements
GP_MENU1_TAB =
{
    {RK_WHISPER,GPDropdown_Whisper},
    {RK_INVITE,GPDropdown_InviteToGroup}
};

GP_MENU2_TAB =
{
    {RK_SUCCEED_PRESIDENT,GPDropdown_LeaderChange}
};

GP_MENU3_TAB =
{
    --{GUILD_ADJUST_GUILD_RANK,GPDropdown_RankChange}
};
GP_MENU4_TAB =
{
    --{GUILD_ADJUST_GUILD_GRUOP,GPDropdown_GroupChange}
};

GP_MENU5_TAB =
{
    {GUILD_CADRE_SHORTNOTE,GPDropdown_CadreNote}
};

GP_MENU6_TAB =
{
    {GUILD_DISMISS_GUILD_MEMBER,GPDropdown_KickGuildMember}
};

GP_MENU7_TAB =
{
    {GUILD_PLAYER_SHORTNOTE,GPDropdown_SelfNote},
};
GP_MENU8_TAB =
{
    {GF_STR_GUILD_LEAVE,GPDropdown_SelfLeave}
};
GP_MENU9_TAB = 
{
	{GUILD_STR_CONTRIBUTION,GPDropdown_ShowResources}
}

------------------------------------------------------------------------------------------

function  GP_MemberDropdown_MakeRankMenu()
    --[[ original function rewritten ]]--
    -- local rankCount=GF_GetRankCount();

    local j = 1;

    for i = 1, 10 do
        -- workaround
        if(type(GuildPanel.RankList[i]) == "table") then

            local rankName = GuildPanel.RankList[i]["rankname"];

            if (string.len(rankName)<2) then
                rankName=string.format("rank%d",i);
            end


            GP_MENU3_TAB[j]={rankName,GPDropdown_RankChange,i};
            j=j+1;

        end;
    end;

    GP_MemberDropdown_AddMenuButton(GP_MENU3_TAB,2,GuildPanel.SelectedMember["rank"]);

end

function GP_MemberDropdown_MakeGuildMenu()
    local isSelf =false;

    if(UnitName("player") == GuildPanel.SelectedMember["name"]) then
        isSelf = true;
    end;

    GP_MemberDropdown_AddTitle(RK_PERSONAL_OPERATE);

    if (not isSelf) then
        GP_MemberDropdown_AddMenuButton(GP_MENU1_TAB,1,0);
    else
        GP_MemberDropdown_AddMenuButton(GP_MENU8_TAB,1,0);
    end

    GP_MemberDropdown_AddMenuButton(GP_MENU9_TAB,1,0);

    if (GuildPanel.Permissions["rank"]
        or GuildPanel.Permissions["note"]
        or GuildPanel.Permissions["kick"]) then
            GP_MemberDropdown_AddTitle(RK_GUILD_OPTION);
    end
    


    if (GuildPanel.Permissions["alreadyCreate"]) then

        if (GuildPanel.Permissions["leader"]) then
            GP_MemberDropdown_AddMenuButton( GP_MENU2_TAB,1,0 );
        end

        if (GuildPanel.Permissions["rank"]) then
            GP_MemberDropdown_AddMenuGroup( GUILD_ADJUST_GUILD_RANK,1,1);
        end

        if (GuildPanel.Permissions["note"]) then
            GP_MemberDropdown_AddMenuButton( GP_MENU5_TAB,1,0 );
        end
    end

    if (GuildPanel.Permissions["kick"]) then
        GP_MemberDropdown_AddMenuButton( GP_MENU6_TAB ,1,0);
    end
end

--[[ dropdown init functions ]]--
function GP_MemberDropdown_OnLoad(frame)
    UIDropDownMenu_Initialize(frame,GP_MemberDropdown_Show,"MENU");
end

function GP_MemberDropdown_Show()
    if( UIDROPDOWNMENU_MENU_LEVEL == 1 ) then
        GP_MemberDropdown_MakeGuildMenu();
    end
    if( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
        GP_MemberDropdown_MakeRankMenu();
    end
end

function GP_MemberDropdown_AddMenuButton(but_tab,level,check)
    for i,tab in pairs(but_tab) do

        local info = {};
        info.text  = tab[1];
        info.func  = tab[2];
        info.value = tab[3];

        if (tab[3] and check == tab[3])        then
            info.checked = 1;
        end

        UIDropDownMenu_AddButton(info,level);
    end
end

function GP_MemberDropdown_AddTitle(titleName,level)
    info = {};
    info.text =titleName;

    info.isTitle=true;
    UIDropDownMenu_AddButton(info,level);
end


function GP_MemberDropdown_AddMenuGroup(groupName,level,value)
    info = {};

    info.text =groupName;
    info.hasArrow=true;
    info.value=value;

    UIDropDownMenu_AddButton(info,level);
end
