local timer = require "libraries.hump.timer"

local math_utils = require "src.utils.math"

local black_card_in = function(card)
    local center_screen = ({ love.graphics.getDimensions() })[1] / 2
    card.position = { x = center_screen, y = - card.sprite.height - 10 }
    card.rotation = 0
    timer.tween(card.time, card.position, { x = love.math.random(center_screen - 50, center_screen + 50) , y = 20 }, "out-cubic")
    timer.tween(card.time, card, { rotation = love.math.random() * math_utils.degtorad(40) - math_utils.degtorad(20)}, "out-cubic")
end

return black_card_in