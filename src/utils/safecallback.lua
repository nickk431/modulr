return function(callback: () -> ...any): thread
	local ok, result = pcall(callback)

	if not ok then
		error(result)
	end

	return result
end
