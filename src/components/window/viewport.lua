--[[
	File: button.lua
	Creates a button in the window
]]

-- < Utils >
local Utils = script.Parent.Parent.Parent.utils
local colorUtils = require(Utils.color3)
local unwrap = require(Utils.unwrap)

-- < Packages >
local Packages = script.Parent.Parent.Parent.packages
local Fusion = require(Packages.fusion)
local ViewportModel = require(Packages.viewport)

-- < Variables >
local Children = Fusion.Children
local Computed = Fusion.Computed
local Value = Fusion.Value
local Ref = Fusion.Ref
local New = Fusion.New

-- < Theme >
local Theme = require(script.Parent.Parent.Parent.storage.theme)

-- < Types >
type ViewportProps = {
	object: string,
	spinning: boolean?,
	zoom: number?,
	clone: boolean?,
}

-- < Component >
return function(props: ViewportProps)
	local ViewportFrame = Value()
	local Camera = Value()
	local cameraCFrame = Value(CFrame.new(0, 0, 0))

	local model = New("Model")({
		[Children] = Computed(function()
			local object = props.object

			if object ~= nil and object:IsA("Instance") then
				if props.clone then
					object.Archivable = true

					return { object:Clone() }
				end

				return { object }
			end

			return {}
		end),
	})

	local spinConnection = nil

	local Viewport = Computed(function()
		return New("ImageButton")({
			Name = "Frame",
			AutoButtonColor = false,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Theme.button_background,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0, 0.145),
			Size = UDim2.fromScale(1, 0),

			[Children] = {
				New("UICorner")({
					CornerRadius = UDim.new(0, 5),
				}),

				New("UIPadding")({
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					PaddingTop = UDim.new(0, 8),
				}),

				New("Camera")({
					[Ref] = Camera,

					CFrame = cameraCFrame,
					CameraSubject = model,
					FieldOfView = 70,
				}),

				New("ViewportFrame")({
					[Ref] = ViewportFrame,

					BackgroundColor3 = Theme.input_background,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 150),
					CurrentCamera = Camera,

					[Children] = {
						New("UICorner")({
							CornerRadius = UDim.new(0, 6),
						}),

						model,
					},
				}),
			},
		})
	end, function()
		if spinConnection ~= nil then
			spinConnection:Disconnect()
		end
	end)

	local viewportObject = ViewportModel.new(unwrap(ViewportFrame), unwrap(Camera))
	local viewportBox, _ = model:GetBoundingBox()

	viewportObject:SetModel(model)

	local theta = 0
	local orientation = CFrame.new()
	local distance = viewportObject:GetFitDistance(viewportBox.Position)

	if props.spinning then
		spinConnection = game:GetService("RunService").RenderStepped:Connect(function(dt)
			theta = theta + math.rad(20 * dt)
			orientation = CFrame.fromEulerAnglesYXZ(math.rad(-20), theta, 0)
			cameraCFrame:set(CFrame.new(viewportBox.Position) * orientation * CFrame.new(0, 0, distance / props.zoom))
		end)
	else
		cameraCFrame:set(CFrame.new(viewportBox.Position) * CFrame.new(0, 0, distance / props.zoom))
	end

	return Viewport
end
