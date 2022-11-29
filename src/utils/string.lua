local string_utils = {}

function string_utils.split(str, delim)
    local tokens = {}
    for token in string.gmatch(str, "([^" .. delim .. "]+)") do
        table.insert(tokens, token)
    end
    return tokens
end

function string_utils.random(m)
    local buffer = {}
    for _ = 1, m do
        local byte = love.math.random(97, 122)
        table.insert(buffer, byte)
    end
    return string.char(unpack(buffer))
end

return string_utils
