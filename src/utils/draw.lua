local font_manager = require "src.managers.fonts"

local draw_utils = {}

local font = font_manager:load("Sniglet-Regular.ttf", 20)

function draw_utils.print_text(text, x, y, color, bg)
    color = color or { 1, 1, 1 }
    bg = bg or { 0, 0, 0 }

    love.graphics.print({bg, text}, font, x - 1, y - 1)
    love.graphics.print({bg, text}, font, x - 1, y + 1)
    love.graphics.print({bg, text}, font, x + 1, y - 1)
    love.graphics.print({bg, text}, font, x + 1, y + 1)
    love.graphics.print({color, text}, font, x, y)
end

return draw_utils