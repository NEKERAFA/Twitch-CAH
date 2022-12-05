local class = require "libraries.hump.class"
local json = require "libraries.json.json"

local ui_element = require "src.entities.ui_element"
local sprite = require "src.sprites.deck_preview"

local deck_preview = class {
    __includes = ui_element,

    init = function (self, path_deck)
        local black_cards = json.decode(assert(love.filesystem.read(("%s/black_cards.json"):format(path_deck))))
        local black_text = black_cards[love.math.random(#black_cards)].text

        local white_cards = json.decode(assert(love.filesystem.read(("%s/white_cards.json"):format(path_deck))))
        local white_text = white_cards[love.math.random(#white_cards)]

        local deck_name = path_deck:match("([^/\\]+)$")

        ui_element.init(self, sprite(deck_name, black_text, white_text))
    end,
}

return deck_preview