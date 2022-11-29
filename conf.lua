_DEBUG = true

local window = require "src.constants.window"

function love.conf(t)
    t.window.title = "Card Against Humanity"
    t.window.icon = "icon.png"
    t.window.resizable = true
    t.window.width = window._WIDTH
    t.window.height = window._HEIGHT
end