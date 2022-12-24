local class = require "libraries.hump.class"

local window = require "src.constants.window"

local WHEEL_VELOCITY = 8

local scroller = class {
    init = function (self, offset)
        self.elements = {}
        self.offset = offset or {x = 0, y = 0}
        self.scroll_y = 0
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

    onmousemoved = function (self, mx, my)
        for _, element in ipairs(self.elements) do
            element.object:onmousemoved(mx, my)
        end
    end,

    onwheelmoved = function (self, _, wy)
        if self.offset.y + self.height > window._HEIGHT then
            if wy > 0 and self.scroll_y > 0 then
                self.scroll_y = math.max(self.scroll_y - wy * WHEEL_VELOCITY, 0)
            elseif wy < 0 and self.scroll_y < (self.offset.y + self.height) - window._HEIGHT then
                self.scroll_y = math.min(self.scroll_y - wy * WHEEL_VELOCITY, (self.offset.y + self.height) - window._HEIGHT)
            end

            if wy ~= 0 then
                for _, element in ipairs(self.elements) do
                    element.object:move(self.offset.x + element.position.x, self.offset.y + element.position.y - self.scroll_y)
                end
            end
        end
    end,

    draw = function (self)
        for _, element in ipairs(self.elements) do
            element.object:draw()
        end
        
        if self.offset.y + self.height > window._HEIGHT then
            local old_color = { love.graphics.getColor() }
            love.graphics.setColor(1, 1, 1, 0.5)

            -- Calculamos el tamaño del scroll mirando el ratio (alto ventana) / (alto máximo del contenido del scroll) * (alto ventana)
            local height = math.floor(window._HEIGHT * window._HEIGHT / (self.offset.y * 2 + self.height))
            -- Calculamos el offset del scroll mirando el ratio (tamaño actual del scroll) / (tamaño del scroll maximo) * (espacio actual del scroll)
            local scroll_y = (window._HEIGHT - height) * self.scroll_y / ((self.offset.y + self.height) - window._HEIGHT)
            love.graphics.rectangle("fill", window._WIDTH - 10, scroll_y, 10, height)

            love.graphics.setColor(old_color)
        end
    end
}

return scroller