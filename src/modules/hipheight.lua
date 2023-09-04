return {
	name = "hipheight",
	description = "Changes your character's HipHeight",
	arguments = {
		{
			name = "value",
			type = "number",
		},
	},

	callback = function(_, utils, arguments)
		utils.player.getHumanoid().HipHeight = arguments.value
	end,
}
