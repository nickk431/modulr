-- < Services >
local Stats = game:GetService("Stats")

-- < Imports >
local Constants = require(script.Parent.Parent.storage.constants)
local Notification = require(script.Parent.Parent.components.notification.notification)

-- < Variables >
local Frames = Stats:WaitForChild("FrameRateManager"):WaitForChild("RenderAverage")
local Ping = Stats:WaitForChild("Network"):WaitForChild("ServerStatsItem"):WaitForChild("Data Ping")

-- < Handling >
local function main()
	while task.wait(5) do
		local fps = math.round((1e3 / Frames:GetValue()) * 10) / 10
		local ping = math.round(Ping:GetValue() * 10) / 10

		if ping > 150 then
			Notification({
				title = "Ping",
				description = "We noticed your Ping is high.  You may experience latency issues.",
				duration = 8,
				type = "warning",
			})

			return
		end

		if fps <= 30 then
			Notification({
				title = "FPS",
				description = "We noticed your FPS is low. Try freeing up some resources on your computer.",
				duration = 8,
				type = "warning",
			})

			return
		end
	end
end

if not Constants._IS_DEV then
	main()
end
