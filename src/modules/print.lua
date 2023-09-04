return {
	name = "print",
	description = "Prints to the console",
	arguments = {
		{
			name = "input",
			type = "string",
		},
	},

	callback = function(_, arguments)
		print(arguments.input)
	end,
}
