local MoneyFrame={}
AAH.MoneyFrame=MoneyFrame

function MoneyFrame.SetFocusOrder(frame,_next, _previous)
    frame.nextFocus = _next
    frame.previousFocus = _previous
end

function MoneyFrame.OnTab(frame)
    local _next = frame:GetParent().nextFocus
    if IsShiftKeyDown() then
        _next = frame:GetParent().previousFocus
    end

    if not _next then
        if frame.ClearFocus then
            frame:ClearFocus()
        end
        return
    end

    if _next.SetFocus then
        if _next.SetFocus then
            _next:SetFocus()
        end
        return
    else
        MoneyFrame.OnFocus(_next)
    end
end


function MoneyFrame.OnFocus(frame)

    if not frame:IsVisible() then
        MoneyFrame.OnTab(frame)
        return
    end

	local frameName = frame:GetName()
	if frame.mode == "copper" then
		getglobal(frameName.."Gold"):SetFocus()
    else
		getglobal(frameName.."Account"):SetFocus()
    end
end

function MoneyFrame.SetMode(frame,mode)
	local frameName = frame:GetName()
	frame.mode = mode or "copper"
	if frame.mode == "copper" then
		getglobal(frameName.."Account"):Hide()
		getglobal(frameName.."Gold"):Show()
	else
		getglobal(frameName.."Account"):Show()
		getglobal(frameName.."Gold"):Hide()
	end
end

function MoneyFrame.OnTextChanged(frame)

    if MoneyFrame.IsValueValid(frame) then
        _G[frame:GetName().."Account"]:SetTextColor(1,1,1)
        _G[frame:GetName().."Gold"]:SetTextColor(1,1,1)
    else
        _G[frame:GetName().."Account"]:SetTextColor(1,0.4,0.4)
        _G[frame:GetName().."Gold"]:SetTextColor(1,0.4,0.4)
    end

	if frame.onvalueChangedFunc then
		frame.onvalueChangedFunc(frame)
	end
end

function MoneyFrame.ResetMoney(frame)
	_G[frame:GetName().."Account"]:SetText("")
	_G[frame:GetName().."Gold"]:SetText("")
    MoneyFrame.SetMode(frame,frame.mode)
end

function MoneyFrame.SetMoney(frame, amount)

    if amount and amount~=0 then
        local editbox = _G[frame:GetName().."Account"]
        if frame.mode == "copper" then
		    editbox = _G[frame:GetName().."Gold"]
        end

		editbox:SetText(AAH.Tools.FormatNumber(amount))
    else
        MoneyFrame.ResetMoney(frame)
    end
end

function MoneyFrame.GetMoney(frame, mode)
    mode = mode or frame.mode

    local amount=""
	if mode == "copper" then
		amount=_G[frame:GetName().."Gold"]:GetText()
	else
        amount=_G[frame:GetName().."Account"]:GetText()
	end

    return (AAH.Tools.ParseMoney(amount) or 0)
end

function MoneyFrame.IsValueValid(frame)
    local amount
	if frame.mode == "copper" then
		amount=_G[frame:GetName().."Gold"]:GetText()
	else
        amount=_G[frame:GetName().."Account"]:GetText()
	end

    return AAH.Tools.IsValidMoneyFormat(amount)
end

