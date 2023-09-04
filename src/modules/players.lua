-- < Components >
local Components = script.Parent.Parent.components
local Button = require(Components.window.button)
local Divider = require(Components.window.divider)
local Section = require(Components.window.section)
local Viewport = require(Components.window.viewport)
local Window = require(Components.window.window)

-- < Packages >
local Packages = script.Parent.Parent.packages
local Fusion = require(Packages.fusion)

local Player = require(script.Parent.Parent.utils.player)

local spectating = false

-- < Functions >
function convertDaysToRelative(days)
	local years = math.floor(days / 365)
	local months = math.floor((days % 365) / 30)
	local remaining_days = days % 30

	local relative_time = ""

	if years > 0 then
		relative_time = years .. " " .. (years == 1 and "year" or "years")
	elseif months > 0 then
		relative_time = months .. " " .. (months == 1 and "month" or "months")
	else
		relative_time = remaining_days .. " " .. (remaining_days == 1 and "day" or "days")
	end

	return relative_time .. " ago"
end

-- < Player updating >
local Players = game:GetService("Players")
local PlayerList = Fusion.Value(Players:GetPlayers())

local function updatePlayers()
	PlayerList:set(Players:GetPlayers())
end

Players.PlayerAdded:Connect(updatePlayers)
Players.PlayerRemoving:Connect(updatePlayers)

-- < Module >
return {
	name = "players",
	description = "View all the players in the game",
	arguments = {},

	callback = function()
		Window({
			title = "Players",
			size = UDim2.fromOffset(320, 394),
		}, {
			Fusion.ForPairs(PlayerList, function(index, value)
				return index,
					Section({
						text = value.DisplayName .. " (" .. value.Name .. ")",
						subtext = value.UserId,
						newPage = {
							-- Viewport
							Divider({
								text = "Viewport",
							}),
							Viewport({
								object = workspace:FindFirstChild(value.Name),
								spinning = true,
								zoom = 8,
								clone = true,
							}),

							-- Info
							Divider({
								text = "Info",
							}),
							Button({
								text = "Creation Date",
								subtext = convertDaysToRelative(value.AccountAge)
									.. " ("
									.. value.AccountAge
									.. " days)",
								clickable = false,
							}),
							Button({
								text = "Verified",
								subtext = tostring(value.HasVerifiedBadge),
								clickable = false,
							}),

							-- Actions
							Divider({
								text = "Actions",
							}),
							Button({
								text = "Teleport",
								subtext = "Teleports your character to the target.",
								callback = function()
									local target = Player.getByName(value.Name)

									if target then
										Player.setPosition(target.Character:GetPivot())

										return
									end
								end,
							}),

							Button({
								text = "Spectate",
								subtext = "Spectates the target. They cannot see that you're spectating.",
								callback = function()
									local target = Player.getByName(value.Name)

									spectating = not spectating

									if target then
										if spectating then
											workspace.CurrentCamera.CameraSubject = target.Character

											return
										else
											workspace.CurrentCamera.CameraSubject = Player.getCharacter()
										end
									end
								end,
							}),
						},
						callback = function()
							print("clicked")
						end,
					})
			end, Fusion.cleanup),
		})
	end,
}
