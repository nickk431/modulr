local Player = require(script.Parent.Parent.utils.player)

return {
	name = "hipheight",
	description = "Changes your character's HipHeight",
	arguments = {
		{
			name = "value",
			type = "number",
		},
	},

	callback = function(_, arguments)
		Player.getHumanoid().HipHeight = arguments.value
	end,
}
