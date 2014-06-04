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
autoUpdate = false

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
		wget("https://raw.github.com/OpenPrograms/Kenny-Programs/master/OL_Control/" .. remotename, filename)
	end

	function remoteVersion()
		for line in internet.request("https://raw.github.com/OpenPrograms/Kenny-Programs/master/OL_Control/ol-version.txt") do 
			if line ~= "not found" then 
				return text.trim(line)
			else 
				return 0 
			end
		end
	end

	function localVersion()
		if not file_check(os.getenv("PWD") .. "ol-version.txt") then
			return 0
		else
			local f = io.open(os.getenv("PWD") .. "ol-version.txt", "rb")
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
				doTehUpdate = string.lower(doTehUpdate)
				if doTehUpdate == "yes" then
					print("Cleaning up previous install")
					fs.remove(os.getenv("PWD") .. "default.gss")
					fs.remove(os.getenv("PWD") .. "cv.gss")
					fs.remove(os.getenv("PWD") .. "gml.lua")
					fs.remove(os.getenv("PWD") .. "gfxbuffer.lua")
					fs.remove(os.getenv("PWD") .. "colorutils.lua")
					fs.remove(os.getenv("PWD") .. "colorutils.lua")
					fs.remove(os.getenv("PWD") .. "ol-version.txt")
					currFile = process.running()
					fs.remove(currFile)
					if not file_check(os.getenv("PWD") .. currFile) then 
						print("Downloading OL_Control.lua")
						downloadFile("OL_Control.lua", currFile)
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
			if not file_check(os.getenv("PWD") .. "ol-version.txt") then 
				print("Downloading ol-version.txt")
				downloadFile("ol-version.txt","ol-version.txt")
			end
			if downloaded == true then
				print("Please run the program again")
				os.exit()
			end
		end

		if not component.isAvailable("internet") then 
			if not file_check(os.getenv("PWD") .. "gml.lua") or not file_check(os.getenv("PWD") .. "cv.gss") or not file_check(os.getenv("PWD") .. "default.gss") or not file_check(os.getenv("PWD") .. "gfxbuffer.lua") or not file_check(os.getenv("PWD") .. "colorutils.lua") or not file_check(os.getenv("PWD") .. "colorinfo.txt") then
				io.stderr:write("You are missing one or more of the required files 'gml.lua', 'colorutils.lua', 'gfxbuffer.lua', 'colorinfo.txt', 'default.gss', or 'cv.gss' and do not have internet access to download them automaticly!\n")
				return
			end
		else
--We load the internet API here so we don't die on computers without internet cards.
internet = require("internet")
if not file_check(os.getenv("PWD") .. "ol-version.txt") then 
	print("Setting up version cache")
	downloadFile("compviewer-version.txt","ol-version.txt")
end
--Check if this is a fresh download, or a update 0 is fresh, > 0 is update.
newVersion = remoteVersion()
if (compareVersions(newVersion, localVersion()) == 0) then
	doUpdate("fresh")
	elseif(compareVersions(newVersion, localVersion()) > 0) then
		doUpdate("update")
	end
	print("Updating Color Info file, One moment please")
	fs.remove(os.getenv("PWD") .. "colorinfo.txt")
	os.sleep(1)
	downloadFile("colorinfo.txt")
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

local openLight = component.openlight
local gpu = component.gpu

local fname = "colorinfo.txt"
local filename = shell.resolve(fname)

local Tier1 = 1
local Tier2 = 4
local Tier3 = 8

local lightListDir = {}
local colorListDir = {}
local colorList = {}
local lightColorID = "0x000000"
local lightAddy = ""

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
	
	centerText(9, "O p e n L i g h t s  C o n t r o l  P a n e l")
end

local gpuDepth = gpu.getDepth()
if (gpuDepth >= Tier2) then
	theme = defaultTheme
else
	theme = normalTheme
end

local function strripos(s, delim)
	return s:match('^.*()'..delim)
end

function loadColorData()
	do
		local f = io.open(filename)
			if f then
				for line in f:lines() do
					table.insert(colorList, line)
				end
			f:close()
		end
	end	
end

if (gpuDepth == Tier3) then
	guiRow = 15
	guiWidth = 80
	guiHeight = 30
	guiContentsLabelCol = 30
	guiContentsLabelWidth = 31
	lightListCol = 2
	lightListRow = 4
	lightListWidth = 45
	lightListHeight = 10
	colorListCol = 2
	colorListRow = 18
	colorListWidth = 45
	colorListHeight = 10
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
	lightListCol = 2
	lightListRow = 4
	lightListWidth = 45
	lightListHeight = 10
	colorListCol = 2
	colorListRow = 18
	colorListWidth = 45
	colorListHeight = 10
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
	lightListCol = 2
	lightListRow = 3
	lightListWidth = 16
	lightListHeight = 10
	functionsCol = 20
	functionsWidth = 30
	functionsHeight = 11
	infoGuiWidth = 50
	infoGuiHeight = 16
	infoFunctionsLabelWidth = 30
	infoListboxWidth = 50
	infoListboxHeight = 10
end

local function getLightList()
	lightList = {}
	for address, name in component.list() do
		if (name == "openlight") then
			table.insert(lightList," "..address)
		end
  end
end

getLightList()
loadColorData()

local gui=gml.create("center", guiRow, guiWidth, guiHeight)
gui.style=gml.loadStyle("cv.gss")
gui:addLabel(15, 2, 14, "  Light List  ")
gui:addLabel(15, 16, 14, "  Color List  ")

local function getColorValue()
end


local lightListDir=gui:addListBox(lightListCol, lightListRow, lightListWidth, lightListHeight, lightList)
local colorListDir=gui:addListBox(colorListCol, colorListRow, colorListWidth, colorListHeight, colorList)

local function updateLightList()
	getLightList()
	lightListDir:updateList(lightList)
end

getColorLabel = gui:addLabel(50, 4, 10, "          ")
setColorLabel = gui:addLabel(65, 4, 10, " Orange   ")

gui:addButton(50, 6, 11, 1, "Get Color", tostring(openLight.getColor(lightList[lightListDir:getSelected()])))
gui:addButton(65, 6, 11, 1, "Set Color", setColorValue)

getBrightLabel = gui:addLabel(50, 9, 10, tostring(openLight.getBrightness()))
setBrightLabel = gui:addLabel(65, 9, 10, " Orange   ")

gui:addButton(50, 11, 10, 1, "Get Bright", updateLightList)
gui:addButton(65, 11, 10, 1, "Set Bright", gui.close)

gui:addLabel(50, 16, 10, "Color List")
gui:addLabel(65, 16, 10, "Light List")

gui:addButton(50, 18, 8, 1, "Reload", loadColorData)
gui:addButton(65, 18, 8, 1, "Reload", updateLightList)

gui:addButton(-2, -1, 8, 1, "Close", gui.close)

local function setColorValue()
	print(lightAddy, lightColorID)
	openLight.setColor(lightAddy, "0x"..lightColorID)
	getColorLabel.text = lightColorId
	getColorLabel:redraw()
end

local function onLightSelect(lb,prevIndex,selIndex)
	lightAddy = lightListDir:getSelected()
end

local function onColorSelect(lb,prevIndex,selIndex)
	lightColorID = string.sub(colorListDir:getSelected(), -6)
end

lightListDir.onChange=onLightSelect
colorListDir.onChange=onColorSelect

lightListDir.onDoubleClick=function()
end

gui.onClose=function()
end

gui.onRun=function()
end

gui:run()

term.setCursor(1,1)
gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x000000)

term.clear()
