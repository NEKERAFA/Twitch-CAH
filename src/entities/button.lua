local class = require "libraries.hump.class"

local ui_element = require "src.entities.ui_element"
local sprite = require "src.sprites.button"

local button = class {
    __includes = ui_element,
    size = sprite.size,

    init = function (self, text, font_style, font_size)
        ui_element.init(self, sprite(text, font_style, font_size))
    end,

    getwidth = function (self)
        return self.sprite.width
    end,

    getheight = function ()
        return sprite.size
    end
}

return button