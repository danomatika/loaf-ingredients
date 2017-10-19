-- VERSION     = SimpleSprite 1.0.0
-- DESCRIPTION = simple sprite animation class using a sprite sheet
-- URL         = http://github.com/danomatika/loaf-ingredients
-- LICENSE     =
--   Copyright (c) 2017 Dan Wilcox <danomatika@gmail.com> MIT License.
--   For information on usage and redistribution, and for a DISCLAIMER OF ALL
--   WARRANTIES, see the file, "LICENSE.txt," in this distribution.

local SimpleSprite = class()

-- constructor with filename, sprite sheet size, ms per frame, & draw scale size
-- the sprite sheet consists of cells where:
--   * rows: animations sequences
--   * cols: frames per-animation sequence
-- assumes the individual cells within the sprite sheet are the same size
function SimpleSprite:__init(sheet, rows, cols, frametime, scale)
	if type(file) == "string" then
		-- path to the sprite sheet file
		self.sheet = of.Image(sheet)
	else
		-- assume this is an of.Image object
		self.sheet = sheet
	end
	self.sheetW = cols
	self.sheetH = rows
	self.spriteW = math.floor(self.sheet:getWidth()/cols)
	self.spriteH = math.floor(self.sheet:getHeight()/rows)
	self.scale = 1
	self.animation = 0 -- sheet row
	self.frame = 0     -- sheet col
	self.framestamp = 0
	self.frametime = 250
	if scale then self.scale = scale end
	if frametime then self.frametime = frametime end
end

-- update the current frame
function SimpleSprite:update()
	if of.getElapsedTimeMillis() - self.framestamp > self.frametime then
		self.frame = self.frame + 1
		if self.frame >= self.sheetW then
			self.frame = 0
		end
		self.framestamp = of.getElapsedTimeMillis()
	end
end

-- draw the current frame at a given location
function SimpleSprite:draw(x, y)
	if self.sheet then
		x = x - (self.spriteW / 2) * self.scale
		y = y - (self.spriteH / 2) * self.scale
		local sx = math.floor(self.frame * self.spriteW)
		local sy = math.floor(self.animation * self.spriteH)
		of.pushMatrix()
		of.translate(x, y)
		of.scale(self.scale, self.scale)
		of.setColor(255) -- white
		self.sheet:drawSubsection(0, 0, self.spriteW, self.spriteH, sx, sy)
		of.popMatrix()
	end
end

-- set the current animation aka col in the sprite sheet
function SimpleSprite:setAnimation(which)
	if which < 0 or which >= self.spriteH then return end
	self.animation = which
end

-- reset the current animation back to the first frame
function SimpleSprite:resetAnimation()
	self.frame = 0
	self.framestamp = of.getElapsedTimeMillis()
end

return SimpleSprite
