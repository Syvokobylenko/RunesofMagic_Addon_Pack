local me = {
	frame="EventHelper_Minimap",
}

function me.Init()
	me.Tooltip = nil
	me.SetRing(false)
end

function me.SetActive(value)
	me.SetRing(value)
end

function me.SetRing(active)
	local green = _G[me.frame.."_Ring_green"]
	local red = _G[me.frame.."_Ring_red"]
	if active then
		green:Show()
		red:Hide()
	else
		green:Hide()
		red:Show()
	end
end

function me.OnClick(this, key)
	if key=="LBUTTON" then
		ToggleUIFrame(EventHelper_Main)
	else
		ev.fn.SetActive(not ev.fn.IsActive())
	end
end

function me.OnEnter(this)
	GameTooltip:Show();
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 0, 0);
	GameTooltip:SetText(ev.name)
	GameTooltip:AddSeparator();
	GameTooltip:AddLine(UI_MINIMAPBUTTON_MOVE, 0, 0.75, 0.95) -- Set move notification --
end

ev.ui.minimap = me;
