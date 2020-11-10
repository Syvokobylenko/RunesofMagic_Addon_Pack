--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...

-------------------------------------------------------- UI lib ---------------------------------------------------------
local me = { 
	children = {
		{"button", ".button"},
		{"checkbutton", ".checkbutton"},
		{"editbox", ".editbox"},
		{"fontstring", ".fontstring"},
		{"frame", ".frame"},
		{"layout", ".layout"},
		{"messageframe", ".messageframe"},
		{"model", ".model"},
		{"radiobutton", ".radiobutton"},
		{"scrollframe", ".scrollframe"},
		{"slider", ".slider"},
		{"statusbar", ".statusbar"},
		{"texture", ".texture"},
		{"tooltip", ".tooltip"},
		{"transition", ".transition"},
	},
	imports = {
		[lib.lib.color:GetFullTableName()] = true,
	},
	exports = {"InitWidget","CreateWidget"},
}

me.CreateWidget = function(class, template, global)
	local parent = type(template._parent) ~= "table" and (template._parent or "") or template._parent:GetName()
	local name = template._name:gsub("$parent", parent)
	local widget = CreateUIComponent(class, name or "", parent or "", template._inherits)
	if parent == "" and type(template._parent) == "table" then
		widget:SetParent(template._parent)
	end
	if not global and name ~= "" then
		_G[name] = nil
	end
	me.InitWidget(widget,class, template)
	return widget
end
me.InitWidget = function(frame, class, tbl)
	AssertType(class, "class", me:GetFullTableName()..".InitWidget", "string")
	class = string.lower(class)
	if type(me[class])=="table" and type(me[class].Init)=="function" then
		me[class].Init(frame, tbl)
	end
end
lib.CreateTable(me,name,path, lib)
