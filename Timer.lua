-- VERSION     = Timer 1.0.0
-- DESCRIPTION = simple millisecond timer
-- URL         = http://github.com/danomatika/loaf-ingredients
-- LICENSE     =
--   Copyright (c) 2017 Dan Wilcox <danomatika@gmail.com> MIT License.
--   For information on usage and redistribution, and for a DISCLAIMER OF ALL
--   WARRANTIES, see the file, "LICENSE.txt," in this distribution.

local Timer = class()

-- a simple millisecond timer
function Timer:__init(alarmTime)
	self.alarmMS = 0   --  milliseconds before alarm
	self.timestamp = 0 -- current timestamp
	self:set()
	if alarmTime then self.alarmMS = alarmTime end
end

-- set the timestamp to the current time
function Timer:set()
	self.timestamp = of.getElapsedTimeMillis()
end

-- set the timestamp and how many ms in the future the alarm should go off
function Timer:setAlarm(alarmTime)
	self:set()
	self.alarmMS = alarmTime
end

-- has the alarm gone off?
function Timer:alarm()
	return of.getElapsedTimeMillis() >= self.timestamp + self.alarmMS
end

-- how many ms have expired since the timestamp was last set
function Timer:getDiff()
	return of.getElapsedTimeMillis() - self.timestamp
end

-- get the normalized difference using the current alarm time
function Timer:getDiffN()
	return getDiff() / self.alarmMS
end

return Timer
