return {
	name = "jumppower",
	description = "Changes your character's JumpPower",
	arguments = {
		{
			name = "value",
			type = "number",
		},
	},

	callback = function(_, utils, arguments)
		utils.player.getHumanoid().JumpPower = arguments.value
	end,
}
