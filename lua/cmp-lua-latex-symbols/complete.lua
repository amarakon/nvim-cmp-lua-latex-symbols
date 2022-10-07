-- This is the command used to generate the symbol list.
local cmd = io.popen([[wget -qO-\
	http://milde.users.sourceforge.net/LUCR/Math/data/unimathsymbols.txt]])

if cmd == nil then
	return
end

local symstr = cmd:read "*a" -- We need to read the symbols.

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

				-- Continue if we’re in the second section and the symbol is a
				-- Unicode character
				if (count == 1 and section:byte() and section:byte() > 127) then
					isunicode = true
					Symbol = section
				-- Continue if we’re in the third section and the code starts
				-- with a backslash
				elseif (count == 2 and isunicode and section:find("\\", 1, true)) then
					isunicode = false

					table.insert(symtbl, {
						word = section,
						label = section.." "..Symbol,
						insertText = Symbol,
						filterText = section
					})

					break
				end
			end

			newpos = w + 1
		end
	end

	pos = v + 1
end

cmd:close() -- We are done reading the symbols.

return symtbl
