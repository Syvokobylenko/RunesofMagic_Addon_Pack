------------------------------------------------------
-- QuestHelper
--
-- file: ui_options
-- desc: option menu
--
-- Author: McBen
-- ver:  v7.4.5
-- date: 2014-04-18T13:37:13Z
------------------------------------------------------

local Options= {}
_G.QH.Options = Options


function Options.OnShow()

    QH_OptionFrameTitle:SetText(QH.L.OPTION_Title)
    QH_OptionFrameNaviName:SetText(QH.L.OPTION_Title_Navi)
    Options.CheckInit( QH_OptionFrameNaviEnable,"navi", QH.L.OPTION_Navi, QH.L.OPTION_Navi_tt )

    QH_OptionFrameTrackerName:SetText(QH.L.OPTION_Title_Tracker)
    Options.CheckInit( QH_OptionFrameTrackerEnable,"tracker", QH.L.OPTION_Tracker, QH.L.OPTION_Tracker_tt )
    Options.CheckInit( QH_OptionFrameTrackerTitle,"tracker_title", QH.L.OPTION_Tracker_Title, QH.L.OPTION_Tracker_Title_tt )
    Options.CheckInit( QH_OptionFrameTrackerZoneOnly,"tracker_zone_only", QH.L.OPTION_Tracker_ZoneOnly, QH.L.OPTION_Tracker_ZoneOnly_tt )

    CommonOptionsSliderTemplate_Init(
        QH_OptionFrameTrackerTextSize, QH.L.OPTION_Tracker_text_size, QH_Options, "text_size" , 6 , 32 , QH.Options.Apply , QH.L.OPTION_Tracker_text_size_tt )
    CommonOptionsSliderTemplate_Init(
        QH_OptionFrameTrackerLineCount,  QH.L.OPTION_Tracker_line_count, QH_Options, "LineCount" , 1 , 20 , QH.Options.Apply , QH.L.OPTION_Tracker_line_count_tt )

    QH_OptionFrameMapName:SetText(QH.L.OPTION_Title_Map)
    Options.CheckInit( QH_OptionFrameMapAllPoints,"map_all_points" , QH.L.OPTION_MapAllPoints, QH.L.OPTION_MapAllPoints_tt )
    Options.CheckInit( QH_OptionFrameMapFullInfo,"map_full_info" , QH.L.OPTION_MapFullQuestInfo, QH.L.OPTION_MapFullQuestInfo_tt )

    QH_OptionFrameMiscName:SetText(QH.L.OPTION_Title_Misc)
    Options.CheckInit( QH_OptionFrameMiscSpeakframe,"speakframe", QH.L.OPTION_SpeakFrame,QH.L.OPTION_SpeakFrame_tt)
    Options.CheckInit( QH_OptionFrameMiscEditor,"editor", QH.L.OPTION_Editor, QH.L.OPTION_Editor_tt )
    Options.CheckInit( QH_OptionFrameMiscDebug,"debug", "Debug Mode" )

    QH_OptionFrameBookName:SetText(QH.L.OPTION_Title_Book)
    Options.CheckInit( QH_OptionFrameBookHook,"hook_book", QH.L.OPTION_Book, QH.L.OPTION_Book_tt )
    Options.CheckInit( QH_OptionFrameBookMinimap,"minimap", QH.L.OPTION_Minimap)
end

function Options.Apply()
    QH.Navi.Show(QH_Options.navi)

    QH.UI_map.ShowMapIcons()

    QH.Tracker.ShowTracker(QH_Options.tracker)
    QH.Tracker.ShowTrackerBody(QH_Options.tracker_body)
    QH.Tracker.ShowTitle(QH_Options.tracker_title)
    QH.Tracker.SetTextSize(QH_Options.text_size)
    QH.Tracker.SetLineCount(QH_Options.LineCount)
    QH.ListDialog.ReplaceOriginalBook(QH_Options.hook_book)

    if QH_Options.minimap==nil then QH_Options.minimap = (AddonManager==nil) end

    if QH_Options.minimap then
        QuestHelperMinimapButton:Show()
    else
        QuestHelperMinimapButton:Hide()
    end

    if QH_Options.navi or QH_Options.tracker then
        QH_QuestTracker_Updater:Show()
    else
        QH_QuestTracker_Updater:Hide()
    end

    if QH_Options.speakframe then
        if SpeakFrame:IsVisible() then
            SpeakFrame_Show()
        end
    else
        if SpeakFrame:GetHeight()~=480 then
            QH.ResizeSpeakFrame()
        end
    end

end

--------------------------------------------------------------------
function Options.CheckInit( this, OptionName, name, tips )
	local ButtonName = this:GetName()
	_G[ButtonName.."Name"]:SetText(name)
	this.OptionName = OptionName
	this:SetChecked( QH_Options[ OptionName ] )
	this.tips = tips
end

function Options.OnCheckClicked(this)
	QH_Options[ this.OptionName ] = this:IsChecked()
	Options.Apply()
end

function Options.OnCheckEnter( this )
	if this.tips then
		GameTooltip:SetOwner( this, "ANCHOR_LEFT", 0, 0 )
		GameTooltip:SetText( this.tips,1,1,1 )
		GameTooltip:Show()
	end
end

function Options.OnCheckLeave()
	GameTooltip:Hide()
end




