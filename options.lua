-- VERSION     = options 1.0.0
-- DESCRIPTION = super simple commandline options parser
-- URL         = http://github.com/danomatika/loaf-ingredients
-- LICENSE     =
--   Copyright (c) 2022 Dan Wilcox <danomatika@gmail.com> MIT License.
--   For information on usage and redistribution, and for a DISCLAIMER OF ALL
--   WARRANTIES, see the file, "LICENSE.txt," in this distribution.

local options = {}

-- parse options hash from arg string array
-- * key: short "-" and long "--" options
-- * (assumed) value based on next arg:
--   - next arg is option: true (assume flag)
--   - next arg *not* option: use as value (number or string)  
-- * short flags can be compounded: -abc = -a -b -c
-- * stops parsing on "--" or first non-value, ex. "-f bar baz -c" stops on baz
-- returns options key/value hash & first non-option pos in arg array
-- ex: "--foo 123 -bar abc -a -- baz" -> {"foo"=123, "bar"="abc", "a"=true}, 7
-- non-options pos is 0 if no remaining args
function options.parse(arg)
	local opt = {}
	local i = 1 -- arg index
	while i <= #arg do
		if arg[i] == "--" then
			-- stop parsing
			i = i + 1
			break
		end
		local key = nil
		if string.sub(arg[i], 1, 2) == "--" then
			-- long opt
			key = string.sub(arg[i], 3, string.len(arg[i]))
		elseif string.sub(arg[i], 1, 1) == "-" then
			-- short opt
			key = string.sub(arg[i], 2, string.len(arg[i]))
			if string.len(key) > 1 then
				-- compound short flags: -abc = -a -b -c
				while string.len(key) > 0 do
					local k = string.sub(key, 1, 1)
					opt[k] = true
					key = string.sub(key, 2, string.len(key))
				end
				key = nil
			end
		else
			-- non-option, stop parsing
			break
		end
		i = i + 1
		if key then
			if arg[i] == nil or options.isopt(arg[i]) then
				-- assume flag
				opt[key] = true
			else
				-- value
				opt[key] = tonumber(arg[i]) or arg[i]
				i = i + 1
			end
		end
	end
	if i > #arg then i = 0 end
	return opt, i
end

-- returns true if given arg string is an option
function options.isopt(arg)
	return (string.sub(arg, 1, 2) == "--") or (string.sub(arg, 1, 1) == "-")
end

return options
