package.path = package.path .. ";../?.lua;../?/init.lua"

local Warper = require "Warper"

local rect = of.Rectangle(0.25, 0.25, 0.5, 0.5)
local seed = 0
local warper = Warper()
local warp = true
local help = [[
w: toggle quad warp
e: edit quad warp
r: reset quad warp]]

function setup()
	of.setWindowTitle("Test Warper")
	of.background(0)
	warper:setup(of.getWidth(), of.getHeight())
end

function update()
	seed = seed + 0.1
end

function draw()
	if warp then
		warper:beginWarp()
		-- clear background manually
		of.setColor(0)
		of.drawRectangle(0, 0, of.getWidth(), of.getHeight())
	end

	of.setColor(0, 255, 255)
	of.drawRectangle(
		rect.x * of.getWidth() + math.sin(seed) * 10,
		rect.y * of.getHeight() + math.cos(seed) * 10,
		rect.width * of.getWidth(), rect.height * of.getHeight()
	)
	
	if warp then
		warper:endWarp()
		warper:draw()
	end

	of.setColor(255)
	of.drawBitmapString(help, 4, 14)
end

function keyReleased(key)
	if key == string.byte("w") then
		warp = not warp
	elseif key == string.byte("e") then
		warper.edit = not warper.edit
	elseif key == string.byte("r") then
		warper:reset()
	end
end

function mouseMoved(x, y)
	warper:mouseMoved(x, y)
end

function mouseDragged(x, y, button)
	warper:mouseDragged(x, y, button)
end

function windowResized(w, h)
	warper:setup(w, h)
end
