--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...

------------------------------------------------------ ui.tooltip ------------------------------------------------------
local me = {
	imports = {
		[lib:GetTableRoot().lib.callback:GetFullTableName()] = "Call",
		[lib:GetTableRoot().lib.item:GetFullTableName()] = "PlusItem",
	},
}
--- Init
-- @param frame (table or string) name of Frame
-- @param tbl (table)
--		@params of ui.frame
me.Init=function(frame, tbl)
	if type(frame)=="string" then frame = _G[frame] end
	if type(tbl)~="table" or type(frame)~="table" then return end
	me.InitWidget(frame, "Frame", tbl)
end
me.CreateIDTooltip = function(id, usedb, frame)
	AssertType(id, "id", me:GetFullTableName()..".CreateIDTooltip",	"number");
	Assert(id>=100000 and id<=999999, me:GetFullTableName()..".CreateIDTooltip", "ID has to be between 100.000 and 999.999: Value->"..id);
	frame = frame or GameTooltip
	if id>=200000 then
		frame:SetHyperLink(me.PlusItem(id))
	else
		frame:SetText(TEXT(sprintf("Sys%d_name",id)))
	end
	if usedb then
		me.Call("AppendTooltipValues", nil, id, frame)
	end
end
me.CreateTooltipByTable = function(tbl, frame)
	if not type(tbl)=="table" then
		return
	end
	frame = frame or GameTooltip
	for i, txt in ipairs(tbl) do
		if type(txt)=="boolean" then
			frame:AddSeparator()
		elseif type(txt)=="number" or type(txt)=="string" then
			if i==1 then
				frame:SetText(txt)
			else
				frame:AddLine(txt)
			end
		end
	end
end

lib.CreateTable(me,name,path, lib)
