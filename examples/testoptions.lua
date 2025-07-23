-- run with args, ex:
-- loaf examples/testoptions.lua --foo bar --baz 1 -a knapp -u 432.1 -t one two three

package.path = package.path .. ";../?.lua;../?/init.lua"

local options = require "options"

local helptext = [[
Usage: loaf myscript [OPTIONS] [ARGUMENT...]

my loaf script

Options:
  -h, --help    print this help
  -f, --foo     string option
  --baz         number option
  -a            string option
  -u            number option
  -t            flag, no value

Arguments:
  ARGUMENT      additional non-option arguments
]]

-- args
io.write(#arg.." args:")
for i,a in ipairs(arg) do
	io.write(" "..a)
end
io.write("\n")

-- options
local opt, argi = options.parse(arg, {"h", "help", "t"})
local optc = 0
print("options")
for k,v in pairs(opt) do
	print("  "..k..": "..tostring(v).." ("..type(v)..")")
	if k == "h" or k == "help" then
		io.write(helptext)
		os.exit(0)
	elseif k == "f" or k == "foo" then
		--
	elseif k == "baz" then
		if tonumber(v) == nil then
			print("option baz invalid")
		end
	elseif k == "a" then
		--
	elseif k == "u" then
		if tonumber(v) == nil then
			print("option u invalid")
		end
	elseif k == "t" then
		--
	end
	optc = optc + 1
end
print("option count: "..optc)

-- non-option args remaining
print("remaining args at: "..argi)
if argi > 0 then
	io.write("remaining args:")
	for i=argi,#arg do
		io.write(" "..arg[i])
	end
else
	io.write("no remaining args")
end
io.write("\n")

-- done
of.exit(0)
