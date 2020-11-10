local AutoLB = {}

_G.AutoLB = AutoLB

function AutoLB.OnLoad(this)
	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("UNIT_BUFF_CHANGED")
end

function AutoLB.OnEvent(event, arg1)
	if event == "VARIABLES_LOADED" then
		if not AutoLB.Buffs then
			AutoLB.Buffs = {}
		end
	elseif event == "UNIT_BUFF_CHANGED" and arg1=="player" then
		for i = 1,20,1 do
			local buff = UnitBuff("player",i)
			if not buff then
				break
			elseif string.find(buff,"Story Element") then
				AutoLB.Buffs[UnitName("player")] = buff..","..GetTime()
				AutoLB_Buffs = AutoLB.Buffs
				SaveVariablesPerCharacter("AutoLB_Buffs")
				break
			end
		end
	end
end