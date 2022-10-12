local draw_utils = {}

local font = love.graphics.newFont("data/assets/fonts/Sniglet-Regular.ttf", 20)

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