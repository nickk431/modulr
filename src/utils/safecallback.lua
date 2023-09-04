return function(callback: () -> ...any): thread
	return task.spawn(xpcall, callback, function(l)
		warn((debug.traceback(l):gsub("[\n\r]+", "\n\t")))
	end)
end
