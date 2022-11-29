local window = require "src.constants.window"

local label = require "src.entities.label"
local button = require "src.entities.button"

local main_menu = {}

local cursor_hand = love.mouse.getSystemCursor("hand")

function main_menu:init()
    local center_v = math.floor(window._WIDTH / 2)

    -- Header
    local top_offset = 32
    self.header = label("Cards Against Humanity", "NotoSans-Bold.ttf", 36)
    self.header:move(
        center_v - math.floor(self.header:getwidth() / 2),
        top_offset
    )

    -- Subheader
    top_offset = top_offset + self.header:getheight() + 8
    self.subheader = label({{1, 1, 1, 1},"(unofficial) ", {0.51, 0.349, 0.914}, "Twitch version", {1, 1, 1, 1}, "."}, "NotoSans-Regular.ttf", 18)
    self.subheader:move(
        center_v + math.floor(self.header:getwidth() / 2) - self.subheader:getwidth(),
        top_offset
    )

    -- Credits
    self.credits = label("Show credits.", "NotoSans-Regular.ttf", 24)
    local bottom_offset = window._HEIGHT - 32 - self.credits:getheight()
    self.credits:move(32, bottom_offset)

    -- Buttons
    self.buttons = { size = 3 }
    local buttons_gap = 24
    local buttons_width = button.size * self.buttons.size + buttons_gap * (self.buttons.size - 1)
    local width_space = bottom_offset - top_offset
    for i = 1, self.buttons.size do
        local obj
        if i == 1 then
            obj = button("Play", 200)
        elseif i == 2 then
            obj = button("Edit", 200)
        elseif i == 3 then
            obj = button("Settings", 200)
        end

        obj:move(
            center_v - 100,
            top_offset + math.floor(width_space / 2) - math.floor(buttons_width /2) + (button.size + buttons_gap) * (i - 1)
        )

        table.insert(self.buttons, obj)
    end
end

function main_menu:mousemoved(mx, my)
    local ishover

    for _, button_info in ipairs(self.buttons) do
        ishover = ishover or button_info:onmousemoved(mx, my)
    end

    ishover = self.credits:onmousemoved(mx, my)

    if ishover then
        love.mouse.setCursor(cursor_hand)
    else
        love.mouse.setCursor()
    end
end

function main_menu:mousepressed(mx, my, mbutton)
    for _, button_info in ipairs(self.buttons) do
        button_info:onmousepressed(mx, my, mbutton)
    end

    self.credits:onmousepressed(mx, my, mbutton)
end

function main_menu:mousereleased(mx, my, mbutton)
    local pressed
    for i, button_info in ipairs(self.buttons) do
        if button_info:onmousereleased(mx, my, mbutton) then
            pressed = ("button%i"):format(i)
        end
    end

    if self.credits:onmousereleased(mx, my, mbutton) then
        pressed = "credits"
    end

    return pressed
end

function main_menu:draw()
    self.header:draw()
    self.subheader:draw()

    for _, button_info in ipairs(self.buttons) do
        button_info:draw()
    end

    self.credits:draw()
end

return main_menu