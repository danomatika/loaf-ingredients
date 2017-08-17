-- add up one level to search path since we're in a subfolder,
-- you won't need this if the script is above or at the same level
package.path = package.path .. ";../?.lua;../?/init.lua"

-- load the hui library aka the "Hooey UI"
local hui = require "hui"

-- create a window manager
manager = hui.WindowManager()

-- create a window with a given position and size
-- note the callback implementations which define behavior
-- callbacks can be set per instance or via subclassing (see below)
window1 = hui.Window(120, 80, 300, 300)
window1.backgroundColor = of.Color(220)
window1.border = 1
window1.borderColor = of.Color.darkGray
window1.mouseMoved = function(self, x, y)
	print("window1 moved "..x.." "..y)
end
window1.becameActive = function(self)
	self.borderColor = of.Color.red
end
window1.resignedActive = function(self)
	self.borderColor = of.Color.darkGray
end

-- create a view with a given position and size
-- this will be a subview within window1
-- note the numerous callback implementations which define behavior
-- you can type into the view when active, pressing enter prints the string
view1 = hui.View(10, 10, 200, 100)
view1.text = "Hooey UI"
view1.backgroundColor = of.Color(200, 100, 100)
view1.border = 1
--view1.clipsToBounds = true -- enable to clip bounds by drawing into an FBO
view1.mousePressed = function(self, x, y, button)
	print("view1 clicked: "..x.." "..y)
end
view1.mouseReleased = function(self, x, y, button)
	print("view1 released: "..x.." "..y)
end
view1.mouseEntered = function(self, x, y)
	self.backgroundColor = of.Color.gold
	print("view1 entered")
end
view1.mouseExited = function(self, x, y)
	self.backgroundColor = of.Color(200, 100, 100)
	print("view1 exited")
end
view1.draw = function(self)
	-- cusomt draw function via overriding
	hui.View.drawBackground(self)
	hui.View.drawSubviews(self)
	of.setColor(0)
	-- draw roughly centered text
	of.drawBitmapString(self.text, self.frame.width/2-string.len(self.text)*4,
		                           self.frame.height/2)
	hui.View.drawBorder(self)
end
view1.keyPressed = function(self, key)
	print("view1 pressed: "..key)
	if key == of.KEY_DEL then
		if string.len(self.text) > 0 then
			self.text = string.sub(self.text, 1, string.len(self.text)-1)
		end
	elseif key == of.KEY_RETURN then
		print(self.text)
		self.text = ""
	elseif key < 256 then
		self.text = self.text..string.char(key)
	end
end
view1.keyReleased = function(self, key)
	print("view1 released: "..key)
end
view1.becameActive = function(self)
	self.borderColor = of.Color.blue
	print("view 1 active")
end
view1.resignedActive = function(self)
	self.borderColor = nil
	print("view1 no longer active")
end

-- create a second view
-- this will be a subview of view1
-- you can type into the view when active
view2 = hui.View(10, 10, 50, 50)
view2.backgroundColor = of.Color(100, 100, 200)
view2.text = ""
view2.border = 1
view2.draw = function(self)
	hui.View.draw(self)
	of.setColor(0)
	of.drawBitmapString(self.text, self.frame.width/2, self.frame.height/2)
end
view2.keyPressed = function(self, key)
	if key < 256 then
		self.text = string.char(key)
	end
end
view2.mousePressed = function(self, x, y, button)
	print("view2 clicked: "..x.." "..y)
end
view2.mouseReleased = function(self, x, y, button)
	print("view2 released: "..x.." "..y)
end
view2.mouseEntered = function(self, x, y)
	view2.backgroundColor = of.Color.gold
	print("view2 entered: "..x.." "..y)
end
view2.mouseExited = function(self, x, y)
	view2.backgroundColor = of.Color(100, 100, 200)
	print("view2 exited: "..x.." "..y)
end
view2.becameActive = function(self)
	self.borderColor = of.Color.blue
	print("view2 active")
end
view2.resignedActive = function(self)
	self.borderColor = nil
	print("view2 no longer active")
end

-- custom hui.Window subclass
-- unlike the previous window creation method, this class an be easily reused
local MyWindow = class(hui.Window)
function MyWindow:__init(name, x, y, w, h)
	hui.Window.__init(self, x, y, w, h)
	self.backgroundColor = of.Color(220)
	self.border = 1
	self.borderColor = of.Color.darkGray
	self.name = name
end
function MyWindow:becameActive()
	self.borderColor = of.Color.red
	print(self.name.." active")
end
function MyWindow:resignedActive()
	self.borderColor = of.Color.darkGray
	print(self.name.." no longer active")
end

-- custom hui.View subclass
-- you can type into the view when active
-- unlike the previous view creation methods, this class an be easily reused
local MyView = class(hui.View)
function MyView:__init(name, x, y, w, h)
	hui.View.__init(self, x, y, w, h)
	self.backgroundColor = of.Color(100, 200, 100)
	self.border = 1
	self.name = name
	self.text = ""
end
function MyView:draw()
	hui.View.draw(self)
	of.setColor(0)
	of.drawBitmapString(self.text, self.frame.width/2, self.frame.height/2)
end
function MyView:keyPressed(key)
	print(self.name.." pressed: "..key)
	if key > 0 and key < 256 then
		self.text = string.char(key)
	end
end
function MyView:mouseEntered(x, y)
	view3.backgroundColor = of.Color.gold
	print(self.name.." entered")
end
function MyView:mouseExited(x, y)
	view3.backgroundColor = of.Color(100, 200, 100)
	print(self.name.." exited")
end
function MyView:becameActive()
	self.border = 1
	self.borderColor = of.Color.blue
	print(self.name.." active")
end
function MyView:resignedActive()
	self.borderColor = nil
	print(self.name.." no longer active")
end

-- create a second window using the MyWindow class
window2 = MyWindow("window2", 340, 120, 200, 200)

-- create a subview for window2 using the MyView class
view3 = MyView("view3", 50, 50, 100, 100)

------------
-- Main Loop
------------

function setup()
	of.setWindowTitle("huitest")

	-- add windows to window manager and
	-- views to windows or other views
	manager:addWindow(window1)
	window1:addSubview(view1)
	view1:addSubview(view2)

	manager:addWindow(window2)
	window2:addSubview(view3)

	-- set the active window and bring it forward
	manager:makeWindowActive(window2)
	manager:bringWindowToFront(window2)
end

function draw()
	manager:draw()
end

---------
-- Events
---------

function keyPressed(key)
	if of.getKeyPressed(of.KEY_SUPER) then -- SUPER is CMD/Windows Key
		if key == string.byte("n") then
			-- SUPER+n: next window
			local nextWindow = manager:windowAfter(manager.activeWindow)
			manager:makeWindowActive(nextWindow)
			manager:bringWindowToFront(nextWindow)
			return
		elseif key == string.byte("t") then
			-- SUPER+t: toggle current window fullscreen
			manager.activeWindow:toggleFullscreen()
			return
		end
	end
	manager:keyPressed(key)
end

function keyReleased(key)
	manager:keyReleased(key)
end

function mouseMoved(x, y)
	manager:mouseMoved(x, y)
end

function mouseDragged(x, y)
	manager:mouseDragged(x, y)
end

function mousePressed(x, y, button)
	manager:mousePressed(x, y, button)
end

function mouseReleased(x, y, button)
	manager:mouseReleased(x, y, button)
end

function windowResized(w, h)
	manager:windowResized(w, h)
end
