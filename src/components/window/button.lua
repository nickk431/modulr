--[[
	File: button.lua
	Creates a button in the window
]]

-- < Utils >
local Utils = script.Parent.Parent.Parent.utils
local animate = require(Utils.animate)
local colorUtils = require(Utils.color3)
local safeCallback = require(Utils.safecallback)
local unwrap = require(Utils.unwrap)

-- < Packages >
local Packages = script.Parent.Parent.Parent.packages
local Fusion = require(Packages.fusion)

-- < Variables >
local Children = Fusion.Children
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local New = Fusion.New

-- < Theme >
local Theme = require(script.Parent.Parent.Parent.storage.theme)

-- < Types >
type ButtonProps = {
	text: string,
	subtext: string?,
	initialValue: boolean?,
	clickable: boolean?,
	callback: ((...any) -> ...any)?,
}

-- < Component >
return function(props: ButtonProps)
	local isHovering = Value(false)
	local isHeldDown = Value(false)

	if props.clickable == nil then
		props.clickable = true
	end

	local Button = New("ImageButton")({
		Name = "Frame",
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = animate(function()
			if props.clickable then
				if unwrap(isHovering) and not unwrap(isHeldDown) then
					return colorUtils.lightenRGB(unwrap(Theme.button_background), 5)
				end

				if unwrap(isHeldDown) then
					return colorUtils.lightenRGB(unwrap(Theme.button_background), 10)
				end
			end

			return unwrap(Theme.button_background)
		end, 40, 1),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0.145),
		Size = animate(function()
			if props.clickable then
				if unwrap(isHovering) and not unwrap(isHeldDown) then
					return UDim2.new(1, -6, 0, 0)
				end

				if unwrap(isHeldDown) then
					return UDim2.new(1, -12, 0, 0)
				end
			end

			return UDim2.new(1, 0, 0, 0)
		end, 40, 1),

		[OnEvent("Activated")] = function()
			safeCallback(props.callback or function() end)

			return
		end,

		[OnEvent("MouseButton1Down")] = function()
			isHeldDown:set(true)
		end,

		[OnEvent("MouseButton1Up")] = function()
			isHeldDown:set(false)
		end,

		[OnEvent("MouseEnter")] = function()
			isHovering:set(true)
		end,

		[OnEvent("MouseLeave")] = function()
			isHovering:set(false)
			isHeldDown:set(false)
		end,

		[Children] = {
			New("UICorner")({
				Name = "UICorner",
				CornerRadius = UDim.new(0, 6),
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
						Name = "UIListLayout",
						Padding = UDim.new(0, 10),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),
				},
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
						Name = "UIListLayout",
						Padding = UDim.new(0, 3),
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),

					New("TextLabel")({
						Name = "TextLabel",
						FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
						Text = props.text,
						TextColor3 = Theme.button_text,
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
					}),

					Computed(function()
						if props.subtext then
							return New("TextLabel")({
								Name = "TextLabel",
								FontFace = Font.new("rbxassetid://12187365364"),
								Text = props.subtext,
								RichText = true,
								TextColor3 = Theme.button_subtext,
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
							})
						end

						return
					end, Fusion.cleanup),
				},
			}),

			New("UIPadding")({
				Name = "UIPadding",
				PaddingBottom = UDim.new(0, 15),
				PaddingRight = UDim.new(0, 15),
				PaddingTop = UDim.new(0, 15),
			}),
		},
	})

	return Button
end
