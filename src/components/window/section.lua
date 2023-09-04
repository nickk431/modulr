--[[
	File: section.lua
	Creates a section in the window
]]

-- < Utils >
local Utils = script.Parent.Parent.Parent.utils
local animate = require(Utils.animate)
local colorUtils = require(Utils.color3)
local unwrap = require(Utils.unwrap)

-- < Packages >
local Packages = script.Parent.Parent.Parent.packages
local Fusion = require(Packages.fusion)
local States = require(Packages.states)

-- < Components >
local Scroll = require(script.Parent.scroll)

-- < Variables >
local Children = Fusion.Children
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local Ref = Fusion.Ref
local New = Fusion.New

-- < Theme >
local Theme = require(script.Parent.Parent.Parent.storage.theme)

-- < Types >
type SectionProps = {
	text: string,
	subtext: string?,
	newPage: { Instance }?,
}

-- < Component >
return function(props: SectionProps)
	local buttonRef = Value()

	local isHovering = Value(false)
	local isHeldDown = Value(false)

	local Button = New("ImageButton")({
		[Ref] = buttonRef,

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
		end, 40, 1),
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

		[OnEvent("Activated")] = function()
			local windowObject = unwrap(buttonRef).Parent
			local windowName = windowObject.Name
			local newScroll = Scroll(props.text, props.newPage)

			Fusion.Hydrate(windowObject.Parent)({
				[Children] = {
					newScroll,
				},
			})

			unwrap(States.Backbuttons)[windowName]:set(true)
			unwrap(States.UILayouts)[windowName]:get():JumpTo(newScroll)
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
					New("ImageLabel")({
						Name = "Frame",
						Image = "rbxassetid://14366752255",
						AnchorPoint = Vector2.new(1, 0.5),
						BackgroundColor3 = Color3.fromRGB(67, 76, 88),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.new(1, 0, 0.5, 0),
						Size = UDim2.fromOffset(16, 16),
						ImageColor3 = Theme.button_arrow,

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

					[Children] = {
						New("UIPadding")({
							PaddingRight = UDim.new(0, 25),
						}),
					},
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
