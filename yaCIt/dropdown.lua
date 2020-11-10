--[[
		This addon raises the limit for entries
		in the game's dropdown menus to 40 which
		is especially useful for users of addons
		like yaCIt.
		
					Author: Chazzard
]]

UIDROPDOWNMENU_MAXBUTTONS = 40

--[[
local onShow = function(this)
	for i=1, UIDROPDOWNMENU_MAXBUTTONS do
		if (not this.noResize) then
			getglobal(this:GetName().."Button"..i):SetWidth(this.maxWidth)
		end
	end
	if (not this.noResize) then
		this:SetWidth(this.maxWidth+28)
	end
	if ( this:GetID() == 1 ) then
		UIDropDownMenu_StartCounting(this)
	else
		this.showTimer = nil
	end
end
	
for i = 1,3 do
	getglobal("DropDownList"..i)__uiLuaOnShow__ = onShow	
end

for i = 1,3 do
	local listName = "DropDownList"..i
	for j = 33,40 do
		local buttonName = listName.."Button"..j
		--print("create: "..buttonName)
		local button = CreateUIComponent("Button",buttonName,listName,"UIDropDownMenuButtonTemplate",-1)
		button:SetID(j)
		local norm = CreateUIComponent("FontString",buttonName.."NormalText",buttonName,"GameFontHighlight",-1)
		local high = CreateUIComponent("FontString",buttonName.."HighlightText",buttonName,"GameFontHighlight",-1)
		local dis  = CreateUIComponent("FontString",buttonName.."DisabledText",buttonName,"GameFontDisable",-1)
		norm:SetJustifyHType("LEFT")
		high:SetJustifyHType("LEFT")
		dis:SetJustifyHType("LEFT")
		
		norm:SetSize(128,16)
		norm:SetFont("Fonts/DFHEIMDU.TTF", 12, "NORMAL", "NORMAL")
		norm:ClearAllAnchors()
		norm:SetAnchor("LEFT","LEFT",norm:GetParent(),2,4)
		norm:SetText("huch!")
		
		high:SetSize(128,16)
		high:SetFont("Fonts/DFHEIMDU.TTF", 12, "NORMAL", "NORMAL")
		high:ClearAllAnchors()
		high:SetAnchor("LEFT","LEFT",high:GetParent(),5,10)
		high:SetText("huch!")
		
		dis:SetSize(128,16)
		dis:SetFont("Fonts/DFHEIMDU.TTF", 12, "NORMAL", "NORMAL")
		dis:ClearAllAnchors()
		dis:SetAnchor("LEFT","LEFT",dis:GetParent(),15,20)
		dis:SetText("huch!")
		
		button:SetLayers(3,norm)
		button:SetLayers(3,high)
		button:SetLayers(3,dis)
		local ExAr = CreateUIComponent("Texture",buttonName.."ExpandArrow",buttonName)
		ExAr:SetSize(16,16)
		ExAr:SetTexture("Interface\Buttons\UIMenu_State")		
		button:SetLayers(3,ExAr)
		local MT = CreateUIComponent("Texture",buttonName.."MarkTexture",buttonName)
		MT:SetSize(16,16)
		MT:ClearAllAnchors()
		MT:SetAnchor("RIGHT","RIGHT",MT:GetParent(),-4,0)
		MT:SetTexture("interface/Common/RaidTarget")
		
		button:SetLayers(3,MT)
		local CK = CreateUIComponent("Texture",buttonName.."Check",buttonName)
		CK:SetSize(16,16)
		CK:SetTexture("Interface\Buttons\CheckBox-Check")		
		button:SetLayers(3,CK)
		
		button:SetScripts("OnClick","UIDropDownMenuButton_OnClick(this, key)")
			
		_G[buttonName] = button
	end
end
]]