local GameTooltip_obj = GameTooltip;
local SetInboxItem_orig=GameTooltip_obj["SetInboxItem"];
function GameTooltip:SetInboxItem(id)
  if (string.sub(self:GetName(), 1,11) == "GameTooltip") then 
    for _,side in pairs({ "Left", "Right" }) do   local j = 1;   while true do     local line = _G["GameTooltipText" .. side .. tostring(j)];     if not line then break end;     line:SetText("");     j = j + 1;   end; end;
    for _,side in pairs({ "Left", "Right" }) do   local j = 1;   while true do     local line = _G["GameTooltip1Text" .. side .. tostring(j)];     if not line then break end;     line:SetText("");     j = j + 1;   end; end;
    for _,side in pairs({ "Left", "Right" }) do   local j = 1;   while true do     local line = _G["GameTooltip2Text" .. side .. tostring(j)];     if not line then break end;     line:SetText("");     j = j + 1;   end; end;
  end;
  SetInboxItem_orig(GameTooltip_obj, id);
StatRating_ProcessTooltip(self, GetInboxItem(id), 'player');
end;
