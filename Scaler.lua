-- VERSION     = Scaler 1.0.0
-- DESCRIPTION = loaf 2d screen render scaler
-- URL         = http://github.com/danomatika/loaf-ingredients
-- LICENSE     =
--   Copyright (c) 2017 Dan Wilcox <danomatika@gmail.com> MIT License.
--   For information on usage and redistribution, and for a DISCLAIMER OF ALL
--   WARRANTIES, see the file, "LICENSE.txt," in this distribution.
local Scaler = class()

-- constructor with render pixel size, leave empty for current window size
function Scaler:__init(w, h)
	self.render = of.Rectangle() -- render area rectangle
	self.width = w               -- render width in pixels
	self.height = h              -- render height in pixels
	self.scaleX = 1.0            -- horz scale between window & render width
	self.scaleY = 1.0            -- vert scale between window & render height
	self.aspect = true           -- keep aspect ratio when scaling?
	if not w then self.width = of.getWidth() end
	if not h then self.height = of.getHeight() end
end

-- update scaler with new window size
function Scaler:update(w, h)
	local win
	if not w and not h then
		win = of.Rectangle(0, 0, of.getWidth(), of.getHeight())
	else
		win = of.Rectangle(0, 0, w, h)
	end
	local a = of.ASPECT_RATIO_IGNORE
	if self.aspect then a = of.ASPECT_RATIO_KEEP end
	self.render:set(0, 0, self.width, self.height)
	self.render:scaleTo(win, a, of.ALIGN_HORZ_CENTER, of.ALIGN_VERT_CENTER)
	self.scaleX = self.render.width / self.width
	self.scaleY = self.render.height / self.height
end

-- apply render scaling, put this inside of.pushMatrix() & of.popMatrix()
function Scaler:apply()
	of.translate(self.render.x, self.render.y)
	of.scale(self.scaleX, self.scaleY)
end

return Scaler
