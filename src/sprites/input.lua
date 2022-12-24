local utf8 = require "utf8"

local class = require "libraries.hump.class"

local fonts_manager = require "src.managers.fonts"

local _FONT_FAMILY = "NotoSans-Regular.ttf"
local _FONT_SIZE = 28
local _SIZE = 48
local _PADDING = 7

-- define un campo de texto
local input = class {
    size = _SIZE,

    init = function (self, placeholder, text, width)
        self.font = fonts_manager:load(_FONT_FAMILY, _FONT_SIZE * 2)
        self.width = width or 100

        self.sprite = love.graphics.newCanvas(self.width * 2, _SIZE * 2)
        self:set(placeholder, text, false)
    end,

    gettextwidth = function (self, text)
        return self.font:getWidth(text) / 2
    end,

    ismouseover = function (self, x, y, mx, my)
        return mx >= x and mx <= x + self.width and my >= y and my <= y + _SIZE
    end,

    set = function(self, placeholder, text, cursor)
        self.sprite:renderTo(function ()
            love.graphics.clear()

            local old_color = { love.graphics.getColor() }
            love.graphics.setColor(1, 1, 1, 1)

            -- dibujamos el fondo
            local old_width = love.graphics.getLineWidth()
            love.graphics.setLineWidth(4)
            love.graphics.rectangle("line", 2, 2, self.width * 2 - 4, _SIZE * 2 - 4)

            -- dibujamos el texto
            local offset_x = 0
            if text:len() > 0 or placeholder then
                if cursor and cursor > 1 then
                    local last_byte = utf8.offset(text, cursor) - 1
                    local width = self:gettextwidth(string.sub(text, 1, last_byte)) * 2
                    offset_x = math.max(0, width - (self.width - _PADDING * 2) * 2)
                end

                local str = ((text:len() > 0) and text) or ({{1, 1, 1, 0.5}, placeholder})
                love.graphics.setScissor(_PADDING * 2, 0, (self.width - _PADDING * 2) * 2, _SIZE * 2)
                love.graphics.print(str, self.font, _PADDING * 2 - offset_x, _SIZE - self.font:getHeight() / 2)
                love.graphics.setScissor()
            end

            -- dibujamos el cursor
            if cursor then
                local offset = 0
                if cursor > 1 then
                    local length = utf8.len(text)
                    if cursor > length then
                        offset = self:gettextwidth(text) * 2
                    else
                        local last_byte = utf8.offset(text, cursor) - 1
                        offset = self:gettextwidth(string.sub(text, 1, last_byte)) * 2
                    end
                end

                love.graphics.setLineWidth(2)
                love.graphics.line(_PADDING * 2 + offset - offset_x, 10, _PADDING * 2 + offset - offset_x, _SIZE * 2 - 10)
            end

            love.graphics.setLineWidth(old_width)
            love.graphics.setColor(old_color)
        end)
    end,

    draw = function (self, x, y)
        love.graphics.draw(self.sprite, x, y, 0, 0.5)
    end
}

return input