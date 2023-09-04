local request = require(script.Parent.Parent.utils.request)

return {
	name = "loadurl",
	description = "Loads a script and executes it",
	arguments = {
		{
			name = "url",
			type = "string",
		},
	},

	callback = function(_, arguments)
		request(arguments.url):andThen(function(result)
			pcall(loadstring, result)
		end)
	end,
}
