local card_list = require "src.screen.card_list"
local editor_screen = require "src.screen.editor"

local screen_manager = require "src.managers.screen"

local edit = {
    current_screen = editor_screen
}

function edit:init()
    if self.current_screen.init then
        self.current_screen:init()
    end
end

function edit:enter()
    if self.current_screen.enter then
        self.current_screen:enter()
    end
end

function edit:mousemoved(mx, my)
    if self.current_screen.mousemoved then
        self.current_screen:mousemoved(screen_manager:windowtoscreen(mx, my))
    end
end

function edit:wheelmoved(wx, wy)
    if self.current_screen.wheelmoved then
        self.current_screen:wheelmoved(wx, wy)
    end
end

function edit:resize(width, height)
    if self.current_screen.resize then
        self.current_screen:resize(width, height)
    end
end

function edit:draw()
    if self.current_screen.draw then
        self.current_screen:draw()
    end
end

return edit