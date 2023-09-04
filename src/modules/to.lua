local Notification = require(script.Parent.Parent.components.notification.notification)
local Player = require(script.Parent.Parent.utils.player)

return {
	name = "to",
	description = "Teleports you to the target",
	arguments = {
		{
			name = "player",
			type = "player",
		},
	},

	callback = function(_, arguments)
		local target = Player.getByName(arguments.player)

		if not target then
			Notification({
				title = "Error",
				description = "Failed to find player: " .. arguments.player,
				type = "error",
				duration = 5,
			})

			return
		end

		Player.setPosition(target.Character:GetPivot())
	end,
}
