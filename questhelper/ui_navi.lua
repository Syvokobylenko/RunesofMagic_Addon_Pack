------------------------------------------------------
-- QuestHelper
--
-- file: ui_navi
-- desc: navigator display in minimap
--      * navi display
--      * speakframe handling for highlit teleport suggestion
--
-- Author: McBen
-- ver:  v7.4.5
-- date: 2013-01-08T18:53:18Z
------------------------------------------------------

local Navi= {}
_G.QH.Navi = Navi

local UPDATE_DELAY=0.2
local UPDATE_ERROR_PAUSE=5
local UPDATE_NO_TARGET=2

local ToolTipIsVisible=nil
local UpdateTimer=0
local target_map,target_x,target_y,target_text

function Navi.Show(show)
    if show then
        QH_QuestNavi:Show()
    else
        QH_QuestNavi:Hide()
    end
end

function Navi.ShowToolTip(this)
    GameTooltip:SetOwner(this, "ANCHOR_LEFT")
    GameTooltip:Show()
    ToolTipIsVisible = true
    Navi.ToolTipUpdate()
end

function Navi.HideToolTip()
    ToolTipIsVisible = nil
    GameTooltip:Hide()
end

function Navi.UpdateTarget()

    target_x = nil
    if QH.QT.HasTarget(1) then
        target_map = QH.Map.GetCurrentWorldMapID()
        target_x,target_y,target_text = QH.QT.FindFirstPathPos(1, target_map)

        if QH.QT.GetPathError(1) then
            QH_QuestNavi_Texture_overlay:Show()
        else
            QH_QuestNavi_Texture_overlay:Hide()
        end

        QH_QuestNavi:Show()

        UpdateTimer = math.min(UpdateTimer,UPDATE_DELAY)
    end

    if not target_x then
        target_map = nil
        QH_QuestNavi:Hide()
        UpdateTimer = UPDATE_NO_TARGET
    end
end

function Navi.ToolTipUpdate()

    if target_map and QH.Map.GetCurrentWorldMapID()==target_map then
        GameTooltip:SetText()
        GameTooltip:AddLine(string.format("Go to: %.1f, %.1f",target_x*100,target_y*100))

        local px, py = GetPlayerWorldMapPos()
        if px and py then
            px = target_x - px
            py = target_y - py
            local dist = 1000*math.sqrt(px*px+py*py)
            GameTooltip:AddLine(string.format("Dist: %.1f m",dist))
        end
        if target_text then
            GameTooltip:AddLine(target_text)
        end
    else
        Navi.HideToolTip()
    end
end



--------------------------------
local ori_SpeakFrame_LoadQuest = SpeakFrame_LoadQuest

local function GetPorterText()

    if QH.QT.HasTarget(1) then
        local tx,ty,_,porter_txt = QH.QT.FindFirstPathPos(1, QH.Map.GetCurrentWorldMapID())
        local px, py = GetPlayerWorldMapPos()

        if tx and px and py then
            local distance2 = (px-tx)*(px-tx)+(py-ty)*(py-ty)

            if distance2<0.000018 then --0.003*0.003*2 = 0.000018
                return porter_txt
            end
        end
    end
end

function SpeakFrame_LoadQuest(this)

    ori_SpeakFrame_LoadQuest(this)

    local textes = GetPorterText()
    if not textes then return end

    for _,text in ipairs(textes) do
        for i= 1,g_SpeakFrameData.count do
            if g_SpeakFrameData.option[i].title == text then
                g_SpeakFrameData.option[i].title = "|cff80ff80>> "..g_SpeakFrameData.option[i].title.." <<"
                g_SpeakFrameData.option[i].iconid=DF_IconType_FlightPoint

                SpeakOption_UpdateItems()
                return
            end
        end
    end
end
--------------------------------
-- TODO: animation on target change
function Navi.OnUpdate(elapsedTime)

    if ToolTipIsVisible then
        Navi.ToolTipUpdate()
    end

    UpdateTimer = UpdateTimer - elapsedTime
    if UpdateTimer>0 then
        return
    end
    UpdateTimer = elapsedTime+UPDATE_DELAY

    if target_map then

        if QH.Map.GetCurrentWorldMapID()==target_map then

            local px, py = GetPlayerWorldMapPos()
            -- in case of transit
            if not px or not py then
                UpdateTimer = UPDATE_ERROR_PAUSE
                QH_QuestNavi:Hide()
                return
            end

            px = target_x - px
            py = target_y - py

            local length = math.sqrt(px*px+py*py)
            if length<0.0001 then length=0.0001 end
            px = px *44 / length
            py = py *44 / length


            length=length*45
            if length<1 then
                px = px*length
                py = py*length
                QH_QuestNavi_Texture:SetAlpha(length)
            else
                QH_QuestNavi_Texture:SetAlpha(1)
            end

            local rotation=math.atan2(py,px)
            local x,y = QH_QuestNavi:GetPos()
            QH_QuestNavi_Pos:SetPos(x+px,y+py)
            QH_QuestNavi_Texture:SetRotate(rotation)

            QH_QuestNavi:Show()

        else
            if not QH.Map.GetCurrentWorldMapID()==400 then -- house
                QH.API.Debug("Navi -> target not on this map -> force Tracker refresh")
                QH.Tracker.NeedRefresh()
            end
            UpdateTimer = UPDATE_NO_TARGET
            QH_QuestNavi:Hide()
        end

    else
        QH_QuestNavi:Hide()
        UpdateTimer = UPDATE_NO_TARGET
    end
end



