--[[ Dummy Hook Tool zum erstellen von dynamischen Hooks
     Entwickler: nachtgold
     Version: 0.4
     Lizenz: http://creativecommons.org/licenses/by-nc-sa/3.0/
     alle Skripte werden in das Verzeichnis dynHook abgelegt, wenn sie noch nicht existieren 
     ]]

if not useDynamicHook then
  useDynamicHook = function(addon, hook, class, method, parameters)
    local filename = "Interface/Addons/"..addon.."/lib/dynHooks/"..class.."_"..method..".lua";
    dofile(filename);
  end;
end;

if not useFunctionDynamicHook then
  useFunctionDynamicHook = function(addon, hook, _function, parameters)
    local filename = "Interface/Addons/"..addon.."/lib/dynHooks/".._function..".lua";
    dofile(filename);
  end;
end;

--DEFAULT_CHAT_FRAME:AddMessage("HookLib loaded|r");