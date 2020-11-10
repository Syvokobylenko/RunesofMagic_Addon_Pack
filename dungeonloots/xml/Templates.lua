function DL_CheckLabelTemplate_OnClick(this)
	if this.func then
		this.func(this)
	end
end

function DL_Tab_Template_OnClick(this, override)
	local parent = this:GetParent()
	if PanelTemplates_GetSelectedTab(parent) ~= this:GetID() or override then
		if this.func then
			this.func();
		end
		if this.frame and type(parent.numTabs) == "number" then
			PanelTemplates_SetTab(parent, this:GetID());
			if _G[this.frame] then
				for i = 1, parent.numTabs do
					if _G[parent:GetName() .. "Tab" .. i].frame then
						if _G[_G[parent:GetName() .. "Tab" .. i].frame] then
							_G[_G[parent:GetName() .. "Tab" .. i].frame]:Hide()
						end
					end
				end
				_G[this.frame]:Show()
			end
		end
	end
end

function DL_Tab_Template_OnEnter(this)
	local tooltip = this.tooltip
	if tooltip then
		GameTooltip:Show();
		GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 0, 0);
		if tooltip[1] then
			GameTooltip:SetText(tooltip[1])
		else
			GameTooltip:SetText("")
		end
		if type(tooltip[2]) == "table" then
			for i = 1, #tooltip[2] do
				GameTooltip:AddLine(tooltip[2][i])
			end
		elseif type(tooltip[2]) == "string" then
			GameTooltip:AddLine(tooltip[2])
		end
	end
end

function DL_Tab_Template_OnShow(this)
	local frame = this:GetName()
	local num = 1
	while _G[frame .. "Tab" .. num] do
		local tab = _G[frame .. "Tab" .. num]
		if tab.frame and type(_G[frame].numTabs) == "number" then
			if _G[tab.frame] and tab.visibleOnShow and tab.visibleOnShow == true then
				DL_Tab_Template_OnClick(tab, true)
			end
		end
		num = num + 1
	end
end
--[[
this:
parent frame
tbl

tooltip=[ {"Title", {"Text"}}, nil] -> Mouseover
text = Buttontext
func = function called onClick
frame=[frame , nil] -> anzuzeigendes Frame
ShowFunc
enableFunc
visibleOnShow
override
]]

function DL_button_SetTab(this, tbl)
	if this then
		local frame = this:GetName()
		local num = 1
		PanelTemplates_SetNumTabs(this, #tbl);
		local ignore = 0
		while _G[frame .. "Tab" .. num] do
			local tab = frame .. "Tab" .. num
			if type(tbl[num + ignore]) == "table" then
				_G[tab]:Show()
				if tbl[num + ignore].ShowFunc then
					if loadstring(tbl[num + ignore].ShowFunc)() == false then
						ignore = ignore + 1
						_G[tab]:Hide()
						_G[tab]:SetText("")
						_G[tab].tooltip = nil
						_G[tab].func = nil
						_G[tab].visibleOnShow = nil
						_G[tab].frame = nil
						num = num - 1
					end
				end
				if tbl[num + ignore].enableFunc then
					if loadstring(tbl[num + ignore].enableFunc)() then
						_G[tab]:Enable()
					else
						_G[tab]:Disable()
					end
				else
					_G[tab]:Enable()
				end
				if tbl[num + ignore].text then
					_G[tab]:SetText(tbl[num + ignore].text)
				else
					_G[tab]:SetText("")
				end
				PanelTemplates_TabResize(_G[tab], 0);
				if tbl[num + ignore].tooltip then
					_G[tab].tooltip = tbl[num + ignore].tooltip
				else
					_G[tab].tooltip = nil
				end
				if type(tbl[num + ignore].func) == "function" then
					_G[tab].func = tbl[num + ignore].func
				else
					_G[tab].func = nil
				end
				if type(tbl[num + ignore].visibleOnShow) then
					_G[tab].visibleOnShow = tbl[num + ignore].visibleOnShow
				else
					_G[tab].visibleOnShow = nil
				end
				if type(tbl[num + ignore].frame) == "string" then
					_G[tab].frame = tbl[num + ignore].frame
					if _G[_G[tab].frame] and _G[_G[tab].frame]:IsVisible() then
						PanelTemplates_SetTab(this, num);
					end
				else
					_G[tab].frame = nil
				end
			else
				_G[tab]:Hide()
				_G[tab]:SetText("")
				_G[tab].tooltip = nil
				_G[tab].func = nil
				_G[tab].visibleOnShow = nil
				_G[tab].frame = nil
			end
			num = num + 1
		end
	end
end
