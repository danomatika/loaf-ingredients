-- run with args, ex:
-- loaf examples/testoptions.lua --foo bar -b -a z -nuc one two three

package.path = package.path .. ";../?.lua;../?/init.lua"

local options = require "options"

-- args
io.write(#arg.." args:")
for i,a in ipairs(arg) do
	io.write(" "..a)
end
io.write("\n")

-- options
local opt, argi = options.parse(arg)
local optc = 0
print("options")
for k,v in pairs(opt) do
	print("  "..k..": "..tostring(v).." ("..type(v)..")")
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
