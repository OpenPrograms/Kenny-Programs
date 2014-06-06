local component = require("component")
local fs = require("filesystem")
local process = require("process")
local event = require("event")
local keyboard = require("keyboard")
local shell = require("shell")
local term = require("term")
local text = require("text")
local unicode = require("unicode")
local sides = require("sides")
local colors=require("colors")
local gpu = component.gpu


local function spaces(cnt)
	return string.rep(string.char(32), cnt)
end

local function spChar(letter, cnt)
	return string.rep(unicode.char(letter), cnt)
end

local solidBlk = 0x2588
local lowerBlk = 0x2584
local upperBlk = 0x2580
local margin = 20
local arrow1Row = 9
local arrow2Row = 21
local num64Row = 31
local startRow = 5

local c64 = { spaces(9)..spChar(solidBlk, 30),
              spaces(9)..spChar(solidBlk, 30),
              spaces(9)..spChar(solidBlk, 30),
              spaces(6)..spChar(solidBlk, 3)..spaces(30)..spChar(solidBlk, 3),
              spaces(6)..spChar(solidBlk, 3)..spaces(30)..spChar(solidBlk, 3),
              spaces(6)..spChar(solidBlk, 3)..spaces(30)..spChar(solidBlk, 3),
              spaces(3)..spChar(solidBlk, 3)..spaces(36)..spChar(solidBlk, 3),
              spaces(3)..spChar(solidBlk, 3)..spaces(36)..spChar(solidBlk, 3),
              spaces(3)..spChar(solidBlk, 3)..spaces(36)..spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spChar(solidBlk, 3),
              spaces(3)..spChar(solidBlk, 3)..spaces(36)..spChar(solidBlk, 3),
              spaces(3)..spChar(solidBlk, 3)..spaces(36)..spChar(solidBlk, 3),
              spaces(3)..spChar(solidBlk, 3)..spaces(36)..spChar(solidBlk, 3),
              spaces(6)..spChar(solidBlk, 3)..spaces(30)..spChar(solidBlk, 3),
              spaces(6)..spChar(solidBlk, 3)..spaces(30)..spChar(solidBlk, 3),
              spaces(6)..spChar(solidBlk, 3)..spaces(30)..spChar(solidBlk, 3),
              spaces(9)..spChar(solidBlk, 30),
              spaces(9)..spChar(solidBlk, 30),
              spaces(9)..spChar(solidBlk, 30) }

-- also used for lines 22 - 30

local ribbon = { 
    spChar(solidBlk, 21),
    spChar(solidBlk, 20),
    spChar(solidBlk, 19),
    spChar(solidBlk, 18),
    spChar(solidBlk, 17),
    spChar(solidBlk, 18),
    spChar(solidBlk, 19),
    spChar(solidBlk, 20),
    spChar(solidBlk, 21) }

local num64 = {
    spaces(6)..spChar(solidBlk,6)..spaces(18)..spChar(solidBlk,3),
    spaces(3)..spChar(solidBlk,3)..spaces(6)..spChar(solidBlk,3)..spaces(14)..spChar(solidBlk,4),
    spChar(solidBlk,3)..spaces(12)..spChar(solidBlk,3)..spaces(9)..spChar(solidBlk,2)..spaces(1)..spChar(solidBlk,3),
    spChar(solidBlk,3)..spaces(23)..spChar(solidBlk,2)..spaces(2)..spChar(solidBlk,3),
    spChar(solidBlk,3)..spaces(3)..spChar(solidBlk,6)..spaces(13)..spChar(solidBlk,2)..spaces(3)..spChar(solidBlk,3),
    spChar(solidBlk,6)..spaces(6)..spChar(solidBlk,3)..spaces(9)..spChar(solidBlk,10),
    spChar(solidBlk,3)..spaces(12)..spChar(solidBlk,3)..spaces(12)..spChar(solidBlk,3),
    spaces(3)..spChar(solidBlk,3)..spaces(6)..spChar(solidBlk,3)..spaces(15)..spChar(solidBlk,3),
    spaces(6)..spChar(solidBlk,6)..spaces(18)..spChar(solidBlk,3) }

gpu.setBackground(0x0000ee)
gpu.setForeground(0x7ac5cd)
term.clear()
for idx, line in pairs(c64) do
    term.setCursor(margin, idx + startRow)
    print (line)
end
  

gpu.setForeground(0x7ac5cd)

for idx, line in pairs(ribbon) do
    term.setCursor(margin + 45, idx + arrow1Row + startRow)
    print (line)
end

gpu.setForeground(0xFF0000)
for idx, line in pairs(ribbon) do
    term.setCursor(margin + 45, idx + arrow2Row + startRow)
    print (line)
end

gpu.setForeground(0xFFFFFF)

for idx, line in pairs(num64) do
    term.setCursor(margin + 46, idx + num64Row + startRow)
    print (line)
end


term.setCursor(1,45)




