--[[
	File: scroll.lua
	Creates a input box in the window
]]

-- < Packages >
local Packages = script.Parent.Parent.Parent.packages
local Fusion = require(Packages.fusion)
local States = require(Packages.states)

-- < Variables >
local Children = Fusion.Children
local Value = Fusion.Value
local Ref = Fusion.Ref
local New = Fusion.New

-- < Component >
return function(name, children)
	local scrollRef = Value()

	local Scroll = New("ScrollingFrame")({
		[Ref] = scrollRef,

		Name = name,
		BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png",
		ScrollBarImageColor3 = Color3.fromRGB(134, 134, 134),
		ScrollBarThickness = 3,
		TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Position = UDim2.fromOffset(0, 55),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Selectable = false,
		Size = UDim2.new(1, 0, 1, -57),
		SelectionGroup = false,

		[Children] = {
			New("UIPadding")({
				Name = "UIPadding",
				PaddingBottom = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 12),
			}),

			New("UIListLayout")({
				Name = "UIListLayout",
				Padding = UDim.new(0, 10),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			children,
		},
	})

	States.add("ScrollingFrames", Scroll, name)

	return Scroll
end
