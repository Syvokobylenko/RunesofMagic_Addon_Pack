--[[
    WaitTimer
        A simple and easy timer class

    by McBen
        Web: http://rom.curseforge.com/addons/waittimer/
        Rep: git://git.curseforge.net/rom/waittimer/mainline.git


    Init:
        local WaitTimer = LibStub("WaitTimer")

    Example:
        -- simple delayed call
        WaitTimer.Delay(5, function () DEFAULT_CHAT_FRAME:AddMessage("huhu") end)

        -- repeatable call
        id = WaitTimer.Delay(10, function ()
                            DEFAULT_CHAT_FRAME:AddMessage("spam")
                            return 10
                        end)
        ...
        WaitTimer.Stop(id)

        -- with user data
        funtion pout(txt) DEFAULT_CHAT_FRAME:AddMessage(txt) end
        WaitTimer.Delay(1, pout, nil, "3")
        WaitTimer.Delay(2, pout, nil, "2")
        WaitTimer.Delay(3, pout, nil, "1")

        -- wait
        WaitTimer.Call(worker)

        function worker()
            DEFAULT_CHAT_FRAME:AddMessage("ready")
            Timer.CallWait(1)
            DEFAULT_CHAT_FRAME:AddMessage("set")
            Timer.CallWait(1)
            DEFAULT_CHAT_FRAME:AddMessage("go")
        end


    Usage:

        timer_id = WaitTimer.Delay(seconds, function, id, data)
        ================================================

        - seconds=  how long to wait
        - function= will be called when time is elapsed
            if the function returns a value, this value is used as new wait_time.
        - id= (optional) a fixed timer id
            If another timer with the same ID exists it will be replaced.
            You may use any kind of value.
        - data= (optional) will be passed to the function call

        - timer_id= id which can be used in the other functions
            It's equal "id" when it was provided


        WaitTimer.Stop(id)
        ===================
        - stops the timer without calling the function


        resttime = WaitTimer.Remaining(id)
        ==================================
        - @return remaining seconds
                  or nil
        - also use it to test if a timer is running


        WaitTimer.SetTime(id, delay)
        ==================================
        - reset the delay time
        - if <delay> is ommited the function will be triggert on next update



        id = WaitTimer.Call(fct, data)
        ==================================
        - will call "fct(data)"
        - required for using "CallWait"
        - the ID can be used for a "CallAbort" call

        WaitTimer.CallWait(time)
        ==================================
        - pause function for 'time' seconds
        - ! only usable if the function was called by "WaitTimer.Call" !

        WaitTimer.CallAbort(id)
        ==================================
        - abort the 'Call'


    GameTooltip
        for delayed tooltips replace
            GameTooltip:Show()  with   GameTooltip:DelayShow()
            GameTooltip:Hide()  with   GameTooltip:DelayHide()


    Setup:
        simply copy theses files to your addon or any subdirectory of it
            LibStub.lua
            WaitTimer.lua
            WaitTimer.toc

--]]
local Timer = LibStub:NewLibrary("WaitTimer", 12)
if not Timer then
    -- for ReloadUI()
    if not GameTooltip.DelayShow then
        Timer =  LibStub("WaitTimer")
        Timer.ReInit()
    end
    return
end

WaitTimerUpdateFrame = nil

local Timer_events={}
local last_id=1000

local function FindID(id)
    for i,data in ipairs(Timer_events) do
        if data[2]==id then return i,data end
    end
end

local function NextID()
    local id

    repeat
        id = last_id
        last_id = last_id+1
    until FindID(id)==nil

    return id
end

local function StartUpdate()
    if not WaitTimerUpdateFrame then
        local frame = CreateUIComponent("Frame", "WaitTimerUpdateFrame", "UIParent")
        frame:SetScripts("OnUpdate",[=[ WaitTimerOnUpdate(this,elapsedTime)]=])
    end

    WaitTimerUpdateFrame:Show()
end

local function StopUpdate()
    if TimerUpdateFrame then
        TimerUpdateFrame:Hide()
    end
end

local function TestIfAllDone()
    if #Timer_events==0 then
        StopUpdate()
    end
end

local function TriggerEvent(events, elapsedTime)
    local something_to_remove=false
    for i,data in ipairs(events) do

        data[1] = data[1]-elapsedTime

        if data[1]<0 then
            local good, next_delay = pcall(data[3],data[4])

            if good and type(next_delay)=="number" then
                data[1] = math.max(0,next_delay)
            else
                if not good then
                    error("error in update call (id='"..tostring(data[2]).."'): "..next_delay,0)
                end

                if data[1]<0 then -- delay was reset in event function
                    something_to_remove=true
                end
            end
        end
    end

    if something_to_remove then
        for i=#events,1,-1 do
            if events[i][1]<0 then
                table.remove(events,i)
            end
        end
    end
end

function WaitTimerOnUpdate(this,elapsedTime)

    TriggerEvent(Timer_events, elapsedTime)

    TestIfAllDone()
end

function Timer.Delay(seconds, fct, id, data)

    if type(fct)~="function" then
        error("parameter 2 is not a function",1)
    end

    seconds = math.max(0,seconds)

    local _,cur_data = FindID(id)
    if cur_data then
        cur_data[1]=seconds
        cur_data[3]=fct
        cur_data[4]=data
        return
    end

    id = id or NextID()

    table.insert(Timer_events, {seconds, id, fct, data} )

    StartUpdate()

    return id
end

function Timer.Wait(seconds, fct, id, data) -- OBSOLETE
    return Timer.Delay(seconds, fct, id, data)
end

function Timer.Remaining(id)
    local _,cur_data = FindID(id)
    if cur_data then
        return cur_data[1]
    end
end

function Timer.SetTime(id,delay)
    local _,cur_data = FindID(id)
    if cur_data then
        cur_data[1] = (delay or 0)
    end
end

function Timer.Stop(id)
    local idx = FindID(id)
    if idx then
        table.remove(Timer_events,idx)

        TestIfAllDone()
    end
end

-------------------------------------
function Timer.Call(fct,data)

    local thread = coroutine.create(fct)
    local id = Timer.Delay(0,
        function ()
            local state, time = coroutine.resume(thread,data)
            if state then
                return time
            end
        end
    )

    return id
end

function Timer.CallWait(time)
    coroutine.yield(time or 0)
end

function Timer.CallAbort(id)
    Timer.Stop(id)
end

-------------------------------------
local SHOW_DELAY = 0.8
local RESHOW_TIME = 0.3
local function DoShow(window)
    window:Show()
end

function Timer.DelayShow(window, delay)
    if Timer.Remaining("wtd2_"..window:GetName()) then
        Timer.Stop("wtd2_"..window:GetName())
        DoShow(window)
        return
    end

    Timer.Delay(delay or SHOW_DELAY, DoShow, "wtd1_"..window:GetName(), window)
end

function Timer.DelayShowCancel(window)
    Timer.Stop("wtd1_"..window:GetName())
    if window:IsVisible() then
        Timer.Delay(RESHOW_TIME, function() end, "wtd2_"..window:GetName())
    end
end

function Timer.ReInit()
    GameTooltip.DelayShow = function (self)
        self:Hide() -- SetText triggers 'Show'
        Timer.DelayShow(self, delay)
    end

    GameTooltip.DelayHide= function (self) -- NB: 'Hide' is a C-Api function thus we shouldn't overload it
        Timer.DelayShowCancel(self)
        self:Hide()
    end

    WaitTimerUpdateFrame = nil
end
Timer.ReInit()

