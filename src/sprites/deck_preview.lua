local class = require "libraries.hump.class"
local math_utils = require "src.utils.math"
local fonts_manager = require "src.managers.fonts"

local deck_preview = class {
    font_preview = fonts_manager:load("NotoSans-Regular.ttf", 20),
    font_bottom = fonts_manager:load("NotoSans-Medium.ttf", 28),

    init = function (self, deck_name, black_text, white_text)
        local black_sprite = self:getrendercard(black_text, true)
        local white_sprite = self:getrendercard(white_text, false)

        self.sprite = love.graphics.newCanvas(256, 256)
        self.sprite:renderTo(function ()
            love.graphics.draw(white_sprite, 156, 116, math_utils.degtorad(15), 1, 1, 60, 80)
            love.graphics.draw(black_sprite, 36, 28)
            love.graphics.printf(deck_name, self.font_bottom, 0, 216, 256, "center")
        end)

        black_sprite:release()
        white_sprite:release()
    end,

    release = function (self)
        self.sprite:release()
    end,

    getrendercard = function (self, text, master)
        local card = love.graphics.newCanvas(120, 160)
        card:renderTo(function ()
            self.rendercard(text, self.font_preview, master)
        end)
        return card
    end,

    rendercard = function (text, font_preview, master)
        local old_color = { love.graphics.getColor() }
        local old_line_width = love.graphics.getLineWidth()

        if master then
            love.graphics.setColor(0, 0, 0, 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end
        love.graphics.rectangle("fill", 0, 0, 120, 160, 10, 10)

        if master then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", 0, 0, 120, 160, 10, 10)
        end

        love.graphics.setScissor(8, 12, 104, 136)
        if not master then
            love.graphics.setColor(0, 0, 0, 1)
        end
        love.graphics.setScissor()
        love.graphics.printf(text, font_preview, 8, 12, 104, "left")

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

        love.graphics.draw(self.sprite, x, y, 0, 0.5, 0.5)
        love.graphics.setColor(old_color)
    end
}

return deck_preview