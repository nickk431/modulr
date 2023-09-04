local Player = require(script.Parent.Parent.utils.player)

return {
	name = "jumppower",
	description = "Changes your character's JumpPower",
	arguments = {
		{
			name = "value",
			type = "number",
		},
	},

	callback = function(_, arguments)
		Player.getHumanoid().JumpPower = arguments.value
	end,
}
