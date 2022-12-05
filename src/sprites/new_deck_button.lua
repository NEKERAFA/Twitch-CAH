local class = require "libraries.hump.class"

local new_deck_button = class {
    init = function (self)
        self.sprite = love.graphics.newCanvas(128, 128)
        self.sprite:renderTo(function ()
            self:renderplusicon()
        end)
    end,

    release = function (self)
        self.sprite:release()
    end,

    renderplusicon = function ()
        local old_color = { love.graphics.getColor() }
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("fill", 55, 35, 19, 58)
        love.graphics.rectangle("fill", 35, 55, 58, 19)
        love.graphics.setColor(old_color)
    end,

    ismouseover = function (_, x, y, mx, my)
        return mx >= x and mx <= x + 128 and my >= y and my <= y + 128
    end,

    draw = function (self, x, y, hover)
        local old_color = { love.graphics.getColor() }
        local old_line_width = love.graphics.getLineWidth()

        love.graphics.setLineWidth(2)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.circle(hover and "fill" or "line", x + 64, y + 64, 48, 100)

        if hover then
            love.graphics.setColor(0, 0, 0, 1)
        end
        love.graphics.draw(self.sprite, x, y)

        love.graphics.setLineWidth(old_line_width)
        love.graphics.setColor(old_color)
    end
}

return new_deck_button