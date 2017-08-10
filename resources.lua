-- VERSION     = resources 1.0.0
-- DESCRIPTION = loaf resource manager
-- URL         = http://github.com/danomatika/loaf-ingredients
-- LICENSE     =
--   Copyright (c) 2017 Dan Wilcox <danomatika@gmail.com> MIT License.
--   For information on usage and redistribution, and for a DISCLAIMER OF ALL
--   WARRANTIES, see the file, "LICENSE.txt," in this distribution.
--
-- based on sandwhich.lua: https://github.com/superzazu/sandwich.lua
local resources = {}

resources.resources = {} -- shared resources with ref count

-- create callbacks
local create = {
	font = function(path, size)
		local object = of.TrueTypeFont()
		if not object:load(path, size) then object = nil end
		return object
	end,
	image = function(path)
		local object = of.Image()
		if not object:load(path) then object = nil end
		return object
	end,
	video = function(path)
		local object = of.VideoPlayer()
		if not object:load(path) then object = nil end
		return object
	end,
	sound = function(path)
		local object = of.SoundPlayer()
		if not object:load(path) then object = nil end
		return object
	end
}

-- add a resource object with a unique name
-- returns nil if creation failed
function resources.add(type, name, ...)
	if not create[type] then print("resources: cannot add, unknown type: "..type) end
	if not resources.resources[type] then
		resources.resources[type] = {}
	end
	if not resources.resources[type][name] then
		local object = create[type](...)
		if not object then return nil end
		resources.resources[type][name] = {}
		resources.resources[type][name].object = object
		resources.resources[type][name].count = 0
		if loaf.isVerbose() then
			print("resources: added "..type.." "..name)
		end
	end
	resources.resources[type][name].count = resources.resources[type][name].count + 1
	return resources.resources[type][name].object
end

-- remove a resource object by its unique name
-- returns true if object deleted
function resources.remove(type, name)
	if not create[type] then print("resources: cannot remove, unknown type: "..type) end
	if not resources.resources[type] or not resources.resources[type][name] then return false end
	resources.resources[type][name].count = resources.resources[type][name].count - 1
	if resources.resources[type][name].count < 1 then
		resources.resources[type][name] = nil
		if loaf.isVerbose() then
			print("resources: removed "..type.." "..name)
		end
		return true
	end
	return false
end

-- get a resource object by its unique name
-- returns nil if object doesn't exist
function resources.get(type, name)
	if not create[type] then print("resources: cannot get, unknown type: "..type) end
	if resources.resources[type] and resources.resources[type][name] then
		return resources.resources[type][name].object
	end
	return nil
end

-- clear all shared resources
function resources.clear()
	resources.resources = {}
end

-- add a type create callback function, ie. something like
--     resources.addType("doodad",
--         function(path)
--             local object = Doodad()
--             if not object:load(path) then object = nil end
--             return object
--         end
--     )
-- callback should return loaded object or nil if object could not load
function resources.addType(type, callback)
    create[type] = callback
end

-- remove a type by clearing it's create callback
function resources.removeType(type)
	create[type] = nil
end

return resources
