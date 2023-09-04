local ColorUtils = {}

function ColorUtils.darkenRGB(Color, factor: number)
	return Color3.fromRGB((Color.R * 255) - factor, (Color.G * 255) - factor, (Color.B * 255) - factor)
end

function ColorUtils.lightenRGB(Color, factor: number)
	return Color3.fromRGB((Color.R * 255) + factor, (Color.G * 255) + factor, (Color.B * 255) + factor)
end

return ColorUtils
