local timer = require "libraries.hump.timer"

local black_card_in = function(card)
    local center_screen = ({ love.graphics.getDimensions() })[1] / 2
    card.position = { x = center_screen, y = - card.sprite.height - 10 }
    card.rotation = 0
    local time = love.math.random() * 0.5 + 0.5
    timer.tween(time, card.position, { x = love.math.random(center_screen - 50, center_screen + 50) , y = 20 }, "out-cubic")
    timer.tween(time, card, { rotation = love.math.random() * 0.6981317 - 0.34906585 }, "out-cubic")
end

return black_card_in