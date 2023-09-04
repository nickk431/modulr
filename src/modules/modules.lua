local Components = script.Parent.Parent.components
local Button = require(Components.window.button)
local Section = require(Components.window.section)
local Window = require(Components.window.window)

local Packages = script.Parent.Parent.packages
local Fusion = require(Packages.fusion)
local States = require(Packages.states)

local Cleanup = Fusion.cleanup
local ForPairs = Fusion.ForPairs

return {
	name = "modules",
	description = "View all the modules in the script",
	arguments = {},

	callback = function()
		Window({
			title = "Modules",
			size = UDim2.fromOffset(345, 394),
		}, {
			ForPairs(States.Commands, function(index, value)
				return index,
					Section({
						text = value.name,
						subtext = value.description,
						newPage = {
							Fusion.Computed(function()
								if #value.arguments > 0 then
									return ForPairs(value.arguments, function(index2, argument)
										return index2,
											Button({
												text = "Argument: " .. argument.name,
												subtext = "Type: " .. argument.type,
											})
									end, Cleanup)
								end

								return Button({
									text = "Command has no arguments.",
									clickable = false,
								})
							end, Cleanup),
						},
					})
			end, Cleanup),
		})
	end,
}
