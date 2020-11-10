if (yGather.templates == nil) then
    yGather.templates = {};
end;

yGather.templates.listBox = {};

local ipairs = ipairs;
local tostring = tostring;

local yGather = yGather;

local _G = _G;
local UIDropDownMenu_SetText = UIDropDownMenu_SetText;
local UIDropDownMenu_Initialize = UIDropDownMenu_Initialize;
local UIDropDownMenu_SetWidth = UIDropDownMenu_SetWidth;
local UIDropDownMenu_AddButton = UIDropDownMenu_AddButton;
local UIDropDownMenu_SetSelectedID = UIDropDownMenu_SetSelectedID;

setfenv(1, yGather.templates.listBox);

function Initialize(this, labelTextKey, configKey, listEntries)
    this.yG = {};
    this.yG.labelTextKey = labelTextKey;
    this.yG.configKey = configKey;
    this.yG.listEntries = listEntries;
    this.yG.labelText = _G[this:GetName() .. "_Label_Text"];
    this.yG.dropDown = _G[this:GetName() .. "_DropDown"];
end;

local function GetSelectionText(this, option)
    for _, entry in ipairs(this.yG.listEntries) do
        if (entry[1] == option) then
            return yGather.translate(entry[2]);
        end;
    end;
end;

local function InitializeDropDown(this)
    local function ClickFunction(button)
        local option = button.arg1;
        local text = button:GetText();
        yGather.settings.SetTemporaryValue(this.yG.configKey, option);
        UIDropDownMenu_SetText(this.yG.dropDown, text);
    end
    
    local function ShowFunction()
        for _, entry in ipairs(this.yG.listEntries) do
            local info = {};
            info.arg1 = entry[1];
            info.text = yGather.translate(entry[2]);
            info.tooltipText = yGather.translate(entry[3]);
            info.notCheckable = 1;
            info.checked = false;
            info.func = ClickFunction;
            UIDropDownMenu_AddButton(info);
        end	
    end
    
	UIDropDownMenu_SetWidth(this.yG.dropDown, 120);
	UIDropDownMenu_Initialize(this.yG.dropDown, ShowFunction);
    UIDropDownMenu_SetText(this.yG.dropDown, GetSelectionText(this, yGather.settings.GetValue(this.yG.configKey)));
end;

function OnShow(this)
    InitializeDropDown(this);
    local entries = this.yG.listEntries;
    local currentValue = yGather.settings.GetValue(this.yG.configKey);

    local i = 1;
    local found = false;
    while ((i <= #entries) and not found) do
        found = entries[i][1] == currentValue;
        i = i + 1;
    end;
    if (found) then
        i = i - 1;
    else
        i = 1;
    end;

    --UIDropDownMenu_SetSelectedID(this.yG.dropDown, i);
    this.yG.labelText:SetText(yGather.translate(this.yG.labelTextKey) .. ":");
end;

