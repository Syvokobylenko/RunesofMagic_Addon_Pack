--[[ ä

	Name: Advanced Questbook
	By: Crypton

]]
if (AdvQuestBookByName == nil or AdvQuestBookText == nil) then
	local i;
	local text;
	AdvQuestBookByName = {};
	AdvQuestBookText = {};
	for i = 420034, 425516 do
		text = TEXT("Sys"..i.."_name");
		if (text ~= nil and text ~= "") then
			AdvQuestBookByName[text] = i;
			AdvQuestBookText[i] = {
				["name"] = TEXT("Sys"..i.."_name"),
				["det"] = TEXT("Sys"..i.."_szquest_desc"),
				["desc"] = TEXT("Sys"..i.."_szquest_accept_detail"),
			};
		end
	end
end
