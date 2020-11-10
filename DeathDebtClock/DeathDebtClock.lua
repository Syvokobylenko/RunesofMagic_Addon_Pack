
local Death = TEXT("Sys106842_name")
local BloodDebt = TEXT("Sys423670_name")
local Blood = TEXT("Sys203166_name")
local Debt = string.gsub(BloodDebt, Blood, "")
local BloodyGalleryClock = TEXT("Sys491897_name")
local BloodyGallery = TEXT("_glossary_01228")
local Clock = string.gsub(BloodyGalleryClock, BloodyGallery, "")
local DeathDebtClock = Death..Debt..Clock
local GuildLibraryStudying = TEXT("GUILD_LIBRARY01")
local DDCMinutes = TEXT("MINUTES")
local OldXPDebt = 0
local TotalStudyingTime = 0

local ADDON = DeathDebtClock
local VERSION = 1.2
local AUTHOR = "ZTrek"

local GreenText = "|cff00DD00"
local OrangeText = "|cffFF4400"
local BlueText = "|cff00A5EC"
local YellowText = "|cffFFFF00"
local EndColor = "|r"

DEFAULT_CHAT_FRAME:AddMessage(string.format("%s%s%s %sv%s%s by %s%s%s", OrangeText, ADDON, EndColor, GreenText, VERSION, EndColor, BlueText, AUTHOR, EndColor))


function DeathDebtClock_OnLoad(this)
    this:RegisterEvent("ZONE_CHANGED")
    this:RegisterEvent("CASTING_START")
    this:RegisterEvent("PLAYER_EXP_CHANGED")
end

function DeathDebtClock_OnEvent(this, event, arg1, arg2, arg3, arg4)
	if event == "ZONE_CHANGED" then
		if InGuildCastle() then
			OldXPDebt = GetPlayerExpDebt()
			XPDebtDif = false
		else
			DeathDebtClockTime:SetText("HH:MM")
		end
		if InGuildCastle() then
			if GetPlayerExpDebt() == 0 then
				DeathDebtClockFrame:Hide()
			else
				DeathDebtClockFrame:Show()
				DeathDebtClockTitle:SetText(DeathDebtClock)
			end
		end
		if not InGuildCastle() then
			DeathDebtClockFrame:Hide()
		end
	end
	if event == "CASTING_START" then --arg1 = Name of spell arg2 = Total casting time
		if arg1 == GuildLibraryStudying then
			TotalStudyingTime = arg2
		end
	end
	if event == "PLAYER_EXP_CHANGED" then
		if InGuildCastle() and TotalStudyingTime > 0 and OldXPDebt < 0 then
			NewXPDebt = GetPlayerExpDebt()
--DEFAULT_CHAT_FRAME:AddMessage(NewXPDebt)
			if not XPDebtDif then
				XPDebtDif = NewXPDebt - OldXPDebt
			end
			local NumRepeats = math.abs(math.ceil(NewXPDebt/XPDebtDif))
--DEFAULT_CHAT_FRAME:AddMessage(NumRepeats)
			local DDClockText = (NumRepeats*TotalStudyingTime)
			DeathDebtClockTime:SetText(string.format("%.2d:%.2d", DDClockText/(60*60), DDClockText/60%60))
		end
	end
end

function InGuildCastle()
		if (GetZoneID()%1000 == 401) then
			return true
		else
			return false
		end
end
