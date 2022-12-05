local class = require "libraries.hump.class"

local math_utils = require "src.utils.math"

local deck_preview = class {
    init = function (self, deck_name, black_text, white_text)
        local black_sprite = self:getrendercard(black_text, true)
        local white_sprite = self:getrendercard(white_text, false)

        self.sprite = love.graphics.newCanvas(128, 128)
        self.sprite:renderTo(function ()
            love.graphics.draw(white_sprite, 72, 58, math_utils.degtorad(15), 1, 1, 38, 45)
            love.graphics.draw(black_sprite, 18, 14)
            love.graphics.printf(deck_name, 0, 108, 128, "center")
        end)

        black_sprite:release()
        white_sprite:release()
    end,

    release = function (self)
        self.sprite:release()
    end,

    getrendercard = function (self, text, master)
        local card = love.graphics.newCanvas(60, 80)
        card:renderTo(function ()
            self.rendercard(text, master)
        end)
        return card
    end,

    rendercard = function (text, master)
        local old_color = { love.graphics.getColor() }
        local old_line_width = love.graphics.getLineWidth()

        if master then
            love.graphics.setColor(0, 0, 0, 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end
        love.graphics.rectangle("fill", 0, 0, 60, 80, 5, 5)

        if master then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setLineWidth(1)
            love.graphics.rectangle("line", 0, 0, 60, 80, 5, 5)
        end

        love.graphics.setScissor(4, 6, 52, 68)
        if not master then
            love.graphics.setColor(0, 0, 0, 1)
        end
        love.graphics.setScissor()
        love.graphics.printf(text, 4, 6, 52, "left")

        love.graphics.setColor(old_color)
        love.graphics.setLineWidth(old_line_width)
    end,

    ismouseover = function (_, x, y, mx, my)
        return mx >= x and mx <= x + 128 and my >= y and my <= y + 128
    end,

    draw = function (self, x, y, hover)
        local old_color = { love.graphics.getColor() }
        love.graphics.setColor(1, 1, 1, 1)

        if hover then
            local old_line_width = love.graphics.getLineWidth()
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", x, y, 128, 128)
            love.graphics.setLineWidth(old_line_width)
        end

        love.graphics.draw(self.sprite, x, y)
        love.graphics.setColor(old_color)
    end
}

return deck_preview