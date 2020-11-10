local NewCasting = {}
_G.NewCasting = NewCasting

local name = ""
local back = CreateUIComponent("Texture", "CastingBarBack", "CastingBarFrame")
_G.CastingBarBack = nil
back:SetSize(192, 17)
back:SetTexture("Interface/Addons/XBar/Img/Striped")
CastingBarFrame:SetLayers(1, back)
local tex = "Interface/Addons/XBar/Img/Castborder"
CastingBarBorderLeft:SetTexture(tex)
CastingBarBorderLeft:SetSize(62, 64)
CastingBarBorderRight:SetTexture(tex)
CastingBarBorderMiddle:SetTexture(tex)
CastingBarFlash:SetTexture("Interface/Addons/XBar/Img/Castflash")
CastingBarFrame:SetSize(192, 17)
CastingBarText:SetSize(192, 21)
CastingBarText:SetFontSize(11)
back:SetColor(.05, .35, .35)

function NewCasting.OnEvent()
	name = arg1
end

function NewCasting.OnUpdate(this)
	if this.casting then
		local ctime = GetTime()
		if ctime>this.maxValue then
			ctime = this.maxValue
		end
		CastingBarText:SetText(string.format("%s: %.1f/%.1f", name, this.maxValue - ctime, this.maxValue - this.minValue))
	end
end

local frame = CreateUIComponent("Frame", "NewCastingFrame", "CastingBarFrame", "UIPanelAnchorFrameTemplate")
_G.NewCastingFrame = nil
frame:SetMouseEnable(true)
frame:SetScripts("OnShow", [=[ UIPanelAnchorFrame_OnShow(this:GetParent()) ]=])
frame:SetScripts("OnMouseDown", [=[ UIPanelAnchorFrame_OnMouseDown(this:GetParent(), key) ]=])
frame:SetScripts("OnMouseUp", [=[ UIPanelAnchorFrame_OnMouseUp(this:GetParent(), key) ]=])
frame:SetScripts("OnLoad", [=[ this:RegisterEvent("CASTING_START") ]=])
frame:SetScripts("OnEvent", [=[ NewCasting.OnEvent() ]=])
frame:SetScripts("OnUpdate", [=[ NewCasting.OnUpdate(CastingBarFrame) ]=])
