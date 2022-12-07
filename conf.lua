_DEBUG = true

local window = require "src.constants.window"

function love.conf(t)
    t.window.title = "Card Against Humanity"
    t.window.icon = "icon.png"
    t.window.resizable = true
    t.window.width = window._WIDTH
    t.window.minwidth = window._WIDTH / 2
    t.window.height = window._HEIGHT
    t.window.minheight = window._HEIGHT / 2
end