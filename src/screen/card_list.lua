local scroller = require "src.entities.scroller"
local deck_preview = require "src.entities.deck_preview"
local new_deck_btn = require "src.entities.new_deck_button"

local decks_manager = require "src.managers.decks"

local card_list = {}

function card_list:enter()
    self:getdecks()
    self.sprite = scroller({ x = 32, y = 32 })
    self:renderpreviews()
end

function card_list:getdecks()
    -- Obtenemos la lista de mazos disponibles
    self.decks = decks_manager:list()
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