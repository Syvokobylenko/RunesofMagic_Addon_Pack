local QuestState = _G.QuestState;
QuestState.flags={
["SpeakDougWells"]=TEXT("Sys423053_szquest_desc"):gsub("%[114647%]", TEXT("Sys114209_name"));
["SpeakFernWells"]=TEXT("Sys423053_szquest_desc"):gsub("%[114647%]", TEXT("Sys116473_name"));
["SpeakGaryWells"]=TEXT("Sys423053_szquest_desc"):gsub("%[114647%]", TEXT("Sys116475_name"));
["SpeakMikaWells"]=TEXT("Sys423053_szquest_desc"):gsub("%[114647%]", TEXT("Sys114207_name"));
["SpeakMiyaWells"]=TEXT("Sys423053_szquest_desc"):gsub("%[114647%]", TEXT("Sys116474_name"));
["SpeakPeggyWells"]=TEXT("Sys423053_szquest_desc"):gsub("%[114647%]", TEXT("Sys114208_name"));
[540811]=TEXT("C_CLASS1")..": "..TEXT("C_WARRIOR");
[540812]=TEXT("C_CLASS1")..": "..TEXT("C_RANGER");
[540813]=TEXT("C_CLASS1")..": "..TEXT("C_THIEF");
[540814]=TEXT("C_CLASS1")..": "..TEXT("C_MAGE");
[540815]=TEXT("C_CLASS1")..": "..TEXT("C_AUGUR");
[540816]=TEXT("C_CLASS1")..": "..TEXT("C_KNIGHT");
[540817]=TEXT("C_CLASS1")..": "..TEXT("C_WARDEN");
[540818]=TEXT("C_CLASS1")..": "..TEXT("C_DRUID");
[542723]=TEXT("Sys542705_name").." (1. "..TEXT("SC_Z16_OR").." 2. "..TEXT("CLASS")..")";
[542724]=TEXT("Sys542707_name").." (1. "..TEXT("SC_Z16_OR").." 2. "..TEXT("CLASS")..")";
[542725]=TEXT("Sys542706_name").." (1. "..TEXT("SC_Z16_OR").." 2. "..TEXT("CLASS")..")";
[542726]=TEXT("Sys542708_name").." (1. "..TEXT("SC_Z16_OR").." 2. "..TEXT("CLASS")..")";
[542727]=TEXT("Sys542694_name").." (1. "..TEXT("SC_Z16_OR").." 2. "..TEXT("CLASS")..")";
[542728]=TEXT("Sys542704_name").." (1. "..TEXT("SC_Z16_OR").." 2. "..TEXT("CLASS")..")";
[542729]=TEXT("Sys543614_name").." (1. "..TEXT("SC_Z16_OR").." 2. "..TEXT("CLASS")..")";
[542730]=TEXT("Sys543615_name").." (1. "..TEXT("SC_Z16_OR").." 2. "..TEXT("CLASS")..")";
[545158]="1. & 2. "..TEXT("CLASS").." "..TEXT("C_LEVEL").." 20";
[546241]=TEXT("LOGIN_RACE")..": "..TEXT("LOGIN_DWARF");
[547010]="2 "..TEXT("PARTY_BOARD_JOBS").." "..TEXT("C_LEVEL").." 60";

-- events are not well documented

[543898]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_01083")); -- Fairy Tale Eevent
[543899]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_01083")); -- Fairy Tale Eevent
[543900]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_01083")); -- Fairy Tale Event
[544812]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02697")); -- Flower Festival
[544813]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02697")); -- Flower Festival
[544814]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02697")); -- Flower Festival
[544815]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02697")); -- Flower Festival
[544818]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02697")); -- Flower Festival
[544858]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_00344")); -- Spring Rain Festival
[544868]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02697")); -- Flower Festival
[544869]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02697")); -- Flower Festival
[544870]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02633")); -- Craft Festival
[545250]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_01083")); -- Fairy Tale Event
[545443]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02633")); -- Craft Festival
[545444]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02633")); -- Craft Festival
[545445]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02633")); -- Craft Festival
[545446]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02633")); -- Craft Festival
[545447]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02633")); -- Craft Festival
[545448]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02633")); -- Craft Festival
[545449]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02633")); -- Craft Festival
[545524]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_01083")); -- Fairy Tale Event
[546219]=QuestState.lang["internalFlag"]:format(TEXT("Sys101719_name").."-"..TEXT("ID_STR_EXPERFRAME_GROUP1")); -- Frog Event

[547183]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
[547184]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
[547185]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
[547232]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
[547231]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
[547168]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
[547228]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
[547226]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
[547191]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
[547197]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
[547283]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
[547284]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
[547278]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
[547202]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
[547344]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
[547287]=QuestState.lang["internalFlag"]:format(TEXT("_glossary_02794")); -- Snowlands Event
};

for i = 547606, 547613 do
	QuestState.flags[i] = QuestState.flags["SpeakMikaWells"];
end;
for i = 547614, 547621 do
	QuestState.flags[i] = QuestState.flags["SpeakFernWells"];
end;
for i = 547622, 547629 do
	QuestState.flags[i] = QuestState.flags["SpeakPeggyWells"];
end;
for i = 547630, 547637 do
	QuestState.flags[i] = QuestState.flags["SpeakMiyaWells"];
end;
for i = 547638, 547645 do
	QuestState.flags[i] = QuestState.flags["SpeakDougWells"];
end;
for i = 547646, 547653 do
	QuestState.flags[i] = QuestState.flags["SpeakGaryWells"];
end;
for i = 547654, 547658 do
	QuestState.flags[i] = QuestState.flags["SpeakMikaWells"];
end;
for i = 547659, 547662 do
	QuestState.flags[i] = QuestState.flags["SpeakFernWells"];
end;
for i = 547663, 547667 do
	QuestState.flags[i] = QuestState.flags["SpeakPeggyWells"];
end;
for i = 547668, 547671 do
	QuestState.flags[i] = QuestState.flags["SpeakMiyaWells"];
end;
for i = 547672, 547676 do
	QuestState.flags[i] = QuestState.flags["SpeakDougWells"];
end;
for i = 547677, 547680 do
	QuestState.flags[i] = QuestState.flags["SpeakGaryWells"];
end;
