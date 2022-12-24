local screen_manager = require "src.managers.screen"

local main_menu_screen = require "src.screen.main_menu"
local settings_screen = require "src.screen.settings"

local main_menu = {
    current_screen = settings_screen
}

function main_menu:init()
    self.current_screen:init()
end

function main_menu:mousemoved(mx, my)
    if self.current_screen.mousemoved then
        self.current_screen:mousemoved(screen_manager:windowtoscreen(mx, my))
    end
end

function main_menu:mousepressed(mx, my, mbutton)
    if self.current_screen.mousepressed then
        local dmx, dmy = screen_manager:windowtoscreen(mx, my)
        self.current_screen:mousepressed(dmx, dmy, mbutton)
    end
end

function main_menu:mousereleased(mx, my, mbutton)
    if self.current_screen.mousereleased then
        local dmx, dmy = screen_manager:windowtoscreen(mx, my)
        local pressed = self.current_screen:mousereleased(dmx, dmy, mbutton)
        if self.current_screen == main_menu_screen then
            if pressed == "button2" then
                --pass
            end
        end
    end
end

function main_menu:textinput(text)
    if self.current_screen.textinput then
        self.current_screen:textinput(text)
    end
end

function main_menu:keypressed(key)
    if self.current_screen.keypressed then
        self.current_screen:keypressed(key)
    end
end

function main_menu:update(dt)
    if self.current_screen.update then
        self.current_screen:update(dt)
    end
end

function main_menu:draw()
    self.current_screen:draw()
end

return main_menu