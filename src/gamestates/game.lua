local timer = require "libraries.hump.timer"
local twitch = require "libraries.twitch.twitch-love"

local string_utils = require "src.utils.string"

local players_manager = require "src.managers.players"
local cards_manager = require "src.managers.cards"
local votes_manager = require "src.managers.votes"
local settings_manager = require "src.managers.settings"

local game_screen = require "src.screen.game"

local game = {}

function game:enter()
    -- establecemos el fondo de pantalla
    love.graphics.setBackgroundColor(0, 1, 0, 1)

    -- inicialimos el estado
    self.state = nil
    self.whites = {}
    self.player = 1

    -- cargamos las cartas
    cards_manager:load()

    -- escogemos los jugadores
    self.players = players_manager:select()

    -- escogemos la carta a jugar
    local black = cards_manager:selectblack()
    local time = game_screen:set_back(black)
    if not _DEBUG and (settings_manager.data.chat_level ~= settings_manager.CHAT_LEVEL_VALUES.NONE) then
        twitch.send(string.format("%q", self.black.text))
    end

    -- Empezamos el turno cuando termine la animación
    timer.after(time, self.startTurn)
end

function game:update(dt)
    timer.update(dt)
end

function game:draw()
    local color = {1, 1, 1, 1}
    if self.isVoting then
        color = {0.5, 0.5, 0.5, 1}
    end

    game_screen:draw(color)
end

function game.startTurn()
    game_screen:clear_cards()
    game.cards = cards_manager:selectwhites()
    game.dropWhiteCard(1)
end

function game.dropWhiteCard(position)
    if position <= #game.cards then
        -- Convertimos una información de una carta blanca en una entidad 'carta' que inicia una animación
        local info = game.cards[position]
        local time = game_screen:add_card(info, position)

        -- Cuando acaba la animación, lanza otra carta
        timer.after(time, function()
            game.dropWhiteCard(position + 1)
        end)
    else
        -- Le indicamos al jugador la carta a escoger
        game_screen:set_player(game.players[game.player])

        if not _DEBUG then
            if (settings_manager.data.chat_level ~= settings_manager.CHAT_LEVEL_VALUES.NONE) then
                twitch.send(string.format("@%s, te toca. Escoge una de las siguientes opciones con %q", game.players[game.player], "!pick numero"))

                if settings_manager.data.chat_level ~= settings_manager.CHAT_LEVEL_VALUES.MINIMAL then
                    for i, card in ipairs(game.cards) do
                        twitch.send(string.format("%i - %s", i, card.text))
                    end
                end
            end

            -- Añade el comando de coger cartas
            twitch.attach("pick", game.onPickACard)
        end

        -- Finaliza el turno pasados 10 segundos
        twitch.settimer("onTurnFinished", 10, game.onTurnFinished)
    end
end

function game.onPickACard(_, username, cardPicked)
    if not _DEBUG then twitch.detach("pick") end

    if twitch.timers["onTurnFinished"] then
        twitch.removetimer("onTurnFinished")
    end

    if username == game.players[game.player] then
        local parsed_card = tonumber(cardPicked)

        if parsed_card then
            -- Un jugador escogió una carta
            local card_info = game.cards[parsed_card]
            cards_manager:pickwhite(card_info.card)
            table.insert(game.whites, card_info)
            game_screen:pick_card(parsed_card)

            game.player = game.player + 1
            game_screen:clear_player()

            for i in ipairs(game.cards) do
                if i ~= parsed_card then
                    game_screen:discard_card(i)
                end
            end

            -- Comprobamos si pasamos al siguiente turno, o a los votos
            timer.after(3, function ()
                if game.player <= players_manager:countselected() then
                    game.startTurn()
                else
                    game.startVote()
                end
            end)
        end
    end
end

function game.onTurnFinished()
    game.onPickACard(nil, game.players[game.player], love.math.random(1, 4))
end

-- 1. limpiar las cartas blancas
-- 2. animación lanzar cartas seleccionadas
-- 3. cuando se acaba, empezamos votos

-- cartas con porcentajes -- oscurecer cartas
-- animación shake
-- cuando gana, se agranda
-- mostrar nombre de les ganadories

function game.dropSelectedWhiteCard(position)
    if position <= players_manager:countselected() then
        -- Convertimos la información de la carta seleccionada en una entidad
        local info = game.whites[position]
        local time = game_screen:add_card(info, position)

        -- Cuando acaba la animación, lanza otra carta
        timer.after(time, function()
            game.dropSelectedWhiteCard(position + 1)
        end)
    else
        -- Iniciamos los votos
        if not _DEBUG then
            if settings_manager.data.chat_level ~= settings_manager.CHAT_LEVEL_VALUES.NONE then
                twitch.send(string.format("Hora de votar. Podeis usar %q para elegir la carta que más os guste", "!vote player"))
            end

            twitch.attach("vote", game.onVote)
        else
            local time = love.math.random() * 4 + 2
            local auxVoting = function(f)
                return function()
                    local player = love.math.random(1, players_manager:countselected())
                    local size = love.math.random(5, 10)
                    local user = string_utils.random(size)
                    game.onVote(nil, user, game.players[player])
                    local time_voting = love.math.random() * 4 + 2
                    game.voting = timer.after(time_voting, f(f))
                end
            end
            game.voting = timer.after(time, auxVoting(auxVoting))
        end

        game.isVoting = true
        twitch.settimer("onVoteClosed", 30, game.onVoteClosed)
    end
end

function game.startVote()
    game_screen:clear_cards()
    game.dropSelectedWhiteCard(1)
end

function game.playerToCardPlayer(player)
    local card_index = nil

    for player_pos, player_name in ipairs(game.players) do
        if player_name == player then
            card_index = player_pos
        end
    end

    return card_index
end

function game.onVote(_, username, player)
    local parsed_card = tonumber(player)
    local vote = nil

    -- Compruebo si es un número de carta, o el nombre de un jugador
    if parsed_card then
        if (parsed_card > 0) or (parsed_card <= players_manager:countselected()) then
            vote = players_manager.selected[parsed_card]
        end
    else
        if players_manager:includeselected(player) then
            vote = player
        end
    end

    -- Añado el voto con el usuario que lo emite
    if vote and (string.lower(vote) ~= string.lower(username)) and not votes_manager:userhasvoted(username) then
        print(string.format("> %s has voted to %s", username, vote))
        local player_pos = game.playerToCardPlayer(vote)
        game.votes[player_pos] = (game.votes[player_pos] and 0) or (game.votes[player_pos] + 1)
        votes_manager:vote(username, vote)
    end
end

function game.onVoteClosed()
    if not _DEBUG then
        twitch.detach("vote")
    else
        timer.cancel(game.voting)
    end

    game.isVoting = false
    twitch.removetimer("onVoteClosed")

    print("end")

    if not _DEBUG and (settings_manager.data.chat_level == settings_manager.CHAT_LEVEL_VALUES.ALL) then
        twitch.send("Las votaciones han finalizado. Estoy calculando les ganadories.")
    end

    -- Obtenemos la lista de votos
    local votes = votes_manager:countvotes()

    if #votes > 0 then
        -- Obtenemos les ganadories
        local winner_cards = {}
        local winners = ""
        local max = votes[1].votes
        for _, player in ipairs(votes) do
            if player.votes < max then
                break
            end

            local card = game.playerToCardPlayer(player.nick)
            game_screen:pick_card(card)
            winner_cards[card] = true

            winners = string.format("%s@%s ", winners, player.nick)
        end

        for i = 1, players_manager:countselected() do
            if not winner_cards[i] then
                game_screen:discard_card(i)
            end
        end

        -- Imprimo les ganadories
        if not _DEBUG and (settings_manager.data.chat_level ~= settings_manager.CHAT_LEVEL_VALUES.NONE) then
            twitch.send(string.format("Les ganadories son %s :)", winners))
        end
        print(("winners: %s"):format(winners))
    else
        if not _DEBUG and (settings_manager.data.chat_level ~= settings_manager.CHAT_LEVEL_VALUES.NONE) then
            twitch.send("No se ha selecionado a nadie :(")
        end

        for i = 1, players_manager:countselected() do
            game_screen:discard_card(i)
        end
    end

    game_screen:discard_back()
end

return game