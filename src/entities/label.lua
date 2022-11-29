local class = require "libraries.hump.class"

local ui_element = require "src.entities.ui_element"
local sprite = require "src.sprites.label"

local label = class {
    __includes = ui_element,

    init = function (self, text, font_style, font_size)
        ui_element.init(self, sprite(text, font_style, font_size))
    end
}

return label