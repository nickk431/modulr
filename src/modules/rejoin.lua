local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local PlaceId, JobId = game.PlaceId, game.JobId

return {
	name = "rejoin",
	description = "Rejoins the current server you're in.",
	arguments = {},

	callback = function()
		if #Players:GetPlayers() <= 1 then
			Players.LocalPlayer:Kick("\nRejoining...")

			task.delay(0.3, function()
				TeleportService:Teleport(PlaceId, Players.LocalPlayer)
			end)
		else
			TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
		end
	end,
}
