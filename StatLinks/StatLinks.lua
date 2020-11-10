
StatLinks = {
	Version = "0.4",
	Author = "Zhur",
	Original_ChatEdit_AddItemLink = nil,
        ManaStoneTier1ID = 202840,
        ManaStoneTier20ID = 202859,
        ManaStoneTier4ID = 202843,
	
	NameAndStat = {
		-- Balanced accessories
		[229698] = true,
		[229699] = true,
		[229700] = true,
		-- Blue crap from KBN
		[227700] = true,
		[227701] = true,
		[227702] = true,
		[227703] = true,
		[227704] = true,
		[227705] = true,
		[227706] = true,
		[227707] = true,
		[227708] = true,
		[227709] = true,
		[227710] = true,
		[227711] = true,
	},
};


function StatLinks:parse_item_link(link)
	if(not link) then
		return nil;
	end
	local itemID, bindType, runes_plus_tier_max_dur, stat12, stat34, stat56, rune1, rune2, rune3, rune4, dur, hash, color, name = 
		string.match(link, "|Hitem:([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+)|h|c([0-9a-f]+)%[(.+)%]|[hr]");
	if(not name) then
		--try without color
		color = "ffffff";
		itemID, bindType, runes_plus_tier_max_dur, stat12, stat34, stat56, rune1, rune2, rune3, rune4, dur, hash, name = 
			string.match(link, "|Hitem:([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+) ([0-9a-f]+)|h%[(.+)%]|[hr]");
		if(not name) then
			--try it without any modifiers OR color (vendor link)
			bindType, runes_plus_tier_max_dur, stat12, stat34, stat56, rune1, rune2, rune3, rune4, dur, hash = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
			itemID, name = string.match(link, "|Hitem:([0-9a-f]+)|h%[(.+)%]|[hr]");
			if(not name) then
				--try it without any modifiers (vendor link)
				itemID, color, name = string.match(link, "|Hitem:([0-9a-f]+)|h|c([0-9a-f]+)%[(.+)%]|[hr]");
				if(not name) then
					return nil;
				end
			end
		end
	end
	if(string.len(color) == 8) then
		color = string.sub(color, 3);
	end
	
	local stats = {};
	for n,v in pairs({stat12, stat34, stat56}) do
		if(v ~= "0") then
			-- we have at least one stat.
			if(string.len(v) < 5) then
				--single stat
				table.insert(stats, tonumber(v, 16));
			else
				local s1 = string.sub(v, 1, 4);
				local s2 = string.sub(v, 5);
				table.insert(stats, tonumber(s1, 16));
				table.insert(stats, tonumber(s2, 16));
			end
		end
	end
	
	
	local unknown, rune_plus, rarity_tier, max_dur = string.match("0000000"..runes_plus_tier_max_dur, "([0-9a-f][0-9a-f])([0-9a-f][0-9a-f])([0-9a-f][0-9a-f])([0-9a-f][0-9a-f])$");
	rune_plus = tonumber(rune_plus, 16);
	rarity_tier = tonumber(rarity_tier, 16);
	local plus = rune_plus % 32;
	local emptyRuneSlots = math.floor(rune_plus/32);
	local rarity = math.floor(rarity_tier/32);
	local tier = rarity_tier % 32;
	
	-- bindType contains the following information:
	-- 0x001 - item unbound
	-- 0x002 - has been previously unbound
	-- 0x100 - prevent hijack - whatever that means
	-- 0x200 - hide durability
	-- 0x400 - Skill Set Extracted
	-- 0x10000 - unknown, but seen on real items.
	local bindType = tonumber(bindType, 16);
	local unbound = ((bindType%2) == 1);
	local bindOnEquip = ((math.floor(bindType/2)%2) == 1);
	local skillExtracted = ((math.floor(bindType/0x400)%2) == 1);

	local result = {
		itemID=tonumber(itemID, 16),
		bindType=bindType,
		unbound=unbound,
		bindOnEquip=bindOnEquip,
		skillExtracted=skillExtracted,
		stats=stats,
		runes = {
				tonumber(rune1, 16),
				tonumber(rune2, 16),
				tonumber(rune3, 16),
				tonumber(rune4, 16),
			},
		emptyRuneSlots=emptyRuneSlots,
		plus=plus,
		tier_add=tier-10,
		rarity_add=rarity,
		max_dur=tonumber(max_dur, 16),
		dur=tonumber(dur, 16)/100,
		hash=tonumber(hash, 16),
		color=color,
		misc=tonumber(unknown, 16),
		name=name
		};
	
	return result;
end
function StatLinks:_getStatName(id)
	local sns, name;
	if(id > 500000) then
		--try it directly.
		sns = 'Sys' .. id .. '_name';
		name = TEXT(sns);
		if(name ~= sns) then
			return name;
		end
	end
	
	-- Off by 0x70000 is the most common.
	sns = 'Sys' .. (id + 0x70000) .. '_name';
	name = TEXT(sns);
	if(name ~= sns) then
		return name;
	end
	
	-- Last ditch effort, try 500000
	sns = 'Sys' .. (id + 500000) .. '_name';
	return(TEXT(sns));
end


function StatLinks:OnLoad(this)
	this:RegisterEvent("VARIABLES_LOADED");
end

function StatLinks:Toggle()
	if(StatLinksSettings.enabled) then
		StatLinks.Disable();
	else
		StatLinks.Enable();
	end
end

function StatLinks.Enable()
	StatLinksSettings.enabled = true;
	DEFAULT_CHAT_FRAME:AddMessage("StatLinks has been enabled.");
end

function StatLinks.Disable()
	StatLinksSettings.enabled = false;
	DEFAULT_CHAT_FRAME:AddMessage("StatLinks has been disabled.");
end

function StatLinks.RewriteLink(link)
	-- Looking specifically for mana stones.
	local item = StatLinks:parse_item_link(link);
	if(item and item.itemID >= StatLinks.ManaStoneTier1ID and item.itemID <= StatLinks.ManaStoneTier20ID) then
		--we have a mana stone.
		if(item.stats and #item.stats == 1) then
			-- We have a stone with only one stat
			local statName = StatLinks:_getStatName(item.stats[1]);
			link = string.gsub(link, "%["..item.name.."%]", "["..statName.."]");
		end
	end
	-- Not sure I actually want this...
	--if(item and StatLinks.NameAndStat[item.itemID]) then
	--	if(item.stats and #item.stats == 1) then
	--		-- We have a stone with only one stat
	--		local statName = StatLinks:_getStatName(item.stats[1]);
	--		link = string.gsub(link, "%["..item.name.."%]", "["..item.name..": "..statName.."]");
	--	end
	--end
	return(link);
end

function StatLinks.ChatEdit_AddItemLink(link)
	if(StatLinksSettings.enabled) then
		link = StatLinks.RewriteLink(link);
	end
	StatLinks.Original_ChatEdit_AddItemLink(link);
end

--- This is a patch for AAH which displays stat names in the list ---
function StatLinks.BrowseAddItemToList(pageNumber, itemIndex)
	StatLinks.Original_BrowseAddItemToList(pageNumber, itemIndex);
	
	if(StatLinksSettings.enabled) then
		local list = AuctionBrowseList.list
		local index = #(AuctionBrowseList.list)
		--Look specifically for Mana Stone items.
		local itemid = AAHVar.AuctionBrowseCache.CACHEDDATA[pageNumber][itemIndex].itemid;
		if(list[index] and itemid >= StatLinks.ManaStoneTier1ID and itemid <= StatLinks.ManaStoneTier20ID) then
			local link = GetAuctionBrowseItemLink(list[index].auctionid);
                        local item = StatLinks:parse_item_link(link);
			
			if(item and item.stats and #item.stats == 1) then
				-- We have a stone with only one stat
				list[index].name = StatLinks:_getStatName(item.stats[1]);
			end
		end
		if(list[index] and StatLinks.NameAndStat[itemid]) then
			local link = GetAuctionBrowseItemLink(list[index].auctionid);
                        local item = StatLinks:parse_item_link(link);
			if(item.stats and #item.stats == 1) then
				-- We have an item with only one stat
				local statName = StatLinks:_getStatName(item.stats[1]);
				list[index].name = item.name..": "..statName;
			end
		end
	end
end
function StatLinks.AAH3_BrowseAddItemToList(pageNumber, itemIndex)
	StatLinks.Original_AAH3_BrowseAddItemToList(pageNumber, itemIndex);
	
	if(StatLinksSettings.enabled) then
		local list = AAH.Browse.Results.list
		local index = #(AAH.Browse.Results.list)
		--Look specifically for Mana Stone items.
		local listing = AAH.Browse.Cache.CACHEDDATA[pageNumber][itemIndex];
		local itemid = listing.itemid;
		
		if(list[index] and itemid >= StatLinks.ManaStoneTier1ID and itemid <= StatLinks.ManaStoneTier20ID) then
			local link = GetAuctionBrowseItemLink(list[index].auctionid);
                        local item = StatLinks:parse_item_link(link);
			
			if(item and item.stats and #item.stats == 1) then
				-- We have a stone with only one stat
				list[index].name = StatLinks:_getStatName(item.stats[1]);
			end
		end
		if(list[index] and StatLinks.NameAndStat[itemid]) then
			local link = GetAuctionBrowseItemLink(list[index].auctionid);
                        local item = StatLinks:parse_item_link(link);
			if(item.stats and #item.stats == 1) then
				-- We have an item with only one stat
				local statName = StatLinks:_getStatName(item.stats[1]);
				list[index].name = item.name..": "..statName;
			end
		end
	end
end


function StatLinks:OnEvent(event)
	if (event == "VARIABLES_LOADED") then
                SLASH_StatLinks1 = "/StatLinks";
		SlashCmdList["StatLinks"] = function (editbox, msg) 
			StatLinks:Toggle();
		end
		
		if(not StatLinksSettings) then
			StatLinksSettings = {
				enabled = true
				};
		end
		SaveVariables("StatLinksSettings");
		
		--Hook the normal method.
		if(not self.Original_ChatEdit_AddItemLink) then
			self.Original_ChatEdit_AddItemLink = _G.ChatEdit_AddItemLink;
			_G.ChatEdit_AddItemLink = self.ChatEdit_AddItemLink;
		end
		
		--Hook AAH if installed.
		if(AAHFunc and not self.Original_BrowseAddItemToList) then
			self.Original_BrowseAddItemToList = AAHFunc.BrowseAddItemToList;
			AAHFunc.BrowseAddItemToList = self.BrowseAddItemToList;
		end
		--Newer versions of AAH
		if(AAH and AAH.Browse and not self.Original_AAH3_BrowseAddItemToList) then
			self.Original_AAH3_BrowseAddItemToList = AAH.Browse.AddItemToList;
			AAH.Browse.AddItemToList = self.AAH3_BrowseAddItemToList;
		end
		
		if AddonManager then
		    local addon = {
			name = "StatLinks",
			version = StatLinks.Version,
			author = StatLinks.Author,
			description = "More readable stat item links",
			-- icon = "Interface/Addons/FriendNotes/FriendNotes.png",
			category = "Other",
			configFrame = false, 
			slashCommand = "/StatLinks",
			miniButton = false,
			onClickScript = false,
			disableScript = StatLinks.Disable,
			enableScript = StatLinks.Enable,
		    }
		    if AddonManager.RegisterAddonTable then
			AddonManager.RegisterAddonTable(addon)
		    else
			AddonManager.RegisterAddon(addon.name, addon.description, addon.icon, addon.category, 
			    addon.configFrame, addon.slashCommand, addon.miniButton, addon.onClickScript, addon.version, addon.author)
		    end
		end
	end
end








