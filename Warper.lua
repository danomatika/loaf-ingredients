-- VERSION     = Warper 1.0.0
-- DESCRIPTION = quad warper using fbo
-- URL         = http://github.com/danomatika/loaf-ingredients
-- LICENSE     =
--   Copyright (c) 2022 Dan Wilcox <danomatika@gmail.com> MIT License.
--   For information on usage and redistribution, and for a DISCLAIMER OF ALL
--   WARRANTIES, see the file, "LICENSE.txt," in this distribution.

local Warper = class()

Warper.handleSize = 30
Warper.color = {
	fbo = 255,                     -- fbo draw color
	border = of.Color(0, 255, 0),  -- edit border and handles
	handle = of.Color(255, 255, 0) -- edit selected handle
}

function Warper:__init()
	self.fbo = of.Fbo() -- render fbo
	self.points = { -- upper left, upper right, lower right, lower left
		-- normalized 0-1
		norm = {glm.vec3(0, 0, 0), glm.vec3(1, 0, 0), glm.vec3(1, 1, 0), glm.vec3(0, 1, 0)},
		-- scaled to 0-width, 0-height
		scale = {glm.vec3(), glm.vec3(), glm.vec3(), glm.vec3()},
		-- mouse over status
		over = {false, false, false, false}
	}
	self.width = 0    -- scale width
	self.height = 0   -- scale height
	self.edit = false -- editing?
end

-- setup with render width and height
function Warper:setup(w, h)
	self.width = w
	self.height = h
	self.fbo:allocate(w, h)
	self.fbo:getTexture():setTextureMinMagFilter(of.NEAREST, of.NEAREST)
	self:_update()
end

-- reset to window size
function Warper:reset()
	self.points.norm[1].x = 0
	self.points.norm[1].y = 0

	self.points.norm[2].x = 1
	self.points.norm[2].y = 0

	self.points.norm[3].x = 1
	self.points.norm[3].y = 1

	self.points.norm[4].x = 0
	self.points.norm[4].y = 1

	self:_update() 
end

-- begin drawing into warper fbo
function Warper:beginWarp()
	self.fbo:beginFbo()
end

-- end drawing into warper fbo
function Warper:endWarp()
	self.fbo:endFbo()
end

-- draw warper
function Warper:draw()
	
	-- fbo
	of.fill()
	of.setColor(Warper.color.fbo)
	self.fbo:getTexture():draw(
		self.points.scale[1],
		self.points.scale[2],
		self.points.scale[3],
		self.points.scale[4]
	)

	if self.edit then
		
		-- quad
		of.noFill()
		of.setColor(Warper.color.border)
		of.setLineWidth(1)
		of.beginShape()
			of.vertex(self.points.scale[1])
			of.vertex(self.points.scale[2])
			of.vertex(self.points.scale[3])
			of.vertex(self.points.scale[4])
		of.endShape(true)
		
		-- edit handles
		of.fill()
		for i=1,4 do
			if self.points.over[i] then
				of.setColor(Warper.color.handle)
			end
			of.drawCircle(self.points.scale[i], Warper.handleSize)		
		end
	end
end

-- check if mouse over handle in edit mode
function Warper:mouseMoved(x, y)
	if not self.edit then return end
	local mpos = glm.vec3(x, y, 0)
	for i=1,4 do
		local d = glm.fastDistance(self.points.scale[i], mpos)
		self.points.over[i] = (d <= Warper.handleSize)
	end
end

-- drag handle in edit mode
function Warper:mouseDragged(x, y, button)
	if not self.edit then return end
	for i=1,4 do
		if self.points.over[i] then
			self.points.scale[i].x = x
			self.points.scale[i].y = y
			self.points.norm[i].x = x / of.getWidth()
			self.points.norm[i].y = y / of.getHeight()
			return
		end 
	end
end

-- update scaled points
function Warper:_update()
	self.points.scale[1].x = self.points.norm[1].x * self.width
	self.points.scale[1].y = self.points.norm[1].y * self.height

	self.points.scale[2].x = self.points.norm[2].x * self.width
	self.points.scale[2].y = self.points.norm[2].y * self.height

	self.points.scale[3].x = self.points.norm[3].x * self.width
	self.points.scale[3].y = self.points.norm[3].y * self.height

	self.points.scale[4].x = self.points.norm[4].x * self.width
	self.points.scale[4].y = self.points.norm[4].y * self.height
end

return Warper
