
local me = {
	tbl = {},
}
--[[
	[1] = text
	[2] = type 0=Log, 1=Note 2=Warning, 3=Error 4=Critical
	[3] = script -> filename
	[4] = {tooltip} additional informations
]]
function me.AddMessage(...)
	if not(ev and ev.Settings and ev.Settings and ev.Settings.main) or ev.Settings.main.debug then
		table.insert(me.tbl, {...})
	end
end

function me.print()
	for a,b in pairs(me.tbl) do
		print(b[1])
	end
end

return me;
