local humanoidStore = require(script.Parent.Parent.stores.humanoid)

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
		humanoidStore:set({
			WalkSpeed = arguments.value,
		})
	end,
}
