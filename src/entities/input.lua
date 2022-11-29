local utf8 = require "utf8"

local class = require "libraries.hump.class"

local ui_element = require "src.entities.ui_element"
local sprite = require "src.sprites.input"

local input = class {
    __includes = ui_element,
    size = sprite.size,

    init = function(self, placeholder, text, width)
        ui_element.init(self, sprite(placeholder, text, width))
        self.text = text or ""
        self.focus = false
        self.cursor = 1
    end,

    getwidth = function(self)
        return self.sprite.width
    end,

    getheight = function()
        return sprite.size
    end,

    ontextinput = function (self, text)
        if self.focus then
            local length = utf8.len(self.text)
            if self.cursor > length then
                self.text = self.text .. text
            else
                local byte = utf8.offset(self.text, self.cursor)
                self.text = string.sub(self.text, 1, byte - 1) .. text .. string.sub(self.text, byte)
            end

            self.sprite:set(self.text)
            self.cursor = self.cursor + 1
        end
    end,

    onkeypressed = function (self, key)
        if key == "backspace" then
            local length = utf8.len(self.text)
            if length > 0 and self.cursor > 1 then
                local last_byte = utf8.offset(self.text, self.cursor - 1) - 1
                local old_text = self.text
                self.text = string.sub(self.text, 1, last_byte)

                if self.cursor <= length then
                    local next_byte = utf8.offset(old_text, self.cursor)
                    self.text = self.text .. string.sub(old_text, next_byte)
                end
                self.sprite:set(self.text)
                self.cursor = self.cursor - 1
            end
        end

        if key == "delete" then
            local length = utf8.len(self.text)
            if length > 0 and self.cursor <= length then
                local last_byte = utf8.offset(self.text, self.cursor) - 1
                local old_text = self.text
                self.text = string.sub(self.text, 1, last_byte)

                if self.cursor < length then
                    local next_byte = utf8.offset(old_text, self.cursor + 1)
                    self.text = self.text .. string.sub(old_text, next_byte)
                end
                self.sprite:set(self.text)
            end
        end

        if key == "left" then
            self.cursor = math.max(1, self.cursor - 1)
        end

        if key == "right" then
            self.cursor = math.min(utf8.len(self.text) + 1, self.cursor + 1)
        end
    end,

    onmousereleased = function(self, _, _, mbutton)
        local pressed = ui_element.onmousereleased(self, nil, nil, mbutton)
        self.focus = pressed
        return pressed
    end,

    draw = function(self)
        local offset_x = 0
        if self.cursor > 1 then
            local last_byte = utf8.offset(self.text, self.cursor) - 1
            local width = self.sprite:gettextwidth(string.sub(self.text, 1, last_byte))
            offset_x = math.max(0, width - self.sprite.width + 14)
        end

        self.sprite:draw(self.position.x, offset_x, self.position.y, self.focus and self.cursor)
    end,
}

return input