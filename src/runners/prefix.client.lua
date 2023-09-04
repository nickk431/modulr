--[[
	File: prefix.client.lua
	Keeps track of keybinds and changes the global state
]]

-- < Services >
local UserInputService = game:GetService("UserInputService")

-- < Imports >
local Constants = require(script.Parent.Parent.storage.constants)
local States = require(script.Parent.Parent.packages.states)

local PREFIX = Constants._PREFIX

-- < Handling >
local function main()
	UserInputService.InputBegan:Connect(function(inputObject, gameProcessedEvent)
		if gameProcessedEvent then
			return
		end

		if inputObject.KeyCode == PREFIX then
			task.wait()
			States.CommandBarOpened:set(true)
		end
	end)
end

main()
