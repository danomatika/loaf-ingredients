package.path = package.path .. ";../?.lua;../?/init.lua"

local hui = require "hui"
local gui = require "panel"

local wm = hui.WindowManager()

local panel = gui.Panel()
panel:addLabel("background")
panel.isMoveable = false
local params = {
	r = gui.Parameter(  0, 0, 255, 1, true),
	g = gui.Parameter(127, 0, 255, 1, true),
	b = gui.Parameter(255, 0, 255, 1, true)
}
panel:addSlider(gui.Slider(params.r, "r"))
panel:addSlider(gui.Slider(params.g, "g"))
panel:addSlider(gui.Slider(params.b, "b"))
wm:addWindow(panel)

------------
-- Main Loop
------------

function setup()
end

function update()
end

function draw()
	of.background(params.r:get(), params.g:get(), params.b:get())
	wm:draw()
end

---------
-- Events
---------

function keyPressed(key)
	wm:keyPressed(key)
end

function keyReleased(key)
	wm:keyReleased(key)
end

function mouseMoved(x, y)
	wm:mouseMoved(x, y)
end

function mouseDragged(x, y)
	wm:mouseDragged(x, y)
end

function mousePressed(x, y, button)
	wm:mousePressed(x, y, button)
end

function mouseReleased(x, y, button)
	wm:mouseReleased(x, y, button)
end

function windowResized(w, h)
	wm:windowResized(w, h)
end
