--ExtendedMacroIcons v2
--By Amurilon
CURRENTMACROICONCAT = 1;
CURRENTMACROSELECTEDICONCAT = 1;

EMI_MAX_NUM_MACROS = 56
EMI_NUM_MACRO_ICONS_SHOWN = 45;
EMI_NUM_ICONS_PER_ROW = 5;
EMI_NUM_ICON_ROWS = 9;

ExtendedMacroIcons = {
	originalMacroFrame = {},
	iconlist = {
	 {name="Default Icons",prefix ="",},
	},
	func = {
		MacroFrame = {
			OnLoad = function(this)
				UIPanelFrame_Initialize(this, nil, nil)
				EMI_MacroFrameTitleText:SetText("Extended Macro Interface")
				local button
				for i = 1, EMI_MAX_NUM_MACROS do
					button = getglobal("EMI_MacroButton"..i)
					button:ClearAllAnchors()
					if ( i == 1 ) then
						button:SetAnchor("TOPLEFT", "TOPLEFT", this:GetName(), 32, 46)
					elseif ( i <= 7 ) then
						button:SetAnchor("LEFT", "RIGHT", "EMI_MacroButton"..(i-1), 4, 0)
					else
						button:SetAnchor("TOPLEFT", "BOTTOMLEFT", "EMI_MacroButton"..(i-7), 0, 6)
					end
				end
				ExtendedMacroIcons.func.MacroFrame.SelectMacro(1)
				this:RegisterEvent("MACROFRAME_UPDATE")
			end,
			OnShow = function(this)
				ExtendedMacroIcons.func.MacroFrame.Update()
			end,
			OnEvent = function(this)
				if ( event == "MACROFRAME_UPDATE" ) then
					ExtendedMacroIcons.func.MacroFrame.Update()
				end
			end,
			OnClick = function(this)
				if ( EMI_MacroPopupFrame:IsVisible() ) then
					return;
				end

				if ( CursorItemType() == "macro" ) then
					PickupMacroItem(this:GetID());
					return;
				end

				ExtendedMacroIcons.func.MacroFrame.SelectMacro(this:GetID())
				ExtendedMacroIcons.func.MacroFrame.Update()
			end,
			SelectMacro = function(id)
				EMI_MacroFrame.selectedMacro = id;
			end,
			Update = function()
				local button, buttonName, buttonIcon;
				local name, icon, body;
				for i = 1, EMI_MAX_NUM_MACROS do
					button = getglobal("EMI_MacroButton"..i);
					buttonName = getglobal("EMI_MacroButton"..i.."Name");
					buttonIcon = getglobal("EMI_MacroButton"..i.."Icon");

					button:SetID(i)

					if ( HasMacro(i) ) then
						icon, name, body = GetMacroInfo(i);
						buttonName:SetText(name);
						buttonIcon:SetTexture(GetMacroIconInfo(icon));
					else
						buttonName:SetText("");
						buttonIcon:SetTexture("");
					end

					if ( i == EMI_MacroFrame.selectedMacro ) then
						button:SetChecked(true);
					else
						button:SetChecked(false);
					end
				end

				ExtendedMacroIcons.func.MacroEditButton.Update();
			end,
		},
		MacroEditButton = {
			Update = function()
				if ( HasMacro(EMI_MacroFrame.selectedMacro) ) then
					EMI_MacroEditButton:SetText(TEXT("MACRO_MODIFY"));
					EMI_MacroResetButton:Enable();
				else
					EMI_MacroEditButton:SetText(TEXT("MACRO_CREATE"))
					EMI_MacroResetButton:Disable();
				end
			end,
			OnClick = function(this)
				EMI_MacroPopupFrame:Show()
			end,
		},
		MacroResetButton = {
			OnClick = function(this)
				StaticPopup_Show("EMI_MACRO_RESET_CONFIRM");
			end,
		},
		MacroPopupFrame = {
			OnShow = function(this)
				ExtendedMacroIcons.func.MacroPopupFrame.Update()
			end,
			UpdateIcon = function(icon)
				EMI_MacroPopupFrame.selectedIcon = icon;
				EMI_MacroPopupIconButtonIcon:SetTexture(GetMacroIconInfo(EMI_MacroPopupFrame.selectedIcon));

				if ( EMI_MacroPopupFrame.selectedIcon ) then
					EMI_MacroPopupSaveButton:Enable();
				else
					EMI_MacroPopupSaveButton:Disable();
				end
			end,
			Update = function()
				local icon, name, body = GetMacroInfo(EMI_MacroFrame.selectedMacro);
				if ( not icon ) then
					icon = 1;
				end
				if ( not name ) then
					name = "";
				end
				if ( not body ) then
					body = "";
				end
				ExtendedMacroIcons.func.MacroPopupFrame.UpdateIcon(icon)
				EMI_MacroPopupNameEdit:SetText(name);
				EMI_MacroPopupBodyEdit:SetText(body);
			end,
		},
		MacroPopupSaveButton = {
			OnClick = function(this)
				EditMacro(EMI_MacroFrame.selectedMacro, EMI_MacroPopupNameEdit:GetText(), EMI_MacroPopupFrame.selectedIcon, EMI_MacroPopupBodyEdit:GetText());
				HideUIPanel(EMI_MacroPopupFrame);
				ExtendedMacroIcons.func.MacroFrame.Update()
			end,
		},
		MacroPopupIconButton = {
			OnClick = function(this)
				MACRO_POPUP_ICON_SELECTED = this.index;
				CURRENTMACROSELECTEDICONCAT = CURRENTMACROICONCAT
				ExtendedMacroIcons.func.MacroPopupIconFrame.Update();
			end,
		},
		MacroPopupIconOkayButton = {
			OnClick = function(this)
				local icon = tonumber(ExtendedMacroIcons.iconlist[CURRENTMACROSELECTEDICONCAT].prefix..MACRO_POPUP_ICON_SELECTED)
				ExtendedMacroIcons.func.MacroPopupFrame.UpdateIcon(icon);
				EMI_MacroPopupIconFrame:Hide();
			end,
		},
		MacroPopupIconFrame = {
			OnShow = function(this)
				CURRENTMACROICONCAT = 1
				CURRENTMACROSELECTEDICONCAT = 1;
				local prefix
				local suffix = EMI_MacroPopupFrame.selectedIcon
				if EMI_MacroPopupFrame.selectedIcon > GetNumMacroIcons() then
					prefix = string.sub(EMI_MacroPopupFrame.selectedIcon,1,5)
					for k,v in ipairs(ExtendedMacroIcons.iconlist) do
						if prefix == v.prefix then
							CURRENTMACROICONCAT = k
							CURRENTMACROSELECTEDICONCAT = k;
						end
					end
					suffix = tonumber(string.sub(EMI_MacroPopupFrame.selectedIcon,6))
				end
				getglobal("EMI_CatFrameButtonDropdownText"):SetText(ExtendedMacroIcons.iconlist[CURRENTMACROICONCAT].name)

				MACRO_POPUP_ICON_SELECTED = suffix
				local numPages = 0;
				if ( MACRO_POPUP_ICON_SELECTED > EMI_NUM_MACRO_ICONS_SHOWN ) then
					numPages = math.floor((MACRO_POPUP_ICON_SELECTED - EMI_NUM_MACRO_ICONS_SHOWN - 1) / EMI_NUM_ICON_ROWS) + 1;
				end
				EMI_MacroPopupIconScrollBar:SetMaxValue(math.floor(GetNumMacroIcons()/EMI_NUM_ICON_ROWS))
				EMI_MacroPopupIconScrollBar:SetValue(numPages);
				ExtendedMacroIcons.func.MacroPopupIconScrollBar.OnValueChanged(EMI_MacroPopupIconScrollBar, numPages);
			end,
			Update = function()
				local icon, index, button;
				local maxNums = GetNumMacroIcons();
				local index = EMI_MacroPopupIconScrollBar:GetValue() * EMI_NUM_ICON_ROWS + 1;
				for i = 1, EMI_NUM_MACRO_ICONS_SHOWN do
					button = getglobal("EMI_MacroPopupIconButton"..i);
					button.index = index;
					if ( index <= maxNums ) then
						local preindex = tonumber(ExtendedMacroIcons.iconlist[CURRENTMACROICONCAT].prefix..index)
						icon = GetMacroIconInfo(preindex);
						getglobal("EMI_MacroPopupIconButton"..i.."Icon"):SetTexture(icon);
						button.index = index;
						button.path = icon
						if ( button.index == MACRO_POPUP_ICON_SELECTED and CURRENTMACROICONCAT == CURRENTMACROSELECTEDICONCAT ) then
							button:SetChecked(true);
						else
							button:SetChecked(false);
						end
						button:Show();
					else
						button:Hide();
					end
					index = index + 1;
				end
			end,
		},
		MacroPopupIconScrollBar = {
			OnValueChanged = function(this, arg1)
				UIPanelScrollBar_OnValueChanged(this, arg1);
				ExtendedMacroIcons.func.MacroPopupIconFrame.Update();
			end,
		},


		OnEvent = function(this,event,arg1, arg2, arg3, arg4)
			if event == "VARIABLES_LOADED" then

				Sol.hooks.Hook("ExtendedMacroIcons", "GetNumMacroIcons", ExtendedMacroIcons.func.GetNumMacroIcons);
				Sol.hooks.Hook("ExtendedMacroIcons", "GetMacroIconInfo", ExtendedMacroIcons.func.GetMacroIconInfo);
				Sol.hooks.Hook("ExtendedMacroIcons", "GetActionInfo", ExtendedMacroIcons.func.GetActionInfo);

				--Sol.hooks.Hook("ExtendedMacroIcons", "MacroEditButton_OnClick", ExtendedMacroIcons.func.MacroEditButton_OnClick);
				--Sol.hooks.Hook("ExtendedMacroIcons", "MacroFrame_OnShow", ExtendedMacroIcons.func.MacroFrame_OnShow);
				--Sol.hooks.Hook("ExtendedMacroIcons", "MacroPopupIconFrame_OnShow", ExtendedMacroIcons.func.MacroPopupIconFrame_OnShow);
				--Sol.hooks.Hook("ExtendedMacroIcons", "ActionButton_Update", ExtendedMacroIcons.func.ActionButton_Update);
				--Sol.hooks.Hook("ExtendedMacroIcons", "MacroPopupIconFrame_Update", ExtendedMacroIcons.func.MacroPopupIconFrame_Update);
				--Sol.hooks.Hook("ExtendedMacroIcons", "MacroPopupIconButton_OnClick", ExtendedMacroIcons.func.MacroPopupIconButton_OnClick);
				--Sol.hooks.Hook("ExtendedMacroIcons", "MacroPopupIconOkayButton_OnClick", ExtendedMacroIcons.func.MacroPopupIconOkayButton_OnClick);

				local func, err = loadfile("Interface/Addons/ExtendedMacroIcons/ExtendedMacroIcon_include.lua");
				if (not err) then
					local list=func()
					for k,v in ipairs(list) do
						local func2, err2 = loadfile("Interface/Addons/ExtendedMacroIcons/icons/"..v[1]);
						if (not err2) then
							local icons=func2()
							local tab ={}
							for k2,v2 in ipairs(icons) do
								table.insert(tab,v2)
							end
							tab.name = v[2]
							tab.prefix = v[3]
							table.insert(ExtendedMacroIcons.iconlist,tab)
						else
						bug(err2, true)
						end
					end
				end

				EMI_MacroPopupIconScrollBar:SetMaxValue(math.floor(GetNumMacroIcons()/EMI_NUM_ICON_ROWS))
				ExtendedMacroIcons.originalMacroFrame = MacroFrame
				MacroFrame = EMI_MacroFrame
				UIPanelWindows["EMI_MacroFrame"] = { area ="left",wide = nil,layer = 0,setAnchor = 1 }
			end
		end,
		CatButtonOnClick = function(this)
			local direction
			direction = string.sub(this:GetName(),#(this:GetName())-3,#(this:GetName()))
			if direction == "Left" then
				CURRENTMACROICONCAT = CURRENTMACROICONCAT -1
			else
				CURRENTMACROICONCAT = CURRENTMACROICONCAT +1
			end
			if CURRENTMACROICONCAT < 1 then
				CURRENTMACROICONCAT = #(ExtendedMacroIcons.iconlist)
			elseif CURRENTMACROICONCAT > #(ExtendedMacroIcons.iconlist) then
				CURRENTMACROICONCAT = 1
			end
			getglobal(this:GetParent():GetName().."ButtonDropdownText"):SetText(ExtendedMacroIcons.iconlist[CURRENTMACROICONCAT].name)
			EMI_MacroPopupIconScrollBar:SetMaxValue(math.floor(GetNumMacroIcons()/EMI_NUM_ICON_ROWS))
			EMI_MacroPopupIconScrollBar:SetValue(0);
			ExtendedMacroIcons.func.MacroPopupIconScrollBar.OnValueChanged(EMI_MacroPopupIconScrollBar, 0);
		end,

		Dropdown = {
			UpdateDropdown = function(name, dropdown)
				catch(name and dropdown, "Cannot update button dropdown with invalid arguments!", name, dropdown)
				local Button = name

				if Button then
					Button.Dropdown = dropdown
				end
			end,
			ToggleDropdown = function(name, forceshow)
				local Button = name
				local ID = name:GetID()
				catch(Button, "Can't toggle dropdown for non existent button!", name)


				if not forceshow and awsmDropdown.IsVisible() then
					awsmDropdown.Close()
				else
					awsmDropdown.Anchor(Button, "TOP", "TOP",0,0)
					awsmDropdown.Open(Button.Dropdown)
					ZZLibrary.TooltipHide()
				end
			end,
			Build = function(id)
				local Dropdown = {}
				for k,v in ipairs(ExtendedMacroIcons.iconlist) do
					table.insert(Dropdown, {
						Title = v.name,
						Click = function()
							CURRENTMACROICONCAT = k
							getglobal("EMI_CatFrameButtonDropdownText"):SetText(ExtendedMacroIcons.iconlist[CURRENTMACROICONCAT].name)
							EMI_MacroPopupIconScrollBar:SetMaxValue(math.floor(GetNumMacroIcons()/EMI_NUM_ICON_ROWS))
							EMI_MacroPopupIconScrollBar:SetValue(0);
							ExtendedMacroIcons.func.MacroPopupIconScrollBar.OnValueChanged(EMI_MacroPopupIconScrollBar, 0);
							awsmDropdown.Close()
						end,
						Icon = GetMacroIconInfo(tonumber(v.prefix.."1")),
					})
				end
				return Dropdown
			end,
			Update = function(this)
				ExtendedMacroIcons.func.Dropdown.UpdateDropdown(this, ExtendedMacroIcons.func.Dropdown.Build(this:GetID()))
				ExtendedMacroIcons.func.Dropdown.ToggleDropdown(this, true)
			end,
		},

		--hooked functions
		GetNumMacroIcons = function()
			local originalGetNumMacroIcons = Sol.hooks.GetOriginalFn("ExtendedMacroIcons", "GetNumMacroIcons")
			local num
			if CURRENTMACROICONCAT == 1 then
				num = originalGetNumMacroIcons()
			else
				if ExtendedMacroIcons.iconlist[CURRENTMACROICONCAT] then
					num = #ExtendedMacroIcons.iconlist[CURRENTMACROICONCAT]
				else
					num = 0
				end
			end
			return num
		end,
		GetMacroIconInfo = function(iconnum)
			local originalGetMacroIconInfo = Sol.hooks.GetOriginalFn("ExtendedMacroIcons", "GetMacroIconInfo")
			local originalGetNumMacroIcons = Sol.hooks.GetOriginalFn("ExtendedMacroIcons", "GetNumMacroIcons")
			if iconnum > originalGetNumMacroIcons() then
				local prefix = string.sub(iconnum,1,5)
				local suffix = string.sub(iconnum,6)
				if #prefix < 5 or #suffix < 1 then
					originalGetMacroIconInfo(1)
				end
				for k,v in ipairs(ExtendedMacroIcons.iconlist) do
					if prefix == v.prefix then
						if tonumber(prefix) >= 90000 then
							return v[tonumber(suffix)]
						else
							if v[tonumber(suffix)] then
								return "Interface/"..v[tonumber(suffix)]
							end
						end
					end
				end

				-- return defaulticon if prefix not found
					return originalGetMacroIconInfo(1)


			else
				return originalGetMacroIconInfo(iconnum)
			end
		end,
		GetActionInfo = function(id)
			local originalGetActionInfo = Sol.hooks.GetOriginalFn("ExtendedMacroIcons", "GetActionInfo")
			local icon_path, name, count, locked, wore, continued = originalGetActionInfo(id)
			if name ~= "" and icon_path == "Interface\\Icons\\Icon-Default" then
				local index = 0
				for i=1,EMI_MAX_NUM_MACROS do
					icon_index, macro_name, macro_body = GetMacroInfo(i)
					if macro_name and name == macro_name then
						index = icon_index
						break
					end
				end
				if index ~= 0 then icon_path = GetMacroIconInfo(index) end
			end
			return icon_path, name, count, locked, wore, continued
		end,
	},
}

StaticPopupDialogs["EMI_MACRO_RESET_CONFIRM"] = {
	text = TEXT("MACRO_RESET_CONFIRM"),
	button1 = TEXT("OKAY"),
	button2 = TEXT("CANCEL"),
	OnAccept = function(this)
		EditMacro(EMI_MacroFrame.selectedMacro);
		ExtendedMacroIcons.func.MacroFrame.Update()
	end,
	OnCancel = function(this)
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1
};
