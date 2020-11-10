--===============================================================================================================================
--==                                   To use, create macro with "/run a()"                                          ==
--===============================================================================================================================

local UseAll = {}

_G.UseAll = UseAll;


local locale = GetLanguage()

UA_Locale = dofile("Interface/AddOns/Use_All/locale/UseAll_"..locale..".lua")

local current = nil

function UseAll_checkBag()
	local occuppied,available,_ = GetBagCount()
	local free = available-occuppied;
	if (free > 0) then
		return true;
	else
		DEFAULT_CHAT_FRAME:AddMessage("The Bag is full");
		return false;
	end
end

function UseAll_start()
	if UseAll_checkBag() then
		--######### IF THERE ARE MORE ITEMS IN list of items, edit the number 30 bellow to correct number of items in the list##################
		current = nil
		for i = 1, 30, 1 do
			if GetBagItemCount(UA_Locale.IDs[i]) > 0 then
				current = UA_Locale.Names[i];
			end
		end
		if (current) then
			DEFAULT_CHAT_FRAME:AddMessage("Item "..current.." used");
			UseItemByName(current);
		end
    end
end

SLASH_UseAll1 = "/a"
SlashCmdList["UseAll"] = UseAll_start