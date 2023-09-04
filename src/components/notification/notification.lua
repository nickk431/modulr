--[[
	File: button.lua
	Creates a button in the window
]]

-- < Services >
local HttpService = game:GetService("HttpService")

-- < Utils >
local Utils = script.Parent.Parent.Parent.utils
local animate = require(Utils.animate)
local unwrap = require(Utils.unwrap)

-- < Packages >
local Packages = script.Parent.Parent.Parent.packages
local Fusion = require(Packages.fusion)
local States = require(Packages.states)

-- < Variables >
local Children = Fusion.Children
local Computed = Fusion.Computed
local Value = Fusion.Value
local Ref = Fusion.Ref
local New = Fusion.New

local NOTIFICATION_TYPES = {
	success = {
		color = Color3.fromRGB(27, 227, 142),
		icon = "rbxassetid://14215830193",
	},

	error = {
		color = Color3.fromRGB(255, 85, 88),
		icon = "rbxassetid://14332744109",
	},

	warning = {
		color = Color3.fromRGB(255, 236, 92),
		icon = "rbxassetid://14332737076",
	},

	info = {
		color = Color3.fromRGB(133, 198, 255),
		icon = "rbxassetid://14332737195",
	},
}

-- < Theme >
local Theme = require(script.Parent.Parent.Parent.storage.theme)

-- < Types >
type ButtonProps = {
	title: string,
	description: string?,
	type: "success" | "error" | "warning" | "info",
	duration: number,
}

-- < Component >
return function(props: ButtonProps)
	local currentPosition = Value(UDim2.new(1, 15, 0, 0))
	local currentSize = Value(UDim2.new(0, 0, 0, 0))
	local durationSize = Value(UDim2.new(1, 15, 0, 3))

	local notificationRef = Value()

	local typeColor = NOTIFICATION_TYPES[props.type].color or NOTIFICATION_TYPES.info.color
	local typeIcon = NOTIFICATION_TYPES[props.type].icon or NOTIFICATION_TYPES.info.icon

	-- < Component >
	local Notification = New("Frame")({
		Name = "Notification",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = animate(function()
			return unwrap(currentSize)
		end, 20, 1.2),

		[Children] = {
			New("CanvasGroup")({
				[Ref] = notificationRef,

				Name = "Object",
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Theme.notif_background,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = animate(function()
					return unwrap(currentPosition)
				end, 30, 1.2),
				Size = UDim2.fromOffset(254, 0),

				[Children] = {
					New("UICorner")({}),

					New("Frame")({
						Name = "Holder",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromOffset(60, 0),
						Size = UDim2.new(1, -60, 1, 0),

						[Children] = {
							New("UIListLayout")({
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								Padding = UDim.new(0, 3),
							}),

							New("TextLabel")({
								FontFace = Font.new(
									"rbxassetid://12187365364",
									Enum.FontWeight.Bold,
									Enum.FontStyle.Normal
								),
								Text = props.title,
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextSize = 16,
								TextXAlignment = Enum.TextXAlignment.Left,
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundColor3 = Color3.fromRGB(30, 30, 30),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Size = UDim2.fromScale(1, 0),
								ZIndex = 3,
							}),

							New("TextLabel")({
								FontFace = Font.new(
									"rbxassetid://12187365364",
									Enum.FontWeight.Medium,
									Enum.FontStyle.Normal
								),
								RichText = true,
								Text = props.description,
								TextColor3 = Color3.fromRGB(204, 204, 204),
								TextSize = 14,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Size = UDim2.fromScale(1, 0),
								ZIndex = 3,

								[Children] = {
									New("UIPadding")({
										PaddingBottom = UDim.new(0, 3),
									}),
								},
							}),
						},
					}),

					New("Frame")({
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = Theme.notif_circle,
						BackgroundTransparency = 0.3,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 20, 0.5, 0),
						Size = UDim2.fromOffset(30, 30),

						[Children] = {
							New("UICorner")({
								CornerRadius = UDim.new(1, 0),
							}),

							New("ImageLabel")({
								Name = "Frame",
								Image = typeIcon,
								ImageColor3 = typeColor,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(67, 76, 88),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromOffset(20, 20),

								[Children] = {
									New("UICorner")({
										CornerRadius = UDim.new(1, 0),
									}),
								},
							}),
						},
					}),

					New("UIPadding")({
						PaddingBottom = UDim.new(0, 15),
						PaddingRight = UDim.new(0, 15),
						PaddingTop = UDim.new(0, 15),
					}),

					New("UIStroke")({
						Color = Color3.fromRGB(50, 50, 50),
						Thickness = 2,
						Transparency = 0.7,
					}),

					New("Frame")({
						AnchorPoint = Vector2.new(0, 1),
						BackgroundColor3 = typeColor,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 0, 1, 15),
						Size = Fusion.Tween(
							Computed(function()
								return unwrap(durationSize)
							end),
							TweenInfo.new(props.duration, Enum.EasingStyle.Linear)
						),
					}),
				},
			}),
		},
	})

	States.add("Notifications", Notification, HttpService:GenerateGUID())

	task.wait(0.1)

	task.spawn(function()
		currentSize:set(UDim2.fromOffset(255, unwrap(notificationRef).AbsoluteSize.Y))

		task.delay(0.2, function()
			currentPosition:set(UDim2.fromScale(0, 0))
			durationSize:set(UDim2.new(0, 0, 0, 3))

			task.wait(props.duration)

			currentPosition:set(UDim2.new(1, 20, 0, 0))

			task.wait(0.3)

			currentSize:set(UDim2.fromOffset(255, 0))

			task.wait(0.5)

			Notification:Destroy()
		end)
	end)

	return Notification
end
