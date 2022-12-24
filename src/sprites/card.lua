local class = require "libraries.hump.class"

local card_font = love.graphics.newFont(28)

local card = class {
    width = 150,
    height = 200,

    init = function (self, ismaster, text)
        self.sprite = love.graphics.newCanvas(self.width * 2, self.height * 2)
        self.sprite:renderTo(function()
            local lastColor = { love.graphics.getColor() }

            -- Dibujamos el fondo de la carta
            if ismaster then
                love.graphics.setColor(0, 0, 0, 1)
            else
                love.graphics.setColor(1, 1, 1, 1)
            end
            love.graphics.rectangle("fill", 0, 0, self.width * 2, self.height * 2, 16, 16)
            love.graphics.rectangle("line", 0, 0, self.width * 2, self.height * 2, 16, 16)

            -- Dibujamos el texto de la carta
            if ismaster then
                love.graphics.setColor(1, 1, 1, 1)
            else
                love.graphics.setColor(0, 0, 0, 1)
            end
            love.graphics.printf(text, card_font, 40, 40, self.width * 2 - 80)

            love.graphics.setColor(lastColor)
        end)
        --self.sprite:setFilter("linear")
    end,

    release = function (self)
        self.sprite:release()
    end,

    draw = function (self, x, y, angle, size)
        love.graphics.draw(self.sprite, x, y, angle or 0, 0.5 * (size or 1), 0.5 * (size or 1), self.width)
    end
}

return card