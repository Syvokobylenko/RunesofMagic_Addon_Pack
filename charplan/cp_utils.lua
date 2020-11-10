--[[
    CharPlan

    Utility funcitons
]]

local Utils = {}
local CP = _G.Charplan
CP.Utils = Utils


function Utils.TableCopy(src,dst)
    local res = dst or {}
    for i in pairs(res) do res[i]=nil end

    for i,v in pairs(src) do
        if type(v)=="table" then
            res[i]=Utils.TableCopy(v)
        else
            res[i]=v
        end
    end
    return res
end


function Utils.ToRoman(num)
    local letters={"M","CM","D","CD","C","XC","L","XL","X", "IX", "V", "IV", "I"}
    local numbers={1000,900,500,400,100,90,50,40,10,9,5,4,1}

    local result=""
    for i,val in ipairs(numbers) do
        while num >= val do
            num = num-val
            result = result .. letters[i]
        end
    end
    return result
end


function Utils.RomanToNum( roman )
    local Num = { ["M"] = 1000, ["D"] = 500, ["C"] = 100, ["L"] = 50, ["X"] = 10, ["V"] = 5, ["I"] = 1 }
    local numeral = 0

    local i = 1
    local strlen = string.len(roman)
    while i < strlen do
        local z1, z2 = Num[ string.sub(roman,i,i) ], Num[ string.sub(roman,i+1,i+1) ]
        if z1 < z2 then
            numeral = numeral + ( z2 - z1 )
            i = i + 2
        else
            numeral = numeral + z1
            i = i + 1
        end
    end

    if i <= strlen then numeral = numeral + Num[ string.sub(roman,i,i) ] end

    return numeral
end

function Utils.FormatThousands(number)
    local left,num,right = string.match(tostring(number),'^([^%d]*%d)(%d*)(.-)$')
    num = num:reverse():gsub('(%d%d%d)','%1'..COMMA)
    return left..(num:reverse())..right
end

function UIDropDownMenu_AddSeparator()
    local separator = { text = string.rep("-",12), isTitle = 1}
    UIDropDownMenu_AddButton(separator)
end

----------------------
-- Color class
CPColor={
 r=1,g=1,b=1
}
CPColor.__index = CPColor

function CPColor.New(r,g,b,a)
    local newcol={}
    setmetatable(newcol,CPColor)
    newcol.r = r or 1
    newcol.g = g or 1
    newcol.b = b or 1
    newcol.a = a or 1
    CPColor.Clamp(newcol)
    return newcol
end

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

function CPColor:Get()
    self:Clamp()

    return self.r,self.g,self.b
end

function CPColor:Brightness(fac)
    local Y = 0.299*self.r + 0.587*self.g + 0.114*self.b
    local U = (self.b - Y)*0.493
    local V = (self.r - Y)*0.877

    Y=Y*fac

    return CPColor.New(
            Y + V*1.140,
            Y - 0.39466*U - 0.5806*V,
            Y + U*2.028)
end

function CPColor:Dup()
    return CPColor.New(self.r,self.g,self.b,self.a)
end



--[[ [ Runes of Magic item link hash calculation code ]]
--//////////////////////////////////////////////////////////////////
-- Runes of Magic item link hash calculation code

-- Author: Valacar (aka Duppy of the Runes of Magic US Osha server)
-- Release Date: September 12th, 2010

-- Credit goes to Neil Richardson for the xor, and rshift function
-- which I slightly modified. The original code can be found at:
-- http://luamemcached.googlecode.com/svn/trunk/CRC32.lua

-- I could care less what anyone does with the code (i.e. it's public domain),
-- but I'd very much appreciate being given credit (to me Valacar) if you do
-- use the code in any way.


-- Exclusive OR
local function xor(a, b)
    local calc = 0
    for i = 32, 0, -1 do
        local val = 2 ^ i
        local aa = false
        local bb = false
        if a == 0 then
            calc = calc + b
            break
        end
        if b == 0 then
            calc = calc + a
            break
        end
        if a >= val then
            aa = true
            a = a - val
        end
        if b >= val then
            bb = true
            b = b - val
        end
        if not (aa and bb) and (aa or bb) then
             calc = calc + val
        end
    end
     return calc
end


-- binary shift right
local function rshift(num, right)
    right = right % 0x20
    local res = num / (2 ^ right)
    return math.floor(res)
end

-- get lower word of a 32-bit number
local function loword(num)
    return num % 2^16
end

-- get high word of a 32-bit number
local function hiword(num)
    return math.floor(num/2^16) % 2^16
end

-- multiply two 32-bit numbers, but returns only the low dword of the 64-bit result
local function mymul(num1, num2)
    -- Note: required for accuraty
    local x = loword(num2) * num1
    local y = (hiword(num2) * num1) * 2^16
    local a = hiword(x) + hiword(y)
    local b = loword(x)

    return ((a * 2^16) + b) % 2^32
end


--//////////////////////////////////////////////////////////////////
-- Calculates hash value of an item based on first 11 hex numbers of an item link
function Utils.CalculateItemLinkHash(num)

    assert(#num == 11, "11 values required!")

    local sum = 0
    for _,w in ipairs(num) do
        sum = sum + w
    end

    local a,b,c,e = sum,0,0,0,0,0

    for x,d in ipairs(num) do
        b = (d * (x-1)) % 2^32
        e = rshift(d, (x-1)*16)
        b = (b + e + a) % 2^32
        a = xor(b, d)
    end

    for _,d in ipairs(num) do
        c = d + 1
        c = mymul(c, a)
        a = mymul(d, c)
        a = math.floor(a/2^16)
        a = a + c
        a = xor(a, d)
    end

    hash = loword(a)

    return hash
end
--[[ ] Runes of Magic item link hash calculation code ]]

