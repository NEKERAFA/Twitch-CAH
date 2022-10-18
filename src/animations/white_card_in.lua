local timer = require "libraries.hump.timer"

local white_card_in = function(card, position)
    local screen_width, screen_height = love.graphics.getDimensions()
    local card_center = math.floor(screen_width / 8 * (position * 2 - 1))
    card.position = { x = card_center, y = screen_height + 10 }
    card.rotation = 0
    local time = love.math.random() * 0.5 + 0.5
    timer.tween(time, card.position, { x = love.math.random(card_center - 10, card_center + 10) , y = screen_height - 20 - card.sprite.height }, "out-cubic")
    timer.tween(time, card, { rotation = love.math.random() * 0.6981317 - 0.34906585 }, "out-cubic")
end

return white_card_in