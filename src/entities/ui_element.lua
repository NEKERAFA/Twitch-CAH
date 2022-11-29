local class = require "libraries.hump.class"

local sounds_manager = require "src.managers.sounds"

local ui_element = class {}

function ui_element.load_sounds ()
    ui_element.selected_sound = sounds_manager:load("select_001.ogg")
    ui_element.clicked_sound = sounds_manager:load("click_001.ogg")
end

function ui_element:init(sprite)
    self.position = { x = 0, y = 0 }
    self.sprite = sprite
end

function ui_element:move(ox, oy)
    self.position.x = ox
    self.position.y = oy
end

function ui_element:getwidth()
    return self.sprite.sprite:getWidth()
end

function ui_element:getheight()
    return self.sprite.sprite:getHeight()
end

function ui_element:onmousemoved(mx, my)
    self.hover = self.sprite:ismouseover(self.position.x, self.position.y, mx, my)
    if self.hover and not self.play_selected_sound and not ui_element.selected_sound:isPlaying() then
        ui_element.selected_sound:seek(0)
        ui_element.selected_sound:play()
        self.play_selected_sound = true
    elseif not self.hover and self.play_selected_sound then
        self.play_selected_sound = false
    end
end

function ui_element:onmousepressed(_, _, mbutton)
    if self.hover then
        self.pressed = mbutton
    end
end

function ui_element:onmousereleased(_, _, mbutton)
    local pressed = false

    if self.hover and self.pressed and self.pressed == mbutton and self.pressed == 1 then
        ui_element.clicked_sound:seek(0)
        ui_element.clicked_sound:play()
        pressed = true
    elseif not self.hover and self.pressed then
        self.pressed = nil
    end

    return pressed
end

function ui_element:draw()
    self.sprite:draw(self.position.x, self.position.y, self.hover)
end

return ui_element
