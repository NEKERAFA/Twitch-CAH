require "packages"
require "auth"

local twitch = require "twitch.twitch"

-- Canales para comunicar el chat manager con el thread
local control = love.thread.getChannel("chat_control")
local recv = love.thread.getChannel("chat_recv") 
local send = love.thread.getChannel("chat_send")

-- Creamos el cliente
local client = twitch.connect(_USERNAME, _TOKEN_AUTH)

-- Nos unimos al canal
client:join(_CHANNEL)

-- Añadimos los comandos del juego
local function command(command, username, args)
    return { command = command, username = username, args = args }
end

client:attach("join", _CHANNEL, function(client, _, username)
    recv:push(command("join", username, nil))
end)

client:attach("pick", _CHANNEL, function(client, _, username, card)
    recv:push(command("pick", username, { card }))
end)

client:attach("vote", _CHANNEL, function(client, _, username, card)
    recv:push(command("vote", username, { card }))
end)

-- Creamos el bucle que va a estar leyendo lo que la gente escriba
local running = true
while running do
    -- Comprueba si hay que cerrar el thread
    if control:getCount() > 0 then
        running = control:pop()
    end

    -- Comprueba si hay que enviar algo a twitch
    while send:getCount() > 0 do
        local msg = send:pop()
        client:send(msg)
    end

    -- Obtiene los mensajes de twitch
    local msg, username, channel, text = client:receive()

    if msg then
        print(string.format("< %s", msg))

        if username == "PING :tmi.twitch.tv" then
            -- Responde al PING
            client.socket:send("PONG :tmi.twitch.tv\r\n")
        else
            local command = string.match(text, "^!(.+)$")

            -- Ejecuta los comandos
            if command then
                local args = {}
                for arg in string.gmatch(command, "([^%s]+)") do
                    table.insert(args, arg)
                end

                -- Envia al comando que toca
                if client.channels[channel][args[1]] then
                    client.channels[channel][args[1]](client, channel, username, unpack(args, 2))
                end
            end
        end
    end
end

client:close()
