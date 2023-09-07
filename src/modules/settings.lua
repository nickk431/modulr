local Components = script.Parent.Parent.components
local Button = require(Components.window.button)
local Constants = require(script.Parent.Parent.storage.constants)
local Divider = require(Components.window.divider)
local Section = require(Components.window.section)
local Switch = require(Components.window.switch)

local Window = require(Components.window.window)

local Packages = script.Parent.Parent.packages
local States = require(Packages.states)

local moduleCount = #script.Parent:GetChildren()

return {
	name = "settings",
	description = "View all the scripts settings",
	arguments = {},

	callback = function()
		Window({
			title = "Settings",
			size = UDim2.fromOffset(345, 394),
		}, {
			Section({
				text = "About",
				subtext = "View general info about the script",
				newPage = {
					Divider({
						text = "General",
					}),
					Button({
						text = "Version",
						subtext = Constants._VERSION .. "-" .. Constants._BRANCH,
						clickable = false,
					}),
					Button({
						text = "Modules",
						subtext = "There are currently <b>" .. moduleCount .. "</b> modules.",
						clickable = false,
					}),

					Divider({
						text = "Credits",
					}),
					Button({
						text = "Nick",
						subtext = "Founder / Main Developer",
						clickable = false,
					}),
					Button({
						text = "0866",
						subtext = "Search icon in the command bar",
						clickable = false,
					}),
					Button({
						text = "Dawid",
						subtext = "Github actions workflow",
						clickable = false,
					}),
					Button({
						text = "Sirius Community",
						subtext = "Thanks to all the members who gave feedback and helped out with decisions!",
						clickable = false,
					}),
				},
			}),

			Section({
				text = "Notifiers",
				subtext = "Manage notification events",
				newPage = {
					Switch({
						text = "FPS Drops",
						subtext = "When your FPS drops below 25",
						initialValue = States.FPSCheck,
						callback = function(value)
							States.FPSCheck:set(value)
						end,
					}),

					Switch({
						text = "Ping Spikes",
						subtext = "When your ping spikes above 150",
						initialValue = States.PingCheck,
						callback = function(value)
							States.PingCheck:set(value)
						end,
					}),
				},
			}),

			Section({
				text = "Themes",
				subtext = "View all the themes you can apply",
				newPage = {
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
				},
			}),

			Button({
				text = "Join Discord",
				secondary = true,
			}),
		})
	end,
}
