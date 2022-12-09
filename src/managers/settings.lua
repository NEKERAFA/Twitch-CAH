local ini = require "libraries.ini.ini"

local settings_manager = {
    data = {
        chat_level = "MINIMAL", -- NONE, MINIMAL, ALL
        username = nil, -- Twitch username to publish message
        channel = nil, -- Twitch channel
        token_auth = nil -- OAuth token
    },

    CHAT_LEVEL_VALUES = {
        NONE = "NONE",
        MINIMAL = "MINIMAL",
        ALL = "ALL"
    }
}

function settings_manager:load()
    local path = love.filesystem.getSaveDirectory() .. "/settings.ini"
    if love.filesystem.getInfo(path) then
        local saved_settings = ini.load(path)
        for key, value in pairs(saved_settings) do
            settings_manager:set(key, value)
        end
    end
end

function settings_manager:save()
    ini.save(self.data, love.filesystem.getSaveDirectory() .. "/settings.ini")
end

function settings_manager:get(key)
    return self.data[key]
end

function settings_manager:set(key, value)
    self.data[key] = value or settings_manager:get(key)
end

return settings_manager