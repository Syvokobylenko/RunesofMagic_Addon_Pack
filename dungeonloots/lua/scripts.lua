--/run dofile("interface/addons/DungeonLoots/lua/scripts.lua")
local me = DL.scripts

--/run DL.scripts.ExportBoss(id, instance_id)
--/run DL.scripts.ExportCurrentView()
function me.ExportCurrentView()
	me.ExportBoss(DL.ui.bossid, DL.ui.instanceid)
end

function me.ExportBoss(id, instance_id)
	if not id then return end
	if not AAROMWELTEN_EXPORT then
		AAROMWELTEN_EXPORT = {}
	end
	local lst = DL.helper.GetBossLootSortedValues(id)
	local name, values = DL.helper.GetBossTooltip(id, instance_id, instance_id)
	local txt = name
	for i=1,#values do
		txt = txt.."\n"..tostring(values[i])
	end
	txt=txt.."\n\nLOOTS:"
	for i=1,#lst do
		txt = txt.."\n"..lst[i].id.." "..lst[i].text.." "..lst[i].r.." "..lst[i].g.." "..lst[i].b
	end
	instance_id = instance_id or ""
	AAROMWELTEN_EXPORT[tonumber(tostring(id)..tostring(instance_id))]={txt}
	SaveVariablesPerCharacter("AAROMWELTEN_EXPORT")
	print(id.." "..name.." "..instance_id.." -> ok")
end

--/run DL.scripts.GetTreasure(id)
function me.GetTreasure(id)
	local tbl = DL.helper.GetLootRecursive({},id,100,0)
	for i=1,#tbl do
		print(string.format("%dx%s (%d): %d%%",tbl[i][3],TEXT("Sys"..tbl[i][1].."_name"),tbl[i][1],tbl[i][2]/1000))
	end
end

--/run DL.scripts.GetPosWithPoint(num)
function me.GetPosWithPoint(num)
	if not num then num = 1 end
	local x, y = GetPlayerWorldMapPos()
	if num == 1 then
		print(string.format("x=%s, y=%s", DL.helper.round(x, 3), DL.helper.round(y, 3)))
	elseif num == 2 then
		local dist = 0.012
		print(string.format("x=%s, y=%s", DL.helper.round(x+dist, 3), DL.helper.round(y, 3)))
		print(string.format("x=%s, y=%s", DL.helper.round(x-dist, 3), DL.helper.round(y, 3)))
		
		print(string.format("x=%s, y=%s", DL.helper.round(x, 3), DL.helper.round(y+dist, 3)))
		print(string.format("x=%s, y=%s", DL.helper.round(x, 3), DL.helper.round(y-dist, 3)))
	elseif num == 3 then
		local dist = 0.009
		vx = dist / math.cos(math.rad(30))
		vy = dist / math.sin(math.rad(30))
		y = y + 0.002
		print(string.format("x=%s, y=%s", DL.helper.round(x, 3), 		DL.helper.round(y+dist, 3)))
		print(string.format("x=%s, y=%s", DL.helper.round(x-vx, 3), 	DL.helper.round(y-vy, 3)))
		print(string.format("x=%s, y=%s", DL.helper.round(x+vx, 3), 	DL.helper.round(y-vy, 3)))
	end
end
DL.scripts = me
