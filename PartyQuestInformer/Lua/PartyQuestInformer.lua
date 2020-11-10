local kwDispatcher = LibStub("kwDispatcher")
local kwIO = LibStub("kwIO")

local PQI = {}
_G.PQI=PQI

PQI.AddonName = "PartyQuestInformer"
PQI.AddonVersion = "v1.4.0"
PQI.PQIT = false
PQI.ChatMsg = true

--load locals
kwIO.Locales(PQI.AddonName)

local function GetQuestIndex(questName)
    for index = 1, GetNumQuestBookButton_QuestBook() do
        local _, catalogID, name = GetQuestInfo(index)
        if string.sub(name, 1, string.len(questName)) == questName then
            return index
        end
    end
end

--switch informer on/off and change the button icon
PQI.Toggle = function()
	if PQI.PQIT==true then
		PQI.PQIT=false
		if PQI.ChatMsg then
			kwIO.Print(PQI.Locales.OFF)
		end
	else
		PQI.PQIT=true
		if PQI.ChatMsg then
			kwIO.Print(PQI.Locales.ON)
		end
	end
	if AddonManager then
		local texFile = "Interface/Addons/PartyQuestInformer/Images/PQIOFF.tga"
		if PQI.PQIT then
			texFile = "Interface/Addons/PartyQuestInformer/Images/PQION.tga"
		else
			texFile = "Interface/Addons/PartyQuestInformer/Images/PQIOFF.tga"
		end
		local tmpTex = CreateUIComponent("Texture", "", "")
		tmpTex:SetTexture(texFile)
		tmpTex:ClearAllAnchors()
		tmpTex:SetSize(24, 24)
		tmpTex:SetAnchor("LEFT", "LEFT", "PQIButton", 0, 0)
		PQIButton:SetNormalTexture(tmpTex)
	end 
end

--send message
PQI.QuestInform = function(PQName)
	if PQI.PQIT then
		if UnitExists("party1") then
			local QBV = GetQuestIndex(PQName)
			local QH = QuestBook_GetQuestHyperLink(QBV)
			local _, _, _, _, _, PQID = GetQuestInfo(QBV);
			if not PQID then
				SendChatMessage(PQI.Locales.Message.." "..QH, "Party")
			end
		end
	end
end

--enable on/off messages
PQI.EnableMsg = function()
	PQI.ChatMsg = true
end

--disable on/off messages
PQI.DisableMsg = function()
	PQI.ChatMsg = false
end

--event listener
PQI.OnEvent = function(event, arg1)
	if event == "VARIABLES_LOADED"then
		if AddonManager then
			local addon = {
		   		name 			= PQI.AddonName,
				description		= PQI.Locales.Description,
				icon 			= "Interface/Addons/PartyQuestInformer/Images/PQION.tga",
				category 		= "Leveling",
		    	version 		= PQI.AddonVersion,
				author 			= "Kwitsch",
		        slashCommands 	= "/PQIT",
				miniButton 		= PQIButton,
				onClickScript 	= PQI.Toggle,
				disableScript 	= PQI.DisableMsg,
				enableScript 	= PQI.EnableMsg,
		    }
		    if AddonManager.RegisterAddonTable then
				AddonManager.RegisterAddonTable(addon)
			else
				AddonManager.RegisterAddon(addon.name, addon.description, addon.icon, addon.category, addon.configFrame, addon.slashCommands, addon.miniButton, addon.onClickScript)
			end
		else
			kwIO.Print(PQI.Locales.Loaded)
			kwIO.Print(PQI.Locales.Command)
		end
	elseif event == "ADDNEW_QUESTBOOK" then 
		PQI.QuestInform(TEXT("Sys"..arg1.."_name"))
	end
end

--create slash command
SlashCmdList["PQIT"] = PQI.Toggle
SLASH_KWRELOAD1 = "/PQIT"

kwDispatcher.RegDEvent(PQI.AddonName, PQI.OnEvent, {"VARIABLES_LOADED","ADDNEW_QUESTBOOK"})