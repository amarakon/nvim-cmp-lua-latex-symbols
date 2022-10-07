local source = {}

function source.new()
	return setmetatable({}, { __index = source })
end

function source.get_trigger_characters()
	return { "\\" }
end

function source.get_keyword_pattern()
	return "\\\\[^[:blank:]]*"
end

function source.complete(_, _, callback)
	callback(require "cmp-lua-latex-symbols/complete")
end

return source
