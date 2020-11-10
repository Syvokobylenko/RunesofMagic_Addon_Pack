--[[
File-Author: Pyrr
File-Hash: ef28f5ab8ba90c4171ea12f324b9810bbcb58eaf
File-Date: 2017-10-30T18:56:27Z
]]
local lib,name,path = ...

------------------------------------------------------ lib.num.vector ------------------------------------------------------
local me = {
}

me.GetVector = function(tbl)
	if tbl.dim==2 then
		return tbl.X, tbl.Z
	else
		return tbl.X, tbl.Z, tbl.Y
	end
end
me.VectorTostring = function(tbl)
	if tbl.dim==2 then
		return sprintf("X=%s, Y=%s", tbl.X, tbl.Z)
	else
		return sprintf("X=%s, Z=%s, Y=%s", tbl.X, tbl.Z, tbl.Y)
	end
end

me.RotateDeg = function(vec, deg_X, deg_Y, deg_Z)
	AssertType(deg_X,"deg_X",me:GetFullTableName()..".RotateDeg","number")
	AssertType(deg_Y,"deg_Y",me:GetFullTableName()..".RotateDeg","number", "nil")
	AssertType(deg_Z,"deg_Z",me:GetFullTableName()..".RotateDeg","number", "nil")
	deg_X = deg_X or 0
	deg_Y = deg_Y or 0
	deg_Z = deg_Z or 0
	if deg_X>360 then deg_X = deg_X -360 end
	if deg_Y>360 then deg_Y = deg_Y -360 end
	if deg_Z>360 then deg_Z = deg_Z -360 end
	me.RotateRad(vec, math.rad(deg_X), math.rad(deg_Y), math.rad(deg_Z))
end
me.RotateRad = function(vec, rad_X, rad_Y, rad_Z)
	AssertType(rad_X,"rad_X",me:GetFullTableName()..".RotateRad","number")
	AssertType(rad_Y,"rad_Y",me:GetFullTableName()..".RotateRad","number", "nil")
	AssertType(rad_Z,"rad_Z",me:GetFullTableName()..".RotateRad","number", "nil")
	rad_X = rad_X or 0
	rad_Y = rad_Y or 0
	rad_Z = rad_Z or 0
	if vec.dim==2 then
		local x,y
		x =  vec.X*math.cos(rad_X)+vec.Z*math.sin(rad_X)
		y = -vec.X*math.sin(rad_X)+vec.Z*math.cos(rad_X)
		vec.X = x
		vec.Z = y
	else
		local x,y,z
		
		x = vec.X*math.cos(rad_X)+vec.Y*math.sin(rad_X)
		y = -vec.X*math.sin(rad_X)+vec.Y*math.cos(rad_X)
		vec.X = x
		vec.Y = y

		x = vec.X*math.cos(rad_Y)+vec.Z*math.sin(rad_Y)
		z = -vec.X*math.sin(rad_Y)+vec.Z*math.cos(rad_Y)
		vec.X = x
		vec.Z = z

		y = vec.Y*math.cos(rad_Z)+vec.Z*math.sin(rad_Z)
		z = -vec.Y*math.sin(rad_Z)+vec.Z*math.cos(rad_Z)
		vec.Y = y
		vec.Z = z
		
	end
	vec.X = vec.X and me.Round(vec.X,8) or nil
	vec.Y = vec.Y and me.Round(vec.Y,8) or nil
	vec.Z = vec.Z and me.Round(vec.Z,8) or nil
end
--/run TESTVEC2 = pylib.lib.num.vector.Vector(0,1) print(TESTVEC2) TESTVEC2:RotateDeg(90) print(TESTVEC2)
--/run local vec = pylib.lib.num.vector.Vector print(vec(1,0)<=vec(2,0))
--/run TESTVEC2 = pylib.lib.num.vector.Vector(1,0) print(TESTVEC2/2) TESTVEC2:RotateDeg(90) print(TESTVEC2)
--/run TESTVEC3 = pylib.lib.num.vector.Vector(1,0,0) print(TESTVEC3) TESTVEC3:RotateDeg(90) print(TESTVEC3)
me.Add = function(tbl1, tbl2)
	Assert(tbl1.dim==tbl2.dim,me:GetFullTableName()..".Add", "Vectors must have same dimensions")
	local x,y,z
	x = tbl1.X+tbl2.X
	y = tbl1.Z+tbl2.Z
	if tbl1.dim==3 then
		z = tbl1.Y+tbl2.Y
	end
	return me.Vector(x,y,z)
end
me.Mul = function(tbl1, val)
	local x,y,z
	x = tbl1.X*val
	y = tbl1.Z*val
	if tbl1.dim==3 then
		z = tbl1.Y*val
	end
	return me.Vector(x,y,z)
end

me.Equals = function(tbl1, tbl2)
	if tbl1.dim ~= tbl2.dim then return false end
	if tbl1.X   ~= tbl2.X   then return false end
	if tbl1.Z   ~= tbl2.Z   then return false end
	if tbl1.dim==2 then return true end
	if tbl1.Y   ~= tbl2.Y   then return false end
	return true
end

me.GetAngle = function(tbl)
	local a1,a2,a3
	if tbl.X and tbl.Y then
		if tbl.Y~=0 then
			a1 = math.atan(tbl.X/tbl.Y)
		else
			a1 = 0
		end
	end
	if tbl.Y and tbl.Z then
		if tbl.Z~=0 then
			a2 = math.atan(tbl.Y/tbl.Z)
		else
			a2 = 0
		end
	end
	if tbl.X and tbl.Z then
		if tbl.Z~=0 then
			a3 = math.atan(tbl.X/tbl.Z)
		else
			a3 = 0
		end
	end
	return a1,a2,a3
end
me.LesserEqual = function(tbl1, tbl2)
	return tbl1<tbl2 or tbl1==tbl2
end

me.LesserThan = function(tbl1, tbl2)
	if tbl1:Length()>=tbl2:Length() then return false end -- check if vector 2 is longer than vector 1
	local a1, a2, a3 = me.GetAngle(tbl1)
	local b1, b2, b3 = me.GetAngle(tbl2)
	if a1~=b1 then return false end -- check angles
	if a2~=b2 then return false end
	if a3~=b3 then return false end
	return true
end

me.Subtraction = function(tbl1, tbl2)
	return -tbl2+tbl1
end
me.Len = function(tbl)
	return math.sqrt((tbl.X or 0)*(tbl.X or 0)+(tbl.Y or 0)*(tbl.Y or 0)+(tbl.Z or 0)*(tbl.Z or 0))
end
me.Division = function(tbl, val)
	return tbl*(1/val)
end
me.Negate = function(tbl)
	return tbl*(-1)
end
local meta = {
		__tostring = me.VectorTostring,
		__index = function(tbl, key) if type(me[key])=="function" then return me[key] end return nil end,
		__eq = me.Equals,
		__le = me.LesserEqual,
		__lt = me.LesserThan,
		
		__add = me.Add,
		__sub = me.Subtraction,
		__mul = me.Mul,
		__div = me.Division,
		__unm = me.Negate, -- negate
		__pow = nil,
		__concat = nil,
		__metatable = "nope",
	}

me.CreateVector = function(tbl)
	tbl.RotateDeg = me.RotateDeg
	tbl.RotateRad = me.RotateRad
	tbl.Length = me.Len
	tbl.Get = me.GetVector
	setmetatable(tbl, meta);
	return tbl
end
me.Vector = function(x1,x2,x3)
	AssertType(x1,"x1",me:GetFullTableName()..".Vector","number")
	AssertType(x2,"x2",me:GetFullTableName()..".Vector","number")
	AssertType(x2,"x3",me:GetFullTableName()..".Vector","number", "nil")
	local tbl = {}
	if x3 then
		tbl.dim = 3
	else
		tbl.dim = 2
	end
	tbl.X = x1
	tbl.Y = x3
	tbl.Z = x2
	return me.CreateVector(tbl)
end
me._Init = function(var)
	if var then return end --before load of children
	lib.Vector = me.Vector -- Export this function to parent lib
end
lib.CreateTable(me,name,path, lib)
