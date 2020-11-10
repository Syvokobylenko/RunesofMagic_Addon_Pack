--[[ StatRating
   Details attribute effects in armor and weapons tooltips.
   Coder: nachtgold, shadecut, snoopycurse
   Licence: http://creativecommons.org/licenses/by-nc-sa/3.0/
   Release date: 2009-11-03
   Credits to: puschk1n, cooper1988 aka souldarkshire
   Version number: see StatRatingConfig.lua.
   $Rev: 139 $
]]

-- Load StatsDB. Needed here to fetch revision number.
dofile("Interface/Addons/StatRating/StatsDB.lua");

local addon_name, addon_version = "StatRating", "v1."..SR_numb_Sub_Version.."."..SR_numb_revision;
_G['ADDON_'..addon_name] = addon_version;
local SR = _G["StatRating"];
local p = function(text) DEFAULT_CHAT_FRAME:AddMessage(text); end;


local r = function(num, _exp)
        if (num - math.floor(num) >= 0.5) then
                return math.ceil((math.pow(10, _exp) * num)) / math.pow(10, _exp);
        else
                return math.floor((math.pow(10, _exp) * num)) / math.pow(10, _exp);
        end;
end;

local debug = false;

local rateColor = "EBDF90";

--== TWEAK VARIABLES ==--
my_dura_rate = 1.0;
my_set_effects = false;
my_dura_max = nil;
my_dura_min = nil;
my_got_dura = false;
my_hammered = false;
my_is_food = false;

-------------------------


function SR_possibleCommands(editBox, msg)
  StatRatingConfig_Initialise();

        local arg = string.upper(msg);
  if (arg == "RELOAD") or (arg == "RELOADUI") then
    ReloadUI();
  elseif(arg == "DPS") then
    SRC_guess_dps(1);
  elseif(arg == "DEBUG") then
    debug = not debug;
    p("Debug: "..tostring(debug));
  elseif(arg == "RATE") then
    SR.config.rate = not SR.config.rate;
    if SR.config.rate then
      p("StatRating |cf00ff00 ON|r");
    else
      p("StatRating |cfff0000 OFF |r");
    end;
    StatRatingConfigTabGeneralActiveRate:SetChecked(SR.config.rate);
  elseif(arg == "ON") then
    SR.config.rate = true;
    StatRatingConfigTabGeneralActiveRate:SetChecked(SR.config.rate);
    p("StatRating |cf00ff00 ON|r");
  elseif(arg == "OFF") then
    SR.config.rate = false;
    StatRatingConfigTabGeneralActiveRate:SetChecked(SR.config.rate);
    p("StatRating |cfff0000 OFF |r");
  end;
end;


function SR.classes.TooltipParser:getAddStatValueSumTable(formula, value, calcSum)
  if value == nil or value == 0 then
    return;
  end;
  if calcSum then
    if self.tbl_sumEffectStats[formula.result] == nil then
      self.tbl_sumEffectStats[formula.result] = value;
    else
      self.tbl_sumEffectStats[formula.result] = self.tbl_sumEffectStats[formula.result] + value;
    end;
  end;
end;

--[[ Die Funktion liest einen einzelnen Wert aus dem Cache oder rechnet ihn anhand seiner Formel nach und gibt ihn zurück ]]
function SR.classes.TooltipParser:getAddStatValue(factor, formula, showStat, calcSum)
  if showStat == true then
    if (SR.cacheDB[formula.effect] ~= nil and SR.cacheDB[formula.effect][factor] ~= nil) then

      self:getAddStatValueSumTable(formula, SR.cacheDB[formula.effect][factor], calcSum);

      return SR.cacheDB[formula.effect][factor];
    end;

    if (SR.db[formula.effect] ~= nil) then
      local erg = r(factor * SR.db[formula.effect], 2);

      if (SR.cacheDB[formula.effect] == nil) then
        SR.cacheDB[formula.effect] = {};
      end;
      SR.cacheDB[formula.effect][factor] = erg;

      self:getAddStatValueSumTable(formula, erg, calcSum);

      return erg;
    end;
  end;

  return 0;
end;

--[[ Die Funktion errechnet das Ergebnis einer Formel mit dem gewünschten Faktor
   * Wird ein und die selbe Kombination mehrfach abgefragt, wird sie nur noch aus dem Cache gelesen
   * Das Ergebnis wird wahlweise allein oder zusammen mit dem übergebenen Result zurückgegeben
   * Ist der Wert 0, wird der Standardinput zurück gegeben ]]
function SR.classes.TooltipParser:resultAddValue(result, factor, formula, showStat, calcSum)
  local value = self:getAddStatValue(factor, formula, showStat, calcSum);

  if value > 0 then
    if (string.len(result) > 0) then
      return result..", +"..tostring(value)..formula.result;
    else
      return "+"..tostring(value)..formula.result;
    end;
  else
    return result;
  end;
end;

--[[ Fügt den Faktor zusammen mit seiner Einheit und einem Plus in eine Zeile, bzw verlängert den result-Stream ]]
function SR.classes.TooltipParser:resultAddSimpleValue(result, factor, formula, showStat, calcSum)

  self:getAddStatValueSumTable(formula, factor, calcSum);
  if showStat == true then
    local erg = "+"..factor..formula.result;

    if (result ~= nil and string.len(result) > 0) then
      return result..", "..erg;
    else
      return erg;
    end;
  else
    return '';
  end;
end;

--[[ Prüft ob die Tabelle einen speziellen Wert enthält ]]
function SR.classes.TooltipParser:tableContainsValue(_table, value)
  for _, v in pairs(_table) do
    if v == value then
      return true;
    end;
  end;
end;

--[[ Trägt einen nummerischen Wert in eine Tabelle ein. Existiert der Index schon, wird die Zahl dazu addiert ]]
function SR.classes.TooltipParser:tableAddNumericValue(_table, key, value)
  if value == nil or value == 0 then
    return;
  end;
  if _table[key] ~= nil then
    _table[key] = _table[key] + value;
  else
    _table[key] = value;
  end;
end;

--[[ Gibt die Größe der Tabelle zurück ]]
function SR.classes.TooltipParser:tableSize(_table)
  local i = 0;
  for _,_ in pairs(_table) do
    i = i + 1;
  end;
  return i;
end;

--[[ Berechnet alle internen Stats über die klassenspezifische RatingDB ]]
function SR.classes.TooltipParser:buildAttachment(stat, factor, calcSum)
  if stat == SRC_Texts.Summary.Int then
    local result = "";

    for k, v in pairs(SR.constants) do
      if string.sub(k, 1, 3) == 'INT' then
        result = self:resultAddValue(result, factor, v, SR.config["show"..k], calcSum);
      end;
    end;

    return result;

  elseif stat == SRC_Texts.Summary.Sta then
    local result = "";

    for k, v in pairs(SR.constants) do
      if string.sub(k, 1, 3) == 'STA' then
        result = self:resultAddValue(result, factor, v, SR.config["show"..k], calcSum);
      end;
    end;

    return result;

  elseif stat == SRC_Texts.Summary.Wis then
    local result = "";

    for k, v in pairs(SR.constants) do
      if string.sub(k, 1, 3) == 'WIS' then
        result = self:resultAddValue(result, factor, v, SR.config["show"..k], calcSum);
      end;
    end;

    return result;

  elseif stat == SRC_Texts.Summary.Str then
    local result = "";

    for k, v in pairs(SR.constants) do
      if string.sub(k, 1, 3) == 'STR' then
        result = self:resultAddValue(result, factor, v, SR.config["show"..k], calcSum);
      end;
    end;

    return result;

  elseif stat == SRC_Texts.Summary.Dex then
    local result = "";

    for k, v in pairs(SR.constants) do
      if string.sub(k, 1, 3) == 'DEX' then
        result = self:resultAddValue(result, factor, v, SR.config["show"..k], calcSum);
      end;
    end;

    return result;

  elseif stat == SRC_Texts.Summary.AA then
    local result = "";

    local tbl_all = {};

    -- Alle Formeln berrechnen
    for k, v in pairs(SR.constants) do
      if string.find(k, '_TO_') ~= nil and k ~= "PHYDEF_TO_MAGDEF" then
        self:tableAddNumericValue(tbl_all, SR.constants[k].result, self:getAddStatValue(factor, v, SR.config["show"..k], calcSum));
      end;
    end;

    for k, v in pairs(tbl_all) do
      if v ~= nil and v ~= 0 and v ~= "0" then
        if (result ~= nil and string.len(result) > 0) then
          result = result..", +"..v..k;
        else
          result = "+"..v..k;
        end;
      end;
    end;

    return result;

  -- könnte man auch weglassen und unten auf der BaseListe in die Effektliste schreiben
  elseif stat == SRC_Texts.Summary.HP[2] then
    return self:resultAddSimpleValue("", factor, SR.constants.MAX_HP, SR.config.showMAX_HP, calcSum);

  elseif stat == SRC_Texts.Summary.MP[2] then
    return self:resultAddSimpleValue("", factor, SR.constants.MAX_MP, SR.config.showMAX_MP, calcSum);
  end;

  return "";
end;

--[[ Trennt den Faktor von dem Stat und schlägt beide über buildAttachment nach ]]
function SR.classes.TooltipParser:splitStat(text, calcSum)
  local splitPos = string.find(text, " ");
  if splitPos ~= nil then
    local factor = tonumber(string.sub(text, 1, splitPos-1));
    local statType = string.sub(text, splitPos+1);

    -- eine Zeile endet meist auf |r, sodass der letzte Wert gekürzt werden muss
    if string.find(statType, "|") ~= nil then statType = string.sub(statType, 1, string.find(statType, "|")-1); end;

    if calcSum == true then
      local transName = self:getTranslatedStatKeyword(statType);
      if transName == "HP" or transName == "MP" then
        -- no bonus for direct HP / MP points
      elseif transName == "AA" then
        self:tableAddNumericValue(self.tbl_sumBaseStats, "Int", factor);
        self:tableAddNumericValue(self.tbl_sumBaseStats, "Sta", factor);
        self:tableAddNumericValue(self.tbl_sumBaseStats, "Str", factor);
        self:tableAddNumericValue(self.tbl_sumBaseStats, "Wis", factor);
        self:tableAddNumericValue(self.tbl_sumBaseStats, "Dex", factor);
      elseif transName == 'PDmg' or transName == 'MDmg' then
        self:tableAddNumericValue(self.tbl_sumEffectStats, transName, factor);
      --p("Found "..transName..": "..factor);

      elseif transName == 'MDef' or transName == 'PDef'
          or transName == 'PAtt' or transName == 'MAtt'then
        self:tableAddNumericValue(self.tbl_sumEffectStats, transName, factor);
      else
        self:tableAddNumericValue(self.tbl_sumBaseStats, transName, factor);
      end;
    end;

    return tostring(self:buildAttachment(statType,factor, calcSum));
  end;
end;

function SR.classes.TooltipParser:getTranslatedStatKeyword(statName)
  for k, v in pairs(SRC_Texts.Summary) do
    if type(v) == 'string' and string.lower(v) == string.lower(statName) then
      return k;
    elseif type(v) == 'table' then
      for k2, v2 in pairs(v) do
        if string.lower(v2) == string.lower(statName) then
          return k;
        end;
      end;
    end;
  end;

  return statName;
end;

--[[ Prüft ob es auf der Zeile ein + gibt (leitet ein Attribut ein)
  * kommt ein Komma vor, so handelt es sich um eine Aufzählung
  * Jeder gefundene Stat wird nach gerechnet und in den Text eingefügt ]]
function SR.classes.TooltipParser:ParseLine(tip_text, completeTip, index, side)
  local text = tip_text;

  if(index == 1) then
    return text;
  end;
  if string.find(text,SRC_Texts.Common.PowerMod_word) ~= nil then
        my_hammered = true;
  end

  if(string.find(text, SRC_Texts.general.Food) ~= nil or string.find(text, SRC_Texts.general.Dessert) or my_is_food == true) then
        my_is_food = true;
        return text;
  end;

  if text ~= nil and string.len(text) > 0   -- kein leerer Text
     and ((string.sub(text, 1, 1) ~= '|') or (string.len(text) > 13))
     and string.find(text, SRC_Texts.Common.PowerMod_word) == nil
  then
    local textfarbe = "";
    if (string.sub(text, 1, 1) == "|") then
      textfarbe = string.sub(text, 1, 10);
    else
      textfarbe = "|r";
    end;

    -- Soll die aktuelle Zeile die Zusammenfassung beeinflussen
    local splitSum = true;

    local durapos = string.find(text, SRC_Texts.general.Durability);
    if(durapos ~= nil) then
      --this line contains duration, fetch it boy!
      durapos = string.find(text,"/");
      if(durapos ~= nil) then
        my_dura_min = tonumber(string.sub(text,durapos - 4,durapos - 1));
        my_dura_max = tonumber(string.sub(text,durapos + 1, durapos + 5));
        my_got_dura = true;

        if SR.config["duraMod"] == false then
          my_got_dura = false;
        else
          if SR.config["duraModAllways"] == true then
            my_dura_min = my_dura_max;
          end
        end
      end
    end

    -- Ist der Text grau, ist er unrelevant
    if string.upper(string.sub(textfarbe, 5, 10)) == "A5A5A5" then
      splitSum = false;

        -- If the text is green or yellow, we will check it out
    elseif string.upper(string.sub(textfarbe, 5, 10)) == "00FF00" and index ~= 1 then
     -- splitSum = false;
      --Find out what the number is and what stat it refers to
      if(my_got_dura == true and my_dura_min ~= nil) then
        if((my_dura_min > 100) and my_hammered == false) then
                                if string.find(text, "St\195\188ck") ~= nil
                                or string.find(text, "Piece") ~= nil
                                or string.find(text, "Pieza") ~= nil
                                or string.find(text, "Pi\195\168ce")~= nil then
            --We are dealing with set effects, parse each line very carefully
          else
            local ppos = string.find(text,"+");

            if(ppos ~= nil) then
              local ind = 1;
              local newVal = nil;
              while(newVal == nil and ind < 6) do
                newVal = tonumber(string.sub(text,ppos + 1, ppos + 6 - ind));
                ind = ind + 1;
              end
              local temppi = newVal;
              if(newVal ~= nil) then
                newVal = newVal * my_dura_rate;
                if(newVal > math.floor(newVal) and newVal < 100) then
                  local meep = string.format("%.1f",newVal);
                  text = "|cFF00FF00" .. "+" .. meep .. string.sub(text,ppos + 1 + string.len(temppi) ,string.len(text))
                else
                  local meep = string.format("%.0f",newVal);
                  text = "|cFF00FF00" .. "+" .. meep .. string.sub(text,ppos + 1 + string.len(temppi) ,string.len(text))
                end;
              end
            end
          end
        end
      end

      elseif string.upper(string.sub(textfarbe, 5, 10)) == "FFFF00" and index ~= 1 then
        if(my_got_dura == true and my_dura_min ~= nil) then
          if((my_dura_min > 100) and my_hammered == false) then
                                if string.find(text, "St\195\188ck") ~= nil
                                or string.find(text, "Piece") ~= nil
                                or string.find(text, "Pieza") ~= nil
                                or string.find(text, "Pi\195\168ce") ~= nil then
              --We are dealing with set effects, parse each line very carefully
            else
              local ppos = string.find(text,"+");
              if(ppos ~= nil) then
                local ind = 1;
                local newVal = nil;
                while(newVal == nil and ind < 6) do
                  newVal = tonumber(string.sub(text,ppos + 1, ppos + 6 - ind));
                  ind = ind + 1;
                end
                local temppi = newVal;
                if(newVal ~= nil) then

                  newVal = newVal * my_dura_rate;
                  if(newVal > math.floor(newVal) and newVal < 100) then
                    local meep = string.format("%.1f",newVal);
                    text = "|cFFFFFF00" .. "+" .. meep .. string.sub(text,ppos + 1 + string.len(temppi) ,string.len(text))
                  else
                    local meep = string.format("%.0f",newVal);
                    text = "|cFFFFFF00" .. "+" .. meep .. string.sub(text,ppos + 1 + string.len(temppi) ,string.len(text))
                  end;
                end
              end
            end
          end
        end
      end

    -- ist der Text von einem Set ist er vlt unrelevant
    if string.find(text, "St\195\188ck") ~= nil
        or string.find(text, "Piece") ~= nil
        or string.find(text, "Pieza") ~= nil
        or string.find(text, "Pi\195\168ce") ~= nil then
      local i = index + 1;
      if completeTip["Left"][i] ~= nil then

        -- ist er nicht der letzte aktive Setboni ist er unrelevant
        if string.upper(completeTip["Left"][i]["color"]) ~= "A5A5A5" then
          -- Ist die Zeile eine von den Setitems, wird nur die letzte gerated
          if string.find(completeTip["Left"][i]["text"], "St\195\188ck") ~= nil
                  or string.find(completeTip["Left"][i]["text"], "Piece") ~= nil
                  or string.find(completeTip["Left"][i]["text"], "Pieza") ~= nil
                  or string.find(completeTip["Left"][i]["text"], "Pi\195\168ce") ~= nil then
            splitSum = false;
          end;
        end;
      end;
    end;

    -- Searches for Pdef and Mdef
    --PDEF is a field with different texts
    local pDefValue = nil;
    if side == "L" and string.find(string.lower(tip_text), string.lower(SRC_Texts.Summary.PDef[1])) ~= nil then
      pDefValue = string.sub(completeTip["Left"][index]["text"], string.len(SRC_Texts.Summary.PDef[1])+2);
    end

    if pDefValue ~= nil and completeTip["Left"]~= nil then

        -- Filtert die Farbbefehle heraus
      local colorcode = nil;
        if string.find(pDefValue, '|c') then
        colorcode = string.sub(pDefValue,string.find(pDefValue, '|c'),string.find(pDefValue, '|c') + 10)
          pDefValue = string.sub(pDefValue, 10+string.find(pDefValue, '|c'));
        end;
        if string.find(pDefValue, '|r') then
          pDefValue = string.sub(pDefValue, 1, string.find(pDefValue, '|r')-1);
        end;

      self:tableAddNumericValue(self.tbl_sumEffectStats, "PDef", tonumber(pDefValue));

      if(my_got_dura == true and my_dura_min ~= nil) then
        if((my_dura_min > 100) and my_hammered == false) then
          --it's high dura allright, find the defense value
          if(colorcode == nil) then colorcode = ""; end;
          return SRC_Texts.Summary.PDef[1] .. " |cffffff00" .. string.format("%.0f", tonumber(pDefValue) * my_dura_rate);
        end
      end
    end;

    --MDEF -- check tip_text instead of completeTip["Right"][index]["text"] ... because the value will added twice ( left/right-check)
    local mdef = nil;
    if side == "R" and string.find(string.lower(tip_text), string.lower(SRC_Texts.Summary.MDef)) ~= nil and
       completeTip["Right"][index] ~= nil and string.find(completeTip["Right"][index]["text"], '+') == nil then
      mdef = string.sub(completeTip["Right"][index]["text"], string.len(SRC_Texts.Summary.MDef)+2);
    end

    if mdef ~= nil then
      -- Filtert die Farbbefehle heraus
      if string.find(mdef, '|c') then
      mdef = string.sub(mdef, 10+string.find(mdef, '|c'));
      end;
      if string.find(mdef, '|r') then
      mdef = string.sub(mdef, 1, string.find(mdef, '|r')-1);
      end;
      self:tableAddNumericValue(self.tbl_sumEffectStats, "MDef", tonumber(mdef));
      if(my_got_dura == true and my_dura_min ~= nil) then
        if((my_dura_min > 100) and my_hammered == false) then
          --it's high dura allright, find the defense value
          return SRC_Texts.Summary.MDef .. " |cffffff00".. string.format("%.0f",mdef * my_dura_rate);
        end
      end
    end

    -- DPS Support for the weapon line
    if side == "L" and completeTip["Right"][index] ~= nil and completeTip["Right"][index]["text"] ~= nil then -- ohne Attackspeed kein DPS
      local PDmg_name = SRC_Texts.Summary.PDmg[1];
      local speed_name = SRC_Texts.Summary.Speed;

	--[[
      if PDmg_name ~= "TODO!" and speed_name ~= "TODO!" then
        local pos_PDmg = string.find(text, PDmg_name);
        local pos_speed = string.find(completeTip["Right"][index]["text"], speed_name);
        local len_dmg = string.len(PDmg_name);
        local len_speed = string.len(speed_name);
        if pos_PDmg ~= nil and pos_speed ~= nil then
          local dmg = string.sub(text, pos_PDmg + len_dmg + 1);
          local as = string.sub(completeTip["Right"][index]["text"], pos_speed + len_speed + 1);
          if (string.sub(dmg, 1, 1) == "|") then dmg = string.sub(dmg, 11); end;
          if (string.find(dmg, '|') ~= nil) then dmg = string.sub(dmg, 1, string.find(dmg, '|')-1); end;
          if (string.sub(as, 1, 1)  == "|") then as = string.sub(as, 11); end;
          if (string.find(as, '|')  ~= nil) then as = string.sub(as, 1, string.find(as, '|')-1); end;
          self:tableAddNumericValue(self.tbl_sumEffectStats, 'PDmg', dmg);
          local dpsValue = r(((tonumber(dmg)) / (tonumber(as))), 2);
          -- DPS in die Zusammenfassung reinnehmen
          if splitSum then
            if self.tbl_sumEffectStats.DPS == nil then
              if(my_got_dura == true and my_dura_min ~= nil) then
                if(my_dura_min > 100) then --it's high dura allright
                  self.tbl_sumEffectStats.DPS = dpsValue * my_dura_rate;
                else
                  self.tbl_sumEffectStats.DPS = dpsValue;
                end
              else
                self.tbl_sumEffectStats.DPS = dpsValue;
              end
            else
              if(my_got_dura == true and my_dura_min ~= nil) then
                if(my_dura_min > 100) then       --it's high dura allright
                  self.tbl_sumEffectStats.DPS = (self.tbl_sumEffectStats.DPS + (dpsValue * my_dura_rate));
                else
                  self.tbl_sumEffectStats.DPS = self.tbl_sumEffectStats.DPS + dpsValue;
                end
              else
                self.tbl_sumEffectStats.DPS = self.tbl_sumEffectStats.DPS + dpsValue;
              end
            end;
          end;
          if(my_got_dura == true and my_dura_min ~= nil) then
            if((my_dura_min > 100) and my_hammered == false) then  --it's high dura allright
              return SRC_Texts.Summary.PDmg[1] .. " |cffffff00" .. string.format("%.0f",tonumber(dmg * my_dura_rate)) .." ("..tostring(dpsValue*my_dura_rate)..' DPS)|r';
            end
          end
          return text.."|cff"..rateColor.." ("..tostring(dpsValue)..' DPS)|r';
        end;
      end;
-- ]]
    end;


    -- Heal support for weapon line
    if ( completeTip["Right"][index] == nil
        or completeTip["Right"][index]["text"] == nil
        or string.len(completeTip["Right"][index]["text"]) == 0)
      and (completeTip["Left"][index] ~= nil and completeTip["Left"][index]["text"] ~= nil) then
      local tmpLeftText = string.lower(completeTip["Left"][index]["text"]);
      local key = string.lower(SRC_Texts.Summary.MDmg);
      if string.find(tmpLeftText, key) then
        local mdValue = tonumber(string.sub(tmpLeftText, string.len(key)+2));
        self:tableAddNumericValue(self.tbl_sumEffectStats, 'MDmg', mdValue);
                    if(mdValue) then
          local mdCalced = (mdValue / (4/3));
          mdCalced = r(mdCalced, 2);
          if splitSum then  -- +HEAL in die Zusammenfassung reinnehmen
            if self.tbl_sumEffectStats.HEAL == nil then
              self.tbl_sumEffectStats.HEAL = mdCalced;
            else
              self.tbl_sumEffectStats.HEAL = self.tbl_sumEffectStats.HEAL + mdCalced;
            end;
          end;
          if(my_got_dura == true and my_dura_min ~= nil) then
            if((my_dura_min > 100) and my_hammered == false) then --it's high dura allright
              return SRC_Texts.Summary.MDmg.." |cffffff00".. string.format("%.0f",mdValue * my_dura_rate) .. " (".. mdCalced * my_dura_rate ..SRC_Texts.Common.Heal_word;
            end
          end
          return text.. " |cff"..rateColor.."("..tostring(mdCalced).. SRC_Texts.Common.Heal_word;
        end;
      end
    end;

    local plusPos = 0;
    while true do
      plusPos = string.find(text, "+", plusPos+1);
      if ( plusPos == nil ) then break; end;

      local delimPos = string.find(text, ",", plusPos+1);
      if ( delimPos ~= nil ) then

        local calcStats = self:splitStat(string.sub(text, plusPos+1, delimPos-1), splitSum);
        if calcStats ~= nil and (string.len(calcStats) > 0) then

          calcStats = "|cff"..rateColor.."("..calcStats..")"..textfarbe;
          local tmp = string.sub(text, 1, delimPos-1)..calcStats;
          plusPos = string.len(tmp);
          text = tmp..string.sub(text, delimPos);
        end;
      else

        local calcStats = self:splitStat(string.sub(text, plusPos+1), splitSum);
        if calcStats ~= nil and (string.len(calcStats) > 0) then

          calcStats = "|cff"..rateColor.." ("..calcStats..")"..textfarbe;
          text = text..calcStats;
          plusPos = string.len(text);
        end;
      end;
    end;
  end;

  return text;
end;

function SR.classes.TooltipParser:MoveABit()
  local x,y = self.tooltip:GetPos();
  if y < 0 then
    self.tooltip:SetPos(x, 4);
  end;
  if x < 0 then
    self.tooltip:SetPos(4, y);
  end;
end;

function SR.classes.TooltipParser:mergeKeyTable(oneTable, anotherTable)
  local newTable = {};
  for k, _ in pairs(oneTable) do
    if newTable[k] == nil then
      newTable[k] = 'x';
    end;
  end;
  for k, _ in pairs(anotherTable) do
    if newTable[k] == nil then
      newTable[k] = 'x';
    end;
  end;

  return newTable;
end;

function SR.classes.TooltipParser:getCompareValueText(field, baseValue)
  local compValue = field;
  if compValue == nil then compValue = 0; end;

  compValue = baseValue - compValue;
  local compColor = '';
  if compValue < 0 then
    compColor = '|cffff0000- ';
    compValue = compValue * (-1);
  else
    compColor = '|cff00ff00+ ';
  end;

  return compValue, compColor;
end;

--[[ Die Funktion geht alle Elemente des Tooltips durch. Kapselt die Werte in "stats" und "tip"
   "stats" ist für die Ablage in einer DB und "tip" für die Berechnungen.]]
function SR.classes.TooltipParser:ReadTooltip(compareTT, compareTT2)

  local linesName = self.tooltip:GetName().."Text";

  local stats = { };
  local tip = { };

  for _,side in pairs({ "Left", "Right" }) do
    local shortSide = string.sub(side, 1, 1);
    local j = 1;

    tip[side] = { };

    while true do
      local line = _G[linesName .. side .. tostring(j)];
      if not line then break; end;
      local text = line:GetText();
      if not text then break; end;
      if text ~= "" and line:IsVisible() then
        local r, g, b = line:GetColor();
        local J = tostring(j);
        stats[shortSide .. "TEXT" .. J] = text;
        local hexcolor = string.format("%02X", math.floor(r*255))..string.format("%02X", math.floor(g*255))..string.format("%02X", math.floor(b*255));
        stats[shortSide .. "RGB" .. J] = '#'..hexcolor;

        -- Tipp cachen
        tip[side][j] = { text=text, color=hexcolor };
      end;
      text = '';
      j = j + 1;
    end;
  end;

  -- Standard löschen
  self.tooltip:ClearLines();

  -- Summentabelle zurück setzen
  self.tbl_sumBaseStats = { };
  self.tbl_sumEffectStats = { };

  -- Separator anhand eines braunen Texts erkennen
  local separator_written = false;

  -- Rated Tipp schreiben
  my_set_effects = false;
  my_hammered = false;
  my_is_food = false;
  my_set_effects = false;
  my_dura_max = nil;
  my_dura_min = nil;
  my_got_dura = false;

  for i,t in pairs(tip["Left"]) do
    local leftText = nil;

    if SR.config.colorFix and t["color"] == 'FFFF00' then
      leftText = "|cff3366FF"..t["text"].."|r";
    else
      leftText = "|cff"..t["color"]..t["text"].."|r";
    end;

    if separator_written ~= true and t["color"] == '9E754C' then
      getglobal(self.tooltip:GetName()..'Separator1'):Show();
      getglobal(self.tooltip:GetName()..'Separator1'):SetWidth(self.tooltip:GetWidth()-20);
      self.tooltip:AddLine('');
      getglobal(self.tooltip:GetName()..'TextLeft'..tostring(i-1)):SetHeight(5);
      separator_written = true;
    end;

    if(tip["Right"][i] == nil) then
      self.tooltip:AddLine(self:ParseLine(leftText, tip, i, "L"));
    else
      local rightText = "|cff"..tip["Right"][i]["color"]..tip["Right"][i]["text"];

      -- SNOOPY Long line ( All attributes) fix
      local leftText1 = self:ParseLine(leftText, tip, i, "L");
      local leftText2 = "";
      local midText   = "";
      local leftLen = string.len(leftText1);
      local delimPos = 0;
      if leftLen >90 then
        delimPos  = string.find(leftText1, ",", 10+leftLen/2);
        midText   = "|cff"..rateColor ..string.sub(leftText1, delimPos+2, leftLen);
        leftText2 = string.sub(leftText1, 1, delimPos);
        self.tooltip:AddDoubleLine(leftText2, "");
        self.tooltip:AddDoubleLine(midText, self:ParseLine(rightText, tip, i, "R"));
      else
        self.tooltip:AddDoubleLine(leftText1, self:ParseLine(rightText, tip, i, "R"));
      end;
     --  self.tooltip:AddDoubleLine(self:ParseLine(leftText, tip, i, "L"), self:ParseLine(rightText, tip, i, "R"));
     -- End of SNOOPY fix

    end;
  end;

  -- Summenbereich
  if SR.config.statSummary and (
         (self:tableSize(self.tbl_sumBaseStats) > 0 or
            (compareTT ~= nil and self:tableSize(compareTT.tbl_sumBaseStats) > 0) or
            (compareTT2 ~= nil and self:tableSize(compareTT2.tbl_sumBaseStats) > 0)
         )
    or
         (self:tableSize(self.tbl_sumEffectStats) > 0 or
            (compareTT ~= nil and self:tableSize(compareTT.tbl_sumEffectStats) > 0) or
            (compareTT2 ~= nil and self:tableSize(compareTT2.tbl_sumEffectStats) > 0)
         )
    )
  then
    -- WICHTIG: GTT2 ist selten verfügbar, deshalb zwar alle Felder initalisiert aber mit Warnung
    local compareTT2Show = false;
    if compareTT2 ~= nil then
      compareTT2Show = true;
    end;

    self.tooltip:AddLine(" ");

    self.tooltip:AddLine("|cff"..rateColor .. SRC_Texts.general.Stat_summary);

    if compareTT == nil and compareTT2 == nil then
      for k, v in pairs(self.tbl_sumBaseStats) do
        -- schlägt nach ob der Wert angezeigt werden soll
        if SR.config['showSum'..string.sub(k, 1, 3)] == nil or SR.config['showSum'..string.sub(k, 1, 3)] then
          -- Workaround weil ich noch nicht alle Attribute auf der Liste habe
          if SRC_Texts.Summary[k] and type(SRC_Texts.Summary[k]) == 'string' then
            self.tooltip:AddDoubleLine("|cff"..rateColor..SRC_Texts.Summary[k]..":", "|cff"..rateColor..v..'|r');
          elseif SRC_Texts.Summary[k] and type(SRC_Texts.Summary[k]) == 'table' then
            self.tooltip:AddDoubleLine("|cff"..rateColor..SRC_Texts.Summary[k][1]..":", "|cff"..rateColor..v..'|r');
          else
            self.tooltip:AddDoubleLine("|cff"..rateColor..k..":", "|cff"..rateColor..v..'|r');
          end;
        end;
      end;

    else

      if compareTT == nil then
        compareTT = {};
      end;
      if compareTT2 == nil then
        compareTT2 = {};
      end;
      if compareTT.tbl_sumBaseStats == nil then
        compareTT.tbl_sumBaseStats = {};
      end;
      if compareTT2.tbl_sumBaseStats == nil then
        compareTT2.tbl_sumBaseStats = {};
      end;

      local fullBaseKeyTable = self:mergeKeyTable(self.tbl_sumBaseStats, compareTT.tbl_sumBaseStats);
      fullBaseKeyTable = self:mergeKeyTable(fullBaseKeyTable, compareTT2.tbl_sumBaseStats);

      for k, _ in pairs(fullBaseKeyTable) do

        -- schlägt nach ob der Wert angezeigt werden soll
        if SR.config['showSum'..string.sub(k, 1, 3)] == nil or SR.config['showSum'..string.sub(k, 1, 3)] then

          local value = self.tbl_sumBaseStats[k];
          if value == nil then value = 0; end;

          local compValue, compColor = self:getCompareValueText(compareTT.tbl_sumBaseStats[k], value);
          local compValue2, compColor2 = self:getCompareValueText(compareTT2.tbl_sumBaseStats[k], value);

          local GTT2value = '';
          if compareTT2Show == true then
            GTT2value = ' | '..compColor2..compValue2..'|r';
          end;

          -- Workaround weil ich noch nicht alle Attribute auf der Liste habe
          if SRC_Texts.Summary[k] then
            if type(SRC_Texts.Summary[k]) == 'table' then
              self.tooltip:AddDoubleLine("|cff"..rateColor..SRC_Texts.Summary[k][1]..":", "|cff"..rateColor..value..' ( '..compColor..compValue..'|r'..GTT2value..'|cff'..rateColor..')|r');
            else
              self.tooltip:AddDoubleLine("|cff"..rateColor..SRC_Texts.Summary[k]..":", "|cff"..rateColor..value..' ( '..compColor..compValue..'|r'..GTT2value..'|cff'..rateColor..')|r');
            end;
          else
            self.tooltip:AddDoubleLine("|cff"..rateColor..k..":", "|cff"..rateColor..value..' ( '..compColor..compValue..'|r|cff'..rateColor..')|r');
          end;
        end;
      end;
    end;

    if compareTT == nil and compareTT2 == nil then

      for k, v in pairs(self.tbl_sumEffectStats) do
        -- schlägt nach ob der Wert angezeigt werden soll
        if SR.config['showSum'..k] == nil or SR.config['showSum'..k] then
          if type(SRC_Texts.Summary[k]) == 'table' then
            self.tooltip:AddDoubleLine("|cff"..rateColor..SRC_Texts.Summary[k][1]..":", "|cff"..rateColor..v..'|r');
          else
            self.tooltip:AddDoubleLine("|cff"..rateColor..SRC_Texts.Summary[k]..":", "|cff"..rateColor..v..'|r');
          end;
        end;
      end;

    else

      if compareTT == nil then
        compareTT = {};
      end;
      if compareTT2 == nil then
        compareTT2 = {};
      end;
      if compareTT.tbl_sumEffectStats == nil then
        compareTT.tbl_sumEffectStats = {};
      end;
      if compareTT2.tbl_sumEffectStats == nil then
        compareTT2.tbl_sumEffectStats = {};
      end;

      local fullEffectKeyTable = self:mergeKeyTable(self.tbl_sumEffectStats, compareTT.tbl_sumEffectStats);
      fullEffectKeyTable = self:mergeKeyTable(fullEffectKeyTable, compareTT2.tbl_sumEffectStats);

      for k, v in pairs(fullEffectKeyTable) do

        -- schlägt nach ob der Wert angezeigt werden soll
        if SR.config['showSum'..k] == nil or SR.config['showSum'..k] then

          local value = self.tbl_sumEffectStats[k];
          if value == nil then value = 0; end;

          local compValue, compColor = self:getCompareValueText(compareTT.tbl_sumEffectStats[k], value);
          local compValue2, compColor2 = self:getCompareValueText(compareTT2.tbl_sumEffectStats[k], value);

          local GTT2value = '';
          if compareTT2Show == true then
            GTT2value = ' | '..compColor2..compValue2..'|r';
          end;

          if type(SRC_Texts.Summary[k]) == 'table' then
            self.tooltip:AddDoubleLine("|cff"..rateColor..SRC_Texts.Summary[k][1]..":", "|cff"..rateColor..value..' ( '..compColor..compValue..'|r'..GTT2value..'|cff'..rateColor..')|r');
          else
           self.tooltip:AddDoubleLine("|cff"..rateColor..SRC_Texts.Summary[k]..":", "|cff"..rateColor..value..' ( '..compColor..compValue..'|r'..GTT2value..'|cff'..rateColor..')|r');
          end;
        end;
      end;
    end;

  end;

  local result = "";
  for k,v in pairs(stats) do
    result = result..k..': {'..v..'} ';
  end;

  -- Rückt das Fenster wieder ins Bild
  self:MoveABit();

  return result;
end;

--[[ Läd beim ersten Aufruf die klassenabhänigen Faktoren für die einzelnen Stats ]]
function StatRating_ProcessTooltip(tooltip, link, unit)
  local firstClass, secondClass = UnitClass(unit);
  if SR.db == nil or SR.currentClass == nil or SR.currentClass ~= firstClass then
    if (SR.db  ~= nil) then SR.db = { }; end;
    if (SR.cacheDB  ~= nil) then SR.cacheDB = { };end;
    SR.db = SR.initDB(firstClass);
    SR.currentClass = firstClass;
    if debug then   p("|cffff0000 StatRating_ProcessTooltip: new class detected: |r"..firstClass ); end;
    StatRatingConfig_Initialise();

    if SR.config == nil then
      p('|cffff0000Es Error detected. Please repport..|r');
    end;
  end;

  if link ~= nil then
    if debug then p(tooltip:GetName().." "..link.." "..unit); end;
  end;

  if SR.config.rate == true and (SR.config.rateOnAltPressed == false or IsAltKeyDown()) then

    local compareParser = nil;
    local compareParser2 = nil;

    -- GTT1 & 2 parsen
    if GameTooltip1:IsVisible() then
      compareParser = SR.classes.TooltipParser:create(GameTooltip1);
      compareParser:ReadTooltip();
    end;

    if GameTooltip2:IsVisible() then
      compareParser2 = SR.classes.TooltipParser:create(GameTooltip2);
      compareParser2:ReadTooltip();
    end;

    -- GTT parsen
    local currentParser = SR.classes.TooltipParser:create(tooltip);
    local readed = currentParser:ReadTooltip(compareParser, compareParser2);

  end;
end;

--[[ Prüft ob das Element teil der Tabelle ist ]]
function SR.classes.TooltipParser:tableContainsKey(tbl, elementName)
  for name,_ in pairs(tbl) do
    if (name == elementName) then
      return true;
    end;
  end;
  return false;
end;

function StatRating_AddGTT1And2(tooltip)
  local linesName = tooltip:GetName().."Text";

  local ggt1_visible = false;
  local ggt2_visible = false;

  for _,side in pairs({ "Right" }) do
    local shortSide = string.sub(side, 1, 1);
    local j = 1;

    while true do
      local line = _G[linesName .. side .. tostring(j)];
      if not line then break; end;
      local text = line:GetText();
      if not text then break; end;
      if text ~= "" then

        -- Vergleiche den Text mit allen BodySlots
        for k_bs, v_bs in pairs (SR.constants.bodySlots) do

          for _, v_word in pairs (v_bs) do

            if v_word == text then

              local slot,_ = GetInventorySlotInfo(k_bs);
              if ggt1_visible == false then
                GameTooltip1:SetInventoryItem('player', slot);

                if _G[GameTooltip1:GetName().."TextLeft1"] ~= nil and _G[GameTooltip1:GetName().."TextLeft1"]:GetText() ~= nil then
                  if _G[GameTooltip1:GetName().."TextLeft1"]:GetText() ~= text then
                    GameTooltip1:Show();
                    ggt1_visible = true;
                  else
                    GameTooltip1:Hide();
                  end
                else
                  GameTooltip1:Show();
                  ggt1_visible = true;
                end

              elseif ggt2_visible == false then
                GameTooltip2:SetInventoryItem('player', slot);

                if _G[GameTooltip2:GetName().."TextLeft1"] ~= nil and _G[GameTooltip2:GetName().."TextLeft1"]:GetText() ~= nil then
                  if _G[GameTooltip2:GetName().."TextLeft1"]:GetText() ~= text then
                    GameTooltip2:Show();
                    ggt2_visible = true;
                  else
                    GameTooltip2:Hide();
                  end
                else
                  GameTooltip2:Show();
                  ggt2_visible = true;
                end

              end;
            end;
          end;
        end;

      end;
      text = '';
      j = j + 1;
    end;
  end;
end;

function StatRating_OnEvent(event)
  if event == "VARIABLES_LOADED" then
    StatRating_registerAddonManager();
  end;
  if event == "PLAYER_BAG_CHANGED" then
  SRC_guess_dps(2);
  end;
end;

function StatRating_registerAddonManager()
  if AddonManager then
    local addon = {
        name          = addon_name,
        description   = SRC_Texts.general.Short_Descr,
        icon          = "Interface/Addons/StatRating/gfx/chart-64x64",
        category      = "Information",
        configFrame   = StatRatingConfig,
        slashCommands = "/src",
        miniButton    = StatRatingConfigMiniButton,
        onClickScript = StatRatingConfig_AM_Toogle,
        version       = addon_version,
        author        = "Venor, nachtgold, shadecut, snoopycurse",
        disableScript = StatRating_TurnOFF,
        enableScript  = StatRating_TurnON,
    }
    if AddonManager.RegisterAddonTable then
       AddonManager.RegisterAddonTable(addon)
    else
       AddonManager.RegisterAddon(addon.name, addon.description, addon.icon, addon.category,
            addon.configFrame, addon.slashCommands, addon.miniButton, addon.onClickScript)
    end
  else
    p('|cff'..rateColor..addon_name..' '..addon_version.." ".. SRC_Texts.general.isLoaded .. '|r');
  end;
end

function StatRating_TurnON()
    SR.config.rate = true;
    StatRatingConfigTabGeneralActiveRate:SetChecked(true);
    --p("StatRating |cf00ff00 ON|r");
end;
function StatRating_TurnOFF()
    SR.config.rate = false;
    StatRatingConfigTabGeneralActiveRate:SetChecked(false);
    --p("StatRating |cfff0000 OFF |r");
end;

--[[ Init-Function: Läd die Hooks und meldet den Start an den Client ]]
function StatRating_OnLoad(this)
  -- Hooks initalisieren
  useDynamicHook("StatRating", "StatRating_ProcessTooltip(self, GetBagItemLink(id), 'player');", "GameTooltip", "SetBagItem", "id");
  useDynamicHook("StatRating", "StatRating_ProcessTooltip(self, nil, 'player');", "GameTooltip", "SetInventoryItem", "unit, id");
  useDynamicHook("StatRating", "StatRating_AddGTT1And2(self); StatRating_ProcessTooltip(self, GetBootyItemLink(id), 'player');", "GameTooltip", "SetBootyItem", "id");
  useDynamicHook("StatRating", "StatRating_ProcessTooltip(self, GetBankItemLink(id), 'player');", "GameTooltip", "SetBankItem", "id");
  useDynamicHook("StatRating", "StatRating_ProcessTooltip(self, GetAuctionBrowseItemLink(id), 'player');", "GameTooltip", "SetAuctionBrowseItem", "id");
  useDynamicHook("StatRating", "StatRating_ProcessTooltip(self, link, 'player');", "GameTooltipHyperLink", "SetHyperLink", "link");
  useDynamicHook("StatRating", "StatRating_ProcessTooltip(self, GetInboxItem(id), 'player');", "GameTooltip", "SetInboxItem", "id");
  useDynamicHook("StatRating", "StatRating_ProcessTooltip(self, nil, 'player');", "GameTooltip", "SetCraftRequestItem", "obj, id");
  useDynamicHook("StatRating", "StatRating_ProcessTooltip(self, nil, 'player');", "GameTooltip", "SetCraftItem", "obj", "qual");
  useDynamicHook("StatRating", "StatRating_AddGTT1And2(self); StatRating_ProcessTooltip(self, nil, 'player');", "GameTooltip", "SetQuestItem", "itemType, index");
  useDynamicHook("StatRating", "StatRating_AddGTT1And2(self); StatRating_ProcessTooltip(self, nil, 'player');", "GameTooltip", "SetStoreItem", "tab, ButtonId ");

  --createDynamicHook("StatRating_ProcessTooltip(self, GetBagItemLink(id), 'player');", "GameTooltip1", "SetBagItem", "id");
  --createDynamicHook("p('a');", "GameTooltip", "SetMerchantItem", "id");

  this:RegisterEvent("VARIABLES_LOADED");
  this:RegisterEvent("PLAYER_BAG_CHANGED");
end;

local function addSlashList()
  SlashCmdList["STATRATING"] = SR_possibleCommands;
  _G["SLASH_STATRATING1"] = "/sr";
end;

addSlashList();
if debug then p("|cff8db9d4"..addon_name.." "..addon_version.." recached.|r"); end;