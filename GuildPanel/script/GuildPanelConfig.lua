GuildPanelConfig = {};

function GuildPanelConfig.OnShow(frame)
    getglobal(frame:GetName().."_Title"):SetText(GuildPanel.locale["Config_Title"]);

    GuildPanelConfig_LastRow_Rank_Text:SetText(GuildPanel.locale["Config_ShowRank"]);
    GuildPanelConfig_LastRow_Note_Text:SetText(GuildPanel.locale["Config_ShowNote"]);

    --GuildPanelConfig_Enable_Text:SetText("GuildPanel aktivieren");
    --GuildPanelConfig_Enable:SetChecked(true);

    GuildPanelConfig_ShowColors_Text:SetText(GuildPanel.locale["Config_ShowColors"]);
    GuildPanelConfig_ColorsOffline_Text:SetText(GuildPanel.locale["Config_ColorsOffline"]);
    GuildPanelConfig_ColorsRank_Text:SetText(GuildPanel.locale["Config_ColorsRank"]);
    GuildPanelConfig_ColorsClass_Text:SetText(GuildPanel.locale["Config_ColorsClass"]);
    GuildPanelConfig_SortOnlineTop_Text:SetText(GuildPanel.locale["Config_SortOnlineTop"]);
    GuildPanelConfig_CloseButton:SetText(GuildPanel.locale["Config_CloseText"]);
    GuildPanelConfig_AutoSaveText:SetText(GuildPanel.locale["Config_AutoSave"].."\nv"..GuildPanel.AddonVersion);

	GuildPanelConfig_SwapDruidWarden_Text:SetText(GuildPanel.locale["Config_SwapDruidWarden"]);
	GuildPanelConfig_SwapDruidWarden_Raid_Text:SetText(GuildPanel.locale["Config_SwapDruidWardenRaid"]);

    if(GuildPanel.Settings["lastRow"] == "rank") then
        GuildPanelConfig_LastRow_Rank:SetChecked(true);
        GuildPanelConfig_LastRow_Note:SetChecked(false);
    else
        GuildPanelConfig_LastRow_Rank:SetChecked(false);
        GuildPanelConfig_LastRow_Note:SetChecked(true);
    end;


    if(GuildPanel.Settings["showColors"] == 1) then
        GuildPanelConfig_ShowColors:SetChecked(true);
    else
        GuildPanelConfig_ShowColors:SetChecked(false);
    end;

    if(GuildPanel.Settings["colorType"] == "rank") then
        GuildPanelConfig_ColorsRank:SetChecked(true);
        GuildPanelConfig_ColorsClass:SetChecked(false);
    elseif(GuildPanel.Settings["colorType"] == "class") then
        GuildPanelConfig_ColorsRank:SetChecked(false);
        GuildPanelConfig_ColorsClass:SetChecked(true);
    else
        GuildPanelConfig_ColorsRank:SetChecked(true);
        GuildPanelConfig_ColorsClass:SetChecked(false);
    end;

    if(GuildPanel.Settings["showColorsOffline"] == 1) then
        GuildPanelConfig_ColorsOffline:SetChecked(true);
    else
        GuildPanelConfig_ColorsOffline:SetChecked(false);
    end;

    if(GuildPanel.Settings["swapDruidWarden"] == 1) then
		GuildPanelConfig_SwapDruidWarden:SetChecked(true);
	else
		GuildPanelConfig_SwapDruidWarden:SetChecked(false);
	end;

    if(GuildPanel.Settings["swapDruidWardenRaid"] == 1) then
		GuildPanelConfig_SwapDruidWarden_Raid:SetChecked(true);
	else
		GuildPanelConfig_SwapDruidWarden_Raid:SetChecked(false);
	end;

end;

function GuildPanelConfig.ButtonClick(frame)
    local fname = frame:GetName();

    if(frame:IsChecked()) then
        if(fname == "GuildPanelConfig_LastRow_Rank") then
            GuildPanel.Settings["lastRow"] = "rank";
            GuildPanelConfig_LastRow_Note:SetChecked(false);
        elseif(fname == "GuildPanelConfig_LastRow_Note") then
            GuildPanel.Settings["lastRow"] = "note";
            GuildPanelConfig_LastRow_Rank:SetChecked(false);
        elseif(fname == "GuildPanelConfig_ShowColors") then
            GuildPanel.Settings["showColors"] = 1;

        elseif(fname == "GuildPanelConfig_ColorsRank") then
            GuildPanel.Settings["colorType"] = "rank";
            GuildPanelConfig_ColorsClass:SetChecked(false);

        elseif(fname == "GuildPanelConfig_ColorsClass") then
            GuildPanel.Settings["colorType"] = "class";
            GuildPanelConfig_ColorsRank:SetChecked(false);

        elseif(fname == "GuildPanelConfig_ColorsOffline") then
            GuildPanel.Settings["showColorsOffline"] = 1;

        elseif(fname == "GuildPanelConfig_SortOnlineTop") then
            GuildPanel.Settings["sortOnlineTop"] = 1;

        elseif(fname == "GuildPanelConfig_SwapDruidWarden") then
			GuildPanel.Settings["swapDruidWarden"] = 1;

		elseif(fname == "GuildPanelConfig_SwapDruidWarden_Raid") then
			GuildPanel.Settings["swapDruidWardenRaid"] = 1;
			
			g_ClassColors["WARDEN"] = g_ClassColors["DRUID_ORIG"];
			g_ClassColors["DRUID"] = g_ClassColors["WARDEN_ORIG"];			

        elseif(fname == "GuildPanelConfig_ShowOffline") then
			GuildPanel.Settings["showOffline"] = 1;
			GuildPanel.InitList();
			GuildPanel_Sort(GuildPanel.Settings["sortOrder"])
			GuildPanel.PopulateList();

        else

        end;
    else
        if(fname == "GuildPanelConfig_LastRow_Rank") then
            GuildPanel.Settings["lastRow"] = "notek";
            GuildPanelConfig_LastRow_Note:SetChecked(true);

        elseif(fname == "GuildPanelConfig_LastRow_Note") then
            GuildPanel.Settings["lastRow"] = "rank";
            GuildPanelConfig_LastRow_Rank:SetChecked(true);

        elseif(fname == "GuildPanelConfig_ShowColors") then
            GuildPanel.Settings["showColors"] = 0;

        elseif(fname == "GuildPanelConfig_ColorsRank") then
            GuildPanel.Settings["colorType"] = "class";
            GuildPanelConfig_ColorsClass:SetChecked(true);

         elseif(fname == "GuildPanelConfig_ColorsClass") then
            GuildPanel.Settings["colorType"] = "rank";
            GuildPanelConfig_ColorsRank:SetChecked(true);

        elseif(fname == "GuildPanelConfig_ColorsOffline") then
            GuildPanel.Settings["showColorsOffline"] = 0;

        elseif(fname == "GuildPanelConfig_SortOnlineTop") then
            GuildPanel.Settings["sortOnlineTop"] = 0;

        elseif(fname == "GuildPanelConfig_SwapDruidWarden") then
			GuildPanel.Settings["swapDruidWarden"] = 0;

		elseif(fname == "GuildPanelConfig_SwapDruidWarden_Raid") then
			GuildPanel.Settings["swapDruidWardenRaid"] = 0;
			
			g_ClassColors["WARDEN"] = g_ClassColors["WARDEN_ORIG"];
			g_ClassColors["DRUID"]  = g_ClassColors["DRUID_ORIG"];			

		elseif(fname == "GuildPanelConfig_ShowOffline") then
			GuildPanel.Settings["showOffline"] = 0;
			GuildPanel.InitList();
			GuildPanel_Sort(GuildPanel.Settings["sortOrder"])
			GuildPanel.PopulateList();
        else

        end;
    end;
end;
