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

source.complete = require "cmp-lua-latex-symbols/complete"

return source
