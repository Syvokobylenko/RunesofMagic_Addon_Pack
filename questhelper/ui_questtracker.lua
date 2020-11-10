------------------------------------------------------
-- QuestHelper
--
-- file: ui_questtracker
-- desc: quest tracker window
--      * the visible quest-To-Do-list
--
-- Author: McBen
-- ver:  v7.4.5
-- date: 2014-04-27T11:38:13Z
------------------------------------------------------

local Tracker= {
  -- constants
  RecheckInterval=5, -- player position check interval in sec

  -- data
  RecheckTimer=10,   -- update timer for position recalculation
  anim_direction=1,  -- 1/-1 for move left or move right
}
_G.QH.Tracker = Tracker

local MAXITEMS=10
local text_size = 12
local line_height=17
local COL_TOOLTIP_HINT = "|cff008CFF"

g_UIPanelAnchorFrameDefaults["QH_QuestTracker"]={
    x = 600,
	y = 400,
	point = "TOPLEFT",
	relativePoint = "TOPLEFT",
	relativeTo = "UIParent",
}
----------------------------------------------
local available_frames={}
local animations={}
local guid=0

local T_TEXT=1
local T_FRAME=2

Tracker.items={}

function Tracker.Init()
    QH_QuestTracker_Title:SetText(QH.L.Tracker_Title)
end

---------------------------------------------
local function CreateFrame()
    guid = guid+1
    local tempname = "QH_QuestTrackerI"..guid
    local tempname2= tempname.."text"
    local frame = CreateUIComponent("Frame",tempname, "QH_QuestTracker_Body")
    frame:SetSize(300, line_height)

    frame.Text = CreateUIComponent("FontString",tempname2, tempname)
    frame.Text:SetSize(300, line_height)
    frame.Text:SetFont("Fonts/DFHEIMDU.TTF", text_size, "NORMAL", "NORMAL")
    frame.Text:SetJustifyHType("LEFT")
    frame.Text:ClearAllAnchors()
    frame.Text:SetAnchor("TOPLEFT", "TOPLEFT", frame, 0, 0)
    frame:SetLayers(1, frame.Text)

    frame:SetMouseEnable(true)
    frame:SetScripts("OnEnter","QH.Tracker.OnItemMouseEnter(this)")
    frame:SetScripts("OnLeave","QH.Tracker.OnItemMouseLeave(this)")
    frame:RegisterForClicks("LeftButton", "RightButton")
    frame:SetScripts("OnClick","QH.Tracker.OnItemClick(this,key)")

    _G[tempname]=nil
    _G[tempname2]=nil

    return frame
end

local function FrameNew()
    local f = table.remove(available_frames,#available_frames)
    if not f then
        f = CreateFrame()
    end

    return f
end

local function FrameRelease(f)
    f:Hide()
    table.insert(available_frames,f)
end
local function FindFreeID()
    for id,v in ipairs(Tracker.items) do
        if next(v)==nil then
            return id
        end
    end

    return #Tracker.items+1
end

function Tracker.EntryAdd(text)
    local id = FindFreeID()
    Tracker.items[id]={text,nil}

    Tracker.NeedRefresh()

    return id
end

function Tracker.EntryRemove(id)
    local item=Tracker.items[id]
    if item[T_FRAME] then
        Tracker.SetNextFramePos(item[T_FRAME],MAXITEMS+1)
    end

    Tracker.items[id]={}

    Tracker.NeedRefresh()
end

----------------------------------------------
function Tracker.EntryPosition(id, pos)

    if not id or not Tracker.items[id] then
        QH.API.DebugErr("EntryPosition id="..tostring(id).." not in tracker.items")
        return
    end

    local item=Tracker.items[id]

    pos = pos or (MAXITEMS+1)

    if not item[T_FRAME] then
        if pos>MAXITEMS then return end

        item[T_FRAME]=FrameNew()
        item[T_FRAME].Data=item
        item[T_FRAME]:SetID(id)
        item[T_FRAME].PosStart=-1
        item[T_FRAME].PosEnd=-1
        item[T_FRAME].PosNext=-1
        Tracker.EntryText(id,item[T_TEXT])
    end

    Tracker.SetNextFramePos(item[T_FRAME],pos)
end

function Tracker.SetNextFramePos(frame,pos)
    assert(pos>0)

    if pos>MAXITEMS then
        pos=-1
    else
        pos =pos-1
    end

    if frame.PosNext==pos then return end
    frame.PosNext=pos

    if not frame.Anim then
        Tracker.StartAnimation(frame)
    end
end

Tracker.Animations={
  ["out"]=  {
    Init= function (this)
        -- detach from item
        this.Data[T_FRAME]=nil
        this:ClearAllAnchors()
        this:SetAnchor("TOPLEFT", "TOPLEFT", "QH_QuestTracker_Body", 0, this.PosStart*line_height)
        this:SetAlpha(1)
        this:Show()
    end,
    Update= function (this,time)
        local a = 1-(time/2)
        if a<0 then a=0 end
        this:SetAlpha(a)
        this:ClearAllAnchors();
        this:SetAnchor("TOPLEFT", "TOPLEFT", "QH_QuestTracker_Body", time*200*Tracker.anim_direction, this.PosStart*line_height)
        return a>0
    end,
    Clear= function (this)
        this:Hide()
        FrameRelease(this)
    end,
  },

  ["in"]=  {
    Init= function (this)
       this:SetAlpha(0)
       this:ClearAllAnchors();
       this:SetAnchor("TOPLEFT", "TOPLEFT", "QH_QuestTracker_Body", 200*Tracker.anim_direction, this.PosEnd*line_height+100)
       this:Show()
    end,
    Update= function (this,time)
       local a = time
       if a>1 then a=1 end
       this:SetAlpha(a)

       if time>2 then time=2 end
       local x = math.cos(3.14*time/4)
       local y = 1-math.sin(3.14*time/4)
       this:ClearAllAnchors();
       this:SetAnchor("TOPLEFT", "TOPLEFT", "QH_QuestTracker_Body", 200*x*Tracker.anim_direction, this.PosEnd*line_height+100*y)
       return time<2
    end,
    Clear= function (this)
       this:ClearAllAnchors()
       this:SetAnchor("TOPLEFT", "TOPLEFT", "QH_QuestTracker_Body", 0, this.PosEnd*line_height)
       this:SetAlpha(1)
       this:Show()
     end,
  },

  ["slide"]= {
    Update= function (this,time)
       if time>1 then time=1 end
       local x = 1-(math.cos(3.14*time)+1)/2
       this:ClearAllAnchors();
       this:SetAnchor("TOPLEFT", "TOPLEFT", "QH_QuestTracker_Body", 0,(this.PosStart+x*(this.PosEnd-this.PosStart))*line_height)
       return time<1
    end,
  },
  ["swing"]= {
    Update= function (this,time)
       if time>2 then time=2 end
       local x = math.sin(3.14*time/2)
       if this.PosEnd>this.PosStart then x=-x end
       local y = (1+math.cos(3.14*time/2))/2
       this:ClearAllAnchors();
       this:SetAnchor("TOPLEFT", "TOPLEFT", "QH_QuestTracker_Body", 150*x*Tracker.anim_direction, (this.PosEnd+y*(this.PosStart-this.PosEnd))*line_height)
       return time<2
    end,
  },
}

local function FrameAnimInit(frame)
    if frame.Anim.Init then
        frame.Anim.Init(frame)
    else
        frame:ClearAllAnchors()
        frame:SetAnchor("TOPLEFT", "TOPLEFT", "QH_QuestTracker_Body", 0,frame.PosStart*line_height)
        frame:SetAlpha(1)
        frame:Show()
    end
end

local function FrameAnimClear(frame)
    if frame.Anim.Clear then
        frame.Anim.Clear(frame)
    else
       frame:ClearAllAnchors()
       frame:SetAnchor("TOPLEFT", "TOPLEFT", "QH_QuestTracker_Body", 0,frame.PosEnd*line_height)
    end
end

local function ChooseAnimation(frame)

    local anim="no_anim"

    if frame.PosStart <0 then
        anim = "in"
    elseif frame.PosEnd <0 then
        anim = "out"
    else
        local lines = frame.PosStart-frame.PosEnd
        if math.abs(lines) == 1 then
            anim = "slide"
        else
            anim = "swing"
        end
    end

    return Tracker.Animations[anim]
end
function Tracker.StartAnimation(frame)

    if frame.PosEnd == frame.PosNext then return end

    frame.PosStart = frame.PosEnd
    frame.PosEnd = frame.PosNext
    frame.AnimTimer=0

    frame.Anim = ChooseAnimation(frame)

    if frame.Anim then
        table.insert(animations, frame)
        FrameAnimInit(frame)
    end
end

function Tracker.EntryText(id,text)
    local item = Tracker.items[id]
    item[T_TEXT]=text

    if item[T_FRAME] then
        local ItemFrame = item[T_FRAME].Text
        ItemFrame:SetText(text)
        local w = math.ceil(ItemFrame:GetDisplayWidth())
        ItemFrame:SetSize(w,text_size)
        item[T_FRAME]:SetSize(w,text_size)
    end
end

function Tracker.IsEntryVisible(id)
    return Tracker.items[id][T_FRAME]
end
----------------------------------------------
function Tracker.ShowTitle(enable)
    if enable then
        QH_QuestTracker_Head:Show()
        QH_QuestTracker_HeadMini:Hide()
    else
        QH_QuestTracker_Head:Hide()
        QH_QuestTracker_HeadMini:Show()
    end
end

function Tracker.ShowTracker(enable)
    if enable then
        QH_QuestTracker:Show()
    else
        QH_QuestTracker:Hide()
    end
end

function Tracker.ShowTrackerBody(enable)
    local _,y = QH_QuestTracker:GetPos()
    local _,sy = UIParent:GetRealSize()
    local head_switch = ((y/sy)>=0.6)
    local switch_size = 8*line_height

    local point, relativePoint, relativeTo, offsetX, offsetY = QH_QuestTracker:GetAnchor()

    if enable then
        QH_QuestTracker_Body:Show()
        if head_switch then
            QH_QuestTracker:ClearAllAnchors()
            QH_QuestTracker:SetAnchor(point, relativePoint, relativeTo, offsetX, offsetY-switch_size/GetUIScale())
        end
    else
        QH_QuestTracker_Body:Hide()
        if head_switch then
            QH_QuestTracker:ClearAllAnchors()
            QH_QuestTracker:SetAnchor(point, relativePoint, relativeTo, offsetX, offsetY+switch_size/GetUIScale())
        end
    end
end

function Tracker.SetTitle(text)
    QH_QuestTracker_Count:SetText(text)
end

function Tracker.NeedRefresh()
  Tracker.RecheckTimer=0.2
end

function Tracker.OnUpdate(elapsedTime)

    -- do animations
    for idx,frame in ipairs(animations) do
        frame.AnimTimer = frame.AnimTimer + elapsedTime

        if not frame.Anim.Update(frame, frame.AnimTimer) then
            FrameAnimClear(frame)
            frame.Anim=nil
            table.remove(animations,idx)
            Tracker.StartAnimation(frame)
        end
    end

    -- Find goals
    if QH.QB.DoingNameSearch then
        QH.QB.ContinueNameSearch(elapsedTime)
    end
end

function Tracker.OnUpdateRefresh(elapsedTime)

    --recalc distance
    Tracker.RecheckTimer = Tracker.RecheckTimer - elapsedTime
    if Tracker.RecheckTimer <0 then
        QH.Tracker.RecheckTimer=QH.Tracker.RecheckInterval
        QH.QT.DoDistanceCheck()
    end

end

----------------------------------------------
function Tracker.OnHeaderClick(this)
    QH_Options.tracker_body = not QH_QuestTracker_Body:IsVisible()
    Tracker.ShowTrackerBody(QH_Options.tracker_body)
end

function Tracker.OnHeaderMouseDown(this, key)
    UIPanelAnchorFrame_OnMouseDown( this:GetParent(), key )
end

function Tracker.OnHeaderMouseUp(this,key)
    UIPanelAnchorFrame_OnMouseUp( this:GetParent(), key )
end

function Tracker.ShowHeadToolTip(this)

    GameTooltip:SetOwner(this, "ANCHOR_LEFT")
    GameTooltip:SetText(string.format(QH.L.HeadTooltip_Header,QH.VERSION))
    GameTooltip:AddLine("")

    GameTooltip:AddDoubleLine(QH.L.HeadTooltip_Quests, string.format("%i/%i "..QH.L.HeadTooltip_Goals,(g_NumTotalQuest or 0),30,QH.QT.Count()))

    local dailycount , dailymax = Daily_count()
    GameTooltip:AddDoubleLine(QH.L.HeadTooltip_Dailies, string.format("%i/%i",dailycount , dailymax))

    GameTooltip:AddLine("")
    GameTooltip:AddLine(QH.L.HeadTooltip_Rewards,1,1,0.2)
    local xp,fin_xp,tp,fin_tp,gold,fin_gold = QH.QB.GetRewardSum()
    GameTooltip:AddDoubleLine(" XP:",string.format("%i (%i)",xp , fin_xp))
    GameTooltip:AddDoubleLine(" TP:",string.format("%i (%i)",tp , fin_tp))
    GameTooltip:AddDoubleLine(" Gold:",string.format("%i (%i)",gold,fin_gold))

    GameTooltip:AddLine("")
    GameTooltip:AddLine(QH.L.HeadTooltip_DBStats,1,1,0.2)
    local quests,dyn_quests, goal_count, dyn_goal_count = QH.DB.DBStatistic()
    GameTooltip:AddDoubleLine(QH.L.HeadTooltip_DBQuests,string.format("%i (%i)",quests, dyn_quests))
    GameTooltip:AddDoubleLine(QH.L.HeadTooltip_DBGoals,string.format("%i (%i)",goal_count, dyn_goal_count))

    GameTooltip:AddLine("")
    GameTooltip:AddLine(COL_TOOLTIP_HINT..QH.L.MoveAndCollapseHint)

    GameTooltip:Show()
end

function Tracker.OnItemMouseEnter(this)
    QH.QT.ShowGoalTooltip(this,this:GetID())
    GameTooltip:AddLine("\n")
    GameTooltip:AddLine(COL_TOOLTIP_HINT..QH.L.RightClickForMenu)
end

function Tracker.OnItemMouseLeave(this)
    GameTooltip:Hide()
end

function Tracker.OnItemClick(this,key)
    if key=="LBUTTON" then
        QH.QT.OnGoalLeftClicked(this,this:GetID())
    elseif key=="RBUTTON" then
        QH_QuestTrackerPopup:SetID(this:GetID())
        UIDropDownMenu_Initialize( QH_QuestTrackerPopup, QH.QT.OnContextMenuShow, "MENU")
        ToggleDropDownMenu( QH_QuestTrackerPopup, 1, nil, "cursor", 1 ,1 )
    end
end

function Tracker.SetTextSize(size)

    local function UpdateFrames(frames)
        for _,item in ipairs(Tracker.items) do
            local frame = item[T_FRAME]
            if frame then
                frame.Text:SetFontSize(text_size)
                -- RoM Bug #45323: SetFontSize needs a text change
                local t = frame.Text:GetText()
                frame.Text:SetText("")
                frame.Text:SetText(t)

                frame:ClearAllAnchors()
                frame:SetAnchor("TOPLEFT", "TOPLEFT", "QH_QuestTracker_Body", 0,frame.PosEnd*line_height)
            end
        end
    end

    text_size = size
    line_height = size+3+size/10

    UpdateFrames(Tracker.items)
    UpdateFrames(available_frames)
    UpdateFrames(animations)
end

function Tracker.SetLineCount(count)
    MAXITEMS = count
    Tracker.NeedRefresh()
end



