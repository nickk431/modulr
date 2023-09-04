return {
	name = "walkspeed",
	description = "Changes your character's WalkSpeed",
	arguments = {
		{
			name = "value",
			type = "number",
		},
	},

	callback = function(_, utils, arguments)
		utils.player.getHumanoid().WalkSpeed = arguments.value
	end,
}
