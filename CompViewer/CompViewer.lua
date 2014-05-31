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

-- The following code added by Michiyo, to check if:
-- A.) The computer has HTTP access, and 
-- B.) if the required files exist to run this program.
-- C.) And to download them if it can.
--#~#~#~#~#~#~#~ CHANGE THE FOLLOWING VARIABLE TO FALSE TO DISABLE AUTOUPDATE CHECKING~#~#~#~#~#~#~#
autoUpdate = true

--Thanks Gopher!
function compareVersions(v1,v2)
	local pat="(%d+)"
	local iter1,iter2=v1:gmatch(pat),v2:gmatch(pat)
	while true do
		local n1,n2=iter1(), iter2()
		n1,n2=n1 and tonumber(n1),n2 and tonumber(n2)
		if n1==nil then
			if n2==nil then
				return 0
			else
				return -1
			end
			elseif n2==nil then
				return 1
			end
			if n1~=n2 then
				return n1-n2
			end
		end
	end

	function file_check(file_name)
		local file = fs.open(file_name)
		if file ~= nil then
			return true
		else
			return false
		end
	end
	wget = loadfile("/bin/wget.lua")
	function downloadFile(remotename, filename)
		wget("https://raw.github.com/OpenPrograms/Kenny-Programs/master/CompViewer/" .. remotename, filename)
	end

	function remoteVersion()
		for line in internet.request("https://raw.github.com/OpenPrograms/Kenny-Programs/master/CompViewer/compviewer-version.txt") do 
			if line ~= "not found" then 
				return text.trim(line)
			else 
				return 0 
			end
		end
	end

	function localVersion()
		if not file_check(os.getenv("PWD") .. "compviewer-version.txt") then
			return 0
		else
			local f = io.open(os.getenv("PWD") .. "compviewer-version.txt", "rb")
			local content = f:read("*all")
			f:close()
			return content
		end
	end

	function doUpdate(watdo)
		if (watdo == "update") then
			if autoUpdate == true then
				print("A new version " .. remoteVersion() .. " is available, would you like to download it? Yes/No")
				doTehUpdate = io.read()
				if doTehUpdate == "yes" then
					print("Cleaning up previous install")
					fs.remove(os.getenv("PWD") .. "default.gss")
					fs.remove(os.getenv("PWD") .. "cv.gss")
					fs.remove(os.getenv("PWD") .. "gml.lua")
					fs.remove(os.getenv("PWD") .. "gfxbuffer.lua")
					fs.remove(os.getenv("PWD") .. "colorutils.lua")
					fs.remove(os.getenv("PWD") .. "colorutils.lua")
					fs.remove(os.getenv("PWD") .. "compviewer-version.txt")
					currFile = process.running()
					fs.remove(currFile)
					if not file_check(os.getenv("PWD") .. currFile) then 
						print("Downloading CompViewer.lua")
						downloadFile("CompViewer.lua", currFile)
					end
				end
				else print("Skipping update, you will be reminded next time")
				end
			end
			print("Downloading latest versions of required files")
			if not file_check(os.getenv("PWD") .. "default.gss") then 
				print("Downloading default.gss")
				downloadFile("default.gss","default.gss")
				downloaded = true
			end
			if not file_check(os.getenv("PWD") .. "cv.gss") then 
				print("Downloading cv.gss")
				downloadFile("cv.gss","cv.gss")
				downloaded = true
			end
			if not file_check(os.getenv("PWD") .. "gml.lua") then 
				print("Downloading gml.lua")
				downloadFile("gml.lua","gml.lua")
				downloaded = true
			end
			if not file_check(os.getenv("PWD") .. "gfxbuffer.lua") then 
				print("Downloading gfxbuffer.lua")
				downloadFile("gfxbuffer.lua","gfxbuffer.lua")
				downloaded = true
			end
			if not file_check(os.getenv("PWD") .. "colorutils.lua") then 
				print("Downloading colorutils.lua")
				downloadFile("colorutils.lua","colorutils.lua")
				downloaded = true
			end
			if not file_check(os.getenv("PWD") .. "compviewer-version.txt") then 
				print("Downloading compviewer-version.txt")
				downloadFile("compviewer-version.txt","compviewer-version.txt")
			end
			if downloaded == true then
				print("Please run the program again")
				os.exit()
			end
		end

		if not component.isAvailable("internet") then 
			if not file_check(os.getenv("PWD") .. "gml.lua") or not file_check(os.getenv("PWD") .. "cv.gss") or not file_check(os.getenv("PWD") .. "default.gss") or not file_check(os.getenv("PWD") .. "gfxbuffer.lua") or not file_check(os.getenv("PWD") .. "colorutils.lua") or not file_check(os.getenv("PWD") .. "CompInfo.txt") then
				io.stderr:write("You are missing one or more of the required files 'gml.lua', 'colorutils.lua', 'gfxbuffer.lua', 'CompInfo.txt', 'default.gss', or 'cv.gss' and do not have internet access to download them automaticly!\n")
				return
			end
		else
--We load the internet API here so we don't die on computers without internet cards.
internet = require("internet")
if not file_check(os.getenv("PWD") .. "compviewer-version.txt") then 
	print("Setting up version cache")
	downloadFile("compviewer-version.txt","compviewer-version.txt")
end
--Check if this is a fresh download, or a update 0 is fresh, > 0 is update.
newVersion = remoteVersion()
if (compareVersions(newVersion, localVersion()) == 0) then
	doUpdate("fresh")
	elseif(compareVersions(newVersion, localVersion()) > 0) then
		doUpdate("update")
	end
	print("Updating Component Info file, One moment please")
	fs.remove(os.getenv("PWD") .. "CompInfo.txt")
	os.sleep(1)
	downloadFile("CompInfo.txt")
end
--We've checked for gml, and downloaded it if it was available, so we can load gml now.
local gml=require("gml")
--We now return you to the previous code by Kenny.
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

local compList = {}
local tmpList = {}
local sentStr = {}
local compLen = 1

local fname = "CompInfo.txt"
local filename = shell.resolve(fname)

local w, h = gpu.getResolution()

local guiRow = 1
local guiWidth = 1
local guiHeight = 1
local guiContentsLabelCol = 1
local guiContentsLabelWidth = 1
local menuDirWidth = 1
local menuDirHeight = 1
local functionsCol = 1
local functionsWidth = 1
local functionsHeight = 1
local infoGuiWidth = 1
local infoGuiHeight = 1
local infoFunctionsLabelWidth = 1
local infoListboxWidth = 1
local infoListboxHeight = 1

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

local gpuDepth = gpu.getDepth()
if (gpuDepth >= Tier2) then
	theme = defaultTheme
else
	theme = normalTheme
end


if (gpuDepth == Tier3) then
	guiRow = 15
	guiWidth = 80
	guiHeight = 30
	guiContentsLabelCol = 30
	guiContentsLabelWidth = 31
	menuDirWidth = 24
	menuDirHeight = 25
	functionsCol = 30
	functionsWidth = 50
	functionsHeight = 25
	infoGuiWidth = 160
	infoGuiHeight = 50
	infoFunctionsLabelWidth = 50
	infoListboxWidth = 160
	infoListboxHeight = 42
	intro()
elseif (gpuDepth == Tier2) then
	guiRow = "center"
	guiWidth = 50
	guiHeight = 16
	guiContentsLabelCol = 18
	guiContentsLabelWidth = 31
	menuDirWidth = 16
	menuDirHeight = 11
	functionsCol = 20
	functionsWidth = 30
	functionsHeight = 11
	infoGuiWidth = 80
	infoGuiHeight = 25
	infoFunctionsLabelWidth = 30
	infoListboxWidth = 80
	infoListboxHeight = 16
else 
	guiRow = "center"
	guiWidth = 50
	guiHeight = 16
	guiContentsLabelCol = 18
	guiContentsLabelWidth = 31
	menuDirWidth = 16
	menuDirHeight = 11
	functionsCol = 20
	functionsWidth = 30
	functionsHeight = 11
	infoGuiWidth = 50
	infoGuiHeight = 16
	infoFunctionsLabelWidth = 30
	infoListboxWidth = 50
	infoListboxHeight = 10
end

local function strripos(s, delim)
	return s:match('^.*()'..delim)
end

local gui=gml.create("center", guiRow, guiWidth, guiHeight)
gui.style=gml.loadStyle("cv.gss")

gui:addLabel(2,1,14,"Component")
local contentsLabel=gui:addLabel(guiContentsLabelCol,1, guiContentsLabelWidth, "contents of")


local function getMenuList()
	menuList = {}
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
					v = text.trim(v)
				if string.len(v) > lineLen then
					while string.len(v) > lineLen do
						v = spaces(6)..v
						tmpStr = string.sub(v, 1, lineLen)
            if string.len(tmpStr) < lineLen then
              tStr = string.sub(tmpStr, 1, string.len(tmpStr) - 1)
            else
              delimPos = strripos(tmpStr, " ")
              tStr = string.sub(tmpStr, 1, delimPos - 1)
            end
						table.insert(sentStr, tStr)
						v = string.sub(v, delimPos + 1)
					end
					if string.len(v) < lineLen then
						table.insert(sentStr, spaces(6)..text.trim(v))
					end
				elseif string.sub(v, 1, string.len(select)) == select then
					table.insert(sentStr, v)
				else 
					table.insert(sentStr, spaces(6)..v)
				end
			end
		end
	end
  for a = 1, #sentStr do
    if string.sub(sentStr[a], 1, string.len(select)) == select then
      sentStr[a] = string.sub(sentStr[a], string.len(select) + 2, string.len(sentStr[a]))
    end
  end
end

getMenuList()

local menuDirList=gui:addListBox(2, 2, menuDirWidth, menuDirHeight, menuList)
local functionsList=gui:addListBox(functionsCol, 2, functionsWidth, functionsHeight, tmpList)

local function updateMenuList()
	getMenuList()
	menuDirList:updateList(menuList)
end

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
	local infoGUI=gml.create("center", "center", infoGuiWidth, infoGuiHeight)
	select = menuDirList:getSelected()
	loadInfoData(select)
	term.clear()
	local infoLabel=infoGUI:addLabel("center", 1, infoFunctionsLabelWidth, "Functions explanation for "..select)
	local infoList=infoGUI:addListBox(1, -5, infoListboxWidth, infoListboxHeight, sentStr)
	infoGUI:addButton("center",-1,12,2,"Close",infoGUI.close)
	infoGUI:run()
	term.clear()
	if (gpuDepth == Tier3) then
		intro()
	end
	gui:draw()
end

gui:addButton(-20,-1,8,1,"Info", newListBox)
gui:addButton(-11,-1,8,1,"Reload", updateMenuList)
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
