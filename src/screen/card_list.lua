local scroller = require "src.entities.scroller"
local deck_preview = require "src.entities.deck_preview"
local new_deck_btn = require "src.entities.new_deck_button"

local card_list = {}

function card_list:enter()
    self:getdecks()
    self.sprite = scroller({ x = 32, y = 32 })
    self:renderpreviews()
end

function card_list:getdecks()
    self.decks = {}

    -- Obtenemos los mazos por defecto
    local system_decks = love.filesystem.getDirectoryItems("data")
    for _, item in pairs(system_decks) do
        table.insert(self.decks, ("data/%s"):format(item))
    end

    -- Obtenemos los mazos guardados por el jugador
    local user_decks = love.filesystem.getDirectoryItems("Saved Desks")
    for _, item in pairs(user_decks) do
        table.insert(self.decks, ("%s/%s"):format("Saved Desks", item))
    end

    -- Los ordenamos por nombre del mazo
    table.sort(self.decks)
end

function card_list:renderpreviews()
    for i, deck in ipairs(self.decks) do
        local item = deck_preview(deck)
        item:move(((i) % 4) * 149, math.floor((i) / 4) * 144)
        self.sprite:addelement(item)
    end

    self.sprite:addelement(new_deck_btn())
end

function card_list:mousemoved(mx, my)
    self.sprite:onmousemoved(mx, my)
end

function card_list:draw()
    self.sprite:draw()
end

return card_list