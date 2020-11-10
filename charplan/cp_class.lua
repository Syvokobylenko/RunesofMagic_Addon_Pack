--[[
    CharPlan - Skills

    the Skill tree
]]
local CP = _G.Charplan
local Classes= {}
CP.Classes = Classes

local SKILLS_PER_PAGE=15
-- helper
local function SetVisible(this,vis)
    if vis then
        this:Show()
    else
        this:Hide()
    end
end
-----

function CP.UpdateClassBotton()
    CPFrameClassBtnLeftText:SetText(CP.Unit.GetClassName())
    CPFrameClassBtnRightText:SetText(CP.Unit.level)
end

function CP.ChangeClass()
    ToggleUIFrame(CPClassDialog)
end

function Classes.OnClassDropDownShow(this)

    local skip_class = nil
    if this == CPClassDialogClassSubClassDropDown then
        skip_class = CP.Unit.class
    end

    local info={}
    for i=1,GetClassCount() do
        local txt, token = GetClassInfoByID( GetClassID(i) )

        if token ~= skip_class then
            info.text = txt
            info.value = token
            info.notCheckable=1
            info.func = function (button) Classes.OnClassDropDownClick(this, button) end
            UIDropDownMenu_AddButton(info)
        end
    end

    if skip_class then
        info.text = "--------"
        info.value = nil
        info.notCheckable=1
        info.func = function (button) Classes.OnClassDropDownClick(this, button) end
        UIDropDownMenu_AddButton(info)
    end
end

function Classes.OnClassDropDownClick(this, button)
    UIDropDownMenu_SetSelectedValue(this, button.value)
    local c1 = UIDropDownMenu_GetSelectedValue(CPClassDialogClassMainClassDropDown)
    local c2 = UIDropDownMenu_GetSelectedValue(CPClassDialogClassSubClassDropDown)
    CP.Unit.SetClass(c1,c2)
    Classes.OnClassChanged()
end

function CP.OnClassDialogClick()
    local lvl = tonumber(CPClassDialogLevelEdit:GetText())
    if lvl<1 then lvl=1 end
    if lvl>MAX_LEVEL then lvl=MAX_LEVEL end

    CP.Unit.level = lvl
    CP.Unit.class = UIDropDownMenu_GetSelectedValue(CPClassDialogClassDropDown)

    HideUIPanel(CPClassDialog)
    CP.UpdateClassBotton()
    CP.UpdatePoints()
end

function Classes.OnShow(this)

    CPClassDialogClassLabel:SetText(CLASS)
    CPClassDialogLevelLabel:SetText(CP.L.SEARCH_LEVEL)
    CPClassDialogHideNotAvailableText:SetText("Hide not available")
    CPClassDialogHideNotSkillableText:SetText("Hide not skillable")

    CPClassDialogClassMainLabel:SetText(C_CLASS1)
    CPClassDialogClassSubLabel:SetText(C_CLASS2)

    CPClassDialogClassMainLevelEdit:SetText(CP.Unit.level)
    CPClassDialogClassSubLevelEdit:SetText(CP.Unit.sec_level)

    local pri_name,sec_name = CP.Unit.GetClassName()
    UIDropDownMenu_SetSelectedValue(CPClassDialogClassMainClassDropDown, CP.Unit.class)
    UIDropDownMenu_SetText(CPClassDialogClassMainClassDropDown, pri_name)
    UIDropDownMenu_SetSelectedValue(CPClassDialogClassSubClassDropDown, CP.Unit.sec_class)
    UIDropDownMenu_SetText(CPClassDialogClassSubClassDropDown, sec_name)

    Classes.OnClassChanged()
end

function Classes.OnHide(this)
    CP.Classes.skills=nil
end

local function GetSetSkills()
    local res ={}
    local setskills = CP.DB.GetSetSkillList()
    for _,skill in ipairs(setskills) do
        table.insert(res,
            {
                0, -- level
                skill, -- id
                TEXT("Sys"..skill.."_name"), -- name
                false, -- learned
                nil,
                0, -- mode = sk[6] -- ==2: passive
                0, -- max level
                true -- local can_be_disabled =
            })
    end

    return res
end

function Classes.OnClassChanged()
    CP.Classes.skills = CP.Unit.GetAllSkills()
    CP.Classes.skills[11] = GetSetSkills()

    Classes.UpdateTabs()
    Classes.UpdateList()
end

function Classes.OnSkillChanged()
    CP.Classes.skills = CP.Unit.GetAllSkills()

    local hide_not_avail = CPClassDialogHideNotAvailable:IsChecked()
    local hide_not_skill = CPClassDialogHideNotSkillable:IsChecked()

    repeat
        local nothing_removed=true
        for _,line in pairs(CP.Classes.skills) do
            for idx,skill in ipairs(line) do
                if (hide_not_avail and not skill[4]) or
                   (hide_not_skill and skill[7]==0) then
                    table.remove(line,idx)
                    nothing_removed=false
                end
            end
        end
    until nothing_removed

    Classes.UpdateList()
end

function Classes.UpdateList()

    local skillPoints = GetTotalTpExp()
    CPClassDialogSkillPoints:SetText( skillPoints )

    Classes.NextPage(0)
end

function Classes.NextPage(delta)
    Classes.ShowPage((CP.Classes.page or 1)+delta)
end

function Classes.ShowPage(pagenr)

	local	_FrameName		= "CPClassDialogSkills"
	local	_PageBar		= _G[ _FrameName .. "PageBar"]
	local	_LeftPage		= _G[ _PageBar:GetName() .. "LeftPage"]
	local	_RightPage		= _G[ _PageBar:GetName() .. "RightPage"]
	local	_Page			= _G[ _PageBar:GetName() .. "Page"]


    local skill_list = Classes.GetCurSkillList()

    local nof_pages = math.ceil( #skill_list / SKILLS_PER_PAGE )

    if pagenr<1 then pagenr =1 end
    if pagenr>nof_pages then pagenr=nof_pages end
    Classes.page = pagenr


    SetVisible(_PageBar, nof_pages > 1)
    SetVisible(_LeftPage, pagenr > 1)
    SetVisible(_RightPage, pagenr < nof_pages)

	_Page:SetText( pagenr.." / "..nof_pages )


    local top = (pagenr-1) * SKILLS_PER_PAGE
    for i = 1,SKILLS_PER_PAGE do
        local _ButtonName = _FrameName .. "SkillButton_"..i
        local _Button = _G[_ButtonName]
        local _NextValueBar	= _G[ _ButtonName .. "PointStatusBar"]

        local sk = skill_list[top+i]

        if sk then
            local lvl = sk[1]
            local id = sk[2]
            local name = sk[3]
            local learned = sk[4]
            local condition = sk[5]
            local mode = sk[6] -- ==2: passive
            local maxskill = sk[7]
            local can_be_disabled = sk[8]

            Classes.SetSkillButton(_Button, name, id, mode, maxskill, learned, can_be_disabled )
		else
			Classes.SetSkillButtonDisabled(_Button)
		end
	end
end

function Classes.UpdateTabs()

    local basename="CPClassDialogSkillsTab"

	local VocName, VocSubName  = CP.Unit.GetClassName()
	local ClassToken, SubClassToken = CP.Unit.class, CP.Unit.sec_class

    local index=1
    local function AddTab(typ, icon, tooltip,text)
        local frame = _G[ basename .. index]
        frame.type = typ
		frame:SetID(index)
        frame:Show()
        if text then
        	frame.toolipsText = toolipsText
            frame:SetText(text)
            PanelTemplates_TabResize(frame, 12)
        else
            PanelTemplates_IconTabInit(frame, icon, tooltip)
        end
        PanelTemplates_DeselectTab(frame)
        index = index+1
    end

    AddTab(DF_SkillType_MainJob, string.format( DF_SkillBook_Tab_Format , ClassToken ) , VocName )
	if SubClassToken then
        AddTab(DF_SkillType_SubJob, string.format( DF_SkillBook_Tab_Format , SubClassToken ) , VocSubName )
    end
    AddTab(DF_SkillType_SP, string.format( DF_SkillBook_Tab_Format , ClassToken ) .. "_sole" , string.format( CLASS_ONLY , VocName ) )
    AddTab(11, nil,nil,"Set")

	for i=index,5 do
 		_G[ basename .. i ]:Hide()
	end

	PanelTemplates_SetNumTabs( CPClassDialogSkills, index )
	PanelTemplates_SetTab( CPClassDialogSkills, 1)
end

function Classes.OnTabClicked(this, id)
    PanelTemplates_SetTab(CPClassDialogSkills,id)
    Classes.ShowPage(1)
end

function Classes.OnLevelChanged(this)
    CP.Unit.level = CP.Unit.ClampLevel(CPClassDialogClassMainLevelEdit:GetText())
    CP.Unit.sec_level = CP.Unit.ClampLevel(CPClassDialogClassSubLevelEdit:GetText())

    CPClassDialogClassMainLevelEdit:SetText(CP.Unit.level)
    CPClassDialogClassSubLevelEdit:SetText(CP.Unit.sec_level)

    if CP.Unit.sec_level > CP.Unit.level then
        CPClassDialogClassSubLevelEdit:SetTextColor(1,0.7,0.7)
    else
        CPClassDialogClassSubLevelEdit:SetTextColor(1,1,1)
    end

    Classes.OnSkillChanged()
end

function Classes.GetCurSkillList()
    local idx = PanelTemplates_GetSelectedTab(CPClassDialogSkills)
    local skill_type = _G[ "CPClassDialogSkillsTab" .. idx ].type
    return CP.Classes.skills[skill_type] or {}
end

function Classes.OnEnterButton(this, id)

	if this.EnableToLV == 1 then
		getglobal( this:GetName() .. "SelectHighlight" ):Show()
	end

    if this.skill then
        GameTooltip:ClearAllAnchors()
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT", 10, 0)

        local name = TEXT("Sys"..(this.skill).."_name")
        local lvl = CP.Unit.skills[this.skill] or 0
        if lvl>0 then
            name = name .."+"..lvl
        end
        GameTooltip:SetText(name)
    --[===[@debug@
    GameTooltip:AddLine("id: "..this.skill)
    --@end-debug@]===]

        local col = CPColor.New(0,0.75,0.95)
        local col_val = col:Brightness(1.5)
        GameTooltip:AddLine(CP.DB.GetSpellDesc(this.skill,lvl,col_val:Code()), col:Get())

        if lvl+1 < this.skill_max then
            local col = CPColor.New(0.45,0.45,0.45)
            local col_val = col:Brightness(1.5)
            GameTooltip:AddLine(TEXT("SYS_TOOLTIP_MAGIC_NEXT_POWER"),col:Get())
            GameTooltip:AddLine(CP.DB.GetSpellDesc(this.skill,lvl+1,col_val:Code()),col:Get())
        end

        if this.skill_max>lvl+1 then
            local col = CPColor.New(0.6,0.6,0.6,1,0.5)
            local col_val = col:Brightness(1.5)
            GameTooltip:AddLine("Max (+"..this.skill_max.."):",col:Get())
            GameTooltip:AddLine(CP.DB.GetSpellDesc(this.skill,this.skill_max,col_val:Code()),col:Get())
        end

        GameTooltip:Show()
    end
end

function Classes.OnClickButton(this, id, key)
	if key == "LBUTTON" then
        if IsShiftKeyDown() then
		    local lvl = CP.Unit.skills[this.skill] or 0
		    local link = CP.Pimp.GenerateSkillLink(this.skill, lvl, CP.Prefix)
		    CP.PostItemLink(link)
        else
            if this.skill_max>0 then
                local skill_min = this.can_be_disabled and 0 or 1
                Classes.RaiseSkill(this,this.skill, skill_min, this.skill_max)
            end
        end
	end
end

function Classes.SetSkillButtonDisabled(_Button)

    local btn=_Button:GetName()
	local _ItemButton = _G[btn.."ItemButton"]
	local _Name       = _G[btn.."_SkillInfo".."_Name"]
	local _LV         = _G[btn.."_SkillInfo".."_LV"]
	local _PowerLV	  = _G[btn.."PowerLV"]
	local _StatusBar  = _G[btn.."PointStatusBar"]
	local _PowerIcon  = _G[btn.."Icon"]

	_Button.EnableToLV = nil
	_Button.bLearned = nil
	_Button.skill = nil
	_Button.skill_max = nil

    _ItemButton:Disable()
    SetItemButtonTexture(_ItemButton, "")
    _LV:SetText("")
    _PowerLV:SetText( "" )
    _PowerIcon:Hide()
    _StatusBar:Hide()
    _Name:SetText("")
    _Button:Disable()
    _Button:Show()

end

function Classes.SetSkillButton( _Button, _SkillName, skill_id, _Mode, _maxskill, _bLearned, can_be_disabled )

    local _EnableToLV = _maxskill>0

    local btn=_Button:GetName()
	local _ItemButton = _G[btn.."ItemButton"]
	local _Name       = _G[btn.."_SkillInfo".."_Name"]
	local _LV         = _G[btn.."_SkillInfo".."_LV"]
	local _PowerLV	  = _G[btn.."PowerLV"]
	local _StatusBar  = _G[btn.."PointStatusBar"]
	local _StatusText = _G[btn.."PointStatusBar".. "StatusText"]
	local _NextValue  = _G[btn.."PointStatusBar".. "NextValue"]
	local _NextValueTitle  = _G[btn.."PointStatusBar".. "Next"]
	local _PowerIcon  = _G[btn.."Icon"]


    local icon = CP.DB.GetSpellIcon(skill_id)
    local passive = CP.DB.IsSpellPassive(skill_id)
    local cur_level = CP.Unit.skills[skill_id] or 0
    if _maxskill<1 then cur_level=nil end
    local costs = CP.DB.GetTPCosts(skill_id,cur_level)


	if( _SkillName ) then
		_NextValueTitle:Show()
		_Button:Enable()
	else
		_NextValueTitle:Hide()
		_Button:Disable()
	end

	SetItemButtonTexture( _ItemButton, icon )
	_StatusText:Hide()

--~ 	if( _Lv and _Lv > 0 ) then
--~ 		local strRank = TEXT( "SYS_MAGIC_LEVEL" )
--~ 		_LV:SetText( strRank .. _Lv )
--~ 		_LV:SetColor( 0.9, 0.9, 0.4 )
--~ 	else
 		_LV:SetText( "" )
--~ 	end

	if cur_level then
		_PowerLV:SetText( cur_level )
		_NextValueTitle:Show()
		_PowerIcon:Show()
	else
		_NextValueTitle:Hide()
		_PowerLV:SetText( "" )
		_PowerIcon:Hide()
	end

	if( _EnableToLV ) then
		_StatusBar:Show()
		if _maxskill>0 then
			_StatusBar:SetValue( cur_level / _maxskill )
   			_NextValue:SetText(costs)
			_NextValueTitle:Show()
			_StatusText:Hide()
		else
			_StatusBar:SetValue( 1 )
			_NextValue:SetText("")
			_NextValueTitle:Hide()
			_StatusText:Show()
		end
		_StatusBar:Show();
	else
		_StatusBar:Hide();
	end

    _Name:SetText( _SkillName )
    if passive then
		_Name:SetColor( 0.1, 0.68, 0.21 )
		_ItemButton:Disable()
    else
		_Name:SetColor( 1, 1, 1 )
		_ItemButton:Enable()
	end

	_Button.EnableToLV = _EnableToLV
	_Button.bLearned = _bLearned
	_Button.skill = skill_id
	_Button.skill_max = _maxskill
    _Button.can_be_disabled = can_be_disabled
	_Button:Show()

	if( not _bLearned )then
		_ItemButton:Disable()
		_Name:SetColor( 0.5, 0.5, 0.5 )
		_LV:SetColor( 0.5, 0.5, 0.5 )
	end

end

function Classes.RaiseSkill(parent, skill_id,skill_min,skill_max)
    CPSkillLevelUpFrame.level = CP.Unit.skills[skill_id] or 0
    CPSkillLevelUpFrame.skill = skill_id
    CPSkillLevelUpFrame.skill_max = skill_max

    local name = TEXT("Sys"..skill_id.."_name")
    CPSkillLevelUpFrameSkillName:SetText(name)

    CPSkillLevelUpFrameLevelBarLow:SetText(skill_min)
    CPSkillLevelUpFrameLevelBarHigh:SetText(skill_max)
    CPSkillLevelUpFrameLevelBar:SetValueStepMode("INT")
    CPSkillLevelUpFrameLevelBar:SetMinMaxValues(skill_min,skill_max)
    CPSkillLevelUpFrameLevelBar:SetValue(CPSkillLevelUpFrame.level)

    CPSkillLevelUpFrame:ClearAllAnchors()
    CPSkillLevelUpFrame:SetAnchor("LEFT", "RIGHT",parent:GetName(), 10,-40)

    GameTooltip_SkillLevelUp:SetOwner( CPSkillLevelUpFrame, "ANCHOR_BOTTOM", 0, 1 )
    CPSkillLevelUpFrame:Show()
    GameTooltip:Hide()

    Classes.RaiseSkill_Update()
end

function Classes.RaiseSkill_Okay()
    if CPSkillLevelUpFrame.level>0 then
        CP.Unit.skills[CPSkillLevelUpFrame.skill] = CPSkillLevelUpFrame.level
    else
        CP.Unit.skills[CPSkillLevelUpFrame.skill] = nil
    end

    CPSkillLevelUpFrame:Hide()
    GameTooltip_SkillLevelUp:Hide()
    Classes.UpdateList()
end

function Classes.RaiseSkill_Update()

    if CPSkillLevelUpFrame.level<0 then
        CPSkillLevelUpFrame.level = 0
    end
    if CPSkillLevelUpFrame.level>CPSkillLevelUpFrame.skill_max then
        CPSkillLevelUpFrame.level = CPSkillLevelUpFrame.skill_max
    end

    local this = CPSkillLevelUpFrame
    local lvl = CPSkillLevelUpFrame.level
    local costs = CP.DB.GetTPCosts(this.skill,lvl)
    local spend = CP.DB.GetTPTotalCosts(this.skill,lvl)
    local rest = CP.DB.GetTPTotalCosts(this.skill,CPSkillLevelUpFrame.skill_max)-spend

    CPSkillLevelUpFrameValueText:SetText(lvl)
    CPSkillLevelUpFrameLevelBar:SetValue(lvl)
    CPSkillLevelUpFrameCost:SetText(CP.Utils.FormatThousands(costs))
    CPSkillLevelUpFrameLevelBarSpend:SetText(CP.Utils.FormatThousands(spend))
    CPSkillLevelUpFrameLevelBarRest:SetText(CP.Utils.FormatThousands(rest))

    local name = TEXT("Sys"..(this.skill).."_name") .."+"..lvl
    GameTooltip_SkillLevelUp:SetText(name)
    --[===[@debug@
    GameTooltip_SkillLevelUp:AddLine("id: "..this.skill)
    --@end-debug@]===]
    local col = CPColor.New(0,0.75,0.95)
    local col_val = col:Brightness(1.5)
    GameTooltip_SkillLevelUp:AddLine(CP.DB.GetSpellDesc(this.skill,lvl,col_val:Code()), col:Get())
    GameTooltip_SkillLevelUp:Show()
end

function Classes.RaiseSkill_Modify(delta)
    CPSkillLevelUpFrame.level = CPSkillLevelUpFrame.level+delta
    Classes.RaiseSkill_Update()
end

function Classes.RaiseSkill_OnSlider(this, arg1)
    CPSkillLevelUpFrame.level = arg1
    Classes.RaiseSkill_Update()
end

