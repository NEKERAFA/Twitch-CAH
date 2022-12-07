local window = require "src.constants.window"

local screen = {
    offset = {
        x = 0, y = 0,
    },
    ratio = 1
}

function screen:resize(width, height)
    local ratio_width = width / window._WIDTH
    local ratio_height = height / window._HEIGHT

    self.ratio = math.min(ratio_width, ratio_height)

    self.offset.x = math.floor(width / 2 - (window._WIDTH * self.ratio / 2))
    self.offset.y = math.floor(height / 2 - (window._HEIGHT * self.ratio / 2))
end

function screen:windowtoscreen(...)
    local points = {...}
    assert(#points % 2 == 0, "points must be pairs")

    for i, value in ipairs(points) do
        points[i] = math.floor((value - ((i % 2 == 0) and self.offset.y or self.offset.x)) * 1 / self.ratio)
    end

    return unpack(points)
end

function screen:prepare()
    love.graphics.translate(self.offset.x, self.offset.y)
    love.graphics.scale(self.ratio)
end

return screen