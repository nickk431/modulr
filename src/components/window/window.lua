-- < Utils >
local Utils = script.Parent.Parent.Parent.utils
local animate = require(Utils.animate)
local colorUtils = require(Utils.color3)
local unwrap = require(Utils.unwrap)

-- < Packages >
local Packages = script.Parent.Parent.Parent.packages
local Fusion = require(Packages.fusion)
local Snapdragon = require(Packages.snapdragon)
local States = require(Packages.states)

-- < Components >
local Scroll = require(script.Parent.scroll)

-- < Variables >
local Children = Fusion.Children
local Computed = Fusion.Computed
local ForPairs = Fusion.ForPairs
local Observer = Fusion.Observer
local OnChange = Fusion.OnChange
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local Tween = Fusion.Tween
local Ref = Fusion.Ref
local New = Fusion.New

-- < Theme >
local Theme = require(script.Parent.Parent.Parent.storage.theme)

-- < Types >
type WindowProps = {
	title: string,
	size: UDim2,
}

return function(props: WindowProps, components)
	-- < Window objects >
	local ScaleObject = Value()
	local Dragbar = Value()
	local WindowObject = Value()

	-- < Window States >
	local openedState = Value(false)
	local pageLayout = Value()
	local toDestroy = Value()

	-- < Window drag >
	local isDragging = Value(false)
	local isHolding = Value(false)

	-- < Back button >
	local BackHovering = Value(false)
	local BackHeldDown = Value(false)

	-- < Exit button >
	local ExitHovering = Value(false)
	local ExitHeldDown = Value(false)

	-- < Exit states >
	local exitState = Value(false)
	local exitObserver = Observer(exitState)

	States.add("Backbuttons", Value(false), props.title)

	local componentHolder = Scroll(props.title, {
		ForPairs(components, function(index, value)
			return index, value
		end, Fusion.cleanup),
	})

	-- < Component >
	local Window = New("CanvasGroup")({
		[Ref] = WindowObject,

		Name = props.title,
		BackgroundColor3 = Theme.window_background,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		GroupTransparency = animate(function()
			if unwrap(openedState) then
				return 0
			end

			return 1
		end, 30, 1),
		Size = props.size,

		[Children] = {
			New("UICorner")({
				Name = "UICorner",
				CornerRadius = UDim.new(0, 6),
			}),

			New("UIStroke")({
				Name = "UIStroke",
				Color = Theme.window_border,
				Thickness = 2,
				Transparency = animate(function()
					if unwrap(openedState) then
						return 0.7
					end

					return 1
				end, 20, 1),
			}),

			New("ImageButton")({
				[Ref] = Dragbar,

				Name = "Drag",
				BackgroundColor3 = Theme.window_drag,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				ImageTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 17),

				[OnEvent("MouseEnter")] = function()
					isDragging:set(true)
				end,

				[OnEvent("MouseLeave")] = function()
					isDragging:set(false)
				end,

				[OnEvent("MouseButton1Down")] = function()
					isHolding:set(true)
				end,

				[OnEvent("MouseButton1Up")] = function()
					isHolding:set(false)
				end,

				[Children] = {
					New("Frame")({
						Name = "Frame",
						AnchorPoint = Vector2.new(0, 1),
						BackgroundColor3 = Theme.window_accents,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0, 1),
						Size = UDim2.new(1, 0, 0, 1),
					}),

					New("Frame")({
						Name = "Frame",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = animate(function()
							if unwrap(isDragging) and not unwrap(isHolding) then
								return colorUtils.lightenRGB(unwrap(Theme.window_drag_bar), 30)
							end

							if unwrap(isHolding) and unwrap(isDragging) then
								return colorUtils.darkenRGB(unwrap(Theme.window_drag_bar), 15)
							end

							return unwrap(Theme.window_drag_bar)
						end, 20, 0.6),

						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.5, 0.5),
						Size = animate(function()
							local isHoldingState = unwrap(isHolding)
							local isDraggingState = unwrap(isDragging)

							if isDraggingState and not isHoldingState then
								return UDim2.new(0.2, 15, 1, -15)
							end

							if isHoldingState and unwrap(isDragging) then
								return UDim2.new(0.2, -5, 1, -15)
							end

							return UDim2.new(0.2, 0, 1, -15)
						end, 30, 1.2),

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
				Name = "ScrollHolder",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(0, 57),
				Size = UDim2.new(1, 0, 1, 0),

				[Children] = {
					New("UIPageLayout")({
						[Ref] = pageLayout,

						Name = "UIPageLayout",
						EasingStyle = Enum.EasingStyle.Cubic,
						TweenTime = 0.3,
						SortOrder = Enum.SortOrder.LayoutOrder,

						[OnChange("CurrentPage")] = function(object)
							if object.Name ~= props.title then
								toDestroy:set(object)
							end
						end,
					}),

					componentHolder,
				},
			}),

			New("Frame")({
				Name = "Topbar",
				BackgroundColor3 = Theme.window_topbar,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = -1,
				Position = UDim2.fromOffset(0, 17),
				Size = UDim2.new(1, 0, 0, 40),

				[Children] = {
					New("Frame")({
						Name = "Frame",
						AnchorPoint = Vector2.new(0, 1),
						BackgroundColor3 = Theme.window_accents,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0, 1),
						Size = UDim2.new(1, 0, 0, 1),
					}),

					New("Frame")({
						Name = "Holder",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0, 0.5),
						Size = UDim2.fromScale(1, 0),

						[Children] = {
							New("TextLabel")({
								Name = "TextLabel",
								FontFace = Font.new(
									"rbxassetid://12187365364",
									Enum.FontWeight.Bold,
									Enum.FontStyle.Normal
								),
								LineHeight = 1.2,
								Text = props.title,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextColor3 = Theme.window_text,
								TextSize = 16,
								AutomaticSize = Enum.AutomaticSize.X,
								AnchorPoint = Vector2.new(0.5, 0),
								Position = UDim2.new(0.5, 0, 0, 0),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Size = UDim2.fromScale(0, 0),
								ZIndex = 3,
							}),
						},
					}),

					New("Frame")({
						Name = "Back",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = animate(function()
							local isOpen = unwrap(States.Backbuttons)[props.title]:get()

							if not isOpen then
								return UDim2.new(0, -35, 0.5, 0)
							end

							return UDim2.fromScale(0, 0.5)
						end, 20, 0.7),
						Size = UDim2.fromScale(1, 1),

						[Children] = {
							New("UIListLayout")({
								Name = "UIListLayout",
								Padding = UDim.new(0, 5),
								FillDirection = Enum.FillDirection.Horizontal,
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Center,
							}),

							New("UIPadding")({
								Name = "UIPadding",
								PaddingLeft = UDim.new(0, 4),
							}),

							New("ImageButton")({
								Name = "Button",
								AutoButtonColor = false,
								Active = false,
								BackgroundColor3 = animate(function()
									if unwrap(BackHovering) and not unwrap(BackHeldDown) then
										return colorUtils.lightenRGB(unwrap(Theme.window_exit), 5)
									end

									if unwrap(BackHeldDown) then
										return colorUtils.lightenRGB(unwrap(Theme.window_exit), 10)
									end

									return unwrap(Theme.window_topbar) -- im sorry... i was lazy.
								end, 20, 1),
								BorderSizePixel = 0,
								LayoutOrder = 2,
								Position = UDim2.fromScale(0, -9.42e-08),
								Selectable = false,
								Size = UDim2.fromOffset(30, 30),

								[OnEvent("MouseButton1Down")] = function()
									BackHeldDown:set(true)
								end,

								[OnEvent("MouseButton1Up")] = function()
									BackHeldDown:set(false)
								end,

								[OnEvent("MouseEnter")] = function()
									BackHovering:set(true)
								end,

								[OnEvent("MouseLeave")] = function()
									BackHovering:set(false)
									BackHeldDown:set(false)
								end,

								[OnEvent("MouseButton1Click")] = function()
									unwrap(States.UILayouts)[props.title]:get():JumpTo(componentHolder)
									unwrap(States.Backbuttons)[props.title]:set(false)

									task.delay(0.23, function()
										unwrap(toDestroy).Visible = false
									end)
								end,

								[Children] = {
									New("UICorner")({
										Name = "UICorner",
										CornerRadius = UDim.new(0, 4),
									}),

									New("ImageLabel")({
										Name = "Image",
										Image = "rbxassetid://14365509058",
										ImageColor3 = Theme.button_arrow,
										AnchorPoint = Vector2.new(0.5, 0.5),
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										BackgroundTransparency = 1,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										Position = animate(function()
											if unwrap(BackHovering) and not unwrap(BackHeldDown) then
												return UDim2.new(0.5, 3, 0.5, 0)
											end

											if unwrap(BackHeldDown) then
												return UDim2.new(0.5, -3, 0.5, 0)
											end

											return UDim2.new(0.5, 0, 0.5, 0)
										end, 20, 0.8),
										Size = UDim2.fromOffset(16, 16),
										ZIndex = 7,
									}),

									New("UIScale")({
										Name = "UIScale",
									}),
								},
							}),
						},
					}),

					New("Frame")({
						Name = "Holder",
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0, 0.5),
						Size = UDim2.fromScale(1, 1),

						[Children] = {
							New("UIPadding")({
								Name = "UIPadding",
								PaddingRight = UDim.new(0, 4),
							}),

							New("ImageButton")({
								Name = "Button",
								AutoButtonColor = false,
								Active = false,
								BackgroundColor3 = animate(function()
									local exitTheme = unwrap(Theme.window_exit)

									if unwrap(ExitHovering) and not unwrap(ExitHeldDown) then
										return colorUtils.lightenRGB(exitTheme, 5)
									end

									if unwrap(ExitHeldDown) then
										return colorUtils.lightenRGB(exitTheme, 10)
									end

									return unwrap(Theme.window_topbar)
								end, 20, 1),
								BorderSizePixel = 0,
								LayoutOrder = 2,
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.new(1, -15, 0, 19),
								Selectable = false,
								Size = UDim2.fromOffset(30, 30),

								[OnEvent("MouseButton1Down")] = function()
									ExitHeldDown:set(true)
								end,

								[OnEvent("MouseButton1Up")] = function()
									ExitHeldDown:set(false)
								end,

								[OnEvent("MouseEnter")] = function()
									ExitHovering:set(true)
								end,

								[OnEvent("MouseLeave")] = function()
									ExitHovering:set(false)
									ExitHeldDown:set(false)
								end,

								[OnEvent("MouseButton1Click")] = function()
									openedState:set(false)

									task.delay(1.2, function()
										exitState:set(true)
									end)
								end,

								[Children] = {
									New("UICorner")({
										Name = "UICorner",
										CornerRadius = UDim.new(0, 4),
									}),

									New("ImageLabel")({
										Name = "Image",
										Image = "rbxassetid://14365500265",
										ImageColor3 = Theme.window_exit_icon,
										AnchorPoint = Vector2.new(0.5, 0.5),
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										BackgroundTransparency = 1,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										Position = UDim2.fromScale(0.5, 0.5),
										Size = UDim2.fromOffset(16, 16),
										ZIndex = 7,
									}),

									New("UIScale")({
										Name = "UIScale",
										Scale = 1,
									}),
								},
							}),
						},
					}),
				},
			}),

			New("UIScale")({
				[Ref] = ScaleObject,

				Name = "UIScale",
				Scale = Tween(
					Computed(function()
						if unwrap(openedState) then
							return 1
						end

						return 0.9
					end),
					TweenInfo.new(0.15, Enum.EasingStyle.Sine)
				),
			}),
		},
	})

	-- < Window global states >
	States.add("Objects", Window, props.title)
	States.add("UILayouts", pageLayout, props.title)

	-- < Window dragging >
	Snapdragon.createDragController(unwrap(Dragbar), {
		DragGui = unwrap(WindowObject), -- Tells this controller that it's dragging the window, not the titlebar
		SnapEnabled = true,
	}):Connect()

	-- < Window open / close >
	openedState:set(true)

	exitObserver:onChange(function()
		if unwrap(exitState) then
			Window:Destroy()
		end
	end)

	return Window
end
