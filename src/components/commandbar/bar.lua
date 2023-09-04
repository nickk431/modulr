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

local Constants = require(Storage.constants)
local VERSION = Constants._VERSION
local BRANCH = Constants._BRANCH

-- < Variables >
local Children = Fusion.Children
local Observer = Fusion.Observer
local OnChange = Fusion.OnChange
local OnEvent = Fusion.OnEvent
local Ref = Fusion.Ref
local Value = Fusion.Value
local New = Fusion.New

-- < Component >
return function()
	local commandbarPos = Value(UDim2.new(0.5, 0, 0, 100))

	local textboxRef = Value()
	local commandbarRef = Value()
	local commandbarScale = Value(1)

	local openedStateObserver = Observer(States.CommandBarOpened)

	openedStateObserver:onChange(function()
		if unwrap(States.CommandBarOpened) then
			commandbarScale:set(1)
			commandbarPos:set(UDim2.new(0.5, 0, 0, 130))

			unwrap(textboxRef):CaptureFocus()
		end
	end)

	local CommandBar = New("CanvasGroup")({
		[Ref] = commandbarRef,

		Name = "CommandBar",
		GroupTransparency = animate(function()
			return unwrap(States.CommandBarOpened) and 0 or 1
		end, 30, 1.2),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Theme.bar_background,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = animate(function()
			return commandbarPos:get()
		end, 30, 1.2),
		Size = UDim2.fromOffset(517, 80),

		[Children] = {
			New("UIScale")({
				Scale = commandbarScale,
			}),

			New("UICorner")({
				Name = "UICorner",
				CornerRadius = UDim.new(0, 10),
			}),

			New("UIStroke")({
				Name = "UIStroke",
				Color = Theme.bar_accent,
				Thickness = 2,
				Transparency = 1,
			}),

			New("Frame")({
				Name = "Drag",
				BackgroundColor3 = Theme.bar_top,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 40),

				[Children] = {
					New("Frame")({
						Name = "Frame",
						AnchorPoint = Vector2.new(0, 1),
						BackgroundColor3 = Theme.bar_accent,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0, 1),
						Size = UDim2.new(1, 0, 0, 1),
					}),

					New("TextLabel")({
						Name = "TextLabel",
						FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
						Text = "Run",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 15,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 40),
						ZIndex = 3,

						[Children] = {
							New("UIPadding")({
								Name = "UIPadding",
								PaddingLeft = UDim.new(0, 15),
							}),
						},
					}),

					New("TextLabel")({
						Name = "TextLabel",
						FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
						Text = VERSION .. "-" .. BRANCH,
						TextColor3 = Color3.fromRGB(223, 223, 223),
						TextSize = 15,
						TextXAlignment = Enum.TextXAlignment.Right,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 40),
						ZIndex = 3,

						[Children] = {
							New("UIPadding")({
								Name = "UIPadding",
								PaddingRight = UDim.new(0, 15),
							}),
						},
					}),
				},
			}),

			New("TextLabel")({
				Name = "Prediction",
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
				LineHeight = 1.1,
				Text = States.PredictionText,
				TextColor3 = Color3.fromRGB(109, 109, 109),
				TextSize = 15,
				TextXAlignment = Enum.TextXAlignment.Left,
				Active = true,
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0, 1),
				Selectable = true,
				Size = UDim2.new(1, 0, 1, -40),

				[Children] = {
					New("UIPadding")({
						PaddingLeft = UDim.new(0, 35),
					}),

					New("ImageLabel")({
						Name = "Image",
						Image = "rbxassetid://14387211002",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.new(0, -15, 0.5, 0),
						Size = UDim2.fromOffset(16, 16),
						Visible = false,
						ZIndex = 7,
					}),
				},
			}),

			New("TextBox")({
				[Ref] = textboxRef,

				Name = "Input",
				CursorPosition = -1,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
				LineHeight = 1.1,
				PlaceholderText = "Enter command or search here...",
				PlaceholderColor3 = Color3.fromRGB(119, 119, 119),
				Text = "",
				TextColor3 = Color3.fromRGB(211, 211, 211),
				TextSize = 15,
				TextXAlignment = Enum.TextXAlignment.Left,
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, 0, 1, -40),

				[OnEvent("FocusLost")] = function()
					States.ToExecute:set(unwrap(textboxRef).Text)
					unwrap(textboxRef).Text = ""
					States.CommandBarOpened:set(false)

					commandbarPos:set(UDim2.new(0.5, 0, 0, 160))
					task.wait(0.2)
					commandbarScale:set(0)
					commandbarPos:set(UDim2.new(0.5, 0, 0, 100))
				end,

				[OnChange("Text")] = function()
					States.CommandBarText:set(unwrap(textboxRef).Text)
				end,

				[Children] = {
					New("UIPadding")({
						Name = "UIPadding",
						PaddingLeft = UDim.new(0, 35),
					}),

					New("ImageLabel")({
						Name = "Image",
						Image = "rbxassetid://14387211002",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.new(0, -15, 0.5, 0),
						Size = UDim2.fromOffset(16, 16),
						ZIndex = 7,
					}),
				},
			}),
		},
	})

	return CommandBar
end
