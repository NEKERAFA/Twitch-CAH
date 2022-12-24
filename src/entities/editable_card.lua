local utf8 = require "utf8"

local class = require "libraries.hump.class"

local ui_element = require "src.entities.ui_element"
local sprite = require "src.sprites.card"

local editable_card = class {
    __includes = ui_element,

    init = function (self, ismaster, text, pick)
        ui_element.init(self, sprite(ismaster, text))
    end,

    getwidth = function (self)
        return math.floor(ui_element.getWidth(self) / 2)
    end,

    getheight = function (self)
        return math.floor(ui_element.getHeight(self) / 2)
    end
}

return editable_card