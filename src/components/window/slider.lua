-- < Services >
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- < Utils >
local Utils = script.Parent.Parent.Parent.utils
local animate = require(Utils.animate)
local colorUtils = require(Utils.color3)
local safeCallback = require(Utils.safecallback)
local unwrap = require(Utils.unwrap)

-- < Packages >
local Packages = script.Parent.Parent.Parent.packages
local Fusion = require(Packages.fusion)
local States = require(Packages.states)

-- < Variables >
local Children = Fusion.Children
local Computed = Fusion.Computed
local Observer = Fusion.Observer
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local Ref = Fusion.Ref
local New = Fusion.New

local floor = math.floor
local min = math.min
local max = math.max

-- < Theme >
local Theme = require(script.Parent.Parent.Parent.storage.theme)

-- < Types >
type ButtonProps = {
	text: string,
	subtext: string?,
	initialValue: boolean?,
	min: number,
	max: number,
	callback: (...any) -> ...any?,
}

-- < Component >
return function(props: ButtonProps)
	local isHovering = Value(false)
	local isHeldDown = Value(false)

	local barRef = Value()
	local grabRef = Value()

	local mouse = Players.LocalPlayer:GetMouse()
	local grabPosition = Value(UDim2.fromScale(0, 0.5))
	local isGrabbing = Value(false)

	local numberValue = Value(props.min)
	local numberObserver = Observer(numberValue)

	local barSize = Value(UDim2.fromOffset(0, 5))

	numberObserver:onChange(function()
		safeCallback(function()
			props.callback(unwrap(numberValue))
		end)
	end)

	local Button = New("ImageButton")({
		Name = "Frame",
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = animate(function()
			if unwrap(isHovering) and not unwrap(isHeldDown) then
				return colorUtils.lightenRGB(unwrap(Theme.button_background), 5)
			end

			if unwrap(isHeldDown) then
				return colorUtils.lightenRGB(unwrap(Theme.button_background), 10)
			end

			return unwrap(Theme.button_background)
		end, 20, 1),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0.145),
		Size = animate(function()
			if unwrap(isHovering) and not unwrap(isHeldDown) then
				return UDim2.new(1, -6, 0, 0)
			end

			if unwrap(isHeldDown) then
				return UDim2.new(1, -12, 0, 0)
			end

			return UDim2.new(1, 0, 0, 0)
		end, 40, 1),

		[OnEvent("Activated")] = function() end,

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
								Padding = UDim.new(0, 15),
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Right,
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Center,
							}),

							New("Frame")({
								[Ref] = barRef,

								Name = "Slider",
								BackgroundColor3 = Theme.slider_background,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Size = UDim2.fromOffset(150, 5),

								[Children] = {
									New("UICorner")({
										Name = "UICorner",
										CornerRadius = UDim.new(0, 7),
									}),

									New("Frame")({
										Name = "Bar",
										BackgroundColor3 = Theme.slider_rail,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										Size = Computed(function()
											return unwrap(barSize)
										end),

										[Children] = {
											New("UICorner")({
												Name = "UICorner",
												CornerRadius = UDim.new(0, 7),
											}),
										},
									}),

									New("ImageButton")({
										[Ref] = grabRef,

										Name = "Grab",
										AnchorPoint = Vector2.new(0, 0.5),
										BackgroundColor3 = Theme.slider_grab,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										Position = animate(function()
											return unwrap(grabPosition)
										end, 25, 1),

										Size = UDim2.fromOffset(13, 13),

										[OnEvent("InputBegan")] = function(inputObject)
											if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
												isGrabbing:set(true)
											end
										end,

										[OnEvent("InputEnded")] = function(inputObject)
											if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
												isGrabbing:set(false)
											end
										end,

										[Children] = {
											New("UICorner")({
												Name = "UICorner",
												CornerRadius = UDim.new(1, 0),
											}),
										},
									}),
								},
							}),

							New("Frame")({
								Name = "Value",
								AutomaticSize = Enum.AutomaticSize.X,
								BackgroundColor3 = animate(function()
									if unwrap(isHovering) and not unwrap(isHeldDown) then
										if unwrap(States.Theme) == "dark" then
											return colorUtils.lightenRGB(Color3.fromRGB(40, 40, 40), 5)
										end
									end

									if unwrap(isHeldDown) then
										if unwrap(States.Theme) == "dark" then
											return colorUtils.lightenRGB(Color3.fromRGB(40, 40, 40), 10)
										end
									end

									return unwrap(Theme.slider_box)
								end, 40, 1),
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Size = UDim2.fromOffset(30, 30),

								[Children] = {
									New("UICorner")({
										Name = "UICorner",
										CornerRadius = UDim.new(0, 7),
									}),

									New("TextLabel")({
										Name = "Label",
										FontFace = Font.new(
											"rbxassetid://12187365364",
											Enum.FontWeight.Medium,
											Enum.FontStyle.Normal
										),
										Text = Computed(function()
											return unwrap(numberValue)
										end),
										TextColor3 = Color3.fromRGB(223, 223, 223),
										TextSize = 15,
										TextWrapped = true,
										AutomaticSize = Enum.AutomaticSize.X,
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										BackgroundTransparency = 1,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										Size = UDim2.fromScale(1, 1),
										ZIndex = 3,

										[Children] = {
											New("UIPadding")({
												Name = "UIPadding",
												PaddingLeft = UDim.new(0, 5),
												PaddingRight = UDim.new(0, 5),
											}),
										},
									}),
								},
							}),
						},
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

	RunService.RenderStepped:Connect(function()
		if not unwrap(isGrabbing) then
			return
		end

		local bar = unwrap(barRef)
		local grab = unwrap(grabRef)

		local absPosition = bar.AbsolutePosition.X
		local absSize = bar.AbsoluteSize.X
		local mouseDelta = min(max(0, mouse.X - absPosition), absSize)

		numberValue:set(floor(props.min + ((mouseDelta / absSize) * (props.max - props.min))))

		grabPosition:set(
			UDim2.new(
				(mouseDelta / absSize) - 0.05,
				grab.Position.X.Offset,
				grab.Position.Y.Scale,
				grab.Position.Y.Offset
			)
		)

		barSize:set(UDim2.new(0, (grab.AbsolutePosition.X - bar.AbsolutePosition.X) + 5, 0, 5))
	end)

	return Button
end
