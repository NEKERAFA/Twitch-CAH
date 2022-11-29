local draw_utils = require "src.utils.draw"

local card = require "src.entities.card"

local game = {
    player = nil,
    black = nil,
    cards = {},
    votes = {count = 0}
}

function game:set_player(player)
    self.player = player
end

function game:clear_player()
    self.player = nil
end

function game:get_card_time()
    return love.math.random() * 0.5 + 0.5
end

function game:set_back(info)
    local time = game:get_card_time()
    self.black = card(info, true, time)
    return time
end

function game:discard_back()
    self.black:discard()
end

function game:clear_back()
    self.black:release()
    self.black = nil
end

function game:add_card(info, index)
    local time = game:get_card_time()
    table.insert(self.cards, card(info, false, time, index))
    return time
end

function game:pick_card(index)
    self.cards[index]:pick()
end

function game:discard_card(index)
    self.cards[index]:discard()
end

function game:clear_cards()
    for _, entity in ipairs(self.cards) do
        entity:release()
    end

    self.cards = {}
end

function game:draw(color)
    if self.black then
        self.black:draw()
    end

    if self.player then
        draw_utils.print_text(("¡Te toca, %s! Elige una de las de abajo"):format(self.player), 10, 170)
    end

    local old_color = {love.graphics.getColor()}
    love.graphics.setColor(color)
    if self.cards then
        for _, entity in ipairs(self.cards) do
            entity:draw()
        end
    end
    love.graphics.setColor(old_color)
end

return game