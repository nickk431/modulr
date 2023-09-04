--[[
	File: app.lua
	Where the app is created and then passed to the main script to be rendered
]]

-- < Services >
local HttpService = game:GetService("HttpService")

-- < Packages >
local Packages = script.Parent.packages
local Fusion = require(Packages.fusion)
local States = require(Packages.states)

-- < Components >
local Bar = require(script.Parent.components.commandbar.bar)
local NotificationHolder = require(script.Parent.components.notification.holder)
local Suggestions = require(script.Parent.components.commandbar.suggestions)

-- < Variables >
local Children = Fusion.Children
local ForPairs = Fusion.ForPairs
local New = Fusion.New

-- < Component >
return function(parent)
	return New("ScreenGui")({
		Name = HttpService:GenerateGUID(false),
		DisplayOrder = 100,
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = parent,

		[Children] = {
			Bar(),
			Suggestions(),
			NotificationHolder(),

			ForPairs(States.Objects, function(index, value)
				return index, value
			end, Fusion.cleanup),
		},
	})
end
