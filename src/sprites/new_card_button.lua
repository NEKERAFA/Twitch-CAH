local class = require "libraries.hump.class"

local new_card_button = class {
    width = 150,
    height = 200,

    init = function (self)
        self.sprite = love.graphics.newCanvas(58, 58)
        self.sprite:renderTo(function ()
            self:renderplusicon()
        end)
    end,

    renderplusicon = function ()
        local old_color = { love.graphics.getColor() }
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("fill", 20, 0, 19, 58)
        love.graphics.rectangle("fill", 0, 20, 58, 19)
        love.graphics.setColor(old_color)
    end,

    release = function (self)
        self.sprite:release()
    end,

    ismouseover = function (self, x, y, mx, my)
        return mx >= x and mx <= x + self.width and my >= y and my <= y + self.height
    end,

    draw = function (self, x, y, hover)
        local old_color = { love.graphics.getColor() }
        local old_line_width = love.graphics.getLineWidth()

        love.graphics.setLineWidth(2)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle((hover and "fill") or "line", x, y, self.width, self.height, 8, 8)

        if hover then
            love.graphics.setColor(0, 0, 0, 1)
        end

        love.graphics.draw(
            self.sprite,
            x + math.floor(self.width / 2), y + math.floor(self.height / 2),
            0, 1, 1,
            math.floor(self.sprite:getWidth() / 2), math.floor(self.sprite:getHeight() / 2)
        )

        love.graphics.setLineWidth(old_line_width)
        love.graphics.setColor(old_color)
    end
}

return new_card_button