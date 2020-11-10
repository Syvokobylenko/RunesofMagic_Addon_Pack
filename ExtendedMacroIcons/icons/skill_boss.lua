-- v6.0.2.2664en

local bossskill = {}
	for i=1,401 do
		local name = "Icons/boss_skill/skill_boss_skill_"
		if i<10 then name=name.."0" end
		name=name..i
		table.insert(bossskill,name)
	end
return bossskill
