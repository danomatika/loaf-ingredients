--   Copyright (c) 2017 Dan Wilcox <danomatika@gmail.com> MIT License.
--   For information on usage and redistribution, and for a DISCLAIMER OF ALL
--   WARRANTIES, see the file, "LICENSE.txt," in this distribution.

local thispath = select('1', ...):match(".+%.") or ""
local View = require(thispath.."View")

Label = class(View)

-- Label: view with a string of text
-- note: does not word wrap
-- w & h are used to set the minsize otherwise the label shrinks to fit its text
function Label:__init(x, y, w, h)
	View.__init(self, x, y, w, h)
	self.text = ""               -- text to display
	self.textColor = of.Color(0) -- text color
	self.font = nil              -- text font, required!

	-- padding around the label text
	self.pad = {horz=0, vert=0}

	-- text alignment within the label
	-- horz: of.ALIGN_HORZ_LEFT, of.ALIGN_HORZ_CENTER, of.ALIGN_HORZ_RIGHT
	-- vert: of.ALIGN_VERT_TOP, of.ALIGN_VERT_CENTER, of.ALIGN_VERT_BOTTOM
	self.align = {horz=of.ALIGN_HORZ_LEFT, vert=of.ALIGN_VERT_TOP}

	-- minimum allowed size, ignored when nil
	-- set as a table: {width=#, height=#}
	self.minsize = nil

	if w then
		if not self.minsize then self.minsize = {} end
		self.minsize.width = w
	end
	if h then
		self.minsize.height = h
	end
end

----------------------
-- Main Loop Callbacks
----------------------

-- draws the label text
function Label:draw()
	self:drawBackground()

	-- use string bounding box
	local x = 0
	local y = self.font:stringHeight("#")
	local bbox = self.font:getStringBoundingBox(self.text, self.frame.x, self.frame.y)

	-- adjust for horz alignment
	if self.align.horz == of.ALIGN_HORZ_CENTER then
		x = math.floor(self.frame.width/2 - bbox.width/2)
	elseif self.align.horz == of.ALIGN_HORZ_RIGHT then
		x = math.floor(self.frame.width - bbox.width) - self.pad.horz
	else -- LEFT & IGNORED
		x = x + self.pad.horz
	end

	-- adjust for vert alignment
	if self.align.vert == of.ALIGN_VERT_CENTER then
		y = y + math.floor(self.frame.height/2 - bbox.height/2)
	elseif self.align.vert == of.ALIGN_VERT_BOTTOM then
		y = y + math.floor(self.frame.height - bbox.height) - self.pad.vert
	else -- TOP & IGNORED
		y = y + self.pad.vert
	end

	-- draw
	of.setColor(self.textColor)
	self.font:drawString(self.text, x-2, y)
	
	self:drawBorder()
end

------------------------
-- View Change Callbacks
------------------------

-- calculates view sized based on label text, call after setting text to resize
function Label:layoutSubviews()
	local rect = self.font:getStringBoundingBox(self.text, self.frame.x, self.frame.y)
	rect.width = math.floor(rect.width + self.pad.horz * 2)
	rect.height = math.floor(rect.height + self.pad.vert * 2)
	if self.minsize then
		local size = self:sizeThatFits(rect.width, rect.height)
		if size.width < self.minsize.width then size.width = self.minsize.width end
		if size.height < self.minsize.height then size.height = self.minsize.height end
		self.frame.width = size.width
		self.frame.height = size.height
	else
		self.frame.width = rect.width
		self.frame.height = rect.height
	end
	View.layoutSubviews(self)
	self:updateClipping()
end

return Label
