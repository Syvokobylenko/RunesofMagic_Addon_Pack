local scrutinizer = scrutinizer

local function scrutinizer_SlashCmdHandler(_, msg)
	if msg == "reset" then
		scrutinizer.cfg.scale = scrutinizer.default.scale
		scrutinizer:ScaleFrames(scrutinizer.cfg.scale)
		scrutinizer.cfg.alpha = scrutinizer.default.alpha
		scrutinizer:SetAlpha(scrutinizer.cfg.alpha)
		
		scrutinizer:UpdateBarAnchor("scrutinizer_MainFrame", "TOPLEFT", "TOPLEFT", "UIParent", scrutinizer.default.x, scrutinizer.default.y)
		scrutinizer.cfg.x, scrutinizer.cfg.y = scrutinizer.default.x, scrutinizer.default.y
		scrutinizer:Print(scrutinizer.addon .. ": " .. "|cffff0000PLEASE RELOG!|r")
		
	elseif msg == "toggle" then
		scrutinizer.cfg.shown = scrutinizer:Toggle("scrutinizer_MainFrame")
		scrutinizer:Print("/scrutinizer toggle")
	else
		scrutinizer:Print("scrutinizer")
		scrutinizer:Print("/scrutinizer reset ("..DEFAULT..")")
		scrutinizer:Print("/scrutinizer toggle")
	end
end

SlashCmdList.scrutinizer = scrutinizer_SlashCmdHandler
_G.SLASH_scrutinizer1 = "/scrutinizer"
_G.SLASH_scrutinizer2 = "/scrut"