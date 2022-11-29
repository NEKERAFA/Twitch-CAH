local sounds_manager = {
    cache = {}
}

function sounds_manager:load(sound)
    local sound_name = sounds_manager:getsoundname(sound)
    local sound_cache = sounds_manager:getsound(sound_name)

    if not sound_cache then
        sound_cache = love.audio.newSource("assets/sounds/" .. sound, "stream")
        self.cache[sound_name] = sound_cache
    end

    return sound_cache
end

function sounds_manager:getsoundname(sound)
    return sound:match("(.+)%.ogg$")
end

function sounds_manager:getsound(sound_name)
    return self.cache[sound_name]
end

return sounds_manager