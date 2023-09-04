-- < Services >
local Players = game:GetService("Players")

-- < Imports >
local Packages = script.Parent.Parent.packages
local Stores = script.Parent.Parent.stores
local Fusion = require(Packages.fusion)

local unwrap = require(script.Parent.Parent.utils.unwrap)

-- < Variables >
local espStore = require(Stores.esp)
local storeEvent = Fusion.Observer(espStore)

-- < Functions >
local highlightObjects = {}

local function addHighlight(player)
	local espSettings = unwrap(espStore)

	local newHighlight = Instance.new("Highlight")
	newHighlight.Parent = player.Character
	newHighlight.Enabled = espSettings.enabled
	newHighlight.FillTransparency = espSettings.fillTransparency
	newHighlight.OutlineTransparency = espSettings.outlineTransparency
	newHighlight.DepthMode = if espSettings.wallCheck
		then Enum.HighlightDepthMode.Occluded
		else Enum.HighlightDepthMode.AlwaysOnTop

	highlightObjects[player.Name] = newHighlight
end

Players.PlayerAdded:Connect(function(player)
	addHighlight(player)

	player.CharacterAdded:Connect(function()
		addHighlight(player)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	highlightObjects[player.Name] = nil
end)

-- < Handling >
local function main()
	storeEvent:onChange(function()
		local espSettings = unwrap(espStore)

		for _, highlight in highlightObjects do
			highlight.Enabled = espSettings.enabled
			highlight.FillTransparency = espSettings.fillTransparency
			highlight.OutlineTransparency = espSettings.outlineTransparency
			highlight.DepthMode = if espSettings.wallCheck
				then Enum.HighlightDepthMode.Occluded
				else Enum.HighlightDepthMode.AlwaysOnTop
		end
	end)

	for _, player in Players:GetPlayers() do
		if player == Players.LocalPlayer then
			continue
		end

		addHighlight(player)

		player.CharacterAdded:Connect(function()
			addHighlight(player)
		end)
	end
end

main()
