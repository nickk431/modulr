local Fusion = require(script.Parent.fusion)
local Value = Fusion.Value

local GlobalStates = {
	-- < Window states >
	Theme = Value("dark"),
	Objects = Value({}),
	UILayouts = Value({}),
	Backbuttons = Value({}),
	ScrollingFrames = Value({}),

	-- < Command bar states >
	CommandBarOpened = Value(false),
	CommandBarText = Value(""),
	Suggestions = Value({}),
	PredictionText = Value(""),
	ToExecute = Value(""),
	Commands = Value({}),

	-- < Notification states >
	Notifications = Value({}),

	-- < Other states >
	FPSCheck = Value(true),
	PingCheck = Value(true),
}

function GlobalStates.add(state: string, value: any, name: string)
	if not GlobalStates[state] then
		error("No global state named: " .. state)
	end

	local globalState = GlobalStates[state]
	local newTable = table.clone(globalState:get())
	newTable[name] = value

	globalState:set(newTable)
end

return GlobalStates
