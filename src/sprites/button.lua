local class = require "libraries.hump.class"
local mlib = require "libraries.mlib.mlib"

local fonts_manager = require "src.managers.fonts"

local _FONT_FAMILY = "NotoSans-Medium.ttf"
local _FONT_SIZE = 28
local _SIZE = 48

-- define un boton
local button = class {
    size = _SIZE,

    init = function (self, text, width)
        local font = fonts_manager:load(_FONT_FAMILY, _FONT_SIZE)
        self.sprite = love.graphics.newText(font, text)
        local min_width = self.sprite:getWidth() + 48
        self.width = width > min_width and width or min_width
        self.hover = false
    end,

    ismouseover = function (self, x, y, mx, my)
        if mx >= x + _SIZE and mx <= x + self.width - _SIZE and my >= y and my <= y + _SIZE then
            return true
        end

        local radius = _SIZE / 2
        if mlib.circle.checkPoint(mx, my, x + radius, y + radius, radius) then
            return true
        end

        if mlib.circle.checkPoint(mx, my, x + self.width - radius, y + radius, radius) then
            return true
        end

        return false
    end,

    draw = function (self, x, y, hover)
        local old_color = { love.graphics.getColor() }
        love.graphics.setColor(1, 1, 1, 1)

        -- dibujamos el fondo
        local old_width = love.graphics.getLineWidth()
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", x, y, self.width, _SIZE, _SIZE / 2, _SIZE / 2)
        love.graphics.setLineWidth(old_width)
        if not hover then
            love.graphics.rectangle("fill", x, y, self.width, _SIZE, _SIZE / 2, _SIZE / 2)
        end

        -- dibujamos el texto
        if not hover then
            love.graphics.setColor(0, 0, 0, 1)
        end
        local offset_x = self.width / 2 - self.sprite:getWidth() / 2
        local font = self.sprite:getFont()
        local offset_y = _SIZE / 2 - font:getHeight() / 2
        love.graphics.draw(self.sprite, x + offset_x, y + offset_y)
        love.graphics.setColor(old_color)
    end
}

return button