--   Copyright (c) 2017 Dan Wilcox <danomatika@gmail.com> MIT License.
--   For information on usage and redistribution, and for a DISCLAIMER OF ALL
--   WARRANTIES, see the file, "LICENSE.txt," in this distribution.

local thispath = select('1', ...):match(".+%.") or ""
local View = require(thispath.."View")

local Window = class(View)

-- Window: top-level View container with intrinsic size and positon
function Window:__init(x, y, w, h)
	View.__init(self, x, y, w, h)
	self.activeSubview = nil  -- the subview receiving input
	self.overSubview = nil    -- the subview the mouse is currently over
	self.manager = nil        -- parent window manager, if any
	self.isFullscreen = false -- is this a fullscreen window?
	self.window = self        -- for subviews
end

------------------------------
-- Managing the View Hierarchy
------------------------------

-- add a view to the end of the list of views
function Window:addSubview(view)
	view:movingToWindow(self)
	view.window = self
	View.addSubview(self, view)
	view:movedToWindow()
end

-- remove a view from the list of views
function Window:removeSubview(view)
	local index = self:indexForView(view)
	if index == 0 then return end -- not found
	view:movingToWindow(nil)
	if view == self.activeSubview then
		self:makeSubviewActive(nil)
	end
	view.window = nil
	view:movedToWindow()
end

---------------------------------
-- Making Subviews Receive Events
---------------------------------

-- set the window to receive mouse events
-- set nil to deactivate current active subview
function Window:makeSubviewActive(view)
	if self.activeSubview == view then return end
	if self.activeSubview then
		self.activeSubview.isActive = false
		self.activeSubview:resignedActive()
	end
	self.activeSubview = view
	if self.activeSubview then
		self.activeSubview.isActive = true
		self.activeSubview:becameActive()
	end
end

---------------------
-- Fullscreen Windows
---------------------

-- enable/disable fullscreen mode
function Window:enableFullscreen(value)
	if self.isFullscreen == value then return end
	if value then
		-- store windowed frame
		self._winframe = self.frame
		self.frame = of.Rectangle(0, 0, of.getWidth(), of.getHeight())
	else
		if self._winframe then
			-- reapply windowed frame
			self.frame = self._winframe
			self._winframe = nil
		end
	end
	self.isFullscreen = value
	self:layoutSubviews()
end

-- toggle between fullscreen and windowed mode
function Window:toggleFullscreen()
	self:enableFullscreen(not self.isFullscreen)
end

------------
-- Internal
------------

-- for internal use
-- override draw when subclassing
function Window:_draw()
	if self.isHidden then return end
	of.enableAlphaBlending()
	View._draw(self)
	of.disableAlphaBlending()
end

-- for internal use
-- override keyPressed when subclassing
function Window:_keyPressed(key)
	if self.activeSubview then
		self.activeSubview:keyPressed(key)
	end
	self:keyPressed(key)
end

-- for internal use
-- override keyReleased when subclassing
function Window:_keyReleased(key)
	if self.activeSubview then
		self.activeSubview:keyReleased(key)
	end
	self:keyReleased(key)
end

-- for internal use
-- override mouseMoved when subclassing
function Window:_mouseMoved(x, y)
	local point
	local view = self:hitTest(x, y)
	if view then
		if self.overSubview ~= view then
			if self.overSubview then
				-- exit old view
				point = View.convertPoint(x, y, nil, self.overSubview)
				self.overSubview:mouseExited(point.x, point.y)
			end
			-- enter new view
			point = View.convertPoint(x, y, nil, view)
			self.overSubview = view
			self.overSubview:mouseEntered(point.x, point.y)
		else
			point = View.convertPoint(x, y, nil, view)
		end
		view:mouseMoved(point.x, point.y)
	elseif self.overSubview then
		-- exit old view
		point = View.convertPoint(x, y, nil, view)
		self.overSubview:mouseExited(point.x, point.y)
		self.overSubview = nil
	end
end

-- for internal use
-- override mouseDragged when subclassing
-- returns true if a subview within the window handled the event
function Window:_mouseDragged(x, y)
	local handled = false
	local view = self:hitTest(x, y)
	if view then
		local point = View.convertPoint(x, y, nil, view)
		view:mouseDragged(point.x, point.y)
		if view ~= self then
			handled = true
		end
	end
	return handled
end

-- for internal use
-- override mousePressed when subclassing
function Window:_mousePressed(x, y, button)
	local point = of.Point(x, y)
	local view = self:hitTest(x, y)
	if view then
		if view ~= self then
			-- clicked in a subview
			self:makeSubviewActive(view)
		else
			-- clicked in the window
			self:makeSubviewActive(nil)
		end
		local point = View.convertPoint(x, y, nil, view)
		view:mousePressed(point.x, point.y, button)
	else
		-- clicked outside the window
		self:makeSubviewActive(nil)
	end
end

-- for internal use
-- override mouseReleased when subclassing
function Window:_mouseReleased(x, y, button)
	local point = of.Point(x, y)
	local view = self:hitTest(x, y)
	if view then
		local point = View.convertPoint(x, y, nil, view)
		view:mouseReleased(point.x, point.y, button)
	else
		self:makeSubviewActive(nil)
	end
end

-- for internal use
-- override windowResized function
-- this is the OF window event, it is not called when resizing a hui.Window
function Window:_windowResized(w, h)
	if self.isFullscreen then
		self.frame.width = w
		self.frame.height = h
		self:layoutSubviews()
	end
	self:windowResized(w, h)
end

return Window
