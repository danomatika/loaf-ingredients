loaf-ingredients
================

A set of useful Lua classes & libraries for projects using loaf: <http://danomatika.com/code/loaf>

>loaf is an interpreter for [openFrameworks](http://openframeworks.cc/) which allows you to write OF applications in the [Lua](http://www.lua.org/) scripting language. This means you can quickly create using openFrameworks but without having to compile C++ or use a heavy IDE like Xcode or Visual Studio. A built-in OSC (Open Sound Control) server enables loaf to communicate natively with other creative coding and music applications over a network connection.

[Dan Wilcox](http://danomatika.com) 2017

Usage
-----

Download or clone this repository and place the .lua files and/or subfolders you want to use into a folder in your project, say "libs". To use the loaf resource manager, you might have the following project layout:

    project/libs/resources.lua
    project/assets/hellokitty.png
    project/main.lua

In main.lua, you can then import and use resources.lua via the require keyword:

    local resources = "libs.resources"
    local image = resources.add("hellokitty", "assets/hellokitty.png")

Note the "libs.resources" which includes the "libs" subfolder. The same is true for libraries within a folder as require will automatically search for an init.lua file as well.

Ingredients List
----------------

The ingredients are a mix of traditional Lua tables and reusable loaf class objects. The naming convention followed is for classes to begin with uppercase letters.

* resources: a loaf resource manager
* SimpleSprite: simple sprite animation class using a sprite sheet
* Scaler: a loaf 2d render scaler class
