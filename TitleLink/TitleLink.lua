
-- Constant text
local VERSION_STR = "v1.0.1"
local AUTHOR = "Jaamosan"

-- Localizable text
local ADDON_NAME = "TitleLink"
local DESCRIPTION = "Allows linking of titles from default UI"

local ERROR_HOOK_TITLE_FRAME = ADDON_NAME.." error:  cannot hook title frame"
local ERROR_HOOK_CHAR_SHEET = ADDON_NAME.." error:  cannot hook character sheet"


local function AddonManagerRegister()
	if AddonManager then
		local addon = {
			name = ADDON_NAME,
			version = VERSION_STR,
			author = AUTHOR,
			description = DESCRIPTION,
			icon = "interface/icons/quest_paperstack03",
			category = "Interface",
			miniButton = nil,
			onClickScript = nil
		}

		if AddonManager.RegisterAddonTable then
			AddonManager.RegisterAddonTable(addon)
		else
			AddonManager.RegisterAddon(addon.name, addon.description, addon.icon, addon.category, 
				addon.configFrame, addon.slashCommands, addon.miniButton, addon.onClickScript, addon.version, addon.author)
		end
	end
end


function TitleLink_OnLoad(frame)
	frame:RegisterEvent("VARIABLES_LOADED")

	TitleLink_HookUi()
end


function TitleLink_OnEvent(frame, event)
	if (event == "VARIABLES_LOADED") then
		AddonManagerRegister()
	end
end

--------------------------------------------------------------------------------

function OutputText(msg, red, green, blue)
	DEFAULT_CHAT_FRAME:AddMessage(msg, red, green, blue)
end


-- Forge a tooltip to read the localized name of the skill.
local function DiscoverName(id)
	local link = string.format("|H%s:%x|h%s|h", "item", id, "[IdName]")

	TitleLink_Tooltip:ClearLines()
	TitleLink_Tooltip:SetHyperLink(link)
	TitleLink_Tooltip:Hide()

	return TitleLink_TooltipTextLeft1:GetText()
end


local function InjectLink(id)
	-- invalid if none or custom
	if (id > 0) then
		local link = string.format("|H%s:%x|h%s|h", "item", id, "|cffffffb2["..DiscoverName(id).."]|r")
		-- if not inserted into chat editbox, display locally in chatframe
		if not (ChatEdit_AddItemLink(link)) then
			OutputText(link)
		end
	end
end

--------------------------------------------------------------------------------

-- Hook built-in frames to allow shift-clicking for a hyperlink.
function TitleLink_HookUi()
	local default_ATF_TitleItem_OnClick
	local default_CharacterPlayerTitleFrame_OnClick

	if (ATF_TitleItem_OnClick) then
		default_ATF_TitleItem_OnClick = ATF_TitleItem_OnClick
		ATF_TitleItem_OnClick = function(frame, ...)
			if (IsShiftKeyDown()) then
				InjectLink(frame.info.titleID)
			else
				default_ATF_TitleItem_OnClick(frame, ...)
			end
		end
	else
		OutputText(ERROR_HOOK_TITLE_FRAME, 0.5, 0.5, 0.5)
	end

	-- Override the XML script array element rather than a specific called function
	if (CharacterPlayerTitleFrame) then
		default_CharacterPlayerTitleFrame_OnClick = CharacterPlayerTitleFrame["__uiLuaOnClick__"]
		CharacterPlayerTitleFrame["__uiLuaOnClick__"] = function(...)
			if (IsShiftKeyDown()) then
				InjectLink(GetCurrentTitle())
			else
				default_CharacterPlayerTitleFrame_OnClick(...)
			end
		end
	else
		OutputText(ERROR_HOOK_CHAR_SHEET, 0.5, 0.5, 0.5)
	end
end
