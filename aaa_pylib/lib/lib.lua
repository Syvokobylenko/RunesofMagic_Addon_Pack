--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...

------------------------------------------------------ default lib ------------------------------------------------------
local me = {
	children = {
		{"table", ".table"},
		{"callback", ".callback"},
		{"color", ".color"},
		{"hash", ".hash"},
		{"helper", ".helper"},
		{"table", ".table"},
		{"hook", ".hook"}, -- needs lib.table
		{"item", ".item"}, -- needs lib.color, lib.hash, lib.callback
		{"num", ".num"},
		{"string", ".string"}, -- needs lib.table
		{"timer", ".timer"},
		
	},
	exports = {},
}
lib.CreateTable(me,name,path, lib)
