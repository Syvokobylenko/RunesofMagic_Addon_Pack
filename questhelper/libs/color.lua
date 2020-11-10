--[[
-----------------------------------------------------------------------------
-- CPColor
--  by McBen
--  a color helper class
--
--  License: MIT/X
-----------------------------------------------------------------------------
 ]]
local CPColor = LibStub:NewLibrary("CPColor", 1)
if not CPColor then return end

CPColor.__index = CPColor

local predefined={
    ["RED"]       ={1   ,0   ,0    },
    ["DARK_RED"]  ={0.5 ,0   ,0    },
    ["LIGHT_RED"] ={0.96,0.6 ,0.47 }, -- raid chat
    ["PINK"]      ={1   ,0.8 ,0.8  },
    ["GREY"]      ={0.6 ,0.6 ,0.6  },
    ["WHITE"]     ={1   ,1   ,1    },
    ["BLUE"]      ={0   ,0.75,0.95 }, -- party chat
    ["LIGHT_BLUE"]={0   ,1   ,1    }, -- channel chat
    ["DARK_BLUE"] ={0   ,0.23,1    }, -- npc
    ["GREEN"]     ={0.25,1.00,0.25 }, -- guild chat
    ["DARK_GREEN"]={0.04,0.37,0.04 }, -- zone / quest
    ["ORANGE"]    ={1   ,0.5 ,0    }, -- system chat
    ["YELLOW"]    ={0.9 ,0.9 ,0.1  }, -- gm chat
    ["BROWN"]     ={0.96,0.6 ,0.47 }, -- bg chat
    ["VIOLET"]    ={0.76,0.56,0.94 }, -- yell chat
    ["PURPLE"]    ={0.91,0.1 ,0.54 }, -- combat chat
    ["BRIGHT_PURPLE"]={0.92,0.47,0.86 }, -- whisper chat
--x=function () return 0.80,0.46,0.05 end, -- item
}

--- predefined colors
-- Directly usable where r,g,b values are required
--
-- @example:
--           frame:SetColor( CPColor.Color("RED") )
--           local mycol = CPColor.New( CPColor.Color("GREY") )
function CPColor.Color(name)
    return unpack(predefined[name])
end

--- create a new color
-- @param r,g,b,a  red,green,blue,alpha
-- @param color    or just another color obj
function CPColor.New(r,g,b,a)
    local newcol={}
    setmetatable(newcol,CPColor)

    if type(r)=="table" then
        newcol.r = r.r or 1
        newcol.g = r.g or 1
        newcol.b = r.b or 1
        newcol.a = r.a or 1
    else
        newcol.r = r or 1
        newcol.g = g or 1
        newcol.b = b or 1
        newcol.a = a or 1
    end
    CPColor.Clamp(newcol)
    return newcol
end

function CPColor:Set(r,g,b,a)
    self.r = r or 1
    self.g = g or 1
    self.b = b or 1
    self.a = a or 1
    self:Clamp()
end

function CPColor:OfItem_n(item_id)
    return CPColor.New(GetItemQualityColor(GetQualityByGUID( item_id )))
end

--- normalize color
-- to keep values between 0-1
function CPColor:Clamp()
    if self.r < 0 then self.r = 0 end
    if self.r > 1 then self.r = 1 end
    if self.g < 0 then self.g = 0 end
    if self.g > 1 then self.g = 1 end
    if self.b < 0 then self.b = 0 end
    if self.b > 1 then self.b = 1 end
    if self.a < 0 then self.a = 0 end
    if self.a > 1 then self.a = 1 end
end

--- get text color code
-- @return string "|caarrggbb" usable in text
function CPColor:Code()
    local r,g,b,a = self.r*256,self.g*256,self.b*256,self.a*256
    if r < 0 then r = 0 end
    if r > 255 then r = 255 end
    if g < 0 then g = 0 end
    if g > 255 then g = 255 end
    if b < 0 then b = 0 end
    if b > 255 then b = 255 end
    if a < 0 then a = 0 end
    if a > 255 then a = 255 end

    return string.format("|c%02x%02x%02x%02x",a,r,g,b)
end

--- get r,g,b
-- example:
-- local red = CPColor.new(1,0,0)
-- DEFAULT_CHAT_FRAME:AddMessage("red", red:Get())
function CPColor:Get()
    self:Clamp()

    return self.r,self.g,self.b
end

--- create new color with changed brightness
-- change color brightness
function CPColor:Brightness_n(fac)
    local n = self:Dup()
    n:Brightness(fac)
    return n
end

function CPColor:Brightness(fac)
    local Y = 0.299*self.r + 0.587*self.g + 0.114*self.b
    local U = (self.b - Y)*0.493
    local V = (self.r - Y)*0.877

    Y=Y*fac

    self.r =Y + V*1.140
    self.g =Y - 0.39466*U - 0.5806*V
    self.b =Y + U*2.028
    self:Clamp()
end

function CPColor:calcHSV()
    local min = math.min(self.r,self.g,self.b)
    local max = math.max(self.r,self.g,self.b)
    if max==0 then return -1,0,0 end

    local delta = max-min

    if max==min then return 0,0,max end

    local h
    if self.r==max then      h=  (self.g-self.b) / delta
    elseif self.g==max then  h=2+(self.b-self.r) / delta
    else                     h=4+(self.r-self.g) / delta
    end

    h = h*60
    if h<0 then h=h+360 end

    return h, delta/max, max
end

function CPColor:FromHSV(h,s,v)
    if s==0 then
        self:Set(v,v,v)
        return
    end

    h = (h%360)/60
    local i= math.floor(h)
    local f = h-i
    local p = v*(1-s)
    local q = v*(1-s*f)
    local t = v*(1-s*(1-f))

    if i==0     then self:Set(v,t,p)
    elseif i==1 then self:Set(q,v,p)
    elseif i==2 then self:Set(p,v,t)
    elseif i==3 then self:Set(p,q,v)
    elseif i==4 then self:Set(t,p,v)
    else             self:Set(v,p,q)
    end
end

--- copy color
function CPColor:Dup()
    return CPColor.New(self)
end

function CPColor:Random()
    self.r = math.random()
    self.g = math.random()
    self.b = math.random()
    self.a = 1
end

function CPColor:FadeTo_n(color,fac)
    local n = self:Dup()
    n:FadeTo_n(color,fac)
    return n
end

--- Fade color to another
-- @param fac 0=nothing,1=other color
function CPColor:FadeTo(color,fac)
    if fac<=0 then return end
    if fac>=1 then
        self.r,self.g,self.b,self.a=color.r,color.g,color.b,color.a
        return
    end
    local negf = 1-fac
    self.r = self.r*negf + color.r*fac
    self.g = self.g*negf + color.g*fac
    self.b = self.b*negf + color.b*fac
    self.a = self.a*negf + color.a*fac
end




