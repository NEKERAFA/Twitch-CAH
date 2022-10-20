local timer = require "libraries.hump.timer"

local math_utils = require "src.utils.math"

local screen_width, screen_height = love.graphics.getDimensions()

local white_card_in = function(card)
    local card_center = math.floor(screen_width / 8 * (card.index * 2 - 1))
    card.position = { x = card_center, y = screen_height + 10 }
    card.rotation = 0
    timer.tween(card.time, card.position, { x = love.math.random(card_center - 5, card_center + 5) , y = screen_height - 20 - card.sprite.height }, "out-cubic")
    timer.tween(card.time, card, { rotation = love.math.random() * math_utils.degtorad(10) - math_utils.degtorad(5) }, "out-cubic")
end

return white_card_in