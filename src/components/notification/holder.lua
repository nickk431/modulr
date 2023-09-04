--[[
	File: holder.lua
	Creates the holder for the notifications
]]

-- < Packages >
local Packages = script.Parent.Parent.Parent.packages
local Fusion = require(Packages.fusion)
local States = require(Packages.states)

-- < Variables >
local Children = Fusion.Children
local ForPairs = Fusion.ForPairs
local New = Fusion.New

-- < Component >
return function()
	return New("Frame")({
		AnchorPoint = Vector2.new(1, 1),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(1, 1),
		Size = UDim2.fromOffset(255, 100),

		[Children] = {
			New("UIListLayout")({
				Padding = UDim.new(0, 10),
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
			}),

			New("UIPadding")({
				PaddingBottom = UDim.new(0, 15),
				PaddingRight = UDim.new(0, 15),
			}),

			ForPairs(States.Notifications, function(index, value)
				return index, value
			end, Fusion.cleanup),
		},
	})
end
