-- VERSION     = panel 0.1.0
-- DESCRIPTION = gui parameter panel inspired by ofxGui, requires the hui lib
-- URL         = http://github.com/danomatika/loaf-ingredients
-- LICENSE     =
--   Copyright (c) 2024 Dan Wilcox <danomatika@gmail.com> MIT License.
--   For information on usage and redistribution, and for a DISCLAIMER OF ALL
--   WARRANTIES, see the file, "LICENSE.txt," in this distribution.

local panel = {}

panel.prefix = (...):match("(.-)[^%.]+$") .. "panel."

panel.Panel     = require(panel.prefix.."Panel")
panel.Parameter = require(panel.prefix.."Parameter")
panel.Slider    = require(panel.prefix.."Slider")

return panel
