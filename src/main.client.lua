--!strict

--[[
	File: main.client.lua
	Mounts the ScreenGui and all of the components to CoreGui or PlayerGui
]]

-- < Services >
local Players = game:GetService("Players")

-- < Packages >
local Constants = require(script.Parent.storage.constants)
local Promise = require(script.Parent.packages.promise)

-- < Components >
local App = require(script.Parent.app)
local Notification = require(script.Parent.components.notification.notification)

-- < Private functions >
local function round(num: number, dec: number)
	local shift = 10 ^ (dec or 2)

	return math.floor(num * shift + 0.5) / shift
end

local function canAccessCoreGui()
	local success, _ = pcall(function()
		return game:GetService("CoreGui").Name == nil
	end)

	return success
end

local function getParent()
	local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")

	if canAccessCoreGui() then
		return game:GetService("CoreGui")
	elseif PlayerGui then
		return PlayerGui
	else
		error("Failed to find a valid parent for the app.")
	end
end

local function render()
	return Promise.new(function(resolve, reject)
		local appParent = getParent()

		local success, err = pcall(App, appParent)
		if success then
			resolve()
		else
			reject(err)
		end
	end)
end

-- < Handling >
local start = os.clock()

render()
	:andThen(function()
		Notification({
			title = "Info",
			description = "Make sure to join the Discord at <b>discord.gg/sJVHnXR8</b>!",
			duration = 12,
			type = "info",
		})

		Notification({
			title = "Success",
			description = "Modulr <b>"
				.. Constants._VERSION
				.. "</b> loaded in <b>"
				.. round(os.clock() - start, 4)
				.. "</b> seconds.",
			duration = 8,
			type = "success",
		})
	end)
	:catch(function(err)
		warn("Failed to initialize app: " .. tostring(err))

		Notification({
			title = "Error",
			description = "An error occurred while initializing. Please check the console for more information.",
			duration = 8,
			type = "error",
		})
	end)
