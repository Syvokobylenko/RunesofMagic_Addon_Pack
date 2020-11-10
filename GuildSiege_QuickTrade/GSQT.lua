--[[
	Guild Siege Quick Trade AddOn
	
	All right reserved.
	
	by McGaerty 	(mcgaerty@ikarus-systems.net)
]]


--[[
	Guildwar Merrits: 	ID=206685
	Stone:			ID=210294
	Guild Siege Zone ID:	402
	Logar Zone ID:		1
	
	For testing change the GS_ID and MERRIT_ID values to the ones
	of your choice. GS_ID defines the zone this addon is restricted to
	and MERRIT_ID leads to the correct MERRIT_NAME value being
	loaded at startup so quick trade can search for the right items
	in your bag without having to depend on locales.
]]
local GS_ID = 402;
local MERRIT_ID = 206685;
local MERRIT_NAME = TEXT("Sys"..MERRIT_ID.."_name");


local qt = {};

local preloaded = {
	VARIABLES_LOADED = true,
	SAVE_VARIABLES = true,
};
local colors = {
	Donate = {r=1,g=1,b=1}, 
	Collect = {r=0,g=1,b=0},
};
local events = {
	TRADE_REQUEST = true,
	TRADE_SHOW = true,
	TRADE_CLOSED = true,
	TRADE_ACCEPT_UPDATE = true,
};
local loaded = false;

local qtCheck = function()
	return gsqtVARS.active and GetCurrentWorldMapID()==GS_ID;
end;

local print = _G.print or function(text)
	DEFAULT_CHAT_FRAME:AddMessage(text, 1, 1, 1);
end;

local printf = _G.printf or function(text, ...)
	print(text:format(...), 1, 1, 1);
end;

qt.OnLoad = function(self, frame)
	frame:RegisterEvent("VARIABLES_LOADED");
	frame:RegisterEvent("SAVE_VARIABLES");
	frame:RegisterEvent("ZONE_CHANGED");
	SaveVariablesPerCharacter("gsqtVARS");
	
	local fName = GSQT_Frame:GetName();
	GSQT_Frame.ActivateButton = getglobal(fName.."_ActivateButton");
	GSQT_Frame.ModeButton = getglobal(fName.."_ModeButton");
	
	qt:CheckZone(frame);
end;

qt.OnUpdate = function(self, frame, elapsed)
	if qt.callback then
		qt.timer = (qt.timer or 0)-elapsed;
		if qt.timer < 0 then
			qt.callback(qt, frame);
			qt.callback = nil;
		end;
	end;
end;

qt.Schedule = function(self, timer, callback)
	qt.timer = timer;
	qt.callback = callback;
end;

qt.OnEvent = function(self, frame, event, ...)
	local handler = self[event];
	if handler and (preloaded[event] or loaded) then
		handler(self, frame, ...);
	end;
end;

qt.ZONE_CHANGED = function(self, frame)
	qt:Schedule(1, qt.CheckZone);
end;

qt.VARIABLES_LOADED = function(self, frame)
	gsqtVARS = gsqtVARS or {
		pos_x = 200,
		pos_y = 200,
		mode = "Donate",
		active = true,
	};
	
	local scale = GetUIScale();
	GSQT_Frame:ClearAllAnchors();
	GSQT_Frame:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", gsqtVARS.pos_x/scale, gsqtVARS.pos_y/scale);
	
	GSQT_Frame.ActivateButton:SetChecked(gsqtVARS.active);
	local col = colors[gsqtVARS.mode];
	GSQT_Frame.ModeButton:SetTextColor(col.r, col.g, col.b);
	GSQT_Frame.ModeButton:SetText(gsqtVARS.mode);
	loaded = true;
end;

qt.SAVE_VARIABLES = function(self, frame)
	--gsqtVARS.pos_x, gsqtVARS.pos_y = frame:GetPos();
end;

qt.TRADE_REQUEST = function(self, frame, name)
	if qtCheck() then
		local popup = StaticPopup_Visible("TRADE");
		if popup then
			getglobal(popup):Hide();
			qt:Schedule(0.1, AgreeTrade);
		end;
	end;
end;

qt.TRADE_SHOW = function(self, frame)
	if qtCheck() then
		if gsqtVARS.mode=="Donate" and GetBagItemCount(MERRIT_ID) then
			TradeFrame:SetAlpha(0);
			qt:Schedule(0.1, qt.PerformTrade);
		end;
	end;
end;

qt.TRADE_CLOSED = function(self, frame)
	if qtCheck() then
		TradeFrame:SetAlpha(1);
	end;
end;

qt.TRADE_ACCEPT_UPDATE = function(self, frame, playerState, targetState)
	if qtCheck() then
		if gsqtVARS.mode=="Collect" and playerState==targetState then
			local tradeCount = 0;
			local name,count;
			for i=1,8,1 do
				_, name, count = GetTradeTargetItemInfo(i);
				if name and name:find(MERRIT_NAME) then
					tradeCount = tradeCount + count;
				end;
			end;
			if tradeCount>0 then
				printf("Collecting %d %s",tradeCount,MERRIT_NAME);
			end;
		end;
		if playerState<2 then
			AcceptTrade("");
		end;
	end;
end;

qt.ToggleMode = function(self, frame)
	if gsqtVARS.mode=="Donate" then
		gsqtVARS.mode = "Collect";
	else
		gsqtVARS.mode = "Donate";
	end;
	local col = colors[gsqtVARS.mode];
	frame:SetTextColor(col.r, col.g, col.b);
	frame:SetText(gsqtVARS.mode);
end;

qt.InitTrade = function(self, unit)
	unit = unit or "target";
	RequestTrade(unit);
end;

qt.CheckZone = function(self, frame)
	if GetCurrentWorldMapID()==GS_ID then
		for event in pairs(events) do
			frame:RegisterEvent(event);			
		end;
		GSQT_Frame:Show();
	else
		for event in pairs(events) do
			frame:UnregisterEvent(event);			
		end;
		GSQT_Frame:Hide();
	end;
end;

qt.PerformTrade = function(self)
	local found;
	local tradeIndex = 1;
	local tradeCount = 0;
	local name,count,index;
	for i=1,BAG_MAX_ITEMS_ALL,1 do
		index, _, name, count, _, _ = GetBagItemInfo(i);
		if name==MERRIT_NAME then
			--printf("found %s on slot %d (%d) - moving to trade slot %d",MERRIT_NAME,i,index,tradeIndex)
			PickupBagItem(index);
			ClickTradeItem(tradeIndex);
			tradeIndex = tradeIndex + 1;
			found = true;
			tradeCount = tradeCount + count;
			
			if tradeIndex > 8 then
				break;
			end;
		end;
	end;	
	
	if found then
		printf("Trading %d %s",tradeCount,MERRIT_NAME);
		AcceptTrade("");
	else
		print("Nothing to trade for now");
		HideUIPanel(TradeFrame);
	end;
end;


_G.GSQT = qt;