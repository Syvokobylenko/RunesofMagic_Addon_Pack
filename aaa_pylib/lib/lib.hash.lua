--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...

------------------------------------------------------ lib.hash ------------------------------------------------------
local me = {
	exports={"CalculateItemLinkHash", "CalculateMD5"}
}
--[[---------------
LuaBit v0.4
-------------------
a bitwise operation lib for lua.
http://luaforge.net/projects/bit/
How to use:
-------------------
bit.bnot(n) -- bitwise not (~n)
bit.band(m, n) -- bitwise and (m & n)
bit.bor(m, n) -- bitwise or (m | n)
bit.bxor(m, n) -- bitwise xor (m ^ n)
bit.brshift(n, bits) -- right shift (n >> bits)
bit.blshift(n, bits) -- left shift (n << bits)
bit.blogic_rshift(n, bits) -- logic right shift(zero fill >>>)
Please note that bit.brshift and bit.blshift only support number within
32 bits.
2 utility functions are provided too:
bit.tobits(n) -- convert n into a bit table(which is a 1/0 sequence)
-- high bits first
bit.tonumb(bit_tbl) -- convert a bit table into a number
-------------------
Under the MIT license.
copyright(c) 2006~2007 hanzhao (abrash_han@hotmail.com)
--]]---------------
---[[ [ ]]
------------------------
-- bit lib implementions
function me.check_int(n)
-- checking not float
	if(n - math.floor(n) > 0) then
		error("trying to use bitwise operation on non-integer!")
	end
end
function me.tbl_to_number(tbl)
	local n = #tbl
	local rslt = 0
	local power = 1
	for i = 1, n do
		rslt = rslt + tbl[i]*power
		power = power*2
	end
	return rslt
end
function me.expand(tbl_m, tbl_n)
	local big = {}
	local small = {}
	if(#tbl_m > #tbl_n) then
		big = tbl_m
		small = tbl_n
	else
		big = tbl_n
		small = tbl_m
	end
	-- expand small
	for i = #small + 1, #big do
		small[i] = 0
	end
end
function me.bit_not(n)
	local tbl = me.to_bits(n)
	local size = math.max(#tbl, 32)
	for i = 1, size do
		if(tbl[i] == 1) then
			tbl[i] = 0
		else
			tbl[i] = 1
		end
	end
	return me.tbl_to_number(tbl)
end
function me.to_bits(n)
	me.check_int(n)
	if(n < 0) then
		-- negative
		return me.to_bits(me.bit_not(math.abs(n)) + 1)
	end
	-- to bits table
	local tbl = {}
	local cnt = 1
	while (n > 0) do
		local last = math.mod(n,2)
		if(last == 1) then
			tbl[cnt] = 1
		else
			tbl[cnt] = 0
		end
		n = (n-last)/2
		cnt = cnt + 1
	end
	return tbl
end
function me.bit_or(m, n)
	local tbl_m = me.to_bits(m)
	local tbl_n = me.to_bits(n)
	me.expand(tbl_m, tbl_n)
	local tbl = {}
	local rslt = math.max(#tbl_m, #tbl_n)
	for i = 1, rslt do
		if(tbl_m[i]== 0 and tbl_n[i] == 0) then
			tbl[i] = 0
		else
			tbl[i] = 1
		end
	end
	return me.tbl_to_number(tbl)
end
function me.bit_and(m, n)
	local tbl_m = me.to_bits(m)
	local tbl_n = me.to_bits(n)
	me.expand(tbl_m, tbl_n)
	local tbl = {}
	local rslt = math.max(#tbl_m, #tbl_n)
	for i = 1, rslt do
		if(tbl_m[i]== 0 or tbl_n[i] == 0) then
			tbl[i] = 0
		else
			tbl[i] = 1
		end
	end
	return me.tbl_to_number(tbl)
end
function me.bit_xor(m, n)
	local tbl_m = me.to_bits(m)
	local tbl_n = me.to_bits(n)
	me.expand(tbl_m, tbl_n)
	local tbl = {}
	local rslt = math.max(#tbl_m, #tbl_n)
	for i = 1, rslt do
		if(tbl_m[i] ~= tbl_n[i]) then
			tbl[i] = 1
		else
			tbl[i] = 0
		end
	end
	return me.tbl_to_number(tbl)
end
function me.bit_rshift(n, bits)
	me.check_int(n)
	local high_bit = 0
	if(n < 0) then
		-- negative
		n = me.bit_not(math.abs(n)) + 1
		high_bit = 2147483648 -- 0x80000000
	end
	for i=1, bits do
		n = n/2
		n = me.bit_or(math.floor(n), high_bit)
	end
	return math.floor(n)
end
-- logic rightshift assures zero filling shift
function me.bit_logic_rshift(n, bits)
	check_int(n)
	if(n < 0) then
	-- negative
		n = bit_not(math.abs(n)) + 1
	end
	for i=1, bits do
		n = n/2
	end
	return math.floor(n)
end
function me.bit_lshift(n, bits)
	me.check_int(n)
	if(n < 0) then
		-- negative
		n = me.bit_not(math.abs(n)) + 1
	end
	for i=1, bits do
		n = n*2
	end
	return me.bit_and(n, 4294967295) -- 0xFFFFFFFF
end
function me.bit_xor2(m, n)
	local rhs = me.bit_or(me.bit_not(m), me.bit_not(n))
	local lhs = me.bit_or(m, n)
	local rslt = me.bit_and(lhs, rhs)
	return rslt
end
-- An MD5 mplementation in Lua, requires bitlib (hacked to use LuaBit from above, ugh)
-- 10/02/2001 jcw@equi4.com
me.md5={ff=tonumber('ffffffff',16),consts={}}
string.gsub([[ d76aa478 e8c7b756 242070db c1bdceee
f57c0faf 4787c62a a8304613 fd469501
698098d8 8b44f7af ffff5bb1 895cd7be
6b901122 fd987193 a679438e 49b40821
f61e2562 c040b340 265e5a51 e9b6c7aa
d62f105d 02441453 d8a1e681 e7d3fbc8
21e1cde6 c33707d6 f4d50d87 455a14ed
a9e3e905 fcefa3f8 676f02d9 8d2a4c8a
fffa3942 8771f681 6d9d6122 fde5380c
a4beea44 4bdecfa9 f6bb4b60 bebfbc70
289b7ec6 eaa127fa d4ef3085 04881d05
d9d4d039 e6db99e5 1fa27cf8 c4ac5665
f4292244 432aff97 ab9423a7 fc93a039
655b59c3 8f0ccc92 ffeff47d 85845dd1
6fa87e4f fe2ce6e0 a3014314 4e0811a1
f7537e82 bd3af235 2ad7d2bb eb86d391
67452301 efcdab89 98badcfe 10325476 ]],"(%w+)", function (s) table.insert(me.md5.consts, tonumber(s,16)) end)
function me.md5.transform(A,B,C,D,X)
	local f=function (x,y,z) return me.bit_or(me.bit_and(x,y),me.bit_and(-x-1,z)) end
	local g=function (x,y,z) return me.bit_or(me.bit_and(x,z),me.bit_and(y,-z-1)) end
	local h=function (x,y,z) return me.bit_xor(x,me.bit_xor(y,z)) end
	local i=function (x,y,z) return me.bit_xor(y,me.bit_or(x,-z-1)) end
	local z=function (f,a,b,c,d,x,s,ac)
		a=me.bit_and(a+f(b,c,d)+x+ac,me.md5.ff)
		-- be *very* careful that left shift does not cause rounding!
		return me.bit_or(me.bit_lshift(me.bit_and(a,me.bit_rshift(me.md5.ff,s)),s),me.bit_rshift(a,32-s))+b
	end
	local a,b,c,d=A,B,C,D
	local t=me.md5.consts
	a=z(f,a,b,c,d,X[ 0], 7,t[ 1])
	d=z(f,d,a,b,c,X[ 1],12,t[ 2])
	c=z(f,c,d,a,b,X[ 2],17,t[ 3])
	b=z(f,b,c,d,a,X[ 3],22,t[ 4])
	a=z(f,a,b,c,d,X[ 4], 7,t[ 5])
	d=z(f,d,a,b,c,X[ 5],12,t[ 6])
	c=z(f,c,d,a,b,X[ 6],17,t[ 7])
	b=z(f,b,c,d,a,X[ 7],22,t[ 8])
	a=z(f,a,b,c,d,X[ 8], 7,t[ 9])
	d=z(f,d,a,b,c,X[ 9],12,t[10])
	c=z(f,c,d,a,b,X[10],17,t[11])
	b=z(f,b,c,d,a,X[11],22,t[12])
	a=z(f,a,b,c,d,X[12], 7,t[13])
	d=z(f,d,a,b,c,X[13],12,t[14])
	c=z(f,c,d,a,b,X[14],17,t[15])
	b=z(f,b,c,d,a,X[15],22,t[16])
	a=z(g,a,b,c,d,X[ 1], 5,t[17])
	d=z(g,d,a,b,c,X[ 6], 9,t[18])
	c=z(g,c,d,a,b,X[11],14,t[19])
	b=z(g,b,c,d,a,X[ 0],20,t[20])
	a=z(g,a,b,c,d,X[ 5], 5,t[21])
	d=z(g,d,a,b,c,X[10], 9,t[22])
	c=z(g,c,d,a,b,X[15],14,t[23])
	b=z(g,b,c,d,a,X[ 4],20,t[24])
	a=z(g,a,b,c,d,X[ 9], 5,t[25])
	d=z(g,d,a,b,c,X[14], 9,t[26])
	c=z(g,c,d,a,b,X[ 3],14,t[27])
	b=z(g,b,c,d,a,X[ 8],20,t[28])
	a=z(g,a,b,c,d,X[13], 5,t[29])
	d=z(g,d,a,b,c,X[ 2], 9,t[30])
	c=z(g,c,d,a,b,X[ 7],14,t[31])
	b=z(g,b,c,d,a,X[12],20,t[32])
	a=z(h,a,b,c,d,X[ 5], 4,t[33])
	d=z(h,d,a,b,c,X[ 8],11,t[34])
	c=z(h,c,d,a,b,X[11],16,t[35])
	b=z(h,b,c,d,a,X[14],23,t[36])
	a=z(h,a,b,c,d,X[ 1], 4,t[37])
	d=z(h,d,a,b,c,X[ 4],11,t[38])
	c=z(h,c,d,a,b,X[ 7],16,t[39])
	b=z(h,b,c,d,a,X[10],23,t[40])
	a=z(h,a,b,c,d,X[13], 4,t[41])
	d=z(h,d,a,b,c,X[ 0],11,t[42])
	c=z(h,c,d,a,b,X[ 3],16,t[43])
	b=z(h,b,c,d,a,X[ 6],23,t[44])
	a=z(h,a,b,c,d,X[ 9], 4,t[45])
	d=z(h,d,a,b,c,X[12],11,t[46])
	c=z(h,c,d,a,b,X[15],16,t[47])
	b=z(h,b,c,d,a,X[ 2],23,t[48])
	a=z(i,a,b,c,d,X[ 0], 6,t[49])
	d=z(i,d,a,b,c,X[ 7],10,t[50])
	c=z(i,c,d,a,b,X[14],15,t[51])
	b=z(i,b,c,d,a,X[ 5],21,t[52])
	a=z(i,a,b,c,d,X[12], 6,t[53])
	d=z(i,d,a,b,c,X[ 3],10,t[54])
	c=z(i,c,d,a,b,X[10],15,t[55])
	b=z(i,b,c,d,a,X[ 1],21,t[56])
	a=z(i,a,b,c,d,X[ 8], 6,t[57])
	d=z(i,d,a,b,c,X[15],10,t[58])
	c=z(i,c,d,a,b,X[ 6],15,t[59])
	b=z(i,b,c,d,a,X[13],21,t[60])
	a=z(i,a,b,c,d,X[ 4], 6,t[61])
	d=z(i,d,a,b,c,X[11],10,t[62])
	c=z(i,c,d,a,b,X[ 2],15,t[63])
	b=z(i,b,c,d,a,X[ 9],21,t[64])
	return A+a,B+b,C+c,D+d
end
-- convert little-endian 32-bit int to a 4-char string
function me.leIstr(i)
	local f=function (s) return string.char(me.bit_and(me.bit_rshift(i,s),255)) end
	return f(0)..f(8)..f(16)..f(24)
end
-- convert raw string to big-endian int
function me.beInt(s)
	local v=0
	for i=1,string.len(s) do v=v*256+string.byte(s,i) end
	return v
end
-- convert raw string to little-endian int
function me.leInt(s)
	local v=0
	for i=string.len(s),1,-1 do v=v*256+string.byte(s,i) end
	return v
end
-- cut up a string in little-endian ints of given size
function me.leStrCuts(s,...)
	local o,r=1,{}
	for i=1,#arg do
		table.insert(r,me.leInt(string.sub(s,o,o+arg[i]-1)))
		o=o+arg[i]
	end
	return r
end
function me.CalculateMD5(s)
	AssertType(s, "s",me:GetFullTableName()..".md5","string", "number")
	local msgLen=string.len(s)
	local padLen=56- msgLen % 64
	if msgLen % 64 > 56 then padLen=padLen+64 end
	if padLen==0 then padLen=64 end
	s=s..string.char(128)..string.rep(string.char(0),padLen-1)
	s=s..me.leIstr(8*msgLen)..me.leIstr(0)
	assert(string.len(s) % 64 ==0)
	local t=me.md5.consts
	local a,b,c,d=t[65],t[66],t[67],t[68]
	for i=1,string.len(s),64 do
		local X=me.leStrCuts(string.sub(s,i,i+63),4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4)
		assert(#X==16)
		X[0]=table.remove(X,1) -- zero based!
		a,b,c,d=me.md5.transform(a,b,c,d,X)
	end
	local swap=function (w) return me.beInt(me.leIstr(w)) end
	return string.format("%08x%08x%08x%08x",swap(a),swap(b),swap(c),swap(d))
end
--[[ Item link data --------------------------------------------------------------------------------
|Hitem:<itemid><bind><unknown& runePlus& tier& max dura><statAB >x3 < runes >x4 < current dura><hash>|h|cff < color>[<name>]|r|h
Ex: |Hitem:33E7E 2 2c8c1064 0 0 0 0 0 0 0 2EE0 < hash>|h|cffc805f8[Yawaka Guard]|r|h
Ex: |Hitem:33E7E 2 2c 8c 10 64 0 0 0 0 0 0 0 2EE0 < hash>|h|cffc805f8[Yawaka Guard]|r|h
Yawaka Guard, + 12, T9, 4 empty rune slots, Dura: 120/100
itemid : length 5
ItemID in hex (Ex: Yawaka Guard, ItemID: 212606, Hex: 33E7E)
bind : length 1 - 3
1 = nonbindable
2 = bound
3 = boe
10 = Equipment Protection (equipment locked?)
30 = Equipment Protection
50 = Equipment Protection
70 = Equipment Protection
90 = Equipment Protection
100 = prevent hijack (don't drop on PK death)
201 = seen when linking an item from craft frame (hides bind status and dura on the tooltip)
400 = set skill extracted
500 = set skill extracted and prevent hijack
unknown : length 0 - 2
unknown, but it seems to be used to differentiate two identical items in the backpack. linking two identical items will make
the same link but if you get the links (GetBagItemLink(invIndex)) of each item they will be different.
Leaving it off doesn't affect any of the vital stats.
Ex: 2 identical Fine Leather Belts
1st: 36de9 1 a64 0 0 0 0 0 0 0 2710 5a6f
2nd: 36de9 1 2f00a64 0 0 0 0 0 0 0 2710 d13e
1st + 1: 36de9 1 10a64 0 0 0 0 0 0 0 2710 da7a
2nd + 1: 36de9 1 2e010a64 0 0 0 0 0 0 0 2710 61d4
runePlus : length 0 - 2
empty rune slots & plus
00/20/40/60/80h = 0 - 4 empty rune slots
00h - 1Fh = + 0 - 31
41 = 2 empty rune slots, + 1
8C = 4 empty rune slots, + 12
4 x 20h = 80h
+ 12 = 0Ch
80 + 0C = 8Ch
90 = 4 empty rune slots, + 16
4 x 20h = 80h
+ 16 = 10h
80h + 10h = 90h
Ex: 9Fh = 4 empty rune slots, + 31
Ex: 70h = 3 empty rune slots, + 16
Ex: 00h = no empty rune slots, + 0
Ex: 26h = 1 empty rune slot, + 6
"Rune: x/y" on the tooltip
x = number of rune slots that are filled (up to 4, since there are only 4 spaces in the for runes stats)
y=<# empty rune slots > + x
tier : length 1 - 2
0A = not tiered, + to default tier (0Bh - 1Fh = 1 - 21)
2A = + 1 rarity level, base tier
4A = + 2 rarity level, base tier
+ rarity level is seen in crafted items
Ex: Brown Hailstone at T9 (rarity level 5 i.e. + 2 above base of 3) = 50h
4Ah + 06h = 50h
maxdura : length 2
this is the visible max dura, straight Dec to Hex
Ex: 100 dura = 64h
stats : length (4x2) x3
4 each, 2 combine into an 8 - hexadecimal digit string, 3 strings separated by spaces, or 0s if no stats there.
Tooltip / hex string - Stat Order
statB
statA
statD
statC
statF
statE
hex string
< statA/statB><statC/statD><statE/statF >
runes : length 5 x4
5 per rune, 4 seperated by spaces, 0s if no rune
Ex: Fatal I, ItemID: 520761, Hex: 7F239
current dura : length 4
this is current dura.<current dura>*100 converted to hex
Ex: 8000 [1F40h in hex] for 80 current dura
Ex: 10000 [2710h in hex] for 100 current dura
Ex: 12000 [2EE0h in hex] for 120 current dura
hash : length 4
Search for 'Runes of Magic item link hash calculation code' in 'ItemPreview/Lua/Main.lua' to view the code.
Thanks to 'ohos' for getting the ball rolling and Valacar (Duppy of Osha - US) for completing the code.
thread that started it all: https://forum.runesofmagic.com/showthread.php?p = 2368150#post2368150
code from: https://forum.runesofmagic.com/showthread.php?t = 280594
----------------------------------------------------------------------------------]]
--//////////////////////////////////////////////////////////////////
-- Runes of Magic item link hash calculation code
-- Author: Valacar (aka Duppy of the Runes of Magic US Osha server)
-- Release Date: September 12th, 2010
-- Credit goes to Neil Richardson for the xor, lshift, and rshift function
-- which I slightly modified. The original code can be found at:
-- http://luamemcached.googlecode.com/svn/trunk/CRC32.lua
-- I could care less what anyone does with the code (i.e. it's public domain),
-- but I'd very much appreciate being given credit (to me Valacar) if you do
-- use the code in any way.
-- Exclusive OR
function me.xor(a, b)
	local calc = 0
	for i = 32, 0, - 1 do
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
-- binary shift left
function me.lshift(num, left)
	local res = num * (2 ^ left)
	return res % (2 ^ 32)
end
-- binary shift right
function me.rshift(num, right)
	right = right % 0x20
	local res = num / (2 ^ right)
	return math.floor(res)
end
-- get lower word of a 32 - bit number
function me.loword(num)
	return me.rshift(me.lshift(num, 16), 16)
end
-- get high word of a 32 - bit number
function me.hiword(num)
	return me.rshift(num, 16) % 2^16
end
-- multiply two 32 - bit numbers, but returns only the low dword of the 64 - bit result
function me.mymul(num1, num2)
	local x = me.loword(num2) * num1
	local y=(me.hiword(num2) * num1) * 2^16
	local a = me.hiword(x) + me.hiword(y)
	local b = me.loword(x)
	return (a * 2^16) + b
end
--//////////////////////////////////////////////////////////////////
-- Calculates hash value of an item based on first 11 hex numbers of an item link
function me.CalculateItemLinkHash(values)
	assert(type(values) == "string", "Must pass a string to CalculateItemLinkHash consisting of 11 hex values separated by a space.")
	local num = { values:match("^(%x+)%s+(%x+)%s+(%x+)%s+(%x+)%s+(%x+)%s+(%x+)%s+(%x+)%s+(%x+)%s+(%x+)%s+(%x+)%s+(%x+)") }
	assert(#num == 11, "11 hex values required!")
	local sum = 0
	for s = 1, 11 do
		num[s] = tonumber(num[s], 16)
		sum = sum + num[s]
	end
	local a, b, c, d, e, x, i = sum, 0, 0, 0, 0, 0, 0
	repeat
		d = num[x + 1]
		b = d
		b = b * x
		b = b % 2^32
		e = d
		e = me.rshift(e, i)
		i = i + 0x10
		x = x + 1
		e = e + a
		e = e % 2^32
		b = b + e
		b = b % 2^32
		b = me.xor(b, d)
		a = b
	until (i >= 0xB0)
	local j = 0
	repeat
		d = num[j + 1]
		c = d + 1
		c = me.mymul(c, a)
		c = c % 2^32
		a = d
		a = me.mymul(a, c)
		a = a % 2^32
		a = me.rshift(a, 16)
		a = a + c
		j = j + 1
		a = me.xor(a, d)
	until (j >= 0x0B)
	return me.loword(a)
end
lib.CreateTable(me,name,path, lib)
