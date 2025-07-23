-- Copyright (c) 2024 Dan Wilcox <danomatika@gmail.com> MIT License.
-- For information on usage and redistribution, and for a DISCLAIMER OF ALL
-- WARRANTIES, see the file, "LICENSE.txt," in this distribution.

package.path = package.path .. ";../?.lua;../?/init.lua"

local hui = require "hui"

-- Slider: horizontal parameter slider
local Slider = class(hui.Label)

-- param: Parameter, associated parameter, required
-- name: string, display name, default ""
-- x & y: numbers, position
-- w & h: numbers, size
function Slider:__init(param, name, x, y, w, h)
	hui.Label.__init(self, x, y, w, h)

	self.param = param -- associated parameter
	self.name = (name ~= nil and name or "") -- display name
	self.controlPos = self.param:getNorm() -- normalized control pos
	self.prevPos = 0 -- normalized prev mouse pos

	self.backgroundColor = of.Color(0, 0, 0, 200)
	self.align.vert = of.ALIGN_VERT_CENTER
	self:updateText()
end

function Slider:draw()
	self:drawBackground()

	local x = self.param:getRange(0, self.frame.width)
	x = of.clamp(x, 2, self.frame.width-3)
	of.setColor(120)
	of.drawRectangle(x-1, 2, 3, self.frame.height-4)

	of.setColor(255)
	self:drawText()
	self:drawBorder()
end

function Slider:mousePressed(x, y, button)
	self.textColor = of.Color(255)
	self.editing = true
	self.prevPos = self:computePos(x)
end

function Slider:mouseDragged(x, y, button)
	if not self.editing then return end

	-- update pos by calculating step diff from previous pos
	local pos = self:computePos(x)
	local dx = pos - self.prevPos -- find diff
	if dx == 0 then return end -- no diff, so bail
	self.prevPos = pos
	self.controlPos = of.clamp(self.controlPos + dx, 0, 1)
	self.param:setRange(self.controlPos, 0, 1)

	-- update label
	self:updateText()
end

function Slider:mouseReleased(x, y, button)
	self.textColor = of.Color(255, 0, 0)
	self.editing = false
	self.prevPos = 0 -- reset
end

-- highlight on mouse hover
function Slider:mouseEntered(x, y)
	self.over = true
end

-- disable highlight
function Slider:mouseExited(x, y)
	self.over = false
end

-- compute normalized pos from horz x value
function Slider:computePos(x)
	x = x - (self.frame.width / 2) -- zero to middle of frame
	local pos = of.map(x, 0, self.frame.width, 0, self.param.numsteps)
	pos = math.floor(pos + 0.5) -- round to nearest step
	pos = of.map(pos, 0, self.param.numsteps, 0, 1) -- normalize
	return pos
end

-- update label name and value
function Slider:updateText()
	if self.name == "" then
		self.text = tostring(self.param)
	else
		self.text = self.name .." "..tostring(self.param)
	end
end

return Slider
