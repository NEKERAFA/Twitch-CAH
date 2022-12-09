local socket = require "socket"

local server = {
    commands = {
        authorize = require "src.auth.commands.authorize",
        access_token = require "src.auth.commands.access_token"
    }
}

function server:start()
    self.conn = socket.bind("localhost", 3000)

    local continue = true
    local keep_alive = true
    while continue do
        local client = self.conn:accept()

        while keep_alive do
            local method, command, httpver, headers = server:get_headers(client)
            continue = server:send(client, command, method, httpver, headers)
            keep_alive = continue and (headers.connection and headers.connection == "keep-alive")
        end

        client:shutdown()
        client:close()
    end

    self.conn:close()
end

function server:get_headers(client)
    local method, resource, httpver
    local headers = {}

    local first_line = true
    local request_line
    repeat
        request_line = assert(client:receive('*l'))

        if first_line then
            method, resource, httpver = server:parse_method(request_line)
            first_line = false
        elseif request_line ~= "" then
            local header = server:parse_header(request_line)
            headers[header.key] = header.value
            print(header.key, header.value)
        end
    until request_line == ""

    return method, resource, httpver, headers
end

function server:parse_method(request)
    local words = {}

    for word in request:gmatch("[^%s]+") do
        if word:find("^/") then
            table.insert(words, word:sub(2, word:len()))
        elseif word:find("^HTTP/") then
            table.insert(words, word:sub(6, word:len()))
        else
            table.insert(words, word)
        end
    end

    return unpack(words)
end

function server:parse_header(request)
    local words = {}
    for word in request:gmatch("[^%s]+") do
        table.insert(words, word)
    end
    local key, value = words[1], words[2]

    return { key = string.lower(key:sub(1, key:len() - 1)), value = value }
end

function server:send(client, command, method, httpver, headers)
    return self.commands[command].execute(client, method, httpver, headers)
end

server:start()