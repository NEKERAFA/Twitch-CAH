local access_token = {}

local channel = love.thread.getChannel("access_token")

function access_token.execute(client, method, httpver, headers)
    if method == "OPTIONS" then
        return access_token.option(client, httpver, headers)
    elseif method == "POST" then
        return access_token.post(client, httpver, headers)
    end

    return false
end

function access_token.option(client, httpver, headers)
    client:send(("HTTP/%s 204 No Content\r\n"):format(httpver))
    client:send(("Date: %s\r\n"):format(os.date("%a, %d %b %Y %X %Z")))
    client:send(("Server: Lua/%s\r\n"):format(_VERSION:match("%d+%.%d+")))
    client:send(("Access-Control-Allow-Origin: %s\r\n"):format(headers.origin))
    client:send("Access-Control-Allow-Methods: POST, OPTIONS\r\n")
    client:send(("Connection: %s\r\n\r\n"):format(headers.connection))

    return true
end

function access_token.post(client, httpver, headers)
    local content_length = tonumber(headers["content-length"])

    local buffer = ""
    while buffer:len() < content_length do
        buffer = buffer .. client:receive(headers["content-length"])
    end

    client:send(("HTTP/%s 204 No Content\r\n"):format(httpver))
    client:send(("Date: %s\r\n"):format(os.date("%a, %d %b %Y %X %Z")))
    client:send(("Server: Lua/%s\r\n"):format(_VERSION:match("%d+%.%d+")))
    client:send(("Access-Control-Allow-Origin: %s\r\n"):format(headers.origin))
    client:send("Access-Control-Allow-Methods: POST, OPTIONS\r\n")
    client:send("Connection: Closed\r\n\r\n")

    local access_tokens = assert(loadstring(buffer))()
    channel:push(access_tokens[1])

    return false
end

return access_token