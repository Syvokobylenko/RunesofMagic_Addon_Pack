--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib, name, path = ...

------------------------------------------------------ ui.me ------------------------------------------------------
local me = {
	TransitionList = {_Frames = {}, }, 
}

me._Init = function(val)
	if val then return end
	me.Clear()
	me.RegisterOnUpdateHandler("PYLIB_TRANSITION", me.Update)
end
local TS_frame, TS_current, TS_ctime, TS_ratio, TS_start, TS_end
me.Update = function(frame, elapsed)
	for name, trans in pairs(me.TransitionList) do
		if name=="_Frames" then else
			TS_frame = trans.Frame
			TS_current = trans.Current+elapsed
			trans.Current = TS_current;
			TS_ctime = trans.Time
			if TS_current > TS_ctime then
				me.Stop(TS_frame, trans.Name);
			else
				TS_ratio = TS_current/TS_ctime
				if trans.Alpha then
					TS_start, TS_end = unpack(trans.Alpha)
					TS_frame:SetAlpha(TS_start+(TS_end-TS_start)*TS_ratio)
				end
				if trans.Update then
					RunScript2(trans.Update, name, TS_ratio)
				end
				if trans.Size then
					TS_start, TS_end = unpack(trans.Size)
					TS_frame:SetSize(TS_start[1]+(TS_end[1]-TS_start[1])*TS_ratio, TS_start[2]+(TS_end[2]-TS_start[2])*TS_ratio)
				end
				if trans.Pos then
					TS_start, TS_end = unpack(trans.Pos)
					TS_frame:SetPos(TS_start[1]+(TS_end[1]-TS_start[1])*TS_ratio, TS_start[2]+(TS_end[2]-TS_start[2])*TS_ratio)
				end
				if trans.Scale then
					TS_start, TS_end = unpack(trans.Scale)
					TS_frame:SetScale(TS_start+(TS_end-TS_start)*TS_ratio)
				end
			end
		end
	end
end
me.Add = function(frame, name, trans)
	AssertType(frame, "frame", me:GetFullTableName()..".Add", "table");
	AssertType(name, "name", me:GetFullTableName()..".Add", "string", "number");
	AssertType(trans, "trans", me:GetFullTableName()..".Add", "table");
	frame.__Transition = frame.__Transition or {}
	local checked_trans = {}
	checked_trans.Frame = frame
	checked_trans.Name = name
	local vtype
	for key, value in pairs(trans) do
		vtype = type(value)
		if key=="Start" then
			if vtype=="string" or vtype=="function" then
				checked_trans[key] = value
			end
		elseif key=="Update" then
			if vtype=="string" or vtype=="function" then
				checked_trans[key] = value
			end
		elseif key=="End" then
			if vtype=="string" or vtype=="function" then
				checked_trans[key] = value
			end
		elseif key=="Time" then
			if vtype=="number" then
				checked_trans[key] = value
			end
		elseif key=="Alpha" then
			if vtype=="table" and type(value[1])=="number" and type(value[2])=="number" then
				checked_trans[key] = value
			end
		elseif key=="Size" then
			if vtype=="table" and type(value[1])=="table" and type(value[2])=="table" then
				checked_trans[key] = value
			end
		elseif key=="Pos" then
			if vtype=="table" and type(value[1])=="table" and type(value[2])=="table" then
				checked_trans[key] = value
			end
		elseif key=="Scale" then
			if vtype=="table" and type(value[1])=="number" and type(value[2])=="number" then
				checked_trans[key] = value
			end
		end
	end
	if not checked_trans.Time then return end
	frame.__Transition[name] = checked_trans
	me.TransitionList._Frames[frame:GetName()] = frame
end
me.Start = function(frame, name, trans)
	AssertType(frame, "frame", me:GetFullTableName()..".Start", "table");
	AssertType(name, "name", me:GetFullTableName()..".Start", "string", "number");
	AssertType(trans, "trans", me:GetFullTableName()..".Add", "table", "nil");
	if trans then
		me.Add(frame, name, trans)
	end
	local trans = frame.__Transition[name]
	trans.Current = 0;
	local transname = frame:GetName()..name
	me.TransitionList[transname]=trans
	if trans.Start then
		RunScript2(trans.Start, trans.Frame, name)
	end
end
me.Stop = function(frame, name)
	local transname = frame:GetName()..name
	if me.TransitionList[transname] then
		local trans = me.TransitionList[transname]
		local frame = trans.Frame
		if trans.Alpha then
			frame:SetAlpha(trans.Alpha[2])
		end
		if trans.Size then
			frame:SetSize(unpack(trans.Size[2]))
		end
		if trans.Pos then
			frame:SetPos(unpack(trans.Pos[2]))
		end
		if trans.Scale then
			frame:SetScale(trans.Scale[2])
		end
		if trans.End then
			RunScript2(trans.End, trans.Frame, name)
		end
		me.TransitionList[transname] = nil
	end
end
me.Delete = function(name)
	for name, frame in pairs(me.TransitionList._Frames) do
		if frame.__Transition and frame.__Transition[name] then
			me.Stop(frame, name)
			frame.__Transition[name] = nil
		end
	end
end
me.Clear = function()
	for a, b in pairs(me.TransitionList) do
		if a=="_Frames" then
			for c, d in pairs(b) do
				me.TransitionList[a][c] = nil
			end
		else
			me.TransitionList[a] = nil
		end
	end
end

lib.CreateTable(me, name, path, lib)
