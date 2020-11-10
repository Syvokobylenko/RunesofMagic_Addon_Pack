local me = {
	frame = "EventHelper_Adv",
}

function me.Init()
	me.InitTabs()
	me.InitConfig()
	me.InitDebugger()
	
end

function me.SetActive(val)
	EventHelper_Adv_config_Active:SetChecked(val)
end

function me.OnLoad(this)

end

function me.OnShow()
	
end


function me.OnEvent(this, event)
	if not _G[me.frame]:IsVisible() then return end

end

function me.OnUpdate()

end

function me.CheckButtonClick(val, frame)
	if frame=="active" then
		ev.fn.SetActive(val)

	elseif frame=="MessagesToOwn" then
		ev.Settings.main.MessagesToOwn = val
	elseif frame=="MessagesToSystem" then
		ev.Settings.main.MessagesToSystem = val
	elseif frame=="MessagesToWarning" then
		ev.Settings.main.MessagesToWarning = val
	elseif frame=="MessagesToChat" then
		ev.Settings.main.MessagesToChat = val

	elseif frame=="ChatMessages" then
		ev.Settings.main.ChatMessages = val
	elseif frame=="ChatMessagesToChat" then
		ev.Settings.main.ChatMessagesToChat = val
		
	elseif frame=="sound" then
		ev.Settings.main.sound = val
	elseif frame=="debug" then
		ev.Settings.main.debug = val
		me.InitTabs()
	elseif frame=="messagemover" then
		ev.fn.ToggleMessageMover(val)
	elseif frame=="" then
	elseif frame=="" then
	else
		print(frame .. " unknown")
	end
end
-------------------------------------------------------
--------------- Init funtions --------------------
-------------------------------------------------------
function me.InitTabs() --/run ev.ui.advframe.InitTabs()
	local maintabs = {
		{text = ev.helper.ReturnLoca("ui_config"), frame = me.frame.."_config", visibleOnShow = true },
		{text = ev.helper.ReturnLoca("ui_debug"), ShowFunc="return ev.Settings.main.debug",  frame = me.frame.."_debug"},
		{text = TEXT("CLOSE"), func = loadstring("ToggleUIFrame("..me.frame..")")},
	}
	EventHelper_button_SetTab(_G[me.frame.."_tabHeader"], maintabs)
end

function me.InitConfig()
	EventHelper_Adv_config_Active_Label:SetText(ev.helper.ReturnLoca("ui_active"))
	
	
	EventHelper_Adv_config_MessagesToOwn_Label:SetText(ev.helper.ReturnLoca("ui_msgtoown"))
	EventHelper_Adv_config_MessagesToOwn:SetChecked(ev.Settings.main.MessagesToOwn)
	
	EventHelper_Adv_config_MessagesToSystem_Label:SetText(ev.helper.ReturnLoca("ui_msgtosys"))
	EventHelper_Adv_config_MessagesToSystem:SetChecked(ev.Settings.main.MessagesToSystem)
	
	EventHelper_Adv_config_MessagesToWarning_Label:SetText(ev.helper.ReturnLoca("ui_msgtowarn"))
	EventHelper_Adv_config_MessagesToWarning:SetChecked(ev.Settings.main.MessagesToWarning)
	
	EventHelper_Adv_config_MessagesToChatButton:SetText(ev.helper.ReturnLoca("ui_msgtochat"))
	EventHelper_Adv_config_MessagesToChat:SetChecked(ev.Settings.main.MessagesToChat)
	UIDropDownMenu_Initialize(EventHelper_Adv_config_MessageToChatDropdown, me.MessageToChatDropdown);
	
	
	
	EventHelper_Adv_config_ChatMessages_Label:SetText(ev.helper.ReturnLoca("ui_chatmsg"))
	EventHelper_Adv_config_ChatMessages:SetChecked(ev.Settings.main.ChatMessages)
	
	EventHelper_Adv_config_ChatMessagesToChatButton:SetText(ev.helper.ReturnLoca("ui_chatmsgtochat"))
	EventHelper_Adv_config_ChatMessagesToChat:SetChecked(ev.Settings.main.ChatMessagesToChat)
	UIDropDownMenu_Initialize(EventHelper_Adv_config_ChatMessageToChatDropdown, me.ChatMessagesToChatDropdown);
	
	
	EventHelper_Adv_config_Sound_Label:SetText(ev.helper.ReturnLoca("ui_sound"))
	EventHelper_Adv_config_Sound:SetChecked(ev.Settings.main.sound)
	
	EventHelper_Adv_config_Debug_Label:SetText(ev.helper.ReturnLoca("ui_debug"))
	EventHelper_Adv_config_Debug:SetChecked(ev.Settings.main.debug)
	
	EventHelper_Adv_config_MoveMessage_Label:SetText(ev.helper.ReturnLoca("ui_movemessage"))
	EventHelper_Adv_config_MoveMessage:SetChecked(false)
end


-------------------------------------------------------
---------------- Dropdown funtions --------------------
-------------------------------------------------------

function me.MessageToChatDropdown()
	local menuitem = {}
	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
		local menuitem = {}
		for i=1,8 do
			local name=GetChatWindowInfo(i)
			if name==nil or name == "" then
				if ( i == 1 ) then
					name = TEXT("GENERAL");
				elseif ( i == 2 ) then
					name = TEXT("COMBAT_LOG");
				elseif ( i == 3 ) then
					name = TEXT("PARTY");
				elseif ( i == 4 ) then
					name = TEXT("GUILD");
				elseif ( i == 5 ) then
					name = TEXT("SALE");
				else
					name = string.format("ChatFrame %d", i) 
				end
			end
			menuitem.text = string.format("%d: %s", i, name);
			menuitem.func = function()
				ev.Settings.main.MessagesToChat_chats[i] = not ev.Settings.main.MessagesToChat_chats[i]
			end
			menuitem.keepShownOnClick = 1;
			menuitem.checked=ev.Settings.main.MessagesToChat_chats[i]
			UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL);
		end
	end
end

function me.ChatMessagesToChatDropdown()
	local menuitem = {}
	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
		local menuitem = {}
		for i=1,8 do
			local name=GetChatWindowInfo(i)
			if name==nil or name == "" then
				if ( i == 1 ) then
					name = TEXT("GENERAL");
				elseif ( i == 2 ) then
					name = TEXT("COMBAT_LOG");
				elseif ( i == 3 ) then
					name = TEXT("PARTY");
				elseif ( i == 4 ) then
					name = TEXT("GUILD");
				elseif ( i == 5 ) then
					name = TEXT("SALE");
				else
					name = string.format("ChatFrame %d", i) 
				end
			end
			menuitem.text = string.format("%d: %s", i, name);
			menuitem.func = function()
				ev.Settings.main.ChatMessagesToChat_chats[i] = not ev.Settings.main.ChatMessagesToChat_chats[i]
			end
			menuitem.keepShownOnClick = 1;
			menuitem.checked=ev.Settings.main.ChatMessagesToChat_chats[i]
			UIDropDownMenu_AddButton(menuitem, UIDROPDOWNMENU_MENU_LEVEL);
		end
	end
end

-------------------------------------------------------
------------------- Debugger frame --------------------
-------------------------------------------------------

function me.InitDebugger()

end

-------------------------------------------------------
--------------- Scrollbar funtions --------------------
-------------------------------------------------------
function me.Scroll(this, delta)
	if (delta > 0) then
		this:SetValue(this:GetValue() - 2);
	elseif (delta < 0) then
		this:SetValue(this:GetValue() + 2);
	end;
end;

function me.OnValueChanged(this)
	local min, max = this:GetMinMaxValues()
	_G[me.frame.."_ScrollBarScrollDownButton"]:Enable()
	_G[me.frame.."_ScrollBarScrollUpButton"]:Enable()
	if this:GetValue() == min then
	_G[me.frame.."_ScrollBarScrollUpButton"]:Disable()
	end
	if this:GetValue() == max then
	_G[me.frame.."_ScrollBarScrollDownButton"]:Disable()
	end
	me.RedrawList()
	--me.ShowHighlight()
end

-------------------------------------------------------
----------------- List function -----------------------
-------------------------------------------------------
function me.FilterList()
	me.FilteredList = {}
	local cmp = _G[me.frame.."_Search"]:GetText()
	for a,b in pairs(ev.register) do
		if type(b)=="table" and b.GetName then
			if string.match(b.GetName(), cmp) then
				table.insert(me.FilteredList, {a,b})
			end
		else
			if string.match(a, cmp) then
				table.insert(me.FilteredList, {a,b})
			end
		end
	end
end

function me.RedrawList()
	local tbl = me.FilteredList
	local maxval = #tbl - 20 + 1
	if (maxval < 1) then maxval = 1; end;
	EventHelper_Main_ScrollBar:SetMinMaxValues(1, maxval);
	local val = EventHelper_Main_ScrollBar:GetValue();
	for i = 1, 20 do
		local btn ="EventHelper_Main_list_Button"..i;
		local index = i + val - 1;
		if tbl[index] then
			if type(tbl[index][2])=="table" and tbl[index][2].GetName then
				_G[btn.."_txt"]:SetText(tbl[index][2].GetName())
			else
				_G[btn.."_txt"]:SetText(tbl[index][1])
			end
			if type(tbl[index][2])=="table" then
				if (tbl[index][2].IsActive and tbl[index][2].IsActive()) or tbl[index][2].IsActive==nil then
					_G[btn.."_active"]:SetColor(0,1,0)
				else
					_G[btn.."_active"]:SetColor(1,1,0)
				end
			else
				_G[btn.."_active"]:SetColor(1,0,0)
			end
			_G[btn]:Show()
		else
			_G[btn]:Hide()
		end
	end
end


-------------------------------------------------------
--------------- List Button function ------------------
-------------------------------------------------------

function me.ListHead_OnClick(this, key)

end

ev.ui.advframe = me;
