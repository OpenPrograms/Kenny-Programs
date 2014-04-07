 local component = require("component")
local fs = require("filesystem")
local internet = require("internet")
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
		wget("https://raw.github.com/OpenPrograms/Kenny-Programs/master/LC_Control/" .. remotename, filename)
	end

	function remoteVersion()
		for line in internet.request("https://raw.github.com/OpenPrograms/Kenny-Programs/master/LC_Control/stargate-version.txt") do 
			if line ~= "not found" then 
				return text.trim(line)
			else 
				return 0 
			end
		end
	end

	function localVersion()
		if not file_check(os.getenv("PWD") .. "stargate-version.txt") then
			return 0
		else
			local f = io.open(os.getenv("PWD") .. "stargate-version.txt", "rb")
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
					fs.remove(os.getenv("PWD") .. "stargate-version.txt")
					currFile = process.running()
					fs.remove(currFile)
					if not file_check(os.getenv("PWD") .. currFile) then 
						print("Downloading stargate.lua")
						downloadFile("stargate.lua", currFile)
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
			if not file_check(os.getenv("PWD") .. "stargate-version.txt") then 
				print("Downloading stargate-version.txt")
				downloadFile("stargate-version.txt","stargate-version.txt")
			end
			if downloaded == true then
				print("Please run the program again")
				os.exit()
			end
		end

		if not component.isAvailable("internet") then 
			if not file_check(os.getenv("PWD") .. "gml.lua") or not file_check(os.getenv("PWD") .. "cv.gss") or not file_check(os.getenv("PWD") .. "default.gss") or not file_check(os.getenv("PWD") .. "gfxbuffer.lua") or not file_check(os.getenv("PWD") .. "colorutils.lua") or not file_check(os.getenv("PWD") .. "GateInfo.txt") then
				io.stderr:write("You are missing one or more of the required files 'gml.lua', 'colorutils.lua', 'gfxbuffer.lua', 'default.gss', or 'cv.gss' and do not have internet access to download them automaticly!\n")
				return
			end
		else
--We load the internet API here so we don't die on computers without internet cards.
internet = require("internet")
if not file_check(os.getenv("PWD") .. "stargate-version.txt") then 
	print("Setting up version cache")
	downloadFile("stargate-version.txt","stargate-version.txt")
end
--Check if this is a fresh download, or a update 0 is fresh, > 0 is update.
if (compareVersions(remoteVersion(), localVersion()) == 0) then
	doUpdate("fresh")
	elseif(compareVersions(remoteVersion(), localVersion()) > 0) then
		doUpdate("update")
	end
	os.sleep(0.5)
end
--We've checked for gml, and downloaded it if it was available, so we can load gml now.

local gml=require("gml")

local gpu=component.gpu
local fname = "GateInfo.txt"
local filename = shell.resolve(fname)
local connectAddress = ""
local destAddress = {" "}
local destName = {" "}
local timerID = 0

local function isAdvanced()
	return gpu.getDepth()
end

local function strripos(s, delim)
	return s:match('^.*()'..delim)
end

function loadAddressData()
	do
		local f = io.open(filename)
		if f then
			for line in f:lines() do
				line = text.trim(line)
				delimPos = strripos(line, ",")
				table.insert(destName, string.sub(line, 1, delimPos - 1))
				table.insert(destAddress, string.sub(line, delimPos + 1, string.len(line)))
			end
			f:close()
		end
	end
end




local sg = component.stargate

local gui=gml.create("center", 1, 160, 50)
gui.style=gml.loadStyle("cv.gss")

local function dialing()
  return tostring(sg.isDialing())
end

local function connected()
  return tostring(sg.isConnected())
end

local function valid(address)
  local reply, error = sg.isValidAddress(address)
  if reply == nil then
    return (error)
  else
    return (tostring(reply))
  end
end
 


loadAddressData()

local addressListBoxGUI = gml.create(65, 16, 70, 20)
local addressList=gui:addListBox(75,-22,50,11, destName)
local addressLabel=gui:addLabel(75, -19, 35,"Destination Address:  "..destAddress[1])
local validLabel=gui:addLabel(75, -17, 50, "Valid Address:  "..valid(destAddress[1]))

local dialingLabel=gui:addLabel(40, 3, 13,"Dialing:  ")
local dialingActiveLabel=gui:addLabel(54, 3, 7,"       ")

local contentsLabel=gui:addLabel(10, 3, 30, "Gate Address:  "..sg.getAddress())
local connectedLabel=gui:addLabel(70, 3, 18, "Gate Connected:  ")
local connectedActiveLabel=gui:addLabel(89, 3, 7, "       ")

local newAddressGUI = gml.create(8, 16, 50, 20)
local newAddressLabel=gui:addLabel(15, -31, 13,"Address Name:")
local newAddressField=gui:addTextField(15,-28,30)
local newGateAddressLabel=gui:addLabel(15, -26, 13,"Gate Address:")
local newGateAddressField=gui:addTextField(15,-22,10)

function saveAddressData()
  destName[#destName + 1] = text.trim(newAddressField.text)
  destAddress[#destAddress + 1] = text.trim(newGateAddressField.text)
	do
		local f = io.open(filename, "w")
		if f then
			for a = 1, #destName do
        f:write(tostring(destName[a])..","..tostring(destAddress[a]).."\n")
			end
			f:close()
		end
	end
  addressList:updateList(destName)
end

local newAddressSave=gui:addButton(21,-18,10,1,"Save", saveAddressData)
local newAddressCancel=gui:addButton(37,-18,10,1,"Cancel",gui.close)


gui.onRun=function()
  newAddressGUI:draw()
  newAddressLabel:draw()
  newAddressField:draw()
  newGateAddressLabel:draw()
  newGateAddressField:draw()
  newAddressSave:draw()
  newAddressCancel:draw()
  addressListBoxGUI:draw()
  addressList:draw()
  addressLabel:draw()
  validLabel:draw()
  dialingLabel:draw()
  dialingActiveLabel:draw()

end



local function updateValues()
  event.cancel(timerID)
  connectedActiveLabel.text=string.sub(" "..connected().."  ", 1, 7)
  dialingActiveLabel.text= string.sub(" "..dialing().."  ", 1, 7)

  if (text.trim(connected()) == "false") then
    connectedActiveLabel["text-color"] = 0xFFFFFF
    connectedActiveLabel["text-background"] = 0xBB0000
  else
    connectedActiveLabel["text-color"] = 0xFFFFFF
    connectedActiveLabel["text-background"] = 0x009900
  end
  if (text.trim(dialing()) == "false") then
    dialingActiveLabel["text-color"] = 0xFFFFFF
    dialingActiveLabel["text-background"] = 0xBB0000
  else
    dialingActiveLabel["text-color"] = 0xFFFFFF
    dialingActiveLabel["text-background"] = 0x009900
  end

  connectedLabel:draw()
  connectedActiveLabel:draw()
  dialingLabel:draw()
  dialingActiveLabel:draw()
end


local function updateDialAddress(info)
  local addressID = 0
  local addInfo = text.trim(info)
  connectAddress = ""
  
  for id, name in pairs(destName) do
    if text.trim(name) == text.trim(addInfo) then
      addressID = id
      break
    end
  end
  if addressID ~= 0 then
    connectAddress = text.trim(destAddress[addressID])
    addressLabel.text="Destination Address: "..destAddress[addressID]
    addressLabel:draw()
  end
  validLabel.text= "Valid Address:  "..valid(connectAddress)
  validLabel:draw()
end




local function disconnect()
  sg.disconnect()
  os.sleep(2)
  updateValues()
end

local function dialGate()
  sg.dial(connectAddress)
  dialingActiveLabel["text-color"] = 0xFFFFFF
  dialingActiveLabel["text-background"] = 0x009900
  dialingActiveLabel.text= string.sub(" "..dialing().."  ", 1, 7)
  dialingActiveLabel:draw()
  timerID = event.timer(26, updateValues, 1)
end



local connect=gui:addButton(5,-3,10,1,"Connect",dialGate)
local disconnect=gui:addButton(25,-3,10,1,"Disconnect", disconnect)
local refuel=gui:addButton(45,-3,10,1,"Refuel",gui.close)
local close=gui:addButton(65,-3,10,1,"Close",gui.close)


local function onAddressSelect(lb,prevIndex,selIndex)
  updateDialAddress(addressList:getSelected())
end

addressList.onChange=onAddressSelect

addressList.onDoubleClick=function()
  updateDialAddress(addressList:getSelected())
end

updateValues()
gui:run()

gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x000000)
term.clear()