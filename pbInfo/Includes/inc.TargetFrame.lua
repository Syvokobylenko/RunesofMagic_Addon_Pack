--[[
pbInfo - Includes/inc.TargetFrame.lua
	v0.55-fix
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/
]]
function pbInfo.TargetFrame.Scripts.OnUpdate()
	if (UnitExists("target") and UnitLevel("target") > 0 and not UnitIsPlayer("target") and (pbInfoSettings["MODIFYHEALTHBAR"] == true or pbInfoSettings["HEALTHCOLORFADE"] == true)) then
		pbInfo.MobDB.Update("target");
		local healthMax = pbInfo.MobDB.Mobs[UnitName("target")][UnitLevel("target")][UnitClass("target")]["healthpoints"] or 0;
		local healthRatio = UnitHealth("target");
		if (pbInfoSettings["MODIFYHEALTHBAR"] == true and type(healthMax) == "number" and healthMax > 0) then
			local text = pbAddThousandsSeparator(math.ceil((healthRatio * healthMax) / 100)) .. "/" .. pbAddThousandsSeparator(healthMax);
			if (pbInfoSettings["HEALTHBARSHOWPERCENTAGE"] == true) then
				text = text .. " (" .. healthRatio .. "%)";
			end;
			TargetHealthBarValueText:SetText(text);
		end;
		if (pbInfoSettings["HEALTHBARCOLORFADE"] == true) then
			TargetHealthBar:SetBarColor(HSBtoRGB(math.ceil((healthRatio / 100) * 127.5), 100, 85)); -- HSBtoRGB returns 3 values: r, g, b
		end;
	else
		TargetHealthBar:SetBarColor(1.0, 0.0, 0.0);
	end;
end;

function pbInfo.TargetFrame.Scripts.OnLoad()
	if (pbInfoSettings["HEALTHBARCOLORFADE"] == false or pbInfoSettings["ENABLE"] == false) then
		TargetHealthBar:SetBarColor(1.0, 0.0, 0.0);
	end;
	if ((pbInfoSettings["HEALTHBARCOLORFADE"] == false and pbInfoSettings["MODIFYHEALTHBAR"] == false) or pbInfoSettings["ENABLE"] == false) then
		pbInfoTargetFrameTimer:Hide();
	else
		pbInfoTargetFrameTimer:Show();
	end;
end;