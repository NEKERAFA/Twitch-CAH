local authorize = {}

function authorize.execute(client, method, httpver, headers)
    print("authorize", ("%s /authorize http/%s"):format(method, httpver))
    for k, v in ipairs(headers) do
        print("authorize", ("%s: %s"):format(k, v))
    end

    if method == "GET" then
        return authorize.get(client, httpver, headers)
    end

    return false
end

function authorize.get(client, httpver, headers)
    local response = authorize.getresponse()

    client:send(("HTTP/%s 200 OK\r\n"):format(httpver))
    client:send(("Date: %s\r\n"):format(os.date("%a, %d %b %Y %X %Z")))
    client:send(("Server: Lua/%s\r\n"):format(_VERSION:match("%d+%.%d+")))
    client:send("Content-Type: text/html; charset=utf8\r\n")
    client:send(("Content-Length: %i\r\n"):format(response.length))
    client:send(("Connection: %s\r\n\r\n"):format(headers.connection))

    for _, response_line in ipairs(response) do
        client:send(response_line)
    end
    client:send("\r\n")

    return true
end

function authorize.getresponse()
    local response = { length = 0 }

    for line in love.filesystem.lines("src/auth/authorize.html") do
        local response_line = ("%s\r\n"):format(line)
        table.insert(response, response_line)
        response.length = response.length + string.len(response_line)
    end

    return response
end

return authorize