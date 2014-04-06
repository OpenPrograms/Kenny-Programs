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
local gml=require("gml")





local gpu=component.gpu
local fname = "GateInfo.txt"
local filename = shell.resolve(fname)
local connectAddress = ""
local destAddress = {}
local destName = {}

local function isAdvanced()
	return gpu.getDepth()
end

local function strripos(s, delim)
	return s:match('^.*()'..delim)
end

function loadAddressData()
  local indx = 1
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

local dialing = ""

if (sg.isDialing()) then
	dialing = "True"
else
	dialing = "False"
end

if (sg.isValidAddress("DACEABGAA")) then
	valid = "True"
else
	valid = "False"
end

if (sg.isConnected()) then
	connected = "True"
else
	connected = "False"
end


loadAddressData()

local addressList=gui:addListBox(17,-22,32,11, destName)
local addressLabel=gui:addLabel(52, -32, 25,"Address:  "..destAddress[1])
local dialingLabel=gui:addLabel(2, 3, 25,"Dialing:  "..dialing)
local validLabel=gui:addLabel(2, 5, 25, "Valid Address:  "..valid)

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
    addressLabel.text="Address "..destAddress[addressID]
    addressLabel:draw()
  end
  if (sg.isValidAddress(connectAddress)) then
    valid = "True"
  else
    valid = "False"
  end
  validLabel.text= "Valid Address:  "..valid
  validLabel:draw()
end

local function dialGate()
  sg.dial(connectAddress)
  if (sg.isDialing()) then
    dialing = "True"
  else
    dialing = "False"
  end
  dialingLabel.text= "Dialing:  "..dialing
  dialingLabel:draw()
end

local contentsLabel=gui:addLabel(40, 3, 25, "Address:  "..sg.getAddress())
local connectedLabel=gui:addLabel(40, 5, 25, "Connected:  "..connected)

local connect=gui:addButton(5,-3,10,1,"Connect",dialGate)
local disconnect=gui:addButton(25,-3,10,1,"Disconnect",sg.disconnect)
local refuel=gui:addButton(45,-3,10,1,"Refuel",gui.close)
local close=gui:addButton(65,-3,10,1,"Close",gui.close)


local function onAddressSelect(lb,prevIndex,selIndex)
  updateDialAddress(addressList:getSelected())
end

addressList.onChange=onAddressSelect

addressList.onDoubleClick=function()
  updateDialAddress(addressList:getSelected())
end


gui:run()

gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x000000)
term.clear()