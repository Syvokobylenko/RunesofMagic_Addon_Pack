--RuneCraft 0.50
--Author: Ganjaaa, odie2, psprofi

local Sol = LibStub("Sol");

local DebugMode = false;
local DBLoaded = false;
local AktTier = 0;

local MaxScroll = 9;

local VERSION = "v0.62";

-- OnLoad
function RCMain_OnLoad(this)
	this:RegisterEvent("VARIABLES_LOADED");
	RC_DBLoad();
	--Tier Name Set
	for i = 0,7,1 do
		if i == 0 then _G["RCMain_Tier"..i]:SetText(RCText.Menu.UnrankedTier);
		else _G["RCMain_Tier"..i]:SetText(string.gsub(RCText.Menu.Tier,"<TIER>",(i-1))); end;
	end
	--Tier Layer
	_G["RCMain_Tier"]:SetText(string.gsub(RCText.Menu.Tier,"<TIER>","0"));
	--Needed Layer
	_G["RCMain_Needed"]:SetText(RCText.Menu.Needed);
	_G["RCMain_Info"]:SetText("1234");
	_G["RCMain_Title"]:SetText("RuneCraft "..VERSION);
	if DebugMode then RCMain:Show() end;
end
--OnEvent
function RCMain_OnEvent(this,event)
	if event == "VARIABLES_LOADED" then
		RC_SetScroll(0,1);
		RC_SetPrev(11);
		if ( AddonManager ) then
			local addon = {
				name = "RuneCraft",
				version = VERSION,
				author = "Ganjaaa, Psprofi, Rycerzodie",
				description = RCText.PrintOut.Description,
				icon = "Interface/AddOns/RuneCraft/Gfx/RuneCraftIcon.tga",
				miniButton = RCMiniButton,
				category = "Crafting",
				slashCommands = "/rc",
				configFrame = RCMain
			}		
			if AddonManager.RegisterAddonTable then
				AddonManager.RegisterAddonTable(addon);
			else
				AddonManager.RegisterAddon(addon.name,addon.description);
			end	
		end
		RC_Print(RCText.PrintOut.Say);
		_G["RCTree_Title"]:SetText(RCText.Menu.BuildList);
		RC_TreeClear();
	end
end
--OnClick
function RCList_OnClick(id)
	if Runes[id]["Name"] ~= nil then
		RC_SetPrev(id);
	end
end
function RCGrade_OnClick(number)
	local id = _G["RCPrev_Icon"]:GetID();
	if Runes[id]["Name"] ~= nil then
		if Runes[id].ID ~= "" then
			local itemid = string.format("%X",string.format("%d","0x"..Runes[id].ID)+number-1)
			local link = RC_StringToLink(Runes[id].Name.." "..RC_Num2Rom(number),itemid);
			ChatEdit_AddItemLink(link)
		end
	end
end
--Tooltip
function RCGrade_Tooltip(number)
	local id = _G["RCPrev_Icon"]:GetID();
	if Runes[id]["Name"] ~= nil then
		if Runes[id].ID ~= "" then
			local itemid = string.format("%X",string.format("%d","0x"..Runes[id].ID)+number-1)
			local link = RC_StringToLink(Runes[id].Name.." "..RC_Num2Rom(number),itemid);
			RCTooltip:SetHyperLink(link);
			RCTooltip:Show();
		end
	end
end
function RCTooltip_Set(id)
	if Runes[id]["Name"] ~= nil then
		if Runes[id].ID ~= "" then
			RCTooltip:SetHyperLink(RC_StringToLink(Runes[id].Name, Runes[id].ID));
			RCTooltip:Show();
		end
	end
end
--Interne Funktionen
---- Erstellt BaumArray
function RC_Tree(start,id,ids)
	local baum = {};
	
	--[[if Runes[id].Comb[5] ~= 2 and Runes[id].Comb[5] ~= 3 and Runes[id].Comb[5] ~= 5 then
		local name_id, name_ids = Runes[id].Name, Runes[ids].Name;
		
		if Runes[id].Type > 0 then
			local comb_id, comb_ids = RC_Tree(0,Runes[id].Comb[1],Runes[id].Comb[2]), RC_Tree(0,Runes[ids].Comb[1],Runes[ids].Comb[2]);
		
			if Runes[id].Comb[3] ~= 0 and Runes[id].Comb[4] ~= 0 then
				comb_id  = RC_Tree(0,Runes[id].Comb[1],Runes[id].Comb[2],Runes[id].Comb[3],Runes[id].Comb[4]);
				comb_ids = RC_Tree(0,Runes[ids].Comb[1],Runes[ids].Comb[2],Runes[ids].Comb[3],Runes[ids].Comb[4]);
			elseif Runes[id].Comb[3] ~= 0 then
				comb_id  = RC_Tree(0,Runes[id].Comb[1],Runes[id].Comb[2],Runes[id].Comb[3]);
				comb_ids = RC_Tree(0,Runes[ids].Comb[1],Runes[ids].Comb[2],Runes[ids].Comb[3]);
			end;
		end;
	
		if start ~= 0 then
			if Runes[id].Type > 0 then
				baum[1] = name_id;
				baum[2] = comb_id;
			else
				baum[1] = name_id;
				baum[2] = 0;
			end
		else
			if Runes[id].Type > 0 then
				baum[1] = name_id;
				baum[2] = {};
				baum[2] = comb_id;
				baum[3] = name_ids;
				baum[4] = {};
				baum[4] = comb_ids;
			else
				baum[1] = name_id;
				baum[2] = 0;
				baum[3] = name_ids;
				baum[4] = 0;
			end
		end
	end
	]]--
	if Runes[id].Comb[3] == 0 and Runes[id].Comb[4] == 0 and Runes[id].Comb[5] ~= 2 and Runes[id].Comb[5] ~= 3 and Runes[id].Comb[5] ~= 5 then
		if start ~= 0 then
			if Runes[id].Type > 0 then
				baum[1] = id;
				baum[2] = RC_Tree(0,Runes[id].Comb[1],Runes[id].Comb[2]);
			else
				baum[1] = id;
				baum[2] = 0;
			end
		else
			if Runes[id].Type > 0 then
				baum[1] = id;
				baum[2] = {};
				baum[2] = RC_Tree(0,Runes[id].Comb[1],Runes[id].Comb[2]);
				baum[3] = ids;
				baum[4] = {};
				baum[4] = RC_Tree(0,Runes[ids].Comb[1],Runes[ids].Comb[2]);
			else
				baum[1] = id;
				baum[2] = 0;
				baum[3] = ids;
				baum[4] = 0;
			end
		end
	end
	if Runes[id].Comb[3] ~= 0 and Runes[id].Comb[4] == 0 and Runes[id].Comb[5] ~= 2 and Runes[id].Comb[5] ~= 3 and Runes[id].Comb[5] ~= 5 then
		if start ~= 0 then
			if Runes[id].Type > 0 then
				baum[1] = id;
				baum[2] = RC_Tree(0,Runes[id].Comb[1],Runes[id].Comb[2],Runes[id].Comb[3]);
			else
				baum[1] = id;
				baum[2] = 0;
			end
		else
			if Runes[id].Type > 0 then
				baum[1] = id;
				baum[2] = {};
				baum[2] = RC_Tree(0,Runes[id].Comb[1],Runes[id].Comb[2],Runes[id].Comb[3]);
				baum[3] = ids;
				baum[4] = {};
				baum[4] = RC_Tree(0,Runes[ids].Comb[1],Runes[ids].Comb[2],Runes[ids].Comb[3]);
			else
				baum[1] = id;
				baum[2] = 0;
				baum[3] = ids;
				baum[4] = 0;
			end
		end
	end
	if Runes[id].Comb[3] ~= 0 and Runes[id].Comb[4] ~= 0 and Runes[id].Comb[5] ~= 2 and Runes[id].Comb[5] ~= 3 and Runes[id].Comb[5] ~= 5 then
		if start ~= 0 then
			if Runes[id].Type > 0 then
				baum[1] = id;
				baum[2] = RC_Tree(0,Runes[id].Comb[1],Runes[id].Comb[2],Runes[id].Comb[3],Runes[id].Comb[4]);
			else
				baum[1] = id;
				baum[2] = 0;
			end
		else
			if Runes[id].Type > 0 then
				baum[1] = id;
				baum[2] = {};
				baum[2] = RC_Tree(0,Runes[id].Comb[1],Runes[id].Comb[2],Runes[id].Comb[3],Runes[id].Comb[4]);
				baum[3] = ids;
				baum[4] = {};
				baum[4] = RC_Tree(0,Runes[ids].Comb[1],Runes[ids].Comb[2],Runes[ids].Comb[3],Runes[ids].Comb[4]);
			else
				baum[1] = id;
				baum[2] = 0;
				baum[3] = ids;
				baum[4] = 0;
			end
		end
	end

	return baum;
end

function RC_TreeList(id)
	--if RC_InArray(Runes,_G[this:GetName().."_Name"]:GetText()) then
	if Runes[id]["Name"] ~= nil then
		local tree = RC_Tree(1,id,id);
		RC_TreeClear();
		RC_TreeFollow(tree,1);
	end;
end

function RC_TreeFollow(tbl,space)
    for k, v in pairs(tbl) do
        if type(v) == "table" then
        else
			if v ~= 0 then
				RC_AddLine(v);
				--Sol.io.Print(enter..tostring(v));
			end
        end
    end
	--RC_AddLine("--------------------");
	for k, v in pairs(tbl) do
        if type(v) == "table" then
            RC_TreeFollow(v,space+1);
        else
        end
    end
end

function RC_AddLine(str)
	if str ~= "--------------------" then
		local id = str;
		for i=1,40,1 do
			if _G["RCTree_Line"..i]:GetText() == "" then
				if Runes[id].Type == 0 then
					_G["RCTree_Line"..i]:SetText(Runes[id].Name); 
				else
					if Runes[id].Comb[3] == 0 and Runes[id].Comb[4] == 0 then
						_G["RCTree_Line"..i]:SetText(Runes[id].Name.."="..Runes[Runes[id].Comb[1]].Name.."+"..Runes[Runes[id].Comb[2]].Name); 
					end
					if Runes[id].Comb[3] ~= 0 and Runes[id].Comb[4] == 0 then	
						_G["RCTree_Line"..i]:SetText(Runes[id].Name.."="..Runes[Runes[id].Comb[1]].Name.."+"..Runes[Runes[id].Comb[2]].Name.."+"..Runes[Runes[id].Comb[3]].Name); 
					end
					if Runes[id].Comb[3] ~= 0 and Runes[id].Comb[4] ~= 0 then
						_G["RCTree_Line"..i]:SetText(Runes[id].Name.."="..Runes[Runes[id].Comb[1]].Name.."+"..Runes[Runes[id].Comb[2]].Name.."+"..Runes[Runes[id].Comb[3]].Name.."+"..Runes[Runes[id].Comb[4]].Name); 
					end
				end
				break;
			end		
		end
	else
		for i=1,40,1 do
			if _G["RCTree_Line"..i]:GetText() == "" then
				_G["RCTree_Line"..i]:SetText(str); 
				break;
			end		
		end
	end
end

function RC_TreeClear()
	for i=1,40,1 do
		if i==2 or i==5 or i== 10 or i==19 then
			_G["RCTree_Line"..i]:SetText("--------------------");
		else
			_G["RCTree_Line"..i]:SetText("");
		end;
	end
end

---- Setzt Preview
function RC_SetPrev(id)
	RC_SetIconTemplate("RCPrev_Icon",Runes[id].Name,Runes[id].Icon);
	_G["RCPrev_Icon"]:SetID(id);
	for i=1,10,1 do
		local gtext = RCText.Menu.Grade..i.." : ";
		if Runes[id].ID ~= "" then
			gtext = gtext..RC_StringToLink(Runes[id].Name.." "..RC_Num2Rom(i),string.format("%X",string.format("%d","0x"..Runes[id].ID)+i-1));
		end
		_G["RCPrev_Grade"..i.."_Name"]:SetText(gtext);
	end
	
	if Runes[id].Comb[5] == 2 then _G["RCMain_Info"]:SetText("|cffF5F5F5"..RCText.Runes.Deactive.."|r");
	elseif Runes[id].Comb[5] == 3 then _G["RCMain_Info"]:SetText("|cffFF4500"..RCText.Runes.NoMake.."|r");
	elseif Runes[id].Comb[5] == 4 then _G["RCMain_Info"]:SetText("|cff32CD32"..RCText.Runes.TreasureHunt.."|r");
	elseif Runes[id].Comb[5] == 5 then _G["RCMain_Info"]:SetText("|cffFF4500"..RCText.Runes.NoMake.."|r".."\n".."|cff32CD32"..RCText.Runes.TreasureHunt.."|r");
	elseif Runes[id].Comb[5] == 6 then _G["RCMain_Info"]:SetText("|cff00B3FF"..RCText.Runes.AltMake.."|r");
	else _G["RCMain_Info"]:SetText(""); end;
	
	for x=1,4,1 do
		if Runes[id].Comb[x] ~= 0 then
			RC_SetIconTemplate("RCPrev_Need"..x,Runes[Runes[id].Comb[x]].Name,Runes[Runes[id].Comb[x]].Icon);
			_G["RCPrev_Need"..x]:SetID(Runes[id].Comb[x]);
			_G["RCPrev_Need"..x]:Show();
		else
			RC_SetIconTemplate("RCPrev_Need"..x,"","");
			_G["RCPrev_Need"..x]:SetID(0);
			_G["RCPrev_Need"..x]:Hide();
		end;
		
		if x == 4 and Runes[id].Comb[1] == 0 and Runes[id].Comb[2] == 0 and Runes[id].Comb[3] == 0 and Runes[id].Comb[4] == 0 then
			_G["RCMain_Needed"]:Hide();
		else
			_G["RCMain_Needed"]:Show();
		end;
	end;
end
---- Holt oder setzt Tier
function RC_AktTier(tier)
	if tier == nil then
		return AktTier;
	else
		if tier == -1 then _G["RCMain_Tier"]:SetText(RCText.Menu.UnrankedTier);
		else _G["RCMain_Tier"]:SetText(string.gsub(RCText.Menu.Tier,"<TIER>",tier)); end;
		AktTier = tier;	
		RCMain_Slider:SetValue(0);
		return AktTier;
	end;
end
----Bilded Itemlink aus Name und ID
function RC_StringToLink(name, id)
	name = string.gsub(name, " [\(]"..RCText.Runes.ShortAlt.."[\)]", "");
	local s = "";
	s = "|Hitem:"..id..":1:0:0:0:0:0:0:0:0:0:0|h|cffffffff["..name.."]|r|h";
	return s;
end
----Sucht in Array
function RC_InArray(array,value)
	local s = false;
	for ix, var in pairs(array) do
		if var.Name == value then
			s = ix;
			break;
		end
	end
	return s;
end
---- Setzt Scrollbar
function RC_SetScroll(tier,start)
	local Items={};
	local count=0
	for index,value in pairs(Runes) do
		if value.Type == tier then
			count=count+1;
			Items[count] = value;
			Items[count]["Index"] = index;
		end
	end
	if (count-MaxScroll) > 0 then
		RCMain_SliderScrollUpButton:Show();
		RCMain_SliderScrollDownButton:Show();
		RCMain_Slider:SetMinMaxValues(1,count-MaxScroll+1,1);
	else
		RCMain_SliderScrollUpButton:Hide();
		RCMain_SliderScrollDownButton:Hide();
		RCMain_Slider:SetMinMaxValues(1,1,1);
	end
	if count >= 9 then
		for i = 1,MaxScroll,1 do
			RC_SetIconTemplate("RCList_Item"..i,Items[start+i-1].Name,Items[start+i-1].Icon);
			_G["RCList_Item"..i]:SetID(Items[start+i-1].Index);
			_G["RCList_Item"..i]:Show();
		end
	else
		for i=1,count,1 do
			RC_SetIconTemplate("RCList_Item"..i,Items[start+i-1].Name,Items[start+i-1].Icon);
			_G["RCList_Item"..i]:SetID(Items[start+i-1].Index);
			_G["RCList_Item"..i]:Show();
		end
		for i=count+1,9,1 do
			RC_SetIconTemplate("RCList_Item"..i,"","");
			_G["RCList_Item"..i]:SetID(0);
			_G["RCList_Item"..i]:Hide();
		end
	end
end
---- Belegt Icon Text Templates
function RC_SetIconTemplate(name,text,img)
	_G[name.."_Name"]:SetText(text);
	_G[name.."_Icon"]:GetNormalTexture():SetFile("interface\\icons\\"..img);	
	_G[name.."_Icon"]:GetPushedTexture():SetFile("interface\\icons\\"..img);	
end
---- Benötigte DBs hinzuladen
function RC_DBLoad()
	if not DBLoaded then
		local Language = string.sub(GetLanguage(), 1, 2);
		local Localespath = "Interface/Addons/RuneCraft/Lang/";

		local func, err = loadfile(Localespath..Language..".lua");
		if (err) then Language = "EN"; end;
		
		RCText = dofile(Localespath..Language..".lua");
		
		if (RCText == nil) then
			Language = "EN";
			RCText = dofile(Localespath..Language..".lua");
		end;
		
		Runes = dofile("Interface/Addons/RuneCraft/db.lua");
		
		DBLoaded = true;
	end
end

---- Dezimal zu Römisch
function RC_Num2Rom(num)
	local tmp = {"I","II","III","IV","V","VI","VII","VIII","IX","X"};
	if num <= 10 and num > 0 then
		return tmp[num];
	end
	return "XXX";
end
---- Läd eine Datei Hinzu
function RC_LoadFile(str)
	local func, err = loadfile(str);
	if (err) then
		return false, err;
	end
	dofile(str);
	return true;
end
---- Öffnet/Schließt Menu
function RCMain_Show()
	if (RCMain:IsVisible()) then
		RCMain:Hide();
		RCTree:Hide();
	else
		RCMain:Show();
		RCTree:Hide();
	end
end
---- PrintOut
function RC_Print(str)
	Sol.io.Print("[RuneCraft]: |cf00ff00 "..str);
end

---- Debug Say
function DebugMessage(str)
	if DebugMode then
		Sol.io.Print("[RCDebug]: |cffff0000"..str);
	end
end

SLASH_RUNECRAFT1 = "/rc"
SlashCmdList["RUNECRAFT"] = RCMain_Show



--[[
Überprüfung der ein inventar gegenstände auf runen
abspeicher der einzelenenn vorhanden daten aktualliserien bei aitem algen oder update

überorpfung der namen auf ranke -> nutzung tooltops

nehemn tier und kontrollieren nach ranke -> mehrdimen array 

einbzeige alle baubaren runen für jeden rank einzeln]]--