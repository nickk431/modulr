local Promise = require(script.Parent.Parent.packages.promise)

return function(url)
	return Promise.new(function(resolve, reject)
		local success, result = pcall(function()
			return game:HttpGetAsync(url)
		end)

		if success then
			resolve(result)
		else
			reject(result)
		end
	end)
end
