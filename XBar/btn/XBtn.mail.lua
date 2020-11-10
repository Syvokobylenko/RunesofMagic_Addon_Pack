--Sold Items feature made by Mavoc
local XBar = _G.XBar
local unread = 0
local soldtable = {}

function XBar.Mail_OnEvent(this,event,tip)
	if event=="LOADED" and not tip then
		--XBar.RegEvent(this, "MAIL_SHOW", "UNREAD%]")
		this:RegisterEvent("MAIL_SHOW")
		this:RegisterEvent("CHAT_MSG_SYSTEM")
	end
	if event=="MAIL_SHOW" then
		unread = 0
		soldtable = {}
		XBarMail_New:Hide()
	end
	if event=="CHAT_MSG_SYSTEM" then
		local soldstring = string.gsub(TEXT("SYS_AC_SELL_SUCCESS"), "%%s", "(.+)")
		if arg1==TEXT("SYS_NEW_MAIL")
		or arg1==TEXT("SYS_AC_BUYOUT_SUCCESS")
		or arg1==TEXT("SYS_AC_CANCEL_SELL_ITEM")
		or arg1==TEXT("SYS_AC_EXCEED")
		or arg1==TEXT("SYS_GOT_GIFT") then
			XBarMail_New:Show()
			unread = unread + 1
		elseif string.match(arg1, soldstring) then
			for v in string.gmatch(arg1, soldstring) do
				table.insert(soldtable, v)
			end
		end
	end
--	Output
	if not tip then
		local usrtxt = {[1] = XBSet["MailV1"], [2] = XBSet["MailV2"]}
		local output = ""
		for i = 1, 2 do
			usrtxt[i], _ = string.gsub(usrtxt[i], "%[UNREAD%]", unread)
		end
		if XBSet["MailT1"] then
			output=usrtxt[1]
		end
		if XBSet["MailT2"] then
			if XBSet["MailT1"] then
				output=output.."\n"..usrtxt[2]
			else
				output=usrtxt[2]
			end
		end
		XBarMail_F_S:SetText(output)
	end
end

function XBar.Mail_OnClick()
	if TimeLet_GetLetTime("MailLet")<0 then
		StaticPopup_Show("TIMEFLAG_FAIL1")
		return
	else
		OpenMail()
		XBarMail_New:Hide()
	end
end

function XBar.Mail_OnEnter(this)
	XBar.Mail_OnEvent(XBarMail,"LOADED",true)
	XBar.TooltipMod(this)
	GameTooltip:SetText(XBar.Lng["Ttip"]["Mail1"])
	GameTooltip:AddLine(XBar.Lng["Ttip"]["Mail2"],0,.7,.9)
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Config"]["Mail1"].."|r", unread)
	if #(soldtable)>0 then
		GameTooltip:AddSeparator()
		GameTooltip:AddLine("|cff8DE668"..XBar.Lng["Ttip"]["Mail3"].."|r")
		for i, v in ipairs(soldtable) do
			if i<32 then --lines 8-39
				GameTooltip:AddLine(v)
			else
				GameTooltip:AddLine("...") --line 40
				break
			end
		end
	end
end