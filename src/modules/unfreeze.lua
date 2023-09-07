return {
	name = "unfreeze",
	description = "Un-anchors all of your character's parts",
	arguments = {},

	callback = function(_, utils, _)
		for _, part in utils.player.getCharacter():GetChildren() do
			if part:IsA("BasePart") then
				part.Anchored = false
			end
		end
	end,
}
