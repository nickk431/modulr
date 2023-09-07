local freecam = require(script.Parent.Parent.packages.freecam)
local enabled = false

return {
	name = "freecam",
	description = "Lets you move your camera freely.",
	arguments = {},

	callback = function()
		enabled = not enabled

		if enabled then
			freecam.EnableFreecam()
		else
			freecam.DisableFreecam()
		end
	end,
}
