local main = {}

main.default = {
	cache = true
}

main.validate = function(params)
	local options = vim.tbl_deep_extend("keep", params.option, main.default)
	vim.validate { cache = { options.cache, "boolean" } }
	return options
end

return main
