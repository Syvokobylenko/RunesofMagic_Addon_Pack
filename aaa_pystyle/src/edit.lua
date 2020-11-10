local me = {}
function me.onLoad(frame) frame.SetPlaceholder = me.SetPlaceholder end

function me.SetPlaceholder(frame, text)
    local ph = _G[frame:GetName() .. "_placeholder"]
    ph:SetText(text)
end

if not PyStyle then PyStyle = {} end
PyStyle.edit = me
