--[[
	File: app.story.lua
	Returns the app component for use with hoarcekat
]]

local App = require(script.Parent.app)

return function(target)
	local tree = App(target)

	return function()
		tree:Destroy()
	end
end
