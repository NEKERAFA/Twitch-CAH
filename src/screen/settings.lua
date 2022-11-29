local window = require "src.constants.window"

local label = require "src.entities.label"
local input = require "src.entities.input"
local scroller = require "src.entities.scroller"

local settings = {}

function settings:init()
    self.scroller = scroller({ x = 32, y = 32 })

    local header_lbl = label("Settings.", "NotoSans-Medium.ttf", 30)
    header_lbl.position.x = math.floor((window._WIDTH - self.scroller.offset.x * 2) / 2 - header_lbl:getwidth() / 2)
    self.scroller:addelement(header_lbl)

    local network_lbl = label("Network.", "NotoSans-Bold.ttf", 28)
    network_lbl.position.x = math.floor((window._WIDTH - self.scroller.offset.x * 2) / 2 - network_lbl:getwidth() / 2)
    network_lbl.position.y = header_lbl.position.y + header_lbl:getheight() + 8 - 32
    self.scroller:addelement(network_lbl)

    self.input = input("hello", "", 200)
    self.input.position.y = network_lbl.position.y + network_lbl:getheight() + 8 - 32
    self.scroller:addelement(self.input)

    self.return_lbl = label("Return.", "NotoSans-Regular.ttf", 24)
    self.return_lbl.position.y = self.input.position.y + self.input:getheight() + 8 - 32
    self.scroller:addelement(self.return_lbl)
end

function settings:mousemoved(mx, my)
    self.return_lbl:onmousemoved(mx, my)
    self.input:onmousemoved(mx, my)
end

function settings:mousepressed(mx, my, mbutton)
    self.input:onmousepressed(mx, my, mbutton)
end

function settings:mousereleased(mx, my, mbutton)
    self.input:onmousereleased(mx, my, mbutton)
end

function settings:textinput(text)
    self.input:ontextinput(text)
end

function settings:keypressed(key)
    self.input:onkeypressed(key)
end

function settings:draw()
    self.scroller:draw()
end

return settings