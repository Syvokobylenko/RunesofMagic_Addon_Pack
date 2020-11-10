--[[
Handles the MiniAddons bar
--]]

local WaitTimer = LibStub("WaitTimer")
local Nyx = LibStub("Nyx")

local Mini = {}
AddonManager.Mini = Mini

local ANIM_TIME=0.5
local CLOSE_DELAY=0.7
local CLICK_DELAY=0.5
local show_click_delay
local ANIM_FACTOR
local DEFAULT_ICON = "interface/icons/reci_car_001"

local function IsFrameValid(frame)
    if not frame or type(frame) ~= "table" then
        return false
    end

    local required_functions={"_uilua.lightuserdate","GetWidth","Show","Hide","IsVisible","ClearAllAnchors","SetAnchor"}
    for _,fct in ipairs(required_functions) do
        if not frame[fct] then return false end
    end

    return true
end

AddonManager.MiniButton_OnEnter = function(btn)
    if not btn.addon then
        return
    end

    if AddonManager_Settings.ShowOnlyNamesInMiniBar then
        GameTooltip:SetOwner(btn, "ANCHOR_TOPLEFT", 0, 0)
        GameTooltip:SetText(btn.addon.name, 1, 1, 1)
        GameTooltip:Show()
    else
        AddonManager.ShowTooltipOfAddon(btn, btn.addon)
    end

    Mini.OnEnter()
end

AddonManager.MiniButton_OnLeave = function(btn)
    GameTooltip:Hide()

    Mini.OnLeave()
end

AddonManager.MiniButton_OnClick = function(btn, key)
    if show_click_delay and show_click_delay+CLICK_DELAY>GetTime() then
        return
    end
    show_click_delay = nil

    if btn.addon.mini_onClickScript then
        btn.addon.mini_onClickScript(btn, key)
    elseif btn.addon.onClickScript then
        btn.addon.onClickScript(btn, key)
    elseif IsFrameValid(btn.addon.configFrame) then
        ToggleUIFrame(btn.addon.configFrame)
    end
    GameTooltip:Hide()
end

function Mini.AddIcon(addon)

    if not addon.miniButton then
        addon.miniButton = AddonManager.CreateButton(addon)
    end

    if not IsFrameValid(addon.miniButton) then
    	addon.miniButton = nil
        return
    end

    addon.miniButton.addon = addon

    Mini.UpdateState()
end

local temp_id=0
function AddonManager.CreateButton(addon)
    temp_id = temp_id +1

    local tempname="AddonManager_MiniBut"..temp_id
    local tempname_but =tempname.."b"
    local tempname_txt1=tempname.."n"
    local tempname_txt2=tempname.."p"
    local tempname_txt3=tempname.."h"

    local button = CreateUIComponent("Button",tempname_but, "AddonManagerMiniFrame")
	button:SetSize(24,24)
    button:Hide()

	local texture_normal = CreateUIComponent("Texture",tempname_txt1, tempname_but)
	texture_normal:SetSize(24,24)
	texture_normal:SetFile((addon.mini_icon or addon.icon) or DEFAULT_ICON)

	local texture_pushed
    if addon.mini_icon_pushed then
	    texture_pushed = CreateUIComponent("Texture",tempname_txt2, tempname_but)
	    texture_pushed:SetSize(24,24)
	    texture_pushed:SetFile(addon.mini_icon_pushed)
    end

	local texture_high = CreateUIComponent("Texture",tempname_txt3, tempname_but)
	texture_high:SetSize(24,24)
	texture_high:SetFile("interface/Buttons/PanelSmallButtonHighlight")
	texture_high:SetAlphaMode("ADD")

    button:SetNormalTexture(texture_normal)
    if texture_pushed then button:SetPushedTexture(texture_pushed) end
    button:SetHighlightTexture(texture_high)
	button:SetMouseEnable(true)

    button:SetScripts("OnClick", "AddonManager.MiniButton_OnClick(this, key)")
    button:SetScripts("OnEnter", "AddonManager.MiniButton_OnEnter(this)")
    button:SetScripts("OnLeave", "AddonManager.MiniButton_OnLeave(this)")

	button:RegisterForClicks("LeftButton","RightButton","MiddleButton")
    _G[tempname_but]=nil
    _G[tempname_txt1]=nil
    _G[tempname_txt2]=nil
    _G[tempname_txt3]=nil

    return button
end

function Mini.HideMiniMenu()
    show_click_delay=nil
    AddonManagerMiniFrame:Hide()
    local point, relativePoint, relativeTo, offsetX, offsetY = AddonManagerMiniFrame:GetAnchor()
    AddonManagerMiniHidden:ClearAllAnchors()
    AddonManagerMiniHidden:SetAnchor(point, relativePoint, relativeTo, offsetX, offsetY)

    local texture = AddonManagerMiniHidden:GetNormalTexture()
    if string.find(relativePoint,"RIGHT") then
        texture:SetTexCoord(0.6875, 0, 0, 1)
    else
        texture:SetTexCoord(0, 0.6875, 0, 1)
    end

    AddonManagerMiniHidden:Show()
end

function Mini.ShowMiniMenu()
    if AddonManagerMiniHidden:IsVisible() then
        show_click_delay = show_click_delay or GetTime()
        AddonManagerMiniHidden:Hide()
    end
    AddonManagerMiniFrame:Show()
end

function Mini.LayoutIcons()
    local x=14
    if AddonManager_Settings.LockMiniBar then x=4 end

    for i, addon in ipairs(AddonManager.Addons) do
        local btn = addon.miniButton
        if btn and btn:IsVisible() then
            local w = btn:GetWidth()
            if w>64 then w=64 end

            btn:ClearAllAnchors()
            btn:SetAnchor("LEFT", "LEFT", AddonManagerMiniFrame, x, 0)
            x=x+ w
        end
    end

    AddonManagerMiniFrame:SetSize(x+4, 34)
end

function Mini.UpdateState()
    Mini.ShowIcons( AddonManagerMiniFrame:IsVisible() )
end

function Mini.Show(show)

    UIPanelAnchorFrame_OnShow( AddonManagerMiniFrame )

    if show and AddonManager_Settings.AutoHideMiniBar then
        Mini.HideMiniMenu()
        show = false
    else
        AddonManagerMiniHidden:Hide()
    end

    Nyx.SetVisible(AddonManagerMiniFrame, show)
    Mini.ShowIcons(show)

    Nyx.SetVisible(AddonManagerMiniFrameBorder, AddonManager_Settings.ShowMiniBarBorder)
    Nyx.SetVisible(AddonManagerMiniFrame_Corner, not AddonManager_Settings.LockMiniBar)
end

local function GetListOfButtons(visible)
    local res={}
    for i, addon in ipairs(AddonManager.Addons) do
        if addon.miniButton and AddonManager.ShowAddonInMini(addon.name) then
            if addon.miniButton:IsVisible()==visible then
                table.insert(res,addon.miniButton)
            end
        end
    end
    return res
end

function Mini.StartMinimizeDelay()
    if AddonManager_Settings.AutoHideMiniBar then
    	WaitTimer.Delay(CLOSE_DELAY,Mini.Minimize,"AM_MINI")
    end
end

function Mini.Minimize()
    local res=GetListOfButtons(true)
    ANIM_FACTOR = -#res*10/ANIM_TIME
  	WaitTimer.Delay(0,Mini.MinimizeUpdate,"AM_MINIUP", res)
end

function Mini.MinimizeUpdate(btns)
    local icons= math.min(#btns,math.max(1,ANIM_FACTOR*WaitTimer.Remaining("AM_MINIUP")))
    for i=1,icons do
        local btn = table.remove(btns,#btns)
        btn:Hide()
    end

    Mini.LayoutIcons()

    if #btns>0 then
        return 0
    end

    Mini.HideMiniMenu()
end

function Mini.Restore()
    Mini.ShowMiniMenu()
    Mini.ShowIcons(true)
    WaitTimer.Stop("AM_MINI")
    WaitTimer.Stop("AM_MINIUP")
end

function Mini.ShowIcons(show)
    for i, addon in ipairs(AddonManager.Addons) do
        if addon.miniButton then
            if show and AddonManager.ShowAddonInMini(addon.name) then
                addon.miniButton:Show()
            else
                addon.miniButton:Hide()
            end
        end
    end
    Mini.LayoutIcons()
end

function Mini.OnEnterHidden()
    Mini.ShowMiniMenu()
    Mini.OnEnter()
end

function Mini.OnEnter()
    if AddonManager_Settings.AutoHideMiniBar then
        Mini.Restore()
    end
end

function Mini.OnLeave()
    Mini.StartMinimizeDelay()
end

UIPANELANCHORFRAME_TOOLTIP = UIPANELANCHORFRAME_TOOLTIP..AddonManager.L.AnchorFrame_Addition
local ori_AutoAnchorManager_CalculateDeltaXY = AutoAnchorManager_CalculateDeltaXY
function AutoAnchorManager_CalculateDeltaXY( autoAnchorFrame )
    local temp = DF_AutoAnchorScope

    if IsCtrlKeyDown() then
        DF_AutoAnchorScope = 0
    end

    local Anchor_DeltaX, Anchor_DeltaY = ori_AutoAnchorManager_CalculateDeltaXY( autoAnchorFrame )
    DF_AutoAnchorScope = temp

    return Anchor_DeltaX, Anchor_DeltaY
end


