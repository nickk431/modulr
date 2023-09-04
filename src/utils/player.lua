local Player = {}

local Players = game:GetService("Players")

local ACCEPTED_ROOTS = {
	"HumanoidRootPart",
	"Torso",
	"UpperTorso",
	"LowerTorso",
	"Head",
}

local function chunkMatch(chunk, str)
	if string.sub(chunk, 1, #str) == str then
		return true
	end

	return false
end

function Player.getCharacter()
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()

	return character
end

function Player.others()
	local players = Players:GetPlayers()
	local others = {}

	for _, player in players do
		if player ~= Player.me() then
			table.insert(others, player)
		end
	end

	return others
end

function Player.getByName(name: string)
	local players = Players:GetPlayers()

	for _, player in players do
		if chunkMatch(string.lower(player.Name), name) or chunkMatch(string.lower(player.DisplayName), name) then
			return player
		end
	end

	return nil
end

function Player.setPosition(position: CFrame)
	local character = Player.getCharacter()

	character:PivotTo(position)
end

function Player.getRoot(player)
	for _, object in player.Character:GetChildren() do
		if table.find(ACCEPTED_ROOTS, object.Name) then
			return object
		end
	end

	return nil
end

function Player.getHumanoid()
	return Player.getCharacter():FindFirstChildWhichIsA("Humanoid")
end

return Player
