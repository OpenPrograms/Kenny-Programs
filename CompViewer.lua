local component = require("component")
local event = require("event")
local fs = require("filesystem")
local keyboard = require("keyboard")
local shell = require("shell")
local term = require("term")
local text = require("text")
local unicode = require("unicode")
local sides = require("sides")
local colors=require("colors")

local gpu = component.gpu

local menuList = {}
local menuLen = 1
local menuWid = 0

local compList = {}
local compLen = 1

local col = 1
local currRow = 1

local w, h = gpu.getResolution()
local offset = 0
local running = true

local fileCount = -1
local fileFirst = ""

local function isAdvanced()
	return (gpu.getDepth() > 1)
end


for address, name in component.list() do
	menuList[menuLen] = name
	if (string.len(menuList[menuLen]) > menuWid) then
		menuWid = string.len(menuList[menuLen])
	end

	for k, v in pairs(component.proxy(address)) do
		compList[compLen] = name.."."..k
		compLen = compLen + 1
	end
	menuLen = menuLen + 1
end

for len = 1, compLen - 1 do
	sPos = string.find(compList[len], ".", 1, true)
	if (string.sub(compList[len], 1, sPos - 1) == "filesystem") then
		fileFirst = string.sub(compList[len], sPos + 1, string.len(compList[len]))
	end
end


menuList[menuLen] = "Exit"

for a = 1, menuLen - 1 do
	for b = 1, menuLen - 1 do
		if menuList[b] > menuList[a] then
			local tmp = menuList[a]
			menuList[a] = menuList[b]
			menuList[b] = tmp
		end
	end
end



col = (w - menuWid - 4) / 2 


local function drawBox(col, row, wid, hgt, f, b, opt)
	local ul = {0x250C, 0x2554}
	local ur = {0x2510, 0x2557}
	local ll = {0x2514, 0x255A}
	local lr = {0x2518, 0x255D}
	local sl = {0x2502, 0x2551}
	local al = {0x2500, 0x2550}
	gpu.setForeground(f)
	gpu.setBackground(b)
	term.setCursor(col, row)
	print(unicode.char(ul[opt])..string.rep(unicode.char(al[opt]), wid - 2)..unicode.char(ur[opt]))
	for a = 1, hgt - 2 do
		term.setCursor(col, row + a)
		print(unicode.char(sl[opt])..string.rep(unicode.char(0x0020), wid - 2)..unicode.char(sl[opt]))
	end
	term.setCursor(col, row + hgt - 2)
	print(unicode.char(ll[opt])..string.rep(unicode.char(al[opt]), wid - 2)..unicode.char(lr[opt]))
	term.setCursor(col, row)
end
	
	
local function hiLiteXY(col, row, menuSel)
	term.setCursorBlink(false)
	gpu.setForeground(theme.promptHighlight)
	gpu.setBackground(theme.prompt)
	component.gpu.set(col, row, menuSel)
end

local function writeXY(col, row, menuSel)
	term.setCursorBlink(false)
	gpu.setForeground(theme.textColor)
	gpu.setBackground(theme.background)
	component.gpu.set(col, row, menuSel)
end	

local function centerText(row, msg)
	local w, h = gpu.getResolution()
	local len = string.len(msg)
	writeXY((w - len)/2, row, msg)
end
	
local function printCompXY(menuSel)
	local tmpList = {}
	local tLen = 1
	local w, h = gpu.getResolution()
	local sPos = 0
	
	for len = 1, compLen - 1 do
		sPos = string.find(compList[len], ".", 1, true)
		if (string.sub(compList[len], 1, sPos - 1) == menuSel) then
			tmpList[tLen] = string.sub(compList[len], sPos + 1, string.len(compList[len]))
			tLen = tLen + 1
		end
	end
	
	local oSet = (h - #tmpList) / 2
	
	gpu.setForeground(theme.textColor)
	gpu.setBackground(theme.background)
	term.clear()
	term.setCursor(25,1)
	centerText(1, "List for "..menuSel)
	for b = 1, tLen - 1 do
		local tmpString = "filesystem."..fileFirst
		if tmpList[b] == fileFirst then
			if fileCount < 0 then
				centerText(b + 3, fileFirst)
			end
			fileCount = fileCount + 1
		end
		if fileCount < 0 then
			centerText(b + 3, tmpList[b])
		end
	end
	term.setCursor((w - 24)/2, h - 1)
	centerText(h - 2, "Press ENTER to continue")
	term.setCursor(55, h - 2)
	local key = term.read()
	fileCount = -1
	gpu.setForeground(theme.textColor)
	gpu.setBackground(theme.background)
	term.clear()
end

local defaultTheme = {				-- Water Theme
  textColor = 0xFFFFFF,
  background = 0x0000FF,
  backgroundHighlight = 0xFFFFFF,
  prompt = 0x000000,
  promptHighlight = 0xFFFFFF,
  }

local normalTheme = {				-- Water Theme
  textColor = 0xFFFFFF,
  background = 0x000000,
  prompt = 0xFFFFFF,
  promptHighlight = 0x000000,
  }

	
local function up()
	writeXY(col, currRow + offset, string.char(32)..menuList[currRow]..string.rep(string.char(32), menuWid - string.len(menuList[currRow]) + 1 ))
  if currRow > 1 then
    currRow = currRow - 1
	else
		currRow = #menuList
	end
	hiLiteXY(col, currRow + offset, string.char(32)..menuList[currRow]..string.rep(string.char(32), menuWid - string.len(menuList[currRow]) + 1 ))
end

local function down()
	writeXY(col, currRow + offset, string.char(32)..menuList[currRow]..string.rep(string.char(32), menuWid - string.len(menuList[currRow]) + 1 ))
  if currRow < #menuList then
    currRow = currRow + 1
	else 
		currRow = 1
	end
	hiLiteXY(col, currRow + offset, string.char(32)..menuList[currRow]..string.rep(string.char(32), menuWid - string.len(menuList[currRow]) + 1 ))
end

offset = (h - #menuList) / 2
local function printBuf()
	if (isAdvanced()) then
		drawBox(col - 2, offset - 1, menuWid + 6, #menuList + 5, theme.textColor, theme.background, 2)
	end
	for a = 1, #menuList do
		writeXY(col, offset + a, string.char(32)..menuList[a]..string.rep(string.char(32), menuWid - string.len(menuList[a]) + 1 ))
	end
end

local function enter()
  term.setCursorBlink(false)
  local w, h = gpu.getResolution()
	if currRow == #menuList then
	  running = false
	else
		term.clear()
		printCompXY(menuList[currRow])
		printBuf()
	end
end

local controlKeyCombos = {[keyboard.keys.s]=true,[keyboard.keys.w]=true,
                          [keyboard.keys.c]=true,[keyboard.keys.x]=true}

local function onKeyDown(char, code)
  if code == keyboard.keys.up then
    up()
  elseif code == keyboard.keys.down then
    down()
  elseif code == keyboard.keys.enter then
    enter()
  end
end

if isAdvanced() then
	theme = defaultTheme
	gpu.setForeground(theme.textColor)
	gpu.setBackground(theme.background)
else
	term.setCursor(1,1)
	print("Regretfully you need at least a tier 2 screen to use the Component Viewer")
	running = false
end

term.clear()
local w, h = gpu.getResolution()

if (isAdvanced()) then
	drawBox(2, 3, w - 2, h - 3, theme.textColor, theme.background, 2)
	printBuf()
end


while running do
	hiLiteXY(col, currRow + offset, string.char(32)..menuList[currRow]..string.rep(string.char(32), menuWid - string.len(menuList[currRow]) + 1 ))
  local event, address, arg1, arg2, arg3 = event.pull()
  if type(address) == "string" and component.isPrimary(address) then
    local blink = true
    if event == "key_down" then
      onKeyDown(arg1, arg2)
    end
  end
end


gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x000000)
term.clear()
term.setCursorBlink(false)


