local class = require "libraries.hump.class"

local fonts_manager = require "src.managers.fonts"

-- define un texto que puede ser seleccionado
local label = class {
    init = function (self, text, font_style, font_size)
        local font = fonts_manager:load(font_style, font_size)
        self.font = { name = font_style, size = font_size }
        self.sprite = love.graphics.newText(font, "")
        self.sprite:set(text)
    end,

    ismouseover = function (self, x, y, mx, my)
        return mx >= x and mx <= x + self.sprite:getWidth() and my >= y and my <= y + self.sprite:getHeight()
    end,

    draw = function (self, x, y, hover)
        local old_color = { love.graphics.getColor() }
        love.graphics.setColor(1, 1, 1, 1)
        -- Dibujamos el texto
        love.graphics.draw(self.sprite, x, y)

        if hover then
            -- Si el ratón está encima, dibujamos la underline
            local old_width = love.graphics.getLineWidth()
            local font = self.sprite:getFont()
            local underline = font:getBaseline() + 5
            love.graphics.setLineWidth(2)
            love.graphics.line({ x, y + underline, x + self.sprite:getWidth(), y + underline })
            love.graphics.setLineWidth(old_width)
        end

        love.graphics.setColor(old_color)
    end
}

return label