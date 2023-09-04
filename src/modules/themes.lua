local Components = script.Parent.Parent.components
local Button = require(Components.window.button)
local Window = require(Components.window.window)

local Packages = script.Parent.Parent.packages
local States = require(Packages.states)

return {
	name = "themes",
	description = "View all the themes you can apply",
	arguments = {},

	callback = function()
		Window({
			title = "Themes",
			size = UDim2.fromOffset(345, 394),
		}, {
			Button({
				text = "Dracula",
				subtext = "A dark purple theme based on the Dracula color pallete.",
				callback = function()
					States.Theme:set("dracula")
				end,
			}),

			Button({
				text = "Dark",
				subtext = "A classic dark theme with not much to it",
				callback = function()
					States.Theme:set("dark")
				end,
			}),

			Button({
				text = "Nord",
				subtext = "A dark blue theme based on the Nord color pallete.",
				callback = function()
					States.Theme:set("nord")
				end,
			}),
		})
	end,
}
