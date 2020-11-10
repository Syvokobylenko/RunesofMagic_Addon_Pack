local GameTooltipHyperLink_obj = GameTooltipHyperLink;
local SetHyperLink_orig=GameTooltipHyperLink_obj["SetHyperLink"];
function GameTooltipHyperLink:SetHyperLink(link)
  if (string.sub(self:GetName(), 1,11) == "GameTooltip") then 
    for _,side in pairs({ "Left", "Right" }) do   local j = 1;   while true do     local line = _G["GameTooltipText" .. side .. tostring(j)];     if not line then break end;     line:SetText("");     j = j + 1;   end; end;
    for _,side in pairs({ "Left", "Right" }) do   local j = 1;   while true do     local line = _G["GameTooltip1Text" .. side .. tostring(j)];     if not line then break end;     line:SetText("");     j = j + 1;   end; end;
    for _,side in pairs({ "Left", "Right" }) do   local j = 1;   while true do     local line = _G["GameTooltip2Text" .. side .. tostring(j)];     if not line then break end;     line:SetText("");     j = j + 1;   end; end;
    for _,side in pairs({ "Left", "Right" }) do   local j = 1;   while true do     local line = _G["GameTooltipHyperLinkText" .. side .. tostring(j)];     if not line then break end;     line:SetText("");     j = j + 1;   end; end;
  end;
  SetHyperLink_orig(GameTooltipHyperLink_obj, link);
StatRating_ProcessTooltip(self, link, 'player');
end;
