local SavedSearch={
    Options = {
        TEXT("C_SEARCH"),					--Search
        AAHLocale.Messages.BROWSE_RENAME,	--Rename
        TEXT("C_DEL"),					--Delete
    },
	Expand = {},
	NewItem = {},
	DragDrop = {},
	RenameItem = {},
}
AAH.SavedSearch = SavedSearch

function SavedSearch.OnLoad()
	AAH_BrowseSavedSearchTitle:SetText(AAHLocale.Messages.BROWSE_SAVED_SEARCH_TITLE)
end

function SavedSearch.ExpandButton_OnClick()
    AAH_BrowseSavedSearchExpandButton:Hide()
    AAH_BrowseSavedSearchMinimizeButton:Show()
    AAH_BrowseSavedSearchPlusButton:Enable()
    AAH_BrowseSavedSearch:Show()
end

function SavedSearch.MinimizeButton_OnClick()
    AAH_BrowseSavedSearchExpandButton:Show()
    AAH_BrowseSavedSearchMinimizeButton:Hide()
    AAH_BrowseSavedSearchPlusButton:Disable()
    AAH_BrowseSavedSearch:Hide()
end

function SavedSearch.ScrollBar_Update()
	local maxValue = #(AAH_SavedSearch)
	if SavedSearch.Expand[1] then
		maxValue = maxValue + #(AAH_SavedSearch[SavedSearch.Expand[1]]["contents"])
		if SavedSearch.Expand[2] then
			maxValue = maxValue + #(SavedSearch.Options)
		end
	end
	maxValue = maxValue - ((AAH.Browse.DisplayedItems * 2) + 5)
	if maxValue > 0 then
		AAH_BrowseSavedSearchScrollBar:Show()
		AAH_BrowseSavedSearchScrollBar:SetMinMaxValues(0, maxValue)
	else
		AAH_BrowseSavedSearchScrollBar:Hide()
		AAH_BrowseSavedSearchScrollBar:SetMinMaxValues(0, 0)
	end
	SavedSearch.UpdateList()
end

function SavedSearch.UpdateList()
	local layer = 1
	local index = 1
	local text
	local folder = 1
	local item = 0
	local option = 0
	local count = 1
	local scroll = AAH_BrowseSavedSearchScrollBar:GetValue()
	while AAH_SavedSearch[folder] do
		if count > (AAH.Browse.DisplayedItems * 2) + 6 then
			return
		end
		if scroll > 0 then
			scroll = scroll - 1
		else
			local button = getglobal("AAH_BrowseSavedSearchButton"..count)
			local normalText = getglobal(button:GetName().."NormalText")
			local highlightText = getglobal(button:GetName().."HighlightText")
			local lineTexture = getglobal(button:GetName().."Line")
			local backgoundTexture = getglobal(button:GetName().."Backgound")
			local width = button:GetWidth()
			if option > 0 then
				layer = 3
				index = option
				text = SavedSearch.Options[index]
			elseif item > 0 then
				layer = 2
				index = item
				text = AAH_SavedSearch[folder]["contents"][item]["name"]
			else
				layer = 1
				index = folder
				text = AAH_SavedSearch[folder]["name"]
			end
			button.layer = layer
			button.index = index
			if layer == 1 then
				backgoundTexture:Show()
				backgoundTexture:SetAlpha(1.0)
				lineTexture:Hide()
				normalText:ClearAllAnchors()
				normalText:SetAnchor("LEFT", "LEFT", button:GetName(), 10, 0)
				normalText:SetWidth(width - 20)
				normalText:SetColor(1, 1, 0)
				highlightText:ClearAllAnchors()
				highlightText:SetAnchor("LEFT", "LEFT", button:GetName(), 10, 0)
				highlightText:SetWidth(width - 20)
				highlightText:SetColor(1, 1, 0)
			elseif layer == 2 then
				backgoundTexture:Show()
				backgoundTexture:SetAlpha(0.5)
				lineTexture:Hide()
				normalText:ClearAllAnchors()
				normalText:SetAnchor("LEFT", "LEFT", button:GetName(), 15, 0)
				normalText:SetWidth(width - 25)
				normalText:SetColor(1, 1, 1)
				highlightText:ClearAllAnchors()
				highlightText:SetAnchor("LEFT", "LEFT", button:GetName(), 15, 0)
				highlightText:SetWidth(width - 25)
				highlightText:SetColor(1, 1, 1)
			else
				backgoundTexture:Hide()
				lineTexture:Show()
				if index == #(SavedSearch.Options) then
					lineTexture:SetTexCoord(0, 1, 0.5, 0.8125)
				else
					lineTexture:SetTexCoord(0, 1, 0, 0.3125)
				end
				normalText:ClearAllAnchors()
				normalText:SetAnchor("LEFT", "LEFT", button:GetName(), 20, 0)
				normalText:SetWidth(width - 30)
				normalText:SetColor(1, 1, 1)
				highlightText:ClearAllAnchors()
				highlightText:SetAnchor("LEFT", "LEFT", button:GetName(), 20, 0)
				highlightText:SetWidth(width - 30)
				highlightText:SetColor(1, 1, 1)
			end
			button:SetText(text)
			if SavedSearch.Expand[layer] == index then
				button:LockHighlight()
			else
				button:UnlockHighlight()
			end
			button:Show()
			count = count + 1
		end
		if option > 0 then
			if option == #(SavedSearch.Options) then
				option = 0
				if item == #(AAH_SavedSearch[folder]["contents"]) then
					item = 0
					folder = folder + 1
				else
					item = item + 1
				end
			else
				option = option + 1
			end
		elseif item > 0 then
			if item == SavedSearch.Expand[2] then
				option = 1
			elseif item == #(AAH_SavedSearch[folder]["contents"]) then
				item = 0
				folder = folder + 1
			else
				item = item + 1
			end
		elseif folder == SavedSearch.Expand[1] then
			item = 1
		else
			folder = folder + 1
		end
	end
	for i = count, (AAH.Browse.DisplayedItems * 2) + 6 do
		getglobal("AAH_BrowseSavedSearchButton"..i):Hide()
	end
end

function SavedSearch.Button_OnClick(this, key)
	for index, value in pairs(SavedSearch.Expand) do
		if index > this.layer then
			SavedSearch.Expand[index] = nil
		end
	end
	if this.layer == 3 then
		if key == "LBUTTON" then
			if this.index == 1 then
				SavedSearch.Search(SavedSearch.Expand[1], SavedSearch.Expand[2])
			elseif this.index == 2 then
				SavedSearch.RenameItem = SavedSearch.Expand
				StaticPopup_Show("SAVEDSEARCH_RENAMEITEM")
			elseif this.index == 3 then
				table.remove(AAH_SavedSearch[SavedSearch.Expand[1]]["contents"], SavedSearch.Expand[2])
				SavedSearch.Expand[2] = nil
				if #(AAH_SavedSearch[SavedSearch.Expand[1]]["contents"]) == 0 then
					SavedSearch.RemoveFolder(SavedSearch.Expand[1], nil)
				end
			end
		elseif key == "RBUTTON" then
			--???
		end
	elseif this.layer == 2 then
		if key == "LBUTTON" then
			if SavedSearch.Expand[2] == this.index then
				SavedSearch.Expand[2] = nil
				--Make Double Click Search
			else
				SavedSearch.Expand[this.layer] = this.index
			end
		elseif key == "RBUTTON" then
			--When Double Click Searches, then this expands
		end
	elseif this.layer == 1 then
		if key == "LBUTTON" then
			if SavedSearch.Expand[1] == this.index then
				SavedSearch.Expand[this.layer] = nil
			else
				SavedSearch.Expand[this.layer] = this.index
			end
		elseif key == "RBUTTON" then
			--Find way to have folder options
		end
	end
	SavedSearch.ScrollBar_Update()
end

function SavedSearch.Button_OnDragStart(this)
	SavedSearch.DragDrop = {}
	if this.layer == 1 then
		SavedSearch.DragDrop["folder"] = this.index
	elseif this.layer == 2 then
		SavedSearch.DragDrop["folder"] = SavedSearch.Expand[1]
		SavedSearch.DragDrop["item"] = this.index
	end
end

function SavedSearch.Button_OnReceiveDrag(this)
	local offset = 0
	if SavedSearch.DragDrop["folder"] and this.layer ~= 3 then
		if SavedSearch.DragDrop["item"] then
			if this.layer == 2 then
				table.insert(AAH_SavedSearch[SavedSearch.Expand[1]]["contents"], this.index, AAH_SavedSearch[SavedSearch.DragDrop["folder"]]["contents"][SavedSearch.DragDrop["item"]])
				if this.index < SavedSearch.DragDrop["item"] then
					offset = 1
				end
				table.remove(AAH_SavedSearch[SavedSearch.DragDrop["folder"]]["contents"], SavedSearch.DragDrop["item"] + offset)
			elseif this.layer == 1 then
				table.insert(AAH_SavedSearch[this.index]["contents"], AAH_SavedSearch[SavedSearch.DragDrop["folder"]]["contents"][SavedSearch.DragDrop["item"]])
				table.remove(AAH_SavedSearch[SavedSearch.DragDrop["folder"]]["contents"], SavedSearch.DragDrop["item"])
				if #(AAH_SavedSearch[SavedSearch.DragDrop["folder"]]["contents"]) == 0 then
					SavedSearch.RemoveFolder(SavedSearch.DragDrop["folder"], this.index)
				else
					SavedSearch.Expand[1] = this.index
				end
			end
			SavedSearch.Expand[2] = nil
		elseif this.layer == 1 then
			table.insert(AAH_SavedSearch, this.index, AAH_SavedSearch[SavedSearch.DragDrop["folder"]])
			if this.index < SavedSearch.DragDrop["folder"] then
				offset = 1
			end
			table.remove(AAH_SavedSearch, SavedSearch.DragDrop["folder"] + offset)
			SavedSearch.Expand = {}
		elseif not this.layer then
			table.insert(AAH_SavedSearch, AAH_SavedSearch[SavedSearch.DragDrop["folder"]])
			table.remove(AAH_SavedSearch, SavedSearch.DragDrop["folder"])
			SavedSearch.Expand = {}
		end
	end
	SavedSearch.ScrollBar_Update()
end

function SavedSearch.CreateItem(itemname)
	local temp = {}
	temp.name = itemname
	temp.data = {}
	temp.data.Keyword = AAH_BrowseNameEditBox:GetText()
	temp.data.MinLvl = AAH_BrowseMinLvlEditBox:GetText()
	temp.data.MaxLvl = AAH_BrowseMaxLvlEditBox:GetText()
	temp.data.Rarity = UIDropDownMenu_GetSelectedID(AAH_BrowseRarityDropDown)
	temp.data.Rune = UIDropDownMenu_GetSelectedID(AAH_BrowseRuneDropDown)
	temp.data.Usable = AAH_BrowseUsableButton:IsChecked()
	temp.data.Category1 = AAH.Browse.SelectedCategory[1]
	temp.data.Category2 = AAH.Browse.SelectedCategory[2]
	temp.data.Category3 = AAH.Browse.SelectedCategory[3]
	temp.data.PPU = AAH_BrowseFilterPPUButton:IsChecked()
	temp.data.Bid = AAH_BrowseFilterBidButton:IsChecked()
	temp.data.MinPrice = AAH_BrowseFilterMinPriceEditBox:GetText()
	temp.data.MaxPrice = AAH_BrowseFilterMaxPriceEditBox:GetText()
	temp.data.Filter1 = AAH_BrowseFilter1EditBox:GetText()
	temp.data.Filter2 = AAH_BrowseFilter2EditBox:GetText()
	temp.data.Filter3 = AAH_BrowseFilter3EditBox:GetText()
	temp.data.Or2 = AAH_BrowseFilter2OrButton:IsChecked()
	temp.data.Or3 = AAH_BrowseFilter3OrButton:IsChecked()
	if SavedSearch.Expand[1] then
		SavedSearch.Expand[2] = nil
		SavedSearch.Expand[3] = nil
		table.insert(AAH_SavedSearch[SavedSearch.Expand[1]]["contents"], temp)
		SavedSearch.ScrollBar_Update()
	else
		SavedSearch.NewItem = temp
		StaticPopup_Show("SAVEDSEARCH_CREATEFOLDER")
	end
end

function SavedSearch.Search(folder, item)
	local temp = AAH_SavedSearch[folder]["contents"][item]["data"]
	AAH_BrowseNameEditBox:SetText(temp.Keyword)
	AAH_BrowseMinLvlEditBox:SetText(temp.MinLvl)
	AAH_BrowseMaxLvlEditBox:SetText(temp.MaxLvl)
	AAH.Tools.SetDropDown(AAH_BrowseRarityDropDown, temp.Rarity, AAH.Browse.RarityInfo[temp.Rarity], {GetItemQualityColor(temp.Rarity - 1)})
	AAH.Tools.SetDropDown(AAH_BrowseRuneDropDown, temp.Rune, AAH.Browse.RuneInfo[temp.Rune])
	AAH_BrowseUsableButton:SetChecked(temp.Usable)
	AAH.Browse.SelectedCategory[1] = temp.Category1
	AAH.Browse.SelectedCategory[2] = temp.Category2
	AAH.Browse.SelectedCategory[3] = temp.Category3
	AAH_BrowseFilterPPUButton:SetChecked(temp.PPU)
	AAH_BrowseFilterBidButton:SetChecked(temp.Bid)
	AAH_BrowseFilterMinPriceEditBox:SetText(temp.MinPrice)
	AAH_BrowseFilterMaxPriceEditBox:SetText(temp.MaxPrice)
	AAH_BrowseFilter1EditBox:SetText(temp.Filter1)
	AAH_BrowseFilter2EditBox:SetText(temp.Filter2)
	AAH_BrowseFilter3EditBox:SetText(temp.Filter3)
	AAH_BrowseFilter2OrButton:SetChecked(temp.Or2)
	AAH_BrowseFilter3OrButton:SetChecked(temp.Or3)
	AAH.Browse.CategoryScrollBar_Update()
	AAH.Browse.SearchButton_OnClick()
end

function SavedSearch.RemoveFolder(folder, expand)
	if expand and expand > folder then
		expand = expand - 1
	end
	table.remove(AAH_SavedSearch, folder)
	SavedSearch.Expand[1] = expand
end

StaticPopupDialogs["SAVEDSEARCH_CREATEFOLDER"] = {
	text = AAHLocale.Messages.BROWSE_CREATE_FOLDER_POPUP,
	button1 = TEXT("ACCEPT"),
	button2 = TEXT("CANCEL"),
	OnShow = function(this)
		getglobal(this:GetName().."EditBox"):SetText("")
	end,
	OnAccept = function(this)
        table.insert(AAH_SavedSearch, {["name"] = getglobal(this:GetName().."EditBox"):GetText(), ["contents"] = {},})
        table.insert(AAH_SavedSearch[#(AAH_SavedSearch)]["contents"], SavedSearch.NewItem)
        SavedSearch.ScrollBar_Update()
	end,
	OnCancel = function(this)
		SavedSearch.NewItem = {}
	end,
	hasEditBox = 1,
	hideOnEscape = 1,
}

StaticPopupDialogs["SAVEDSEARCH_CREATEITEM"] = {
	text = AAHLocale.Messages.BROWSE_NAME_SEARCH_POPUP,
	button1 = TEXT("ACCEPT"),
	button2 = TEXT("CANCEL"),
	OnShow = function(this)
		getglobal(this:GetName().."EditBox"):SetText("")
	end,
	OnAccept = function(this)
		SavedSearch.CreateItem(getglobal(this:GetName().."EditBox"):GetText())
	end,
	hasEditBox = 1,
	hideOnEscape = 1,
}

StaticPopupDialogs["SAVEDSEARCH_RENAMEITEM"] = {
	text = AAHLocale.Messages.BROWSE_RENAME_SAVED_SEARCH_POPUP,
	button1 = TEXT("ACCEPT"),
	button2 = TEXT("CANCEL"),
	OnShow = function(this)
		getglobal(this:GetName().."EditBox"):SetText("")
	end,
	OnAccept = function(this)
		AAH_SavedSearch[SavedSearch.RenameItem[1]]["contents"][SavedSearch.RenameItem[2]]["name"] = getglobal(this:GetName().."EditBox"):GetText()
		SavedSearch.ScrollBar_Update()
	end,
	hasEditBox = 1,
	hideOnEscape = 1,
}