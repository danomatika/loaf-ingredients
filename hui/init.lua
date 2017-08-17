-- VERSION     = hui 1.0.0
-- DESCRIPTION = loaf Hooey UI view hierarchy and window manager
-- URL         = http://github.com/danomatika/loaf-ingredients
-- LICENSE     =
--   Copyright (c) 2017 Dan Wilcox <danomatika@gmail.com> MIT License.
--   For information on usage and redistribution, and for a DISCLAIMER OF ALL
--   WARRANTIES, see the file, "LICENSE.txt," in this distribution.
--
-- based on Apple's iOS UIKit
local hui = {}

hui.WindowManager = require "hui.WindowManager"
hui.Window        = require "hui.Window"
hui.View          = require "hui.View"

return hui
