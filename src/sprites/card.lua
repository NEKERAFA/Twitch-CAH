local class = require "libraries.hump.class"

local card_font = love.graphics.newFont(14)

-- blanca o negra
-- texto
-- huecos
local card = class {
    width = 150,
    height = 200,

    init = function (self, ismaster, text)
        self.sprite = love.graphics.newCanvas(self.width, self.height)
        self.sprite:renderTo(function()
            local lastColor = { love.graphics.getColor() }

            -- Dibujamos el fondo de la carta
            if ismaster then
                love.graphics.setColor(0, 0, 0, 1)
            else
                love.graphics.setColor(1, 1, 1, 1)
            end
            love.graphics.rectangle("fill", 0, 0, self.width, self.height, 16, 16)

            -- Dibujamos el texto de la carta
            if ismaster then
                love.graphics.setColor(1, 1, 1, 1)
            else
                love.graphics.setColor(0, 0, 0, 1)
            end
            love.graphics.printf(text, card_font, 20, 20, self.width - 40)

            love.graphics.setColor(lastColor)
        end)
    end,

    draw = function (self, x, y, angle)
        local offset_y = (self.ismaster and 0) or self.height
        love.graphics.draw(self.sprite, x, y + offset_y, angle, 1, 1, self.width / 2, offset_y)
    end
}

return card