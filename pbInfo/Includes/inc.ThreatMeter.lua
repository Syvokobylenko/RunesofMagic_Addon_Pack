--[[
pbInfo - Includes/inc.ThreatMeter.lua
	v0.51-fix
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/
]]
pbInfo.ThreatMeter.Timer = 0;
function pbInfo.ThreatMeter.Scripts.OnUpdate()
	local currentTime = GetTime();
	if (currentTime < (pbInfo.ThreatMeter.Timer + pbInfoSettings["ThreatMeterDelay"])) then
		return false;
	else
		pbInfo.ThreatMeter.Timer = currentTime;
		TargetHateListRequest();
		local i = 0;
		local totalThreat, maxThreat, threatList = 0, 0, {};
		local breakHateListLoop, defaultBarWidth, defaultBarHeigth, defaultAlpha = false, 140, 10, 1;
		repeat
			i = i + 1;
			local unitName, unitThreat = GetTargetHateList(i);
			if (type(unitThreat) ~= "nil") then
				threatList[i] = {
					["unitName"] = unitName,
					["unitThreat"] = unitThreat,
				};
				totalThreat = totalThreat + unitThreat;
				if (maxThreat < unitThreat) then
					maxThreat = unitThreat;
				end;
			else
				breakHateListLoop = true;
			end;
		until (breakHateListLoop == true);
		if (i > 0) then
			table.sort(threatList, function(a, b) return a["unitThreat"] > b["unitThreat"] end);
			if (pbInfoSettings["THREATMETERPLAYERONTOP"]) then
				for k = 1, 6, 1 do
					if (type(threatList[k]) == "table" and threatList[k]["unitName"] == UnitName("player")) then
						table.insert(threatList, 1, table.remove(threatList, k));
						break;
					end;
				end;
			end;
			for k = 1, 6, 1 do
				local threatBar, threatName, threatPercentage = _G["pbInfoThreatMeter_Bar" .. k], _G["pbInfoThreatMeter_Name" .. k], _G["pbInfoThreatMeter_Percentage" .. k]
				if (type(threatList[k]) == "table") then
					local percentage = threatList[k]["unitThreat"] / ((pbInfoSettings["THREATMETERRELATIVETOMAXTHREAT"] and maxThreat) or totalThreat);
					if ((percentage * 100) >= pbInfoSettings["ThreatMeterDisplayLimit"]) then
						local g, r, b = HSBtoRGB(math.ceil(percentage * 127.5), 100, 100); -- swaped red and green!
						threatBar:SetSize(math.ceil(defaultBarWidth * percentage), defaultBarHeigth);
						threatBar:SetColor(r, g, b, 1);
						
						threatName:SetText(threatList[k]["unitName"]);
						if (pbInfoSettings["THREATMETERSHOWREALTHREAT"] == true) then
							threatPercentage:SetText(threatList[k]["unitThreat"]);
						else
							threatPercentage:SetText(math.floor(percentage * 100 + 0.5) .. "%");
						end;
						if (threatList[k]["unitName"] == UnitName("player")) then
							threatName:SetColor(1, 1, 0, defaultAlpha);
							threatPercentage:SetColor(1, 1, 0, defaultAlpha);
						else
							threatName:SetColor(1, 1, 1, defaultAlpha);
							threatPercentage:SetColor(1, 1, 1, defaultAlpha);
						end;
					end;
				else
					threatBar:SetSize(0, defaultBarHeigth);
					threatName:SetText("");
					threatPercentage:SetText("");
				end;
			end;
		end;
	end;
end;

function pbInfo.ThreatMeter.Scripts.OnLoad()
	local scale, x, y = GetUIScale(), unpack(pbInfoSettings["ThreatMeterPosition"]);
	pbInfoThreatMeter:ClearAllAnchors();
	pbInfoThreatMeter:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", x / scale, y / scale);
	pbInfoThreatMeter_Title:SetText(pbInfo.Locale["Config"]["SettingThreatMeter"]);
	pbInfoThreatMeter:SetBackdropTileAlpha(pbInfoSettings["ThreatMeterAlpha"]);
	pbInfoThreatMeter:SetBackdropEdgeAlpha(pbInfoSettings["ThreatMeterAlpha"]);
	if (pbInfoSettings["THREATMETER"] == false
		or (pbInfoSettings["THREATMETERHIDEONNOTARGET"] and not UnitCanAttack("player", "target"))
		or (pbInfoSettings["THREATMETERHIDEONNOPARTY"] and GetNumPartyMembers() == 0)
		or pbInfoSettings["ENABLE"] == false
	) then
		pbInfoThreatMeter:Hide();
	else
		pbInfoThreatMeter:Show();
	end;
	if (pbInfoSettings["THREATMETERLOCK"] == false) then
		pbInfoThreatMeter_MovingDot:Show();
	else
		pbInfoThreatMeter_MovingDot:Hide();
	end;
	if (pbInfoSettings["THREATMETERSHOWTITLE"] == false) then
		pbInfoThreatMeter:SetHeight(105);
		pbInfoThreatMeter_Head:SetHeight(10);
		pbInfoThreatMeter_Head:Hide();
	else
		pbInfoThreatMeter:SetHeight(115);
		pbInfoThreatMeter_Head:SetHeight(20);
		pbInfoThreatMeter_Head:Show();
	end;
	if (pbInfoSettings["THREATMETEWARNTARGETTARGETTARGET"] == false or pbInfoSettings["THREATMETER"] == false) then
		pbInfoThreatMeterAggroWarning:Hide();
		pbInfoThreatMeterAggroWarningTimer:Hide();
	else
		pbInfoThreatMeterAggroWarningTimer:Show();
	end;
end;