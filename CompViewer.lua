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

local function spChar(charter, cnt)
	return string.rep(unicode.char(charter), cnt)
end

local OC_1 = " "..spChar(0x2584,3).."  "..spChar(0x2584,4).."  "..spChar(0x2584,5).." "..spChar(0x2584,1).."   "..spChar(0x2584,1).."  "..spChar(0x2584,4).."  "..spChar(0x2584,3).."  "..spChar(0x2584,1).."   "..spChar(0x2584,1).." "..spChar(0x2584,4).."  "..spChar(0x2584,1).."   "..spChar(0x2584,1).." "..spChar(0x2584,5).." "..spChar(0x2584,5).." "..spChar(0x2584,4).."   "..spChar(0x2584,4)
local OC_2 = spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).."     "..spChar(0x2588,1)..spChar(0x2584,1).."  "..spChar(0x2588,1).." "..spChar(0x2588,1).."     "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1)..spChar(0x2580,1)..spChar(0x2584,1)..spChar(0x2580,1)..spChar(0x2588,1).." "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).."   "..spChar(0x2588,1).."   "..spChar(0x2588,1).."   "..spChar(0x2588,1).."     "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1)
local OC_3 = spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1)..spChar(0x2580,3).."  "..spChar(0x2588,1)..spChar(0x2580,2).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).." "..spChar(0x2588,1).." "..spChar(0x2588,1).."     "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1)..spChar(0x2580,3).."  "..spChar(0x2588,1).."   "..spChar(0x2588,1).."   "..spChar(0x2588,1).."   "..spChar(0x2588,1)..spChar(0x2580,2).."   "..spChar(0x2588,1)..spChar(0x2580,1)..spChar(0x2588,1)..spChar(0x2580,1).."   "..spChar(0x2580,2)..spChar(0x2584,1)
local OC_4 = spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).."     "..spChar(0x2588,1).."     "..spChar(0x2588,1).."  "..spChar(0x2588,2).." "..spChar(0x2588,1).."     "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).."     "..spChar(0x2588,1).."   "..spChar(0x2588,1).."   "..spChar(0x2588,1).."   "..spChar(0x2588,1).."     "..spChar(0x2588,1).."  "..spChar(0x2588,1).."      "..spChar(0x2588,1)
local OC_5 = " "..spChar(0x2580,3).."  "..spChar(0x2580,1).."     "..spChar(0x2580,5).." "..spChar(0x2580,1).."   "..spChar(0x2580,1).."  "..spChar(0x2580,4).."  "..spChar(0x2580,3).."  "..spChar(0x2580,1).."   "..spChar(0x2580,1).." "..spChar(0x2580,1).."      "..spChar(0x2580,3).."    "..spChar(0x2580,1).."   "..spChar(0x2580,5).." "..spChar(0x2580,1).."   "..spChar(0x2580,1).." "..spChar(0x2580,4)

local menuHint = "List function calls for the "
local help = "[UP/DN] - Arrow through the menu     [Enter/Left/Right] - Select current menu item     [R] - Refresh List     [Q/X] - Exit"

local menuList = {}
local menuLen = 1
local menuWid = 0

local compList = {}
local compList1 = {}
local compLen = 1

local col = 1
local currRow = 1

local offset = 0
local running = true


local function getMenuList()
	local w, h = gpu.getResolution()
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
	table.sort(menuList)
	menuList[menuLen] = "Exit"
	col = (w - menuWid - 4) / 2 
	offset = (h - #menuList) / 2
	return col	
end


local w, h = gpu.getResolution()
local tmpW, tmpH = gpu.getResolution()

if (w < 160 and h < 50) then
	tmpW, tmpH = gpu.getResolution()
	gpu.setResolution(160,50)
end


local function table_count(tt, item)
	local count
	count = 0
	for ii,xx in pairs(tt) do
		if item == xx then count = count + 1 end
	end
	return count
end
	
local function table_unique(tt)
	local newtable = {}
	for ii,xx in ipairs(tt) do
		if table_count(newtable, xx) == 0 then
			newtable[#newtable+1] = xx
		end
	end
	return newtable
end

local function getCh()
	return (select(3, event.pull("key_down")))
end

local function getKey()
	return (select(4, event.pull("key_down")))
end

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

local function saveWin(x, y, wid, hgt)
	local winCol = {}
	local winRow = {}
	for a = 1, hgt do
		for b = 1, wid do
			winCol[b] = gpu.get((x + b) - 1, (y + a) - 1)
		end
		winRow[a] = table.concat(winCol)
	end
	return winRow
end

local function restoreWin(x, y, wind)
	for a = 1, #wind do
		gpu.set(x, (y + a) - 1, wind[a])
	end
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

local function printDocXY(col, row, menuSel)
	setCursor(col, row)
	print(menuSel)
end


local function centerText(row, msg)
	local w, h = getSize()
	local len = string.len(msg)
	gpu.set((w - len)/2, row, msg)
end

local function centerIntroText(row, msg)
	local msg1 = "*   * *   * *     **  * *     *   * * * * *   * *   *   *   *     *   * *    "
	local w, h = getSize()
	local len = string.len(msg1)
	gpu.set((w - len)/2, row, msg)
end




local function intro()
	local w, h = gpu.getResolution()
	local msg1 = "*   * *   * *     **  * *     *   * * * * *   * *   *   *   *     *   * *    "
	local len = string.len(msg1)
	local helpLen = string.len(help)
	
	drawBox(2, 3, w - 2, h - 3, theme.textColor, theme.background, 2)
	drawBox((w - len)/2 - 2, 5, len + 4, 10, theme.introText, theme.introBackground, 1)
	
	centerIntroText(6, OC_1)
	centerIntroText(7, OC_2)
	centerIntroText(8, OC_3)
	centerIntroText(9, OC_4)
	centerIntroText(10, OC_5)
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
	centerText(h - 3, "[M] Manual   [Any Other Key] continue")
	setCursor(w/2 + (string.len("[M] Manual   [Any Other Key] continue")/2) + 2, h - 3)
	local key = getCh()
	if string.upper(string.char(key)) == "M" then
		drawBox(1, 1, w, h - 1, theme.textColor, theme.background, 2)
		centerText(4, "Description of the functions for "..menuSel)
		if string.lower(menuSel) == "computer" then
			printXY(10, 7, "address()"..spaces(5).."Gets the address of the card")
			printXY(10, 9, "start(): boolean"..spaces(5).."Tries to start the computer. Returns true on success, false otherwise. Note that this will also")
			printXY(31, 10, "return false if the computer was already running. If the computer is currently shutting down, this")
			printXY(31, 11, "will cause the computer to reboot instead.")
			printXY(10, 13, "stop(): boolean"..spaces(5).."Tries to stop the computer. Returns true on success, false otherwise. Also returns false if the")
			printXY(30, 14, "computer is already stopped.")
			printXY(10, 16, "isRunning(): boolean"..spaces(5).."Returns whether the computer is currently running.")
			printXY(10, 18, "type()")
			centerText(h - 3, "[Any Key] continue")
			setCursor(w/2 + (string.len("[Any Key] continue")/2) + 2, h - 3)
		elseif string.lower(menuSel) == "gpu" then
			printXY(10, 7, "address()"..spaces(5).."Gets the address of the card")
			printXY(10, 9, "bind(address: string): boolean[, string]"..spaces(5).."Tries to bind the GPU to a screen with the specified address. Returns true on") 
			printXY(20, 10, "success, false and an error message on failure. A GPU can only be bound to one screen at a time. All operations")
			printXY(20, 11, "on it will work on the bound screen. If you wish to control multiple screens at once, you'll need to put more")
			printXY(20, 12, "than one graphics card into your computer.")
			printXY(10, 14, "copy(x: number, y: number, width: number, height: number, tx: number, ty: number): boolean")
			printXY(20, 15, "Copies a portion of the screens buffer to another location. The source rectangle is specified")
			printXY(20, 16, "by the x, y, width and height parameters. The target rectangle is defined by x + tx, y + ty,")
			printXY(20, 17, "width and height. Returns true on success, false otherwise.")
			printXY(10, 19, "fill(x: number, y: number, width: number, height: number, char: string): boolean")
			printXY(20, 20, "Fills a rectangle in the screen buffer with the specified character. The target rectangle is specified") 
			printXY(20, 21, "by the x and y coordinates and the rectangle's width and height. The fill character char must be a string")
			printXY(20, 22, "of length one, i.e. a single character. Returns true on success, false otherwise.")
			printXY(20, 23, "Note that filling screens with spaces () is usually less expensive, i.e. consumes less energy,")
			printXY(20, 24, "because it is considered a 'clear' operation (see config).")
			printXY(10, 26, "get(x: number, y: number): string"..spaces(5).."Gets the character currently being displayed at the specified coordinates.")
			printXY(10, 28, "getBackground(): number"..spaces(5).."Gets the current background color. This background color is applied to all 'pixels'")
			printXY(20, 29, "that get changed by other operations.")
			printXY(20, 30, "Note that the returned number is an RGB value in hexadecimal format, i.e. 0xRRGGBB. This is to allow")
			printXY(20, 31, "uniform color operations regardless of color depth supported by the screen and GPU.")
			printXY(10, 33, "getDepth(): number"..spaces(5).."The currently set color depth of the GPU/screen, in bits. Can be 1, 4 or 8.")
			printXY(10, 35, "getForeground(): number"..spaces(5).."Like getBackground, but for the foreground color.")
			printXY(10, 37, "getResolution(): number, number"..spaces(5).."Gets the currently set resolution.")
			printXY(10, 39, "getSize(): number, number"..spaces(5).."Gets the size in blocks of the screen the graphics card is bound to. For simple")
			printXY(20, 40, "screens and robots this will be one by one.")
			centerText(h - 3, "[Any Key] continue")
			setCursor(w/2 + (string.len("[Any Key] continue")/2) + 2, h - 3)
			local key = getCh()
			drawBox(1, 1, w, h - 1, theme.textColor, theme.background, 2)
			centerText(4, "Description of the functions for "..menuSel)
			printXY(10, 7, "maxDepth(): number"..spaces(5).."Gets the maximum supported color depth supported by the GPU and the screen it is bound")
			printXY(20, 8, "to (minimum of the two).")
			printXY(10, 10, "maxResolution(): number, number"..spaces(5).."Gets the maximum resolution supported by the GPU and the screen it is bound")
			printXY(20, 11, "to (minimum of the two).")
			printXY(10, 13, "set(x: number, y: number, value: string): boolean")
			printXY(20, 14, "Writes a string to the screen, starting at the specified coordinates. The string will be copied to the screen's")
			printXY(20, 15, "buffer directly, in a single row. This means even if the specified string contains line breaks, these will just")
			printXY(20, 16, "be printed as special characters, the string will not be displayed over multiple lines. Returns true if the")
			printXY(20, 17, "string was set to the buffer, false otherwise.")
			printXY(10, 19, "setBackground(color: number): number"..spaces(5).."Sets the background color to apply to 'pixels' modified by other operations")
			printXY(20, 20, "from now on. The returned value is the new background color, which may differ from the specified value based on the")
			printXY(20, 21, "supported color depth.")
			printXY(20, 22, "Note that the color is expected to be specified in hexadecimal RGB format, i.e. 0xRRGGBB. This is to allow uniform")
			printXY(20, 23, "color operations regardless of the color depth supported by the screen and GPU.")
			printXY(10, 25, "setDepth(bit: number): boolean"..spaces(5).."Sets the color depth to use. Can be up to the maximum supported color depth. If a")
			printXY(20, 26, "larger or invalid value is provided it will throw an error. Returns true if the depth was set, false otherwise.")
			printXY(10, 28, "setForeground(color: number): number"..spaces(5).."Like setBackground, but for the foreground color.")
			printXY(20, 30, "setResolution(width: number, height: number): boolean"..spaces(5).."Sets the specified resolution. Can be up to the maximum")
			printXY(20, 31, "supported resolution. If a larger or invalid resolution is provided it will throw an error. Returns true if the")
			printXY(20, 32, "resolution was set, false otherwise.")
			printXY(20, 33, "type()")
			centerText(h - 3, "[Any Key] continue")
			setCursor(w/2 + (string.len("[Any Key] continue")/2) + 2, h - 3)
		elseif string.lower(menuSel) == "modem" then
			printXY(10, 7, "address()"..spaces(5).."Gets the address of the card")
			printXY(10, 9, "isWireless(): boolean"..spaces(5).."Returns whether this modem is capable of sending wireless messages.")
			printXY(10, 11, "isOpen(port: number): boolean"..spaces(5).."Returns whether the specified 'port' is currently being listened on.")
			printXY(20, 12, "Messages only trigger signals when they arrive on a port that is open.")
			printXY(10, 14, "open(port: number): boolean"..spaces(5).."Opens the specified port number for listening. Returns true if the port")
			printXY(20, 15, "was opened, false if it was already open.")
			printXY(10, 17, "send(address: string, port: number[, ...]): boolean"..spaces(5).."Sends a network message to the specified address.")
			printXY(20, 18, "Returns true if the message was sent. This does not mean the message was received, only that it was sent.")
			printXY(20, 19, "No port-sniffing for you.")
			printXY(20, 20, "Any additional arguments are passed along as data. These arguments must be basic types: nil, boolean, number")
			printXY(20, 21, "and string values are supported, tables and functions are not. See the text API for serialization of tables.")
			printXY(10, 23, "broadcast(port: number, ...): boolean"..spaces(5).."Sends a broadcast message. This message is delivered to all reachable")
			printXY(20, 24, "network cards. Returns true if the message was sent. Note that broadcast messages are not delivered to the modem")
			printXY(20, 25, "that sent the message.")
			printXY(20, 26, "All additional arguments are passed along as data. See send.")
			printXY(10, 28, "getStrength(): number"..spaces(5).."The current signal strength to apply when sending messages. Wireless network cards only.")
			printXY(10, 30, "setStrength(value: number): number"..spaces(5).."Sets the signal strength. If this is set to a value larger than zero, sending")
			printXY(20, 31, "a message will also generate a wireless message. The higher the signal strength the more energy is required to send")
			printXY(20, 32, "messages, though. Wireless network cards only.")
			centerText(h - 3, "[Any Key] continue")
			setCursor(w/2 + (string.len("[Any Key] continue")/2) + 2, h - 3)
		elseif string.lower(menuSel) == "redstone" then
			printXY(10, 7, "address()"..spaces(5).."Gets the address of the card")
			printXY(10, 9, "type()")
			printXY(10, 11, "getInput(side: number): number"..spaces(5).."Gets the current ingoing redstone signal from the specified side. Note")
			printXY(20, 12, "that the side is relative to the computer's orientation, i.e. sides.south is in front of the computer, not south in")
			printXY(20, 13, "the world. Likewise, sides.left is to the left of the computer, so when you look at the computer's front, it'll be")
			printXY(20, 14, "to your right.")
			printXY(20, 15, "If you use mods such as RedLogic the input may exceed the vanilla values of [0, 15].")
			printXY(10, 17, "getOutput(side: number): number"..spaces(5).."Gets the currently set output on the specified side.")
			printXY(10, 19, "setOutput(side: number, value: number): number"..spaces(5).."Sets the strength of the redstone signal to emit on the")
			printXY(20, 20, "specified side. Returns the new value.")
			printXY(20, 21, "This can be an arbitrarily large number for mods that support this. For vanilla interaction it is clamped to")
			printXY(20, 22, "the interval [0, 15].")
			printXY(10, 25, "getBundledInput(side: number, color: number): number"..spaces(5).."Like getInput, but for bundled input, reading")
			printXY(20, 26, "the value for the channel with the specified color.")
			printXY(10, 28, "getBundledOutput(side: number, color: number): number"..spaces(5).."Like getOutput, but for bundled output, getting the value")
			printXY(20, 29, "for the channel with the specified color.")
			printXY(10, 31, "setBundledOutput(side: number, color: number, value: number): number"..spaces(5).."Like setOutput, but for bundled output,")
			printXY(20, 32, "setting the value for the channel with the specified color.")
			centerText(h - 3, "[Any Key] continue")
			setCursor(w/2 + (string.len("[Any Key] continue")/2) + 2, h - 3)
		else
			printXY(15, 7, "Currently no documentation for this")
		end
		local key = getCh()
	end
	term.clear()
end


local defaultTheme = {				-- Water Theme
  textColor = 0xFFFFFF,
  background = 0x0000FF,
	introText = 0xFF0000,
	introBackground = 0x000000,
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


local function printBuf()
	if isAdvanced() then
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

if isAdvanced() then
	theme = defaultTheme
	setColors(theme.textColor, theme.background)
else
	printXY(1, 1, "Regretfully you need at least a tier 2 screen to use the Component Viewer")
	running = false
end

term.clear()
local w, h = gpu.getResolution()

if (isAdvanced()) then
	getMenuList()
	intro()
	printBuf()
end


while running do
	setColors(theme.menuHintText, theme.menuHint)
	printXY((w - (menuWid + string.len(menuHint)))/2, h - 9, string.rep(string.char(32), menuWid + string.len(menuHint)))
	printXY((w - (menuWid + string.len(menuHint)))/2, h - 9, menuHint..menuList[currRow])
	setColors(theme.promptHighlight, theme.prompt)
	printXY(col, currRow + offset, string.char(32)..menuList[currRow]..string.rep(string.char(32), menuWid - string.len(menuList[currRow]) + 1 ))
  key = getKey()
  if key == keyboard.keys.up then
    up()
  elseif key == keyboard.keys.down then
    down()
  elseif key == keyboard.keys.enter or key == keyboard.keys.left or key == keyboard.keys.right then
    enter()
  elseif key == keyboard.keys.r then
		menuLen = 1
		menuWid = 0
		menuList = {}
		getMenuList()
		intro()
		printBuf()
  elseif key == keyboard.keys.q or key == keyboard.keys.x then
    running = false
  end
end

gpu.setResolution(tmpW, tmpH)
setColors(0xFFFFFF, 0x000000)
term.clear()


