--[[
pbInfo - Includes/inc.MobDB.lua
	v0.56
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/
]]
function pbInfo.MobDB.Update(target)
	if (UnitExists(target) and not UnitIsPlayer(target) and UnitLevel(target) > 0) then
		local name = UnitName(target);
		local mL, sL = UnitLevel(target);
		local mC, sC = UnitClass(target);
		local healthMax = UnitChangeHealth(target);
		if (type(pbInfo.MobDB.Mobs[name]) ~= "table") then
			pbInfo.MobDB.Mobs[name] = {};
		end;
		if (type(pbInfo.MobDB.Mobs[name][mL]) ~= "table") then
			pbInfo.MobDB.Mobs[name][mL] = {};
		end;
		-- thanks to matif for the update (different mob clases within one level have different healthMax).
		if (type(pbInfo.MobDB.Mobs[name][mL][mC]) ~= "table") then
			pbInfo.MobDB.Mobs[name][mL][mC] = {};
		end;
		if (UnitHealth(target) == 100 and (pbInfo.MobDB.Mobs[name][mL][mC]["healthpoints"] or 0) < healthMax) then
			pbInfo.MobDB.Mobs[name][mL]["healthpoints"] = healthMax; -- backward compatibility for other addons
			pbInfo.MobDB.Mobs[name][mL][mC]["healthpoints"] = healthMax;
		end;
	end;
end;