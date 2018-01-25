--   Copyright (c) 2017 Dan Wilcox <danomatika@gmail.com> MIT License.
--   For information on usage and redistribution, and for a DISCLAIMER OF ALL
--   WARRANTIES, see the file, "LICENSE.txt," in this distribution.

local WindowManager = class()

-- WindowManager: top-level Window container without size or position
function WindowManager:__init()
	self.windows = {}       -- child windows
	self.activeWindow = nil -- current active window receiving events
end

---------------------------------
-- Managing the Window Hierarchy
---------------------------------

-- add a window to the end of the list of windows
function WindowManager:addWindow(window)
	table.insert(self.windows, window)
	window.manager = self
end

-- move the specified window so that it appears on top of its siblings
function WindowManager:bringWindowToFront(window)
	local index = self:indexForWindow(window)
	if index == 0 then return end
	table.remove(self.windows, index)
	table.insert(self.windows, window) -- last is front
end

-- move the specified window so that it appears behind its siblings
function WindowManager:sendWindowToBack(window)
	local index = self:indexForWindow(window)
	if index == 0 then return end
	table.remove(self.windows, index)
	table.insert(self.windows, 1, window) -- first is bottom
end

-- remove a window from the list of windows
function WindowManager:removeWindow(window)
	local index = self:indexForWindow(window)
	if index == 0 then return end
	if window == self.activeWindow then
		self:makeWindowActive(nil)
	end
	table.remove(self.windows, index)
	window.manager = nil
end

-- insert a window above another window in the window hierarchy
function WindowManager:insertViewAbove(window1, window2)
	for i,window in ipairs(self.windows) do
		if window == window2 then
			table.insert(self.windows, i+1, window1)
			return
		end
	end
end

-- insert a window below another window in the window hierarchy
function WindowManager:insertWindowBelow(window1, window2)
	for i,window in ipairs(self.window) do
		if window == window2 then
			table.insert(self.windows, i, window1)
			return
		end
	end
end

-- exchange the windows at the specified indices
function WindowManager:exchangeWindows(window1, window2)
	local window1 = self.windows[index1]
	local window2 = self.windows[index2]
	self.windows[index1] = window2
	self.windows[index2] = window1
end

-- get the index for a window in the current window list
-- returns 0 if not found
function WindowManager:indexForWindow(window)
	for i=1,#self.windows do
		if self.windows[i] == window then
			return i
		end
	end
	return 0
end

-- get the previous window in the window list from the given window
-- returns nil if not found
function WindowManager:windowBefore(window)
	local index = self:indexForWindow(window)-1
	if index == 0 then return nil end
	if index < 1 then index = #self.windows end
	return self.windows[index]
end

-- get the next window in the window list from the given window
-- returns nil if not found
function WindowManager:windowAfter(window)
	local index = self:indexForWindow(window)+1
	if index == 0 then return nil end
	if index > #self.windows then index = 1 end
	return self.windows[index]
end

--------------------------------
-- Making Windows Receive Events
--------------------------------

-- set the window to receive events
-- set nil to deactivate current active window
function WindowManager:makeWindowActive(window)
	if self.activeWindow == window then return end
	if self.activeWindow then
		self.activeWindow.isActive = false
		self.activeWindow:makeSubviewActive(nil)
		self.activeWindow:resignedActive()
	end
	self.activeWindow = window
	if window then
		self.activeWindow.isActive = true
		self.activeWindow:becameActive()
	end
end

----------------------
-- Main Loop Callbacks
----------------------

-- update views
function WindowManager:update()
	for i=1,#self.windows do
		self.windows[i]:_update()
	end
end

-- draw all visible views
function WindowManager:draw()
	for i=1,#self.windows do
		self.windows[i]:_draw()
	end
end

------------------
-- Event Callbacks
------------------

-- send keyPressed to active window
function WindowManager:keyPressed(key)
	if self.activeWindow then
		self.activeWindow:_keyPressed(key)
	end
end

-- send keyReleased to active window
function WindowManager:keyReleased(key)
	if self.activeWindow then
		self.activeWindow:_keyReleased(key)
	end
end

-- send mouseMoved to active window
function WindowManager:mouseMoved(x, y)
	if self.activeWindow then
		self.activeWindow:_mouseMoved(x, y)
	end
end

-- send mouseDragged to active window,
-- uses global OF previous mouse pos unless overridden by setting the px & py
-- paramaters, ie. custom scaling of mouse positions, etc
function WindowManager:mouseDragged(x, y, px, py)
	if self.activeWindow then
		-- move window if click wasn't handled internally,
		-- window is moveable, there is no active subview,
		-- and window is moveable and not fullscreen
		if not self.activeWindow:_mouseDragged(x, y) and
		   not self.activeWindow.activeSubview and
		   not self.activeWindow.isFullscreen and
		   self.activeWindow.moveable then
		    if not px then px = of.getPreviousMouseX() end
		    if not py then py = of.getPreviousMouseY() end
			local dx = x - px
			local dy = y - py
			self.activeWindow.frame.x = self.activeWindow.frame.x + dx
			self.activeWindow.frame.y = self.activeWindow.frame.y + dy
		end
	end
end

-- send mousePressed to active window
function WindowManager:mousePressed(x, y, button)
	local window = self:hitTest(x, y)
	if window then
		if self.activeWindow ~= window then
			self:makeWindowActive(window)
			self:bringWindowToFront(window)
		end
		self.activeWindow:_mousePressed(x, y, button)
	else
		self:makeWindowActive(nil)
	end
end

-- send mouseReleased to active window
function WindowManager:mouseReleased(x, y, button)
	if self.activeWindow then
		self.activeWindow:_mouseReleased(x, y, button)
	end
end

-- resize any full screen windows and forward OF resize event to subviews
function WindowManager:windowResized(w, h)
	for i=1,#self.windows do
		self.windows[i]:_windowResized(w, h)
	end
end

------------------------
-- Hit Testing in a View
------------------------

-- return the farthest descendant of the receiver in the view hierarchy
-- (including itself) that contains a specified point
function WindowManager:hitTest(x, y)
	for i=#self.windows,1,-1 do
		local window = self.windows[i]
		if window:pointInside(x, y) then
			return window
		end
	end
	return nil
end

return WindowManager
