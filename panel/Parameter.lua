-- Copyright (c) 2024 Dan Wilcox <danomatika@gmail.com> MIT License.
-- For information on usage and redistribution, and for a DISCLAIMER OF ALL
-- WARRANTIES, see the file, "LICENSE.txt," in this distribution.

-- Parameter: number value wrapper
local Parameter = class()

-- value: number, initial value, default 0
-- min & max: numbers, value range, default 0 and 1
-- step: number, increment/decrement step amount, default 0.01
-- integer: bool, float or integer? default false (float)
function Parameter:__init(value, min, max, step, integer)
	self.value = value or 0 -- do not access directly, use set/get functions
	self.min = (min ~= nil and min or 0)
	self.max = (max ~= nil and max or 1)
	self.integer = (integer ~= nil and integer or false)
	self.step = (step ~= nil and step or 0.01) 
	self.numsteps = math.floor(math.abs(self.max - self.min) / self.step)
	self:set(value)
end

-- set value
function Parameter:set(v)
	self.value = of.clamp(v, self.min, self.max)
	if self.integer then -- round to nearest int
		self.value = math.floor(self.value + 0.5)
	end
end

-- get value
function Parameter:get()
	return self.value
end

-- set from normalized value 0 - 1
function Parameter:setNorm(v)
	self:set(of.map(v, 0, 1, self.min, self.max))
end

-- get as normalized value 0 - 1
function Parameter:getNorm()
	return of.map(self.value, self.min, self.max, 0, 1)
end

-- set mapped from a given input range
function Parameter:setRange(v, min, max)
	self:set(of.map(v, min, max, self.min, self.max))
	self.numsteps = (self.max - self.min) / self.step
end

-- get mapped to a given output range
function Parameter:getRange(min, max)
	return of.map(self.value, self.min, self.max, min, max)
end

-- set from step pos
function Parameter:getStep(s)
	self:set(s * self.numsteps)
end

-- get as step pos
function Parameter:getStep()
	return math.floor((self:getNorm() * self.numsteps) + 0.5)
end

-- go down one step
function Parameter:stepUp()
	return self:set(self:get() - self.step)
end

-- go up one step
function Parameter:stepDown()
	return self:set(self:get() + self.step)
end

-- convert value to string
function Parameter:__tostring()
	return string.format("%g", self:get())
end

return Parameter
