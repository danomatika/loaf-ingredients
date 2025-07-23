--   Copyright (c) 2017 Dan Wilcox <danomatika@gmail.com> MIT License.
--   For information on usage and redistribution, and for a DISCLAIMER OF ALL
--   WARRANTIES, see the file, "LICENSE.txt," in this distribution.

local thispath = select('1', ...):match(".+%.") or ""
local View = require(thispath.."View")

Label = class(View)

-- shared font
Label.font = nil

-- default text offset as some fonts might need to be nudged
Label.textOffset = {horz=0, vert=0}

-- font fixed width default
Label.fontFixedWidth = false

-- Label: view with a string of text
-- note: does not word wrap
-- w & h are used to set the minsize otherwise the label shrinks to fit its text
function Label:__init(x, y, w, h)
	View.__init(self, x, y, w, h)
	self.text = ""               -- text to display
	self.textColor = of.Color(0) -- text color
	if not Label.font then -- lazy load default font
		Label.font = of.TrueTypeFont()
		Label.font:load(of.TTF_MONO, 12)
	end
	self.font = Label.font       -- text font, required!

	-- padding around the label text
	self.pad = {horz=0, vert=0}

	-- text offset as some fonts might need to be nudged
	self.textOffset = {horz=Label.textOffset.horz, vert=Label.textOffset.vert}

	-- is the font fixed width? used when calculating min width
	self.fontFixedWidth = Label.fontFixedWidth

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
		if not self.minsize then self.minsize = {} end
		self.minsize.height = h
	end
end

----------------------
-- Main Loop Callbacks
----------------------

-- draws the label text
function Label:draw()
	self:drawBackground()
	of.setColor(self.textColor)
	self:drawText()
	self:drawBorder()
end

-----------------
-- Draw Callbacks
-----------------

-- draw the current label text with an optional offset, does *not* set color
function Label:drawText(x, y)

	-- use string bounding box
	if not x then x = 0 end
	if not y then y = 0 end
	y = y + self:fixedCharWidth()
	local w = self.font:stringWidth(self.text)
	local h = self.font:stringHeight(self.text)

	-- adjust for horz alignment
	if self.align.horz == of.ALIGN_HORZ_CENTER then
		x = x + math.floor(self.frame.width/2 - w/2)
	elseif self.align.horz == of.ALIGN_HORZ_RIGHT then
		x = x + math.floor(self.frame.width - w) - self.pad.horz
	else -- LEFT & IGNORED
		x = x + self.pad.horz
	end

	-- adjust for vert alignment
	if self.align.vert == of.ALIGN_VERT_CENTER then
		y = y + math.floor(self.frame.height/2 - h/2)
	elseif self.align.vert == of.ALIGN_VERT_BOTTOM then
		y = y + math.floor(self.frame.height - h) - self.pad.vert
	else -- TOP & IGNORED
		y = y + self.pad.vert
	end

	-- draw
	of.fill()
	self.font:drawString(self.text, x+self.textOffset.horz, y+self.textOffset.vert)
end

------------------------
-- View Change Callbacks
------------------------

-- calculates view sized based on label text, call after setting text to resize
function Label:layoutSubviews()
	local w = self.font:stringWidth(self.text)
	local h = self.font:stringHeight(self.text)
	if self.fontFixedWidth then
		-- min fixed char width
		local len = 0
		if utf8 then len = utf8.len(self.text) else len = string.len(self.text) end
		w = math.ceil(math.max(w, self:fixedCharWidth()*len) + self.pad.horz * 2)
	else
		-- variable char width
		w = math.floor(w + self.pad.horz * 2)
	end
	-- min line height
	h = math.floor(math.max(h, self.font:getLineHeight()) + self.pad.vert * 2)
	-- check min size
	if self.minsize then
		local size = self:sizeThatFits(w, h)
		if size.width < self.minsize.width then size.width = self.minsize.width end
		if size.height < self.minsize.height then size.height = self.minsize.height end
		self.frame.width = size.width
		self.frame.height = size.height
	else
		self.frame.width = w
		self.frame.height = h
	end
	View.layoutSubviews(self)
	self:updateClipping()
end

-------
-- Util
-------

-- width of a character when using a fixed width font
function Label:fixedCharWidth()
	return self.font:stringHeight("#")
end

return Label
