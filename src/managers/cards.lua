local json = require "libraries.json.json"

local table_utils = require "src.utils.table"

local cards = {
    selected = {
        blacks = {},
        whites = {},
    }
}

function cards:load()
    self.blacks = json.decode(assert(love.filesystem.read("data/black_cards.json")))
    self.whites = json.decode(assert(love.filesystem.read("data/white_cards.json")))
end

function cards:selectblack()
    local selected = love.math.random(table_utils.size(self.blacks))
    local card = self.blacks[selected]
    
    table.insert(self.selected.blacks, selected)

    -- debug
    print(string.format("black card: %q", json.encode(card)))

    return card
end

function cards:selectwhites()
    local selected = table_utils.pick(self.whites, 4)
    local cards = {}

    for _, card in ipairs(selected) do
        table.insert(cards, { card = card, text = self.whites[card] })
    end

    print(string.format("white cards: %q", json.encode(cards)))

    return cards
end

function cards:pickwhite(card)
    local selected = self.whites[card]

    table.insert(self.selected.whites, selected)
end

return cards
