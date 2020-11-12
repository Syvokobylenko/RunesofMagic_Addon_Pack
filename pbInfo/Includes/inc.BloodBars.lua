/run _, IS_remaining = GetSkillCooldown(2,4);
/run _, EC_remaining = GetSkillCooldown(4,1);
/run _, ECB_remaining = GetSkillCooldown(4,29);
/run DEFAULT_CHAT_FRAME:AddMessage(FB);
/run if (IS_remaining == 0) then CastSpellByName("Intensification") elseif (EC_remaining == 0) then CastSpellByName("Elemental Catalysis") elseif (ECB_remaining == 0) then CastSpellByName("Earth Core Barrier") else CastSpellByName("Flame") end