local class = require "libraries.hump.class"

local ui_element = require "src.entities.ui_element"
local sprite = require "src.sprites.new_deck_button"

local new_deck_button = class {
    __includes = ui_element,

    init = function (self)
        ui_element.init(self, sprite())
    end,
}

return new_deck_button