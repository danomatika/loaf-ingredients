-- VERSION     = hui 1.2.1
-- DESCRIPTION = loaf Hooey UI view hierarchy and window manager
-- URL         = http://github.com/danomatika/loaf-ingredients
-- LICENSE     =
--   Copyright (c) 2017 Dan Wilcox <danomatika@gmail.com> MIT License.
--   For information on usage and redistribution, and for a DISCLAIMER OF ALL
--   WARRANTIES, see the file, "LICENSE.txt," in this distribution.
--
-- based on Apple's iOS UIKit

local hui = {}

hui.prefix = (...):match("(.-)[^%.]+$") .. "hui."

-- core
hui.WindowManager = require(hui.prefix.."WindowManager")
hui.Window        = require(hui.prefix.."Window")
hui.View          = require(hui.prefix.."View")

-- addons
hui.Label         = require(hui.prefix.."Label")

return hui
