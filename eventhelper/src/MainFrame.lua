local me = {
	frame = "EventHelper_Main",
	FilteredList = {},
	update = nil,
	maintable = {
		type = 0, -- 0 scripts; 1 config
	}
}

function me.Init()
	_G[me.frame.."_name"]:SetText(ev.name)
	_G[me.frame.."_info"]:SetText(ev.helper.ReturnLoca("ui_version",ev.ver))
	_G[me.frame.."_MoreButton"]:SetText(ev.helper.ReturnLoca("ui_more"))
end

function me.OnLoad(this)
	this:RegisterEvent("LOADING_END")
	for i=1,20 do
		_G["EventHelper_Main_list_Button"..i.."_active"]:SetTexture("interface/AddOns/Eventhelper/img/round32x32.tga")
		_G["EventHelper_Main_list_Button"..i.."_active"]:Show()
		_G["EventHelper_Main_list_Button"..i.."_check"]:Show()
	end
	
	_G[me.frame.."_list"].OnClickFn = me.ListCheckButton_OnClick
	_G[me.frame.."_list"].OnScrollFn = me.Scroll
	_G[me.frame.."_list"].Scrollbar = _G[me.frame.."_ScrollBar"]
	
	_G[me.frame.."_list_Button0"].OnClickFn = me.ListHead_OnClick
	
	_G[me.frame.."_ScrollBar"].OnScrollFn = me.Scroll
	_G[me.frame.."_ScrollBar"].OnValueChangedFn = me.OnValueChanged
end

function me.OnShow()
	me.FilterList()
	me.RedrawList()
	me.SetTableType(0)
end

function me.SetTableType(num)
	_G[me.frame.."_Search"]:SetText("")
	if num==1 then -- config
		me.maintable.type=1
		_G[me.frame.."_list_Button0"]:SetText(ev.helper.ReturnLoca("ui_scriptconfig", "todo"))
	else -- script list
		me.maintable.type=0
		_G[me.frame.."_list_Button0"]:SetText(ev.helper.ReturnLoca("ui_scripts"))
	end
end

function me.OnEvent(this, event)
	if not EventHelper_Main:IsVisible() then return end
	if event=="LOADING_END" then
		me.RedrawList()
	end
end

function me.OnUpdate()
	if me.update and me.update+0.2<GetTime() then
		me.FilterList()
		me.RedrawList()
		me.update = nil
	end
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
			if type(tbl[index][2])=="table" then
				if tbl[index][2].GetName then
					_G[btn.."_txt"]:SetText(tbl[index][2].GetName())
				end
				_G[btn.."_check"]:SetChecked(type(tbl[index][2].GetSettings)~="function" or tbl[index][2].GetSettings().active)
				_G[btn.."_check"]:Enable()
			else
				_G[btn.."_txt"]:SetText(tbl[index][1])
				_G[btn.."_check"]:SetChecked(false)
				_G[btn.."_check"]:Disable()
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

function me.ListCheckButton_OnClick(id, typ, val)
	local index = id + EventHelper_Main_ScrollBar:GetValue() - 1;
	if typ=="check" then
		local script = ev.register[me.FilteredList[index][1]]
		local values=script.GetSettings()
		values.active=val;
		script.SetSettings(values)
	end
end

function me.ListHead_OnClick(this, key)
	me.SetTableType(me.maintable.type-1)
	me.FilterList()
	me.RedrawList()
end

ev.ui.mainframe = me;
