local class = require "libraries.hump.class"

local sprite = require "src.sprites.card"

local black_card_in = require "src.animations.black_card_in"
local white_card_in = require "src.animations.white_card_in"

local card = class {
    init = function(self, info, ismaster, position)
        self.position = { x = 0, y = 0 }
        self.rotation = 0
        self.ismaster = ismaster
        self.text = info.text
        self.pick = info.pick
        self.card = info.card
        self.position = position

        local text = self.text
        if not ismaster then
            text = string.format("%i. %s", self.position, text)
        end
        self.sprite = sprite(self.ismaster, text)

        if ismaster then
            black_card_in(self)
        else
            white_card_in(self, self.position)
        end
    end,

    draw = function(self)
        self.sprite:draw(self.position.x, self.position.y, self.rotation)
    end
}

return card