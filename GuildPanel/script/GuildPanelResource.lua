local GP_MAX_CONTRIBITEMS=6;

function GP_GuildFunctions_OnLoad(this)
	this:RegisterEvent("GRF_UPDATERESOURCE");
	this:RegisterEvent("UPDATE_GUILD_INFO");


	for i=1,8 do

		GuildFuncFrame_Update(this:GetName().."_Func"..i,GUILD_RESOURCE_STR[i+8],0,0);

	end

end


function GP_GuildFunctions_OnShow(this)

	local level = GCB_GetGuildLevel()
	local levelMax = GCB_GetGuildLevelCount()
	
	local f2=getglobal(this:GetName().."_Func1")
	GuildFuncFrame_Update(this:GetName().."_Func1",GUILD_RESOURCE_STR[9],level-1,level,1);
	f2:Show()

	local f2=getglobal(this:GetName().."_Func2");

	local t1 = GCB_GetGuildLevelInfo(level,9);
	local t2 = GCB_GetGuildLevelInfo(level+1,9);
	
	-- ignore max level+1
	if(t2 == -1) then
		t2 = "";
	end;
	
	GuildFuncFrame_Update(this:GetName().."_Func2",GUILD_RESOURCE_STR[10],t1,t2,(t1));

	if (t1~=nil or t2~=nil) then
		f2:Show();
	else
		f2:Hide();
	end


	local of1=getglobal(this:GetName().."_Func2");

	for i=3,8 do

	        local v=GCB_GetGuildLevelInfo(level,i+7);

			local f1=getglobal(this:GetName().."_Func"..i);

			local Str1,Str2;
			if (v == 0) then
				Str1 = GuildPanel.locale["No"];
			else
				Str1 = GuildPanel.locale["Yes"];
			end

			local v2=GCB_GetGuildLevelInfo(level+1,i+7);
			if (v2 > 0) then
				Str2 = GuildPanel.locale["Yes"];
			else
				Str2 = GuildPanel.locale["No"];
			end
			
			-- max level, display no more stats
			if(v2 == -1) then
				Str2 = "";
			end;

			GuildFuncFrame_Update(this:GetName().."_Func"..i, GUILD_RESOURCE_STR[i+8] ,Str1 ,Str2 ,v);

			if (v>0 or v2>0) then

				f1:ClearAllAnchors();
				f1:SetAnchor("TOP", "BOTTOM", of1,0,0);
				f1:Show();
				of1=f1;


			else
				f1:Hide();

			end
	end
	checks = GP_CheckUpgrade()
	if (checks==7) then
		GP_GuildUpgrade:Enable();
	else
		GP_GuildUpgrade:Disable();
	end

	if (level>=levelMax or GuildFrame.class.bLeader==false) then
		GP_GuildUpgrade:Hide();
	else
		GP_GuildUpgrade:Show();
	end

	GLVL_STRING = "Gildenstufe " .. level
	--local guildtitle = getglobal( "GP_RessStatus_GuildLevel")
	--PointFrame_Update(guildtitle:GetName(), level-1)

end

function GP_CheckUpgrade()

	local level=GCB_GetGuildLevel()
	local checks = 0

	for i=1,7 do
		current=GCB_GetGuildResource(i);
		levelup=GCB_GetGuildLevelInfo(level+1,i);
		if current >= levelup then
			checks = checks + 1
		end
	end
	return checks
end


-- ## RessStatus-Frame ##

function GP_RessStatus_OnShow(this)
	GP_UpdateRessStatus()
end

function GP_UpdateRessStatus()
	local level=GCB_GetGuildLevel()

	GuildFrame.Resource={}
	GuildFrame.NextResource={}
	for i=1,7 do
		GuildFrame.Resource[i]=GCB_GetGuildResource(i);
		GuildFrame.NextResource[i]=GCB_GetGuildLevelInfo(level+1,i);
		local f2=getglobal(GuildPanel_RessStatus:GetName().."_Res"..i);

		GP_ResFrame_Update(f2:GetName(),GUILD_RESOURCE_STR[i+1],GuildFrame.Resource[i],GuildFrame.NextResource[i]);

	end
end

function GP_ResFrame_Update(frameName,name,Now,Next)

	local _Bar= getglobal(frameName.."Bar");
	local _BarMsg= getglobal(_Bar:GetName().."DurableStr");
	local _Name = getglobal(_Bar:GetName().."_Name");
	
	local str = "";
	
	if (Next==-1) then
		str = string.format("%s",Now);
	else
		str = string.format("%s/%s",Now,Next);
	end
	
	_Name:SetText(name);
	_BarMsg:SetText(str);

	
	_Bar:SetMaxValue(Next);
	_Bar:SetValue(Now);
	
	if (Next <= 0) then
		_Bar:SetBarColor(0.5,0.5,0.5);
		
		_Bar:SetMaxValue(100);
		_Bar:SetValue(100);	
	
	elseif (Now > Next) then
		_Bar:SetBarColor(0.8,0.2,0.2);
	else
		_Bar:SetBarColor(0.2,0.8,0.2);
	end

end

-- ## Beitrag leisten ##

function GP_Ressource_OnOK()

	local copper = MoneyInputFrame_GetCopper(GP_GuildContributionMoney)
	local Bonus = MoneyInputFrame_GetCopper(GP_GuildContributionBonusMoney)
	GCB_ContributionItemOK(copper,Bonus)

	MoneyInputFrame_ResetMoney(GP_GuildContributionMoney)
	MoneyInputFrame_ResetMoney(GP_GuildContributionBonusMoney)

	GP_Ressource_OnClean()
end

function GP_Ressource_OnClean()

	for i=1 , GP_MAX_CONTRIBITEMS  do
		local frame=getglobal("GP_Contrib_Item"..i);
			local button=getglobal(frame:GetName().."Button");
		if (button.bagPos~=nil) then
			GCB_RemoveContributionItem(button.bagPos);

			button.bagPos=nil;

		end
		
		SetItemButtonTexture( button,nil );
		SetItemButtonCount( button, 0 );
		PointFrame_UpdateType(frame:GetName().."Point","");
		PointFrame_Update(frame:GetName().."Point", 0);
		getglobal(frame:GetName().."Name"):SetText(nil);
	end

	MoneyInputFrame_ResetMoney(GP_GuildContributionMoney)
	MoneyInputFrame_ResetMoney(GP_GuildContributionBonusMoney)

	GuildPanel.FetchResourceList();
	GuildPanel.SelectResourceUser("");
	GuildPanel.PopulateResourceList(GuildPanel_ResourceList);

end

function GP_RessItems_OnHide(this)
	GP_Ressource_OnClean()
end

function GP_RessItems_OnShow(this)
	GP_Ressource_OnClean()
end

function GP_RessItems_OnEvent(this, event)

	if(event == "UPDATE_GUILD_INFO") then
		GP_UpdateRessStatus()
	end
end

function GP_RessItems_OnLoad(this)
	this:RegisterEvent("UPDATE_GUILD_INFO");
end
