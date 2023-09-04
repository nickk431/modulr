local Players = game:GetService("Players")

local player = Players.LocalPlayer

return {
	name = "refresh",
	description = "Refreshes your character and teleports you back",
	arguments = {},

	callback = function()
		local character = player.Character

		local savedPosition = character:GetPivot()

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:ChangeState(15)
		end

		character:ClearAllChildren()

		local newCharacter = Instance.new("Model")
		newCharacter.Parent = workspace
		player.Character = newCharacter

		task.delay(0.1, function()
			player.Character = character
			newCharacter:Destroy()
		end)

		player.CharacterAdded:Wait()

		player.Character:PivotTo(savedPosition)
	end,
}
