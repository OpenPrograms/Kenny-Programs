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

local ks = {}
local gpu = component.gpu



function ks.getCursor()
	return term.getCursor()
end


function ks.setCursor(col, row)
	return term.setCursor(col, row)
end


function ks.setColors(fore, back)
	gpu.setForeground(fore)
	gpu.setBackground(back)
end

-- gets the screen resolution
function ks.getSize()
  return gpu.getResolution()
end


-- checks to see if the monitor is a color monitor
function ks.isAdvanced()
	return (gpu.getDepth() > 1)
end

--clears the in the area specified
function ks.clearWin(col, row, wid, hgt)
	gpu.fill(col, row, col + wid, row + hgt, " ")
end


--saves the specified area to be restored later
function ks.saveWin(x, y, wid, hgt)
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


--restores a saved window
function ks.restoreWin(x, y, wind)
	for a = 1, #wind do
		gpu.set(x, (y + a) - 1, wind[a])
	end
end


--draws a box at the give col, row a specified with setting the screen colors and wether it is a single or double line box.
function ks.box(col, row, wid, hgt, fore, back, opt)
	-- opt =  1 for single box, 2 for a double line box
	local upperLeft = {0x250C, 0x2554}
	local upperRight = {0x2510, 0x2557}
	local lowerLeft = {0x2514, 0x255A}
	local lowerRight = {0x2518, 0x255D}
	local sideLine = {0x2502, 0x2551}
	local acrossLine = {0x2500, 0x2550}
	gpu.setForeground(fore)
	gpu.setBackground(back)
	component.gpu.set(col, row, unicode.char(upperLeft[opt])..string.rep(unicode.char(acrossLine[opt]), wid - 2)..unicode.char(upperRight[opt]))
	for a = 1, hgt - 2 do
		component.gpu.set(col, row + a, unicode.char(sideLine[opt])..string.rep(unicode.char(0x0020), wid - 2)..unicode.char(sideLine[opt]))
	end
	component.gpu.set(col, row + hgt - 2,	unicode.char(lowerLeft[opt])..string.rep(unicode.char(acrossLine[opt]), wid - 2)..unicode.char(lowerRight[opt]))
	term.setCursor(col, row)
end


--print a string at the given col, row
function ks.printXY(col, row, msg)
	component.gpu.set(col, row, msg)
end	


-- cnters a string on the given row
function ks.centerText(row, msg)
	local w, h = gpu.getResolution()
	local len = string.len(msg)
	component.gpu.set((w - len)/2, row, msg)
end


--trims blanks spaces from the beginning and end of a string
function ks.trim(msg)
	return text.trim(msg)
end


--adds or prints the specified number of spaces
function ks.spaces(cnt)
	return string.rep(string.char(32), cnt)
end


--adds or prints the specified number of special chars
function ks.spChar(charter, cnt)
	return string.rep(unicode.char(charter), cnt)
end


--this is use by table_unique
local function table_count(tt, item)
	local count
	count = 0
	for ii,xx in pairs(tt) do
		if item == xx then count = count + 1 end
	end
	return count
end

--this function will remove duplicate entries from a table	
function ks.table_unique(tt)
	local newtable = {}
	for ii,xx in ipairs(tt) do
		if table_count(newtable, xx) == 0 then
			newtable[#newtable+1] = xx
		end
	end
	return newtable
end

--function for getting a single character from the keyboard.  this is for alpha/numeric jeys
function ks.getCh()
	return (select(3, event.pull("key_down")))
end

--function for getting a control character from the keyboard.  this is for shift/alt/control, etc.   special control keys
function ks.getKey()
	return (select(4, event.pull("key_down")))
end

return ks
