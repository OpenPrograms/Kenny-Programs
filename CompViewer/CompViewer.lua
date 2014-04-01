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
local gml=require("gml")

local function spaces(cnt)
	return string.rep(string.char(32), cnt)
end

local function spChar(letter, cnt)
	return string.rep(unicode.char(letter), cnt)
end

local OC_1 = "   "..spChar(0x2584,3).."  "..spChar(0x2584,4).."  "..spChar(0x2584,5).." "..spChar(0x2584,1).."   "..spChar(0x2584,1).."  "..spChar(0x2584,4).."  "..spChar(0x2584,3).."  "..spChar(0x2584,1).."   "..spChar(0x2584,1).." "..spChar(0x2584,4).."  "..spChar(0x2584,1).."   "..spChar(0x2584,1).." "..spChar(0x2584,5).." "..spChar(0x2584,5).." "..spChar(0x2584,4).."   "..spChar(0x2584,4).."  "
local OC_2 = "  "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).."     "..spChar(0x2588,1)..spChar(0x2584,1).."  "..spChar(0x2588,1).." "..spChar(0x2588,1).."     "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1)..spChar(0x2580,1)..spChar(0x2584,1)..spChar(0x2580,1)..spChar(0x2588,1).." "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).."   "..spChar(0x2588,1).."   "..spChar(0x2588,1).."   "..spChar(0x2588,1).."     "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).."  "
local OC_3 = "  "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1)..spChar(0x2580,3).."  "..spChar(0x2588,1)..spChar(0x2580,2).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).." "..spChar(0x2588,1).." "..spChar(0x2588,1).."     "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1)..spChar(0x2580,3).."  "..spChar(0x2588,1).."   "..spChar(0x2588,1).."   "..spChar(0x2588,1).."   "..spChar(0x2588,1)..spChar(0x2580,2).."   "..spChar(0x2588,1)..spChar(0x2580,1)..spChar(0x2588,1)..spChar(0x2580,1).."   "..spChar(0x2580,2)..spChar(0x2584,1).."  "
local OC_4 = "  "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).."     "..spChar(0x2588,1).."     "..spChar(0x2588,1).."  "..spChar(0x2588,2).." "..spChar(0x2588,1).."     "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).."   "..spChar(0x2588,1).." "..spChar(0x2588,1).."     "..spChar(0x2588,1).."   "..spChar(0x2588,1).."   "..spChar(0x2588,1).."   "..spChar(0x2588,1).."     "..spChar(0x2588,1).."  "..spChar(0x2588,1).."      "..spChar(0x2588,1).."  "
local OC_5 = "   "..spChar(0x2580,3).."  "..spChar(0x2580,1).."     "..spChar(0x2580,5).." "..spChar(0x2580,1).."   "..spChar(0x2580,1).."  "..spChar(0x2580,4).."  "..spChar(0x2580,3).."  "..spChar(0x2580,1).."   "..spChar(0x2580,1).." "..spChar(0x2580,1).."      "..spChar(0x2580,3).."    "..spChar(0x2580,1).."   "..spChar(0x2580,5).." "..spChar(0x2580,1).."   "..spChar(0x2580,1).." "..spChar(0x2580,4).."  "

local gpu = component.gpu
local Tier1 = 1
local Tier2 = 4
local Tier3 = 8

local menuList = {}
local menuLen = 1
local menuWid = 0

local compList = {}
local tmpList = {}
local compLen = 1
local compListWid = 0
local col = 1
local currRow = 1
local sentStr = {}

local offset = 0
local running = true
local w, h = gpu.getResolution()
local tmpW, tmpH = gpu.getResolution()

local fname = "CompInfo.txt"
local filename = shell.resolve(fname)

local gui=gml.create("center",15,80,30)

gui:addLabel(2,1,14,"Component")
local contentsLabel=gui:addLabel(30,1,31,"contents of")

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

local function isAdvanced()
	return gpu.getDepth()
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

local function drawBox(col, row, wid, hgt, fore, back, opt)
	local ul = {0x250C, 0x2554}
	local ur = {0x2510, 0x2557}
	local ll = {0x2514, 0x255A}
	local lr = {0x2518, 0x255D}
	local sl = {0x2502, 0x2551}
	local al = {0x2500, 0x2550}
	setColors(fore, back)
	gpu.set(col, row, unicode.char(ul[opt])..spChar(al[opt], wid - 2)..unicode.char(ur[opt]))
	for a = 1, hgt - 2 do
		gpu.set(col, row + a, unicode.char(sl[opt])..spaces(wid - 2)..unicode.char(sl[opt]))
	end
	gpu.set(col, row + hgt - 2, unicode.char(ll[opt])..spChar(al[opt], wid - 2)..unicode.char(lr[opt]))
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
	local msg1 = "   *   * *   * *     **  * *     *   * * * * *   * *   *   *   *     *   * *     "
	local w, h = getSize()
	local len = string.len(msg1)
	gpu.set((w - len)/2, row, msg)
end


local defaultTheme = {				-- Water Theme
  textColor = 0xFFFFFF,
  background = 0x000099,
	introText = 0xFF0000,
	introBackground = 0x000000,
	menuHintText = 0xFFFF00,
	menuHint = 0x000000,
  prompt = 0xBBBB00,
  promptHighlight = 0x000000,
	fancyDots = 0xAAFFCC,
	fancyBackground = 0x113322
  }

local normalTheme = {				-- Water Theme
  textColor = 0xFFFFFF,
  background = 0x000000,
  prompt = 0x000000,
  promptHighlight = 0xFFFFFF,
  }

term.clear()
local w, h = gpu.getResolution()

local function intro()
	local w, h = gpu.getResolution()
	local msg1 = "   *   * *   * *     **  * *     *   * * * * *   * *   *   *   *     *   * *     "
	local len = string.len(msg1) + 1
	
	drawBox(1, 3, w, h - 3, theme.textColor, theme.background, 2)
	drawBox((w - len)/2 - 2, 5, len + 4, 10, theme.introText, theme.introBackground, 1)
	
	centerIntroText(6, OC_1)
	centerIntroText(7, OC_2)
	centerIntroText(8, OC_3)
	centerIntroText(9, OC_4)
	centerIntroText(10, OC_5)
	centerText(12, "Component Viewer")
end

if (isAdvanced() == Tier3) then
	theme = defaultTheme
	intro()
else
	theme = normalTheme
end

local function strripos(s, delim)
	return s:match('^.*()'..delim)
end

local function getMenuList()
	local tmpName = ""
	for address, name in component.list() do
		table.insert(menuList,name)
		for k, v in pairs(component.proxy(address)) do
			tmpName = name.."."..k
			table.insert(compList,tmpName)
		end
	end
	table.sort(menuList)
end

function loadInfoData(select)
	local lineLen, lineHeight = 0, 0
	local lineCnt = 0
	local optName = "["..string.upper(select).."]"
	local optNameEnd = "["..string.upper(select).."_END]"
	local optNameStart, optNameLast = 0,0
	local w, h = gpu.getResolution()
	local tmpLine = {}
	local tmpStr = ""
	sentStr = {}
	lineLen = w - 8

	do
		local f = io.open(filename)
			if f then
				for line in f:lines() do
					lineCnt = lineCnt + 1
					if text.trim(line) == optName then
						optNameStart = lineCnt + 1
          end
					if text.trim(line) == optNameEnd then
						optNameLast = lineCnt - 1
					end
					table.insert(tmpLine, line)
				end
			f:close()
		end
	end	
	if lineCnt > 2 then
    if optNameStart < 2 then
      table.insert(sentStr, "No information available for "..select)
    end
    local tStr = ""
		for k, v in pairs(tmpLine) do
			if k >= optNameStart and k <= optNameLast then
--					v = text.trim(v)
				if string.len(v) > lineLen then
					while string.len(v) > lineLen do
						tmpStr = string.sub(v, 1, lineLen)
            if string.len(tmpStr) < lineLen then
              tStr = string.sub(tmpStr, 1, string.len(tmpStr) - 1)..spaces(w - string.len(tmpStr))
            else
              delimPos = strripos(tmpStr, " ")
              tStr = string.sub(tmpStr, 1, delimPos - 1)..spaces((w - delimPos) + 12)
            end
						table.insert(sentStr, tStr)
						v = string.sub(v, delimPos + 1)
					end
					if string.len(v) < lineLen then
						table.insert(sentStr, v)
					end
				else
					table.insert(sentStr, v)
				end
			end
		end
	end
end

getMenuList()

local menuDirList=gui:addListBox(2,2,24,25, menuList)
local functionsList=gui:addListBox(30,2,50,25, tmpList)

local function updateFunctionsList(comp)
	local tLen = 1
	local sPos = 1
	local sTmp = ""
	local tmpList = {}
	
  contentsLabel.text="Functions for "..comp
  contentsLabel:draw()

	for len = 1, #compList do
		sPos = string.find(compList[len], ".", 1, true)
		if (string.sub(compList[len], 1, sPos - 1) == comp) then
			sTmp = string.sub(compList[len], sPos + 1, string.len(compList[len]))
			table.insert(tmpList, sTmp)
		end
	end
	table.sort(tmpList)
	tmpList = table_unique(tmpList)
	functionsList:updateList(tmpList)
end

function newListBox()
	local infoGUI=gml.create("center","center",160,50)
	select = menuDirList:getSelected()
	loadInfoData(select)
	term.clear()
	local infoLabel=infoGUI:addLabel(50,1,50,"Functions explanation for "..select)
	local infoList=infoGUI:addListBox(1,-5,160,42, sentStr)
	infoGUI:addButton(-70,-1,12,2,"Close",infoGUI.close)
	infoGUI:run()
	term.clear()
	intro()
	gui:draw()
end

gui:addButton(-11,-1,8,1,"Info", newListBox)
gui:addButton(-2,-1,8,1,"Close",gui.close)

local function onMenuSelect(lb,prevIndex,selIndex)
  updateFunctionsList(menuDirList:getSelected())
end

menuDirList.onChange=onMenuSelect

menuDirList.onDoubleClick=function()
  updateFunctionsList(menuDirList:getSelected())
end

updateFunctionsList(menuDirList:getSelected())

gui:run()
term.setCursor(1,1)
gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x000000)

term.clear()
