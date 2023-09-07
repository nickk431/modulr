local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local Fusion = require(script.Parent.Parent.packages.fusion)
local Components = script.Parent.Parent.components

local Button = require(Components.window.button)
local Window = require(script.Parent.Parent.components.window.window)

local request = require(script.Parent.Parent.utils.request)
local placeId = game.PlaceId

return {
	name = "servers",
	description = "View a list of servers for the current game.",
	arguments = {},

	callback = function()
		local servers = {}

		request("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=50")
			:andThen(function(response)
				local body = HttpService:JSONDecode(response)

				for _, server in body.data do
					if type(server) == "table" and server.playing < server.maxPlayers then
						table.insert(servers, {
							id = server.id,
							ping = server.ping,
						})
					end
				end
			end)
			:finally(function()
				Window({
					title = "Servers",
					size = UDim2.fromOffset(345, 394),
				}, {
					Button({
						text = "Join Random",
						secondary = true,
						callback = function()
							TeleportService:TeleportToPlaceInstance(
								placeId,
								servers[math.random(1, #servers)].id,
								Players.LocalPlayer
							)
						end,
					}),

					Fusion.ForPairs(servers, function(index, server)
						print(index, server)
						return index,
							Button({
								text = "Server ID: " .. server.id,
								subtext = "Ping: " .. server.ping .. " ms",
								clickable = true,
								callback = function()
									TeleportService:TeleportToPlaceInstance(placeId, server.id, Players.LocalPlayer)
								end,
							})
					end, Fusion.cleanup),
				})
			end)
	end,
}
