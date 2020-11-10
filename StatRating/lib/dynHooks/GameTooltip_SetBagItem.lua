local GameTooltip_obj = GameTooltip;
local SetBagItem_orig=GameTooltip_obj["SetBagItem"];
function GameTooltip:SetBagItem(id)

  if (string.sub(self:GetName(), 1,11) == "GameTooltip") then
    for _,side in pairs({ "Left", "Right" }) do   local j = 1;   while true do     local line = _G["GameTooltipText" .. side .. tostring(j)];     if not line then break end;     line:SetText("");     j = j + 1;   end; end;
    for _,side in pairs({ "Left", "Right" }) do   local j = 1;   while true do     local line = _G["GameTooltip1Text" .. side .. tostring(j)];     if not line then break end;     line:SetText("");     j = j + 1;   end; end;
    for _,side in pairs({ "Left", "Right" }) do   local j = 1;   while true do     local line = _G["GameTooltip2Text" .. side .. tostring(j)];     if not line then break end;     line:SetText("");     j = j + 1;   end; end;
  end;

  SetBagItem_orig(GameTooltip_obj, id);
  StatRating_ProcessTooltip(self, GetBagItemLink(id), 'player');
end;