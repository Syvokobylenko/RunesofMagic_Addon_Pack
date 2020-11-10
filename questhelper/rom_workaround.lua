

function Z37_Client124523()
  local QuestID = 427661
  local QuestID2 = 427667
  if CheckQuest( QuestID ) >= 1 and CheckQuest( QuestID2 ) < 2 then
    return false;
  end
  return true;
end
