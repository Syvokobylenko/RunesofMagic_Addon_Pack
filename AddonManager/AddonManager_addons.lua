local Nyx = LibStub("Nyx")

local AddonManager = _G.AddonManager
local tab_addons = {}

AddonManager.tabs = {}
AddonManager.tabs[1]=tab_addons

function AddonManager.GetAddonAtIndex(id)
    local num = (AddonManagerFrame.page - 1) * DF_MAXPAGESKILL_SKILLBOOK + id

    local filter = UIDropDownMenu_GetSelectedID(AddonManagerCategoryFilter)
    if filter == 1 then  -- All
        return AddonManager.Addons[num]
    else
        filter = AddonManager.Categories[filter - 1]
        local count = 1
        for _, addon in pairs(AddonManager.Addons) do
            if addon.category == filter then
                count = count + 1
                if count > num then
                    return addon
                end
            end
        end
    end
end

function tab_addons.GetCount()
    return #AddonManager.Addons
end

function tab_addons.OnShow()
    table.sort(AddonManager.Addons, AddonManager.AddonSortFn)
    AddonManager.UpdateButtons()
    AddonManagerFramePageAddons:Show()
end

function tab_addons.OnHide()
    AddonManagerFramePageAddons:Hide()
end

function tab_addons.ShowButton(index, basename)
    local addon = AddonManager.Addons[index]

    local catname = AddonManager.L.CAT[addon.category]
    if AddonManager_Settings.ShowSlashCmdInsteadOfCat then
        catname = addon.slashCommands
    end

    local minibutton= nil
    if addon.miniButton then
        minibutton = AddonManager.ShowAddonInMini(addon.name)==true
    end

    local enablebutton= nil
    if addon.disableScript and addon.enableScript then
        enablebutton = not AddonManager.IsAddonDisabled(addon.name)
    end


    AddonManager.SetButtons(basename, addon.name, catname,
        addon.icon or DEFAULT_ICON, nil,
        minibutton, enablebutton,
        AddonManager.IsActive(addon) )
end

function tab_addons.OnAddonClicked(index)

    local addon = AddonManager.Addons[index]

    if addon.onClickScript then
        addon.onClickScript(btn)

    elseif addon.configFrame then
        ToggleUIFrame(addon.configFrame)
        GameTooltip:Hide()
    end
end

function tab_addons.OnAddonEntered(btn, index)

    local addon = AddonManager.Addons[index]
    AddonManager.ShowTooltipOfAddon(btn,addon)
end

function tab_addons.OnCheckMiniBtn(index, is_checked)

    local addon = AddonManager.Addons[index]
    if is_checked then
        for i,name in ipairs(AddonManager_UncheckedAddons) do
            if name==addon.name then
                table.remove(AddonManager_UncheckedAddons,i)
                break
            end
        end
    else
        table.insert(AddonManager_UncheckedAddons, addon.name)
    end

    AddonManager.Mini.UpdateState()
end

function tab_addons.OnCheckEnableBtn(index, is_checked)

    local addon = AddonManager.Addons[index]
    if is_checked then
        SetAddonEnabled(addon.name, true)
        addon.enableScript()
    else
        SetAddonEnabled(addon.name, false)
        addon.disableScript()
    end
end

-----------------------------------------
local tab_minimap = {}
AddonManager.tabs[2]=tab_minimap

local FIXED_NAMES={
    ["MinimapFramePlusButton"] = "Minimap Zoom+",
    ["MinimapFrameMinusButton"] = "Minimap Zoom-",
    ["MinimapFrameTopupButton"] = "Dia-Shop",
}

local MANUAL_FRAMES={
    -- ROM
    ["MinimapFrameBugGartherButton"] = false,
    ["PlayerFramePetButton"] = true,
    ["PlayerFramePartyBoardButton"] = true,
    ["PlayerFrameWorldBattleGroundButton"] = true,
    ["PetBookFrameButton"] = true,
    ["MinimapFramePlusButton"] = true,
    ["MinimapFrameMinusButton"] = true,
    ["MinimapFrameTopupButton"] = true,

    -- Addons
    ["LootIt_MinimapButton"] = true,
    ["Ikarus_MinimapButton"] = true,
    ["TitleSelectMinimapButton"] = true,
    ["SummonMyPet_Minimap"] = true,
    ["kwSpeedUpButton"] = true,
    ["afStayWithMe_Minimap_Switch"] = true,

    --["ComeOnInFrame_Minimap_Shout"] = false,
    --["ComeOnInFrame_Minimap_Config"] = false,
}

local minimap_frames

local function ListOfMinimapButtons()

    if minimap_frames then
        return minimap_frames
    end

    minimap_frames={}
    for _,val in pairs(_G) do
        if type(val)=="table" then
            if val.func_UpdateAnchor == UIPanelAnchorFrameManager_UpdateAnchor_RelativeToMinimap then
                --val.groupId== 20090401 ??? then
                table.insert(minimap_frames,val)
            end
        end
    end

    for framename, add in pairs(MANUAL_FRAMES) do
        local frame = _G[framename]
        local idx = Nyx.TableIndexOf(minimap_frames,frame)

        if frame then
            if add and not idx then
                table.insert(minimap_frames,frame)
            else
                if idx then
                    table.remove(minimap_frames,idx)
                end
            end
        end
    end

    table.sort(minimap_frames, function(a,b) return a:GetName()<b:GetName() end)

    return minimap_frames
end

local function GetMinimapName(frame)
    local name = frame:GetName()
    local fname = FIXED_NAMES[name]
    if fname then
        return fname
    end

    name = string.gsub(name,"Minimap","")
    name = string.gsub(name,"Button","")
    name = string.gsub(name,"Frame","")
    name = string.gsub(name,"^[_ ]","")
    name = string.gsub(name,"[_ ]$","")
    return name
end

function tab_minimap.GetCount()
    local list = ListOfMinimapButtons()
    return #list
end

function tab_minimap.OnShow()
    minimap_frames=nil
    AddonManager.UpdateButtons()
    AddonManagerFramePageAddons:Show()
end

function tab_minimap.OnHide()
    AddonManagerFramePageAddons:Hide()
end

function tab_minimap.ShowButton(index, basename)

    local mapbtn = ListOfMinimapButtons()[index]

    AddonManager.SetButtons(basename, GetMinimapName(mapbtn) , mapbtn:GetName(),
        nil, mapbtn.GetNormalTexture and mapbtn:GetNormalTexture(),
        mapbtn:IsVisible(), nil,
        true )
end

function tab_minimap.OnAddonClicked(index)
    local mapbtn = ListOfMinimapButtons()[index]

    if mapbtn.__uiLuaOnClick__ then
        mapbtn.__uiLuaOnClick__(btn)
    end
end

function tab_minimap.OnAddonEntered(btn, index)

    local mapbtn = ListOfMinimapButtons()[index]

    GameTooltip:ClearAllAnchors()
    GameTooltip:SetOwner(btn, "ANCHOR_RIGHT", 10, 0)
    GameTooltip:SetText("Minibutton")

    if mapbtn.__uiLuaOnMouseEnter__ then
        mapbtn.__uiLuaOnMouseEnter__(btn)

        AddonManager.onitemleave = mapbtn.__uiLuaOnMouseLeave__

        GameTooltip:ClearAllAnchors()
        GameTooltip:SetOwner(btn, "ANCHOR_RIGHT", 10, 0)
    end


    GameTooltip:AddLine(mapbtn:GetName())
    GameTooltip:Show()
end

function tab_minimap.OnCheckMiniBtn(index, is_checked)
    local mapbtn = ListOfMinimapButtons()[index]
    Nyx.SetVisible(mapbtn, is_checked)
    AddonManager_MinimapButtons[mapbtn:GetName()] = is_checked
end

function tab_minimap.OnCheckEnableBtn(index, is_checked)
end


-----------------------------------------
local tab_settings = {}
AddonManager.tabs[3]=tab_settings

function tab_settings.OnShow()
    Sol.config.LoadConfig("AddonManager")
    AddonManagerFramePageSettings:Show()
end

function tab_settings.OnHide()
    AddonManagerFramePageSettings:Hide()
end

