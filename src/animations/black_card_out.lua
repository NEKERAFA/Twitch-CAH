local timer = require "libraries.hump.timer"

local black_card_out = function(card)
    timer.tween(card.time, card.position, { y = -20 - card.sprite.height }, "out-cubic")
end

return black_card_out