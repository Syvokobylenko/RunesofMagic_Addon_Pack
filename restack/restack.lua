restack = {
	Addonname       = "restack",
	Version         = "1.0.1",
	running	        = false,
	stopvalue       = 0,
	delay           = 0,
	checkvalue      = 0,
	oldvalue        = 0,
	i               = 0,
	j               = 0,
}

function restack.onLoad(frame)
	frame:RegisterEvent("VARIABLES_LOADED")
	SaveVariables("restackdb")
end


function restack.onUpdate(this, elapsedTime)
	if restack.delay > 0 then
		restack.delay = restack.delay - elapsedTime
		if restack.delay <= 0 then
			local _, _, name, itemCount = GetBagItemInfo(restack.checkvalue)
			if (itemCount == restack.oldvalue) then
				--restack.log("Wir lernen: "..name.." stackt sich bis "..itemCount)
				restackdb[name] = itemCount
			end
			restack.redo()
		end
	end
end


function restack.onEvent(event, this)
	if (event == "VARIABLES_LOADED") then
		local v = GetVersion()
		if not (restackdb) or (restackdb.version == nil) or (restackdb.version ~= v) then
			restackdb = { }
			restackdb.version = v
		end
	end
end


function restack.doit()
	if restack.running or CursorHasItem() then
		return
	end
	local occupiedSlots, availableSlots, totalSlots = GetBagCount()
	restack.stopvalue = totalSlots
	restack.i=1
	restack.j=2
	RestackButton:Disable()
	restack.running = true
	restack.redo()
end


function restack.resort(i,j,jcount)
	PickupBagItem(GetBagItemInfo(i))
	PickupBagItem(GetBagItemInfo(j))
	restack.j = restack.j+1
	restack.checkvalue = j
	restack.oldvalue = jcount
	restack.delay = 1
end


function restack.redo()
	for i=restack.i,restack.stopvalue-1 do
		restack.i = i
		local inventoryIndex, _, name, itemCount = GetBagItemInfo(i)
		for j=restack.j,restack.stopvalue do
			restack.j = j
			local inventoryIndex2, _, name2, itemCount2 = GetBagItemInfo(j)
			if (name == name2) and ((itemCount > 1) or (itemCount2 > 1)) then
				local maxi = 0
				if restackdb[name] ~= nil then
					maxi = restackdb[name];
				end
				if (itemCount ~= maxi) and (itemCount2 ~= maxi) then
					if itemCount < itemCount2 then
						restack.resort(i, j, itemCount2)
						return
					else
						restack.resort(j, i, itemCount)
						return
					end
				end
				
			end
		end
		restack.j = restack.i+2
	end
	RestackButton:Enable()
	restack.running = false
end


function restack.setTooltip(this)
	GameTooltip:SetOwner(this, "ANCHOR_TOPLEFT", 4, 0);
	GameTooltip:SetText("Restack v"..restack.Version);
	local language = string.upper(string.sub(GetLanguage(),1,2));
	if language == "DE" then
		GameTooltip:AddLine("Füllt halbvolle Stacks im Rucksack durch Umsortierung auf und kann so mehr Platz schaffen.");
	else
		GameTooltip:AddLine("Fills up half-full stacks in the backpack by resorting and can make room this way.");
	end
	GameTooltip:AddLine(UI_MINIMAPBUTTON_MOVE, 0, 0.75, 0.95);
end


function restack.log(msg)
	local n
	for n=1,10 do
		getglobal("ChatFrame"..n):AddMessage("[|cff00ff00".."restack|r] "..msg)
	end
end
