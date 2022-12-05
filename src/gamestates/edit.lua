local card_list = require "src.screen.card_list"
local editor_screen = require "src.screen.editor"

local edit = {
    current_screen = card_list
}

function edit:enter()
    if self.current_screen.enter then
        self.current_screen:enter()
    end
end

function edit:mousemoved(mx, my)
    if self.current_screen.mousemoved then
        self.current_screen:mousemoved(mx, my)
    end
end

function edit:draw()
    if self.current_screen.draw then
        self.current_screen:draw()
    end
end

return edit