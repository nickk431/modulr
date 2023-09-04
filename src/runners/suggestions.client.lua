--[[
	File: suggestions.client.lua
	Keeps track of suggestions and changes the global state
]]

-- < Imports >
local Fusion = require(script.Parent.Parent.packages.fusion)
local Fuzzy = require(script.Parent.Parent.packages.damerau)
local States = require(script.Parent.Parent.packages.states)
local Suggestion = require(script.Parent.Parent.components.commandbar.suggestion)

-- < Variables >
local function buildTree()
	local moduleTree = {}
	local moduleList = script.Parent.Parent.modules:GetChildren()

	for _, module in moduleList do
		local moduleData = require(module)

		moduleTree[moduleData.name] = moduleData
	end

	return moduleTree
end

local function buildNames(tree)
	local moduleNames = {}

	for _, module in tree do
		table.insert(moduleNames, module.name)
	end

	return moduleNames
end

local moduleTree = buildTree()
local moduleNames = buildNames(moduleTree)

local function main()
	local inputObserver = Fusion.Observer(States.CommandBarText)

	inputObserver:onChange(function()
		local matches = {}
		for _, name in moduleNames do
			matches[name] = Fuzzy.raw(States.CommandBarText:get(), name)
		end

		local keys = {}
		for k in matches do
			table.insert(keys, k)
		end

		table.sort(keys, function(a, b)
			return matches[a] < matches[b]
		end)

		local suggestions = {}
		for index, k in keys do
			if matches[k] < 5 then
				if index == 1 then
					local text = States.CommandBarText:get()

					if #text > 1 and text:sub(1, #text) == k:sub(1, #text) then
						States.PredictionText:set(k)
					else
						States.PredictionText:set("")
					end
				end

				table.insert(
					suggestions,
					Suggestion({
						name = k,
						description = moduleTree[k].description,
						types = moduleTree[k].arguments,
						top = index == 1 and true or false,
					})
				)
			end
		end

		States.Suggestions:set(suggestions)
	end)
end

main()
