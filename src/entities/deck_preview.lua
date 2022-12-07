local class = require "libraries.hump.class"
local json = require "libraries.json.json"

local ui_element = require "src.entities.ui_element"
local sprite = require "src.sprites.deck_preview"

local decks_manager = require "src.managers.decks"

local deck_preview = class {
    __includes = ui_element,

    init = function (self, path_deck)
        local deck_name = path_deck:match("([^/\\]+)$")
        local deck = decks_manager:load(deck_name)
        local black_text = deck.blacks[love.math.random(#deck.blacks)].text
        local white_text = deck.whites[love.math.random(#deck.whites)]

        ui_element.init(self, sprite(deck_name, black_text, white_text))
    end,
}

return deck_preview