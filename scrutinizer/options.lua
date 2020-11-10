local scrutinizer = scrutinizer

local tostring = tostring

local function OptionsMenu(this)
	local info = {}
	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
		info = {}
		info.text = UI_WORLDMAP_SETUP
		info.isTitle = true
		info.notCheckable = 1
		info.value = 1
		UIDropDownMenu_AddButton(info, 1)	

		info = {}
		info.text = STR_CHAT_SEND
		info.notCheckable = 1
		info.hasArrow = 1
		info.value = 2
		UIDropDownMenu_AddButton(info, 1)		
		
		info = {}
		info.text = OBJ_RESET
		info.notCheckable = 1
		info.hasArrow = 1
		info.value = 3
		UIDropDownMenu_AddButton(info, 1)		

		info = {}
		info.text = OBJ_SHOW
		info.notCheckable = 1
		info.hasArrow = 1
		info.value = 4
		UIDropDownMenu_AddButton(info, 1)
		
		info = {}
		info.text = RAIDFRAME_BUF_SIZE
		info.hasArrow = 1
		info.notCheckable = 1
		info.value = 5
		UIDropDownMenu_AddButton(info, 1)
		
		info = {}
		info.text = UI_WORLDMAP_ALPHA
		info.hasArrow = 1
		info.notCheckable = 1
		info.value = 6
		UIDropDownMenu_AddButton(info, 1)		

		info = {}
		info.text = GCF_GROUP_MSIC
		info.notCheckable = 1
		info.hasArrow = 1
		info.value = 7
		UIDropDownMenu_AddButton(info, 1)
		
		info = {}
		info.text = SYSTEM_CLOSE
		info.notCheckable = 1
		info.func = function()
			scrutinizer.cfg.shown = scrutinizer:Toggle("scrutinizer_MainFrame")
			scrutinizer:Print("/scrutinizer toggle", 1, 1, 1)
		end
		info.value = 8
		UIDropDownMenu_AddButton(info, 1)		
		
		info = {}
		info.text = C_CANCEL
		info.notCheckable = 1
		info.func = function() end
		info.value = 9
		UIDropDownMenu_AddButton(info, 1)

	elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then
		if UIDROPDOWNMENU_MENU_VALUE == 2 then
			info = {}
			info.text = MESSAGE_SAY
			info.func = function()
				scrutinizer:SendToSay()
			end
			info.value = 1
			UIDropDownMenu_AddButton(info, 2)
			
			info = {}
			info.text = MESSAGE_GUILD
			info.func = function()
				scrutinizer:SendToGuild()
			end
			info.value = 2
			UIDropDownMenu_AddButton(info, 2)

			info = {}
			info.text = BINDING_NAME_CHAT_PARTY
			info.func = function()
				scrutinizer:SendToParty()
			end
			info.value = 3
			UIDropDownMenu_AddButton(info, 2)
			
			info = {}
			info.text = MESSAGE_WHISPER
			info.func = function()
				scrutinizer:SendToWhisper()
			end
			info.value = 4
			UIDropDownMenu_AddButton(info, 2)
			
			info = {}
			info.text = CHANNEL
			info.func = function()
				scrutinizer:SendToChannel()
			end
			info.value = 5
			UIDropDownMenu_AddButton(info, 2)
		elseif UIDROPDOWNMENU_MENU_VALUE == 3 then
			info = {}
			info.text = C_CONFIRM_CHANGE..": "..NO
			info.func = function()
				if scrutinizer.cfg.autoreset then
					scrutinizer.cfg.autoreset = false
				else
					scrutinizer.cfg.autoreset = true
					scrutinizer.cfg.resetjoin = false
				end
			end
			info.checked = scrutinizer.cfg.autoreset
			info.value = 1
			UIDropDownMenu_AddButton(info, 2)		
		
			info = {}
			info.text = LUA_FRIEND_MENU_NEWGROUP..": "..INQUIRE
			info.func = function()
				if scrutinizer.cfg.resetjoin then
					scrutinizer.cfg.resetjoin = false
				else
					scrutinizer.cfg.resetjoin = true
					scrutinizer.cfg.autoreset = false
				end
			end
			info.checked = scrutinizer.cfg.resetjoin
			info.value = 2
			UIDropDownMenu_AddButton(info, 2)
			
		
		elseif UIDROPDOWNMENU_MENU_VALUE == 4 then
			info = {}
			info.text = CHAT_MSG_PARTY .. "-Bar"
			info.func = function()
				scrutinizer.cfg.showpartybar = scrutinizer:Toggle("scrutinizer_MainFrame_Group")
				scrutinizer:UpdateMainFrame()
				scrutinizer:UpdateAnchors()
			end
			info.checked = scrutinizer.cfg.showpartybar
			info.value = 1
			UIDropDownMenu_AddButton(info, 2)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == 5 then
			for i = -5, 10 do
				info = {}
				info.text = tostring(i)
				info.func = function()
					scrutinizer.cfg.scale = i
					scrutinizer:ScaleFrames(scrutinizer.cfg.scale)
				end
				if i == scrutinizer.cfg.scale then
					info.checked = true
				else
					info.checked = false
				end
				info.value = i + 6
				UIDropDownMenu_AddButton(info, 2)
			end
		elseif UIDROPDOWNMENU_MENU_VALUE == 6 then
			for i = 0, 10 do
				info = {}
				info.text = tostring(i)
				info.func = function()
					scrutinizer.cfg.alpha = i
					scrutinizer:SetAlpha(scrutinizer.cfg.alpha)
				end
				if i == scrutinizer.cfg.alpha then
					info.checked = true
				else
					info.checked = false
				end
				info.value = i + 1
				UIDropDownMenu_AddButton(info, 2)
			end
		elseif UIDROPDOWNMENU_MENU_VALUE == 7 then
			info = {}
			info.text = scrutinizer.addon .. " V" .. scrutinizer.version .. " " .. scrutinizer.author
			info.isTitle = true
			info.notCheckable = 1
			info.value = 1
			UIDropDownMenu_AddButton(info, 2)
			
			info = {}
			info.text = CHANNEL_CHANGE_LOCK
			info.func = function()
				if scrutinizer.cfg.pinned then
					scrutinizer.cfg.pinned = false
					scrutinizer_MainFrame_Head_MoveButton:Show()
				else
					scrutinizer.cfg.pinned = true
					scrutinizer_MainFrame_Head_MoveButton:Hide()
				end
			end
			info.checked = scrutinizer.cfg.pinned
			info.value = 2
			UIDropDownMenu_AddButton(info, 2)			
		end
	end
end

function scrutinizer:OptionsOnLoad(this)
	UIDropDownMenu_Initialize(this, OptionsMenu, "MENU")
end