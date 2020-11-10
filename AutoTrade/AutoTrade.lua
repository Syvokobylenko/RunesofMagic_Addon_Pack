AutoTrade = {
	Addonname       = "AutoTrade",
	Version         = "0.2",
	Counter         = 0,
	Action          = "",
	ButWeDo			= true,
};



function AutoTrade_OnLoad(frame)

	frame:RegisterEvent("TRADE_ACCEPT_UPDATE");
	frame:RegisterEvent("TRADE_REQUEST");
	frame:RegisterEvent("TRADE_SHOW");

end;



function AutoTrade_OnUpdate(frame, elapsedTime)

	if (AutoTrade.Counter > 0) then

		AutoTrade.Counter = AutoTrade.Counter - elapsedTime;

		if (AutoTrade.Counter <= 0) then

			if (AutoTrade.Action == "agree") then
				AgreeTrade();
			end;

		end;

	end;

end;



function AutoTrade_OnEvent(event, frame)

	if (event == "TRADE_REQUEST") then

		local popup = StaticPopup_Visible("TRADE");

		if popup then
			getglobal(popup):Hide();
		end;

		AutoTrade.Action = "agree";
		AutoTrade.Counter = 0.3;
		AutoTrade.ButWeDo = false;

	end;
	
	
	if (event == "TRADE_SHOW") then
		if (AutoTrade.ButWeDo) then
			BagFrame:Show()
		else
			AutoTrade.ButWeDo = true
		end
	end;


	if (event == "TRADE_ACCEPT_UPDATE") then

		local PlayerState = arg1;
		local TargetState = arg2;
		local i, j, name;
		local invNr, invNr2;
		local iTrade = false;
		local myMoney;

		for i=1,8 do
			_, name = GetTradePlayerItemInfo(i);
			if name then
				iTrade = true;
			end;
		end;

		myMoney = GetTradePlayerMoney();

		if (myMoney > 0) then
			iTrade = true;
		end;


		if (not iTrade) and (TargetState == 1) and (PlayerState == 0) then
			AcceptTrade("");
		end;

		if (not iTrade) and (TargetState == 2) and (PlayerState == 1) then
			AcceptTrade("");
		end;

	end;

end;



function AutoTrade_io(msg,c1,c2,c3)

	DEFAULT_CHAT_FRAME:AddMessage("[|cff00ff00".."AutoTrade|r] "..msg,c1,c2,c3);

end;
