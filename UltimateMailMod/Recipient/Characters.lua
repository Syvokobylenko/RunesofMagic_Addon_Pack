--[[

#######################################################################
##                                                                   ##
##  This file is for creating a hardwired list of own characters.    ##
##  When displaying own characters in the Composer or in Mass        ##
##  Send Items this list will be used and the order of names         ##
##  written in this file will be respected. Any names auto-gathered  ##
##  will be added to the end of the list but will still be sorted.   ##
##                                                                   ##
#######################################################################

special characters: [àèìòùáéíóúâêîôûãëïõüäñöæøçÄÖÜß]
   à : \195\160    è : \195\168    ì : \195\172    ò : \195\178    ù : \195\185
   á : \195\161    é : \195\169    í : \195\173    ó : \195\179    ú : \195\186
   â : \195\162    ê : \195\170    î : \195\174    ô : \195\180    û : \195\187
   ã : \195\163    ë : \195\171    ï : \195\175    õ : \195\181    ü : \195\188
   ä : \195\164                    ñ : \195\177    ö : \195\182
   æ : \195\166                                    ø : \195\184
   ç : \195\167
   
   Ä : \195\132
   Ö : \195\150
   Ü : \195\156
   ß : \195\159
   
Sample of how the list MUST be created:
	UMM_OwnCharacters = {
	[1] = "CharFive",
	[2] = "CharOne",
	[3] = "CharThree",
	[4] = "CharFour",
	[5] = "CharTwo",
	};

--]]

UMM_OwnCharacters = {
[1] = "",
[2] = "",
[3] = "",
[4] = "",
[5] = "",
};

--[[
#######################################################################
##                                                                   ##
##  Below items are connected to the 16 mark buttons.    			 ##
##  Each item might contain a characters name, where the marked      ##
##  items have to be send to (Receipients Name).                     ##
##                                                                   ##
##  WARNING                                                          ##
##  *******                                                          ##
##  Be carefull when using this function and review the receipient   ##
##  any time befor pressing the send button.                         ##
##                                                                   ##
#######################################################################
--]]

UMM_MSI_RECIPE_SEND_TO1		        = ""; 		-- Runes
UMM_MSI_RECIPE_SEND_TO2		        = ""; 		-- Fusion Stones
UMM_MSI_RECIPE_SEND_TO3             = ""; 		-- Juwels
UMM_MSI_RECIPE_SEND_TO4		        = ""; 		-- Ore
UMM_MSI_RECIPE_SEND_TO5		        = ""; 		-- Wood
UMM_MSI_RECIPE_SEND_TO6             = ""; 		-- Herbs
UMM_MSI_RECIPE_SEND_TO7		        = ""; 		-- Raw Materials
UMM_MSI_RECIPE_SEND_TO8		        = ""; 		-- Production Runes
UMM_MSI_RECIPE_SEND_TO9             = ""; 		-- Food
UMM_MSI_RECIPE_SEND_TO10		    = ""; 		-- Desserts
UMM_MSI_RECIPE_SEND_TO11		    = ""; 		-- Potions
UMM_MSI_RECIPE_SEND_TO12            = ""; 		-- White Recipes
UMM_MSI_RECIPE_SEND_TO13	        = ""; 		-- Green Recipes
UMM_MSI_RECIPE_SEND_TO14	        = ""; 		-- Blue Recipes
UMM_MSI_RECIPE_SEND_TO15            = ""; 		-- Magenta Recipes
UMM_MSI_RECIPE_SEND_TO16            = ""; 		-- Guild Contribution
