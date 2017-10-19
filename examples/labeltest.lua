package.path = package.path .. ";../?.lua;../?/init.lua"

local hui   = require "hui"

font = of.TrueTypeFont()
font:load("data/font/PrintChar21.ttf", 12)

-- set default label font
hui.Label.font = font

-- set global font offset as some fonts need a litte nudge
hui.Label.textOffset.horz = -2

local wm = hui.WindowManager()

-- one fullscreen window
win = hui.Window()
win:enableFullscreen(true)
wm:addWindow(win)

-- add labels
local label = hui.Label(10, 10)
label.text = "auto sized"
label.border = 1
label.borderColor = of.Color.darkGray
win:addSubview(label)

label = hui.Label(200, 10)
label.text = "padded auto sized"
label.border = 1
label.borderColor = of.Color.darkGray
label.pad.horz = 10
label.pad.vert = 10
win:addSubview(label)

label = hui.Label(10, 90)
label.text = [[
multi line:
Iste recusandae distinctio dolorum a vero.
Cupiditate voluptatem explicabo expedita
quibusdam fuga. Recusandae suscipit at sed.
]]
label.textColor = of.Color.black
label.border = 1
label.pad.horz = 5
label.pad.vert = 5
label.borderColor = of.Color.darkGray
win:addSubview(label)

label = hui.Label(10, 200, 200, 50)
label.text = "fixed size"
label.border = 1
label.borderColor = of.Color.darkGray
win:addSubview(label)

label = hui.Label(220, 200, 200, 50)
label.text = "top center"
label.border = 1
label.borderColor = of.Color.darkGray
label.align.horz = of.ALIGN_HORZ_CENTER
win:addSubview(label)

label = hui.Label(430, 200, 200, 50)
label.text = "top right"
label.border = 1
label.borderColor = of.Color.darkGray
label.align.horz = of.ALIGN_HORZ_RIGHT
win:addSubview(label)

label = Label(10, 260, 200, 50)
label.text = "left center"
label.border = 1
label.borderColor = of.Color.darkGray
label.align.horz = of.ALIGN_HORZ_LEFT
label.align.vert = of.ALIGN_VERT_CENTER
win:addSubview(label)

label = Label(220, 260, 200, 50)
label.text = "center"
label.border = 1
label.borderColor = of.Color.darkGray
label.align.horz = of.ALIGN_HORZ_CENTER
label.align.vert = of.ALIGN_VERT_CENTER
win:addSubview(label)

label = hui.Label(430, 260, 200, 50)
label.text = "right center"
label.border = 1
label.borderColor = of.Color.darkGray
label.align.horz = of.ALIGN_HORZ_RIGHT
label.align.vert = of.ALIGN_VERT_CENTER
win:addSubview(label)

label = hui.Label(10, 320, 200, 50)
label.text = "left bottom"
label.border = 1
label.borderColor = of.Color.darkGray
label.align.horz = of.ALIGN_HORZ_LEFT
label.align.vert = of.ALIGN_VERT_BOTTOM
win:addSubview(label)

label = hui.Label(220, 320, 200, 50)
label.text = "center bottom"
label.border = 1
label.borderColor = of.Color.darkGray
label.align.horz = of.ALIGN_HORZ_CENTER
label.align.vert = of.ALIGN_VERT_BOTTOM
win:addSubview(label)

label = hui.Label(430, 320, 200, 50)
label.text = "right bottom"
label.border = 1
label.borderColor = of.Color.darkGray
label.align.horz = of.ALIGN_HORZ_RIGHT
label.align.vert = of.ALIGN_VERT_BOTTOM
win:addSubview(label)

label = hui.Label(160, 400, 100, 50)
label.text = "min size"
label.border = 1
label.borderColor = of.Color.darkGray
label.align.horz = of.ALIGN_HORZ_CENTER
label.align.vert = of.ALIGN_VERT_CENTER
win:addSubview(label)

minsize = label

label = hui.Label(320, 400)
label.text = "auto size"
label.border = 1
label.borderColor = of.Color.darkGray
label.align.horz = of.ALIGN_HORZ_CENTER
label.align.vert = of.ALIGN_VERT_CENTER
win:addSubview(label)

autosize = label

-- some punctuation chars probably won't be centered vertically...
label = hui.Label(500, 400)
label.text = ".-_.',:"
label.border = 1
label.borderColor = of.Color.darkGray
label.align.horz = of.ALIGN_HORZ_CENTER
label.align.vert = of.ALIGN_VERT_CENTER
win:addSubview(label)
label.minsize = {width=120, height=40}
label:layoutSubviews()

------------
-- Main Loop
------------

function setup()
	of.background(255)
	of.setColor(127)
end

function update()

	if of.getFrameNum() % 30 == 0 then
		local text = ""
		local num = math.floor(of.random(1, 11))
		for i=1,num do
			
			text = text..string.char(math.floor(of.random(33, 127)))
		end
		minsize.text = text
		autosize.text = text
		minsize:layoutSubviews()
		autosize:layoutSubviews()
	end

	wm:update()
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
