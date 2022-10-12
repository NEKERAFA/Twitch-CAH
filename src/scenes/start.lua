local gamestate = require "libraries.hump.gamestate"
local twitch = require "libraries.twitch.twitch-love"

local player_manager = require "src.managers.players"
local settings_manager = require "src.managers.settings"

local draw_utils = require "src.utils.draw"

local game_scene = require "src.scenes.game"

local start = {}

-- Mensaje de inicio del juego
function start:enter()
    if settings_manager.data.chat_level ~= settings_manager.CHAT_LEVEL_VALUES.NONE then
        twitch.send('Va a comenzar una partida de "Cartas Contra la Humanidad". Escribe !join en el chat para jugar.')
    end

    assert(twitch.attach("join", start.onJoinPlayer))
    assert(twitch.settimer("checkPlayer", 30, start.onCheckPlayers))

    player_manager:clear()
end

start.resume = start.enter

function start:leave()
    twitch.detach("join")
    twitch.removetimer("checkPlayer")
end

function start:draw()
    draw_utils.print_text("Lista de participantes: ", 10, 10)
    for i, player in player_manager:iterate() do
        draw_utils.print_text(string.format("> %s", player), 10, 30 + (i - 1) * 16)
    end
end

function start.onJoinPlayer(_, username)
    player_manager:join(username)
end

function start.onCheckPlayers()
    -- if player_manager:count() < 4 then
    --     twitch.send('Va a comenzar una partida de "Cartas Contra la Humanidad". Escribe !join en el chat para jugar.')
    -- else
    --     gamestate.switch(game_scene)
    -- end
    gamestate.switch(game_scene)
end

return start
