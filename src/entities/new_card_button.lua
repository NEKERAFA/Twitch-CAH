local class = require "libraries.hump.class"

local ui_element = require "src.entities.ui_element"
local sprite = require "src.sprites.new_card_button"

local new_card_button = class {
    __includes = ui_element,

    init = function (self)
        ui_element.init(self, sprite())
    end,

    getwidth = function (_)
        return sprite.width
    end,

    getheight = function (_)
        return sprite.height
    end
}

return new_card_button