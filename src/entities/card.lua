local class = require "libraries.hump.class"
local timer = require "libraries.hump.timer"

local sounds_manager = require "src.managers.sounds"

local sprite = require "src.sprites.card"

local black_card_in = require "src.animations.black_card_in"
local black_card_out = require "src.animations.black_card_out"
local white_card_in = require "src.animations.white_card_in"
local white_card_out = require "src.animations.white_card_out"
local white_card_selected = require "src.animations.white_card_selected"

local sounds = { playing = false }
for i = 1, 8 do
    table.insert(sounds, sounds_manager:load(("cardSlide%i.ogg"):format(i)))
end

local card = class {
    init = function(self, info, ismaster, time, index)
        self.position = { x = 0, y = 0 }
        self.rotation = 0
        self.size = 1
        self.ismaster = ismaster
        self.index = index
        self.time = time

        local text = info.text
        if not ismaster then
            text = ("%i. %s"):format(index, text)
        end
        self.sprite = sprite(ismaster, text)

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

    release = function(self)
        self.sprite:release()
    end,

    draw = function(self)
        self.sprite:draw(self.position.x, self.position.y, self.rotation, self.size)
    end,

    pick = function(self)
        white_card_selected(self)
    end,

    discard = function(self)
        if not sounds.playing then
            local sound = sounds[love.math.random(8)]
            sound:setVolume(0.10)
            sound:seek(0)
            sound:play()
            sounds.playing = true

            timer.after(sound:getDuration(), function()
                sounds.playing = false
            end)
        end

        if self.ismaster then
            black_card_out(self)
        else
            white_card_out(self)
        end
    end,
}

return card