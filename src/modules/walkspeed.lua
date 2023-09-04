local Player = require(script.Parent.Parent.utils.player)

return {
	name = "walkspeed",
	description = "Changes your character's WalkSpeed",
	arguments = {
		{
			name = "value",
			type = "number",
		},
	},

	callback = function(_, arguments)
		Player.getHumanoid().WalkSpeed = arguments.value
	end,
}
