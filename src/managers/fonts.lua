local fonts_manager = {
    cache = {refs = {}, size = 0}
}

local _MAX_FONTS = 16

function fonts_manager:load(font, size)
    local font_name = fonts_manager:getfontname(font)
    local cached_font = fonts_manager:getfontobject(font_name, size)

    -- Si la fuente no está cacheada, la cargamos y la cacheamos
    if not cached_font then
        -- Si se ha superado el número de fuentes a guardar, hacemos espacio
        if self.cache.size == _MAX_FONTS then
            fonts_manager:removefirst()
        end

        -- Cargamos la fuente
        cached_font = love.graphics.newFont("assets/fonts/" .. font, size)

        -- Cacheamos la fuente
        fonts_manager:addfont(cached_font, font_name, size)
    end

    return cached_font
end

function fonts_manager:release(font_name, size)
    self.cache[font_name][size]:release()
    self.cache[font_name][size] = nil

    self.cache[font_name].size = self.cache[font_name].size - 1
    if self.cache[font_name].size == 0 then
        self.cache[font_name] = nil
    end

    local pos = 0
    for index, font_info in ipairs(self.cache.refs) do
        if font_info.name == font_name and font_info.size == size then
            pos = index
            break
        end
    end
    if pos > 0 then
        table.remove(self.cache.refs, pos)
    end

    self.cache.size = self.cache.size - 1
end

function fonts_manager:getfontname(font)
    return font:match("(.+)%.ttf$")
end

function fonts_manager:getfontobject(font_name, size)
    local font = nil

    if self.cache[font_name] then
        font = self.cache[font_name][size]
    end

    return font
end

function fonts_manager:removefirst()
    local font_info = self.cache.refs[1]
    fonts_manager:release(font_info.name, font_info.size)
end

function fonts_manager:addfont(font, name, size)
    if not self.cache[name] then
        self.cache[name] = {size = 0}
    end

    self.cache[name][size] = font
    self.cache[name].size = self.cache[name].size + 1
    table.insert(self.cache.refs, { name = name, size = size })
    self.cache.size = self.cache.size + 1
end

return fonts_manager