--[[
	File: text.lua
	Creates a text label in the window
]]

-- < Packages >
local Packages = script.Parent.Parent.Parent.packages
local Fusion = require(Packages.fusion)

-- < Variables >
local Children = Fusion.Children
local New = Fusion.New

-- < Theme >
local Theme = require(script.Parent.Parent.Parent.storage.theme)

-- < Types >
type DivivderProps = {
	text: string,
}

-- < Component >
return function(props: DivivderProps)
	local Divider = New("ImageButton")({
		Name = "Frame",
		AutoButtonColor = false,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(35, 35, 35),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0.232),
		Size = UDim2.fromScale(1, -0.0317),

		[Children] = {
			New("UICorner")({
				CornerRadius = UDim.new(0, 6),
			}),

			New("UIPadding")({
				PaddingLeft = UDim.new(0, -13),
				PaddingRight = UDim.new(0, 2),
				PaddingTop = UDim.new(0, 5),
			}),

			New("Frame")({
				Name = "Holder",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(15, 0),
				Size = UDim2.new(1, -15, 1, 0),

				[Children] = {
					New("UIListLayout")({
						Padding = UDim.new(0, 8),
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),

					New("TextLabel")({
						FontFace = Font.new(
							"rbxassetid://12187365364",
							Enum.FontWeight.SemiBold,
							Enum.FontStyle.Normal
						),
						Text = props.text,
						TextColor3 = Theme.divider_text,
						TextSize = 15,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.0162, 0.0588),
						Size = UDim2.fromScale(1, 0),
						ZIndex = 3,

						[Children] = {
							New("UIPadding")({
								PaddingLeft = UDim.new(0, 2),
							}),
						},
					}),

					New("Frame")({
						BackgroundColor3 = Theme.divider_accent,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 1),
					}),
				},
			}),
		},
	})

	return Divider
end
