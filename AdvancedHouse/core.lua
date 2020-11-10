local config = {}
local me = {
  name = 'AdvancedHouse', --
  version = 'v1.0.0-beta2',
}

function me.init()
  local fn = loadfile('interface/addons/AdvancedHouse/config.lua')
  if fn then
    for a, b in pairs(fn()) do
      config[a] = b
    end
  end
end
function me.onLoad(this)
  this:RegisterEvent('HOUSESFRAME_HIDE');
end
function me.onEvent(this)
  this:Hide()
end

SLASH_AHF1 = '/ahf';
SlashCmdList['AHF'] = function(editBox, msg)
  if AdvancedHouseFrame:IsVisible() then
    AdvancedHouseFrame:Hide()
  else
    AdvancedHouseFrame:Show()
  end
end

_G[me.name] = me
pcall(me.init)
