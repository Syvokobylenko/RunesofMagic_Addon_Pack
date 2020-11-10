--[[
Sol by Alleris

Several utility functions that help addon development.
Many of these rely on certain naming conventions. For example,
the addon settings should be called <addonName>_Settings and
you should have a table called <addonName> with your functions
defined as <addonName>.<fnName>. Example:

MyAddon = {}
MyAddon.MyFunction = function(arg1)
    Sol.io.Print("Hello World")
end

See function comments for any additional preconditions.

To use Sol:
- Include Sol.lua and LibStub.lua with your addon's files 
- Add LibStub.lua followed by Sol.lua to your .toc, before any
files that use Sol
- Place this line at the top any files that use Sol:
local Sol = LibStub("Sol")

Example
-------
File stucture:
MyAddon/Libs/LibStub.lua
MyAddon/Libs/Sol.lua
MyAddon/MyAddon.toc
MyAddon/MyAddon.lua
MyAddon/MyAddon.xml

MyAddon.toc:
Libs/LibStub.lua
Libs/Sol.lua
MyAddon.lua
MyAddon.xml

MyAddon.lua:
local Sol = LibStub("Sol")
...


Sol API:
- http://theromwiki.com/index.php/Sol

--]]




local VERSION = "34"
local Sol = LibStub:NewLibrary("Sol", VERSION)

if not Sol then
    if _G.Sol and _G.Sol._help and _G.Sol._help.GetOrigReloadUI and 
        _G.Sol._help.GetOrigReloadUI() == ReloadUI then
        
        _G.Sol._help.HookReloadFunctions()
    end
    return	-- already loaded and no upgrade necessary
end


local UnHookReloadFunctions = function()
    if _G.Sol._help.GetOrigReloadUI then
        ReloadUI = _G.Sol._help.GetOrigReloadUI() 
    end
    
    if _G.Sol._help.GetOrigLogout then
        Logout = _G.Sol._help.GetOrigLogout()
    end
end

---- If we're replacing the current Sol, unhook ReloadUI and Logout
if _G.Sol and _G.Sol._help then
    UnHookReloadFunctions()
    
    if _G.Sol._help.GetOrigCancelLogout then
        CancelLogout = _G.Sol._help.GetOrigCancelLogout
    end
end



Sol.constants = {}
Sol.constants.VERSION = tonumber("1.".. VERSION)
Sol._help = {}
Sol._help.DEBUG = false -- *** Debug Flag *** --


Sol.animation = {}
Sol.chat = {}
Sol.color = {}
Sol.config = {}
Sol.hooks = {}
Sol.io = {}
Sol.math = {}
Sol.string = {}
Sol.table = {}
Sol.timers = {}
Sol.tooltip = {}
Sol.util = {}

Sol.data = {}
Sol.data.crafts = {}
Sol.data.frames = {}
Sol.data.items = {}
Sol.data.mobs = {}
Sol.data.quests = {}
Sol.data.skills = {}

Sol._help.Addons = Sol._help.Addons or {}

-- Keep old versions from erroring
Sol._help.UnHookAll = function() end

-- If replacing an older version of Sol, keep their hooks and timers
SolHooks = SolHooks or {}
SolTimers = SolTimers or {}

local savedHooks = nil

-------------------------------------------------------------------------------
-- Sol.animation --------------------------------------------------------------
-------------------------------------------------------------------------------
--[[
Animates a series of images

Note: This uses Sol.timers.ScheduleTimer. Please see the notes for that
function as they pertain to this one, as well.

Parameters:
+ addonName      - Your addon's name
+ frame          - Frame to animate images on
+ images         - A list of texture paths
+ fps            - How many frames per second to use for the animation
                   Defaults to Sol.constants.DEFAULT_FPS
+ onUpdateFnName - The name of the OnUpdate handler to use (optional)
                   Defaults to <addonName>_OnUpdate
+ onAnimationEndFn - Function to call when the animation finishes

                   
Returns:
+ true if the animation was setup successfully; else false

Post:
+ Calls frame.SetTexture for each image in the list; creates an image animation
--]]
Sol.animation.AnimateImage = function(addonName, frame, images, fps, onUpdateFnName, onAnimationEndFn)
    if not frame or not frame.SetTexture or not addonName or 
        not images or not Sol.util.IsValidFrame(frame) then
        return false
    end
    if not fps or fps <= 0 then
        fps = Sol.constants.DEFAULT_FPS
    end
    
    local imageIndex = 1
    local fn = function(addonName, timerID)
        frame:SetTexture(images[imageIndex])
        
        imageIndex = imageIndex + 1
        if imageIndex > #images then
            Sol.timers.RemoveTimer(addonName, timerID)
            if onAnimationEndFn then
                onAnimationEndFn(addonName, timerID, frame)
            end
        end
    end
    
    return nil ~= Sol.timers.ScheduleTimer(addonName, 0, fn, 1/fps, "AnimateSize", onUpdateFnName)
end

--[[
Animates a fade in or fade out (transparency) of a frame.

Note: This uses Sol.timers.ScheduleTimer. Please see the notes for that
function as they pertain to this one, as well.

Parameters:
+ addonName      - Your addon's name
+ frame          - Frame to fade
+ fadeToAlpha    - The alpha level to gradually change toward (between 0 and 1)
                   Defaults to 0 if current alpha > 0, or 1 otherwise
+ fps            - How many frames per second to use for the animation
                   Defaults to Sol.constants.DEFAULT_FPS
+ time           - How much time to take for the animation
                   Defaults to Sol.constants.DEFAULT_ANIMATION_TIME
+ onUpdateFnName - The name of the OnUpdate handler to use (optional)
                   Defaults to <addonName>_OnUpdate
+ onAnimationEndFn - Function to call when the animation finishes
                   
Returns:
+ true if the animation was setup successfully; else false

Post:
+ The frame's alpha will gradually change until it gets to the 'fadeToAlpha' value
--]]
Sol.animation.Fade = function(addonName, frame, fadeToAlpha, fps, time, onUpdateFnName, onAnimationEndFn)
    if not frame or not addonName or not Sol.util.IsValidFrame(frame) then
        return false
    end
    if not time or time <= 0 then
        time = Sol.constants.DEFAULT_ANIMATION_TIME
    end
    if not fps or fps <= 0 then
        fps = Sol.constants.DEFAULT_FPS
    end
    if not fadeToAlpha or fadeToAlpha < 0 or fadeToAlpha > 1 then
        fadeToAlpha = Sol.util.TernaryOp(frame:GetAlpha() > 0, 0, 1)
    end
    
    local alphaPerTick = (fadeToAlpha - frame:GetAlpha()) / (fps * time)
    local fn = function(addonName, timerID)
        frame:SetAlpha(frame:GetAlpha() + alphaPerTick)
        if math.abs(frame:GetAlpha() - fadeToAlpha) < Sol.constants.FLOATING_PT_PRECISION then
            Sol.timers.RemoveTimer(addonName, timerID)
            frame:SetAlpha(fadeToAlpha)
            if onAnimationEndFn then
                onAnimationEndFn(addonName, timerID, frame)
            end
        end
    end
    
    return nil ~= Sol.timers.ScheduleTimer(addonName, 0, fn, 1/fps, "AnimateFade", onUpdateFnName)
end

--[[
Animates a movement of a frame.

Note: This uses Sol.timers.ScheduleTimer. Please see the notes for that
function as they pertain to this one, as well.

Parameters:
+ addonName        - Your addon's name
+ frame            - Frame to move
+ moveToX          - The x position to gradually move toward. Defaults to 0
+ moveToY          - The y position to gradually change toward. Defaults to 0
+ fps              - How many frames per second to use for the animation
                     Defaults to Sol.constants.DEFAULT_FPS
+ time             - How much time to take for the animation
                     Defaults to Sol.constants.DEFAULT_ANIMATION_TIME
+ onUpdateFnName   - The name of the OnUpdate handler to use (optional)
                     Defaults to <addonName>_OnUpdate
+ onAnimationEndFn - Function to call when the animation finishes

Returns:
+ true if the animation was setup successfully; else false

Post:
+ The frame will gradually move toward the specified position
--]]
Sol.animation.Move = function(addonName, frame, moveToX, moveToY, fps, time, onUpdateFnName, onAnimationEndFn)
    if not frame or not addonName or not Sol.util.IsValidFrame(frame) then
        return false
    end
    if not time or time <= 0 then
        time = Sol.constants.DEFAULT_ANIMATION_TIME
    end
    if not fps or fps <= 0 then
        fps = Sol.constants.DEFAULT_FPS
    end
    if not moveToX then
        moveToX = 0
    end
    if not moveToY then
        moveToY = 0
    end
    
    local x, y = frame:GetPos()
    local xPerTick = (moveToX - x) / (fps * time)
    local yPerTick = (moveToY - y) / (fps * time)
    
    local fn = function(addonName, timerID)
        local x, y = frame:GetPos()
        frame:SetPos(x + xPerTick, y + yPerTick)
        
        x, y = frame:GetPos()
        if math.abs(x - moveToX) < Sol.constants.FLOATING_PT_PRECISION and
            math.abs(y - moveToY) < Sol.constants.FLOATING_PT_PRECISION then
            
            Sol.timers.RemoveTimer(addonName, timerID)
            if onAnimationEndFn then
                onAnimationEndFn(addonName, timerID, frame)
            end
        end
    end
    
    return nil ~= Sol.timers.ScheduleTimer(addonName, 0, fn, 1/fps, "AnimateSize", onUpdateFnName)
end

--[[
Animates a resize of a frame.

Note: This uses Sol.timers.ScheduleTimer. Please see the notes for that
function as they pertain to this one, as well.

Parameters:
+ addonName      - Your addon's name
+ frame          - Frame to resize
+ sizeToWidth    - The width to gradually change toward (>= 0). Defaults to 0
+ sizeToHeight   - The height to gradually change toward (>= 0). Defaults to 0
+ fps            - How many frames per second to use for the animation
                   Defaults to Sol.constants.DEFAULT_FPS
+ time           - How much time to take for the animation
                   Defaults to Sol.constants.DEFAULT_ANIMATION_TIME
+ sizeChildren   - If true, will attempt to resize all named children of frame
                   Will not work if frame width or height is <= 0
+ onUpdateFnName - The name of the OnUpdate handler to use (optional)
                   Defaults to <addonName>_OnUpdate
+ onAnimationEndFn - Function to call when the animation finishes
                   
Returns:
+ true if the animation was setup successfully; else false

Post:
+ The frame's size (and optionally, its named children) will gradually change 
until it gets to the specified value
--]]
Sol.animation.Resize = function(addonName, frame, sizeToWidth, sizeToHeight, fps, time, sizeChildren, onUpdateFnName, onAnimationEndFn)
    if not frame or not addonName or not Sol.util.IsValidFrame(frame) then
        return false
    end
    if not time or time <= 0 then
        time = Sol.constants.DEFAULT_ANIMATION_TIME
    end
    if not fps or fps <= 0 then
        fps = Sol.constants.DEFAULT_FPS
    end
    if not sizeToWidth or sizeToWidth < 0 then
        sizeToWidth = 0
    end
    if not sizeToHeight or sizeToHeight < 0 then
        sizeToHeight = 0
    end
    if frame:GetWidth() <= 0 or frame:GetHeight() <= 0 then
        sizeChildren = false
    end
    
    
    local frames = fps * time
    local widthPerTick = (sizeToWidth - frame:GetWidth()) / frames
    local heightPerTick = (sizeToHeight - frame:GetHeight()) / frames
    
    local traverseFn = nil
    local childSizes = {}
    if sizeChildren then
        local widthFactor = sizeToWidth / frame:GetWidth()
        local heightFactor = sizeToHeight / frame:GetHeight()
        
        Sol.data.frames.SetupFrameHierarchy()
        traverseFn = function(node, parent, level)
            local widthPerTick = (node:GetWidth() * widthFactor - node:GetWidth()) / frames
            local heightPerTick = (node:GetHeight() * heightFactor - node:GetHeight()) / frames
            
            childSizes[node] = {widthPerTick, heightPerTick}
        end
        Sol.data.frames.TraverseFrameHierarchy(traverseFn, frame)
        
        traverseFn = function(node, parent, level)
            local widthPerTick, heightPerTick = unpack(childSizes[node])
            node:SetSize(node:GetWidth() + widthPerTick, node:GetHeight() + heightPerTick)
        end
    end
        
    
    local fn = function(addonName, timerID)
        frame:SetSize(frame:GetWidth() + widthPerTick, frame:GetHeight() + heightPerTick)
        
        if math.abs(frame:GetWidth() - sizeToWidth) < Sol.constants.FLOATING_PT_PRECISION and
            math.abs(frame:GetHeight() - sizeToHeight) < Sol.constants.FLOATING_PT_PRECISION then
            
            Sol.timers.RemoveTimer(addonName, timerID)
            
            if onAnimationEndFn then
                onAnimationEndFn(addonName, timerID, frame)
            end
        end
        if sizeChildren then
            Sol.data.frames.TraverseFrameHierarchy(traverseFn, frame)
        end
    end
    
    return nil ~= Sol.timers.ScheduleTimer(addonName, 0, fn, 1/fps, "AnimateSize", onUpdateFnName)
end


--[[
Animates a scaling of a frame.

Note: This uses Sol.timers.ScheduleTimer. Please see the notes for that
function as they pertain to this one, as well.

Parameters:
+ addonName      - Your addon's name
+ frame          - Frame to scale
+ scale          - The scale to end at (>= 0). Defaults to 0
+ fps            - How many frames per second to use for the animation
                   Defaults to Sol.constants.DEFAULT_FPS
+ time           - How much time to take for the animation
                   Defaults to Sol.constants.DEFAULT_ANIMATION_TIME
+ onUpdateFnName - The name of the OnUpdate handler to use (optional)
                   Defaults to <addonName>_OnUpdate
+ onAnimationEndFn - Function to call when the animation finishes
                   
Returns:
+ true if the animation was setup successfully; else false

Post:
+ The frame's scale will gradually change until it gets to the specified value
--]]
Sol.animation.Scale = function(addonName, frame, scale, fps, time, onUpdateFnName, onAnimationEndFn)
    if not frame or not addonName or not Sol.util.IsValidFrame(frame) then
        return false
    end
    if not time or time <= 0 then
        time = Sol.constants.DEFAULT_ANIMATION_TIME
    end
    if not fps or fps <= 0 then
        fps = Sol.constants.DEFAULT_FPS
    end
    if not scale or scale < 0 then
        scale = Sol.util.TernaryOp(frame:GetScale() > 0, 0, 1)
    end
    
    local scalePerTick = (scale - frame:GetScale()) / (fps * time)
    local fn = function(addonName, timerID)
        frame:SetScale(frame:GetScale() + scalePerTick)
        if math.abs(frame:GetScale() - scale) < Sol.constants.FLOATING_PT_PRECISION then
            Sol.timers.RemoveTimer(addonName, timerID)
            frame:SetScale(scale)
            if onAnimationEndFn then
                onAnimationEndFn(addonName, timerID, frame)
            end
        end
    end
    
    return nil ~= Sol.timers.ScheduleTimer(addonName, 0, fn, 1/fps, "AnimateScale", onUpdateFnName)
end

-------------------------------------------------------------------------------
-- Sol.chat -------------------------------------------------------------------
-------------------------------------------------------------------------------
--[[
Find the first chat frame that has the specified name

Parameters:
+ name - the name of the chat frame to look for
--]]
Sol.chat.FindChatTabByName = function(name)
    for chatIndex = 1, 10 do
        local tabText = _G["ChatFrame" .. chatIndex .. "TabText"]
        if tabText and tabText:GetText() == name then
            return _G["ChatFrame" .. chatIndex]
        end
    end
    return nil
end

-------------------------------------------------------------------------------
-- Sol.color ------------------------------------------------------------------
-------------------------------------------------------------------------------
--[[
Takes some text and applies the specified color to it

Parameters:
+ text     - Some string
+ hexColor - 6 hex characters [RRGGBB]

Note that this function doesn't support alpha. There's rarely a
good reason to use alpha text.
--]]
Sol.color.ColorText = function(text, hexColor)
    return "|cff" .. hexColor .. text .. "|r"
end

 
--[[
Takes some text and applies a color to it as specified by the r, g, b values

Parameters:
+ text     - Some string
+ r        - The amount of red in the color (betwen 0 and 1.0)
+ g        - The amount of green in the color (betwen 0 and 1.0)
+ b        - The amount of blue in the color (betwen 0 and 1.0)

Note that this function doesn't support alpha. There's rarely a
good reason to use alpha text. Additionally, any color values > 1 will
be treated as 1 and any values < 0 will be treated as 0
--]]
Sol.color.ColorTextRGB = function(text, r, g, b)
    return Sol.color.ColorText(text, Sol.color.ColorValuesToHexColor(r, g, b))
end

-- Converts specified percent (out of 1.0) color values to the equivalent RGB
-- hex representation
Sol.color.ColorValuesToHexColor = function(r, g, b, prefix)
    if not r or not g or not b 
        or type(r) ~= "number" 
        or type(g) ~= "number" 
        or type(b) ~= "number" then
        return nil
    end
    r = Sol.color.PercentToHex(r)
    g = Sol.color.PercentToHex(g)
    b = Sol.color.PercentToHex(b)
    if prefix then
        return "|cFF" .. r .. g .. b
    else
        return r .. g .. b
    end
end

-- Returns the hex version of the specified decimal number
Sol.color.DecimalToHex = function(decimal)
    if decimal > 15 then
        return "F"
    elseif decimal < 0 then
        return 0
    elseif decimal < 10 then
        return decimal
    else
        return string.char(decimal + 55)
    end
end

--[[
Get the hex color value of the specified (most likely tooltip) text 

Parameters:
+ text   - the text
+ colors - table of RGB color values { 1=R, 2=G, 3=B } (optional)

Returns:
+ the hexacdecimal value of the text color (e.g., FF0000 for red)
--]]
Sol.color.GetTextColor = function(text, colors)
    return 
        (colors and Sol.color.ColorValuesToHexColor(unpack(colors))) or 
        (text:sub(1, 2) == "|c" and text:sub(5, 10):upper())
end

-- Converts specified RGB hex representation
-- to the equivalent percent (out of 1.0) color values
Sol.color.HexColorToColorValues = function(hex)
    if #hex >= 10 and hex:upper():find("^|CFF%x%x%x%x%x%x.*") then
        hex = hex:sub(5, 10)
    end
    if #hex ~= 6 then
        return nil
    end

    r = Sol.color.HexToPercent(hex:sub(1, 2))
    g = Sol.color.HexToPercent(hex:sub(3, 4))
    b = Sol.color.HexToPercent(hex:sub(5, 6))
    return r, g, b
end

-- Converts specified two-digit hex value (out of 255) to a
-- decimal value (out of 1.0). A value of FF or more counts as 1.0 .
Sol.color.HexToPercent = function(hex)
    if not hex then
        return nil
    end
    if #hex > 2 then
        return 1
    end
    return Sol.math.HexToDec(hex) / 255
end

-- Converts specified decimal value (out of 1.0) to a two-digit
-- hex value (out of 255). A value of 1.0 or more counts as FF.
Sol.color.PercentToHex = function(percent)
    if not percent or type(percent) ~= "number" then
        return nil
    end
    if percent >= 1 then
        return "FF"
    end
    percent = percent * 255
    local c1 = math.floor(percent / 16)
    local c2 = math.floor(percent % 16)
    return Sol.color.DecimalToHex(c1) .. Sol.color.DecimalToHex(c2)
end


-------------------------------------------------------------------------------
-- Sol.config -----------------------------------------------------------------
-------------------------------------------------------------------------------
--[[
If your config page has multiple tabs, you can use this to switch
between them.

Parameters:
+ addonName - Your addon's name
+ tab       - The tab button to change to (frame element, not string)

Pre:
+ Your XML must have tabs and pages, the tabs most likely being buttons
and pages being the frames you'll be switching in and out using the tabs.
The pages must be named exactly the same as the tabs except wherever the
word "Tab" appears in the tab name, the word "Page" should appear in the
page frame (case-sensitive). For example:
<Button name="MyAddonTabsFrameTab1">...</Button>
<Frame name="MyAddonPagesFramePage1">...</Frame>

Post: 
+ Changes the tabs to make the selected one stand out and hides the
previous page and shows the new one.
--]]
Sol.config.ChangeTab = function(addonName, tab)
    local addon = Sol._help.CheckAddon(addonName)

    if addon.SelectedTab then
        local selectedPage = Sol._help.GetPageFromTab(addon.SelectedTab)
        if selectedPage then
            selectedPage:Hide()
        end
        addon.SelectedTab:Enable()
    end
    
    local page = Sol._help.GetPageFromTab(tab)
    if page then
        page:Show()
    end
    tab:Disable()

    addon.SelectedTab = tab
end

--[[
Checks if all the settings exist for this addon and if some don't,
sets them from the default settings. Sets up your addon's settings
to be saved (uses SaveVariables(<yourAddonSettings>))

Parameters:
+ addonName       - Your addon's name
+ defaultSettings - Your addon's default settings (key-value table)
+ settingsName    - If you don't want to use <addonName>_Settings,
                    you can specify which var you want to use, instead.
+ removeOld       - True to remove settings that are not in defaultSettings
                    Defaults to false
+ perCharacter    - Whether to save the settings variable per character

Pre: 
+ Your addon's settings table must be called <addonName>_Settings

Post:
+ Your addon's settings table will be setup to be saved to
SaveVariables.lua when the game saves all variables
--]]
Sol.config.CheckSettings = function(addonName, defaultSettings, settingsName, removeOld, perCharacter)
    local addon = Sol._help.CheckAddon(addonName)

    if not defaultSettings then
        defaultSettings = {}
    end

    if not settingsName then
        settingsName = Sol._help.GetAddonSettingsName(addonName)
    end
    if perCharacter then
        SaveVariablesPerCharacter(settingsName)
    else
        SaveVariables(settingsName)
    end

    local addonSettings = _G[settingsName]
    if not addonSettings then
        _G[settingsName] = defaultSettings
    else
        Sol._help.AddSettings(addonSettings, defaultSettings)
        if removeOld then
            Sol._help.RemoveSettings(addonSettings, defaultSettings)
        end
    end
end


--[[
Creates a slash chat command for the specified function.

Parameters:
+ command   - The shorthand command you want to use
+ fn        - The function to invoke for this command
+ slashName - The key to use for SlashCmdList. When adding multiple
              commands for the same function, use the same slashName.
              Can be nil to use command as the slashName
+ num       - When adding multiple commands for the same function,
              increment num for each.

Note that there will be two slash commands that execute fn:
/<command> and //<command>. This is merely for convenience.
--]]
Sol.config.CreateSlashCommand = function(command, fn, slashName, num)
    -- we'll add the slash later, so get rid of any existing ones
    command = command:gsub("/", ""):lower()

    if not slashName then
        slashName = command:upper()
    end
    if not num or num < 1 then
        num = 1
    end

    -- To allow us to seamlessly make two commands here (one for / and
    -- one for //), we need to change the numbering a bit s.t.
    -- (1 == 1), (2 == 3), (3 == 5), etc.
    num = num * 2 - 1

    _G["SLASH_" .. slashName .. num] = "/" .. command:lower()
    _G["SLASH_" .. slashName .. num+1] = "//" .. command:lower()

    SlashCmdList[slashName] = fn
end

--[[
Creates a slash chat command for your addon that will open/close
your config pages.

Parameters:
+ addonName - Your addon's name
+ frame     - Your config frame
+ command   - The shorthand command you want to use. A command for
              /<addonName> is automatically created, so this can be nil.
+ animateTime      - Amount of time to animate; leave nil to avoid animation
+ animateType      - The type of animation to run
+ onAnimationEndFn - A function to call after the animation is finished, if there is one

Post:
+ Entering /<addonName> and/or /<command> will open your config
frame if it's closed and close it if it's open.
--]]
Sol.config.CreateSlashToHandleConfig = function(addonName, frame, command, animateTime, animateType, onAnimationEndFn)
    local addon = Sol._help.CheckAddon(addonName)
    if not Sol.util.IsValidFrame(frame) then
        return
    end

    addon.frame = frame
    local fn = function(editBox, msg)
        if animateTime and animateTime ~= 0 then
            Sol.util.ToggleVisibility(addon.frame, addonName, animateTime, animateType, onAnimationEndFn)
        else
            ToggleUIFrame(addon.frame)
        end
    end

    addonName:gsub("/", "")
    local slashName = addonName:upper()

    Sol.config.CreateSlashCommand(addonName, fn, slashName, 1)
    if command then
        Sol.config.CreateSlashCommand(command, fn, slashName, 2)
    end
end

--[[
getopt, POSIX style command line argument parser
param arg contains the command line arguments in a standard table.
param options is a string with the letters that expect string values.
returns a table where associated keys are true, nil, or a string value.
The following example styles are supported
  -a one  ==> opts["a"]=="one"
  -bone   ==> opts["b"]=="one"
  -c      ==> opts["c"]==true
  --c=one ==> opts["c"]=="one"
  -cdaone ==> opts["c"]==true opts["d"]==true opts["a"]=="one"
note POSIX demands the parser ends at the first non option
     this behavior isn't implemented.

Example:
opts = Sol.config.GetParameters( arg, "ab" )
for k, v in pairs(opts) do
  print( k, v )
end

Contributed by Xylch (aka h3x3dg0d)
--]]
Sol.config.GetParameters = function(arg, options)
  local tab = {}
  for k, v in ipairs(arg) do
    if string.sub( v, 1, 2) == "--" then
      local x = string.find( v, "=", 1, true )
      if x then tab[ string.sub( v, 3, x-1 ) ] = string.sub( v, x+1 )
      else      tab[ string.sub( v, 3 ) ] = true
      end
    elseif string.sub( v, 1, 1 ) == "-" then
      local y = 2
      local l = string.len(v)
      local jopt
      while ( y <= l ) do
        jopt = string.sub( v, y, y )
        if string.find( options, jopt, 1, true ) then
          if y < l then
            tab[ jopt ] = string.sub( v, y+1 )
            y = l
          else
            tab[ jopt ] = arg[ k + 1 ]
          end
        else
          tab[ jopt ] = true
        end
        y = y + 1
      end
    end
  end
  return tab
end

--[[
Attempts to setup your config screen based on your addon's settings.
You may still have to set some values manually. Make sure to check
all your settings thuroughly!

Parameters:
+ addonName   - Your addon's name
+ selectedTab - The tab button for the page that's selected initially

IMPORTANT: SEE Sol.config.SaveConfig for PRE conditions!
--]]
Sol.config.LoadConfig = function(addonName, selectedTab)
    local addon = Sol._help.CheckAddon(addonName)
    local addonSettings = Sol._help.GetAddonSettings(addonName)

    if selectedTab then
        Sol.config.ChangeTab(addonName, selectedTab)
    end

    Sol._help.ConfigLoad(addonName, addonSettings)
end


--[[
Restores the frame's previously saved (using Sol.config.SaveFrameBounds) 
size and position. Typically called on variables loaded

Parameters:
+ addonName  - Your addon's name
+ frame      - The frame whose bounds to restore
+ ignoreSize - True to not restore frame size, only position

Post:
+ The frame's size and positions will be set to whatever it was when
Sol.config.SaveFrameBounds was last called on it
--]]
Sol.config.RestoreFrameBounds = function(addonName, frame, ignoreSize)
    local addon = Sol._help.CheckAddon(addonName)
    if not addonName or not Sol.util.IsValidFrame(frame) then
        return
    end
    
    local varName = addonName .. "_" .. frame:GetName() .. "_Position"
    
    if _G[varName] then
        -- Ensure the variable persists through restarts, even if save isn't
        -- called again
        SaveVariables(varName)
        
        local scale = GetUIScale()
        frame:ClearAllAnchors()
        frame:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", 
            _G[varName][1] / scale, 
            _G[varName][2] / scale)
        if not ignoreSize then
            frame:SetSize(_G[varName].width, _G[varName].height)
        end
    end
end

--[[
Attempts to go through your config screen and save the displayed
values to your addon settings table. You may still have to set some
settings manually. Make sure to check all your settings thuroughly!

Note: it actually goes through your addon settings table and uses
that to try to find xml elements that match the settings.

Parameters:
+ addonName - Your addon's name
+ hideInfoMsg - hide "AddonName settings saved." message

Pre:
+ For this to work, you must have very specific naming for
your config xml entries. Specifically:
- Boolean widgets like checkboxes - <addonName>Config_Toggle<SettingName>
- String widgets like textboxes   - <addonName>Config_Text<SettingName>
- Numeric widgets like sliders    - <addonName>Config_Number<SettingName>
- Dropdowns are special numeric   - <addonName>Config_Dropdown<SettingName>

Post:
+ Hopefully, all or most of your addon's settings will be
set, based on your config screen. However, some may not be, so
again, check the settings before you distribtue.
--]]
Sol.config.SaveConfig = function(addonName, hideInfoMsg)
    local addon = Sol._help.CheckAddon(addonName)
    local addonSettings = Sol._help.GetAddonSettings(addonName)

    Sol._help.ConfigSave(addonName, addonSettings)

    SaveVariables(Sol._help.GetAddonSettingsName(addonName))

    if not hideInfoMsg then
        Sol.io.Print(addonName .. " settings saved.")
    end
end

--[[
Saves the frame's size and position, to be restored later (e.g., upon next 
login) using Sol.config.RestoreFrameBounds. Typically called when the user
stops moving the frame (OnMouseUp)

Parameters:
+ addonName    - Your addon's name
+ frame        - The frame whose bounds to save
+ perCharacter - Whether to save the settings variable per character

Post:
+ The frame's size and positions will be saved in SavedVariables
--]]
Sol.config.SaveFrameBounds = function(addonName, frame, perCharacter)
    local addon = Sol._help.CheckAddon(addonName)
    if not addonName or not Sol.util.IsValidFrame(frame) then
        return
    end
    frame:StopMovingOrSizing()
    
    local varName = addonName .. "_" .. frame:GetName() .. "_Position"
    _G[varName] = { frame:GetPos() }
    _G[varName].width, _G[varName].height = frame:GetSize()
    if perCharacter then
        SaveVariablesPerCharacter(varName)
    else
        SaveVariables(varName)
    end
end

--[[
Initializes a dropdown with the specified values and makes sure it functions
correctly.

Parameters:
+ dropdown       - The dropdown frame to setup
+ values         - A table of values to use in the dropdown; can be either a list of
                   strings or of tables. In the latter case, the tables must have a 
                   name field
+ selectedIndex  - Which value to select initially; doesn't matter if you use
                   Sol.config.LoadConfig afterwards (and your naming is as described
                   in Sol.config.SaveConfig). Defaults to the first item
+ width          - Width of the dropdown frame; defaults to 100
+ onSelectScript - Custom script to run when an item is selected. Signature:
                   onSelectScript = function(dropdown, selectedIndex, selectedValue)
                   
Post: 
+ dropdown is initialized with values, its width and selected item are set, and
clicking an item will check it in the dropdown and optionally call onSelectScript
with the dropdown, selected id, and selected value as the parameters
--]]
Sol.config.SetupDropdown = function(dropdown, values, selectedIndex, width, onSelectScript)
    if not dropdown or not values then
        return
    end
    if not width then 
        width = 100
    end
    if not selectedIndex then
        selectedIndex = 1
    end
    
    local selectFn = function(button)
        UIDropDownMenu_SetSelectedID(dropdown, button:GetID())
        if onSelectScript and type(onSelectScript) == "function" then
            onSelectScript(dropdown, button:GetID(), values[button:GetID()])
        end
    end
    local onShowFn = function()
        for _, v in pairs(values) do
            local name = Sol.util.TernaryOp(type(v) == "table" and v.name, v.name, tostring(v))
            UIDropDownMenu_AddButton({["text"] = name, ["func"] = selectFn})
        end
    end
    
    UIDropDownMenu_SetWidth(dropdown, width)
    UIDropDownMenu_Initialize(dropdown, onShowFn)
    UIDropDownMenu_SetSelectedID(dropdown, selectedIndex)
end

-------------------------------------------------------------------------------
-- Sol.data.crafts ------------------------------------------------------------
-------------------------------------------------------------------------------
--[[
Get the materials needed to craft the specified item

Parameters:
+ itemName - the name of the crafted item 

Returns:
+ a table of item data, each entry being the return values of GetCraftRequestItem

Example:
local mats = Sol.data.crafts.GetCraftMaterials("Basic Medicine")
for index, data in pairs(mats) do
    Sol.io.Print(data.texture)
    Sol.io.Print(data.name)
    Sol.io.Print(data.amountNeeded)
    Sol.io.Print(data.amountInInventory)
end
--]]
Sol.data.crafts.GetCraftMaterials = function(itemName)
    local retVal = {}
    local craftSkill, subType, craftItem = Sol.data.crafts.GetCraftSkillIndeces(itemName)
    if not craftItem then
        return nil
    end
    
    local _, name, _, id = GetCraftItem(craftSkill, subType, craftItem)
    for i = 1, GetCraftRequestItem(id, -1) do
        local itemName, itemTexture, itemCount, itemTotal = GetCraftRequestItem(id, i)
        retVal[i] = { 
            name = itemName, 
            texture = itemTexture, 
            amountNeeded = itemCount, 
            amountInInventory = itemTotal
        }
    end
    return retVal
end

--[[
Get the indeces used to access a craft item. 
NOTE: Improper usage of craft indeces could crash your game. Using the indeces
provided by this function will ensure you don't go out of bounds.

Parameters:
+ itemName - name of the crafted item

Returns:
+ the crafting skill index
+ the crafting sub-type index
+ the crafting item index

Example:
local skill, type, item = Sol.data.crafts.GetCraftSkillIndeces("Ventis Crown")
Sol.io.PrintTable{ GetCraftItem(skill, type, item) }
--]]
Sol.data.crafts.GetCraftSkillIndeces = function(itemName)
    for craftSkill = 1, GetCraftItemList(-1) do
        for subType = 1, GetCraftSubType(craftSkill, -1) do
            for craftItem = 1, GetCraftItem(craftSkill, subType, -1) do
                local _, name = GetCraftItem(craftSkill, subType, craftItem)
                if name == itemName then
                    return craftSkill, subType, craftItem
                end
            end
        end
    end
end

--[[
Return the index for the specified crafting skill, used in GetCraftSubType, etc

Parameters:
+ craftName - the craft skill name (e.g., "Blacksmithing"

Returns:
+ the craft's index or nil if invalid craft type
--]]
Sol.data.crafts.GetCraftTypeIndex = function(craftName)
    for craftSkill = 1, GetCraftItemList(-1) do
        local CraftTypeID, CraftTypeName = GetCraftItemType( craftSkill )
        if craftName == CraftTypeName then
            return craftSkill
        end
    end
end


-------------------------------------------------------------------------------
-- Sol.data.frames ------------------------------------------------------------
-------------------------------------------------------------------------------
--[[
Prints a frames children. Reuiqres Sol.data.frames.SetupFrameHierarchy to have 
run at least once

Parameters:
+ printFn    - The function used for printing
               Signature: function(printFrame, string)
+ frame      - The frame whose children to print
+ printFrame - The frame to print to, if any.
--]]
Sol.data.frames.PrintChildren = function(printFn, frame, printFrame)
    if not frame or not frame.__SolChildren__  then
        return
    end
    for _, child in ipairs(frame.__SolChildren__) do
        printFn(printFrame, child:GetName())
    end
end

--[[
Prints all the global frames and their children, and their children, etc.
I.e., prints the frame tree. Creates the hierarchy first, if necessary.

Parameters:
+ printFn      - The function used for printing. If not specified, will try
                 some known text functions on printFrame but will error if
                 none are found.
+ printFrame   - The frame to print to. Not used if printFn is set. Otherwise,
                 if printFn and printFrame are nil, prints to DEFAULT_CHAT_FRAME
+ printSpacing - True to add a number of spaces to the begining of a line
                 depending on how far down in the tree the current node is.
                 Default is true.

Example: Sol.data.frames.PrintFrameHierarchy(nil, Sol.util.FindDebugFrame(), false, PlayerFrame)
--]]
Sol.data.frames.PrintFrameHierarchy = function(printFn, printFrame, printSpacing, rootFrame)
    if not printFrame then
        printFrame = DEFAULT_CHAT_FRAME
    end
    if not printFn then
        if printFrame.AddMessage then
            printFn = printFrame.AddMessage
        elseif printFrame.AddLine then
            printFn = printFrame.AddLine
        elseif printFrame.SetText then
            printFn = printFrame.SetText
        else
            Sol.Error("Could not find print function for frame " .. printFrame:GetName())
            return
        end
    end

    if printSpacing == nil then
        printSpacing = true
    end

    if not rootFrame then
        rootFrame = WorldFrame
    end

    local callback = function(frame, parentFrame, level)
        local msg = frame:GetName()
        if printSpacing then
            local spacing = ""
            for i = 1, level do
                spacing = spacing .. "  "
            end
            msg = spacing .. msg
        end
        if printFn ~= printFrame.SetText then
            printFn(printFrame, msg)
        else
            printFn(printFrame, printFrame:GetText() .. ("\n" .. msg))
        end
    end

    Sol.data.frames.TraverseFrameHierarchy(callback, rootFrame, nil)
end

--[[
Goes through the list of global frames and creates a list of each of their
children. Stores this list as frame.__SolChildren__

This function is required for most or all of the other functions in this
section.
--]]
Sol.data.frames.SetupFrameHierarchy = function()

    -- Clears out an existing hierarchy in case it's stale
    if WorldFrame.__SolChildren__ then
        for k, v in pairs(_G) do
            if v and type(v) == "table" and v.__SolChildren__ then
                v.__SolChildren__ = {}
            end
        end
    end

    -- Goes through all global frames and adds them as children to their parents __SolChildren__ list
    for k, v in pairs(_G) do
        if Sol.util.IsValidFrame(v, k) then
            local parent = v:GetParent()

            if parent then
                if not parent.__SolChildren__ then
                    parent.__SolChildren__ = {}
                end
                table.insert(parent.__SolChildren__, v)
            end
        end
    end
end

--[[
Sorts all the __SolChildren__ in the hierarchy according to
sortFn, or alphabetically if sortFn is not given.

Parameters:
sortFn - A function that determines sort order. See Sol.data.frames.TraverseFrameHierarchy
         fn parameter for sortFn parameters. Default is just table.sort with an
         alphabetic sort on frame names.

WARNING: This can take quite a bit of time!
--]]
Sol.data.frames.SortFrameHierarchy = function(sortFn)
    if not sortFn then
        local compFn = function(tblA, tblB)
            return tblA:GetName():lower() < tblB:GetName():lower()
        end
        sortFn = function(node, parent, level)
            if node.__SolChildren__ then
                table.sort(node.__SolChildren__, compFn)
            end
        end
    end
    Sol.data.frames.TraverseFrameHierarchy(sortFn, WorldFrame)
end

--[[
Traverse a frame hierarchy created with Sol.data.frames.SetupFrameHierarchy,
calling fn for each node. Starts at root.


Parameters:
+ fn       - The callback function that will be used for every node in the tree.
             It should have the following signature:
             function(node, parentNode, treeLevel)
             ~~ node       - the node being examined
             ~~ parentNode - that node's parent
             ~~ level      - how far down in the tree this node is
+ root     - The node to start traversing at.
+ level    - The node level at the start of the traversal. This will be
             incremented as we go deeper into the tree and is passed to fn
             as one of the parameters.

Note: Requires Sol.data.frames.SetupFrameHierarchy to be run first
--]]
Sol.data.frames.TraverseFrameHierarchy = function(fn, root, level)
    if not root then
        return
    end
    if not level then
        level = 1
    end

    if root.__SolChildren__ then
        for _, child in ipairs(root.__SolChildren__) do
            fn(child, root, level)
            Sol.data.frames.TraverseFrameHierarchy(fn, child, level + 1)
        end
    end
end

--[[
Runs through the frames hierarchy and adds a Function Watch
to any that has the specified function. For example,
Sol.util.WatchAllFramesForFn("Show") will tell you any time a frame is shown.

Requires FunctionWatch addon.

Parameters:
+ fnName - The name of the function to watch

--]]
Sol.data.frames.WatchAllFramesForFn = function(fnName)
    if not FunctionWatch_AddFunction then
        Sol.io.Error("Must have FunctionWatch addon")
        return
    end
    local callback = function(frame, parent, level)
        if frame and frame[fnName] then
            FunctionWatch_AddFunction(fnName, frameName)
        end
    end

    Sol.data.frames.TraverseFrameHierarchy(callback, WorldFrame)
end

--[[
Runs through the global list of frames (and not any of their subframes)
and adds a Function Watch to any that has the specified function. For example,
Sol.util.WatchAllFramesForFn("Show") will tell you any time a frame is shown.

Requires FunctionWatch addon.

Parameters:
+ fnName - The name of the function to watch

--]]
Sol.data.frames.WatchTopLevelFrames = function(fnName)
    if not FunctionWatch_AddFunction then
        return
    end
    if not UIParent.__SolChildren__ then
        Sol.data.frames.SetupFrameHierarchy()
    end
    for i, v in ipairs(UIParent.__SolChildren__) do
        if v[fnName] then
            FunctionWatch_AddFunction(fnName, v)
        end
    end
end

-------------------------------------------------------------------------------
-- Sol.data.items -------------------------------------------------------------
-------------------------------------------------------------------------------
--[[
Finds the first empty bag slot in the specified bag. If no bag is specified,
searches first two bags (can't test others)

Parameters:
+ bagIndex - 0 for Bag I, 1 for Bag II, etc

Returns:
+ the inventory index of the first empty slot (used by GetBagItemLink)
+ the bag index of the first empty slot (used by GetBagItemInfo)
--]]
Sol.data.items.FindEmptyBagSlot = function(bagIndex)
    local maxItems = 30
    local offset = 0
    if not bagIndex then
        _, maxItems = GetBagCount()
    else
        offset = bagIndex * maxItems
    end
    
    for i = 1, maxItems do
        local index, file = GetBagItemInfo(offset + i)
        if not file or file == "" then
            return index, i
        end
    end
end

--[[
Get the stats/attributes of an item (e.g., +22.0 Stamina)

Parameters:
+ index   - The bag index of the item, as used by GetBagItemInfo
+ tooltip - Optionally specify a tooltip to use; default is GameTooltip

Returns:
+ A table of attribute data for the specified item

Example:
local slots = Sol.data.items.GetBagSlots("Fusion Stone")
for slot, data in pairs(slots) do
    local attribs = Sol.data.items.GetBagItemAttributes(slot, MyTooltip)
    for _, attr in pairs(attribs) do
        Sol.io.Print(attr)
    end
end
--]]
Sol.data.items.GetBagItemAttributes = function(index, tooltip)
    index = GetBagItemInfo(index)
    if not tooltip then
        tooltip = GameTooltip
    end
    Sol.tooltip.ClearAllText(tooltip)
    tooltip:SetBagItem(index)
    tooltip:Hide()
    
    local attributes = {}
    local lines = Sol.tooltip.ReadTooltip(tooltip)
    for _, line in pairs(lines.left) do
        if line.color and
            (line.color[1] == 1 or line.color[1] == 0) and  -- yellow, r=1,g=1
            line.color[2] == 1 and line.color[3] == 0 then  -- green, g=1
            table.insert(attributes, line.text)
        end
    end
    return attributes
end

--[[
Attempts to retrieve all known info about an equipment item in the inventory

Parameters:
+ index   - The bag index of the item, as used by GetBagItemInfo
+ tooltip - Optionally specify a tooltip to use; default is GameTooltip

Returns:
+ A table of data about the equipment item

Example:
local data = Sol.data.items.GetBagItemData(1)
for key, val in pairs(data) do
    Sol.io.Print(key .. " = " .. val)
end
--]]
Sol.data.items.GetBagItemData = function(index, tooltip)
    local bagIndex, icon, name, itemCount, locked, invalid = GetBagItemInfo(index)
    if not icon then 
        return nil
    end
    if not tooltip then
        tooltip = GameTooltip
    end
    Sol.tooltip.ClearAllText(tooltip)
    tooltip:SetBagItem(bagIndex)
    tooltip:Hide()
    
    local data = Sol.tooltip.ParseItemData(tooltip)
    data.icon = icon
    data.name = name
    data.itemCount = itemCount
    data.locked = locked
    data.invalid = invalid
    data.link = GetBagItemLink(bagIndex)
    data.bagIndex = bagIndex
    
    return data
end

--[[
Returns a list of the bag slots that have the specified item, as well as
extra info about each slot

Parameters:
+ itemName - name of the item to look for

Returns:
+ A table of item data, each entry being the return values of GetBagItemInfo,
indexed by the slot number

Example:
local items = Sol.data.items.GetBagSlots("Basic Medicine")
for slotNum, data in pairs(items) do
    Sol.io.Print(data.index)
    Sol.io.Print(data.texture)
    Sol.io.Print(data.name)
    Sol.io.Print(data.itemCount)
    Sol.io.Print(data.locked)
    Sol.io.Print(data.invalid)
end
--]]
Sol.data.items.GetBagSlots = function(itemName)
    local retVal = {}
    local occupiedSlots, totalSlots = GetBagCount()
    for i = 1, totalSlots do
        local index, texture, name, itemCount, locked, invalid = GetBagItemInfo(i)
        if name == itemName then
            local data = {
                index = index,
                texture = texture,
                name = name,
                itemCount = itemCount,
                locked = locked,
                invalid = invalid
            }
            retVal[i] = data
        end
    end
    return retVal
end

--[[
Returns a list of the bank slots that have the specified item, as well as
extra info about each slot

Parameters:
+ itemName - name of the item to look for

Returns:
+ A table of item data, each entry being the return values of GetBankItemInfo,
indexed by the slot number

Example:
local items = Sol.data.items.GetBankSlots("Basic Medicine")
for slotNum, data in pairs(items) do
    Sol.io.Print(data.texture)
    Sol.io.Print(data.name)
    Sol.io.Print(data.itemCount)
    Sol.io.Print(data.locked)
    Sol.io.Print(data.invalid)
end
--]]
Sol.data.items.GetBankSlots = function(itemName)
    local retVal = {}
    local totalSlots = GetBankNumItems()
    for i = 1, totalSlots do
        local  texture, name, itemCount, locked = GetBankItemInfo(i)
        if name == itemName then
            local data = {
                texture = texture,
                name = name,
                itemCount = itemCount,
                locked = locked,
                invalid = invalid
            }
            retVal[i] = data
        end
    end
    return retVal
end

--[[
Finds an item that has the specified icon

Parameters:
+ iconPath - texture to look for

Returns:
+ the name of the first item that has the specified texture, or nil

--]]
Sol.data.items.GetItemName = function(iconPath)
    local occupiedSlots, totalSlots = GetBagCount()
    for i = 1, totalSlots do
        local index, texture, name, itemCount, locked, invalid = GetBagItemInfo(i)
        if texture == iconPath then
            return name
        end
    end
end

--[[
Get the total number of the specified item in your inventory, adding
up all stacks (not including bank, etc).

Parameters:
+ itemName - the name of the item to look for

Returns:
+ how many of the item you have in your bags
--]]
Sol.data.items.GetTotalBagItemCount = function(itemName)
    local data = Sol.data.items.GetBagSlots(itemName)
    local count = 0
    for index, value in pairs(data) do
        count = count + value.itemCount
    end
    return count
end


--[[
Get the total number of the specified item in your bank, adding
up all stacks

Parameters:
+ itemName - the name of the item to look for

Returns:
+ how many of the item you have in your bank
--]]
Sol.data.items.GetTotalBankItemCount = function(itemName)
    local data = Sol.data.items.GetBankSlots(itemName)
    local count = 0
    for index, value in pairs(data) do
        count = count + value.itemCount
    end
    return count
end


-------------------------------------------------------------------------------
-- Sol.data.mobs --------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Sol.data.quests ------------------------------------------------------------
-------------------------------------------------------------------------------
--[[
Search through the quest list for all quests that match the specified criteria.

Any parameter may be left blank to include all quests.

Parameters:
+ searchStr      - portion of the quest name
+ completionType - one of Sol.constants.QUEST_ALL/QUEST_COMPLETE/QUEST_INCOMPLETE
+ questType      - one of Sol.constants.QUEST_ALL/QUEST_DAILY/QUEST_NORMAL
+ minLevel       - minimum level of the quest (inclusive)
+ maxLevel       - maximum level of the quest (inclusive)

Returns:
+ a table of quests that match the criteria, each entry being a table with
these fields: index, name, completed, level,  daily, track, catalogID

Example:
local quests = Sol.data.quests.FindQuests(nil, Sol.constants.QUEST_COMPLETE, nil, 20)

This would return all completed quests with suggested level >= 20
--]]
Sol.data.quests.FindQuests = function(searchStr, completionType, questType, minLevel, maxLevel)
    if not completionType then
        completionType = Sol.constants.QUEST_ALL
    end
    if not questType then
        questType = Sol.constants.QUEST_ALL
    end
    if not minLevel then
        minLevel = 0
    end
    if not maxLevel then
        maxLevel = 999
    end
    
    local retVal = {}
    for index = 1, GetNumQuestBookButton_QuestBook() do
        local _, catalogID, name, track, level, daily = GetQuestInfo(index)
        local completed = Sol.data.quests.IsComplete(index)
        
        if  (not searchStr or name:find(searchStr)) and
            (questType == Sol.constants.QUEST_ALL or 
                (questType == Sol.constants.QUEST_DAILY and daily) or 
                (questType == Sol.constants.QUEST_NORMAL and not daily)) and
            (completionType == Sol.constants.QUEST_ALL or
                (completionType == Sol.constants.QUEST_COMPLETE and completed) or
                (completionType == Sol.constants.QUEST_INCOMPLETE and not completed)) and
            (minLevel <= level) and (maxLevel >= level) then
            
            table.insert(retVal, { 
                index = index,
                name = name,
                completed = completed,
                level = level, 
                daily = daily,
                track = track,
                catalog = catalogID
            })
        end
    end
    return retVal
end

--[[
Get the index of the specified quest

Parameters:
+ questName - the name of the quest to look for

Returns:
+ quest index, used by GetQuestInfo, etc
--]]
Sol.data.quests.GetQuestIndex = function(questName)
    for index = 1, GetNumQuestBookButton_QuestBook() do
        local _, catalogID, name = GetQuestInfo(index)
        if Sol.string.StartsWith(name, questName) then
            return index
        end
    end
end

--[[
Check if all parts of the specified quest have been completed

Parameters:
+ index - the quests index, used by GetQuestInfo, etc

Returns:
+ false if any part of the quest is incomplete; true otherwise.
Note that this is optimistic - if the quest doesn't have any parts,
it will return true
--]]
Sol.data.quests.IsComplete = function(index)
    if not index then
        return
    end
    
    local part = 1
    local _, completedPart = GetQuestRequest(index, part)
    while completedPart ~= nil do
        if completedPart == 0 then 
            return false
        end
        part = part + 1
        completedPart = GetQuestRequest(index, part)
    end
    return true
end


-------------------------------------------------------------------------------
-- Sol.data.skills ------------------------------------------------------------
-------------------------------------------------------------------------------
--[[
Tries to find the action bar slot with the specified skill.

Parameters: 
+ skillName - skill to look for

Returns:
+ The first slot that has the same icon as skillName, or nil if not found
--]]
Sol.data.skills.GetActionBarSlot = function(skillName)
    for i = 1, ACTIONBAR_NUM_BUTTONS * ACTIONBAR_NUM_PAGES do
        local name = Sol.data.skills.GetSkillNameFromAction(i)
        if name == skillName then
            return i
        end
    end
end

--[[
Parse a tooltip to get the casting time specified in the skillbook

Parameters:
+ skillPage  - The index of the skill tab that has the skill or nil
+ skillIndex - The skill index within that tab or nil
+ tooltip    - Optionally specify a tooltip to use; default is GameTooltip

Returns:
+ The cast time of the specified skill, as shown in the skillbook
--]]
Sol.data.skills.GetSkillCastTime = function(skillPage, skillIndex, tooltip)
    local regex = "^(%d+) second cast$"
    return Sol._help.GetSkillMatches(skillPage, skillIndex, tooltip, regex)
end

--[[
Parse a tooltip to get the skill cost specified in the skillbook

Parameters:
+ skillPage  - The index of the skill tab that has the skill or nil
+ skillIndex - The skill index within that tab or nil
+ tooltip    - Optionally specify a tooltip to use; default is GameTooltip

Returns:
+ The mana/energy/rage/focus cost of the skill, as shown in the skillbook
--]]
Sol.data.skills.GetSkillCost = function(skillPage, skillIndex, tooltip)
    local regex = "^Uses (%d+) (%w+)$"
    return Sol._help.GetSkillMatches(skillPage, skillIndex, tooltip, regex)
end

--[[
Returns the name of the primary and secondary skill types of unit, as
shown in skill tooltips. E.g., scout/rogue would return concentration, energy

Parameters:
+ unit - a unit id (e.g., "player") 

Returns:
+ the primary class's skill type
+ the secondary class's skill type
--]]
Sol.data.skills.GetSkillTypes = function(unit)
    local class, subClass = UnitClass(unit)
    local data = {
        Scout = "focus",
        Rogue = "energy",
        Warrior = "rage",
        Mage = "MP",
        Priest = "MP",
        Knight = "MP",
    }
    return data[class], data[subClass]
end

--[[
If the action bar slot is a skill, returns the name of that skill.

Parameters:
+ actionBarSlot - the action bar button index

Returns:
+ The name of the skill with the same icon as the specified action slot,
or nil if no such skill
--]]
Sol.data.skills.GetSkillNameFromAction = function(actionBarSlot)
    local path = GetActionInfo(actionBarSlot)
    return Sol.data.skills.GetSkillNameFromIcon(path)
end

--[[
Get the name of the skill that has the icon at iconPath

Parameters:
+ iconPath - the path, as returned by GetActionInfo and GetSkillDetail

Returns:
+ the name of the skill or nil if not found
--]]
Sol.data.skills.GetSkillNameFromIcon = function(iconPath)
    for tabNum = 1, 5 do
        local numSkills = GetNumSkill(tabNum)
        if numSkills then
            for skillNum = 1, numSkills do
                local name, _, path = GetSkillDetail(tabNum, skillNum)
                if path == iconPath then
                    return name
                end
            end
        end
    end
end

--[[
Get the indeces used to access a skill from the skill book

Parameters:
+ skillName - name of the skill to look for

Returns:
+ the index of the skill tab that has the skill or nil
+ the skill index within that tab or nil

Example:
local tabNum, skillNum = Sol.data.skills.GetSkillbookIndeces("Vampire Arrows")
local cooldown, remaining = GetSkillCooldown(tabNum, skillNum)
--]]
Sol.data.skills.GetSkillbookIndeces = function(skillName)
    for tabNum = 1, 5 do
        local numSkills = GetNumSkill(tabNum)
        if numSkills then
            for skillNum = 1, numSkills do
                if GetSkillDetail(tabNum, skillNum) == skillName then
                    return tabNum, skillNum
                end
            end
        end
    end
end

--[[
Get the index of the specified buff on the unit

Parameters:
+ unit     - standard unit string ("player", "target", etc)
+ buffName - name of the buff to look for

Returns:
+ index in the buff list that the specified buff is at, or -1 if not found
--]]
Sol.data.skills.UnitBuffIndex = function(unit, buffName)
    return Sol._help.UnitBuffOrDebuffIndex(unit, buffName, true)
end

--[[
Get the index of the specified debuff on the unit

Parameters:
+ unit     - standard unit string ("player", "target", etc)
+ buffName - name of the debuff to look for

Returns:
+ index in the debuff list that the specified debuff is at, or -1 if not found
--]]
Sol.data.skills.UnitDeBuffIndex = function(unit, debuffName)
    return Sol._help.UnitBuffOrDebuffIndex(unit, debuffName, false)
end

--[[
Check if the unit has the specified buff

Parameters:
+ unit     - standard unit string ("player", "target", etc)
+ buffName - name of the buff to look for

Returns:
+ true if unit has buffName
--]]
Sol.data.skills.UnitHasBuff = function(unit, buffName)
    return Sol.data.skills.UnitBuffIndex(unit, buffName) > -1
end

--[[
Check if the unit has the specified debuff

Parameters:
+ unit     - standard unit string ("player", "target", etc)
+ buffName - name of the debuff to look for

Returns:
+ true if unit has debuffName
--]]
Sol.data.skills.UnitHasDeBuff = function(unit, debuffName)
    return Sol.data.skills.UnitDeBuffIndex(unit, debuffName) > -1
end


-------------------------------------------------------------------------------
-- Sol.hooks ------------------------------------------------------------------
-------------------------------------------------------------------------------
--[[
Get the original, hooked function. Use this to call the
original function after hooking yours. For example, after
hooking DEFAULT_CHAT_FRAME.AddMessage:
MyAddon.DEFAULT_CHAT_FRAME_AddMessage = function(msg)
  local originalFn = Sol.hooks.GetOriginalFn("MyAddon", "AddMessage", DEFAULT_CHAT_FRAME)
  MyAddon.DoStuff(msg)
  originalFn(msg)
end

Parameters:
+ addonName - Your addon's name
+ fnName    - The name of the function to unhook
+ tbl       - The frame or table the function is for, or nil
+ tableName - For tables that aren't frames, a name must be specified

Returns:
+ The original function assigned to this frame and fnName, before it
was hooked, or nil if the function hasn't been hooked.

--]]
Sol.hooks.GetOriginalFn = function(addonName, fnName, tbl, tableName)
    local addon = Sol._help.CheckAddon(addonName)

    if tbl and not tableName and tbl.GetName then
        tableName = tbl:GetName()
    elseif not tableName then
        tbl = _G
        tableName = "_G"
    end
    
    local hooks = Sol._help.GetHooks(tableName, fnName)
    
    if not hooks then return nil end

    for i, hook in ipairs(hooks) do
        if hook.addon.name == addonName then
            return hook.originalFn
        end
    end
end

--[[
Hooking a function means that whenever the system attempts to call that
function, it will call your function, instead. So, for example, if you
want to  change how things display in a chat frame, you can hook that
frame's AddMessage function and have your own function be called.
After you do whatever processing you want, you can (and in most cases,
should) call the original function using Sol.hooks.GetOriginalFn

Parameters:
+ addonName - Your addon's name
+ fnName    - The name of the function to hook
+ newFn     - Function to call instead of the original one
+ tbl       - The table or frame the function is for, or nil
+ tableName - For tables that aren't frames, a name must be specified

WARNING: Hooking is inherently dangerous; if you mess
things up you may have to restart the game. 
--]]
Sol.hooks.Hook = function(addonName, fnName, newFn, tbl, tableName)
    local addon = Sol._help.CheckAddon(addonName)

    if tbl and not tableName and tbl.GetName then
        tableName = tbl:GetName()
    elseif not tableName then
        tbl = _G
        tableName = "_G"
    end
    
    
    if not tbl or newFn == tbl[fnName] or not tbl[fnName] or not newFn then
        return false
    end

    -- Check hooks table and create as neccessary
    if not SolHooks[tableName] then 
        SolHooks[tableName] = {} 
    end
    local hooks = SolHooks[tableName][fnName]
    if not hooks then
        hooks = {}
        SolHooks[tableName][fnName] = hooks
    end
    
    -- Save the original fn
    local hook = { addon = addon, originalFn = tbl[fnName], newFn = newFn, tbl = tbl }
    table.insert(hooks, hook)

    -- Set the new one
    tbl[fnName] = newFn

    return true
end

--[[
Unhook functions to restore the system to its normal state.
If the function hasn't been hooked using Sol, does nothing.

Parameters:
+ addonName - Your addon's name
+ fnName    - The name of the function to unhook
+ tbl       - The table or frame the function is for, or nil
+ tableName - For tables that aren't frames, a name must be specified

--]]
Sol.hooks.UnHook = function(addonName, fnName, tbl, tableName)
    local addon = Sol._help.CheckAddon(addonName)

    if tbl and not tableName and tbl.GetName then
        tableName = tbl:GetName()
    elseif not tableName then
        tableName = "_G"
        tbl = _G
    end
    
    local hooks = Sol._help.GetHooks(tableName, fnName)
    if hooks then
        for i, hook in ipairs(hooks) do
            if hook.addon.name == addonName then
                if #hooks > i then
                    -- Another hook is pointing at this one, make it
                    -- point to the previous one or the original fn
                    hooks[i + 1].originalFn = hook.originalFn
                else
                    -- This is the last hook in the chain, just unhook
                    tbl[fnName] = hook.originalFn
                end
                
                table.remove(hooks, i)
                break
            end
        end
    end
end

--[[
Unhook all functions hooked by your addon using Sol

Parameters:
+ addonName - Your addon's name
--]]
Sol.hooks.UnHookAll = function(addonName)
    if not addonName then
        return
    end

    for tableName, fnNames in pairs(SolHooks) do
        for fnName, hooks in pairs(fnNames) do
            for i, hook in ipairs(hooks) do
                if hook.addon.name == addonName then
                    Sol.hooks.UnHook(addonName, fnName, hook.tbl)
                end
            end
        end
    end
end


-------------------------------------------------------------------------------
-- Sol.io ---------------------------------------------------------------------
-------------------------------------------------------------------------------
--[[
Print a message to a specific frame, a debug frame, OR the DEFAULT_CHAT_FRAME
(in that order) -only if Sol._help.DEBUG is true-. Color is orange.

Parameters:
+ msg        - The message to print
+ printFrame - The frame to print to. Leave nil to print to DEFAULT_CHAT_FRAME
--]]
Sol.io.Debug = function(msg, printFrame)
    if Sol._help.DEBUG then
        local debugFrame = Sol.util.FindDebugFrame()
        if not debugFrame or not debugFrame:IsVisible() then
            debugFrame = DEFAULT_CHAT_FRAME
        end
        Sol.io.Print(Sol.color.ColorText(tostring(msg), "ff7700"), debugFrame)
    end
end

--[[
Print a message to a specific frame or the DEFAULT_CHAT_FRAME. Color is red.

Parameters:
+ msg        - The message to print
+ printFrame - The frame to print to. Leave nil to print to DEFAULT_CHAT_FRAME
--]]
Sol.io.Error = function(msg, printFrame)
    Sol.io.Print(Sol.color.ColorText("=Error= " .. tostring(msg), "ff0000"), printFrame)
end

--[[
Print a message to a specific frame or the DEFAULT_CHAT_FRAME. Color is white
if no color codes found in msg

Parameters:
+ msg        - The message to print
+ printFrame - The frame to print to. Leave nil to print to DEFAULT_CHAT_FRAME
--]]
Sol.io.Print = function(msg, printFrame)
    if type(msg) == "function" then
        msg = Sol.util.FnName(msg)
    end
    msg = tostring(msg)
    if not msg:find("|c") then
        msg = Sol.color.ColorText(msg, "ffffff")
    end
    if printFrame and printFrame.AddMessage then
        printFrame:AddMessage(msg)
    else
        DEFAULT_CHAT_FRAME:AddMessage(msg)
    end
end

--[[
Print a formatted message to a specific frame or the DEFAULT_CHAT_FRAME.
Color is white if no color codes found in msg.

Parameters:
+ msg        - The message to print
+ printFrame - The frame to print to. Leave nil to print to DEFAULT_CHAT_FRAME
+ ...        - Any number of format parameters
--]]
Sol.io.Printf = function(msg, printFrame, ...)
    Sol.io.Print(msg:format(...), printFrame)
end

--[[
Prints the table entries, one per line, to the default chat frame.
Recurses up to Sol.io.MaxRecursionLevel times to print inner tables.

Parameters:
+ tbl      - The table or frame to print
+ spacing  - How much to indent the printout (leave at 0 or nil if unsure)
+ isDebug  - Will only print if Sol._help.DEBUG is true
+ name     - Name of the table. If specified, will print this first
+ visited  - List of frames that have been visited (used for recursion, but
             can also be used to filter)
+ print_fn - Function to call when something needs to be printed
--]]
Sol.io.MaxRecursionLevel = 5
Sol.io.PrintTable = function(tbl, spacing, isDebug, name, visited, print_fn)
    if not tbl or type(tbl) ~= "table" then
        return
    end
    if not print_fn then
        print_fn = (isDebug and Sol.io.Debug) or Sol.io.Print
    end

    if not spacing then
        spacing = 0
    elseif spacing > Sol.io.MaxRecursionLevel then
        print_fn("...")
        return
    end

    if not visited then
        visited = {}
    elseif Sol.table.Contains(visited, tbl) then
        return
    end
    
    table.insert(visited, tbl)
    
    if spacing == 0 and name then
        print_fn(name .. " {")
    end

    for k, v in pairs(tbl) do
        local start = ""
        for i = 0, spacing do
            start = start .. "   "
        end
        start = start .. " "
        if type(v) == "table" then
            print_fn(start .. tostring(k) .. " {")
            Sol.io.PrintTable(v, spacing + 1, isDebug, name, visited, print_fn)
            print_fn(start .. "}")
        elseif type(v) == "function" then
            print_fn(start .. tostring(k) .. " = " .. Sol.util.FnName(v, tbl))
        else
            print_fn(start .. tostring(k) .. " = " .. tostring(v))
        end
    end

    if spacing == 0 and name then
        print_fn("}")
    end
end

--[[
Print a message to the first frame that has COMBAT in its messageTypeList.

Parameters:
+ msg - The message to print
--]]
Sol.io.PrintToCombatLog = function(msg)
    local combatLog = Sol.util.FindChatFrame("COMBAT")
    if combatLog then
        Sol.io.Print(msg, combatLog)
    end
end

--[[
Print a message to the first frame that has nothing but CHANNEL in its messageTypeList.

Parameters:
+ msg - The message to print
--]]
Sol.io.PrintToDebugFrame = function(msg)
    local debugFrame = Sol.util.FindDebugFrame()
    if debugFrame then
        Sol.io.Print(msg, debugFrame)
    end
end

--[[
Print a message to the first frame that has SYSTEM in its messageTypeList.

Parameters:
+ msg - The message to print
--]]
Sol.io.PrintToSystem = function(msg)
    local sysFrame = Sol.util.FindChatFrame("SYSTEM")
    if sysFrame then
        Sol.io.Print(msg, sysFrame)
    end
end


-------------------------------------------------------------------------------
-- Sol.math -------------------------------------------------------------------
-------------------------------------------------------------------------------

-- source: http://snipplr.com/view/13086/number-to-hex/
-- converts decimal number to hex format
Sol.math.DecToHex = function(dec)
    if not dec or type(dec) ~= "number" then
        return nil
    end

    local hexValues = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}
    local hex = ""
    while dec > 0 do
        local mod = math.fmod(dec, 16)+1
        hex = hexValues[mod] .. hex
        dec = math.floor(dec / 16)
    end
    if hex == "" then hex = "0" end
    return hex
end

-- converts hex number to decimal format
Sol.math.HexToDec = function(hex)
    if not hex then
        return nil
    end

    local hexValues = {A=10, B=11, C=12, D=13, E=14, F=15}
    local dec = 0
    local num = 0
    hex = hex:upper()
    for i=1,#hex do
        subhex = hex:sub(-i, -i)
        if hexValues[subhex] then
            num = hexValues[subhex]
        elseif subhex >= "0" and subhex <= "9" then
            num = tonumber(subhex)
        end
        dec = dec + num * math.pow(16, i-1)
    end
    return dec
end

-- From lua-users.org wiki
-- Rounds a number to the given number of decimal places.
Sol.math.Round = function(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end


-------------------------------------------------------------------------------
-- Sol.string -----------------------------------------------------------------
-------------------------------------------------------------------------------

-- From lua-users.org wiki
-- Returns true if "str" ends with "end"
Sol.string.EndsWith = function(str, ends)
    if not ends then return false end
    return ends == '' or string.sub(str, -string.len(ends)) == ends
end

-- From lua-users.org wiki
-- Returns true if "str" starts with "start"
Sol.string.StartsWith = function(str, start)
    if not start then return false end
    return string.sub(str, 1, string.len(start)) == start
end

-- Get the last index of the specified substring within string
Sol.string.LastIndexOf = function(str, subString)
    local lastIndex = nil
    local index = true
    while index do
        lastIndex = index
        index = str:find(subString)
        str = str:sub(index + 1)
    end
    return lastIndex
end



--[[
Parses the given string into a date, if possible

Parameters:
+ str   - a string containing a date in the format d/m/y h:m:s or some variation of it

Returns:
+ the (month, day, year) and the (hour, minute, second) in the order that they were in the string

Examples:
local month, day, year, hour, minute, second = Sol.string.ParseDate("12/31/2009 23:59:59")
--]]
Sol.string.ParseDate = function(dt)
    local h, m, s = dt:match("(%d%d?):(%d%d?):(%d%d?)")
    local mo, da, ye = dt:match("(%d%d?)/(%d%d?)/(%d%d?%d?%d?)")
    return mo, da, ye, h, m, s
end


-- From lua-users.org wiki
-- Splits str into parts, using delim as a delimeter, and returns
-- a list of the parts
Sol.string.Split = function(str, delim)
    if not delim then
        delim = " "
    end
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
    end
    -- Handle the last field
    result[nb + 1] = string.sub(str, lastPos)
    return result
end

-- Returns a string identical to str except with whitespace removed
-- from the front and end of it
Sol.string.Trim = function(str)
    return str:gsub("^[^%w]*", ""):gsub("[^%w]*$", "")
end

-------------------------------------------------------------------------------
-- Sol.table ------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Removes blanks from an integer-ordered table
Sol.table.Compact = function(tbl)
    local indeces = {}
    for i, v in pairs(tbl) do
        if type(i) == "number" then
            table.insert(indeces, i)
        end
    end
    table.sort(indeces)
    
    for i = 1, #indeces do
        if i ~= indeces[i] then
            tbl[i] = tbl[indeces[i]]
            tbl[indeces[i]] = nil
        end
    end
end

-- Returns true if value is one of the values in tbl
Sol.table.Contains = function(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end


--[[
Goes through every value in tbl (top-level only) and attempts to match
it to the specified regex

Parameters:
+ tbl   - the table to look in
+ value - the regex to look for

Return:
+ true if tbl has a string that matches regex in the top-level; false
otherwise
--]]
Sol.table.ContainsRegex = function(tbl, value)
    for _, v in pairs(tbl) do
        if type(v) == "string" and value:match(v) then
            return true
        end
    end
    return false
end

-- From lua-users.org wiki
-- Copy the table and any sub-tables (including keys)
Sol.table.DeepCopy = function(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

-- Get the key for the specified value
Sol.table.GetKey = function(tbl, value)
    for k, v in pairs(tbl) do
        if v == value then
            return k
        end
    end
    return nil
end

-- Removes any entries in the table that are blank strings or just a single space
Sol.table.RemoveEmpty = function(tbl)
    for i = #tbl, 1, -1 do
        local v = tbl[i]
        if v == "" or v == " " then
            table.remove(tbl, i)
        end
    end
    return tbl
end


-- Removes a specific value from tbl (as opposed to removing an item
-- at a certain index)
Sol.table.RemoveValue = function(tbl, value)
    local key = Sol.table.GetKey(tbl, value)
    if type(key) == "number" then
        table.remove(tbl, key)
    else
        table[key] = nil
    end
end

-- Get all keys in tbl
Sol.table.GetKeys = function(tbl)
    local keys = {}
    for k, v in pairs(tbl) do
        table.insert(keys, k)
    end
    return keys
end


-------------------------------------------------------------------------------
-- Sol.timers -----------------------------------------------------------------
-------------------------------------------------------------------------------
--[[
Retrieves the table of a timer created with Sol

Parameters:
+ addonName - Your addon's name
+ timerID   - The id returned by Sol.timers.ScheduleTimer 

Return:
+ a table with fields detailing the timer - id, name, fn, delay, 
repeatDelay, addonName, started, finished, start, repeatStart
--]]
Sol.timers.GetTimer = function(addonName, timerID)
    for i, timer in ipairs(SolTimers[addonName].timers) do
        if timer.id == timerID then
            return timer
        end
    end
end

--[[
Stops a timer created with Sol

Parameters:
+ addonName - Your addon's name
+ timerID   - The id returned by Sol.timers.ScheduleTimer 

Return:
+ true if the timer was successfully removed; false if it
couldn't be found
--]]
Sol.timers.RemoveTimer = function(addonName, timerID)
    if not SolTimers[addonName] then
        return
    end
    for i, timer in ipairs(SolTimers[addonName].timers) do
        if timer.id == timerID then
            timer.finished = true
            table.remove(SolTimers[addonName].timers, i)
            if #SolTimers[addonName].timers == 0 then
                Sol.hooks.UnHook("Sol", SolTimers[addonName].onUpdateFnName)
            end
            return true
        end
    end
    return false
end

--[[
Creates a new timer that will execute 'fn' after the specified delay, and
periodically.

NOTE: This function requires you to have an OnUpdate handler for some
visible frame. By default, this is <addonName>_OnUpdate (you can specify
a different handler with the optional onUpdateFnName parameter). This 
function need not do anything, but it must exist and must be called
from an <OnUpdate> script tag in your xml. If your frame ever gets hidden,
the OnUpdate won't tick and the timer won't work!

Parameters:
+ addonName      - Your addon's name
+ delay          - How long to wait before executing 'fn' the first 
                   time (in seconds)
+ fn             - A callback function with the following sinature:
                   function(addonName, timerID). Called every timer tick
+ repeatDelay    - If you wish to run 'fn' periodically, use this to specify 
                   how often (in seconds, optional)
+ timerName      - Name for the timer; can be used to more easily identify 
                   it (optional)
+ onUpdateFnName - The name of the OnUpdate handler to use (optional)
                   Defaults to <addonName>_OnUpdate
                   
Return:
+ a timer ID that can be used with Sol.timers.GetTimer and 
Sol.timers.RemoveTimer

Post:
+ 'fn' will be executed once after 'delay' time, and then again every
'repeatDelay' time, as long as the update frame is visible (that is,
as long as the function referred to by onUpdateFnName gets called)
--]]
Sol.timers.ScheduleTimer = function(addonName, delay, fn, repeatDelay, timerName, onUpdateFnName)
    if not addonName or not fn or (not delay and not repeatDelay) then
        return
    end
    if not delay then
        delay = 0
    end
    
    if not onUpdateFnName then
        onUpdateFnName = addonName .. "_OnUpdate"
    end
    
    -- Create place to store timer
    if not SolTimers[addonName] then
        SolTimers[addonName] = {}
        SolTimers[addonName].timers = {}
        SolTimers[addonName].onUpdateFnName = onUpdateFnName
    end
    
    local timerID = Sol._help.GenerateTimerID()	
    
    if delay == 0 and not repeatDelay then
        -- This isn't a timer; it's just a function call (no delay and no repeat)
        fn(addonName, timerID)
        return
    end
    
    -- Create timer object
    local newTimer = {
        id = timerID,
        name = timerName,
        delay = delay,
        started = false,
        repeatStart = nil,
        repeatDelay = repeatDelay,
        addonName = addonName,
        finished = false,
        fn = fn,
        start = GetTime()
    }
    table.insert(SolTimers[addonName].timers, newTimer)
    
    -- Run timer initially, if needed
    if not delay or delay == 0 then
        fn(addonName, newTimer.id)
        newTimer.started = true
        newTimer.repeatStart = newTimer.start
    end
    
    -- Hook the OnUpdate
    local updateFn = function(frame, elapsedTime)
        Sol._help.TimerUpdate(frame, elapsedTime, addonName)
    end
    SolTimers[addonName].updateFn = updateFn
    
    if not Sol.hooks.GetOriginalFn("Sol", onUpdateFnName) then
        Sol.hooks.Hook("Sol", onUpdateFnName, updateFn)
    end
    
    return timerID
end


-------------------------------------------------------------------------------
-- Sol.tooltip ----------------------------------------------------------------
-------------------------------------------------------------------------------
--[[
Clears all text fields on this tooltip. Removes text that ClearLines() leaves
behind.

Parameters:
+ tooltip - the tooltip to clear

Post: tooltipTextLeft1 .. 40 and tooltipTextRight1 .. 40 are cleared of text
--]]
Sol.tooltip.ClearAllText = function(tooltip)
    tooltip:ClearLines()
    for i = 1, 40 do
        local left = _G[tooltip:GetName() .. "TextLeft" .. i]
        local right = _G[tooltip:GetName() .. "TextRight" .. i]
        left:SetText("")
        right:SetText("")
    end
end


--[[
Parses a tooltip that's been set to an item and attempts to glean as much
information from it as possible.

Parameters:
+ tooltip - a tooltip that's been cleared and set to an item, e.g. with SetBagItem

Returns:
+ a table of useful data about the item, including type, level, attributes, etc

Example:
Sol.tooltip.ClearAllText(GameTooltip)
GameTooltip:SetBagItem(GetBagItemInfo(1))
local data = Sol.tooltip.ParseItemData
Sol.io.PrintTable(data)
--]]
Sol.tooltip.ParseItemData = function(tooltip)
    local colorRegex = "|cff%x%x%x%x%x%x"
    local lines = Sol.tooltip.ReadTooltip(tooltip)
    Sol.tooltip.ParseItemDataFromLines(lines)
end

--[[
Parses data that's been read from an item and attempts to glean as much
information from it as possible.

Parameters:
+ lines - data read from a tooltip, e.g., with Sol.tooltip.ReadTooltip(tooltip)

Returns:
+ a table of useful data about the item, including type, level, attributes, etc

Example:
Sol.tooltip.ClearAllText(GameTooltip)
GameTooltip:SetBagItem(GetBagItemInfo(1))
local data = Sol.tooltip.ParseItemData
Sol.io.PrintTable(data)
--]]
Sol.tooltip.ParseItemDataFromLines = function(lines)
    local data = {}
    local index = 1
    local numLines = #(lines.left)
    data.attributes = {}
    
    if not lines.left[index] then
        return data
    end
    
    if lines.left[index].text == "Current Equipment" then
        index = index + 1
    end
    
    if not Sol._help.qualityColors then
        Sol._help.qualityColors = {}
        for i = 1, 5 do
            local hexColor = Sol.color.ColorValuesToHexColor(GetItemQualityColor(i))
            Sol._help.qualityColors[hexColor] = _G["ITEM_QUALITY" .. i .. "_DESC"]
        end
    end
        
    -- Item Name is the first thing in the tooltip
    data.name = lines.left[index].text
    local color = (data.name:sub(1,2) == "|c") and data.name:sub(5, 10)
    if color then
        data.quality = Sol._help.qualityColors[color:upper()]
    end
    index = index + 1
    if index > numLines then
        return data
    end
    
    if lines.left[index].text:match("Bound") ~= nil then
        data.isBound = true
        index = index + 1
        if index > numLines then
            return data
        end
    end
    
    if lines.left[index].text:match("Binds when equipped") ~= nil then
        data.isBindable = true
        index = index + 1
        if index > numLines then
            return data
        end
    end
    
    if lines.left[index].text:match("Item Shop Item") ~= nil then
        data.isItemShopItem = true
        index = index + 1
        if index > numLines then
            return data
        end
    end
    
    if lines.left[index].text:match("Not dropped on PK death") ~= nil then
        data.isNotDropOnPKDeath = true
        index = index + 1
        if index > numLines then
            return data
        end
    end
    
    data.stackCount = lines.left[index].text:match("Stacked Number:(%d+)")
    if data.stackCount then
        index = index + 1
        if index > numLines then
            return data
        end
    end
    
    data.liveTime = lines.left[index].text:match("Live time (%d+ .*)")
    if data.liveTime then
        index = index + 1
        if index > numLines then
            return data
        end
    end
    
    data.numUses = tonumber(lines.left[index].text:match("Number of uses (%d+)"))
    if data.numUses then
        index = index + 1
        if index > numLines then
            return data
        end
    end
    
    local color = Sol.color.GetTextColor(lines.left[index].text, lines.left[index].color)
    if color == Sol.constants.FLAVOR_TEXT_COLOR then
        data.flavorText = lines.left[index].text
        if data.flavorText:match("(Daily Quest)") then
            data.type = "Quest Item"
            data.isDaily = true        
        end
        index = index + 1
        if index > numLines then
            return data
        end
    end
    
    -- Items with durability must have a tier
    data.tier = tonumber(lines.left[index].text:match("Tier (%d+)"))
    if data.tier then
        if lines.right[index] then
            local currentDur, totalDur = lines.right[index].text:match("Durability (%d+)/(%d+)")
            data.currentDur = tonumber(currentDur)
            data.totalDur = tonumber(totalDur)
            if lines.right[index + 1] and not lines.left[index + 1] then
                data.powerModifier = tonumber(lines.right[index].text:gsub(colorRegex, "")
                                        :match("Power Modifier %+?(-?%d+)%%"))
                index = index + 1
            end
        end
        index = index + 1
        if index > numLines then
            return data
        end
    end
    
    data.level = tonumber(lines.left[index].text:match("Level (%d+)"))
    if data.level then
        index = index + 1
        if index > numLines then
            return data
        end
    end

    data.worth = lines.left[index].text:match("Worth: (%d+) Gold")
    if data.worth then
        index = index + 1
        if index > numLines then
            return data
        end
    end
    
    -- For most things, the type is next
    color = Sol.color.GetTextColor(lines.left[index].text, lines.left[index].color)
    if not data.type and 
        (not color or 
            color == Sol.constants.NORMAL_TEXT_COLOR or 
            color == Sol.constants.ERROR_TEXT_COLOR) then
        
        data.type = lines.left[index].text
        if color == Sol.constants.ERROR_TEXT_COLOR then
            data.unequipable = true
        end
        if lines.right[index] then
            data.position = lines.right[index].text
        end
        index = index + 1
        if index > numLines then
            return data
        end
    end
    
    -- Physical defense shows up on armor only    
    data.pdef = tonumber(lines.left[index].text:gsub(colorRegex, ""):match("Physical Defense (%d+.%d+)"))
    if data.pdef then
        if lines.right[index] then
            data.mdef = tonumber(lines.right[index].text:gsub(colorRegex, ""):match("Magical Defense (%d+.%d+)"))
        end
        index = index + 1
        if index > numLines then
            return data
        end
    end
    
    data.patk = tonumber(lines.left[index].text:gsub(colorRegex, ""):match("Physical Damage (%d+.%d+)"))
    if data.patk then
        if lines.right[index] then
            data.speed = tonumber(lines.right[index].text:gsub(colorRegex, ""):match("Attack Speed (%d+.%d+)"))
        end
        index = index + 1
        if index > numLines then
            return data
        end
    end
    
    data.matk = tonumber(lines.left[index].text:gsub(colorRegex, ""):match("Magical Damage (%d+.%d+)"))
    if data.matk then
        index = index + 1
        if index > numLines then
            return data
        end
    end
    
    -- may have already gotten worth by now
    if not data.worth then
        data.worth = tonumber(lines.left[index].text:gsub(colorRegex, ""):match("Worth: (%d+)"))
        if data.worth then
            index = index + 1
            if index > numLines then
                return data
            end
        end
    end
    
    -- Blue text is 'flavor' text; sometimes it appears on equipment, after the worth
    -- note that there's another part that checks for flavor text above
    color = Sol.color.GetTextColor(lines.left[index].text, lines.left[index].color)
    if not data.flavorText and color == Sol.constants.FLAVOR_TEXT_COLOR then
        data.flavorText = lines.left[index].text
        if data.flavorText:match("(Daily Quest)") then
            data.type = "Quest Item"
            data.isDaily = true
        end
        index = index + 1
        if index > numLines then
            return data
        end
    end
    
    for i = index, #lines.left do
        local line = lines.left[i]
        local color = Sol.color.GetTextColor(line.text, line.color)
        if color == Sol.constants.GREEN_STAT_TEXT_COLOR or color == YELLOW_STAT_TEXT_COLOR then
            table.insert(data.attributes, line.text)
            
        elseif color == Sol.constants.RUNE_TEXT_COLOR then
            local runesUsed, runesTotal = line.text:match("Rune %((%d)/(%d)%)")
            if runesUsed then
                data.runesUsed = tonumber(runesUsed)
                data.runesTotal = tonumber(runesTotal)
            end
        end
    end
    return data
end

--[[
Reads all data from the tooltip and returns it as a table in the format 
{
    left = {
        1 = {
            text = <text>,
            color = { 1 = <red>, 2 = <green>, 3 = <blue> }
        },
        2 = {
            text = <text>
        }
    }
    right = {
        ...
    }
}

If no color is specified, that means it's the default tooltip color - white (1,1,1)

Parameters:
+ tooltip - the tooltip to read data from; should be intialized with one of
the GameTooltip:Set* functions

Returns:
+ the text in the tooltip, in the table structure described above 
--]]
Sol.tooltip.ReadTooltip = function(tooltip)
    local data = { left = {}, right = {}}
    for i = 1, 40 do
        local left = _G[tooltip:GetName() .. "TextLeft" .. i]
        local right = _G[tooltip:GetName() .. "TextRight" .. i]
        
        local hasText = false
        if left:GetText() and left:GetText() ~= ""  then 
            hasText = true
            local r, g, b = left:GetColor()
            if r == 1 and g == 1 and b == 1 then
                data.left[i] = { text = left:GetText() }
            else
                data.left[i] = { text = left:GetText(), color = { left:GetColor() } }
            end
        end
        if right:GetText() and right:GetText() ~= ""  then 
            hasText = true
            local r, g, b = right:GetColor()
            if r == 1 and g == 1 and b == 1 then
                data.right[i] = { text = right:GetText() }
            else
                data.right[i] = { text = right:GetText(), color = { right:GetColor() } }
            end
        end
        if not hasText then
            break
        end
    end
    return data
end

--[[
Sets a tooltip's text fields to match the specified data

Parameters:
+ tooltip - The tooltip to set
+ data    - A table that specified the values of the text
            and colors to use, in the following format:
{
    left = {
        1 = {
            text = <text>,
            color = { 1 = <red>, 2 = <green>, 3 = <blue> }
        },
        2 = {
            text = <text>
        }
    }
    right = {
        ...
    }
}

If no color is specified, the default tooltip color is used - white (1,1,1)

Post:
+ Tooltip is cleared, and then its text fields are set
to the text and color given in data 
--]]
Sol.tooltip.SetTooltipData = function(tooltip, data)
    local defaultColor = {1, 1, 1}
    
    Sol.tooltip.ClearAllText(tooltip)
    tooltip:SetText(data.left[1].text, unpack(data.left[1].color))
    for i = 2, 40 do
        if data.left[i] and data.right[i] then
            if not data.left[i].color then
                data.left[i].color = defaultColor
            end
            if not data.right[i].color then
                data.right[i].color = defaultColor
            end
            tooltip:AddDoubleLine(data.left[i].text, data.right[i].text, 
                unpack(data.left[i].color), unpack(data.right[i].color))
                
        elseif data.left[i] then
            if not data.left[i].color then
                data.left[i].color = defaultColor
            end
            tooltip:AddLine(data.left[i].text, unpack(data.left[i].color))
        end
    end
end


-------------------------------------------------------------------------------
-- Sol.util -------------------------------------------------------------------
-------------------------------------------------------------------------------

--[[
Takes a string (presumably entered through the chat edit box),
evaluates it, and returns the concatenated result

Parameters:
+ str - A string that contains an expression to be evaluated.
        If you can return it, it should work.

Returns:
+ The results of evaluating str, joined with a comma
--]]
Sol.util.Eval = function(str)
    local fn = loadstring("return " .. str)
    if not fn then
        return str
    end
    local result = {fn()}
    local retVal = ""
    for k,v in pairs(result) do
        if retVal ~= "" then
            retVal = retVal .. ", " .. tostring(v)
        else
            retVal = retVal .. tostring(v)
        end
    end
    if retVal ~= "" then
        return retVal
    else
        return "nil"
    end
end


--[[
Takes a string (presumably a table name entered through the chat edit box),
evaluates it, and returns the first result

Parameters:
+ str - A table name. Theoretically. Other things can work, too.

Returns:
+ The result of evaluating str
--]]
Sol.util.EvalTable = function(str)
    local fn = loadstring("return " .. str)
    if not fn then
        return str
    end
    return fn()
end


--[[
Looks for and returns a string in global (or a table's) variables

Convenience function for Sol.util.FindInTable. Useful for commands entered
by the user from the edit box.

Parameters:
+ searchStr   - String in the format "<searchItem> [<searchType>] [<table>]"
                (the parts of the string are space-separated)
                ~~ searchItem is a string or part of a string you're looking for
                ~~ searchType is what you want to search for: 'table', 'function',
                   'string', 'number', 'boolean', or 'all'. Default is 'all'.
                ~~ table is the table to look in; if not specified, looks
                   globally
+ start       - If there are more than Sol.util.MaxSearchResults results, you'll
                get a message saying "<number> = more not shown...". Use the
                start parameter to specify what "page" of the results to show.
                So, setting start to, say, 30 will return results 30 through
                30+MaxSearchResults.
+ ignoreCase  - Search ignoring case.
+ searchPos   - Sol.constants.SEARCH_POS_START, Sol.constants.SEARCH_POS_END,
                or Sol.constants.SEARCH_POS_ANY. Default is SEARCH_POS_ANY
                Specifies where to look for searchStr: at the begining,
                end, or anywhere in the table values

Returns:
+ A table containing all items that match searchStr and the other
parameters specified.

Eample:
Sol.util.MaxSearchResults = 5
local results = Sol.util.Find("Frame table PlayerFrame", 3, true, Sol.constants.SEARCH_POS_END)
Sol.io.PrintTable(results)

This prints the 3rd through 8th tables found in PlayerFrame that have Frame at the end.


Note: To print this out, use Sol.io.PrintTable. To change the number of
results returned, change Sol.util.MaxSearchResults
--]]
Sol.util.MaxSearchResults = 50
Sol.util.Find = function(searchStr, start, ignoreCase, searchPosition, plain)
    local searchStrParts = Sol.table.RemoveEmpty(Sol.string.Split(searchStr))
    local searchType = nil
    local tbl = _G
    if table.getn(searchStrParts) > 1 then
        searchStr = searchStrParts[1]
        searchType = searchStrParts[2]
        if table.getn(searchStrParts) > 2 then
            tbl = _G[searchStrParts[2]]
            if not tbl then
                tbl = _G
            end
        end
    end
    return Sol.util.FindInTable(tbl, searchStr, searchType, start, ignoreCase, searchPosition, plain)
end

-- Looks for and returns the first ChatFrame that has frameName as part of its
-- messageTypeList
-- Contributed by Sigi_cz
Sol.util.FindChatFrame = function(frameName)
    for chatIndex = 1, 10 do
        local chatFrame = _G["ChatFrame" .. chatIndex]
        if Sol.table.Contains(chatFrame.messageTypeList, frameName:upper()) then
            return chatFrame
        end
    end
end

-- Looks for and returns the first ChatFrame that has COMBAT as part of its
-- messageTypeList
Sol.util.FindCombatLog = function()
    return Sol.util.FindChatFrame("COMBAT")
end

-- Looks for and returns the first ChatFrame that has nothing in its
-- messageTypeList but the default CHANNEL
Sol.util.FindDebugFrame = function()
    for chatIndex = 1, 10 do
        local chatFrame = _G["ChatFrame" .. chatIndex]
        if #chatFrame.messageTypeList <= 1 and chatFrame.messageTypeList[1] == "CHANNEL" then
            return chatFrame
        end
    end
    return nil
end

--[[
Looks for the specified string among all variables in table, or globally if
table is nil.

Parameters:
+ searchStr   - A string or part of a string you're looking for
+ searchType  - What you want to search for: 'table', 'function', 'string',
                'number', 'boolean', or 'all'
+ table       - The table to look in; if not specified, looks globally
+ start       - If there are more than Sol.util.MaxSearchResults results, you'll
                get a message saying "<number> = more not shown...". Use the
                start parameter to specify what "page" of the results to show.
                So, setting start to, say, 30 will return results 30 through
                30+MaxSearchResults.
+ ignoreCase  - Search ignoring case.
+ searchPos   - Sol.constants.SEARCH_POS_START, Sol.constants.SEARCH_POS_END,
                or Sol.constants.SEARCH_POS_ANY.
                Specifies where to look for searchStr: at the begining,
                end, or anywhere in the table values

Returns:
+ A table containing all items that match searchStr and the other
parameters specified.

Note: To print this out, use Sol.io.PrintTable. To change the number of
results returned, change Sol.util.MaxSearchResults
--]]
Sol.util.FindInTable = function(tbl, searchStr, searchType, start, ignoreCase, searchPosition, plain)
    local results = {}

    if not searchStr then
        return results
    end

    tbl = tbl                       or _G
    searchType = searchType         or Sol.constants.SEARCH_TYPE_ANY
    start = start                   or 0
    plain = plain                   or true
    searchPosition = searchPosition or Sol.constants.SEARCH_POS_ANY

    if not Sol.util.MaxSearchResults or type(Sol.util.MaxSearchResults) ~= "number" then
        Sol.util.MaxSearchResults = 50
    end

    local count = 0
    local index = 0

    if ignoreCase then
        searchStr = searchStr:lower()
    end
    for k,v in pairs(tbl) do
        local kStr = tostring(k)
        if ignoreCase then
            kStr = kStr:lower()
        end

        if  (searchPosition == Sol.constants.SEARCH_POS_ANY and string.find(kStr, searchStr, 1, plain)) or
            (searchPosition == Sol.constants.SEARCH_POS_END and Sol.string.EndsWith(kStr, searchStr, 1, plain)) or
            (searchPosition == Sol.constants.SEARCH_POS_START and Sol.string.StartsWith(kStr, searchStr, 1, plain))
        then
            if (searchType == Sol.constants.SEARCH_TYPE_ANY or type(v) == searchType) then
                index = index + 1
                if count < Sol.util.MaxSearchResults and index >= start then
                    count = count + 1
                    results[count] = k .. " (" .. type(v) .. ")"
                end
            end
        end
    end
    if count + start < index then
        results[Sol.util.MaxSearchResults + 1] = (index - Sol.util.MaxSearchResults + 1 - start) .. " more not shown..."
    end
    return results
end

--[[
Find the name of this function as it appears in tbl (or globally if tbl is nil)

Parameters:
+ fn  - The function. Yea.
+ tbl - The table this function is in. If nil, will search global function.

Returns:
+ The fn's name or 'function <memory address>'
--]]
Sol.util.FnName = function(fn, tbl)
    if not tbl then tbl = _G end
    for k,v in pairs(tbl) do
        if v == fn then
            return k .. " - " .. tostring(fn)
        end
    end
    return tostring(fn)
end


--[[
Check if the specified meta key is pressed

Parameters
+ keyName - one of Alt, Shift, Control, Ctrl, None, Any, or All

Returns
+ true if the specified key is pressed (for Alt, Shift, Control,
and Ctrl), if all are pressed (for All), or if None, Any, "", or 
nil is specified as the key; false otherwise
--]]
Sol.util.IsMetaKeyDown = function(keyName)
    if not keyName then
        return true
    end
    
    keyName = keyName:upper()
    return (keyName == "ALT" and IsAltKeyDown()) 
        or (keyName == "SHIFT" and IsShiftKeyDown())
        or ((keyName == "CONTROL" or keyName == "CTRL") and IsCtrlKeyDown())
        or (keyName == "ALL" and IsCtrlKeyDown() and IsShiftKeyDown() and IsAltKeyDown())
        or (keyName == "NONE" or keyName == "" or keyName == "ANY")
end

--[[
Checks if var is actually a frame. If name is specified (most likely as the key
of a key-value enumeration), checks if it's one of the "Bad Frames" - ones that
are valid frames, but error when any frame method is used on them

Parameters:
+ var  - The item to check to see if it's a frame
+ name - If known, the likely name of the frame

Returns
+ True if var is a valid frame; else false
--]]
Sol.util.IsValidFrame = function(var, name)
    if not var or type(var) ~= "table" then
        return false
    end

    for k, v in pairs(var) do
        -- All valid frames should have userdata
        if k == "_uilua.lightuserdate" then
            return true
        end
    end

    return false
end

--[[
Loads the specified lua file. Needs path from Addons folder to the file.
For example, Sol.util.LoadFile("MyAddon/MyAddon.lua")
--]]
Sol.util.LoadFile = function(file)
    dofile("Interface/Addons/" .. file)
end

--[[
Loads the specified lua file. Attempts to determine the correct path.
For example, Sol.util.LoadFile2("MyAddon.lua") will load MyAddon/MyAddon.lua,
and Sol.util.LoadFile2("MyAddonConfig") will load MyAddon/MyAddonConfig.lua.
For anything else, use Sol.util.LoadFile. Runs UnHookAll for MyAddon, as well.

Parameters:
+ file - The file name, as described above
--]]
Sol.util.LoadFile2 = function(file)
    local configIndex = file:find("Config")
    local extIndex = file:find(".lua")
    if extIndex then
        file = file:sub(1, extIndex - 1)
    end
    local folder = file
    if configIndex then
        folder = folder:sub(1, configIndex - 1)
    end
    Sol.hooks.UnHookAll(folder)
    dofile("Interface/Addons/" .. folder .. "/" .. file .. ".lua")
end

--[[
Use this if you want to setup some useful slash commands.
/pr     - Evaluate and print an expression
/prt    - Print a table, recursively, one entry per line
/load   - Loads the exact lua file specified
/load2  - Tries to load a file (see function comments)
/cls    - Clears the DEFAULT_CHAT_FRAME text
/gfind  - Search for text in global variables

/loadcmd - Reloads this list, in case you want to add your own commands
--]]
Sol.util.LoadCommands = function()
    Sol.config.CreateSlashCommand("pr", function(_, str)
        str = tostring(Sol.util.Eval(str))
        Sol.io.Print(str)
    end, "SOL_PRINT")

    Sol.config.CreateSlashCommand("prt", function(_, str)
        local tbl = Sol.util.EvalTable(str)
        Sol.io.PrintTable(tbl, 0, false, str)
    end, "SOL_PRINTTABLE")

    Sol.config.CreateSlashCommand("load", function(_, file)
        Sol.util.LoadFile(file)
    end, "SOL_LOADFIlE")

    Sol.config.CreateSlashCommand("load2", function(_, file)
        Sol.util.LoadFile2(file)
    end, "SOL_LOADFIlE2")

    Sol.config.CreateSlashCommand("gfind", function(_, str)
        Sol.io.PrintTable(Sol.util.Find(str))
    end, "SOL_GFIND")

    Sol.config.CreateSlashCommand("cls", function()
        DEFAULT_CHAT_FRAME:ClearText()
    end, "SOL_CLEARCHAT")

    Sol.config.CreateSlashCommand("loadcommands", Sol.util.LoadCommands, "SOL_RELOADCMDS")

    Sol.io.Debug("Loaded Sol CommandSet")
end

-- If enable == true, Enables frame; else disables frame
Sol.util.SetEnabled = function(frame, enable)
    if not frame or not frame.Enable or not frame.Disable then
        Sol.io.Debug("Sol.util.SetEnabled error: 'frame' is nil or invalid")
        return
    end

    if enable == true then
        frame:Enable()
    else
        frame:Disable()
    end
end

-- If visible == true, Shows frame; else hides frame
Sol.util.SetVisible = function(frame, visibile)
    if not frame or not frame.Show or not frame.Hide then
        Sol.io.Debug("Sol.util.SetVisible error: 'frame' is nil or invalid")
        return
    end

    if visibile == true then
        frame:Show()
    else
        frame:Hide()
    end
end

-- Ternary operator - (condition ? trueValue : falseValue)
Sol.util.TernaryOp = function(condition, trueValue, falseValue)
    if condition then
        return trueValue
    else
        return falseValue
    end
end

--[[
Hides the frame if it's visible; shows it if it's not. Tries to animate if addonName is specified

Parameters:
+ frame     - The frame to show or hide
+ addonName - The name of the addon. This is used for animation; must have <addonName>_OnUpdate function
              called from an OnUpdate event of a visible frame
+ time      - The amount of time to animate (defaults to Sol.constants.DEFAULT_ANIMATION_TIME)
+ animationType    - The type of animation to do (defaults to Sol.constants.FADE)
+ onAnimationEndFn - A function to call when the animation finishes

--]]
Sol.util.ToggleVisibility = function(frame, addonName, time, animationType, onAnimationEndFn)
    if not time then time = Sol.constants.DEFAULT_ANIMATION_TIME end
    if not animationType then animationType = Sol.constants.FADE end
    
    if frame:IsVisible() then
        -- Hide the frame
        if addonName and Sol.animation[animationType] then
            -- Animate
            Sol.animation[animationType](addonName, frame, 0, nil, time, nil, function() 
                frame:Hide() 
                if onAnimationEndFn then
                    onAnimationEndFn(addonName, frame)
                end
            end)
        else
            -- No animation
            frame:Hide()
        end
    else
        -- Show the frame
        frame:Show()
        if addonName and Sol.animation[animationType] then
            -- Animate
            if animationType == Sol.constants.FADE then
                frame:SetAlpha(0)
            elseif animationType == Sol.constants.SCALE then
                frame:SetScale(0)
            end
            local fn = nil
            if onAnimationEndFn then
                fn = function() onAnimationEndFn(addonName, frame) end
            end
            Sol.animation[animationType](addonName, frame, 1, nil, time, nil, fn)
        end
    end
end



-- Helper functions -----------------------------------------------------------
-- None of these should be called from your addons

-- Creates a place to store data about this addon, if necessary
Sol._help.CheckAddon = function(addonName)
    local addon = Sol._help.GetAddon(addonName)
    if not addon then
        addon = {name=addonName}
        table.insert(Sol._help.Addons, addon)
    end
    return addon
end

Sol._help.GetAddon = function(addonName)
    for i, addon in pairs(Sol._help.Addons) do
        if addon.name == addonName then
            return addon
        end
    end
end

-- Get the name of the settings table for the addon
Sol._help.GetAddonSettingsName = function(addonName)
    return addonName .. "_Settings"
end

-- Get the settings table for the addon
Sol._help.GetAddonSettings = function(addonName)
    return _G[Sol._help.GetAddonSettingsName(addonName)]
end

-- Helper function for Sol.config.ChangeTab
Sol._help.GetPageFromTab = function(tab)
    if not tab or not Sol.util.IsValidFrame(tab) then
        return nil
    end
    local pageName = tab:GetName():gsub("Tab", "Page")
    return _G[pageName]
end

-- Get the index of the specified buff or debuff on unit
Sol._help.UnitBuffOrDebuffIndex = function(unit, buffName, isBuff)
    local index = 1
    local unitBuff = nil
    repeat
        unitBuff = Sol.util.TernaryOp(isBuff, UnitBuff(unit, index), UnitDebuff(unit, index))
        if unitBuff == buffName then
            return index
        end
        index = index + 1
    until unitBuff == nil

    return -1
end

--Retrieves a new usable timer id
Sol._help.StaticTimerID = 0
Sol._help.GenerateTimerID = function()
    Sol._help.StaticTimerID = Sol._help.StaticTimerID + 1
    return Sol._help.StaticTimerID
end

-- Runs the timer callbacks for an addon
Sol._help.TimerUpdate = function(frame, elapsedTime, addonName)
    local origFn = Sol.hooks.GetOriginalFn("Sol", SolTimers[addonName].onUpdateFnName) 
    if origFn then
        origFn(frame, elapsedTime)
    end
    
    local time = GetTime()
    for i, timer in ipairs(SolTimers[addonName].timers) do
        if timer and not timer.finished then
            local delay = Sol.util.TernaryOp(timer.started, timer.repeatDelay, timer.delay)
            local start = Sol.util.TernaryOp(timer.started, timer.repeatStart, timer.start)
            if time - start >= delay then
                timer.fn(addonName, timer.id)
                if timer.repeatDelay then
                    timer.repeatStart = time
                    timer.started = true
                else
                    Sol.timers.RemoveTimer(addonName, timer.id)
                end
            end
        end
    end
end

-- Sets a skill on a tooltip and reads data from it, trying to match regex
Sol._help.GetSkillMatches = function(skillPage, skillIndex, tooltip, regex)
    if not tooltip then
        tooltip = GameTooltip
    end
    Sol.tooltip.ClearAllText(tooltip)
    tooltip:SetSkillItem(skillPage, skillIndex)
    tooltip:Hide()
    
    local lines = Sol.tooltip.ReadTooltip(tooltip)
    for _, line in pairs(lines.left) do
        local data = {string.match(line.text, regex)}
        if #data > 0 then
            return unpack(data)
        end
    end
end


-- Adds any missing settings to addonSettings from defaultSettings
Sol._help.AddSettings = function(addonSettings, defaultSettings)
    -- Add new settings
    for kDefault, vDefault in pairs(defaultSettings) do
        local found = false
        for kSetting, vSetting in pairs(addonSettings) do
            if kSetting == kDefault then
                found = true
                if type(vDefault) == "table" then
                    if not vSetting or type(vSetting) ~= "table" then
                        addonSettings[kDefault] = vDefault
                    else
                        Sol._help.AddSettings(vSetting, vDefault)
                    end
                end
                break
            end
        end
        if not found then
            addonSettings[kDefault] = vDefault
        end
    end
end

-- Removes any extra settings from addonSettings, based on defaultSettings
Sol._help.RemoveSettings = function(addonSettings, defaultSettings)
    -- Remove stale settings
    for kSetting, vSetting in pairs(addonSettings) do
        local found = false
        for kDefault, vDefault in pairs(defaultSettings) do
            if kSetting == kDefault then
                found = true
                if type(vSetting) == "table" then
                    if not vDefault or type(vDefault) ~= "table" then
                        addonSettings[kSetting] = vDefault
                    else
                        Sol._help.RemoveSettings(vSetting, vDefault)
                    end
                end
                break
            end
        end
        if not found then
            addonSettings[kSetting] = nil
        end
    end
end

-- function attempts to setup your config screen
Sol._help.ConfigLoad = function(addonName, settingsTable, parrentTable)

    if not parrentTable then
        parrentTable = ""
    end

    for opt, val in pairs(settingsTable) do
        if type(val) == "boolean" then
            local button = _G[addonName .. "Config_Toggle" .. parrentTable .. opt]
            if button then
                button:SetChecked(val)
            end
        elseif type(val) == "string" then
            local textBox = _G[addonName .. "Config_Text" .. parrentTable .. opt]
            if textBox then
                textBox:SetText(val)
            end
        elseif type(val) == "number" then
            local slider = _G[addonName .. "Config_Number" .. parrentTable .. opt]
            if not slider then
                local dropdown = _G[addonName .. "Config_Dropdown" .. parrentTable .. opt]
                if dropdown then
                    local selectedIndex = settingsTable[opt]
                    if selectedIndex ~= UIDropDownMenu_GetSelectedID(dropdown) then
                        UIDropDownMenu_SetSelectedID(dropdown, selectedIndex)
                    end
                end
            else
                slider:SetValue(settingsTable[opt])
            end
        elseif type(val) == "table" then
            Sol._help.ConfigLoad(addonName, settingsTable[opt], tostring(opt))
        end
    end

end

-- function attempts to save the displayed values on config screen
Sol._help.ConfigSave = function(addonName, settingsTable, parrentTable)

    if not parrentTable then
        parrentTable = ""
    end

    for opt, val in pairs(settingsTable) do
        if type(val) == "boolean" then
            local button = _G[addonName .. "Config_Toggle" .. parrentTable .. opt]
            if button then
                settingsTable[opt] = button:IsChecked()
            end
        elseif type(val) == "string" then
            local textBox = _G[addonName .. "Config_Text" .. parrentTable .. opt]
            if textBox then
                settingsTable[opt] = textBox:GetText()
            end
        elseif type(val) == "number" then
            local slider = _G[addonName .. "Config_Number" .. parrentTable .. opt]
            if not slider then
                local dropdown = _G[addonName .. "Config_Dropdown" .. parrentTable .. opt]
                if dropdown then
                    settingsTable[opt] = UIDropDownMenu_GetSelectedID(dropdown)
                end
            else
                settingsTable[opt] = slider:GetValue()
            end
        elseif type(val) == "table" then
            Sol._help.ConfigSave(addonName, settingsTable[opt], tostring(opt))
        end
    end

end

-- !!! DO NOT CALL !!! --
Sol._help.Reset = function()
    -- Unhook in reverse order
    for tableName, fnNames in pairs(SolHooks) do
        for fnName, hooks in pairs(fnNames) do
            for i = #hooks, 1, -1 do
                local hook = hooks[i]
                Sol.hooks.UnHook(hook.addon.name, fnName, hook.tbl)
            end
        end
    end
    
    Sol._help.Addons = {}
    
    SolHooks = {}
    SolTimers = {}
    
    UnHookReloadFunctions()
end

Sol._help.SaveHooks = function()
    savedHooks = {}
    for tableName, fnNames in pairs(SolHooks) do
        savedHooks[tableName] = {}
        for fnName, hooks in pairs(fnNames) do
            savedHooks[tableName][fnName] = {}
            for i, hook in ipairs(hooks) do 
                table.insert(savedHooks[tableName][fnName], hook)
            end
        end
    end
end

Sol._help.ReHookAll = function()
    if savedHooks then
        for tableName, fnNames in pairs(savedHooks) do
            for fnName, hooks in pairs(fnNames) do
                for i, hook in ipairs(hooks) do 
                    Sol.hooks.Hook(hook.addon.name, fnName, hook.newFn, hook.tbl)
                end
            end
        end
    end
    Sol._help.HookReloadFunctions()
end


local orig_Logout = Logout
local orig_ReloadUI = ReloadUI
local orig_CancelLogout = CancelLogout

Sol._help.HookReloadFunctions = function()
    Logout = Sol_Logout
    ReloadUI = Sol_ReloadUI
    if not orig_CancelLogout then
        orig_CancelLogout = CancelLogout
    end
    CancelLogout = Sol_CancelLogout
end

function Sol_CancelLogout()
    Sol._help.GetOrigCancelLogout()()
    Sol._help.ReHookAll()
end

function Sol_Logout()
    Sol._help.SaveHooks()
    Sol._help.Reset()
    Sol._help.GetOrigLogout()()
end

function Sol_ReloadUI()
    Sol._help.Reset()
    Sol._help.GetOrigReloadUI()()
end

Sol._help.GetOrigLogout = function()
    return orig_Logout
end

Sol._help.GetOrigReloadUI = function()
    return orig_ReloadUI
end

Sol._help.GetOrigCancelLogout = function()
    return orig_CancelLogout
end

Sol._help.GetHooks = function(tableName, fnName)
    return SolHooks[tableName] and SolHooks[tableName][fnName]
end

Sol._help.GetSavedHooks = function()
    return savedHooks
end

Sol._help.HookReloadFunctions()



-- End Helper functions -------------------------------------------------------

Sol.constants.SEARCH_POS_ANY = 0
Sol.constants.SEARCH_POS_START = 1
Sol.constants.SEARCH_POS_END = -1

Sol.constants.SEARCH_TYPE_ANY = "any"
Sol.constants.SEARCH_TYPE_TABLE = "table"
Sol.constants.SEARCH_TYPE_FUNCTION = "function"
Sol.constants.SEARCH_TYPE_STRING = "string"
Sol.constants.SEARCH_TYPE_NUMBER = "number"
Sol.constants.SEARCH_TYPE_BOOLEAN = "boolean"

Sol.constants.QUEST_ALL = 0
Sol.constants.QUEST_COMPLETE = 1
Sol.constants.QUEST_INCOMPLETE = 2
Sol.constants.QUEST_DAILY = 1
Sol.constants.QUEST_NORMAL = 2

Sol.constants.DEFAULT_ANIMATION_TIME = 1
Sol.constants.DEFAULT_FPS = 30
Sol.constants.FADE = "Fade"
Sol.constants.SCALE = "Scale"

Sol.constants.FLOATING_PT_PRECISION = 0.001
    
-- Blue text is 'flavor' text
-- Green or yellow's an attribute
-- Runes are purple
-- Normal text color is white
-- Error text is red
Sol.constants.FLAVOR_TEXT_COLOR = "00BFF2"
Sol.constants.GREEN_STAT_TEXT_COLOR = "00FF00"
Sol.constants.YELLOW_STAT_TEXT_COLOR = "FFFF00"
Sol.constants.RUNE_TEXT_COLOR = "BC2DFF"
Sol.constants.NORMAL_TEXT_COLOR = "FFFFFF"
Sol.constants.ERROR_TEXT_COLOR = "FF0000"

Sol.constants.CASH_SHOP_ITEM_COLOR = "A864A8"
Sol.constants.SKILL_COLOR = "8080FF"


if Sol._help.DEBUG then
    p = Sol.io.Print
    d = Sol.io.Debug
    t = Sol.io.PrintTable
end


-- Expose to global scope
_G.Sol = Sol