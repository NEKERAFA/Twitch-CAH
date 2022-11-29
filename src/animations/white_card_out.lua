local timer = require "libraries.hump.timer"
local screen_width = ({ love.graphics.getDimensions() })[1]

local white_card_out = function(card)
    timer.tween(card.time, card.position, {x = screen_width + 20 + card.sprite.width / 2}, "out-cubic")
end

return white_card_out