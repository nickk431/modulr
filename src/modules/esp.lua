local Components = script.Parent.Parent.components
local Input = require(Components.window.input)
local Switch = require(Components.window.switch)
local Window = require(Components.window.window)

local espStore = require(script.Parent.Parent.stores.esp)

local wallCheck = false
local espEnabled = false
local espOutline = 0
local espFill = 0

return {
	name = "esp",
	description = "Brings up options for the ESP.",
	arguments = {},

	callback = function()
		Window({
			title = "ESP",
			size = UDim2.fromOffset(320, 394),
		}, {
			Switch({
				text = "Enabled",
				subtext = "Whether or not the ESP is enabled.",
				callback = function(state)
					espEnabled = state

					espStore:set({
						enabled = state,
						outlineTransparency = espOutline,
						fillTransparency = espFill,
						wallCheck = wallCheck,
					})
				end,
			}),

			Switch({
				text = "Wallcheck",
				subtext = "Makes the ESP occuluded.",
				callback = function(state)
					espStore:set({
						enabled = espEnabled,
						outlineTransparency = espOutline,
						fillTransparency = espFill,
						wallCheck = state,
					})
				end,
			}),

			Input({
				text = "Outline",
				subtext = "The outline transparency.",
				placeholderText = "0",
				callback = function(value)
					espStore:set({
						enabled = espEnabled,
						outlineTransparency = value,
						fillTransparency = espFill,
						wallCheck = wallCheck,
					})

					espOutline = value
				end,
				executionEvent = "onFocusLost",
			}),

			Input({
				text = "Fill",
				subtext = "The fill transparency.",
				placeholderText = "0",
				callback = function(value)
					espStore:set({
						enabled = espEnabled,
						outlineTransparency = espOutline,
						fillTransparency = value,
						wallCheck = wallCheck,
					})

					espFill = value
				end,
				executionEvent = "onFocusLost",
			}),
		})
	end,
}
