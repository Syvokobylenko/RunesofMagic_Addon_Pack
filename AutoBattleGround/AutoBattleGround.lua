local AutoBG = {}

_G.AutoBG = AutoBG
local WaitTimer = LibStub("WaitTimer")

AutoBG.ToggleStatus = false
AutoBG.TimerID = 1337
AutoBG.loading_msg = false

function AutoBG.OnLoad(this)
    this:RegisterEvent("OPEN_ENTER_BATTLEGROUND_QUERY_DIALOG")
    this:RegisterEvent("ON_BATTLEGROUND_CLOSE")
	this:RegisterEvent("PLAYER_DEAD")
end

function AutoBG.OnEvent(event)
	if event == "OPEN_ENTER_BATTLEGROUND_QUERY_DIALOG" then
		if StaticPopup1:IsVisible() then
			StaticPopup_OnClick(StaticPopup1, 1)
			StaticPopup_EnterPressed(StaticPopup1)
			StaticPopup1:Hide()
		end
	elseif event == "ON_BATTLEGROUND_CLOSE" then
		LeaveBattleGround()
	elseif event == "PLAYER_DEAD" and IsBattleGroundZone() then
		BrithRevive()
	end
end

function AutoBG.MenuOnShow(this)
	local info = {}
	
    info = {}
    info.text = "AutoBattleGround"
    info.isTitle = 1
	UIDropDownMenu_AddButton( info, 1 )

end

function AutoBG.ButtonOnClick(this,key)
    if not IsShiftKeyDown() then
        if key == "LBUTTON" then
            AutoBG.Toggle(not AutoBG.ToggleStatus)
		else
			ToggleDropDownMenu(AutoBG_Menu)
        end
    end
end

function AutoBG.ButtonOnEnter(this)
	GameTooltip:SetOwner(this, "ANCHOR_LEFT", 4, 0)
	GameTooltip:SetText("AutoBattleGround", 1, 1, 1)
	GameTooltip:AddLine(UI_MINIMAPBUTTON_MOVE, 0, 0.75, 0.95)
	GameTooltip:Show()
end

function AutoBG.ButtonOnLeave(this)
    GameTooltip:Hide()
end

function AutoBG.Toggle(enable)
    AutoBG.ToggleStatus = enable
	if AutoBG.ToggleStatus then
		AutoBG.StartTimer()
		DEFAULT_CHAT_FRAME:AddMessage("Auto AA started");
		AutoBG_Button:UnlockPushed()
	else
		AutoBG.StopTimer()
		DEFAULT_CHAT_FRAME:AddMessage("Auto AA stopped");
        AutoBG_Button:LockPushed()
    end
end


function AutoBG.StartTimer()
	if GetBattleGroundQueueStatusNum() == 0 then
		JoinBattleGround(448)
	end
	AutoBG_Timer = WaitTimer.Wait(20, AutoBG.StartTimer, AutoBG.TimerID)
end

function AutoBG.StopTimer()
	AutoBG_Timer = WaitTimer.Wait(1, do_nothing, AutoBG.TimerID)
	if IsBattleGroundZone() then
		LeaveBattleGround()
		AutoBG.loading_msg = true
	elseif GetBattleGroundQueueStatusNum() == 1 then
		Leave_All_Battle_Ground_Queue()
	end
end

function do_nothing() end