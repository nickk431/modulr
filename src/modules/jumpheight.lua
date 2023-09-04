local humanoidStore = require(script.Parent.Parent.stores.humanoid)

return {
	name = "jumpheight",
	description = "Changes your character's JumpHeight",
	arguments = {
		{
			name = "value",
			type = "number",
		},
	},

	callback = function(_, arguments)
		humanoidStore:set({
			JumpHeight = arguments.value,
		})
	end,
}
