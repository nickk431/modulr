-- < Services >
local Players = game:GetService("Players")

-- < Imports >
local Packages = script.Parent.Parent.packages
local Stores = script.Parent.Parent.stores
local Fusion = require(Packages.fusion)

-- < Variables >
local player = Players.LocalPlayer

local humanoidStore = require(Stores.humanoid)
local storeEvent = Fusion.Observer(humanoidStore)

-- < Handling >
local function main()
	local character = player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid", 5)

	storeEvent:onChange(function()
		local values = humanoidStore:get()

		for property, value in values do
			humanoid[property] = value
		end
	end)

	player.CharacterAdded:Connect(function(char)
		humanoid = char:WaitForChild("Humanoid", 5)
	end)
end

main()
