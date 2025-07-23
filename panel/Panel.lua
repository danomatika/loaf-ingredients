-- Copyright (c) 2024 Dan Wilcox <danomatika@gmail.com> MIT License.
-- For information on usage and redistribution, and for a DISCLAIMER OF ALL
-- WARRANTIES, see the file, "LICENSE.txt," in this distribution.

package.path = package.path .. ";../?.lua;../?/init.lua"

local hui = require "hui"

-- Panel: simple vertical gui panel inspired by ofxGui
local Panel = class(hui.Window)

-- x & y: numbers, position, default 5,5
-- w & h: numbers, size, default 130x? as h grows with number of rows
function Panel:__init(x, y, w, h)
	hui.Window.__init(self, x or 5, y or 5, w or 130, h)
	self.backgroundColor = of.Color(220, 220, 220, 120)
	self.padding = 5
	self.paramHeight = 30
	if self.frame.height == 0 then
		self.frame.height = self.padding
	end
end

-- add a text label row
function Panel:addLabel(text)
	local l = hui.Label()
	l.text = text
	l:sizeToFit()
	l.align.vert = of.ALIGN_VERT_CENTER
	self:add(l)
	self.frame.height = self.frame.height + l.frame.height + self.padding
end

--- add a slider row
function Panel:addSlider(s)
	self:add(s)
	self.frame.height = self.frame.height + s.frame.height + self.padding
end

-- add a hui subview
function Panel:add(v)
	local x = self.padding
	local y = self.padding
	local last = self.subviews[#self.subviews]
	if last then
		y = last.frame.y + last.frame.height + self.padding
	end
	self:addSubview(v)
	v.frame.x = x
	v.frame.y = y
	v.frame.width = self.frame.width - (self.padding * 2)
	v.minsize = {width = v.frame.width, height = self.paramHeight}
	v:layoutSubviews()
end

return Panel
