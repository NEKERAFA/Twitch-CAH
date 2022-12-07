local ini = require "libraries.ini.ini"

local settings_manager = {
    data = {
        chat_level = "MINIMAL" -- NONE, MINIMAL, ALL
    },

    CHAT_LEVEL_VALUES = {
        NONE = "NONE",
        MINIMAL = "MINIMAL",
        ALL = "ALL"
    }
}

function settings_manager.load()
    local path = love.filesystem.getSaveDirectory() .. "/settings.ini"
    if love.filesystem.getInfo(path) then
        settings_manager.data = ini.load(path)
    end
end

function settings_manager.save()
    ini.save(settings_manager.data, love.filesystem.getSaveDirectory() .. "/settings.ini")
end

return settings_manager