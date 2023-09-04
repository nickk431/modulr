--[[
	File: button.lua
	Creates a button in the window
]]

-- < Utils >
local Utils = script.Parent.Parent.Parent.utils
local animate = require(Utils.animate)
local unwrap = require(Utils.unwrap)

-- < Packages >
local Packages = script.Parent.Parent.Parent.packages
local Fusion = require(Packages.fusion)
local States = require(Packages.states)

-- < Storage >
local Storage = script.Parent.Parent.Parent.storage
local Theme = require(Storage.theme)

-- < Variables >
local Children = Fusion.Children
local ForPairs = Fusion.ForPairs
local Value = Fusion.Value
local Ref = Fusion.Ref
local New = Fusion.New

-- < Component >
return function()
	local suggestionsSize = Value(0)
	local suggestionsRef = Value()
	local sizingRef = Value()

	local Suggestions = New("CanvasGroup")({
		[Ref] = suggestionsRef,

		Name = "Frame",
		GroupTransparency = animate(function()
			if #unwrap(States.Suggestions) <= 0 then
				return 1
			end

			if unwrap(States.CommandBarOpened) and #unwrap(States.CommandBarText) > 1 then
				return 0.03
			else
				return 1
			end
		end, 45, 1.2),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Theme.suggestion_back,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = animate(function()
			if #unwrap(States.Suggestions) <= 0 then
				return UDim2.new(0.5, 0, 0, 200)
			end

			if unwrap(States.CommandBarOpened) and #unwrap(States.CommandBarText) > 1 then
				return UDim2.new(0.5, 0, 0, 180)
			else
				return UDim2.new(0.5, 0, 0, 200)
			end
		end, 45, 1.2),
		Size = animate(function()
			return UDim2.fromOffset(517, math.clamp(unwrap(suggestionsSize), 75, 1000))
		end, 35, 1.2),
		Visible = true,

		[Children] = {
			New("UICorner")({
				Name = "UICorner",
				CornerRadius = UDim.new(0, 10),
			}),

			New("UIStroke")({
				Name = "UIStroke",
				Color = Color3.fromRGB(50, 50, 50),
				Thickness = 2,
				Transparency = 1,
			}),

			New("Frame")({
				Name = "Holder",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),

				[Children] = {
					New("Frame")({
						[Ref] = sizingRef,

						Name = "Sizing",
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Size = UDim2.fromScale(1, 0),

						[Children] = {
							New("UIPadding")({
								PaddingBottom = UDim.new(0, 8),
								PaddingLeft = UDim.new(0, 8),
								PaddingRight = UDim.new(0, 8),
								PaddingTop = UDim.new(0, 8),
							}),

							New("UIListLayout")({
								Padding = UDim.new(0, 8),
								SortOrder = Enum.SortOrder.LayoutOrder,
							}),

							ForPairs(States.Suggestions, function(index, value)
								return index, value
							end, Fusion.cleanup),
						},
					}),
				},
			}),
		},
	})

	unwrap(sizingRef):GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		suggestionsSize:set(unwrap(sizingRef).AbsoluteSize.Y)
	end)

	return Suggestions
end
