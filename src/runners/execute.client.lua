--[[
	File: suggestions.client.lua
	Keeps track of suggestions and changes the global state
]]

-- < Imports >
local Packages = script.Parent.Parent.packages
local Cmdr = require(Packages.cmdr)
local Fusion = require(Packages.fusion)
local States = require(Packages.states)

-- < Handling >
local function main()
	local Handler = Cmdr.new({})

	for _, module in script.Parent.Parent.modules:GetChildren() do
		local moduleData = require(module)

		Handler:newCommand({
			name = moduleData.name,
			description = moduleData.Description,
			arguments = moduleData.arguments,
			callback = moduleData.callback,
		})

		States.add("Commands", moduleData, moduleData.name)
	end

	local executeObserver = Fusion.Observer(States.ToExecute)
	executeObserver:onChange(function()
		local stringToExecute = States.ToExecute:get()

		if stringToExecute == "" then
			return
		end

		Handler:executeCommand(stringToExecute)
	end)
end

main()
