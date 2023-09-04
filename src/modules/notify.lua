local Notification = require(script.Parent.Parent.components.notification.notification)

return {
	name = "notify",
	description = "Creates a notification (debug)",
	arguments = {
		{
			name = "title",
			type = "string",
		},
		{
			name = "desc",
			type = "string",
		},
		{
			name = "duration",
			type = "number",
		},
	},

	callback = function(_, _, arguments)
		Notification({
			title = arguments.title,
			description = arguments.desc,
			duration = arguments.duration,
			type = "success",
		})
	end,
}
