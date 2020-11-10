------------------------------------------------------
-- QuestHelper
--
-- file: API
-- desc: general stuff / tool functions
--
-- Author: McBen
-- ver:  v7.4.5
-- date: 2014-03-16T19:14:32Z
------------------------------------------------------

local API= {}
_G.QH.API = API

local CPColor = LibStub("CPColor")
local COL = CPColor.Color

------------------------------------------------------
-- Output text in chatwindow if debug mode is on
function API.Debug(text)
  if QH_Options.debug then
    DEFAULT_CHAT_FRAME:AddMessage("QH: "..text, COL("GREY"))
  end
end

------------------------------------------------------
-- Output an error message if debug mode is on
function API.DebugErr(text)
  if QH_Options.debug then
    DEFAULT_CHAT_FRAME:AddMessage("QH ERROR: "..text, COL("RED"))
  end
end

------------------------------------------------------
-- Output text in chatwindow
function API.Print(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
end


