local humanoidStore = require(script.Parent.Parent.stores.humanoid)

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
		humanoidStore:set({
			JumpHeight = arguments.value,
		})
	end,
}
