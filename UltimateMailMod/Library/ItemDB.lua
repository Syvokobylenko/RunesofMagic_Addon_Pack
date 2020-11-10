
local ResourceItemFilter = {
  
  ItemDB = {};
  
  priv_AddDB = function(self, type, itemID)
    if (not self.ItemDB[type]) then
      self.ItemDB[type] = {};
    end
    self.ItemDB[type][itemID] = true;
  end;
  
  Init = function(self)
    self.ItemDB = nil;
    self.ItemDB = {};
  end;
  
  IsItem = function(self, type, itemLink)
    if (self.ItemDB[type]) then
      local itemkind, itemData, itemName = ParseHyperlink(itemLink);
      local _, _, itemID = string.find(itemData, "^(%x+)");
      itemID = tonumber(itemID, 16); --max item id is 16 characters long
      if (self.ItemDB[type][itemID]) then
        --DEFAULT_CHAT_FRAME:AddMessage("1");
        return true;
      else
        --DEFAULT_CHAT_FRAME:AddMessage("2");
        return nil;
      end
    else
        --DEFAULT_CHAT_FRAME:AddMessage("0");
      return nil;
    end
  end;
  
  GetTypeByID = function(self, id)
    local result = "None";
    if (id == 1) then
      result = "Runes";
    elseif (id == 2) then
      result = "FusionStones";
    elseif (id == 3) then
      result = "Juwels";
    elseif (id == 4) then
      result = "Ores";
    elseif (id == 5) then
      result = "Wood";
    elseif (id == 6) then
      result = "Herbs";
    elseif (id == 7) then
      result = "RawMaterials";
    elseif (id == 8) then
      result = "ProductionRunes";
    elseif (id == 9) then
      result = "Foods";
    elseif (id == 10) then
      result = "Desserts";
    elseif (id == 11) then
      result = "Potions";
    elseif (id == 12) then
      result = "WRecipes";		-- release 5.0.1.2553
    elseif (id == 13) then
      result = "GRecipes";		-- release 5.0.1.2553
    elseif (id == 14) then
      result = "BRecipes";		-- release 5.0.1.2553
    elseif (id == 15) then
      result = "MRecipes";		-- release 5.0.1.2553
    elseif (id == 16) then
      result = "Guild";			-- release 5.0.0.2545
    elseif (id == 17) then    
      result = "BagStat";       -- release 6.4.1.2752
    elseif (id == 18) then    
      result = "RunePetEgg";       -- release 6.4.1.2769
    elseif (id == 19) then    
      result = "EarthPetEgg";       -- release 6.4.1.2769
    elseif (id == 20) then    
      result = "WaterPetEgg";       -- release 6.4.1.2769
    elseif (id == 21) then    
      result = "FirePetEgg";       -- release 6.4.1.2769
    elseif (id == 22) then    
      result = "WindPetEgg";       -- release 6.4.1.2769
    elseif (id == 23) then    
      result = "lightPetEgg";       -- release 6.4.1.2769
    elseif (id == 24) then
      result = "DarkPetEgg";       -- release 6.4.1.2769
    elseif (id == 25) then
      result = "DynamicCenedril";       -- release 6.4.1.2769
    elseif (id == 26) then
      result = "SteadfastCenedril";       -- release 6.4.1.2769
    elseif (id == 27) then
      result = "MysticalCenedril";       -- release 6.4.1.2769
	elseif (id == 28) then
      result = "allitems";       -- release 6.4.1.2769
    end
    return result;
  end;
  
};

-- Supplies
local function priv_AddFoods(db)
  -- Purple
  db:priv_AddDB("Foods", 203127); -- Dexterity Pumpkin Pie
  db:priv_AddDB("Foods", 240365); -- Gebratenes Schweinekotlett
  db:priv_AddDB("Foods", 240366); -- Schweinerippchen
  db:priv_AddDB("Foods", 240368); -- Geschmortes Schweinefleisch
  db:priv_AddDB("Foods", 240369); -- Fisch mit Essig
  db:priv_AddDB("Foods", 240370); -- Pikantes Fischstaebchen
  db:priv_AddDB("Foods", 240371); -- Gelbfisch süß-sauer
  db:priv_AddDB("Foods", 240372); -- Tofu-Dorsch
  -- Blue
  db:priv_AddDB("Foods", 200359); -- Hot Stew
  db:priv_AddDB("Foods", 201532); -- Surprising Broth
  db:priv_AddDB("Foods", 201533); -- Little Magic Biscuit
  -- Green
  db:priv_AddDB("Foods", 200085); -- Roasted Salty Fish
  db:priv_AddDB("Foods", 200086); -- Garlic Roasted Meat
  db:priv_AddDB("Foods", 200091); -- Salted Fish with Sauce
  db:priv_AddDB("Foods", 200092); -- Smoked Bacon with Herbs
  db:priv_AddDB("Foods", 200097); -- Crisp Honey-roasted Chicken
  db:priv_AddDB("Foods", 200098); -- Caviar Sandwich
  db:priv_AddDB("Foods", 200103); -- Deluxe Seafood
  db:priv_AddDB("Foods", 200104); -- Spicy Meatsauce Burrito
  db:priv_AddDB("Foods", 200109); -- Delicious Swamp Mix
  db:priv_AddDB("Foods", 200110); -- Unimaginable Salad
  db:priv_AddDB("Foods", 200115); -- Moti Blended Sausage
  db:priv_AddDB("Foods", 200116); -- Imperial Seafood Pie
  db:priv_AddDB("Foods", 200121); -- Doom's Banquet
  db:priv_AddDB("Foods", 203794); -- Roasted Bacon
  db:priv_AddDB("Foods", 203795); -- Juicy Roasted Wing
  db:priv_AddDB("Foods", 203796); -- Baked Seafood Pie
  db:priv_AddDB("Foods", 203797); -- Cyclops Burrito
  db:priv_AddDB("Foods", 203798); -- Flaming Sandwich
  db:priv_AddDB("Foods", 203799); -- Delicious Seafood Salad
  db:priv_AddDB("Foods", 203800); -- Superior Swamp Mix
  db:priv_AddDB("Foods", 203801); -- Miracle Salad
  db:priv_AddDB("Foods", 203802); -- Special Canyon Mix
  db:priv_AddDB("Foods", 203803); -- Scalok Sausage
  db:priv_AddDB("Foods", 207635); -- Loaf of Magic Hard Bread
  db:priv_AddDB("Foods", 207636); -- Loaf of Handmade Black Bread
  db:priv_AddDB("Foods", 207637); -- Light Fluffy Bread
  db:priv_AddDB("Foods", 207638); -- Crispy Toast
  db:priv_AddDB("Foods", 207639); -- Garlic Bread
  db:priv_AddDB("Foods", 207640); -- Sesame Bread
  db:priv_AddDB("Foods", 207641); -- Pasty Rolls With Cinnimon
  db:priv_AddDB("Foods", 207642); -- Natural Bread
  db:priv_AddDB("Foods", 207643); -- Bread with Pygerium Aroma
  db:priv_AddDB("Foods", 207644); -- Lettuce Sandwich
  db:priv_AddDB("Foods", 207645); -- Meat Sandwich
  db:priv_AddDB("Foods", 207646); -- Fried Egg Sandwich
  db:priv_AddDB("Foods", 207647); -- Huge Sandwich
  db:priv_AddDB("Foods", 207648); -- Berry Sandwich
  db:priv_AddDB("Foods", 207649); -- Ham Sandwich
  db:priv_AddDB("Foods", 207650); -- Salted Meat Sandwich
  db:priv_AddDB("Foods", 207651); -- Smoked Chicken Sandwich
  db:priv_AddDB("Foods", 207652); -- Vegetable Sandwich
  db:priv_AddDB("Foods", 207653); -- Lightly Burnt Ribs
  db:priv_AddDB("Foods", 207654); -- Spiced Rack of Ribs
  db:priv_AddDB("Foods", 207655); -- Broiled Ribs
  db:priv_AddDB("Foods", 207656); -- Smoked Ribs
  db:priv_AddDB("Foods", 207657); -- Fried Ribs
  db:priv_AddDB("Foods", 207658); -- Juicy Spare Ribs
  db:priv_AddDB("Foods", 207659); -- Peppered Ribs
  db:priv_AddDB("Foods", 207660); -- Fried Ribs
  db:priv_AddDB("Foods", 207661); -- Honey Ribs
  -- White
  db:priv_AddDB("Foods", 200083); -- Roasted Fish
  db:priv_AddDB("Foods", 200084); -- Roasted Meat
  db:priv_AddDB("Foods", 200089); -- Salted Fish
  db:priv_AddDB("Foods", 200090); -- Smoked Bacon
  db:priv_AddDB("Foods", 200095); -- Honey Roasted Chicken
  db:priv_AddDB("Foods", 200096); -- Fish Egg Sandwich
  db:priv_AddDB("Foods", 200101); -- Creamy Seafood Pie
  db:priv_AddDB("Foods", 200102); -- Meatsauce Burrito
  db:priv_AddDB("Foods", 200107); -- Swamp Mix
  db:priv_AddDB("Foods", 200108); -- Seaworm Salad
  db:priv_AddDB("Foods", 200113); -- General's Three-color Sausage
  db:priv_AddDB("Foods", 200114); -- Cheese Fishcake
  db:priv_AddDB("Foods", 200119); -- Dragon's Banquet
  db:priv_AddDB("Foods", 202239); -- Red Bean Rice Dumplings
  db:priv_AddDB("Foods", 202240); -- Egg Rice Dumplings
  db:priv_AddDB("Foods", 202241); -- Realgar Wine
  db:priv_AddDB("Foods", 202242); -- Aged Realgar Wine
  db:priv_AddDB("Foods", 203859); -- Wine
end

local function priv_AddDesserts(db)
  -- Blue
  db:priv_AddDB("Desserts", 200776); -- Necropolis Cake
  -- Green
  db:priv_AddDB("Desserts", 200125); -- Fruits and Cheese
  db:priv_AddDB("Desserts", 200126); -- Aromatic Fruit
  db:priv_AddDB("Desserts", 200129); -- Crisp Doughnuts
  db:priv_AddDB("Desserts", 200130); -- Sweet Fruit Bread
  db:priv_AddDB("Desserts", 200133); -- Garlic Bread with Herbs
  db:priv_AddDB("Desserts", 200134); -- Excellent Meat and Bread
  db:priv_AddDB("Desserts", 200137); -- Delicious Mushroom Pie
  db:priv_AddDB("Desserts", 200138); -- Rainbow Crystal Candy
  db:priv_AddDB("Desserts", 200141); -- Magic Fruit Pie
  db:priv_AddDB("Desserts", 200142); -- Forestsong Soft Cake
  db:priv_AddDB("Desserts", 200145); -- Exquisite Tea-scented Muffins
  db:priv_AddDB("Desserts", 200146); -- Exquisite Cocoa Shortbread
  db:priv_AddDB("Desserts", 200149); -- Laor Forest Tart
  db:priv_AddDB("Desserts", 200150); -- Serenstum
  db:priv_AddDB("Desserts", 207595); -- Bitter Dark Chocolate
  db:priv_AddDB("Desserts", 207596); -- Ordinary Chocolate
  db:priv_AddDB("Desserts", 207597); -- Milk Chocolate
  db:priv_AddDB("Desserts", 207662); -- Chocolate Cake
  db:priv_AddDB("Desserts", 207663); -- Cheesecake
  db:priv_AddDB("Desserts", 207664); -- Butter Cream Cake
  db:priv_AddDB("Desserts", 207670); -- Birthday Cake
  db:priv_AddDB("Desserts", 207669); -- Fruit Tart in a Local Style
  db:priv_AddDB("Desserts", 207668); -- Vanilla Cake
  db:priv_AddDB("Desserts", 207667); -- Strawberry Cake with Cream
  db:priv_AddDB("Desserts", 207666); -- Berry Cake
  db:priv_AddDB("Desserts", 207665); -- Honey Cake
  -- White
  db:priv_AddDB("Desserts", 200123); -- Sour Cheeseball
  db:priv_AddDB("Desserts", 200124); -- Herbal Fruit
  db:priv_AddDB("Desserts", 200127); -- Sweet Deep-fried Doughnuts
  db:priv_AddDB("Desserts", 200128); -- Bread and Jam
  db:priv_AddDB("Desserts", 200131); -- Garlic Bread
  db:priv_AddDB("Desserts", 200132); -- Meat and Bread
  db:priv_AddDB("Desserts", 200135); -- Mushroom Pie
  db:priv_AddDB("Desserts", 200136); -- Crystal Sugar
  db:priv_AddDB("Desserts", 200139); -- Exotic Fruit Pie
  db:priv_AddDB("Desserts", 200140); -- Green Soft Cake
  db:priv_AddDB("Desserts", 200143); -- Tea-scented Waffle
  db:priv_AddDB("Desserts", 200144); -- Cocoa Shortbread with Herbs
  db:priv_AddDB("Desserts", 200147); -- Wizard's Rations
  db:priv_AddDB("Desserts", 200148); -- Dreamland Fruit
  db:priv_AddDB("Desserts", 203023); -- Love Chocolate
  db:priv_AddDB("Desserts", 203281); -- Chocolate
  -- db:priv_AddDB("Desserts", 203282); -- Lolllipop
  -- db:priv_AddDB("Desserts", 203469); -- Snowflake Festival Hat Biscuit
  -- db:priv_AddDB("Desserts", 203470); -- Snowflake Festival Stocking Biscuit
  -- db:priv_AddDB("Desserts", 203520); -- Snowflake Festival Candy Cane
  -- db:priv_AddDB("Desserts", 203521); -- Snowflake Festival Heart Candy
  -- db:priv_AddDB("Desserts", 203522); -- Snowflake Festival Chocolate
  -- db:priv_AddDB("Desserts", 203523); -- Snowflake Festival Soft Candy
  -- db:priv_AddDB("Desserts", 203524); -- Snowflake Festival Lollipop
  db:priv_AddDB("Desserts", 203861); -- Cheese Cake
  db:priv_AddDB("Desserts", 203863); -- Chocolate Crisp
  db:priv_AddDB("Desserts", 240524); -- Milk Candy
  db:priv_AddDB("Desserts", 240525); -- Rainbow Lollipop
end

local function priv_AddPotions(db)
  -- Purple
  db:priv_AddDB("Potions", 205975); -- Advanced Experience Potion (30 Days)
  db:priv_AddDB("Potions", 205977); -- Advanced Skill Potion (30 Days)
  db:priv_AddDB("Potions", 205974); -- Basic Experience Potion (30 Days)
  db:priv_AddDB("Potions", 203593); -- Basic Skill Potion
  db:priv_AddDB("Potions", 205976); -- Basic Skill Potion (30 Days)
  db:priv_AddDB("Potions", 201139); -- Big Angel's Sigh
  db:priv_AddDB("Potions", 201134); -- Experience Potion
  db:priv_AddDB("Potions", 202264); -- Experience Potion (1 Day)
  db:priv_AddDB("Potions", 205962); -- Experience Potion (30 Days)
  db:priv_AddDB("Potions", 202319); -- Experience Potion (7 Days)
  db:priv_AddDB("Potions", 201617); -- Expert Skill Potion
  db:priv_AddDB("Potions", 203574); -- High Quality Experience Potion
  db:priv_AddDB("Potions", 201608); -- Lasting Experience Potion
  db:priv_AddDB("Potions", 203592); -- Lesser Speed Mount Potion (30 Days)
  db:priv_AddDB("Potions", 203591); -- Lesser Speed Mount Potion (7 Days)
  db:priv_AddDB("Potions", 205978); -- Luck Potion (30 Days)
  db:priv_AddDB("Potions", 201618); -- Master Skill Potion
  db:priv_AddDB("Potions", 201460); -- Party Experience Potion
  db:priv_AddDB("Potions", 201141); -- Phoenix' Redemption
  db:priv_AddDB("Potions", 202322); -- Potent Luck Potion
  db:priv_AddDB("Potions", 201619); -- Potion of Luck
  db:priv_AddDB("Potions", 201609); -- Powerful Experience Potion
  db:priv_AddDB("Potions", 202670); -- Riding Medicine (30 Days)
  db:priv_AddDB("Potions", 202669); -- Riding Medicine (7 Days)
  db:priv_AddDB("Potions", 201610); -- Skill Potion
  db:priv_AddDB("Potions", 202320); -- Skill Potion (1 Day)
  db:priv_AddDB("Potions", 205963); -- Skill Potion (30 Days)
  db:priv_AddDB("Potions", 202321); -- Skill Potion (7 Days)
  db:priv_AddDB("Potions", 202540); -- St. Phoenix
  db:priv_AddDB("Potions", 203415); -- Transformation Potion - Giant Guardian
  db:priv_AddDB("Potions", 203416); -- Transformation Potion - Gingerbread Man
  db:priv_AddDB("Potions", 203417); -- Transformation Potion - Santa Claus
  db:priv_AddDB("Potions", 204533); -- Universal Potion
  -- Blue
  db:priv_AddDB("Potions", 200286); -- Shock Potion
  db:priv_AddDB("Potions", 202153); -- Universal Potion
  -- Green
  db:priv_AddDB("Potions", 200192); -- Ancient Spirit Water
  db:priv_AddDB("Potions", 200154); -- Basic Healing Potion
  db:priv_AddDB("Potions", 200155); -- Basic Mana Potion
  db:priv_AddDB("Potions", 200425); -- Elixir of the Sage
  db:priv_AddDB("Potions", 200225); -- Embrace of the Muse
  db:priv_AddDB("Potions", 203805); -- Fiery Medicine
  db:priv_AddDB("Potions", 200178); -- Healing Potion
  db:priv_AddDB("Potions", 200277); -- Hero Potion
  db:priv_AddDB("Potions", 200172); -- Invisibility Potion
  db:priv_AddDB("Potions", 200179); -- Mana Potion
  db:priv_AddDB("Potions", 203509); -- Potion of Exquisite Skill
  db:priv_AddDB("Potions", 203511); -- Potion of Focused Will
  db:priv_AddDB("Potions", 203806); -- Powder of Peace
  db:priv_AddDB("Potions", 200276); -- Purified Stimulating Scent
  db:priv_AddDB("Potions", 203807); -- Spellweaver Potion
  db:priv_AddDB("Potions", 203507); -- Strength of Battle
  db:priv_AddDB("Potions", 200274); -- Strong Healing Potion
  db:priv_AddDB("Potions", 200275); -- Strong Mana Potion
  db:priv_AddDB("Potions", 200173); -- Strong Stimulant
  db:priv_AddDB("Potions", 200199); -- Touch of the Unicorn
  db:priv_AddDB("Potions", 200427); -- Tranquility Powder
  db:priv_AddDB("Potions", 203808); -- Transparence Potion
  db:priv_AddDB("Potions", 203809); -- Unicorn's Present
  db:priv_AddDB("Potions", 240535); -- Extinguish Potion
  db:priv_AddDB("Potions", 240534); -- Extinction Potion
  db:priv_AddDB("Potions", 240533); -- Strong Magic Potion
  db:priv_AddDB("Potions", 240532); -- Deadly Potion
  db:priv_AddDB("Potions", 207671); -- Defense Potion
  db:priv_AddDB("Potions", 207672); -- Steel Potion
  db:priv_AddDB("Potions", 207673); -- Cleansing Potion
  db:priv_AddDB("Potions", 207674); -- Divine Healing Potion
  db:priv_AddDB("Potions", 207675); -- Madness Potion
  db:priv_AddDB("Potions", 207676); -- Super Salve
  db:priv_AddDB("Potions", 207677); -- Super Healing Potion
  db:priv_AddDB("Potions", 207678); -- Super Spirit Potion
  db:priv_AddDB("Potions", 207679); -- Super Mana Potion
  db:priv_AddDB("Potions", 207681); -- Strong Magic Potion
  db:priv_AddDB("Potions", 207682); -- Chainlink Strike
  -- White
  db:priv_AddDB("Potions", 200820); -- Ancestral Spirit Herbs
  db:priv_AddDB("Potions", 200811); -- Barbarian Herbs
  db:priv_AddDB("Potions", 200664); -- Basic First Aid Potion
  db:priv_AddDB("Potions", 201043); -- Basic Magic Potion
  db:priv_AddDB("Potions", 200151); -- Basic Medicine
  db:priv_AddDB("Potions", 200152); -- Basic Spirit Potion
  db:priv_AddDB("Potions", 202906); -- Bean Paste Mooncake
  db:priv_AddDB("Potions", 203867); -- Blue Magic Potion
  db:priv_AddDB("Potions", 202907); -- Coconut Mooncake
  db:priv_AddDB("Potions", 200418); -- Collection Potion I
  db:priv_AddDB("Potions", 200420); -- Collection Potion II
  db:priv_AddDB("Potions", 200422); -- Collection Potion III
  db:priv_AddDB("Potions", 201053); -- Condensed Magic Potion
  db:priv_AddDB("Potions", 201056); -- Crystal Mana Medicine
  db:priv_AddDB("Potions", 205867); -- Dexterity Potion
  db:priv_AddDB("Potions", 201052); -- Elemental Mana Stone
  db:priv_AddDB("Potions", 201061); -- Elemental Spirit Stone
  db:priv_AddDB("Potions", 204890); -- Elemental Spirit Stone
  db:priv_AddDB("Potions", 200807); -- First Aid Potion
  db:priv_AddDB("Potions", 203510); -- Focus Potion
  db:priv_AddDB("Potions", 200812); -- Healer's First Aid Potion
  db:priv_AddDB("Potions", 205869); -- Health Potion
  db:priv_AddDB("Potions", 205863); -- Intelligence Potion
  db:priv_AddDB("Potions", 200194); -- Life Source
  db:priv_AddDB("Potions", 201046); -- Magic Potion
  db:priv_AddDB("Potions", 204130); -- Magical Wine
  db:priv_AddDB("Potions", 200808); -- Major First Aid Potion
  db:priv_AddDB("Potions", 201047); -- Major Magic Potion
  db:priv_AddDB("Potions", 200175); -- Mana Potion
  db:priv_AddDB("Potions", 200195); -- Mana Source
  db:priv_AddDB("Potions", 200819); -- Military Regeneration Formula
  db:priv_AddDB("Potions", 200018); -- Mysterious Potion
  db:priv_AddDB("Potions", 200426); -- Pacification Powder
  -- db:priv_AddDB("Potions", 203499); -- Phirius Elixir - Type A
  -- db:priv_AddDB("Potions", 203500); -- Phirius Elixir - Type B
  -- db:priv_AddDB("Potions", 203501); -- Phirius Elixir - Type C
  -- db:priv_AddDB("Potions", 203502); -- Phirius Elixir - Type D
  -- db:priv_AddDB("Potions", 203503); -- Phirius Elixir - Type E
  -- db:priv_AddDB("Potions", 203494); -- Phirius Potion - Type A
  -- db:priv_AddDB("Potions", 203495); -- Phirius Potion - Type B
  -- db:priv_AddDB("Potions", 203496); -- Phirius Potion - Type C
  -- db:priv_AddDB("Potions", 203497); -- Phirius Potion - Type D
  -- db:priv_AddDB("Potions", 203498); -- Phirius Potion - Type E
  -- db:priv_AddDB("Potions", 203489); -- Phirius Special Water - Type A
  -- db:priv_AddDB("Potions", 203490); -- Phirius Special Water - Type B
  -- db:priv_AddDB("Potions", 203491); -- Phirius Special Water - Type C
  -- db:priv_AddDB("Potions", 203492); -- Phirius Special Water - Type D
  -- db:priv_AddDB("Potions", 203493); -- Phirius Special Water - Type E
  db:priv_AddDB("Potions", 201057); -- Potent Crystal Mana Medicine
  db:priv_AddDB("Potions", 205868); -- Potent Dexterity Potion
  db:priv_AddDB("Potions", 205870); -- Potent Health Potion
  db:priv_AddDB("Potions", 205864); -- Potent Intelligence Potion
  db:priv_AddDB("Potions", 200816); -- Potent Regeneration Formula
  db:priv_AddDB("Potions", 205862); -- Potent Strength Potion
  db:priv_AddDB("Potions", 205866); -- Potent Wisdom Potion
  db:priv_AddDB("Potions", 203508); -- Potion of Energy
  db:priv_AddDB("Potions", 200273); -- Potion of Fire Elemental Affinity
  db:priv_AddDB("Potions", 200272); -- Potion of Holy Power
  db:priv_AddDB("Potions", 200424); -- Potion of Potential
  db:priv_AddDB("Potions", 203506); -- Potion of Rage
  db:priv_AddDB("Potions", 200159); -- Potion of Speed
  db:priv_AddDB("Potions", 200270); -- Powerful Spirit Potion
  db:priv_AddDB("Potions", 203159); -- Pumpkin Pizza
  db:priv_AddDB("Potions", 203160); -- Pumpkin Soup of Happiness
  db:priv_AddDB("Potions", 201060); -- Refined Crystal Mana Medicine
  db:priv_AddDB("Potions", 200815); -- Regeneration Mixture
  db:priv_AddDB("Potions", 200174); -- Salve
  db:priv_AddDB("Potions", 200663); -- Simple First Aid Potion
  db:priv_AddDB("Potions", 201042); -- Simple Magic Potion
  db:priv_AddDB("Potions", 204889); -- Spirit Herb
  db:priv_AddDB("Potions", 200160); -- Stimulant
  db:priv_AddDB("Potions", 200271); -- Stimulant Scent
  db:priv_AddDB("Potions", 205861); -- Strength Potion
  db:priv_AddDB("Potions", 200229); -- Strong Medicine
  db:priv_AddDB("Potions", 200196); -- Superior Collection Potion I
  db:priv_AddDB("Potions", 200197); -- Superior Collection Potion II
  db:priv_AddDB("Potions", 200198); -- Superior Collection Potion III
  db:priv_AddDB("Potions", 202886); -- Training First-aid Potion
  db:priv_AddDB("Potions", 202887); -- Training Magic Potion
  db:priv_AddDB("Potions", 205865); -- Wisdom Potion
  db:priv_AddDB("Potions", 200176); -- Witch Doctor Elixir
  db:priv_AddDB("Potions", 208655); -- Basic Production Speed Potion (1 Day)
  db:priv_AddDB("Potions", 208485); -- Rare Sage Stone
  db:priv_AddDB("Potions", 208486); -- Mysterious Sage Stone
end

-- Materials
local function priv_AddOres(db)
  -- Purple
  db:priv_AddDB("Ores", 201744); -- Abyss-Mercury Ingot
  db:priv_AddDB("Ores", 201739); -- Copper Ingot
  db:priv_AddDB("Ores", 202576); -- Cyanide Ingot
  db:priv_AddDB("Ores", 201740); -- Dark Crystal Ingot
  db:priv_AddDB("Ores", 202575); -- Flame Dust Ingot
  db:priv_AddDB("Ores", 202580); -- Frost Crystal Ingot
  db:priv_AddDB("Ores", 201738); -- Iron Ingot
  db:priv_AddDB("Ores", 202579); -- Mithril Ingot
  db:priv_AddDB("Ores", 201743); -- Moon Silver Ingot
  db:priv_AddDB("Ores", 202578); -- Mysticite Ingot
  db:priv_AddDB("Ores", 202577); -- Rock Crystal Ingot
  db:priv_AddDB("Ores", 201741); -- Silver Ingot
  db:priv_AddDB("Ores", 201737); -- Tin Ingot
  db:priv_AddDB("Ores", 201742); -- Wizard-Iron Ingot
  db:priv_AddDB("Ores", 201736); -- Zinc Ingot
  db:priv_AddDB("Ores", 201745); -- Rune Obsidian Ingot - 56
  db:priv_AddDB("Ores", 208237); -- Olivine Ingot - 61
  db:priv_AddDB("Ores", 202581); -- Mica Ingot - 61
  db:priv_AddDB("Ores", 240317); -- Purple Agate Crystal Ingot - 66
  db:priv_AddDB("Ores", 241435); -- Olegansteinbarren - 69
  db:priv_AddDB("Ores", 241441); -- Rein Crystal Ingot - 69
  db:priv_AddDB("Ores", 242249); -- Silver Star Stone Ingot - 81-- credit Ultak
  db:priv_AddDB("Ores", 242297); -- Ironaxe Stone Ingot - 81-- credit Ultak
  db:priv_AddDB("Ores", 242261); -- Mutation Dust Ingot - 86-- credit Ultak
  db:priv_AddDB("Ores", 242273); -- Rainbow Stone Ingot - 91-- credit Ultak
  db:priv_AddDB("Ores", 242307); -- Sea Crystal Ingot - 91-- credit Ultak
  -- Blue
  db:priv_AddDB("Ores", 201731); -- Abyss-Mercury Nugget
  db:priv_AddDB("Ores", 201726); -- Copper Nugget
  db:priv_AddDB("Ores", 202569); -- Cyanide Nugget
  db:priv_AddDB("Ores", 201727); -- Dark Crystal Nugget
  db:priv_AddDB("Ores", 202568); -- Flame Dust Nugget
  db:priv_AddDB("Ores", 202573); -- Frost Crystal Nugget
  db:priv_AddDB("Ores", 201725); -- Iron Nugget
  db:priv_AddDB("Ores", 202572); -- Mithril Nugget
  db:priv_AddDB("Ores", 201730); -- Moon Silver Nugget
  db:priv_AddDB("Ores", 202571); -- Mysticite Nugget
  db:priv_AddDB("Ores", 202570); -- Rock Crystal Nugget
  db:priv_AddDB("Ores", 201728); -- Silver Nugget
  db:priv_AddDB("Ores", 201724); -- Tin Nugget
  db:priv_AddDB("Ores", 201729); -- Wizard-Iron Nugget
  db:priv_AddDB("Ores", 201723); -- Zinc Nugget
  db:priv_AddDB("Ores", 201732); -- Rune Obsidian Nugget - 56
  db:priv_AddDB("Ores", 202574); -- Mica Nugget - 61
  db:priv_AddDB("Ores", 208236); -- Olivine Stone - 61
  db:priv_AddDB("Ores", 240316); -- Purpurroter Achatkristallklumpen - 66-- credit Ultak
  db:priv_AddDB("Ores", 241434); -- Olegan Stone Nugget - 69-- credit Ultak
  db:priv_AddDB("Ores", 241440); -- Rein Crystal Nugget - 69-- credit Ultak
  db:priv_AddDB("Ores", 242248); -- Silver Star Stone Nugget - 81-- credit Ultak
  db:priv_AddDB("Ores", 242296); -- Ironaxe Stone Nugget - 81-- credit Ultak
  db:priv_AddDB("Ores", 242260); -- Mutation Dust Nugget - 86-- credit Ultak
  db:priv_AddDB("Ores", 242272); -- Rainbow Stone Nugget - 91-- credit Ultak
  db:priv_AddDB("Ores", 242306); -- Sea Crystal Nugget - 91-- credit Ultak
  -- Green
  db:priv_AddDB("Ores", 201720); -- Abyss-Mercury Sand
  db:priv_AddDB("Ores", 201714); -- Copper Sand
  db:priv_AddDB("Ores", 202562); -- Cyanide Sand
  db:priv_AddDB("Ores", 201715); -- Dark Crystal Sand
  db:priv_AddDB("Ores", 202561); -- Flame Dust Sand
  db:priv_AddDB("Ores", 202566); -- Frost Crystal Sand
  db:priv_AddDB("Ores", 201713); -- Iron Sand
  db:priv_AddDB("Ores", 202565); -- Mithrial Sand
  db:priv_AddDB("Ores", 201718); -- Moon Silver Sand
  db:priv_AddDB("Ores", 202564); -- Mysticite Sand
  db:priv_AddDB("Ores", 202563); -- Rock Crystal Sand
  db:priv_AddDB("Ores", 201716); -- Silver Sand
  db:priv_AddDB("Ores", 201711); -- Tin Sand
  db:priv_AddDB("Ores", 201717); -- Wizard-Iron Sand
  db:priv_AddDB("Ores", 201710); -- Zinc Sand
  db:priv_AddDB("Ores", 201721); -- Rune Obsidian Sand - 56
  db:priv_AddDB("Ores", 202567); -- Mica Sand - 61
  db:priv_AddDB("Ores", 208235); -- Olivine Sand - 61
  db:priv_AddDB("Ores", 240315); -- Purpurroter Achatkristallsand - 66
  db:priv_AddDB("Ores", 241433); -- Olegan Stone Sand - 69
  db:priv_AddDB("Ores", 241439); -- Rein Crystal Sand - 69
  db:priv_AddDB("Ores", 242247); -- Silver Star Stone Sand - 81-- credit Ultak
  db:priv_AddDB("Ores", 242295); -- Ironaxe Stone Sand - 81-- credit Ultak
  db:priv_AddDB("Ores", 242259); -- Mutation Dust Sand - 86-- credit Ultak
  db:priv_AddDB("Ores", 242271); -- Rainbow Stone Sand - 91-- credit Ultak
  db:priv_AddDB("Ores", 242305); -- Sea Crystal Sand - 91-- credit Ultak
  -- White
  db:priv_AddDB("Ores", 200264); -- Abyss-Mercury
  db:priv_AddDB("Ores", 200236); -- Copper Ore
  db:priv_AddDB("Ores", 200506); -- Cyanide
  db:priv_AddDB("Ores", 200238); -- Dark Crystal
  db:priv_AddDB("Ores", 200507); -- Flame Dust
  db:priv_AddDB("Ores", 202315); -- Frost Crystal
  db:priv_AddDB("Ores", 200234); -- Iron Ore
  db:priv_AddDB("Ores", 200265); -- Mithril
  db:priv_AddDB("Ores", 200244); -- Moon Silver Ore
  db:priv_AddDB("Ores", 200269); -- Mysticite
  db:priv_AddDB("Ores", 200249); -- Rock Crystal
  db:priv_AddDB("Ores", 200239); -- Silver Ore
  db:priv_AddDB("Ores", 200232); -- Tin Ore
  db:priv_AddDB("Ores", 200242); -- Wizard-Iron Ore
  db:priv_AddDB("Ores", 200230); -- Zinc Ore
  db:priv_AddDB("Ores", 200268); -- Rune Obsidian Ore - 56
  db:priv_AddDB("Ores", 202316); -- Mica - 61
  db:priv_AddDB("Ores", 208234); -- Olivine - 61
  db:priv_AddDB("Ores", 240314); -- Purpurroter Achatkristall - 66
  db:priv_AddDB("Ores", 241432); -- Olegan Stone - 69
  db:priv_AddDB("Ores", 241438); -- Rein Crystal - 69
  db:priv_AddDB("Ores", 242246); -- Silver Star Stone - 81-- credit Ultak
  db:priv_AddDB("Ores", 242294); -- Ironaxe Stone - 81-- credit Ultak
  db:priv_AddDB("Ores", 242258); -- Mutation Dust - 86-- credit Ultak
  db:priv_AddDB("Ores", 242270); -- Rainbow Stone - 91-- credit Ultak
  db:priv_AddDB("Ores", 242306); -- Sea Crystal - 91-- credit Ultak
  
end

local function priv_AddWood(db)
  -- Purple
  db:priv_AddDB("Wood", 201773); -- Ash Plank
  db:priv_AddDB("Wood", 202610); -- Chime Wood Plank
  db:priv_AddDB("Wood", 202613); -- Dragon Beard Root Plank
  db:priv_AddDB("Wood", 201781); -- Dragonlair Wood Plank
  db:priv_AddDB("Wood", 202615); -- Fairywood Plank
  db:priv_AddDB("Wood", 201778); -- Holly Plank
  db:priv_AddDB("Wood", 201775); -- Maple Plank
  db:priv_AddDB("Wood", 201776); -- Oak Plank
  db:priv_AddDB("Wood", 201777); -- Pine Plank
  db:priv_AddDB("Wood", 202612); -- Redwood Plank
  db:priv_AddDB("Wood", 202614); -- Sagewood Plank
  db:priv_AddDB("Wood", 202611); -- Stone Rotan Plank
  db:priv_AddDB("Wood", 201780); -- Tarslin Demon Wood Plank
  db:priv_AddDB("Wood", 201774); -- Willow Plank
  db:priv_AddDB("Wood", 201779); -- Yew Plank
  db:priv_AddDB("Wood", 201782); -- Ancient Spirit Oak Plank
  db:priv_AddDB("Wood", 202616); -- Aeontree Plank - 61
  db:priv_AddDB("Wood", 208243); -- Fastan Banyan Plank - 63
  db:priv_AddDB("Wood", 240326); -- Janost-Zypressenbrett - 66-- credit Ultak
  db:priv_AddDB("Wood", 241423); -- Todo Ginkgo Plank?
  db:priv_AddDB("Wood", 241429); -- Pinienholzbrett - 69-- credit Ultak
  db:priv_AddDB("Wood", 242245); -- Nadal Wisteria Plank - 81-- credit Ultak
  db:priv_AddDB("Wood", 242293); -- Blood Palm Plank - 81-- credit Ultak
  db:priv_AddDB("Wood", 242257); -- Summer Oak Plank - 86-- credit Ultak
  db:priv_AddDB("Wood", 242269); -- Fire Mountain Tree Plank - 91-- credit Ultak
  db:priv_AddDB("Wood", 242305); -- Bleak Fir Plank - 91-- credit Ultak
  -- Blue
  db:priv_AddDB("Wood", 201761); -- Ash Lumber
  db:priv_AddDB("Wood", 202603); -- Chime Wood Lumber
  db:priv_AddDB("Wood", 202606); -- Dragon Beard Root Lumber
  db:priv_AddDB("Wood", 201769); -- Dragonlair Wood Lumber
  db:priv_AddDB("Wood", 202608); -- Fairywood Lumber
  db:priv_AddDB("Wood", 201766); -- Holly Lumber
  db:priv_AddDB("Wood", 201763); -- Maple Lumber
  db:priv_AddDB("Wood", 201764); -- Oak Lumber
  db:priv_AddDB("Wood", 201765); -- Pine Lumber
  db:priv_AddDB("Wood", 202605); -- Redwood Lumber
  db:priv_AddDB("Wood", 202607); -- Sagewood Lumber
  db:priv_AddDB("Wood", 202604); -- Stone Rotan Lumber
  db:priv_AddDB("Wood", 201768); -- Tarslin Demon Wood Lumber
  db:priv_AddDB("Wood", 201762); -- Willow Lumber
  db:priv_AddDB("Wood", 201767); -- Yew Lumber
  db:priv_AddDB("Wood", 201770); -- Ancient Spirit Oak Lumber
  db:priv_AddDB("Wood", 202609); -- Aeontree Lumber - 61
  db:priv_AddDB("Wood", 208242); -- Fastan Banyan Lumber - 63
  db:priv_AddDB("Wood", 240325); -- Janost-Cypress Lumber - 66
  db:priv_AddDB("Wood", 241422); -- Todo Ginkgo Lumber
  db:priv_AddDB("Wood", 241428); -- Stone Pine Lumber - 71-- credit Ultak
  db:priv_AddDB("Wood", 242244); -- Nadal Wisteria Lumber - 81-- credit Ultak
  db:priv_AddDB("Wood", 242292); -- Blood Palm Lumber - 81-- credit Ultak
  db:priv_AddDB("Wood", 242256); -- Summer Oak Lumber - 86-- credit Ultak
  db:priv_AddDB("Wood", 242268); -- Fire Mountain Tree Lumber - 91-- credit Ultak
  db:priv_AddDB("Wood", 242304); -- Bleak Fir Lumber - 91-- credit Ultak
  -- Green
  db:priv_AddDB("Wood", 201749); -- Ash Timber - 1
  db:priv_AddDB("Wood", 202596); -- Chime Wood Timber - 1
  db:priv_AddDB("Wood", 201750); -- Willow Timber - 8
  db:priv_AddDB("Wood", 202597); -- Stone Rotan Timber - 11
  db:priv_AddDB("Wood", 201751); -- Maple Timber - 14
  db:priv_AddDB("Wood", 201752); -- Oak Timber - 20
  db:priv_AddDB("Wood", 202598); -- Redwood Timber - 21
  db:priv_AddDB("Wood", 201754); -- Pine Timber - 26
  db:priv_AddDB("Wood", 202599); -- Dragon Beard Root Timber - 31
  db:priv_AddDB("Wood", 201753); -- Holly Timber - 32
  db:priv_AddDB("Wood", 201757); -- Yew Timber - 38
  db:priv_AddDB("Wood", 202600); -- Sagewood Timber - 41
  db:priv_AddDB("Wood", 201758); -- Tarslin Demon Wood Timber - 44
  db:priv_AddDB("Wood", 201759); -- Dragonlair Wood Timber - 51
  db:priv_AddDB("Wood", 202601); -- Fairywood Timber - 51
  db:priv_AddDB("Wood", 201760); -- Ancient Spirit Oak Timber - 56
  db:priv_AddDB("Wood", 202602); -- Aeontree Timber - 61
  db:priv_AddDB("Wood", 208241); -- Fastan Banyan Timber - 63
  db:priv_AddDB("Wood", 240324); -- Janost-Cypress Timber - 66
  db:priv_AddDB("Wood", 241427); -- Stone Pine Timber - 71-- credit Ultak
  db:priv_AddDB("Wood", 241421); -- Todo Ginkgo Timber
  db:priv_AddDB("Wood", 242243); -- Nadal Wisteria Timber - 81-- credit Ultak
  db:priv_AddDB("Wood", 242291); -- Blood Palm Timber - 81-- credit Ultak
  db:priv_AddDB("Wood", 242255); -- Summer Oak Timber - 86-- credit Ultak
  db:priv_AddDB("Wood", 242267); -- Fire Mountain Tree Timber - 91-- credit Ultak
  db:priv_AddDB("Wood", 242303); -- Bleak Fir Timber - 91-- credit Ultak
  -- White
  db:priv_AddDB("Wood", 200293); -- Ash Wood - 1
  db:priv_AddDB("Wood", 200508); -- Chime Wood - 1
  db:priv_AddDB("Wood", 200295); -- Willow Wood - 8
  db:priv_AddDB("Wood", 200509); -- Stone Rotan Wood - 11
  db:priv_AddDB("Wood", 200297); -- Maple Wood - 14
  db:priv_AddDB("Wood", 200300); -- Oak Wood - 20
  db:priv_AddDB("Wood", 200326); -- Redwood - 21
  db:priv_AddDB("Wood", 200304); -- Pine Wood - 26
  db:priv_AddDB("Wood", 200332); -- Dragon Beard Root Wood - 31
  db:priv_AddDB("Wood", 200298); -- Holly Wood - 32
  db:priv_AddDB("Wood", 200306); -- Yew Wood - 38
  db:priv_AddDB("Wood", 200331); -- Sagewood - 41
  db:priv_AddDB("Wood", 200307); -- Tarslin Demon Wood - 44
  db:priv_AddDB("Wood", 202317); -- Fairywood - 51
  db:priv_AddDB("Wood", 200310); -- Dragonlair Wood - 51
  db:priv_AddDB("Wood", 200312); -- Ancient Spirit Oak Wood - 56
  db:priv_AddDB("Wood", 202318); -- Aeontree Wood - 61
  db:priv_AddDB("Wood", 208240); -- Fastan Banyan - 63
  db:priv_AddDB("Wood", 240323); -- Janost-Cypress Wood - 66
  db:priv_AddDB("Wood", 241420); -- Todo Ginkgo Tree - 66?
  db:priv_AddDB("Wood", 241426); -- Stone Pine Wood - 71-- credit Ultak
  db:priv_AddDB("Wood", 242242); -- Nadal Wisteria Wood - 81-- credit Ultak
  db:priv_AddDB("Wood", 242290); -- Blood Palm Wood - 81-- credit Ultak
  db:priv_AddDB("Wood", 242254); -- Summer Oak Wood - 86-- credit Ultak
  db:priv_AddDB("Wood", 242266); -- Fire Mountain Tree Wood - 91-- credit Ultak
  db:priv_AddDB("Wood", 242302); -- Bleak Fir Wood - 91-- credit Ultak
end

local function priv_AddHerbs(db)
  -- Purple
  db:priv_AddDB("Herbs", 201818); -- Barsleaf Extract
  db:priv_AddDB("Herbs", 201814); -- Beetroot Extract
  db:priv_AddDB("Herbs", 202646); -- Bison Grass Extract
  db:priv_AddDB("Herbs", 201815); -- Bitterleaf Extract
  db:priv_AddDB("Herbs", 201821); -- Dragon Mallow Extract
  db:priv_AddDB("Herbs", 201817); -- Dusk Orchid Extract
  db:priv_AddDB("Herbs", 202647); -- Foloin Nut Extract
  db:priv_AddDB("Herbs", 202648); -- Green Thistle Extract
  db:priv_AddDB("Herbs", 201819); -- Moon Orchid Extract
  db:priv_AddDB("Herbs", 201813); -- Mountain Demon Grass Extract
  db:priv_AddDB("Herbs", 201816); -- Moxa Extract
  db:priv_AddDB("Herbs", 202645); -- Rosemary Extract
  db:priv_AddDB("Herbs", 202649); -- Straw Mushroom Extract - 41
  db:priv_AddDB("Herbs", 201820); -- Sinners Palm Extract - 44
  db:priv_AddDB("Herbs", 202650); -- Mirror Sedge Extract - 51
  db:priv_AddDB("Herbs", 201822); -- Thorn Apple Extract - 56
  db:priv_AddDB("Herbs", 202651); -- Goblin Grass Extract - 61
  db:priv_AddDB("Herbs", 208249); -- Verbena Extract - 63
  db:priv_AddDB("Herbs", 240332); -- Nocturnal Lantern Grass Extract - 66
  db:priv_AddDB("Herbs", 241417); -- Dovetail Flower Extract - 71
  db:priv_AddDB("Herbs", 241411); -- Tuhnderhoof Grass Extract - 75-- credit Ultak
  db:priv_AddDB("Herbs", 242253); -- Isyeh Grass Extract - 81-- credit Ultak
  db:priv_AddDB("Herbs", 242301); -- Dragonsprout Grass Extract - 81-- credit Ultak
  db:priv_AddDB("Herbs", 242265); -- Cold Psilotum Extract - 86-- credit Ultak
  db:priv_AddDB("Herbs", 242277); -- Snow Grass Extract - 91-- credit Ultak
  db:priv_AddDB("Herbs", 242313); -- Moon Grass Extract - 91-- credit Ultak
  -- Blue
  db:priv_AddDB("Herbs", 201804); -- Barsleaf Sap
  db:priv_AddDB("Herbs", 201800); -- Beetroot Sap
  db:priv_AddDB("Herbs", 202639); -- Bison Grass Sap
  db:priv_AddDB("Herbs", 201801); -- Bitterleaf Sap
  db:priv_AddDB("Herbs", 201807); -- Dragon Mallow Sap
  db:priv_AddDB("Herbs", 201803); -- Dusk Orchid Sap
  db:priv_AddDB("Herbs", 202640); -- Foloin Nut Sap
  db:priv_AddDB("Herbs", 202641); -- Green Thistle Sap
  db:priv_AddDB("Herbs", 201805); -- Moon Orchid Sap
  db:priv_AddDB("Herbs", 201799); -- Mountain Demon Grass Sap
  db:priv_AddDB("Herbs", 201802); -- Moxa Sap
  db:priv_AddDB("Herbs", 202638); -- Rosemary Sap
  db:priv_AddDB("Herbs", 202642); -- Straw Mushroom Sap - 41
  db:priv_AddDB("Herbs", 201806); -- Sinners Palm Sap - 44
  db:priv_AddDB("Herbs", 202643); -- Mirror Sedge Sap - 51
  db:priv_AddDB("Herbs", 201808); -- Thorn Apple Juice - 56
  db:priv_AddDB("Herbs", 202644); -- Goblin Grass Sap - 61
  db:priv_AddDB("Herbs", 208248); -- Verbena Juice - 63
  db:priv_AddDB("Herbs", 240331); -- Nocturnal Lantern Grass Sap - 66
  db:priv_AddDB("Herbs", 241416); -- Dovetail Flower Sap - 71
  db:priv_AddDB("Herbs", 241410); -- Thunderhoof Sap - 75-- credit Ultak
  db:priv_AddDB("Herbs", 242252); -- Isyeh Grass Sap - 81-- credit Ultak
  db:priv_AddDB("Herbs", 242300); -- Dragonsprout Grass Sap - 81-- credit Ultak
  db:priv_AddDB("Herbs", 242264); -- Cold Psilotum Sap - 86-- credit Ultak
  db:priv_AddDB("Herbs", 242276); -- Snow Grass Sap - 91-- credit Ultak
  db:priv_AddDB("Herbs", 242312); -- Moon Grass Sap - 91-- credit Ultak
  -- Green
  db:priv_AddDB("Herbs", 201792); -- Barsleaf Bundle
  db:priv_AddDB("Herbs", 201786); -- Beetroot Bundle
  db:priv_AddDB("Herbs", 202632); -- Bison Grass Bundle
  db:priv_AddDB("Herbs", 201789); -- Bitterleaf Bundle
  db:priv_AddDB("Herbs", 201797); -- Dragon Mallow Bundle
  db:priv_AddDB("Herbs", 201791); -- Dusk Orchid Bundle
  db:priv_AddDB("Herbs", 202633); -- Foloin Nut Bundle
  db:priv_AddDB("Herbs", 202634); -- Green Thistle Bundle
  db:priv_AddDB("Herbs", 201794); -- Moon Orchid Bundle
  db:priv_AddDB("Herbs", 201785); -- Mountain Demon Grass Bundle
  db:priv_AddDB("Herbs", 201788); -- Moxa Bundle
  db:priv_AddDB("Herbs", 202631); -- Rosemary Bundle
  db:priv_AddDB("Herbs", 202635); -- Straw Mushroom Bundle - 41
  db:priv_AddDB("Herbs", 201796); -- Sinners Palm Bundle - 44
  db:priv_AddDB("Herbs", 202636); -- Mirror Sedge Bundle - 51
  db:priv_AddDB("Herbs", 201798); -- Thorn Apple Bundle - 56
  db:priv_AddDB("Herbs", 202637); -- Goblin Grass Bundle - 61
  db:priv_AddDB("Herbs", 208247); -- Bouquet of Verbena - 63
  db:priv_AddDB("Herbs", 240330); -- Nocturnal Lantern Grass Bundle - 66
  db:priv_AddDB("Herbs", 241415); -- Dovetail Flower Bundle - 71
  db:priv_AddDB("Herbs", 241409); -- Thunderhoof Grass Bundle - 75-- credit Ultak
  db:priv_AddDB("Herbs", 242251); -- Isyeh Grass Bundle - 81-- credit Ultak
  db:priv_AddDB("Herbs", 242299); -- Dragonsprout Grass Bundle - 81-- credit Ultak
  db:priv_AddDB("Herbs", 242263); -- Cold Psilotum Bundle - 86-- credit Ultak
  db:priv_AddDB("Herbs", 242275); -- Snow Grass Bundle - 91-- credit Ultak
  db:priv_AddDB("Herbs", 242311); -- Moon Grass Bundle - 91-- credit Ultak
  -- White
  db:priv_AddDB("Herbs", 200342); -- Barsleaf
  db:priv_AddDB("Herbs", 200334); -- Beetroot
  db:priv_AddDB("Herbs", 202553); -- Bison Grass
  db:priv_AddDB("Herbs", 200333); -- Bitterleaf
  db:priv_AddDB("Herbs", 200349); -- Dragon Mallow
  db:priv_AddDB("Herbs", 200343); -- Dusk Orchid
  db:priv_AddDB("Herbs", 202554); -- Foloin Nut
  db:priv_AddDB("Herbs", 202555); -- Green Thistle
  db:priv_AddDB("Herbs", 200345); -- Moon Orchid
  db:priv_AddDB("Herbs", 200335); -- Mountain Demon Grass
  db:priv_AddDB("Herbs", 200338); -- Moxa
  db:priv_AddDB("Herbs", 202552); -- Rosemary
  db:priv_AddDB("Herbs", 202556); -- Straw Mushroom - 41
  db:priv_AddDB("Herbs", 200346); -- Sinners Palm - 44
  db:priv_AddDB("Herbs", 202557); -- Mirror Sedge - 51
  db:priv_AddDB("Herbs", 200350); -- Thorn Apple - 56
  db:priv_AddDB("Herbs", 202558); -- Goblin Grass - 61
  db:priv_AddDB("Herbs", 208246); -- Verbena - 63
  db:priv_AddDB("Herbs", 240329); -- Nocturnal Lantern Grass - 66
  db:priv_AddDB("Herbs", 241414); -- Dovetail Flower - 71-- credit Ultak
  db:priv_AddDB("Herbs", 241408); -- Thunderhoof Grass - 75-- credit Ultak
  db:priv_AddDB("Herbs", 242250); -- Isyeh Grass - 81-- credit Ultak
  db:priv_AddDB("Herbs", 242298); -- Dragonsprout Grass - 81-- credit Ultak
  db:priv_AddDB("Herbs", 242262); -- Cold Psilotum - 86-- credit Ultak
  db:priv_AddDB("Herbs", 242274); -- Snow Grass - 91-- credit Ultak
  db:priv_AddDB("Herbs", 242310); -- Moon Grass - 91-- credit Ultak
end

local function priv_AddRawMaterials(db)
  -- Orange
  db:priv_AddDB("RawMaterials", 205829); -- Feyenloth's Growth
  db:priv_AddDB("RawMaterials", 205831); -- Feyenloth's Rage
  db:priv_AddDB("RawMaterials", 205828); -- Feyenloth's Rest
  db:priv_AddDB("RawMaterials", 205830); -- Feyenloth's Return
  db:priv_AddDB("RawMaterials", 205827); -- Feyenloth's Tranquility
  db:priv_AddDB("RawMaterials", 205832); -- Strange Magical Leaf
  db:priv_AddDB("RawMaterials", 204529); -- Hormone Crystal
  -- Purple
  db:priv_AddDB("RawMaterials", 205729); -- Feyenloth's Fear
  db:priv_AddDB("RawMaterials", 205823); -- Payer of Life
  db:priv_AddDB("RawMaterials", 205826); -- Prayer of Protection
  db:priv_AddDB("RawMaterials", 205822); -- Prayer of Repletion
  db:priv_AddDB("RawMaterials", 205811); -- Prayer of Resting
  db:priv_AddDB("RawMaterials", 205825); -- Prayer of Struggle
  db:priv_AddDB("RawMaterials", 205824); -- Prayer of Weaving
  db:priv_AddDB("RawMaterials", 203018); -- Rune Crystal
  db:priv_AddDB("RawMaterials", 241820); -- Frost Breath
  db:priv_AddDB("RawMaterials", 206032); -- ?????
  db:priv_AddDB("RawMaterials", 206033); -- ?????
  db:priv_AddDB("RawMaterials", 206034); -- ?????
  db:priv_AddDB("RawMaterials", 206035); -- ?????
  db:priv_AddDB("RawMaterials", 240077); -- Colorful Iron Sand
  db:priv_AddDB("RawMaterials", 240076); -- Spiritwood Branch
  db:priv_AddDB("RawMaterials", 240075); -- Dragon Skin
  db:priv_AddDB("RawMaterials", 240074); -- Silver Feather Silk
  db:priv_AddDB("RawMaterials", 240073); -- Unicorn Tail
  db:priv_AddDB("RawMaterials", 240072); -- Secret Spice
  -- Blue
  db:priv_AddDB("RawMaterials", 202125); -- Aloeswood Fiber
  db:priv_AddDB("RawMaterials", 202117); -- Alpha Metal Stone
  db:priv_AddDB("RawMaterials", 202112); -- Aluminum Nail
  db:priv_AddDB("RawMaterials", 202132); -- Amber Fiber
  db:priv_AddDB("RawMaterials", 202128); -- Balloonflower Fiber
  db:priv_AddDB("RawMaterials", 202118); -- Beta Metal Stone
  db:priv_AddDB("RawMaterials", 202126); -- Calamus Fiber
  db:priv_AddDB("RawMaterials", 202129); -- Chestnut Fiber
  db:priv_AddDB("RawMaterials", 202110); -- Copper Nail
  db:priv_AddDB("RawMaterials", 202986); -- Crushed Purple Jade
  db:priv_AddDB("RawMaterials", 202120); -- Delta Metal Stone
  db:priv_AddDB("RawMaterials", 203017); -- Elemental Crystal
  db:priv_AddDB("RawMaterials", 202121); -- Epsilon Metal Stone
  db:priv_AddDB("RawMaterials", 202123); -- Eta Metal Stone
  db:priv_AddDB("RawMaterials", 205728); -- Feyenloth's Broken Soul
  db:priv_AddDB("RawMaterials", 202988); -- Flame Crystal Sand
  db:priv_AddDB("RawMaterials", 202119); -- Gamma Metal Stone
  db:priv_AddDB("RawMaterials", 203014); -- Gem From Hammertooth Mask
  db:priv_AddDB("RawMaterials", 202987); -- Gloomy Crystal Sand
  db:priv_AddDB("RawMaterials", 202116); -- Gold Nail
  db:priv_AddDB("RawMaterials", 202111); -- Iron Nail
  db:priv_AddDB("RawMaterials", 203013); -- Kobold Crown Fragment
  db:priv_AddDB("RawMaterials", 202131); -- Lapis Lazuli Fiber
  db:priv_AddDB("RawMaterials", 202130); -- Pine Fiber
  db:priv_AddDB("RawMaterials", 202115); -- Platinum Nail
  db:priv_AddDB("RawMaterials", 202990); -- Refined Fire Essence Nugget
  db:priv_AddDB("RawMaterials", 202991); -- Refined Water Essence Nugget
  db:priv_AddDB("RawMaterials", 202989); -- Sharp Gravel
  db:priv_AddDB("RawMaterials", 202114); -- Silver Nail
  db:priv_AddDB("RawMaterials", 202984); -- Smashed Fire Essence Fragment
  db:priv_AddDB("RawMaterials", 202985); -- Smashed Water Essence Fragment
  db:priv_AddDB("RawMaterials", 202113); -- Steel Nail
  db:priv_AddDB("RawMaterials", 202104); -- Stone of Fire Planet
  db:priv_AddDB("RawMaterials", 202105); -- Stone of the Earth Planet
  db:priv_AddDB("RawMaterials", 202101); -- Stone of the Golden Planet
  db:priv_AddDB("RawMaterials", 202107); -- Stone of the Planet of the Heavnly King
  db:priv_AddDB("RawMaterials", 202108); -- Stone of the Planet of the King of Darkness
  db:priv_AddDB("RawMaterials", 202102); -- Stone of the Tree Planet
  db:priv_AddDB("RawMaterials", 202106); -- Stone of the Water King Planet
  db:priv_AddDB("RawMaterials", 202103); -- Stone of the Water Planet
  db:priv_AddDB("RawMaterials", 202992); -- Tempered Fire Essence Nugget
  db:priv_AddDB("RawMaterials", 202993); -- Tempered Water Essence Nugget
  db:priv_AddDB("RawMaterials", 202124); -- Thet Metal Stone
  db:priv_AddDB("RawMaterials", 202127); -- Tulipwood Fiber
  db:priv_AddDB("RawMaterials", 202109); -- Wooden Nail
  db:priv_AddDB("RawMaterials", 202122); -- Zeta Metal Stone
  db:priv_AddDB("RawMaterials", 242314); -- Siren Star
  db:priv_AddDB("RawMaterials", 242315); -- Tin Nail
  db:priv_AddDB("RawMaterials", 242316); -- Desny Metal Stone
  db:priv_AddDB("RawMaterials", 242317); -- Green Fibre
  db:priv_AddDB("RawMaterials", 242318); -- Peace Stone
  db:priv_AddDB("RawMaterials", 242319); -- Silver-Mercury Nail
  db:priv_AddDB("RawMaterials", 242320); -- Rogi Metal Stone
  db:priv_AddDB("RawMaterials", 242321); -- Cotton Fiber
  db:priv_AddDB("RawMaterials", 242322); -- Lotus Star
  db:priv_AddDB("RawMaterials", 242323); -- Wolfram Gold Nail
  db:priv_AddDB("RawMaterials", 242324); -- Floyd Metal Stone
  db:priv_AddDB("RawMaterials", 242325); -- Beach Fibre
  db:priv_AddDB("RawMaterials", 242326); -- Rainbow Star
  db:priv_AddDB("RawMaterials", 242327); -- Silver Copper Nail
  db:priv_AddDB("RawMaterials", 242328); -- Gutis Metal Stone
  db:priv_AddDB("RawMaterials", 242329); -- Mineral Wolf Fibre
  db:priv_AddDB("RawMaterials", 207409); -- Harvest God Star Stone
  db:priv_AddDB("RawMaterials", 207410); -- Wisdom God Star Stone
  db:priv_AddDB("RawMaterials", 207411); -- White Gold Nail
  db:priv_AddDB("RawMaterials", 207412); -- Wolfram Nail
  db:priv_AddDB("RawMaterials", 207413); -- Soaring Tower Metal Stone
  db:priv_AddDB("RawMaterials", 207414); -- Shigassa Metal Stone
  db:priv_AddDB("RawMaterials", 207415); -- Soaring Tower Metal Stone
  db:priv_AddDB("RawMaterials", 207416); -- Sago Palm Fiber
  db:priv_AddDB("RawMaterials", 208252); -- Fertile Goddess Star Stone
  db:priv_AddDB("RawMaterials", 208253); -- Mottled Copper Nail
  db:priv_AddDB("RawMaterials", 208254); -- Ikes' Metal Stone
  db:priv_AddDB("RawMaterials", 208255); -- Flax
  db:priv_AddDB("RawMaterials", 240410); -- Dark Planet Stone
  db:priv_AddDB("RawMaterials", 240411); -- White Iron Nail
  db:priv_AddDB("RawMaterials", 240412); -- Sigma Metal Stone
  db:priv_AddDB("RawMaterials", 240413); -- Palm Fiber
  db:priv_AddDB("RawMaterials", 242063); -- Hebe
  db:priv_AddDB("RawMaterials", 242064); -- Silver Nail
  db:priv_AddDB("RawMaterials", 242065); -- Impeth Metal Stone
  db:priv_AddDB("RawMaterials", 242066); -- Mulberry Fiber
  db:priv_AddDB("RawMaterials", 241463); -- Star Of Discord
  db:priv_AddDB("RawMaterials", 241464); -- Dark Silver Nail
  db:priv_AddDB("RawMaterials", 241465); -- Ruite Metal Stone
  db:priv_AddDB("RawMaterials", 241466); -- Ginkgo Fiber
  db:priv_AddDB("RawMaterials", 206039); -- ?????
  db:priv_AddDB("RawMaterials", 206040); -- ?????
  db:priv_AddDB("RawMaterials", 206041); -- ?????
  db:priv_AddDB("RawMaterials", 206039); -- ?????
  db:priv_AddDB("RawMaterials", 206026); -- ?????
  db:priv_AddDB("RawMaterials", 206027); -- ?????
  -- Green
  db:priv_AddDB("RawMaterials", 203015); -- Assassin's Sword Hilt
  db:priv_AddDB("RawMaterials", 203011); -- Broken Goblin Staff
  db:priv_AddDB("RawMaterials", 203008); -- Crimson Hog Hide
  db:priv_AddDB("RawMaterials", 203012); -- Damaged Fine Repeating Crossbow
  db:priv_AddDB("RawMaterials", 203009); -- Damaged Kobold Battle Axe
  db:priv_AddDB("RawMaterials", 203016); -- Gomio's Rucksack
  db:priv_AddDB("RawMaterials", 203005); -- Low Magic Element
  db:priv_AddDB("RawMaterials", 203007); -- Low Rune Power
  db:priv_AddDB("RawMaterials", 203019); -- Medium Magic Element
  db:priv_AddDB("RawMaterials", 203020); -- Medium Rune Power
  db:priv_AddDB("RawMaterials", 202994); -- Very Low Magic Element
  db:priv_AddDB("RawMaterials", 203006); -- Very Low Rune Power
  db:priv_AddDB("RawMaterials", 203010); -- Worn Kobold Robe
  db:priv_AddDB("RawMaterials", 206028); -- Resilient Dragon Skin
  db:priv_AddDB("RawMaterials", 206029); -- ?????
  db:priv_AddDB("RawMaterials", 206030); -- ?????
  db:priv_AddDB("RawMaterials", 206031); -- ?????
  db:priv_AddDB("RawMaterials", 206036); -- ?????
  db:priv_AddDB("RawMaterials", 206037); -- ?????
  db:priv_AddDB("RawMaterials", 206038); -- ?????
  -- White
  db:priv_AddDB("RawMaterials", 201952); -- Alchemy Bottle
  db:priv_AddDB("RawMaterials", 203419); -- Animal Meat
  db:priv_AddDB("RawMaterials", 200473); -- Apple
  db:priv_AddDB("RawMaterials", 200534); -- Arapaima
  db:priv_AddDB("RawMaterials", 200532); -- Bass
  db:priv_AddDB("RawMaterials", 201951); -- Beaker
  db:priv_AddDB("RawMaterials", 200766); -- Bird Meat
  db:priv_AddDB("RawMaterials", 200530); -- Blue Trout
  db:priv_AddDB("RawMaterials", 200491); -- Celery
  db:priv_AddDB("RawMaterials", 203425); -- Cocoa
  db:priv_AddDB("RawMaterials", 200782); -- Cream
  db:priv_AddDB("RawMaterials", 200767); -- Delicious Worm Meat
  db:priv_AddDB("RawMaterials", 203421); -- Flour
  db:priv_AddDB("RawMaterials", 203418); -- Frog Meat
  db:priv_AddDB("RawMaterials", 203426); -- Garlic
  db:priv_AddDB("RawMaterials", 203423); -- Golden Flour
  db:priv_AddDB("RawMaterials", 200479); -- Grape
  db:priv_AddDB("RawMaterials", 201539); -- Green-spotted Fungus Bread
  db:priv_AddDB("RawMaterials", 203422); -- High Quality Flour
  db:priv_AddDB("RawMaterials", 201540); -- Highlands Demon Weed Seed
  db:priv_AddDB("RawMaterials", 200489); -- Lettuce
  db:priv_AddDB("RawMaterials", 203395); -- Magic Bottle
  db:priv_AddDB("RawMaterials", 203427); -- Mushroom
  db:priv_AddDB("RawMaterials", 201534); -- Newborn Boar Tusk
  db:priv_AddDB("RawMaterials", 203428); -- Oriental Tea Leaves
  db:priv_AddDB("RawMaterials", 201953); -- Philosopher's Egg
  db:priv_AddDB("RawMaterials", 200480); -- Pineapple
  db:priv_AddDB("RawMaterials", 203420); -- Rare Animal Meat
  db:priv_AddDB("RawMaterials", 200529); -- Salmon
  db:priv_AddDB("RawMaterials", 201950); -- Small Empty Bottle
  db:priv_AddDB("RawMaterials", 200528); -- Small Fish
  db:priv_AddDB("RawMaterials", 201537); -- Snow Frog Placenta
  db:priv_AddDB("RawMaterials", 200543); -- Spiny Lobster
  db:priv_AddDB("RawMaterials", 201536); -- Wandering Ent Bud
  db:priv_AddDB("RawMaterials", 203424); -- Witchcraft Sugar
  db:priv_AddDB("RawMaterials", 201538); -- Young Ostrich's Egg
  -- Boss Furniture
  
end

local function priv_AddProductionRunes(db)
  -- Purple
  db:priv_AddDB("ProductionRunes", 201086); -- Advanced Skill Reset Stone
  db:priv_AddDB("ProductionRunes", 202088); -- Bag of Activate-Runes
  db:priv_AddDB("ProductionRunes", 202091); -- Bag of Blend-Runes
  db:priv_AddDB("ProductionRunes", 202089); -- Bag of Disenchant-Runes
  db:priv_AddDB("ProductionRunes", 202087); -- Bag of Frost-Runes
  db:priv_AddDB("ProductionRunes", 202086); -- Bag of Link-Runes
  db:priv_AddDB("ProductionRunes", 202090); -- Bag of Purify-Runes
  db:priv_AddDB("ProductionRunes", 201971); -- Basic Skill Reset Stone
  db:priv_AddDB("ProductionRunes", 203035); -- Skill Reset Rune
  -- White
  db:priv_AddDB("ProductionRunes", 200852); -- Activate Rune
  db:priv_AddDB("ProductionRunes", 200855); -- Blend Rune
  db:priv_AddDB("ProductionRunes", 200856); -- Day & Night Rune
  db:priv_AddDB("ProductionRunes", 200853); -- Disenchant Rune
  db:priv_AddDB("ProductionRunes", 200851); -- Frost Rune
  db:priv_AddDB("ProductionRunes", 200850); -- Link Rune
  db:priv_AddDB("ProductionRunes", 200854); -- Purify Rune
  db:priv_AddDB("ProductionRunes", 200857); -- Season Rune
  db:priv_AddDB("ProductionRunes", 200858); -- Years Rune
end

local function priv_AddRunes(db)
  -- Accuracy
  db:priv_AddDB("Runes", 521331); -- Accuracy I
  db:priv_AddDB("Runes", 521332); -- Accuracy II
  db:priv_AddDB("Runes", 521333); -- Accuracy III
  db:priv_AddDB("Runes", 521334); -- Accuracy IV
  db:priv_AddDB("Runes", 521335); -- Accuracy V
  db:priv_AddDB("Runes", 521336); -- Accuracy VI
  db:priv_AddDB("Runes", 521337); -- Accuracy VII
  db:priv_AddDB("Runes", 521338); -- Accuracy VIII
  db:priv_AddDB("Runes", 521339); -- Accuracy IX
  db:priv_AddDB("Runes", 521340); -- Accuracy X
  
  -- Advance
  db:priv_AddDB("Runes", 520581); -- Advance I
  db:priv_AddDB("Runes", 520582); -- Advance II
  db:priv_AddDB("Runes", 520583); -- Advance III
  db:priv_AddDB("Runes", 520584); -- Advance IV
  db:priv_AddDB("Runes", 520585); -- Advance V
  db:priv_AddDB("Runes", 520586); -- Advance VI
  db:priv_AddDB("Runes", 520587); -- Advance VII
  db:priv_AddDB("Runes", 520588); -- Advance VIII
  db:priv_AddDB("Runes", 520589); -- Advance IX
  db:priv_AddDB("Runes", 520590); -- Advance X
  
  -- Aggression
  db:priv_AddDB("Runes", 520561); -- Aggression I
  db:priv_AddDB("Runes", 520562); -- Aggression II
  db:priv_AddDB("Runes", 520563); -- Aggression III
  db:priv_AddDB("Runes", 520564); -- Aggression IV
  db:priv_AddDB("Runes", 520565); -- Aggression V
  db:priv_AddDB("Runes", 520566); -- Aggression VI
  db:priv_AddDB("Runes", 520567); -- Aggression VII
  db:priv_AddDB("Runes", 520568); -- Aggression VIII
  db:priv_AddDB("Runes", 520569); -- Aggression IX
  db:priv_AddDB("Runes", 520570); -- Aggression X
  
  -- Agile
  db:priv_AddDB("Runes", 520521); -- Agile I
  db:priv_AddDB("Runes", 520522); -- Agile II
  db:priv_AddDB("Runes", 520523); -- Agile III
  db:priv_AddDB("Runes", 520524); -- Agile IV
  db:priv_AddDB("Runes", 520525); -- Agile V
  db:priv_AddDB("Runes", 520526); -- Agile VI
  db:priv_AddDB("Runes", 520527); -- Agile VII
  db:priv_AddDB("Runes", 520528); -- Agile VIII
  db:priv_AddDB("Runes", 520529); -- Agile IX
  db:priv_AddDB("Runes", 520530); -- Agile X
  
  -- Anger
  db:priv_AddDB("Runes", 520361); -- Anger I
  db:priv_AddDB("Runes", 520362); -- Anger II
  db:priv_AddDB("Runes", 520363); -- Anger III
  db:priv_AddDB("Runes", 520364); -- Anger IV
  db:priv_AddDB("Runes", 520365); -- Anger V
  db:priv_AddDB("Runes", 520366); -- Anger VI
  db:priv_AddDB("Runes", 520367); -- Anger VII
  db:priv_AddDB("Runes", 520368); -- Anger VIII
  db:priv_AddDB("Runes", 520369); -- Anger IX
  db:priv_AddDB("Runes", 520370); -- Anger X
  
  -- Atonement
  db:priv_AddDB("Runes", 520241); -- Atonement I
  db:priv_AddDB("Runes", 520242); -- Atonement II
  db:priv_AddDB("Runes", 520243); -- Atonement III
  db:priv_AddDB("Runes", 520244); -- Atonement IV
  db:priv_AddDB("Runes", 520245); -- Atonement V
  db:priv_AddDB("Runes", 520246); -- Atonement VI
  db:priv_AddDB("Runes", 520247); -- Atonement VII
  db:priv_AddDB("Runes", 520248); -- Atonement VIII
  db:priv_AddDB("Runes", 520249); -- Atonement IX
  db:priv_AddDB("Runes", 520250); -- Atonement X
  
  -- Barrier
  db:priv_AddDB("Runes", 520381); -- Barrier I
  db:priv_AddDB("Runes", 520382); -- Barrier II
  db:priv_AddDB("Runes", 520383); -- Barrier III
  db:priv_AddDB("Runes", 520384); -- Barrier IV
  db:priv_AddDB("Runes", 520385); -- Barrier V
  db:priv_AddDB("Runes", 520386); -- Barrier VI
  db:priv_AddDB("Runes", 520387); -- Barrier VII
  db:priv_AddDB("Runes", 520388); -- Barrier VIII
  db:priv_AddDB("Runes", 520389); -- Barrier IX
  db:priv_AddDB("Runes", 520390); -- Barrier X
  
  -- Block
  db:priv_AddDB("Runes", 520621); -- Block I
  db:priv_AddDB("Runes", 520622); -- Block II
  db:priv_AddDB("Runes", 520623); -- Block III
  db:priv_AddDB("Runes", 520624); -- Block IV
  db:priv_AddDB("Runes", 520625); -- Block V
  db:priv_AddDB("Runes", 520626); -- Block VI
  db:priv_AddDB("Runes", 520627); -- Block VII
  db:priv_AddDB("Runes", 520628); -- Block VIII
  db:priv_AddDB("Runes", 520629); -- Block IX
  db:priv_AddDB("Runes", 520630); -- Block X
  
  -- Burst
  db:priv_AddDB("Runes", 520781); -- Burst I
  db:priv_AddDB("Runes", 520782); -- Burst II
  db:priv_AddDB("Runes", 520783); -- Burst III
  db:priv_AddDB("Runes", 520784); -- Burst IV
  db:priv_AddDB("Runes", 520785); -- Burst V
  db:priv_AddDB("Runes", 520786); -- Burst VI
  db:priv_AddDB("Runes", 520787); -- Burst VII
  db:priv_AddDB("Runes", 520788); -- Burst VIII
  db:priv_AddDB("Runes", 520789); -- Burst IX
  db:priv_AddDB("Runes", 520790); -- Burst X
  
  -- Capability
  db:priv_AddDB("Runes", 521151); -- Capability I
  db:priv_AddDB("Runes", 521152); -- Capability II
  db:priv_AddDB("Runes", 521153); -- Capability III
  db:priv_AddDB("Runes", 521154); -- Capability IV
  db:priv_AddDB("Runes", 521155); -- Capability V
  db:priv_AddDB("Runes", 521156); -- Capability VI
  db:priv_AddDB("Runes", 521157); -- Capability VII
  db:priv_AddDB("Runes", 521158); -- Capability VIII
  db:priv_AddDB("Runes", 521159); -- Capability IX
  db:priv_AddDB("Runes", 521160); -- Capability X
  
  -- Charm
  db:priv_AddDB("Runes", 521031); -- Charm I
  db:priv_AddDB("Runes", 521032); -- Charm II
  db:priv_AddDB("Runes", 521033); -- Charm III
  db:priv_AddDB("Runes", 521034); -- Charm IV
  db:priv_AddDB("Runes", 521035); -- Charm V
  db:priv_AddDB("Runes", 521036); -- Charm VI
  db:priv_AddDB("Runes", 521037); -- Charm VII
  db:priv_AddDB("Runes", 521038); -- Charm VIII
  db:priv_AddDB("Runes", 521039); -- Charm IX
  db:priv_AddDB("Runes", 521040); -- Charm X
 
  -- Comprehension
  db:priv_AddDB("Runes", 521191); -- Comprehension I
  db:priv_AddDB("Runes", 521192); -- Comprehension II
  db:priv_AddDB("Runes", 521193); -- Comprehension III
  db:priv_AddDB("Runes", 521194); -- Comprehension IV
  db:priv_AddDB("Runes", 521195); -- Comprehension V
  db:priv_AddDB("Runes", 521196); -- Comprehension VI
  db:priv_AddDB("Runes", 521197); -- Comprehension VII
  db:priv_AddDB("Runes", 521198); -- Comprehension VIII
  db:priv_AddDB("Runes", 521199); -- Comprehension IX
  db:priv_AddDB("Runes", 521200); -- Comprehension X
 
  -- Cruelty
  db:priv_AddDB("Runes", 521011); -- Cruelty I
  db:priv_AddDB("Runes", 521012); -- Cruelty II
  db:priv_AddDB("Runes", 521013); -- Cruelty III
  db:priv_AddDB("Runes", 521014); -- Cruelty IV
  db:priv_AddDB("Runes", 521015); -- Cruelty V
  db:priv_AddDB("Runes", 521016); -- Cruelty VI
  db:priv_AddDB("Runes", 521017); -- Cruelty VII
  db:priv_AddDB("Runes", 521018); -- Cruelty VIII
  db:priv_AddDB("Runes", 521019); -- Cruelty IX
  db:priv_AddDB("Runes", 521020); -- Cruelty X
 
  -- Curse
  db:priv_AddDB("Runes", 521311); -- Curse I
  db:priv_AddDB("Runes", 521312); -- Curse II
  db:priv_AddDB("Runes", 521313); -- Curse III
  db:priv_AddDB("Runes", 521314); -- Curse IV
  db:priv_AddDB("Runes", 521315); -- Curse V
  db:priv_AddDB("Runes", 521316); -- Curse VI
  db:priv_AddDB("Runes", 521317); -- Curse VII
  db:priv_AddDB("Runes", 521318); -- Curse VIII
  db:priv_AddDB("Runes", 521319); -- Curse IX
  db:priv_AddDB("Runes", 521320); -- Curse X
 
  -- Dauntlessness
  db:priv_AddDB("Runes", 521231); -- Dauntlessness I
  db:priv_AddDB("Runes", 521232); -- Dauntlessness II
  db:priv_AddDB("Runes", 521233); -- Dauntlessness III
  db:priv_AddDB("Runes", 521234); -- Dauntlessness IV
  db:priv_AddDB("Runes", 521235); -- Dauntlessness V
  db:priv_AddDB("Runes", 521236); -- Dauntlessness VI
  db:priv_AddDB("Runes", 521237); -- Dauntlessness VII
  db:priv_AddDB("Runes", 521238); -- Dauntlessness VIII
  db:priv_AddDB("Runes", 521239); -- Dauntlessness IX
  db:priv_AddDB("Runes", 521240); -- Dauntlessness X
 
   -- Defense
  db:priv_AddDB("Runes", 520201); -- Defense I
  db:priv_AddDB("Runes", 520202); -- Defense II
  db:priv_AddDB("Runes", 520203); -- Defense III
  db:priv_AddDB("Runes", 520204); -- Defense IV
  db:priv_AddDB("Runes", 520205); -- Defense V
  db:priv_AddDB("Runes", 520206); -- Defense VI
  db:priv_AddDB("Runes", 520207); -- Defense VII
  db:priv_AddDB("Runes", 520208); -- Defense VIII
  db:priv_AddDB("Runes", 520209); -- Defense IX
  db:priv_AddDB("Runes", 520210); -- Defense X
  
  -- Destruction
  db:priv_AddDB("Runes", 521271); -- Destruction I
  db:priv_AddDB("Runes", 521272); -- Destruction II
  db:priv_AddDB("Runes", 521273); -- Destruction III
  db:priv_AddDB("Runes", 521274); -- Destruction IV
  db:priv_AddDB("Runes", 521275); -- Destruction V
  db:priv_AddDB("Runes", 521276); -- Destruction VI
  db:priv_AddDB("Runes", 521277); -- Destruction VII
  db:priv_AddDB("Runes", 521278); -- Destruction VIII
  db:priv_AddDB("Runes", 521279); -- Destruction IX
  db:priv_AddDB("Runes", 521280); -- Destruction X
 
  -- Devil
  db:priv_AddDB("Runes", 521111); -- Devil I
  db:priv_AddDB("Runes", 521112); -- Devil II
  db:priv_AddDB("Runes", 521113); -- Devil III
  db:priv_AddDB("Runes", 521114); -- Devil IV
  db:priv_AddDB("Runes", 521115); -- Devil V
  db:priv_AddDB("Runes", 521116); -- Devil VI
  db:priv_AddDB("Runes", 521117); -- Devil VII
  db:priv_AddDB("Runes", 521118); -- Devil VIII
  db:priv_AddDB("Runes", 521119); -- Devil IX
  db:priv_AddDB("Runes", 521120); -- Devil X
 
  -- Dexterity
  db:priv_AddDB("Runes", 520951); -- Dexterity I
  db:priv_AddDB("Runes", 520952); -- Dexterity II
  db:priv_AddDB("Runes", 520953); -- Dexterity III
  db:priv_AddDB("Runes", 520954); -- Dexterity IV
  db:priv_AddDB("Runes", 520955); -- Dexterity V
  db:priv_AddDB("Runes", 520956); -- Dexterity VI
  db:priv_AddDB("Runes", 520957); -- Dexterity VII
  db:priv_AddDB("Runes", 520958); -- Dexterity VIII
  db:priv_AddDB("Runes", 520959); -- Dexterity IX
  db:priv_AddDB("Runes", 520960); -- Dexterity X
 
  -- Enchantment
  db:priv_AddDB("Runes", 521251); -- Enchantment I
  db:priv_AddDB("Runes", 521252); -- Enchantment II
  db:priv_AddDB("Runes", 521253); -- Enchantment III
  db:priv_AddDB("Runes", 521254); -- Enchantment IV
  db:priv_AddDB("Runes", 521255); -- Enchantment V
  db:priv_AddDB("Runes", 521256); -- Enchantment VI
  db:priv_AddDB("Runes", 521257); -- Enchantment VII
  db:priv_AddDB("Runes", 521258); -- Enchantment VIII
  db:priv_AddDB("Runes", 521259); -- Enchantment IX
  db:priv_AddDB("Runes", 521260); -- Enchantment X
 
  -- Endurance
  db:priv_AddDB("Runes", 520121); -- Endurance I
  db:priv_AddDB("Runes", 520122); -- Endurance II
  db:priv_AddDB("Runes", 520123); -- Endurance III
  db:priv_AddDB("Runes", 520124); -- Endurance IV
  db:priv_AddDB("Runes", 520125); -- Endurance V
  db:priv_AddDB("Runes", 520126); -- Endurance VI
  db:priv_AddDB("Runes", 520127); -- Endurance VII
  db:priv_AddDB("Runes", 520128); -- Endurance VIII
  db:priv_AddDB("Runes", 520129); -- Endurance IX
  db:priv_AddDB("Runes", 520130); -- Endurance X
  
  -- Enlightenment
  db:priv_AddDB("Runes", 521351); -- Enlightenment I
  db:priv_AddDB("Runes", 521352); -- Enlightenment II
  db:priv_AddDB("Runes", 521353); -- Enlightenment III
  db:priv_AddDB("Runes", 521354); -- Enlightenment IV
  db:priv_AddDB("Runes", 521355); -- Enlightenment V
  db:priv_AddDB("Runes", 521356); -- Enlightenment VI
  db:priv_AddDB("Runes", 521357); -- Enlightenment VII
  db:priv_AddDB("Runes", 521358); -- Enlightenment VIII
  db:priv_AddDB("Runes", 521359); -- Enlightenment IX
  db:priv_AddDB("Runes", 521360); -- Enlightenment X
 
 -- Excite
  db:priv_AddDB("Runes", 520281); -- Excite I
  db:priv_AddDB("Runes", 520282); -- Excite II
  db:priv_AddDB("Runes", 520283); -- Excite III
  db:priv_AddDB("Runes", 520284); -- Excite IV
  db:priv_AddDB("Runes", 520285); -- Excite V
  db:priv_AddDB("Runes", 520286); -- Excite VI
  db:priv_AddDB("Runes", 520287); -- Excite VII
  db:priv_AddDB("Runes", 520288); -- Excite VIII
  db:priv_AddDB("Runes", 520289); -- Excite IX
  db:priv_AddDB("Runes", 520290); -- Excite X
  
  -- Experience
  db:priv_AddDB("Runes", 520741); -- Experience I
  db:priv_AddDB("Runes", 520742); -- Experience II
  db:priv_AddDB("Runes", 520743); -- Experience III
  db:priv_AddDB("Runes", 520744); -- Experience IV
  db:priv_AddDB("Runes", 520745); -- Experience V
  db:priv_AddDB("Runes", 520746); -- Experience VI
  db:priv_AddDB("Runes", 520747); -- Experience VII
  db:priv_AddDB("Runes", 520748); -- Experience VIII
  db:priv_AddDB("Runes", 520749); -- Experience IX
  db:priv_AddDB("Runes", 520750); -- Experience X
  
  -- Fatal
  db:priv_AddDB("Runes", 520761); -- Fatal I
  db:priv_AddDB("Runes", 520762); -- Fatal II
  db:priv_AddDB("Runes", 520763); -- Fatal III
  db:priv_AddDB("Runes", 520764); -- Fatal IV
  db:priv_AddDB("Runes", 520765); -- Fatal V
  db:priv_AddDB("Runes", 520766); -- Fatal VI
  db:priv_AddDB("Runes", 520767); -- Fatal VII
  db:priv_AddDB("Runes", 520768); -- Fatal VIII
  db:priv_AddDB("Runes", 520769); -- Fatal IX
  db:priv_AddDB("Runes", 520770); -- Fatal X
  
  -- Fearless
  db:priv_AddDB("Runes", 520481); -- Fearless I
  db:priv_AddDB("Runes", 520482); -- Fearless II
  db:priv_AddDB("Runes", 520483); -- Fearless III
  db:priv_AddDB("Runes", 520484); -- Fearless IV
  db:priv_AddDB("Runes", 520485); -- Fearless V
  db:priv_AddDB("Runes", 520486); -- Fearless VI
  db:priv_AddDB("Runes", 520487); -- Fearless VII
  db:priv_AddDB("Runes", 520488); -- Fearless VIII
  db:priv_AddDB("Runes", 520489); -- Fearless IX
  db:priv_AddDB("Runes", 520490); -- Fearless X
  
  -- Ferocity
  db:priv_AddDB("Runes", 521091); -- Ferocity I
  db:priv_AddDB("Runes", 521092); -- Ferocity II
  db:priv_AddDB("Runes", 521093); -- Ferocity III
  db:priv_AddDB("Runes", 521094); -- Ferocity IV
  db:priv_AddDB("Runes", 521095); -- Ferocity V
  db:priv_AddDB("Runes", 521096); -- Ferocity VI
  db:priv_AddDB("Runes", 521097); -- Ferocity VII
  db:priv_AddDB("Runes", 521098); -- Ferocity VIII
  db:priv_AddDB("Runes", 521099); -- Ferocity IX
  db:priv_AddDB("Runes", 521100); -- Ferocity X
 
  -- Fountain
  db:priv_AddDB("Runes", 520461); -- Fountain I
  db:priv_AddDB("Runes", 520462); -- Fountain II
  db:priv_AddDB("Runes", 520463); -- Fountain III
  db:priv_AddDB("Runes", 520464); -- Fountain IV
  db:priv_AddDB("Runes", 520465); -- Fountain V
  db:priv_AddDB("Runes", 520466); -- Fountain VI
  db:priv_AddDB("Runes", 520467); -- Fountain VII
  db:priv_AddDB("Runes", 520468); -- Fountain VIII
  db:priv_AddDB("Runes", 520469); -- Fountain IX
  db:priv_AddDB("Runes", 520470); -- Fountain X
  
  -- Grasp
  db:priv_AddDB("Runes", 521131); -- Grasp I
  db:priv_AddDB("Runes", 521132); -- Grasp II
  db:priv_AddDB("Runes", 521133); -- Grasp III
  db:priv_AddDB("Runes", 521134); -- Grasp IV
  db:priv_AddDB("Runes", 521135); -- Grasp V
  db:priv_AddDB("Runes", 521136); -- Grasp VI
  db:priv_AddDB("Runes", 521137); -- Grasp VII
  db:priv_AddDB("Runes", 521138); -- Grasp VIII
  db:priv_AddDB("Runes", 521139); -- Grasp IX
  db:priv_AddDB("Runes", 521140); -- Grasp X
 
  -- Guts
  db:priv_AddDB("Runes", 520301); -- Guts I
  db:priv_AddDB("Runes", 520302); -- Guts II
  db:priv_AddDB("Runes", 520303); -- Guts III
  db:priv_AddDB("Runes", 520304); -- Guts IV
  db:priv_AddDB("Runes", 520305); -- Guts V
  db:priv_AddDB("Runes", 520306); -- Guts VI
  db:priv_AddDB("Runes", 520307); -- Guts VII
  db:priv_AddDB("Runes", 520308); -- Guts VIII
  db:priv_AddDB("Runes", 520309); -- Guts IX
  db:priv_AddDB("Runes", 520310); -- Guts X
  
  -- Harm
  db:priv_AddDB("Runes", 520161); -- Harm I
  db:priv_AddDB("Runes", 520162); -- Harm II
  db:priv_AddDB("Runes", 520163); -- Harm III
  db:priv_AddDB("Runes", 520164); -- Harm IV
  db:priv_AddDB("Runes", 520165); -- Harm V
  db:priv_AddDB("Runes", 520166); -- Harm VI
  db:priv_AddDB("Runes", 520167); -- Harm VII
  db:priv_AddDB("Runes", 520168); -- Harm VIII
  db:priv_AddDB("Runes", 520169); -- Harm IX
  db:priv_AddDB("Runes", 520170); -- Harm X
  
  -- Hatred
  db:priv_AddDB("Runes", 520681); -- Hatred I
  db:priv_AddDB("Runes", 520682); -- Hatred II
  db:priv_AddDB("Runes", 520683); -- Hatred III
  db:priv_AddDB("Runes", 520684); -- Hatred IV
  db:priv_AddDB("Runes", 520685); -- Hatred V
  db:priv_AddDB("Runes", 520686); -- Hatred VI
  db:priv_AddDB("Runes", 520687); -- Hatred VII
  db:priv_AddDB("Runes", 520688); -- Hatred VIII
  db:priv_AddDB("Runes", 520689); -- Hatred IX
  db:priv_AddDB("Runes", 520690); -- Hatred X
  
  -- Intellect
  db:priv_AddDB("Runes", 520911); -- Intellect I
  db:priv_AddDB("Runes", 520912); -- Intellect II
  db:priv_AddDB("Runes", 520913); -- Intellect III
  db:priv_AddDB("Runes", 520914); -- Intellect IV
  db:priv_AddDB("Runes", 520915); -- Intellect V
  db:priv_AddDB("Runes", 520916); -- Intellect VI
  db:priv_AddDB("Runes", 520917); -- Intellect VII
  db:priv_AddDB("Runes", 520918); -- Intellect VIII
  db:priv_AddDB("Runes", 520919); -- Intellect IX
  db:priv_AddDB("Runes", 520920); -- Intellect X
  
  -- Keenness
  db:priv_AddDB("Runes", 521171); -- Keenness I
  db:priv_AddDB("Runes", 521172); -- Keenness II
  db:priv_AddDB("Runes", 521173); -- Keenness III
  db:priv_AddDB("Runes", 521174); -- Keenness IV
  db:priv_AddDB("Runes", 521175); -- Keenness V
  db:priv_AddDB("Runes", 521176); -- Keenness VI
  db:priv_AddDB("Runes", 521177); -- Keenness VII
  db:priv_AddDB("Runes", 521178); -- Keenness VIII
  db:priv_AddDB("Runes", 521179); -- Keenness IX
  db:priv_AddDB("Runes", 521180); -- Keenness X
 
   -- Life
  db:priv_AddDB("Runes", 520971); -- Life I
  db:priv_AddDB("Runes", 520972); -- Life II
  db:priv_AddDB("Runes", 520973); -- Life III
  db:priv_AddDB("Runes", 520974); -- Life IV
  db:priv_AddDB("Runes", 520975); -- Life V
  db:priv_AddDB("Runes", 520976); -- Life VI
  db:priv_AddDB("Runes", 520977); -- Life VII
  db:priv_AddDB("Runes", 520978); -- Life VIII
  db:priv_AddDB("Runes", 520979); -- Life IX
  db:priv_AddDB("Runes", 520980); -- Life X
 
  -- Loot
  db:priv_AddDB("Runes", 520721); -- Loot I
  db:priv_AddDB("Runes", 520722); -- Loot II
  db:priv_AddDB("Runes", 520723); -- Loot III
  db:priv_AddDB("Runes", 520724); -- Loot IV
  db:priv_AddDB("Runes", 520725); -- Loot V
  db:priv_AddDB("Runes", 520726); -- Loot VI
  db:priv_AddDB("Runes", 520727); -- Loot VII
  db:priv_AddDB("Runes", 520728); -- Loot VIII
  db:priv_AddDB("Runes", 520729); -- Loot IX
  db:priv_AddDB("Runes", 520730); -- Loot X
  
  -- Madness
  db:priv_AddDB("Runes", 521211); -- Madness I
  db:priv_AddDB("Runes", 521212); -- Madness II
  db:priv_AddDB("Runes", 521213); -- Madness III
  db:priv_AddDB("Runes", 521214); -- Madness IV
  db:priv_AddDB("Runes", 521215); -- Madness V
  db:priv_AddDB("Runes", 521216); -- Madness VI
  db:priv_AddDB("Runes", 521217); -- Madness VII
  db:priv_AddDB("Runes", 521218); -- Madness VIII
  db:priv_AddDB("Runes", 521219); -- Madness IX
  db:priv_AddDB("Runes", 521220); -- Madness X
 
  -- Magic
  db:priv_AddDB("Runes", 520141); -- Magic I
  db:priv_AddDB("Runes", 520142); -- Magic II
  db:priv_AddDB("Runes", 520143); -- Magic III
  db:priv_AddDB("Runes", 520144); -- Magic IV
  db:priv_AddDB("Runes", 520145); -- Magic V
  db:priv_AddDB("Runes", 520146); -- Magic VI
  db:priv_AddDB("Runes", 520147); -- Magic VII
  db:priv_AddDB("Runes", 520148); -- Magic VIII
  db:priv_AddDB("Runes", 520149); -- Magic IX
  db:priv_AddDB("Runes", 520150); -- Magic X
  
  -- Mayhem
  db:priv_AddDB("Runes", 520421); -- Mayhem I
  db:priv_AddDB("Runes", 520422); -- Mayhem II
  db:priv_AddDB("Runes", 520423); -- Mayhem III
  db:priv_AddDB("Runes", 520424); -- Mayhem IV
  db:priv_AddDB("Runes", 520425); -- Mayhem V
  db:priv_AddDB("Runes", 520426); -- Mayhem VI
  db:priv_AddDB("Runes", 520427); -- Mayhem VII
  db:priv_AddDB("Runes", 520428); -- Mayhem VIII
  db:priv_AddDB("Runes", 520429); -- Mayhem IX
  db:priv_AddDB("Runes", 520430); -- Mayhem X
  
  -- Might
  db:priv_AddDB("Runes", 520501); -- Might I
  db:priv_AddDB("Runes", 520502); -- Might II
  db:priv_AddDB("Runes", 520503); -- Might III
  db:priv_AddDB("Runes", 520504); -- Might IV
  db:priv_AddDB("Runes", 520505); -- Might V
  db:priv_AddDB("Runes", 520506); -- Might VI
  db:priv_AddDB("Runes", 520507); -- Might VII
  db:priv_AddDB("Runes", 520508); -- Might VIII
  db:priv_AddDB("Runes", 520509); -- Might IX
  db:priv_AddDB("Runes", 520510); -- Might X
  
  -- Mind
  db:priv_AddDB("Runes", 520061); -- Mind I
  db:priv_AddDB("Runes", 520062); -- Mind II
  db:priv_AddDB("Runes", 520063); -- Mind III
  db:priv_AddDB("Runes", 520064); -- Mind IV
  db:priv_AddDB("Runes", 520065); -- Mind V
  db:priv_AddDB("Runes", 520066); -- Mind VI
  db:priv_AddDB("Runes", 520067); -- Mind VII
  db:priv_AddDB("Runes", 520068); -- Mind VIII
  db:priv_AddDB("Runes", 520069); -- Mind IX
  db:priv_AddDB("Runes", 520070); -- Mind X
  
  -- Miracle
  db:priv_AddDB("Runes", 520821); -- Miracle I
  db:priv_AddDB("Runes", 520822); -- Miracle II
  db:priv_AddDB("Runes", 520823); -- Miracle III
  db:priv_AddDB("Runes", 520824); -- Miracle IV
  db:priv_AddDB("Runes", 520825); -- Miracle V
  db:priv_AddDB("Runes", 520826); -- Miracle VI
  db:priv_AddDB("Runes", 520827); -- Miracle VII
  db:priv_AddDB("Runes", 520828); -- Miracle VIII
  db:priv_AddDB("Runes", 520829); -- Miracle IX
  db:priv_AddDB("Runes", 520830); -- Miracle X
  
  -- Passion
  db:priv_AddDB("Runes", 520441); -- Passion I
  db:priv_AddDB("Runes", 520442); -- Passion II
  db:priv_AddDB("Runes", 520443); -- Passion III
  db:priv_AddDB("Runes", 520444); -- Passion IV
  db:priv_AddDB("Runes", 520445); -- Passion V
  db:priv_AddDB("Runes", 520446); -- Passion VI
  db:priv_AddDB("Runes", 520447); -- Passion VII
  db:priv_AddDB("Runes", 520448); -- Passion VIII
  db:priv_AddDB("Runes", 520449); -- Passion IX
  db:priv_AddDB("Runes", 520450); -- Passion X
  
  -- Payback
  db:priv_AddDB("Runes", 520261); -- Payback I
  db:priv_AddDB("Runes", 520262); -- Payback II
  db:priv_AddDB("Runes", 520263); -- Payback III
  db:priv_AddDB("Runes", 520264); -- Payback IV
  db:priv_AddDB("Runes", 520265); -- Payback V
  db:priv_AddDB("Runes", 520266); -- Payback VI
  db:priv_AddDB("Runes", 520267); -- Payback VII
  db:priv_AddDB("Runes", 520268); -- Payback VIII
  db:priv_AddDB("Runes", 520269); -- Payback IX
  db:priv_AddDB("Runes", 520270); -- Payback X
  
  -- Potential
  db:priv_AddDB("Runes", 520661); -- Potential I
  db:priv_AddDB("Runes", 520662); -- Potential II
  db:priv_AddDB("Runes", 520663); -- Potential III
  db:priv_AddDB("Runes", 520664); -- Potential IV
  db:priv_AddDB("Runes", 520665); -- Potential V
  db:priv_AddDB("Runes", 520666); -- Potential VI
  db:priv_AddDB("Runes", 520667); -- Potential VII
  db:priv_AddDB("Runes", 520668); -- Potential VIII
  db:priv_AddDB("Runes", 520669); -- Potential IX
  db:priv_AddDB("Runes", 520670); -- Potential X
  
  -- Power
  db:priv_AddDB("Runes", 520021); -- Power I
  db:priv_AddDB("Runes", 520022); -- Power II
  db:priv_AddDB("Runes", 520023); -- Power III
  db:priv_AddDB("Runes", 520024); -- Power IV
  db:priv_AddDB("Runes", 520025); -- Power V
  db:priv_AddDB("Runes", 520026); -- Power VI
  db:priv_AddDB("Runes", 520027); -- Power VII
  db:priv_AddDB("Runes", 520028); -- Power VIII
  db:priv_AddDB("Runes", 520029); -- Power IX
  db:priv_AddDB("Runes", 520030); -- Power X
  
  -- Quickness
  db:priv_AddDB("Runes", 520101); -- Quickness I
  db:priv_AddDB("Runes", 520102); -- Quickness II
  db:priv_AddDB("Runes", 520103); -- Quickness III
  db:priv_AddDB("Runes", 520104); -- Quickness IV
  db:priv_AddDB("Runes", 520105); -- Quickness V
  db:priv_AddDB("Runes", 520106); -- Quickness VI
  db:priv_AddDB("Runes", 520107); -- Quickness VII
  db:priv_AddDB("Runes", 520108); -- Quickness VIII
  db:priv_AddDB("Runes", 520109); -- Quickness IX
  db:priv_AddDB("Runes", 520110); -- Quickness X
  
  -- Raid
  db:priv_AddDB("Runes", 521291); -- Raid I
  db:priv_AddDB("Runes", 521292); -- Raid II
  db:priv_AddDB("Runes", 521293); -- Raid III
  db:priv_AddDB("Runes", 521294); -- Raid IV
  db:priv_AddDB("Runes", 521295); -- Raid V
  db:priv_AddDB("Runes", 521296); -- Raid VI
  db:priv_AddDB("Runes", 521297); -- Raid VII
  db:priv_AddDB("Runes", 521298); -- Raid VIII
  db:priv_AddDB("Runes", 521299); -- Raid IX
  db:priv_AddDB("Runes", 521300); -- Raid X
 
  -- Reconciliation
  db:priv_AddDB("Runes", 520701); -- Reconciliation I
  db:priv_AddDB("Runes", 520702); -- Reconciliation II
  db:priv_AddDB("Runes", 520703); -- Reconciliation III
  db:priv_AddDB("Runes", 520704); -- Reconciliation IV
  db:priv_AddDB("Runes", 520705); -- Reconciliation V
  db:priv_AddDB("Runes", 520706); -- Reconciliation VI
  db:priv_AddDB("Runes", 520707); -- Reconciliation VII
  db:priv_AddDB("Runes", 520708); -- Reconciliation VIII
  db:priv_AddDB("Runes", 520709); -- Reconciliation IX
  db:priv_AddDB("Runes", 520710); -- Reconciliation X
  
  -- Resistance
  db:priv_AddDB("Runes", 520041); -- Resistance I
  db:priv_AddDB("Runes", 520042); -- Resistance II
  db:priv_AddDB("Runes", 520043); -- Resistance III
  db:priv_AddDB("Runes", 520044); -- Resistance IV
  db:priv_AddDB("Runes", 520045); -- Resistance V
  db:priv_AddDB("Runes", 520046); -- Resistance VI
  db:priv_AddDB("Runes", 520047); -- Resistance VII
  db:priv_AddDB("Runes", 520048); -- Resistance VIII
  db:priv_AddDB("Runes", 520049); -- Resistance IX
  db:priv_AddDB("Runes", 520050); -- Resistance X
  
  -- Resistor
  db:priv_AddDB("Runes", 520401); -- Resistor I
  db:priv_AddDB("Runes", 520402); -- Resistor II
  db:priv_AddDB("Runes", 520403); -- Resistor III
  db:priv_AddDB("Runes", 520404); -- Resistor IV
  db:priv_AddDB("Runes", 520405); -- Resistor V
  db:priv_AddDB("Runes", 520406); -- Resistor VI
  db:priv_AddDB("Runes", 520407); -- Resistor VII
  db:priv_AddDB("Runes", 520408); -- Resistor VIII
  db:priv_AddDB("Runes", 520409); -- Resistor IX
  db:priv_AddDB("Runes", 520410); -- Resistor X
  
  -- Revolution
  db:priv_AddDB("Runes", 520601); -- Revolution I
  db:priv_AddDB("Runes", 520602); -- Revolution II
  db:priv_AddDB("Runes", 520603); -- Revolution III
  db:priv_AddDB("Runes", 520604); -- Revolution IV
  db:priv_AddDB("Runes", 520605); -- Revolution V
  db:priv_AddDB("Runes", 520606); -- Revolution VI
  db:priv_AddDB("Runes", 520607); -- Revolution VII
  db:priv_AddDB("Runes", 520608); -- Revolution VIII
  db:priv_AddDB("Runes", 520609); -- Revolution IX
  db:priv_AddDB("Runes", 520610); -- Revolution X
  
  -- Rouse
  db:priv_AddDB("Runes", 520321); -- Rouse I
  db:priv_AddDB("Runes", 520322); -- Rouse II
  db:priv_AddDB("Runes", 520323); -- Rouse III
  db:priv_AddDB("Runes", 520324); -- Rouse IV
  db:priv_AddDB("Runes", 520325); -- Rouse V
  db:priv_AddDB("Runes", 520326); -- Rouse VI
  db:priv_AddDB("Runes", 520327); -- Rouse VII
  db:priv_AddDB("Runes", 520328); -- Rouse VIII
  db:priv_AddDB("Runes", 520329); -- Rouse IX
  db:priv_AddDB("Runes", 520330); -- Rouse X
  
  -- Safeguard
  db:priv_AddDB("Runes", 521051); -- Safeguard I
  db:priv_AddDB("Runes", 521052); -- Safeguard II
  db:priv_AddDB("Runes", 521053); -- Safeguard III
  db:priv_AddDB("Runes", 521054); -- Safeguard IV
  db:priv_AddDB("Runes", 521055); -- Safeguard V
  db:priv_AddDB("Runes", 521056); -- Safeguard VI
  db:priv_AddDB("Runes", 521057); -- Safeguard VII
  db:priv_AddDB("Runes", 521058); -- Safeguard VIII
  db:priv_AddDB("Runes", 521059); -- Safeguard IX
  db:priv_AddDB("Runes", 521060); -- Safeguard X
 
  -- Savage
  db:priv_AddDB("Runes", 520871); -- Savage I
  db:priv_AddDB("Runes", 520872); -- Savage II
  db:priv_AddDB("Runes", 520873); -- Savage III
  db:priv_AddDB("Runes", 520874); -- Savage IV
  db:priv_AddDB("Runes", 520875); -- Savage V
  db:priv_AddDB("Runes", 520876); -- Savage VI
  db:priv_AddDB("Runes", 520877); -- Savage VII
  db:priv_AddDB("Runes", 520878); -- Savage VIII
  db:priv_AddDB("Runes", 520879); -- Savage IX
  db:priv_AddDB("Runes", 520880); -- Savage X
 
  -- Shell
  db:priv_AddDB("Runes", 520221); -- Shell I
  db:priv_AddDB("Runes", 520222); -- Shell II
  db:priv_AddDB("Runes", 520223); -- Shell III
  db:priv_AddDB("Runes", 520224); -- Shell IV
  db:priv_AddDB("Runes", 520225); -- Shell V
  db:priv_AddDB("Runes", 520226); -- Shell VI
  db:priv_AddDB("Runes", 520227); -- Shell VII
  db:priv_AddDB("Runes", 520228); -- Shell VIII
  db:priv_AddDB("Runes", 520229); -- Shell IX
  db:priv_AddDB("Runes", 520230); -- Shell X
  
  -- Shield
  db:priv_AddDB("Runes", 520641); -- Shield I
  db:priv_AddDB("Runes", 520642); -- Shield II
  db:priv_AddDB("Runes", 520643); -- Shield III
  db:priv_AddDB("Runes", 520644); -- Shield IV
  db:priv_AddDB("Runes", 520645); -- Shield V
  db:priv_AddDB("Runes", 520646); -- Shield VI
  db:priv_AddDB("Runes", 520647); -- Shield VII
  db:priv_AddDB("Runes", 520648); -- Shield VIII
  db:priv_AddDB("Runes", 520649); -- Shield IX
  db:priv_AddDB("Runes", 520650); -- Shield X
  
  -- Sorcery
  db:priv_AddDB("Runes", 520541); -- Sorcery I
  db:priv_AddDB("Runes", 520542); -- Sorcery II
  db:priv_AddDB("Runes", 520543); -- Sorcery III
  db:priv_AddDB("Runes", 520544); -- Sorcery IV
  db:priv_AddDB("Runes", 520545); -- Sorcery V
  db:priv_AddDB("Runes", 520546); -- Sorcery VI
  db:priv_AddDB("Runes", 520547); -- Sorcery VII
  db:priv_AddDB("Runes", 520548); -- Sorcery VIII
  db:priv_AddDB("Runes", 520549); -- Sorcery IX
  db:priv_AddDB("Runes", 520550); -- Sorcery X
  
  -- Spell
  db:priv_AddDB("Runes", 520991); -- Spell I
  db:priv_AddDB("Runes", 520992); -- Spell II
  db:priv_AddDB("Runes", 520993); -- Spell III
  db:priv_AddDB("Runes", 520994); -- Spell IV
  db:priv_AddDB("Runes", 520995); -- Spell V
  db:priv_AddDB("Runes", 520996); -- Spell VI
  db:priv_AddDB("Runes", 520997); -- Spell VII
  db:priv_AddDB("Runes", 520998); -- Spell VIII
  db:priv_AddDB("Runes", 520999); -- Spell IX
  db:priv_AddDB("Runes", 521000); -- Spell X
 
  -- Spirit
  db:priv_AddDB("Runes", 520931); -- Spirit I
  db:priv_AddDB("Runes", 520932); -- Spirit II
  db:priv_AddDB("Runes", 520933); -- Spirit III
  db:priv_AddDB("Runes", 520934); -- Spirit IV
  db:priv_AddDB("Runes", 520935); -- Spirit V
  db:priv_AddDB("Runes", 520936); -- Spirit VI
  db:priv_AddDB("Runes", 520937); -- Spirit VII
  db:priv_AddDB("Runes", 520938); -- Spirit VIII
  db:priv_AddDB("Runes", 520939); -- Spirit IX
  db:priv_AddDB("Runes", 520940); -- Spirit X
 
  -- Stamina
  db:priv_AddDB("Runes", 520891); -- Stamina I
  db:priv_AddDB("Runes", 520892); -- Stamina II
  db:priv_AddDB("Runes", 520893); -- Stamina III
  db:priv_AddDB("Runes", 520894); -- Stamina IV
  db:priv_AddDB("Runes", 520895); -- Stamina V
  db:priv_AddDB("Runes", 520896); -- Stamina VI
  db:priv_AddDB("Runes", 520897); -- Stamina VII
  db:priv_AddDB("Runes", 520898); -- Stamina VIII
  db:priv_AddDB("Runes", 520899); -- Stamina IX
  db:priv_AddDB("Runes", 520900); -- Stamina X
 
  -- Strike
  db:priv_AddDB("Runes", 520181); -- Strike I
  db:priv_AddDB("Runes", 520182); -- Strike II
  db:priv_AddDB("Runes", 520183); -- Strike III
  db:priv_AddDB("Runes", 520184); -- Strike IV
  db:priv_AddDB("Runes", 520185); -- Strike V
  db:priv_AddDB("Runes", 520186); -- Strike VI
  db:priv_AddDB("Runes", 520187); -- Strike VII
  db:priv_AddDB("Runes", 520188); -- Strike VIII
  db:priv_AddDB("Runes", 520189); -- Strike IX
  db:priv_AddDB("Runes", 520190); -- Strike X
  
  -- Triumph
  db:priv_AddDB("Runes", 520341); -- Triumph I
  db:priv_AddDB("Runes", 520342); -- Triumph II
  db:priv_AddDB("Runes", 520343); -- Triumph III
  db:priv_AddDB("Runes", 520344); -- Triumph IV
  db:priv_AddDB("Runes", 520345); -- Triumph V
  db:priv_AddDB("Runes", 520346); -- Triumph VI
  db:priv_AddDB("Runes", 520347); -- Triumph VII
  db:priv_AddDB("Runes", 520348); -- Triumph VIII
  db:priv_AddDB("Runes", 520349); -- Triumph IX
  db:priv_AddDB("Runes", 520350); -- Triumph X
  
  -- Vigor
  db:priv_AddDB("Runes", 520021); -- Vigor I
  db:priv_AddDB("Runes", 520022); -- Vigor II
  db:priv_AddDB("Runes", 520023); -- Vigor III
  db:priv_AddDB("Runes", 520024); -- Vigor IV
  db:priv_AddDB("Runes", 520025); -- Vigor V
  db:priv_AddDB("Runes", 520026); -- Vigor VI
  db:priv_AddDB("Runes", 520027); -- Vigor VII
  db:priv_AddDB("Runes", 520028); -- Vigor VIII
  db:priv_AddDB("Runes", 520029); -- Vigor IX
  db:priv_AddDB("Runes", 520030); -- Vigor X
 
  -- Vitality
  db:priv_AddDB("Runes", 520081); -- Vitality I
  db:priv_AddDB("Runes", 520082); -- Vitality II
  db:priv_AddDB("Runes", 520083); -- Vitality III
  db:priv_AddDB("Runes", 520084); -- Vitality IV
  db:priv_AddDB("Runes", 520085); -- Vitality V
  db:priv_AddDB("Runes", 520086); -- Vitality VI
  db:priv_AddDB("Runes", 520087); -- Vitality VII
  db:priv_AddDB("Runes", 520088); -- Vitality VIII
  db:priv_AddDB("Runes", 520089); -- Vitality IX
  db:priv_AddDB("Runes", 520090); -- Vitality X
  
  -- Wall
  db:priv_AddDB("Runes", 520621); -- Wall I
  db:priv_AddDB("Runes", 520622); -- Wall II
  db:priv_AddDB("Runes", 520623); -- Wall III
  db:priv_AddDB("Runes", 520624); -- Wall IV
  db:priv_AddDB("Runes", 520625); -- Wall V
  db:priv_AddDB("Runes", 520626); -- Wall VI
  db:priv_AddDB("Runes", 520627); -- Wall VII
  db:priv_AddDB("Runes", 520628); -- Wall VIII
  db:priv_AddDB("Runes", 520629); -- Wall IX
  db:priv_AddDB("Runes", 520630); -- Wall X
  
  -- Ward
  db:priv_AddDB("Runes", 521071); -- Ward I
  db:priv_AddDB("Runes", 521072); -- Ward II
  db:priv_AddDB("Runes", 521073); -- Ward III
  db:priv_AddDB("Runes", 521074); -- Ward IV
  db:priv_AddDB("Runes", 521075); -- Ward V
  db:priv_AddDB("Runes", 521076); -- Ward VI
  db:priv_AddDB("Runes", 521077); -- Ward VII
  db:priv_AddDB("Runes", 521078); -- Ward VIII
  db:priv_AddDB("Runes", 521079); -- Ward IX
  db:priv_AddDB("Runes", 521080); -- Ward X
 
  -- Wrath
  db:priv_AddDB("Runes", 520801); -- Wrath I
  db:priv_AddDB("Runes", 520802); -- Wrath II
  db:priv_AddDB("Runes", 520803); -- Wrath III
  db:priv_AddDB("Runes", 520804); -- Wrath IV
  db:priv_AddDB("Runes", 520805); -- Wrath V
  db:priv_AddDB("Runes", 520806); -- Wrath VI
  db:priv_AddDB("Runes", 520807); -- Wrath VII
  db:priv_AddDB("Runes", 520808); -- Wrath VIII
  db:priv_AddDB("Runes", 520809); -- Wrath IX
  db:priv_AddDB("Runes", 520810); -- Wrath X
end;

local function priv_AddFusionStones(db)
  -- Purple
  db:priv_AddDB("FusionStones", 202881); -- Purified Fusion Stone
  -- Fusion Stone
  db:priv_AddDB("FusionStones", 202882); -- Fusion Stone
  db:priv_AddDB("FusionStones", 202883); -- Fusion Stone
  db:priv_AddDB("FusionStones", 202885); -- Fusion Stone
  db:priv_AddDB("FusionStones", 202995); -- Fusion Stone
  db:priv_AddDB("FusionStones", 202996); -- Fusion Stone
  db:priv_AddDB("FusionStones", 202997); -- Fusion Stone
  db:priv_AddDB("FusionStones", 202998); -- Fusion Stone
  db:priv_AddDB("FusionStones", 203000); -- Fusion Stone
  db:priv_AddDB("FusionStones", 203001); -- Fusion Stone
  db:priv_AddDB("FusionStones", 203002); -- Fusion Stone
  db:priv_AddDB("FusionStones", 203003); -- Fusion Stone
  db:priv_AddDB("FusionStones", 203004); -- Fusion Stone
  db:priv_AddDB("FusionStones", 202880); -- Fusion Stone
  db:priv_AddDB("FusionStones", 202999); -- Random Fusion Stone
  -- Mana Stone
  db:priv_AddDB("FusionStones", 202840); -- Mana Stone Tier 1
  db:priv_AddDB("FusionStones", 202841); -- Mana Stone Tier 2
  db:priv_AddDB("FusionStones", 202842); -- Mana Stone Tier 3
  db:priv_AddDB("FusionStones", 202843); -- Mana Stone Tier 4
  db:priv_AddDB("FusionStones", 202844); -- Mana Stone Tier 5
  db:priv_AddDB("FusionStones", 202845); -- Mana Stone Tier 6
  db:priv_AddDB("FusionStones", 202846); -- Mana Stone Tier 7
  db:priv_AddDB("FusionStones", 202847); -- Mana Stone Tier 8
  db:priv_AddDB("FusionStones", 202848); -- Mana Stone Tier 9
  db:priv_AddDB("FusionStones", 202849); -- Mana Stone Tier 10
  db:priv_AddDB("FusionStones", 202850); -- Mana Stone Tier 11
  db:priv_AddDB("FusionStones", 202851); -- Mana Stone Tier 12
  db:priv_AddDB("FusionStones", 202852); -- Mana Stone Tier 13
  db:priv_AddDB("FusionStones", 202853); -- Mana Stone Tier 14
  db:priv_AddDB("FusionStones", 202854); -- Mana Stone Tier 15
  db:priv_AddDB("FusionStones", 202855); -- Mana Stone Tier 16
  db:priv_AddDB("FusionStones", 202856); -- Mana Stone Tier 17
  db:priv_AddDB("FusionStones", 202857); -- Mana Stone Tier 18
  db:priv_AddDB("FusionStones", 202858); -- Mana Stone Tier 19
  db:priv_AddDB("FusionStones", 202859); -- Mana Stone Tier 20
end;

local function priv_AddJuwels(db)
  db:priv_AddDB("Juwels", 550000);
end;

local function priv_AddGuildContribution(db) -- 5.0.0.2545
  db:priv_AddDB("Guild", 202916); -- Guild Rune
  db:priv_AddDB("Guild", 202917); -- Guild Stone
  db:priv_AddDB("Guild", 203450); -- Ruby Stone
  db:priv_AddDB("Guild", 206695); -- Ore Essence
  db:priv_AddDB("Guild", 206696); -- Wood Essence
  db:priv_AddDB("Guild", 206697); -- Herb Essence
  
  --Andor Materials-- credit Ultak
  db:priv_AddDB("Guild", 207326); -- Nightmare Essence - 100 Guild Runes
  db:priv_AddDB("Guild", 207330); -- Wisdom Core - 100 Guild Stones
  db:priv_AddDB("Guild", 207930); -- Teardrop Ruby - 100 Guild Rubies
  db:priv_AddDB("Guild", 206592); -- Moonlight Pearl - 100 Guild Ore
  db:priv_AddDB("Guild", 206591); -- Sunset Ear of Grain - 100 Guild Wood
  db:priv_AddDB("Guild", 206590); -- Magic Fortune Grass - 100 Guild Herb
end;

local function priv_AddBagStats(db) -- 6.4.1.2752  -- credit Ultak

  db:priv_AddDB("BagStat", 222061); -- Tasuqian Necklace - 98
  db:priv_AddDB("BagStat", 222062); -- Tasuqian Ring - 98
  db:priv_AddDB("BagStat", 222063); -- Tasuqian Earring - 98
  
  -- db:priv_AddDB("BagStat", ??????); -- ???????????????? - 97
  
  -- db:priv_AddDB("BagStat", ??????); -- ???????????????? - 95

  db:priv_AddDB("BagStat", 233989); -- Splitwater Earring - 92
  db:priv_AddDB("BagStat", 233988); -- Splitwater Ring - 92
  db:priv_AddDB("BagStat", 233987); -- Splitwater Necklace - 92

  db:priv_AddDB("BagStat", 233685); -- Ash Earring - 92
  db:priv_AddDB("BagStat", 233684); -- Ash Ring - 92
  db:priv_AddDB("BagStat", 233683); -- Ash Necklace - 92
  
  db:priv_AddDB("BagStat", 233243); -- Earring of the Basin - 90
  db:priv_AddDB("BagStat", 233242); -- Ring of the Basin - 90
  db:priv_AddDB("BagStat", 233241); -- Necklace of the Basin - 90
  
  db:priv_AddDB("BagStat", 232755); -- Jungle Earring - 87
  db:priv_AddDB("BagStat", 232754); -- Jungle Ring - 87
  db:priv_AddDB("BagStat", 232753); -- Jungle Necklace - 87
  
  db:priv_AddDB("BagStat", 228879); -- Fjord Earring - 85
  db:priv_AddDB("BagStat", 228750); -- Fjord Ring - 85
  db:priv_AddDB("BagStat", 224991); -- Fjord Necklace - 85
  
  db:priv_AddDB("BagStat", 231926); -- Kingdom Earring - 82
  db:priv_AddDB("BagStat", 231925); -- Kingdom Ring - 82
  db:priv_AddDB("BagStat", 231924); -- Kingdom Necklace - 82
  
  db:priv_AddDB("BagStat", 231923); -- Water Fire Earring - 80
  db:priv_AddDB("BagStat", 231922); -- Water Fire Ring - 80
  db:priv_AddDB("BagStat", 231921); -- Water Fire Necklace - 80
  
  --db:priv_AddDB("BagStat", ); --  - 77
  --db:priv_AddDB("BagStat", ); --  - 77
  --db:priv_AddDB("BagStat", ); --  - 77
  
  db:priv_AddDB("BagStat", 229699); -- Balanced Earring - 75
  db:priv_AddDB("BagStat", 229700); -- Balanced Ring - 75
  db:priv_AddDB("BagStat", 229698); -- Balanced Necklace - 75
  
end;

local function priv_AddRunePetEggs(db) -- 6.4.1.2758
  db:priv_AddDB("RunePetEgg", 204506); --Blue Rune Egg 6.4.1.2758
  db:priv_AddDB("RunePetEgg", 204507); --Purple Rune Egg 6.4.1.2758
  db:priv_AddDB("RunePetEgg", 204508); --orange Rune Egg 6.4.1.2758
  db:priv_AddDB("RunePetEgg", 204509); --white Rune Egg 6.4.1.2758
end;
local function priv_AddEarthPetEggs(db) -- 6.4.1.2758
  db:priv_AddDB("EarthPetEgg", 204476); --white 6.4.1.2758
  db:priv_AddDB("EarthPetEgg", 204482); --Green 6.4.1.2758
  db:priv_AddDB("EarthPetEgg", 204488); --Blue 6.4.1.2758
  db:priv_AddDB("EarthPetEgg", 204494); --Purple 6.4.1.2758
  db:priv_AddDB("EarthPetEgg", 204500); --orange 6.4.1.2758
end;
local function priv_AddWaterPetEggs(db) -- 6.4.1.2758
  db:priv_AddDB("WaterPetEgg", 204477); --white 6.4.1.2758
  db:priv_AddDB("WaterPetEgg", 204483); --Green 6.4.1.2758
  db:priv_AddDB("WaterPetEgg", 204489); --Blue 6.4.1.2758
  db:priv_AddDB("WaterPetEgg", 204495); --Purple 6.4.1.2758
  db:priv_AddDB("WaterPetEgg", 204501); --orange 6.4.1.2758
end;
local function priv_AddFirePetEggs(db) -- 6.4.1.2758
  db:priv_AddDB("FirePetEgg", 204478); --white 6.4.1.2758
  db:priv_AddDB("FirePetEgg", 204484); --Green 6.4.1.2758
  db:priv_AddDB("FirePetEgg", 204490); --Blue 6.4.1.2758
  db:priv_AddDB("FirePetEgg", 204496); --Purple 6.4.1.2758
  db:priv_AddDB("FirePetEgg", 204502); --orange 6.4.1.2758
end;
local function priv_AddWindPetEggs(db) -- 6.4.1.2758
  db:priv_AddDB("WindPetEgg", 204479); --white 6.4.1.2758
  db:priv_AddDB("WindPetEgg", 204485); --Green 6.4.1.2758
  db:priv_AddDB("WindPetEgg", 204491); --Blue 6.4.1.2758
  db:priv_AddDB("WindPetEgg", 204497); --Purple 6.4.1.2758
  db:priv_AddDB("WindPetEgg", 204503); --orange 6.4.1.2758
end;
local function priv_AddLightPetEggs(db) -- 6.4.1.2758
  db:priv_AddDB("lightPetEgg", 204480); --white 6.4.1.2758
  db:priv_AddDB("lightPetEgg", 204486); --green 6.4.1.2758
  db:priv_AddDB("lightPetEgg", 204492); --Blue 6.4.1.2758
  db:priv_AddDB("lightPetEgg", 204498); --Purple 6.4.1.2758
  db:priv_AddDB("lightPetEgg", 204504); --orange 6.4.1.2758
end;
local function priv_AddDarkPetEggs(db) -- 6.4.1.2758
  db:priv_AddDB("DarkPetEgg", 204481); --white 6.4.1.2758
  db:priv_AddDB("DarkPetEgg", 204487); --Green 6.4.1.2758
  db:priv_AddDB("DarkPetEgg", 204493); --Blue 6.4.1.2758
  db:priv_AddDB("DarkPetEgg", 204499); --Purple 6.4.1.2758
  db:priv_AddDB("DarkPetEgg", 204505); --orange 6.4.1.2758
end;
-- Cenedril --
local function priv_DynamicCenedril(db) -- 6.4.1.2758
  db:priv_AddDB("DynamicCenedril", 209873); -- white mirror fragment
  db:priv_AddDB("DynamicCenedril", 209876); -- white cenedril image piece
  db:priv_AddDB("DynamicCenedril", 209879); -- white mirror ink
  db:priv_AddDB("DynamicCenedril", 209882); -- white immage restoration scroll
  db:priv_AddDB("DynamicCenedril", 209885); -- Green mirror fragment
  db:priv_AddDB("DynamicCenedril", 209888); -- Green cenedril image piece
  db:priv_AddDB("DynamicCenedril", 209891); -- Green mirror ink
  db:priv_AddDB("DynamicCenedril", 209894); -- Green immage restoration scroll
  db:priv_AddDB("DynamicCenedril", 209897); -- Blue mirror fragment
  db:priv_AddDB("DynamicCenedril", 209900); -- Blue cenedril image piece
  db:priv_AddDB("DynamicCenedril", 209903); -- Blue mirror ink
  db:priv_AddDB("DynamicCenedril", 209906); -- Blue immage restoration scroll
  db:priv_AddDB("DynamicCenedril", 209909); -- Purple mirror fragment
  db:priv_AddDB("DynamicCenedril", 209912); -- Purple cenedril image piece
  db:priv_AddDB("DynamicCenedril", 209915); -- Purple mirror ink
  db:priv_AddDB("DynamicCenedril", 209918); -- Purple immage restoration scroll
  db:priv_AddDB("DynamicCenedril", 209921); -- Orange mirror fragment
  db:priv_AddDB("DynamicCenedril", 209924); -- Orange cenedril image piece
  db:priv_AddDB("DynamicCenedril", 209927); -- Orange mirror ink
  db:priv_AddDB("DynamicCenedril", 209930); -- Orange immage restoration scroll
  db:priv_AddDB("DynamicCenedril", 209933); -- Brown mirror fragment
  db:priv_AddDB("DynamicCenedril", 209936); -- Brown cenedril image piece
  db:priv_AddDB("DynamicCenedril", 209939); -- Brown mirror ink
  db:priv_AddDB("DynamicCenedril", 209942); -- Brown immage restoration scroll
end;
local function priv_SteadfastCenedril(db) -- 6.4.1.2758
  db:priv_AddDB("SteadfastCenedril", 209874); -- white mirror fragment
  db:priv_AddDB("SteadfastCenedril", 209877); -- white cenedril image piece
  db:priv_AddDB("SteadfastCenedril", 209880); -- white mirror ink
  db:priv_AddDB("SteadfastCenedril", 209883); -- white immage restoration scroll
  db:priv_AddDB("SteadfastCenedril", 209886); -- Green mirror fragment
  db:priv_AddDB("SteadfastCenedril", 209889); -- Green cenedril image piece
  db:priv_AddDB("SteadfastCenedril", 209892); -- Green mirror ink
  db:priv_AddDB("SteadfastCenedril", 209895); -- Green immage restoration scroll
  db:priv_AddDB("SteadfastCenedril", 209898); -- Blue mirror fragment
  db:priv_AddDB("SteadfastCenedril", 209901); -- Blue cenedril image piece
  db:priv_AddDB("SteadfastCenedril", 209904); -- Blue mirror ink
  db:priv_AddDB("SteadfastCenedril", 209907); -- Blue immage restoration scroll
  db:priv_AddDB("SteadfastCenedril", 209910); -- Purple mirror fragment
  db:priv_AddDB("SteadfastCenedril", 209913); -- Purple cenedril image piece
  db:priv_AddDB("SteadfastCenedril", 209916); -- Purple mirror ink
  db:priv_AddDB("SteadfastCenedril", 209919); -- Purple immage restoration scroll
  db:priv_AddDB("SteadfastCenedril", 209922); -- Orange mirror fragment
  db:priv_AddDB("SteadfastCenedril", 209925); -- Orange cenedril image piece
  db:priv_AddDB("SteadfastCenedril", 209928); -- Orange mirror ink
  db:priv_AddDB("SteadfastCenedril", 209931); -- Orange immage restoration scroll
  db:priv_AddDB("SteadfastCenedril", 209934); -- Brown mirror fragment
  db:priv_AddDB("SteadfastCenedril", 209937); -- Brown cenedril image piece
  db:priv_AddDB("SteadfastCenedril", 209940); -- Brown mirror ink
  db:priv_AddDB("SteadfastCenedril", 209943); -- Brown immage restoration scroll
end;
local function priv_MysticalCenedril(db) -- 6.4.1.2758
  db:priv_AddDB("MysticalCenedril", 209875); -- white mirror fragment
  db:priv_AddDB("MysticalCenedril", 209878); -- white cenedril image piece
  db:priv_AddDB("MysticalCenedril", 209881); -- white mirror ink
  db:priv_AddDB("MysticalCenedril", 209884); -- white immage restoration scroll
  db:priv_AddDB("MysticalCenedril", 209887); -- Green mirror fragment
  db:priv_AddDB("MysticalCenedril", 209890); -- Green cenedril image piece
  db:priv_AddDB("MysticalCenedril", 209893); -- Green mirror ink
  db:priv_AddDB("MysticalCenedril", 209896); -- Green immage restoration scroll
  db:priv_AddDB("MysticalCenedril", 209899); -- Blue mirror fragment
  db:priv_AddDB("MysticalCenedril", 209902); -- Blue cenedril image piece
  db:priv_AddDB("MysticalCenedril", 209905); -- Blue mirror ink
  db:priv_AddDB("MysticalCenedril", 209908); -- Blue immage restoration scroll
  db:priv_AddDB("MysticalCenedril", 209911); -- Purple mirror fragment
  db:priv_AddDB("MysticalCenedril", 209914); -- Purple cenedril image piece
  db:priv_AddDB("MysticalCenedril", 209917); -- Purple mirror ink
  db:priv_AddDB("MysticalCenedril", 209920); -- Purple immage restoration scroll
  db:priv_AddDB("MysticalCenedril", 209923); -- Orange mirror fragment
  db:priv_AddDB("MysticalCenedril", 209926); -- Orange cenedril image piece
  db:priv_AddDB("MysticalCenedril", 209929); -- Orange mirror ink
  db:priv_AddDB("MysticalCenedril", 209932); -- Orange immage restoration scroll
  db:priv_AddDB("MysticalCenedril", 209935); -- Brown mirror fragment
  db:priv_AddDB("MysticalCenedril", 209938); -- Brown cenedril image piece
  db:priv_AddDB("MysticalCenedril", 209941); -- Brown mirror ink
  db:priv_AddDB("MysticalCenedril", 209944); -- Brown immage restoration scroll
end;


UMMItemDB = ResourceItemFilter;
UMMItemDB:Init();

-- Guild Contribution
priv_AddGuildContribution(UMMItemDB); -- 5.0.0.2545

-- Supplies
priv_AddFoods(UMMItemDB);
priv_AddDesserts(UMMItemDB);
priv_AddPotions(UMMItemDB);

-- Materials
priv_AddOres(UMMItemDB);
priv_AddWood(UMMItemDB);
priv_AddHerbs(UMMItemDB);
priv_AddRawMaterials(UMMItemDB);
priv_AddProductionRunes(UMMItemDB);

--Gear  credit Ultak
priv_AddBagStats(UMMItemDB); -- 6.4.1.2752 -- credit Ultak

-- Equipment Enchancements
priv_AddJuwels(UMMItemDB);
priv_AddRunes(UMMItemDB);
priv_AddFusionStones(UMMItemDB);

--pet eggs  -- 6.4.1.2758
priv_AddRunePetEggs(UMMItemDB);-- 6.4.1.2758
priv_AddEarthPetEggs(UMMItemDB);-- 6.4.1.2758
priv_AddWaterPetEggs(UMMItemDB);-- 6.4.1.2758
priv_AddFirePetEggs(UMMItemDB);-- 6.4.1.2758
priv_AddWindPetEggs(UMMItemDB);-- 6.4.1.2758
priv_AddLightPetEggs(UMMItemDB);-- 6.4.1.2758
priv_AddDarkPetEggs(UMMItemDB);-- 6.4.1.2758

-- Cenedril
priv_DynamicCenedril(UMMItemDB);
priv_SteadfastCenedril(UMMItemDB);
priv_MysticalCenedril(UMMItemDB);