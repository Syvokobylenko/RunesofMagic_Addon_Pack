-- auto generated file don't change it 
local GameTooltip_obj = GameTooltip;  
local SetInventoryItem_orig=GameTooltip_obj['SetInventoryItem'];  
function GameTooltip:SetInventoryItem(unit, id)  
if (string.sub(self:GetName(), 1,11) == "GameTooltip") then for _,side in pairs({ "Left", "Right" }) do   local j = 1;   while true do     local line = _G[GameTooltip:GetName().."Text" .. side .. tostring(j)];     if not line then break end;     line:SetText("");     j = j + 1;   end; end;  
for _,side in pairs({ "Left", "Right" }) do   local j = 1;   while true do     local line = _G["GameTooltip1Text" .. side .. tostring(j)];     if not line then break end;     line:SetText("");     j = j + 1;   end; end; 
for _,side in pairs({ "Left", "Right" }) do   local j = 1;   while true do     local line = _G["GameTooltip2Text" .. side .. tostring(j)];     if not line then break end;     line:SetText("");     j = j + 1;   end; end; 
for _,side in pairs({ "Left", "Right" }) do   local j = 1;   while true do     local line = _G["GameTooltipHyperLinkText" .. side .. tostring(j)];     if not line then break end;     line:SetText("");     j = j + 1;   end; end; 
end; 
SetInventoryItem_orig(GameTooltip_obj, unit, id);  
StatRating_ProcessTooltip(self, nil, 'player');  
end;  
