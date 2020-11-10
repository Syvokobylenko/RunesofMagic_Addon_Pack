--[[ ä
	
	Name: Advanced Questbook
	By: Crypton

	Function by DFlame, permission is given to Crypton for usage.
	Originally named: lib.dflame.lua

]]
function AdvQuestBook_Checktooltip()
	local x, y = GameTooltip:GetPos();
	local w, h = GameTooltip:GetSize();
	local tempAnchor = {};
	local bChanged = false;
	tempAnchor.point, tempAnchor.relativePoint, tempAnchor.relativeTo, tempAnchor.offsetX, tempAnchor.offsetY = GameTooltip:GetAnchor();
	if (x < 0) then
		if (tempAnchor.relativePoint == "LEFT") then
			tempAnchor.relativePoint = "RIGHT";
		elseif (tempAnchor.relativePoint == "TOP") then
			tempAnchor.relativePoint = "TOPRIGHT";
		elseif (tempAnchor.relativePoint == "BOTTOM") then
			tempAnchor.relativePoint = "BOTTOMRIGHT";
		elseif (tempAnchor.relativePoint == "TOPLEFT") then
			tempAnchor.relativePoint = "TOPRIGHT";
		elseif (tempAnchor.relativePoint == "BOTTOMLEFT") then
			tempAnchor.relativePoint = "BOTTOMRIGHT";
		end
		if (tempAnchor.point == "RIGHT") then
			tempAnchor.point = "LEFT";
		elseif (tempAnchor.point == "TOP") then
			tempAnchor.point = "TOPLEFT";
		elseif (tempAnchor.point == "BOTTOM") then
			tempAnchor.point = "BOTTOMLEFT";
		elseif (tempAnchor.point == "TOPRIGHT") then
			tempAnchor.point = "TOPLEFT";
		elseif (tempAnchor.point == "BOTTOMRIGHT") then
			tempAnchor.point = "BOTTOMLEFT";
		end
		bChanged = true;
	end
	if (y < 0) then
		if (tempAnchor.relativePoint == "TOP") then
			tempAnchor.relativePoint = "BOTTOM";
		elseif (tempAnchor.relativePoint == "TOPLEFT") then
			tempAnchor.relativePoint = "BOTTOMLEFT";
		elseif (tempAnchor.relativePoint == "TOPRIGHT") then
			tempAnchor.relativePoint = "BOTTOMRIGHT";
		end
		if (tempAnchor.point == "BOTTOM") then
			tempAnchor.Point = "TOP";
		elseif (tempAnchor.point == "BOTTOMLEFT") then
			tempAnchor.point = "TOPLEFT";
		elseif (tempAnchor.point == "BOTTOMRIGHT") then
			tempAnchor.point = "TOPRIGHT";
		end
		bChanged = true;
	end
	if ((x + w) > GetScreenWidth()) then
		if (tempAnchor.relativePoint == "RIGHT") then
			tempAnchor.relativePoint = "LEFT";
		elseif (tempAnchor.relativePoint == "TOP") then
			tempAnchor.relativePoint = "TOPLEFT";
		elseif (tempAnchor.relativePoint == "BOTTOM") then
			tempAnchor.relativePoint = "BOTTOMLEFT";
		elseif (tempAnchor.relativePoint == "TOPRIGHT") then
			tempAnchor.relativePoint = "TOPLEFT";
		elseif (tempAnchor.relativePoint == "BOTTOMRIGHT") then
			tempAnchor.relativePoint = "BOTTOMLEFT";
		end
		if (tempAnchor.point == "LEFT") then
			tempAnchor.point = "RIGHT";
		elseif (tempAnchor.point == "TOP") then
			tempAnchor.point = "TOPRIGHT";
		elseif (tempAnchor.point == "BOTTOM") then
			tempAnchor.point = "BOTTOMRIGHT";
		elseif (tempAnchor.point == "TOPLEFT") then
			tempAnchor.point = "TOPRIGHT";
		elseif (tempAnchor.point == "BOTTOMLEFT") then
			tempAnchor.point = "BOTTOMRIGHT";
		end
		bChanged = true;
	end
	if ((y + h) > GetScreenHeight()) then
		if (tempAnchor.relativePoint == "BOTTOM") then
			tempAnchor.relativePoint = "TOP";
		elseif (tempAnchor.relativePoint == "LEFT") then
			tempAnchor.relativePoint = "TOPLEFT";
		elseif (tempAnchor.relativePoint == "RIGHT") then
			tempAnchor.relativePoint = "TOPRIGHT";
		elseif (tempAnchor.relativePoint == "BOTTOMLEFT") then
			tempAnchor.relativePoint = "TOPLEFT";
		elseif (tempAnchor.relativePoint == "BOTTOMLEFT") then
			tempAnchor.relativePoint = "TOPLEFT";
		elseif (tempAnchor.relativePoint == "BOTTOMRIGHT") then
			tempAnchor.relativePoint = "TOPRIGHT";
		end
		if (tempAnchor.point == "TOP") then
			tempAnchor.Point = "BOTTOM";
		elseif (tempAnchor.point == "LEFT") then
			tempAnchor.point = "BOTTOMLEFT";
		elseif (tempAnchor.point == "RIGHT") then
			tempAnchor.point = "BOTTOMRIGHT";
		elseif (tempAnchor.point == "TOPLEFT") then
			tempAnchor.point = "BOTTOMLEFT";
		elseif(tempAnchor.point == "TOPRIGHT") then
			tempAnchor.point = "BOTTOMRIGHT";
		end
		bChanged = true;
	end
	if (bChanged) then
		GameTooltip:ClearAllAnchors();
		GameTooltip:SetAnchor(tempAnchor.point, tempAnchor.relativePoint, tempAnchor.relativeTo, tempAnchor.offsetX, tempAnchor.offsetY);
	end
end
