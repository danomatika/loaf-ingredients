--   Copyright (c) 2017 Dan Wilcox <danomatika@gmail.com> MIT License.
--   For information on usage and redistribution, and for a DISCLAIMER OF ALL
--   WARRANTIES, see the file, "LICENSE.txt," in this distribution.

local View = class()

-- View: manages the content for a rectangular area on the screen
function View:__init(x, y, w, h)
	self.frame = of.Rectangle()    -- view rectangle within superview frame
	self.subviews = {}             -- child views
	self.superview = nil           -- parent view, nil if none
	self.window = nil              -- parent window, nil if none
	self.backgroundColor = nil     -- background color, ignored when nil
	self.isActive = false          -- is this view receiving mouse events?
	self.isHidden = false          -- hide the view?
	self.interactionEnabled = true -- does the view handle interaction events?
	self.clipsToBounds = false     -- clip content outside the view bounds?
	self.border = 0                -- border width, ignored when 0
	self.borderColor = nil         -- border color, ignored when nil
	if x then
		if type(x) == "number" then
			-- regular number
			self.frame.x = x
		else
			-- assume rectangle object
			self.frame = x
		end
	end
	if y then self.frame.y = y end
	if w then self.frame.width = w end
	if h then self.frame.height = h end
end

----------------------
-- Main Loop Callbacks
----------------------

-- override when subclassing
function View:update() end

-- draw background, subviews, and border
function View:draw()
	self:drawBackground()
	self:drawSubviews()
	self:drawBorder()
end

-----------------
-- Draw Callbacks
-----------------

-- draws the background
-- override when subclassing
function View:drawBackground()
	if self.backgroundColor then
		of.setColor(self.backgroundColor)
		of.fill()
		of.drawRectangle(0, 0, self.frame.width, self.frame.height)
	end
end

-- draws subviews
-- ovveride when subclassing
function View:drawSubviews()
	for i=1,#self.subviews do
		self.subviews[i]:_draw()
	end
end

-- draws the border
-- override when subclassing
function View:drawBorder()
	if self.border > 0 and self.borderColor then
		of.setColor(self.borderColor)
		of.noFill()
		of.setLineWidth(self.border)
		of.drawRectangle(0, 0, self.frame.width, self.frame.height)
		of.setLineWidth(1)
	end
end

------------------
-- Event Callbacks
------------------

-- implement these when subclassing
function View:keyPressed(key) end
function View:keyReleased(key) end
function View:mouseMoved(x, y) end
function View:mouseDragged(x, y) end
function View:mousePressed(x, y, button) end
function View:mouseReleased(x, y, button) end
function View:mouseEntered(x, y) end
function View:mouseExited(x, y) end

-- this is the OF window event, it is not called when resizing a hui.Window
-- override when subclassing
function View:windowResized(w, h)
	for i=1,#self.subviews do
		self.subviews[i]:windowResized(w, h)
	end
end

------------------------
-- View Change Callbacks
------------------------

-- tell the view to layout it's subviews
-- override when subclassing
function View:layoutSubviews()
	for i=1,#self.subviews do
		self.subviews[i]:layoutSubviews()
	end
end

-- tell the view that a subview was added
-- override when subclassing
function View:addedSubview(view)
	for i=1,#self.subviews do
		self.subviews[i]:addedSubview(view)
	end
end

-- tell the view that a subview is about to be removed
-- override when subclassing
function View:removingSubview(view)
	for i=1,#self.subviews do
		self.subviews[i]:removingSubview(view)
	end
end

-- tell the view that a subview has been removed
-- override when subclassing
function View:removedSubview(view)
	for i=1,#self.subviews do
		self.subviews[i]:removedSubview(view)
	end
end

-- tell the view that its superview is about to change to the specified superview
-- override when subclassing
function View:movingToSuperview(view)
	for i=1,#self.subviews do
		self.subviews[i]:movingToSuperview(view)
	end
end

-- tell the view that its superview changed
-- override when subclassing
function View:movedToSuperview()
	for i=1,#self.subviews do
		self.subviews[i].superview = self
		self.subviews[i].window = self.window
		self.subviews[i]:movedToSuperview()
	end
end

-- tell the view that its window object is about to change
-- override when subclassing
function View:movingToWindow(window)
	for i=1,#self.subviews do
		self.subviews[i]:movingToWindow(window)
	end
end

-- tell the view that its window object changed
-- override when subclassing
function View:movedToWindow()
	for i=1,#self.subviews do
		self.subviews[i].window = self.window
		self.subviews[i]:movedToWindow()
	end
end

-- inform the view that is has become the active view
-- override when subclassing
function View:becameActive() end

-- inform the view that it is no longer the active view
-- override when subclassing
function View:resignedActive() end

------------------------------
-- Managing the View Hierarchy
------------------------------

-- add a view to the end of the list of subviews
function View:addSubview(view)
	self:insertSubview(view, #self.subviews+1)
end

-- move the specified subview so that it appears on top of its siblings
function View:bringSubviewToFront(view)
	local index = self:indexForSubview(view)
	if index == 0 then return end -- not found
	table.remove(self.subviews, index)
	table.insert(self.subviews, view) -- last is front
end

-- move the specified subview so that it appears behind its siblings
function View:sendSubviewToBack(view)
	local index = self:indexForSubview(view)
	if index == 0 then return end -- not found
	table.remove(self.subviews, index)
	table.insert(self.subviews, 1, view) -- first is bottom
end

-- remove the view from its superview
function View:removeFromSuperview()
	if not self.superview then return end
	local index = self.superview:indexForSubview(self)
	if index == 0 then return end -- not found
	local super = self.superview
	if super then super:removingSubview(self) end
	self:movingToSuperview(nil)
	table.remove(self.superview.subviews, index)
	self.superview = nil
	self.window = nil
	self:movedToSuperview()
	if super then super:removedSubview(self) end
end

-- insert a subview at the specified index
function View:insertSubview(view, index)
	local exists = self:indexForSubview(view)
	if exists > 0 then
		-- already exists
		table.remove(self.subviews, exists)
		table.insert(self.subviews, index-1, view)
	else
		-- adding
		if view.superview then view:removeFromSuperview() end
		view:movingToSuperview(self)
		view.superview = self
		view.window = self.window
		table.insert(self.subviews, index, view)
		view:movedToSuperview()
		view:layoutSubviews()
		self:addedSubview(view)
	end
end

-- insert a subview above another subview in the view hierarchy
function View:insertSubviewAbove(view1, view2)
	for i,view in ipairs(self.subviews) do
		if view == view2 then
			self:insertSubview(view1, i+1)
			return
		end
	end
end

-- insert a subview below another subview in the view hierarchy
function View:insertSubviewBelow(view1, view2)
	for i,view in ipairs(self.subviews) do
		if view == view2 then
			self:insertSubview(view1, i)
			return
		end
	end
end

-- exchange the subviews at the specified indices
function View:exchangeSubviews(index1, index2)
	local view1 = self.subviews[index1]
	local view2 = self.subviews[index2]
	self.subviews[index1] = view2
	self.subviews[index2] = view1
end

-- returns true if the receiver is a subview of a given view or
-- identical to that view
function View:isDescendantOf(view)
	if self == view then return true end
	if self.superview then
		return self.superview:isDescendantOf(view)
	end
	return false
end

-- get the index for a subview in the current subviews list
-- returns 0 if not found
function View:indexForSubview(view)
	for i=1,#self.subviews do
		if self.subviews[i] == view then
			return i
		end
	end
	return 0
end

-- get the previous window in the window list from the given window
-- set interaction to true to ignore subviews without interaction
-- returns nil if not found
function View:subviewBefore(view, interaction)
	local index = self:indexForSubview(view)
	if index == 0 then return nil end
	local newindex = index - 1
	while newindex ~= index do
		if newindex < 1 then newindex = #self.subviews end
		if not interaction or self.subviews[newindex].interactionEnabled then
			break
		end
		newindex = newindex - 1
	end
	return self.subviews[newindex]
end

-- get the next window in the window list from the given window
-- set interaction to true to ignore subviews without interaction
-- returns nil if not found
function View:subviewAfter(view, interaction)
	local index = self:indexForSubview(view)
	if index == 0 then return nil end
	local newindex = index + 1
	while newindex ~= index do
		if newindex > #self.subviews then newindex = 1 end
		if not interaction or self.subviews[newindex].interactionEnabled then
			break
		end
		newindex = newindex + 1
	end
	print(newindex)
	return self.subviews[newindex]
end

----------------
-- View Clipping
----------------

-- enable/disable bounds clipping
-- note: uses an fbo internally when enabled,
--       set antialias to true to enable linear texture scaling
function View:enableClipping(value, antialias)
	if value == self.clipsToBounds then return end
	-- create or delete clipping fbo
	if value then
		local filter = of.NEAREST
		if antialias then filter = of.LINEAR end
		local fbo = of.Fbo()
		fbo:allocate(self.frame.width, self.frame.height)
		fbo:getTexture():setTextureMinMagFilter(filter, filter)
		self._fbo = fbo
	else
		self._fbo = nil
	end
	self.clipsToBounds = value
end

-- update the bounds clipping fbo
-- call this after changing the frame size
function View:updateClipping()
	if not self.clipsToBounds then return end
	-- make sure to carry filters over
	local minFilter = self._fbo:getTexture():getTextureData().minFilter
	local magFilter = self._fbo:getTexture():getTextureData().magFilter
	self._fbo:allocate(self.frame.width, self.frame.height)
	self._fbo:getTexture():setTextureMinMagFilter(minFilter, magFilter)
end

---------
-- Sizing
---------

-- calculate and return the size that best fits the specified size
-- returns value as a table: {width, height}
function View:sizeThatFits(width, height)
	local frame = of.Rectangle(self.frame)
	frame:growToInclude(of.Rectangle(self.frame.x, self.frame.y, width, height))
	return {width=frame.width, height=frame.height}
end

-- resizes and moves the view so it encloses its subviews
function View:sizeToFit()
	for _,view in ipairs(self.subviews) do
		self.frame:growToInclude(self:convertRect(view.frame, view, self))
	end
end

--------------
-- Positioning
--------------

-- set the position of the view centered at a given point
function View:centerAt(x, y)
	self.frame:setFromCenter(x, y, self.frame.width, self.frame.height)
end

---------------------------------------------
-- Converting Between View Coordinate Systems
---------------------------------------------

-- convert a point from one view coordinate system to another
-- setting a view to nil denotes screen level
function View.convertPoint(x, y, viewFrom, viewTo)
	local p = of.Point(x, y)
	if viewTo == viewFrom then return p end
	-- viewTo is subchild of viewFrom
	local bottom = viewTo
	local top = viewFrom
	local subtract = true
	if viewFrom and viewFrom:isDescendantOf(viewTo) then
		-- viewFrom is subchild of viewTo
		bottom = viewFrom
		top = viewTo
		subtract = false
	end
	-- flip if bottom starts at nil
	if not bottom then
		local oldbottom = bottom
		bottom = top
		top = oldbottom
		subtract = not subtract
	end
	-- walk up the view hierachy
	if subtract then
		while bottom and bottom ~= top do
			p.x = p.x - bottom.frame.x
			p.y = p.y - bottom.frame.y
			bottom = bottom.superview
		end
	else
		while bottom and bottom.superview ~= top do
			p.x = p.x + bottom.superview.frame.x
			p.y = p.y + bottom.superview.frame.y
			bottom = bottom.superview
		end
	end
	return p
end

-- convert a point from one view coordinate system to another
-- setting a view to nil denotes screen level
function View.convertRect(rect, viewFrom, viewTo)
	local point = View.convertPoint(rect.x, rect.y, viewFrom, viewTo)
	return of.Rectangle(point.x, point.y, rect.width, rect.height)
end

------------------------
-- Hit Testing in a View
------------------------

-- return the farthest descendant of the receiver in the view hierarchy
-- (including itself) that contains a specified point in it's coordinate system
function View:hitTest(x, y)
	if self.isHidden or not self.interactionEnabled then return nil end
	if not self.frame:inside(x, y) then return nil end
	for i=#self.subviews,1,-1 do
		local view = self.subviews[i]:hitTest(x - self.frame.x, y - self.frame.y)
		if view then return view end
	end
	return self
end

-- returns true if the receiver contains the specified point
function View:pointInside(x, y)
	return self.frame:inside(x, y)
end

-----------
-- Internal
-----------

-- internal update function
-- override update when subclassing
function View:_update()
	self:update()
	for i=1,#self.subviews do
		self.subviews[i]:_update()
	end
end

-- internal draw function
-- override draw when subclassing
function View:_draw()
	if self.isHidden then return end
	if self.clipsToBounds then
		-- draw into an fbo to clip the bounds
		local fbo = self._fbo
		if not fbo then
			fbo = of.Fbo()
			fbo:allocate(self.frame.width, self.frame.height)
			fbo:getTexture():setTextureMinMagFilter(of.LINEAR, of.LINEAR)
			self._fbo = fbo
		end
		of.pushMatrix()
		of.translate(self.frame.x, self.frame.y)
		fbo:beginFbo()
		self:draw()
		fbo:endFbo()
		of.setColor(255)
		fbo:draw(0, 0)
		of.popMatrix()
	else
		-- draw normally
		of.pushMatrix()
		of.translate(self.frame.x, self.frame.y)
		self:draw()
		of.popMatrix()
	end
end

return View
