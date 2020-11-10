local AutoAI = {}

_G.AutoAI = AutoAI

AutoAI.PartyInvite = true
AutoAI.RideInvite = true
AutoAI.TradeInvite = true
AutoAI.BossSound = true

function AutoAI.OnLoad(this)
	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("SAVE_VARIABLES")
	this:RegisterEvent("PARTY_INVITE_REQUEST")
	this:RegisterEvent("RIDE_INVITE_REQUEST")
	this:RegisterEvent("TRADE_REQUEST")
	this:RegisterEvent("ELITE_BOSS_BELL")
	SaveVariablesPerCharacter("AutoAI_RideInvite")
	SaveVariablesPerCharacter("AutoAI_PartyInvite")
	SaveVariablesPerCharacter("AutoAI_TradeInvite")
	SaveVariablesPerCharacter("AutoAI_BossSound")
end

function AutoAI.OnEvent(event)
	if event == "VARIABLES_LOADED" then
		AutoAI.RideInvite = AutoAI_RideInvite
		AutoAI.PartyInvite = AutoAI_PartyInvite
		AutoAI.TradeInvite = AutoAI_TradeInvite
		AutoAI.BossSound = AutoAI_BossSound
	elseif event == "SAVE_VARIABLES" then
		AutoAI_RideInvite = AutoAI.RideInvite
		AutoAI_PartyInvite = AutoAI.PartyInvite
		AutoAI_TradeInvite = AutoAI.TradeInvite
		AutoAI_BossSound = AutoAI.BossSound
	elseif event == "PARTY_INVITE_REQUEST" and AutoAI.PartyInvite then
		AcceptGroup()
		getglobal(StaticPopup_Visible("PARTY_INVITE")):Hide();
	elseif event == "RIDE_INVITE_REQUEST" and AutoAI.RideInvite then
		AcceptRideMount()
		getglobal(StaticPopup_Visible("RIDE_INVITE")):Hide();
	elseif event == "TRADE_REQUEST" and AutoAI.RideInvite then
		AgreeTrade()
		getglobal(StaticPopup_Visible("TRADE")):Hide();
	elseif event == "ELITE_BOSS_BELL" and AutoAI.BossSound then
		PlaySoundByPath("/interface/addons/AutoAcceptInvitations/disneymlg.mp3");
	end
end

function AutoAI.MenuOnShow(this)

	local info = {}
	
	info = {}
	info.text = "AutoAcceptInvitations"
	info.isTitle = 1
	UIDropDownMenu_AddButton( info, 1 )

	info = {}
	info.text = "Accept Party Invite"
	info.checked = AutoAI.PartyInvite
	info.keepShownOnClick = 1
	info.func=function() AutoAI.PartyInvite = not AutoAI.PartyInvite end
	UIDropDownMenu_AddButton( info, 1 )

	info = {}
	info.text = "Accept Ride Invite"
	info.checked = AutoAI.RideInvite
	info.keepShownOnClick = 1
	info.func=function() AutoAI.RideInvite = not AutoAI.RideInvite end
	UIDropDownMenu_AddButton( info, 1 )

	info = {}
	info.text = "Accept Trade Invite"
	info.checked = AutoAI.TradeInvite
	info.keepShownOnClick = 1
	info.func=function() AutoAI.TradeInvite = not AutoAI.TradeInvite end
	UIDropDownMenu_AddButton( info, 1 )

	info = {}
	info.text = "Play Boss Sound"
	info.checked = AutoAI.BossSound
	info.keepShownOnClick = 1
	info.func=function() AutoAI.BossSound = not AutoAI.BossSound end
	UIDropDownMenu_AddButton( info, 1 )
end

function AutoAI.ButtonOnClick(this,key)
	if not IsShiftKeyDown() then
		ToggleDropDownMenu(AutoAI_Menu)
	end
end

function AutoAI.ButtonOnEnter(this)
	GameTooltip:SetOwner(this, "ANCHOR_LEFT", 4, 0)
	GameTooltip:SetText("AutoAcceptInvitations", 1, 1, 1)
	GameTooltip:AddLine(UI_MINIMAPBUTTON_MOVE, 0, 0.75, 0.95)
	GameTooltip:Show()
end

function AutoAI.ButtonOnLeave(this)
	GameTooltip:Hide()
end
