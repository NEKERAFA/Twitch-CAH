local timer = require "libraries.hump.timer"

local sounds_manager = require "src.managers.sounds"

local screen_height = ({ love.graphics.getDimensions() })[1]

local sounds = {}
for i = 1, 8 do
    table.insert(sounds, sounds_manager:load(("cardSlide%i.ogg"):format(i)))
end

local white_card_selected = function(card)
    timer.tween(card.time / 2, card, {size = 1.25}, "in-cubic")

    timer.after(card.time * 2, function()
        timer.tween(card.time, card.position, {y = screen_height + 20 + card.sprite.height / 2}, "out-cubic")

        local sound = sounds[love.math.random(8)]
        sound:setVolume(0.10)
        sound:seek(0)
        sound:play()
    end)
end

return white_card_selected