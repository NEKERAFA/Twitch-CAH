local utf8 = require "utf8"

local class = require "libraries.hump.class"

local fonts_manager = require "src.managers.fonts"

local _FONT_FAMILY = "NotoSans-Regular.ttf"
local _FONT_SIZE = 28
local _SIZE = 48

-- define un campo de texto
local input = class {
    size = _SIZE,

    init = function (self, placeholder, text, width)
        local font = fonts_manager:load(_FONT_FAMILY, _FONT_SIZE)
        self.text = text or ""
        self.sprite = love.graphics.newText(font, self.text)
        if placeholder then
            self.placeholder = love.graphics.newText(font, {{ 1, 1, 1, 0.25 }, placeholder})
        end
        self.width = width or 0
    end,

    gettextwidth = function (self, text)
        local font = self.sprite:getFont()
        return font:getWidth(text)
    end,

    ismouseover = function (self, x, y, mx, my)
        return mx >= x and mx <= x + self.width and my >= y and my <= y + _SIZE
    end,

    set = function(self, text)
        self.text = text
        self.sprite:set(text)
    end,

    draw = function (self, x, offset_x, y, cursor)
        local old_color = { love.graphics.getColor() }
        love.graphics.setColor(1, 1, 1, 1)

        -- dibujamos el fondo
        local old_width = love.graphics.getLineWidth()
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", x, y, self.width, _SIZE)

        -- dibujamos el texto
        if string.len(self.text) > 0 or self.placeholder then
            love.graphics.setScissor(x, y, self.width, _SIZE)
            love.graphics.draw(
                string.len(self.text) > 0 and self.sprite or self.placeholder,
                x + 7 - offset_x,
                y + _SIZE / 2 - (string.len(self.text) > 0 and self.sprite:getHeight() or self.placeholder:getHeight()) / 2
            )
            love.graphics.setScissor()
        end

        -- dibujamos el cursor
        if cursor then
            local offset = 0
            if cursor > 1 then
                local length = utf8.len(self.text)
                if cursor > length then
                    offset = self.sprite:getWidth()
                else
                    local last_byte = utf8.offset(self.text, cursor) - 1
                    local font = self.sprite:getFont()
                    offset = font:getWidth(string.sub(self.text, 1, last_byte))
                end
            end

            love.graphics.setLineWidth(1)
            love.graphics.line(x + 7 + offset - offset_x, y + 5, x + 7 + offset - offset_x, y + _SIZE - 4)
        end

        love.graphics.setLineWidth(old_width)
        love.graphics.setColor(old_color)
    end
}

return input