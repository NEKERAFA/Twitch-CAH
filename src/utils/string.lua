local string_utils = {}

function string_utils.split(str, delim)
    local tokens = {}
    for token in string.gmatch(str, "([^" .. delim .. "]+)") do
        table.insert(tokens, token)
    end
    return tokens
end

return string_utils
