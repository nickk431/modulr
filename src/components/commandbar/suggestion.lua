--[[
	File: suggestion.lua
	Creates a suggestion in the command bar
]]

-- < Constants >
local ARGUMENT_TYPES = {
	string = {
		color = Color3.fromRGB(255, 255, 255),
		icon = "rbxassetid://14080619136",
	},

	boolean = {
		color = Color3.fromRGB(231, 255, 74),
		icon = "rbxassetid://14080668232",
	},

	instance = {
		color = Color3.fromRGB(175, 78, 255),
		icon = "rbxassetid://14080695268",
	},

	player = {
		color = Color3.fromRGB(111, 169, 255),
		icon = "rbxassetid://14078781674",
	},

	number = {
		color = Color3.fromRGB(116, 255, 144),
		icon = "rbxassetid://14080652058",
	},
}

-- < Packages >
local Packages = script.Parent.Parent.Parent.packages
local Fusion = require(Packages.fusion)

-- < Storage >
local Storage = script.Parent.Parent.Parent.storage
local Theme = require(Storage.theme)

-- < Variables >
local Children = Fusion.Children
local ForPairs = Fusion.ForPairs
local Computed = Fusion.Computed
local New = Fusion.New

-- < Component >
return function(props)
	local Suggestion = New("Frame")({
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Theme.suggestion_top,
		BackgroundTransparency = Computed(function()
			return props.top and 0 or 0.7
		end),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 60),

		[Children] = {
			New("UIPadding")({
				PaddingBottom = UDim.new(0, 13),
				PaddingLeft = UDim.new(0, 13),
				PaddingRight = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 10),
			}),

			New("UIListLayout")({
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			New("TextLabel")({
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
				Text = props.name,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 15,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = -1,
				Position = UDim2.fromScale(0.0162, 0.0588),
				Size = UDim2.fromScale(1, 0),
				ZIndex = 3,

				[Children] = {
					New("Frame")({
						Name = "Holder",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 15, 0.5, 8),
						Size = UDim2.new(1, -15, 0, 0),

						[Children] = {
							ForPairs(props.types, function(index, value)
								return index,
									New("Frame")({
										Name = "Type",
										AutomaticSize = Enum.AutomaticSize.X,
										BackgroundColor3 = ARGUMENT_TYPES[value.type].color,
										BackgroundTransparency = 0.75,
										BorderSizePixel = 0,
										LayoutOrder = 1,
										Position = UDim2.fromOffset(340, 4),
										Size = UDim2.fromOffset(0, 25),

										[Children] = {
											New("ImageLabel")({
												Name = "Image",
												Image = ARGUMENT_TYPES[value.type].icon,
												ImageColor3 = ARGUMENT_TYPES[value.type].color,
												AnchorPoint = Vector2.new(0.5, 0.5),
												BackgroundColor3 = Color3.fromRGB(255, 255, 255),
												BackgroundTransparency = 1,
												BorderColor3 = Color3.fromRGB(0, 0, 0),
												BorderSizePixel = 0,
												Position = UDim2.new(0, 18, 0.5, 0),
												Size = UDim2.fromOffset(14, 14),
												ZIndex = 7,
											}),

											New("UIPadding")({
												PaddingLeft = UDim.new(0, 9),
												PaddingRight = UDim.new(0, 9),
												PaddingTop = UDim.new(0, 1),
											}),

											New("UICorner")({
												CornerRadius = UDim.new(0, 6),
											}),

											New("TextLabel")({
												Name = "Title",
												FontFace = Font.new(
													"rbxassetid://12187365364",
													Enum.FontWeight.SemiBold,
													Enum.FontStyle.Normal
												),
												Text = string.upper(value.name),
												TextColor3 = ARGUMENT_TYPES[value.type].color,
												TextSize = 12,
												AnchorPoint = Vector2.new(1, 0),
												AutomaticSize = Enum.AutomaticSize.X,
												BackgroundColor3 = Color3.fromRGB(255, 255, 255),
												BackgroundTransparency = 1,
												BorderSizePixel = 0,
												LayoutOrder = 1,
												Position = UDim2.new(0.302, 0, -1.98, 54),
												Size = UDim2.fromOffset(25, 25),
												ZIndex = 5,
											}),

											New("UIListLayout")({
												Padding = UDim.new(0, 5),
												FillDirection = Enum.FillDirection.Horizontal,
												SortOrder = Enum.SortOrder.LayoutOrder,
												VerticalAlignment = Enum.VerticalAlignment.Center,
											}),
										},
									})
							end, Fusion.cleanup),

							New("UIPadding")({
								PaddingRight = UDim.new(0, 5),
							}),

							New("UIListLayout")({
								Padding = UDim.new(0, 10),
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Right,
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Center,
							}),
						},
					}),
				},
			}),

			New("TextLabel")({
				FontFace = Font.new("rbxassetid://12187365364"),
				Text = props.description,
				TextColor3 = Color3.fromRGB(204, 204, 204),
				TextSize = 15,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0, 0.424),
				Size = UDim2.fromScale(1, 0),
				ZIndex = 3,
			}),

			New("UICorner")({
				CornerRadius = UDim.new(0, 6),
			}),
		},
	})

	return Suggestion
end
