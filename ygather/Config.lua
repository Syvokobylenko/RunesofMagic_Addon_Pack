
if (yGather.config == nil) then
    yGather.config = {}
end

function yGather.config:SetConfigDialog(frame)
    self.configDialog = frame;
end;

function yGather.config:ShowConfigDialog()
    if (self.configDialog) then
        self.configDialog:Show();
    end
end;

function yGather.config:AddTab(tab)
    if (not tab) then
        return;
    end
    if (not self.tabs) then
        self.tabs = {};
    end
    self.tabs[tab:GetID()] = tab;
end

function yGather.config:OnTabClick(tab)
    if (self.selectedTab) then
        PanelTemplates_DeselectTab(self.selectedTab);
        self.tabFrames[self.selectedTab:GetID()]:Hide();
    end
    PanelTemplates_SelectTab(tab);
    self.tabFrames[tab:GetID()]:Show();
    self.selectedTab = tab;
end

function yGather.config:ResetTabs(defaultTab)
    assert(self.tabs, "Tabs added");
    for id, tab in pairs(self.tabs) do
        if (tab == defaultTab) then
            PanelTemplates_SelectTab(tab);
            self.selectedTab = defaultTab;
            local tabFrame = self.tabFrames[tab:GetID()];
            assert(tabFrame, "No tab frame for tab " .. tab:GetID());
            tabFrame:Show();
        else
            PanelTemplates_DeselectTab(tab);
            local tabFrame = self.tabFrames[tab:GetID()];
            assert(tabFrame, "No tab frame for tab " .. tab:GetID());
            tabFrame:Hide();
        end
    end
    
end

function yGather.config:AddTabFrame(frame)
    if (not frame) then
        return;
    end
    if (not self.tabFrames) then
        self.tabFrames = {};
    end
    self.tabFrames[frame:GetID()] = frame;
end

function yGather.config:InitializeListBox(listBox)
    local key = listBox.configKey;
    local entries = listBox.listEntries;
    
    local function ClickFunction(button)
        local option = button.arg1;
        local text = button:GetText();
        yGather.settings.SetTemporaryValue(key, option);
        UIDropDownMenu_SetText(listBox, text);
    end
    
    local function ShowFunction()
        local info;
        for option, text in pairs(entries) do
            info = {};
            info.text = yGather.translate(text[1]);
            info.arg1 = option;
            info.tooltipText = yGather.translate(text[2]);
            info.func = ClickFunction;
            info.notCheckable = 1;
            UIDropDownMenu_AddButton(info);
        end	
    end
    
	UIDropDownMenu_SetWidth(listBox, 120);
	UIDropDownMenu_Initialize(listBox, ShowFunction);
end

function yGather.config:OpenColorPicker(button)
    local configKey = button.configKey;
    local title = yGather.translate(button.textKey) .. " color";
    local oldColor = yGather.settings.GetValue(configKey);
    
    local function OkayFunction()
    end
    
    local function CancelFunction()
        yGather.settings.SetTemporaryValue(configKey, oldColor);
        _G[button:GetName() .. "_Color"]:SetColor(unpack(oldColor));
    end
    
    local function UpdateFunction()
        local r, g, b = ColorPickerFrame.r, ColorPickerFrame.g, ColorPickerFrame.b;
        _G[button:GetName() .. "_Color"]:SetColor(r, g, b);
        yGather.settings.SetTemporaryValue(configKey, {r, g, b});
    end
    
    local info = {};
    info.parent = yGather_ConfigDialogFrame;
    info.titleText = title;
    info.alphaMode = nil;
    info.r, info.g, info.b = unpack(yGather.settings.GetValue(configKey));
    info.brightnessUp = 1;
    info.brightnessDown = 0;
    info.callbackFuncOkay = OkayFunction;
    info.callbackFuncUpdate = UpdateFunction;
    info.callbackFuncCancel = CancelFunction;
    OpenColorPickerFrameEx(info);
end

function yGather.config:ConfigDialogFrame_OnShow(frame)
    yGather_ConfigTitleText:SetText("yGather " .. yGather.translate("config/title"));
end

function yGather.config.ShowConfigDialog()
    yGather_ConfigDialogFrame:Show();
end

function yGather.config.GetColorShowHideFunction(button, key)
    return function()
        local iconSetName = yGather.settings.GetValue(key);
        local iconSet = yGather.iconsets.GetByName(iconSetName);
        local colored = false;
        if (nil ~= iconSet) then
            colored = iconSet.coloring or false;
        end
        if (colored) then
            button:Show();
        else
            button:Hide();
        end
    end
end;

SLASH_yGatherConfig1 = "/yGather";
SLASH_yGatherConfig2 = "/ygather";
SlashCmdList["yGatherConfig"] = yGather.config.ShowConfigDialog;

yGather.config.miscFrame = {};
function yGather.config.miscFrame.OnLoad(this)
    local languages = yGather.i18n.GetLanguages();
    local options = {};
    table.insert(options, {nil, "common/default"});
    for _, entry in ipairs(languages) do
        table.insert(options, {entry[1], entry[2]});
    end;
    yGather.templates.listBox.Initialize(this, "config/misc/uiLanguage", "misc/uilanguage", options);
end;

