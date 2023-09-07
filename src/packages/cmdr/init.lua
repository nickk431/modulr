--!strict

local Notification = require(script.Parent.Parent.components.notification.notification)

local packages = {}
for _, package in script.Parent:GetChildren() do
	if package.Name ~= "cmdr" then
		packages[package.Name] = require(package)
	end
end

local utils = {}
for _, util in script.Parent.Parent.utils:GetChildren() do
	utils[util.Name] = require(util)
end

local ARGUMENT_TYPES = {
	string = function(argument)
		return argument
	end,

	number = function(argument)
		return tonumber(argument) or 0
	end,

	integer = function(argument)
		return math.floor(tonumber(argument) or 0)
	end,

	bool = function(argument)
		argument = string.lower(argument)
		return (argument == "on" or argument == "true" or argument == "yes" or argument == "1") or false
	end,

	url = function(argument)
		return string.match(argument, "^%a+://%S+")
	end,

	player = function(argument)
		return argument:lower()
	end,

	hex = function(argument)
		return string.match(argument, "^[A-Fa-f0-9]+$")
	end,
}

-- Classes
local Utilities = {}
do
	function Utilities.charAt(str: string, index: number): string?
		return string.sub(str, index, index)
	end

	function Utilities.startsWith(str: string, start: string): boolean
		return string.sub(str, 1, #start) == start
	end

	function Utilities.trim(str: string): string?
		return string.match(str, "^%s*(.-)%s*$")
	end
end

local Cmdr = {}

type Command = {
	name: string,
	description: string,
	arguments: {
		{
			name: string,
			type: string,
		}
	},
	callback: (...any) -> ...any,
}

do
	Cmdr.__index = Cmdr

	function Cmdr.new(props: { prefix: string? })
		local self = setmetatable({}, Cmdr)

		self.prefix = props.prefix or ""
		self.commands = {}

		return self
	end

	function Cmdr:newCommand(props: Command)
		local newCommand = {
			name = props.name,
			description = props.description,
			arguments = props.arguments,
			callback = props.callback,
		}

		table.insert(self.commands, newCommand)
	end

	function Cmdr:executeCommand(fromString: string)
		if Utilities.startsWith(fromString, self.prefix) then
			fromString = fromString:sub(#self.prefix + 1)
		end

		local tokens = {}
		for token in string.gmatch(Utilities.trim(fromString) or "", "%S+") do
			table.insert(tokens, token)
		end

		local commandName = tokens[1]
		local commandArgs = {}
		for i = 2, #tokens do
			table.insert(commandArgs, tokens[i])
		end

		local commandProcess
		local commandObject
		for _, command in self.commands do
			if command.name == commandName then
				commandProcess = command.callback
				commandObject = command
			end
		end

		if commandProcess == nil then
			Notification({
				title = "Error",
				description = "Could not find command <b>" .. commandName .. "</b>",
				duration = 5,
				type = "error",
			})

			return
		end

		local processArguments = {}
		for index, argument in commandObject.arguments do
			local argValue = commandArgs[index]

			if argValue then
				local validatedArg = ARGUMENT_TYPES[argument.type](argValue)

				if validatedArg == nil then
					Notification({
						title = "Error",
						description = "There was an error validating argument: <b>" .. argument.name .. "</b>",
						duration = 5,
						type = "error",
					})
				end

				processArguments[argument.name] = validatedArg
			else
				Notification({
					title = "Error",
					description = "Missing argument <b>" .. argument.name .. "</b>",
					duration = 5,
					type = "error",
				})
			end
		end

		local success, err = pcall(commandProcess, packages, utils, processArguments)
		if not success then
			error(err)
		end
	end
end

return table.freeze(Cmdr)
