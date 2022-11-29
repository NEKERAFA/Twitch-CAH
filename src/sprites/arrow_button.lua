local class = require "libraries.hump.class"
local mlib = require "libraries.mlib.mlib"

local _SIZE = 48

-- define un boton en forma de flecha
local arrow_button = class {
    init = function (self, orientation)
        self.orientation = orientation
        self.hover = false
    end,

    update = function (self, dt)
    end,

    onresizewindow = function (self, width, height)
    end,

    onmouseover = function (self, x, y, mx, my)
        self.hover = self:ismouseover(x, y, mx, my)
    end,

    getvertices = function (self, x, y)
        local vertices = {}
        if self.orientation == "left" then
            table.insert(vertices, { x, y + _SIZE / 2 })
            table.insert(vertices, { x + math.sqrt(3) / 2 * _SIZE, y })
            table.insert(vertices, { x + math.sqrt(3) / 2 * _SIZE, y + _SIZE })
        elseif self.orientation == "right" then
            table.insert(vertices, { x, y })
            table.insert(vertices, { x + math.sqrt(3) / 2 * _SIZE, y + _SIZE / 2 })
            table.insert(vertices, { x, y + _SIZE })
        end

        return vertices
    end,

    ismouseover = function (self, x, y, mx, my)
        local vertices = self:getvertices(x, y)
        return mlib.polygon.checkPoint(mx, my, vertices)
    end,

    draw = function (self, x, y)
        local vertices = self:getvertices(x, y)

        local old_color = { love.graphics.getColor() }
        love.graphics.setColor(1, 1, 1, 1)

        -- Dibujamos el borde
        local old_width = love.graphics.getLineWidth()
        love.graphics.setLineWidth(3)
        love.graphics.polygon("line", vertices)
        love.graphics.setLineWidth(old_width)

        -- Dibujamos el relleno
        if self.hover then
            love.graphics.polygon("line", vertices)
        end

        love.graphics.setColor(old_color)
    end
}

return arrow_button