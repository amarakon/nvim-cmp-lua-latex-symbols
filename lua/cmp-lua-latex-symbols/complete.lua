return function(self, params, callback)
    if not vim.regex(self.get_keyword_pattern() .. "$"):match_str(params.context.cursor_before_line) then
        return callback()
    end

	local cached = require
		"cmp-lua-latex-symbols.options".validate(params).cache

	local cachew
	if cached then
		local cache = vim.fn.stdpath("cache").."/cmp-lua-latex-symbols.lua"
		local cacher = io.open(cache, "r")

		if cacher ~= nil then
			cacher:close()
			callback(dofile(cache))
			return
		else
			cachew = io.open(cache, "w")
			if cachew == nil then
				return
			end
			cachew:write("return {\n")
		end
	end

	-- This is the command used to generate the symbol list.
	local cmd = io.popen([[
		URL=http://milde.users.sourceforge.net/LUCR/Math/data/unimathsymbols.txt

		if [ "$(command -v wget)" != "" ]; then
			wget -qO- $URL
		elif [ "$(command -v curl)" != "" ]; then
			curl -L $URL
		fi
	]])

	if cmd == nil then
		return
	end

	local symstr = cmd:read "*a" -- We need to read the symbols.

	if symstr == "" then
		return
	end

	local pos,symtbl = 0,{}
	for i,v in function() return symstr:find("\n", pos, true) end do
		-- A caret needs to be added at the end to parse the last section.
		local line = symstr:sub(pos, i - 1):gsub("^%x-%^", "").."^"

		-- Remove comments (They start with a hashtag.)
		if not line:find("#", 0, true) then
			local count = 0 -- Initiate the counter
			local isunicode = false -- Initiate the Unicode checker

			local newpos = 0
			-- Separate each section by the caret symbol
			for j,w in function() return line:find("^", newpos, true) end do
				-- Only continue if the next symbol is not also a separator
				if line:find("^", w) == w then
					count = count + 1
					local section = line:sub(newpos, j - 1)

					-- Continue if we’re in the second section and the symbol is
					-- a Unicode character
					if count == 1 and section:byte() and section:byte() > 127 then
						isunicode = true
						symbol = section
					-- Continue if we’re in the third section and the code
					-- starts with a backslash
					elseif count == 2 and isunicode and section:find("\\", 1, true) and not section:match("^\\%S-{%S-}") then
						isunicode = false

						table.insert(symtbl, {
							word = section,
							label = section.." "..symbol,
							insertText = symbol,
							filterText = section
						})
						if cached then
							cachew:write("\t{ "..
								"word = "..'"\\'..section..'", '..
								"label = "..'"\\'..section.." "..symbol..'", '..
								"insertText = "..'"'..symbol..'", '..
								"filterText = "..'"\\'..section..'"'..
							" },\n")
						end

						break
					end
				end

				newpos = w + 1
			end
		end

		pos = v + 1
	end

	if cached then
		cachew:write("}\n") -- Add the closing bracket
		cachew:close() -- We are done writing to the cache file.
	end

	cmd:close() -- We are done reading the symbols.

	callback(symtbl)
end
