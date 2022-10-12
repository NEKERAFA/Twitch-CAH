local class = require "libraries.hump.class"

local card_font = love.graphics.newFont(24)

-- blanca o negra
-- texto
-- huecos
local card = class {
    init = function (self, isMaster, text)
        self.sprite = love.graphics.newCanvas(200, 300)
        self.sprite:renderTo(function()
            local lastColor = { love.graphics.getColor() }

            -- Dibujamos el fondo de la carta
            if isMaster then
                love.graphics.setColor(0, 0, 0, 1)
            else
                love.graphics.setColor(1, 1, 1, 1)
            end
            love.graphics.rectangle("fill", 0, 0, 200, 300, 18, 18)

            -- Dibujamos el texto de la carta
            if isMaster then
                love.graphics.setColor(1, 1, 1, 1)
            else
                love.graphics.setColor(0, 0, 0, 1)
            end
            love.graphics.printf(text, card_font, 24, 24, 152)

            love.graphics.setColor(lastColor)
        end)
    end,

    draw = function (self, x, y)
        love.graphics.draw(self.sprite, x, y, 0, 0.75, 0.75)
    end
}

return card