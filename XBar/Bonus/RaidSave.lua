local rd = {}
local join = NONE
local diff
local frame = CreateUIComponent("Frame", "RaidSaveFrame", "UIParent")
local function Print(str, ...)
	DEFAULT_CHAT_FRAME:AddMessage(str:format(...), 1, 1, 1)
end

SLASH_RdSave1 = "/rds"
function SlashCmdList.RdSave()
	if GetNumPartyMembers()>0 or GetNumRaidMembers()>0 then
		rd = {}
		for i = 1, 36 do
			local m = UnitName("raid"..i)
			if UnitExists("raid"..i) and m~=UnitName("player") then
				table.insert(rd, m)
				Print("%s |cffFFE855%s|r!", OBJ_SAVE, m)
			end
		end
		diff = GetInstanceLevel()
		Print("%s |cffFFE855%s|r %s!", INSTANCE_LEVEL, diff, OBJ_SAVE)
	end
	join = string.format(TEXT("SYS_ADD_PARTY"), UnitName("player")):gsub("%p", "")
	frame:UnregisterEvent("CHAT_MSG_SYSTEM")
end

SLASH_RdDisband1 = "/rdd"
function SlashCmdList.RdDisband()
	SlashCmdList.RdSave()
	if IsPartyLeader() then
		for i = 1, 36 do
			if UnitExists("raid"..i) and UnitName("raid"..i)~=UnitName("player") then
				UninviteFromParty("raid"..i)
			end
		end
	end
end

SLASH_RdInvite1 = "/rdi"
function SlashCmdList.RdInvite()
	for i, v in ipairs(rd) do
		InviteByName(v)
	end
	frame:RegisterEvent("CHAT_MSG_SYSTEM")
end

SLASH_RdReload1 = "/rdr"
function SlashCmdList.RdReload()
	SlashCmdList.RdDisband()
	SlashCmdList.RdInvite()
end

function RaidSave_Level()
	if string.find(arg1:gsub("%p", ""), join) and IsPartyLeader() and diff then
		SetInstanceLevel(diff)
	end
end

_G.RaidSaveFrame = nil
frame:SetScripts("OnEvent", [=[ RaidSave_Level() ]=])
