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

local function spaces(cnt)
	return string.rep(string.char(32), cnt)
end

local OC_1 = " ***  ****  ***** *   *  ****  ***  *   * ****  *   * ***** ***** ****   ****"
local OC_2 = "*   * *   * *     **  * *     *   * * * * *   * *   *   *   *     *   * *    "
local OC_3 = "*   * ****  ***   * * * *     *   * *   * ****  *   *   *   ***   ****   *** "
local OC_4 = "*   * *     *     *  ** *     *   * *   * *     *   *   *   *     *  *      *"
local OC_5 = " ***  *     ***** *   *  ****  ***  *   * *      ***    *   ***** *   * **** "

local menuHint = "List function calls for the "
local help = "[UP/DN] - Arrow through the menu          [Enter/Left/Right] - Select current menu item"

local menuList = {}
local menuLen = 1
local menuWid = 0

local compList = {}
local compList1 = {}
local compLen = 1

local col = 1
local currRow = 1

local w, h = gpu.getResolution()
local offset = 0
local running = true

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

function table_count(tt, item)
  local count
  count = 0
  for ii,xx in pairs(tt) do
    if item == xx then count = count + 1 end
  end
  return count
end

function table_unique(tt)
	local newtable = {}
	for ii,xx in ipairs(tt) do
		if table_count(newtable, xx) == 0 then
			newtable[#newtable+1] = xx
		end
	end
	return newtable
end

table.sort(menuList)
menuList[menuLen] = "Exit"

col = (w - menuWid - 4) / 2 

local function isAdvanced()
	return (gpu.getDepth() > 1)
end

local function setColors(fore, back)
	gpu.setForeground(fore)
	gpu.setBackground(back)
end

local function setCursor(col, row)
	term.setCursor(col, row)
end

local function getSize()
	return gpu.getResolution()
end

local function extraChars(letter, cnt)
	return string.rep(unicode.char(letter), cnt)
end

local function drawBox(col, row, wid, hgt, fore, back, opt)
	local ul = {0x250C, 0x2554}
	local ur = {0x2510, 0x2557}
	local ll = {0x2514, 0x255A}
	local lr = {0x2518, 0x255D}
	local sl = {0x2502, 0x2551}
	local al = {0x2500, 0x2550}
	setColors(fore, back)
	gpu.set(col, row, unicode.char(ul[opt])..extraChars(al[opt], wid - 2)..unicode.char(ur[opt]))
	for a = 1, hgt - 2 do
		gpu.set(col, row + a, unicode.char(sl[opt])..spaces(wid - 2)..unicode.char(sl[opt]))
	end
	gpu.set(col, row + hgt - 2, unicode.char(ll[opt])..extraChars(al[opt], wid - 2)..unicode.char(lr[opt]))
	setCursor(col, row)
end
	
local function printXY(col, row, menuSel)
	gpu.set(col, row, menuSel)
end	

local function centerText(row, msg)
	local w, h = getSize()
	local len = string.len(msg)
	gpu.set((w - len)/2, row, msg)
end

local function intro()
	local w, h = getSize()
	local len = string.len(OC_1)
	local helpLen = string.len(help)
	
	drawBox(2, 3, w - 2, h - 3, theme.textColor, theme.background, 2)
	drawBox((w - len)/2 - 2, 5, len + 4, 10, theme.introText, theme.introBackground, 1)
	
	centerText(6, OC_1)
	centerText(7, OC_2)
	centerText(8, OC_3)
	centerText(9, OC_4)
	centerText(10, OC_5)
	centerText(12, "Component Viewer")
	drawBox((w - helpLen)/2 - 2, h - 7, helpLen + 4, 4, theme.introText, theme.introBackground, 1)
	centerText(h - 6, help)
end

local function printCompXY(menuSel)
	local tmpList = {}
	local tLen = 1
	local w, h = getSize()
	local sPos = 0
	local listWid = 0
	
	for len = 1, compLen - 1 do
		sPos = string.find(compList[len], ".", 1, true)
		if (string.sub(compList[len], 1, sPos - 1) == menuSel) then
			tmpList[tLen] = string.sub(compList[len], sPos + 1, string.len(compList[len]))
			if string.len(tmpList[tLen]) > listWid then
				listWid = string.len(tmpList[tLen])
			end
			tLen = tLen + 1
		end
	end

	table.sort(tmpList)
	tmpList = table_unique(tmpList)

	local topBar = "List for "..menuSel
	local tbLen = string.len(topBar)
	local boxWid = 0
	
	if tbLen > listWid then
		boxWid = tbLen
	else
		boxWid = listWid
	end
	
	setColors(theme.textColor, theme.background)
	term.clear()
	drawBox(2, 3, w - 2, h - 3, theme.textColor, theme.background, 2)
	drawBox(((w - tbLen)/2) - 2, ((h - #tmpList)/2) - 5, (boxWid) + 4, #tmpList + 7, theme.textColor, theme.background, 2)
	setColors(theme.introText, theme.introBackground)
	centerText(((h - #tmpList)/2) - 3, topBar)
	for b = 1, #tmpList do
		if (math.fmod(b, 2) == 0) then
			setColors(theme.textColor, theme.background)
			printXY(((w - tbLen)/2), ((h - #tmpList)/2) + b - 2, tmpList[b]..spaces(listWid - string.len(tmpList[b])))
		else
			setColors(theme.promptHighlight, theme.prompt)
			printXY(((w - tbLen)/2), ((h - #tmpList)/2) + b - 2, tmpList[b]..spaces(listWid - string.len(tmpList[b])))
		end
	end
	setColors(theme.textColor, theme.background)
	setCursor((w - 24)/2, h - 3)
	centerText(h - 3, "Press ENTER to continue")
	setCursor(w/2 + (string.len("Press ENTER to continue")/2) + 2, h - 3)
	local key = term.read()
	term.clear()
end

local defaultTheme = {				-- Water Theme
  textColor = 0xFFFFFF,
  background = 0x0000FF,
	introText = 0xFF0000,
	introBackground = 0xC5C1AA,
	menuHintText = 0xFFFF00,
	menuHint = 0x000000,
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
	setColors(theme.textColor, theme.background)
	printXY(col, currRow + offset, string.char(32)..menuList[currRow]..string.rep(string.char(32), menuWid - string.len(menuList[currRow]) + 1 ))
  if currRow > 1 then
    currRow = currRow - 1
	else
		currRow = #menuList
	end
	setColors(theme.menuHintText, theme.menuHint)
	printXY((w - (menuWid + string.len(menuHint)))/2, h - 9, string.rep(string.char(32), menuWid + string.len(menuHint)))
	printXY((w - (menuWid + string.len(menuHint)))/2, h - 9, menuHint..menuList[currRow])
	setColors(theme.promptHighlight, theme.prompt)
	printXY(col, currRow + offset, string.char(32)..menuList[currRow]..string.rep(string.char(32), menuWid - string.len(menuList[currRow]) + 1 ))
end

local function down()
	setColors(theme.textColor, theme.background)
	printXY(col, currRow + offset, string.char(32)..menuList[currRow]..string.rep(string.char(32), menuWid - string.len(menuList[currRow]) + 1 ))
  if currRow < #menuList then
    currRow = currRow + 1
	else 
		currRow = 1
	end
	setColors(theme.menuHintText, theme.menuHint)
	printXY((w - (menuWid + string.len(menuHint)))/2, h - 9, string.rep(string.char(32), menuWid + string.len(menuHint)))
	printXY((w - (menuWid + string.len(menuHint)))/2, h - 9, menuHint..menuList[currRow])
	setColors(theme.promptHighlight, theme.prompt)
	printXY(col, currRow + offset, string.char(32)..menuList[currRow]..string.rep(string.char(32), menuWid - string.len(menuList[currRow]) + 1 ))
end

offset = (h - #menuList) / 2
local function printBuf()
	if (isAdvanced()) then
		drawBox(col - 2, offset - 1, menuWid + 6, #menuList + 5, theme.textColor, theme.background, 2)
	end
	for a = 1, #menuList do
		setColors(theme.textColor, theme.background)
		printXY(col, offset + a, string.char(32)..menuList[a]..spaces(menuWid - string.len(menuList[a]) + 1 ))
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
		intro()
		printBuf()
	end
end

local controlKeyCombos = {[keyboard.keys.s]=true, [keyboard.keys.w]=true, [keyboard.keys.c]=true, [keyboard.keys.x]=true}

local function onKeyDown(char, code)
  if code == keyboard.keys.up then
    up()
  elseif code == keyboard.keys.down then
    down()
  elseif code == keyboard.keys.enter or code == keyboard.keys.left or code == keyboard.keys.right then
    enter()
  end
end

if isAdvanced() then
	theme = defaultTheme
	setColors(theme.textColor, theme.background)
else
	printXY(1, 1, "Regretfully you need at least a tier 2 screen to use the Component Viewer")
	running = false
end

term.clear()
local w, h = getSize()

if (isAdvanced()) then
	intro()
	printBuf()
end


while running do
	setColors(theme.menuHintText, theme.menuHint)
	printXY((w - (menuWid + string.len(menuHint)))/2, h - 9, string.rep(string.char(32), menuWid + string.len(menuHint)))
	printXY((w - (menuWid + string.len(menuHint)))/2, h - 9, menuHint..menuList[currRow])
	setColors(theme.promptHighlight, theme.prompt)
	printXY(col, currRow + offset, string.char(32)..menuList[currRow]..string.rep(string.char(32), menuWid - string.len(menuList[currRow]) + 1 ))
  local event, address, arg1, arg2, arg3 = event.pull()
  if type(address) == "string" and component.isPrimary(address) then
    local blink = true
    if event == "key_down" then
      onKeyDown(arg1, arg2)
    end
  end
end

setColors(0xFFFFFF, 0x000000)
term.clear()


