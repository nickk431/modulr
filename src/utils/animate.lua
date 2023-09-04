local Fusion = require(script.Parent.Parent.packages.fusion)
local Spring = Fusion.Spring
local Computed = Fusion.Computed

return function(callback, speed, damping)
	return Spring(Computed(callback), speed, damping)
end
