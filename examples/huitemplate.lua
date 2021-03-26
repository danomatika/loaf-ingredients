package.path = package.path .. ";../?.lua;../?/init.lua"

local hui = require "hui"

local wm = hui.WindowManager()
local win = hui.Window(10, 10, 100, 100)

wm:addWindow(win)
win.backgroundColor = of.Color(200)

------------
-- Main Loop
------------

function setup()
end

function update()
end

function draw()
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
