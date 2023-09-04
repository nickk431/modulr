local Fusion = require(script.Parent.Parent.packages.fusion)
local Computed = Fusion.Computed

local States = require(script.Parent.Parent.packages.states)

-- TODO: change format

-- dark = {
-- 	window = {
-- 		text = Color3.fromRGB(255, 255, 255),
-- 		background = Color3.fromRGB(30, 30, 30),
-- 		border = Color3.fromRGB(50, 50, 50),

-- 		topbar = Color3.fromRGB(35, 35, 35),
-- 		accents = Color3.fromRGB(50, 50, 50),

-- 		exit = Color3.fromRGB(45, 45, 45),
-- 		exit_icon = Color3.fromRGB(221, 221, 221),

-- 		drag = Color3.fromRGB(40, 40, 40),
-- 		drag_bar = Color3.fromRGB(90, 90, 90),
-- 	},
-- },

local THEME_COLOURS = {
	--[[ WINDOW START ]]
	window_background = {
		nord = Color3.fromRGB(45, 51, 63),
		dracula = Color3.fromRGB(40, 42, 54),
		dark = Color3.fromRGB(30, 30, 30),
	},

	window_topbar = {
		nord = Color3.fromRGB(51, 58, 70),
		dracula = Color3.fromRGB(45, 47, 59),
		dark = Color3.fromRGB(35, 35, 35),
	},

	window_accents = {
		nord = Color3.fromRGB(61, 69, 83),
		dracula = Color3.fromRGB(59, 61, 77),
		dark = Color3.fromRGB(50, 50, 50),
	},

	window_exit = {
		nord = Color3.fromRGB(59, 66, 82),
		dracula = Color3.fromRGB(48, 50, 65),
		dark = Color3.fromRGB(45, 45, 45),
	},

	window_exit_icon = {
		nord = Color3.fromRGB(204, 204, 204),
		dracula = Color3.fromRGB(221, 221, 221),
		dark = Color3.fromRGB(221, 221, 221),
	},

	window_text = {
		nord = Color3.fromRGB(255, 255, 255),
		dracula = Color3.fromRGB(255, 255, 255),
		dark = Color3.fromRGB(255, 255, 255),
	},

	window_drag = {
		nord = Color3.fromRGB(58, 66, 80),
		dracula = Color3.fromRGB(45, 47, 59),
		dark = Color3.fromRGB(40, 40, 40),
	},

	window_border = {
		nord = Color3.fromRGB(57, 65, 80),
		dracula = Color3.fromRGB(55, 57, 73),
		dark = Color3.fromRGB(50, 50, 50),
	},

	window_drag_bar = {
		nord = Color3.fromRGB(91, 103, 126),
		dracula = Color3.fromRGB(89, 94, 119),
		dark = Color3.fromRGB(90, 90, 90),
	},
	--[[ WINDOW END ]]

	--[[ BUTTON START ]]
	button_background = {
		nord = Color3.fromRGB(51, 57, 70),
		dracula = Color3.fromRGB(45, 47, 59),
		dark = Color3.fromRGB(35, 35, 35),
	},

	button_text = {
		nord = Color3.fromRGB(255, 255, 255),
		dracula = Color3.fromRGB(255, 255, 255),
		dark = Color3.fromRGB(255, 255, 255),
	},

	button_subtext = {
		nord = Color3.fromRGB(204, 204, 204),
		dracula = Color3.fromRGB(204, 204, 204),
		dark = Color3.fromRGB(204, 204, 204),
	},

	button_switch = {
		nord = Color3.fromRGB(81, 90, 110),
		dracula = Color3.fromRGB(84, 89, 112),
		dark = Color3.fromRGB(80, 80, 80),
	},

	button_switch_circle = {
		nord = Color3.fromRGB(150, 150, 150),
		dracula = Color3.fromRGB(150, 150, 150),
		dark = Color3.fromRGB(150, 150, 150),
	},

	button_switch_enabled = {
		nord = Color3.fromRGB(136, 192, 208),
		dracula = Color3.fromRGB(177, 118, 255),
		dark = Color3.fromRGB(254, 126, 92),
	},

	button_switch_circle_enabled = {
		nord = Color3.fromRGB(255, 255, 255),
		dracula = Color3.fromRGB(255, 255, 255),
		dark = Color3.fromRGB(255, 255, 255),
	},

	button_arrow = {
		nord = Color3.fromRGB(136, 192, 208),
		dracula = Color3.fromRGB(189, 147, 249),
		dark = Color3.fromRGB(254, 126, 92),
	},

	slider_grab = {
		nord = Color3.fromRGB(230, 230, 230),
		dracula = Color3.fromRGB(230, 230, 230),
		dark = Color3.fromRGB(230, 230, 230),
	},

	slider_rail = {
		nord = Color3.fromRGB(136, 192, 208),
		dracula = Color3.fromRGB(189, 147, 249),
		dark = Color3.fromRGB(254, 126, 92),
	},

	slider_box = {
		nord = Color3.fromRGB(54, 61, 75),
		dracula = Color3.fromRGB(45, 47, 59),
		dark = Color3.fromRGB(40, 40, 40),
	},

	slider_background = {
		nord = Color3.fromRGB(70, 79, 97),
		dracula = Color3.fromRGB(64, 67, 83),
		dark = Color3.fromRGB(80, 80, 80),
	},

	input_background = {
		nord = Color3.fromRGB(58, 65, 78),
		dracula = Color3.fromRGB(50, 53, 66),
		dark = Color3.fromRGB(40, 40, 40),
	},

	input_placeholder = {
		nord = Color3.fromRGB(154, 156, 160),
		dracula = Color3.fromRGB(103, 108, 138),
		dark = Color3.fromRGB(120, 120, 120),
	},

	input_text = {
		nord = Color3.fromRGB(223, 223, 223),
		dracula = Color3.fromRGB(223, 223, 223),
		dark = Color3.fromRGB(223, 223, 223),
	},

	divider_accent = {
		nord = Color3.fromRGB(52, 58, 71),
		dracula = Color3.fromRGB(59, 61, 77),
		dark = Color3.fromRGB(52, 52, 52),
	},

	divider_text = {
		nord = Color3.fromRGB(220, 220, 220),
		dracula = Color3.fromRGB(220, 220, 220),
		dark = Color3.fromRGB(220, 220, 220),
	},

	notif_background = {
		nord = Color3.fromRGB(38, 43, 53),
		dracula = Color3.fromRGB(40, 42, 54),
		dark = Color3.fromRGB(30, 30, 30),
	},

	notif_circle = {
		nord = Color3.fromRGB(58, 66, 80),
		dracula = Color3.fromRGB(55, 58, 75),
		dark = Color3.fromRGB(50, 50, 50),
	},

	bar_background = {
		nord = Color3.fromRGB(42, 47, 58),
		dracula = Color3.fromRGB(40, 42, 54),
		dark = Color3.fromRGB(30, 30, 30),
	},

	bar_top = {
		nord = Color3.fromRGB(52, 58, 71),
		dracula = Color3.fromRGB(47, 50, 63),
		dark = Color3.fromRGB(40, 40, 40),
	},

	bar_accent = {
		nord = Color3.fromRGB(59, 67, 82),
		dracula = Color3.fromRGB(58, 61, 78),
		dark = Color3.fromRGB(50, 50, 50),
	},

	suggestion_back = {
		nord = Color3.fromRGB(41, 46, 56),
		dracula = Color3.fromRGB(40, 42, 54),
		dark = Color3.fromRGB(30, 30, 30),
	},

	suggestion_top = {
		nord = Color3.fromRGB(56, 64, 78),
		dracula = Color3.fromRGB(51, 54, 68),
		dark = Color3.fromRGB(40, 40, 40),
	},
}

local currentTheme = States.Theme -- So it can be updated through the global states

local currentColours = {}
for colorName, colorOptions in THEME_COLOURS do
	currentColours[colorName] = Computed(function()
		return colorOptions[currentTheme:get()]
	end)
end

return currentColours
