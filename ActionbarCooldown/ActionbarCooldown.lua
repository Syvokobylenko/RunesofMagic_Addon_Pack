local ActionbarCooldown = {}
_G.ActionbarCooldown = ActionbarCooldown

ActionbarCooldown.correctTime = function(self, inputTime)
    local rawSeconds = ""
    local rawMinutes = ""
    local rawHours = ""
    local outputTime = ""
    if(inputTime <= 60) then
        return math.floor(inputTime)
    elseif(inputTime <= 3600) then
        rawSeconds = math.floor(((inputTime/60) - math.floor(inputTime/60)) * 60)
        if(rawSeconds < 10 and rawSeconds > 0) then
            rawSeconds = "0"..rawSeconds
        elseif(rawSeconds == 0) then
            rawSeconds = ""
        end
        outputTime = math.floor(inputTime/60).."m"..rawSeconds
        return outputTime
    elseif(inputTime > 3600) then
        rawHours = math.floor(inputTime/60/60)
        rawMinutes = math.floor(((inputTime/60/60) - math.floor(inputTime/60/60)) * 60)
        if(rawMinutes < 10 and rawMinutes > 0) then
            rawMinutes = "0"..rawMinutes
        elseif(rawMinutes == 0) then
            rawMinutes = ""
        end
        outputTime = rawHours.."h"..rawMinutes
        return outputTime
    end
end

function CooldownFrame_SetTime(this, duration, remaining)
    if ( duration > 0 or remaining > 0 ) then
        local h, m, s;
        local cooldownText = getglobal(this:GetName().."Text");
        local cooldownTexture = getglobal(this:GetName().."Texture");

        h = getglobal("UNIT_HOUR") or "h";
        m = getglobal("UNIT_MINUTE") or "m";
        s = getglobal("UNIT_SECOND") or "s";

        if ( remaining > 1 ) then
            cooldownText:SetText(ActionbarCooldown:correctTime(remaining))
        else
            cooldownText:SetText("");
        end


        cooldownTexture:SetCooldown(duration, remaining);
        this.starting = 1;
        this.duration = duration;
        this.remaining = remaining;
        this:Show();
    else
        this:Hide();
    end
end