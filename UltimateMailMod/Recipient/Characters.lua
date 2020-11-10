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

special characters: [������������������������������]
   � : \195\160    � : \195\168    � : \195\172    � : \195\178    � : \195\185
   � : \195\161    � : \195\169    � : \195\173    � : \195\179    � : \195\186
   � : \195\162    � : \195\170    � : \195\174    � : \195\180    � : \195\187
   � : \195\163    � : \195\171    � : \195\175    � : \195\181    � : \195\188
   � : \195\164                    � : \195\177    � : \195\182
   � : \195\166                                    � : \195\184
   � : \195\167
   
   � : \195\132
   � : \195\150
   � : \195\156
   � : \195\159
   
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
