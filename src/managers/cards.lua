local json = require "libraries.json.json"

local decks_manager = require "src.managers.decks"
local table_utils = require "src.utils.table"

local cards = {
    selected = {
        blacks = {},
        whites = {},
    }
}

function cards:new(deck_name)
    self.name = deck_name
    self.blacks = {}
    self.whites = {}
end

function cards:load(deck_name)
    local deck = decks_manager:load(deck_name or "default", false)
    self.name = deck_name
    self.blacks = deck.blacks
    self.whites = deck.whites
end

function cards:save()
    decks_manager:updatedeck(self.name, self.blacks, self.whites, false)
end

function cards:addwhite(text)
    local id = #self.whites
    table.insert(self.whites, text)
    return id
end

function cards:removewhite(id)
    table.remove(self.whites, id)
end

function cards:updatewhite(id, new_text)
    self.whites[id] = new_text
end

function cards:addblack(text, picked_cards)
    local id = #self.blacks
    table.insert(self.blacks, { text = text, pick = picked_cards })
    return id
end

function cards:removeblack(id)
    table.remove(self.blacks, id)
end

function cards:updateblacktext(id, new_text)
    self.blacks[id].text = new_text
end

function cards:updateblackpickedcards(id, picked_cards)
    self.blacks[id].pick = picked_cards
end

function cards:selectblack()
    local blacks_size = table_utils.size(self.blacks)
    -- Si se vacía la lista de cartas a jugar, volvemos a insertar las descartadas
    if blacks_size == 0 then
        for _, card in ipairs(self.selected.blacks) do
            table.insert(self.blacks, card)
        end

        blacks_size = table_utils.size(self.blacks)
        self.selected.blacks = {}
    end

    local selected = love.math.random(blacks_size)
    local card = self.blacks[selected]

    -- Descartamos la carta elegida
    table.insert(self.selected.blacks, card)
    table.remove(self.blacks, selected)

    -- debug
    print(string.format("black card: %s", json.encode(card)))

    return card
end

function cards:selectwhites()
    -- Si nos hemos quedado sin cartas para jugar, cogemos del descarte
    if table_utils.size(self.whites) == 0 then
        for _, card in ipairs(self.selected.whites) do
            table.insert(self.whites, card)
        end

        self.selected.whites = {}
    end

    local selected = table_utils.pick(self.whites, 4)
    local selected_cards = {}

    for _, card in ipairs(selected) do
        table.insert(selected_cards, { card = card, text = self.whites[card] })
    end

    -- debug
    print(string.format("white cards: %s", json.encode(selected_cards)))

    return selected_cards
end

function cards:pickwhite(selected)
    local card = self.whites[selected]

    table.insert(self.selected.whites, card)
    table.remove(self.whites, selected)

    -- debug
    print(string.format("white card: %s", json.encode(card)))

    return card
end

return cards
