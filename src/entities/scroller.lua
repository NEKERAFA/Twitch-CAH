local class = require "libraries.hump.class"

local scroller = class {
    init = function (self, offset)
        self.elements = {}
        self.offset = offset or {x = 0, y = 0}
        self.scroll = 0
        self.height = 0
    end,

    addelement = function (self, element)
        local new_element = {
            object = element,
            position = {
                x = element.position.x,
                y = element.position.y
            }
        }

        table.insert(self.elements, new_element)
        element:move(self.offset.x + new_element.position.x, self.offset.y + new_element.position.y)
        self.height = math.max(self.height, element.position.y + element:getheight())
    end,

    draw = function (self)
        for _, element in ipairs(self.elements) do
            element.object:draw()
        end
    end
}

return scroller