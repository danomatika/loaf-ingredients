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

local thispath = select('1', ...):match(".+%.") or ""
hui.WindowManager = require(thispath.."hui.WindowManager")
hui.Window        = require(thispath.."hui.Window")
hui.View          = require(thispath.."hui.View")

return hui
