local class = require "libraries.hump.class"
local timer = require "libraries.hump.timer"

local sprite = require "src.sprites.card"

local black_card_in = require "src.animations.black_card_in"
local white_card_in = require "src.animations.white_card_in"
local white_card_out = require "src.animations.white_card_out"

local sounds = {playing = false}
for i = 1, 8 do
    table.insert(sounds, love.audio.newSource(("data/assets/sound/cardSlide%i.ogg"):format(i), "stream"))
end

local card = class {
    init = function(self, info, ismaster, time, index)
        self.position = { x = 0, y = 0 }
        self.rotation = 0
        self.ismaster = ismaster
        self.text = info.text
        self.pick = info.pick
        self.card = info.card
        self.time = time
        self.index = index
        self.opacity = 1
        self.type = "card"

        local text = self.text
        if not ismaster then
            text = string.format("%i. %s", self.index, text)
        end
        self.sprite = sprite(self.ismaster, text)

        if ismaster then
            black_card_in(self)
        else
            white_card_in(self)
        end

        local sound = sounds[love.math.random(8)]
        sound:setVolume(0.10)
        sound:seek(0)
        sound:play()
    end,

    draw = function(self)
        local oldColor = { love.graphics.getColor() }
        local newColor = { unpack(oldColor) }
        newColor[4] = self.opacity
        love.graphics.setColor(newColor)
        self.sprite:draw(self.position.x, self.position.y, self.rotation)
        love.graphics.setColor(oldColor)
    end,

    pick = function(self)
        -- pass
    end,

    discard = function(self)
        if self.ismaster then
            -- pass
        else
            white_card_out(self)

            if not sounds.playing then
                local sound = sounds[love.math.random(8)]
                sound:seek(0)
                sound:play()
                sounds.playing = true

                timer.after(sound:getDuration(), function()
                    sounds.playing = false
                end)
            end
        end
    end
}

return card