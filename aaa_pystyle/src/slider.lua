local me = {}
function me.scroll(frame, delta)
    local step = delta / 120;
    if frame:GetValueStepMode() == "FLOAT" then
        step = step * (frame:GetMaxValue() - frame:GetMinValue()) / 100
    end
    frame:SetValue(frame:GetValue() - step)
end
function me.update(frame)
    local min, max = frame:GetMinMaxValues()
    local down = _G[frame:GetName() .. "ScrollDownButton"]
    local up = _G[frame:GetName() .. "ScrollUpButton"]
    if frame:GetValue() == min then
        up:Disable()
    else
        up:Enable()
    end
    if frame:GetValue() == max then
        down:Disable()
    else
        down:Enable()
    end
end
function me.init(frame)
    frame.update = me.update;
    frame.scroll = me.scroll
    frame:SetScripts("OnValueChanged", "this:_update()")
    frame:SetMinMaxValues(1, 1000)
end
if not PyStyle then PyStyle = {} end
PyStyle.slider = me
