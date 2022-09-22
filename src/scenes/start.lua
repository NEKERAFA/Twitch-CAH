--local gamestate = require "libraries.hump.gamestate"
local twitch = require "libraries.twitch.twitch-love"

--local chat_manager = require "managers.chat"
local player_manager = require "src.managers.players"
--local game = require "scenes.game"

local start = {}

-- Mensaje de inicio del juego
function start:enter()
    twitch.send('Va a comenzar una partida de "Cartas Contra la Humanidad". Escribe !join en el chat para jugar.')
    assert(twitch.attach("join", start.onJoinPlayer))
    assert(twitch.settimer("checkPlayer", 30, start.onCheckPlayers))

    player_manager:clear()
end

start.resume = start.enter

function start:leave()
    twitch.detach("join")
    twitch.removetimer("checkPlayer")
end

function start.onJoinPlayer(_, username)
    player_manager:join(username)
end

function start.onCheckPlayers()
    if player_manager:count() < 4 then
        twitch.send('Va a comenzar una partida de "Cartas Contra la Humanidad". Escribe !join en el chat para jugar.')
    else
        print("A jugar!")
    end
end

return start
