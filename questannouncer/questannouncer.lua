
local QA = {}
_G.QuestAnnouncer = QA

QA_Options = {
    QuestStartMsg=false,
    QuestStepMsg=true,
    QuestStepCompletMsg=true,
    QuestCompletMsg=true,
}

QA.version="v1"

QA.L={
    UI_OPTION="Right click for options.",
    MSG_START=">> Quest-Started: ",
    MSG_STEP=">>",
    MSG_STEP_COMPLETE=">>",
    MSG_COMPLETE=">> Quest-Completed: ",

    JOIN_RAID = "joining raid -> QuestAnnouncer disabled",
    LEFT_RAID = "leaving raid -> QuestAnnouncer enabled",
    JOIN_PARTY_WARN = "QuestAnnouncer is ACTIVE",

    OPTION_ENABLED="|cff40ff40Activate",
    OPTION_DISABLED="|cffff4040Deactivate",
    OPTION_MSG_TITLE="Send message on:",
    OPTION_MSG_START="Quest Start",
    OPTION_MSG_STEP ="Quest progress",
    OPTION_MSG_STEP_COMPLETE ="Quest Goal complete",
    OPTION_MSG_COMPLETE ="Quest complete",
}

function QA.OnLoad(this)
    this:RegisterEvent("VARIABLES_LOADED")
    this:RegisterEvent("LOADING_END")
    this:RegisterEvent("SYSTEM_MESSAGE")
    this:RegisterEvent("PARTY_MEMBER_CHANGED")
end

function QA.Out(txt)
    DEFAULT_CHAT_FRAME:AddMessage("QA: "..txt,1,0.6,0.6)
end

function QA.OnEvent(event)
    QA[event](arg1)
end

function QA.VARIABLES_LOADED()
    SaveVariables("QA_Options")
    QuestAnnouncer.active = true
    QuestAnnouncer.InParty = false
    QuestAnnouncer.InRaid = false

    QA.fin_text = TEXT("QUEST_MSG_REQUEST_COMPLETE")
    QA.fin_text= string.gsub(QA.fin_text,"([%(%)%%])","%%%1")
end

function QA.LOADING_END()
    SaveVariables("QA_Options")
end


function QA.PARTY_MEMBER_CHANGED()
    QA.UpdateGroupStatus()
end

function QA.SYSTEM_MESSAGE(msg)

    local numQuests = GetNumQuestBookButton_QuestBook()
	for i=1, numQuests do
        local _, _, _QuestName, _, _, _, _, _, _, _bCompleteQuest = GetQuestInfo( i )
        local fin_found = string.find(msg,TEXT("QUEST_MSG_REQUEST_COMPLETE"),0,true)
        _QuestName = string.gsub(_QuestName,QA.fin_text,"")

		if string.find(msg, _QuestName,0,true) then
            if msg==string.format(TEXT("QUEST_MSG_GET"),_QuestName) then
                QA.QuestStart(_QuestName)
            elseif fin_found then
                msg = string.gsub(msg,"^".._QuestName..": ","")
                QA.QuestStepComplete(msg)
            elseif _bCompleteQuest then
                QA.QuestComplete(_QuestName)
            else
                -- RoM-Bug: SystemMessage is singular, Goal-Text is plural
                -- so we skip goal checking here
                msg = string.gsub(msg,"^".._QuestName..": ","")
                QA.QuestStep(msg,_QuestName)
            end
		end
	end
end

function QA.UpdateGroupStatus(silent)
    local in_party = (GetNumPartyMembers()>1)
    local in_raid = UnitInRaid("player")

    if not silent then
        if QuestAnnouncer.InRaid~=in_raid then
            if in_raid then
                if QuestAnnouncer.active then
                    QA.Out(QA.L.JOIN_RAID)
                    QuestAnnouncer.preRaidState=QuestAnnouncer.active
                    QA.EnableAnnouncer(false)
                end
            else
                if QuestAnnouncer.preRaidState then
                    QA.Out(QA.L.LEFT_RAID)
                    QuestAnnouncer.preRaidState=nil
                    QA.EnableAnnouncer(true)
                end
            end
        end

        if in_party and not QuestAnnouncer.InParty and QuestAnnouncer.active then
            QA.Out(QA.L.JOIN_PARTY_WARN)
        end
    end

    QuestAnnouncer.InParty = in_party
    QuestAnnouncer.InRaid = in_raid
end

function QA.QuestStart(quest)
    if QA_Options.QuestStartMsg then
        QA.SendAnnounce(QA.L.MSG_START..quest,"PARTY")
    end
end

function QA.QuestStep(msg)
    if QA_Options.QuestStepMsg then
        QA.SendAnnounce(QA.L.MSG_STEP..msg,"PARTY")
    end
end

function QA.QuestStepComplete(msg)
    if QA_Options.QuestStepCompletMsg then
        QA.SendAnnounce(QA.L.MSG_STEP_COMPLETE..msg,"PARTY")
    end
end

function QA.QuestComplete(quest)
    if QA_Options.QuestCompletMsg then
        QA.SendAnnounce(QA.L.MSG_COMPLETE..quest,"PARTY")
    end
end


function QA.SendAnnounce(msg)
    if QuestAnnouncer.active and QuestAnnouncer.InParty then
        SendChatMessage(msg,"PARTY")
    end
end

function QA.EnableAnnouncer(enable)
    QuestAnnouncer.active = enable

    if QuestAnnouncer.active then
        QuestAnnouncerMinimapButton:UnlockPushed()
    else
        QuestAnnouncerMinimapButton:LockPushed()
    end
end

function QA.ButtonOnClick(this,key)
    if not IsShiftKeyDown() then
        if key == "RBUTTON" then
            ToggleDropDownMenu(QuestAnnouncer_Menu)
        else
            QA.EnableAnnouncer(not QuestAnnouncer.active)
        end
    end
end

function QA.ButtonOnEnter(this)
	GameTooltip:SetOwner(this, "ANCHOR_LEFT", 4, 0)
	GameTooltip:SetText("QuestAnnouncer "..QA.version, 1, 1, 1)
	GameTooltip:AddLine(QA.L.UI_OPTION, 0, 0.75, 0.95)
	GameTooltip:AddLine(UI_MINIMAPBUTTON_MOVE, 0, 0.75, 0.95)
	GameTooltip:Show()
end

function QA.ButtonOnLeave(this)
    GameTooltip:Hide()
end

function QA.MenuOnShow(this)
	local info = {}

    if QuestAnnouncer.active then
        info.text = QA.L.OPTION_DISABLED
        info.func = function() QA.EnableAnnouncer(false) end
        UIDropDownMenu_AddButton( info, 1 )
    else
        info.text = QA.L.OPTION_ENABLED
        info.func = function() QA.EnableAnnouncer(true) end
        UIDropDownMenu_AddButton( info, 1 )
    end

    info = {}
    info.text = QA.L.OPTION_MSG_TITLE
    info.isTitle = 1
    UIDropDownMenu_AddButton( info, 1 )

    info = {}
    info.text = QA.L.OPTION_MSG_START
    info.checked = QA_Options.QuestStartMsg
    info.keepShownOnClick = 1
    info.func=function() QA_Options.QuestStartMsg = not QA_Options.QuestStartMsg end
    UIDropDownMenu_AddButton( info, 1 )

    info.text = QA.L.OPTION_MSG_STEP
    info.checked = QA_Options.QuestStepMsg
    info.func=function() QA_Options.QuestStepMsg = not QA_Options.QuestStepMsg end
    UIDropDownMenu_AddButton( info, 1 )

    info.text = QA.L.OPTION_MSG_STEP_COMPLETE
    info.checked = QA_Options.QuestStepCompletMsg
    info.func=function() QA_Options.QuestStepCompletMsg = not QA_Options.QuestStepCompletMsg end
    UIDropDownMenu_AddButton( info, 1 )

    info.text = QA.L.OPTION_MSG_COMPLETE
    info.checked = QA_Options.QuestCompletMsg
    info.func=function() QA_Options.QuestCompletMsg = not QA_Options.QuestCompletMsg end
    UIDropDownMenu_AddButton( info, 1 )

end

