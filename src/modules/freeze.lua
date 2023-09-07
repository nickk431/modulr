return {
	name = "freeze",
	description = "Anchors all of your character's parts",
	arguments = {},

	callback = function(_, utils, _)
		for _, part in utils.player.getCharacter():GetChildren() do
			if part:IsA("BasePart") then
				part.Anchored = true
			end
		end
	end,
}
