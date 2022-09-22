local twitch = require "libraries.twitch.twitch-love"

local chat_manager = {}

function chat_manager.connect(token, user, channel)
    twitch.connect(token, user)
    twitch.join(channel)
end

function chat_manager.send(msg)
    twitch.send(msg)
end

function chat_manager.update(dt)
    twitch.update(dt)
end

return chat_manager

--[[
-- Canales para comunicar el chat manager con el thread
local control = love.thread.getChannel("chat_control")
local recv = love.thread.getChannel("chat_recv")
local send = love.thread.getChannel("chat_send")

local chat_manager = {}

-- Creamos el thread del chat
function chat_manager:connect()
    self.thread = love.thread.newThread("utils/chat.lua")
    self.thread:start()
end

-- Enviamos mensajes al chat
function chat_manager:send(msg)
    send:push(msg)
end

-- Comprobamos si hay mensajes recibidos del chat
function chat_manager:hasmessages()
    return recv:getCount() > 0
end

-- Obtenemos los mensajes recibidos
function chat_manager:receive()
    return recv:pop()
end

-- Le indicamos al thread del chat que termine de ejecutarse
function chat_manager:close()
    control:push(false)
    self.thread:wait()
end

return chat_manager
]]