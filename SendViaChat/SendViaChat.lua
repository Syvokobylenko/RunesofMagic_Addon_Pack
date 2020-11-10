local SendVC = {}

_G.SendVC = SendVC
SendVC.ToggleStatus = false
SendVC.FriendsOnly = true

function SendVC.OnLoad(this)
	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("SAVE_VARIABLES")
	this:RegisterEvent("CHAT_MSG_WHISPER")
	this:RegisterEvent("CHAT_MSG_CHANNEL")
end

function SendVC.OnEvent(event, arg1, arg2, arg3, arg4)
	if event == "VARIABLES_LOADED" then
		SendVC.ToggleStatus = SendVC_SavedStatus
		SendVC.FriendsOnly = SendVC_SavedFriendsOnly
	elseif event == "SAVE_VARIABLES" then
		SendVC_SavedStatus = SendVC.ToggleStatus
		SendVC_SavedFriendsOnly = SendVC.FriendsOnly
		SaveVariablesPerCharacter("SendVC_SavedStatus")
		SaveVariablesPerCharacter("SendVC_SavedFriendsOnly")
	elseif event == "CHAT_MSG_CHANNEL" or "CHAT_MSG_WHISPER" then
		if SendVC.ToggleStatus and SendVC.IsCommand(arg1) and SendVC.IsTarget(arg1) and SendVC.Authentication(arg4) then
			SendVC.Execute(arg1)
		end
	end
end

function SendVC.MenuOnShow(this)
	local info = {}
	
    info = {}
    info.text = "SendViaChat"
    info.isTitle = 1
	UIDropDownMenu_AddButton( info, 1 )
	
    info = {}
    info.text = "Only friends can send commands."
	info.checked = SendVC.FriendsOnly
	info.keepShownOnClick = 1
	info.func=function() SendVC.FriendsOnly = not SendVC.FriendsOnly end
    UIDropDownMenu_AddButton( info, 1 )
end

function SendVC.ButtonOnClick(this,key)
    if not IsShiftKeyDown() then
        if key == "LBUTTON" then
            SendVC.Toggle(not SendVC.ToggleStatus)
		else
			ToggleDropDownMenu(SendVC_Menu)
        end
    end
end

function SendVC.ButtonOnEnter(this)
	GameTooltip:SetOwner(this, "ANCHOR_LEFT", 4, 0)
	GameTooltip:SetText("SendViaChat", 1, 1, 1)
	GameTooltip:AddLine("Rightclick for options", 0, 0.75, 0.95)
	GameTooltip:AddLine(UI_MINIMAPBUTTON_MOVE, 0, 0.75, 0.95)
	GameTooltip:Show()
end

function SendVC.ButtonOnLeave(this)
    GameTooltip:Hide()
end

function SendVC.Toggle(enable)
    SendVC.ToggleStatus = enable
	if SendVC.ToggleStatus then
		DEFAULT_CHAT_FRAME:AddMessage("SendViaChat started");
		SendVC_Button:UnlockPushed()
	else
		DEFAULT_CHAT_FRAME:AddMessage("SendViaChat stopped");
        SendVC_Button:LockPushed()
    end
end

function SendVC.Authentication(arg4)
	if not SendVC.FriendsOnly then
		return true
	elseif IsMyFriend(arg4) then
		DEFAULT_CHAT_FRAME:AddMessage("Access Granted to: "..arg4);
		return true 
	else 
		DEFAULT_CHAT_FRAME:AddMessage("Access denied to: "..arg4);
		SendChatMessage("Access denied!", "WHISPER", 0, arg4);
		return false
	end
end

function SendVC.IsCommand(arg1)
	if string.find(arg1,"##") then
		return true
	else 
		return false
	end
end

function SendVC.IsTarget(arg1)
	if string.find(arg1,"G1") then
		if IsMyFriend("Firstgroupunit") then
			return true
		end
	elseif string.find(arg1,"G2") then
		if IsMyFriend("Secondgroupunit") then
			return true
		end
	else
		return true
	end
	return false
end

function SendVC.Execute(arg1)
	if string.find(arg1,"SVC") then
		if string.find(arg1,"stop") then
			SendChatMessage("SendViaChat Stopping!", "CHANNEL", 0, 1);
			SendVC.Toggle(false)
		elseif string.find(arg1,"start") then
			SendChatMessage("SendViaChat Starting!", "CHANNEL", 0, 1);
			SendVC.Toggle(true)
		end
	elseif string.find(arg1,"AAI") then
		if string.find(arg1,"stop") then
			SendChatMessage("Stopping auto accept!", "CHANNEL", 0, 1);
			AutoAI.Toggle(false)
		elseif string.find(arg1,"start") then
			SendChatMessage("Starting auto accept!", "CHANNEL", 0, 1);
			AutoAI.Toggle(true)
		end
		if  string.find(arg1,"leave") then
			SendChatMessage("Leaving Party!", "CHANNEL", 0, 1);
			LeaveParty()
		end
	elseif string.find(arg1,"ABG") then
		if string.find(arg1,"stop") then
			SendChatMessage("Access Granted, Stopping!", "CHANNEL", 0, 1);
			AutoBG.Toggle(false)
		elseif string.find(arg1,"start") then
			SendChatMessage("Access Granted, Starting!", "CHANNEL", 0, 1);
			AutoBG.Toggle(true)
		end
	end
end