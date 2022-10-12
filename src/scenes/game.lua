local gamestate = require "libraries.hump.gamestate"
local twitch = require "libraries.twitch.twitch-love"

local players_manager = require "src.managers.players"
local cards_manager = require "src.managers.cards"
local votes_manager = require "src.managers.votes"
local settings_manager = require "src.managers.settings"

local draw_utils = require "src.utils.draw"

local card_sprite = require "src.sprites.card"

local game = {}

function game:enter()
    -- inicialimos el estado
    self.state = nil
    self.whites = {}
    self.player = 1
    self.votes = {}

    -- cargamos las cartas
    cards_manager:load()

    -- escogemos los jugadores
    self.players = players_manager:select()

    -- escogemos la carta a jugar
    self.black = cards_manager:selectblack()
    self.black_sprite = card_sprite(true, self.black.text)
    if not _DEBUG and (settings_manager.data.chat_level ~= settings_manager.CHAT_LEVEL_VALUES.NONE) then
        twitch.send(string.format("%q", self.black.text))
    end

    -- Empezamos el turno
    self.startTurn()

    -- Añadimos el comando de escoger carta
    if _DEBUG then
        twitch.attach("pick", self.onPickACard)
    end
end

function game:draw()
    if self.black_sprite then
        self.black_sprite:draw(10, 10)
    end

    if self.cards_sprites and self.player <= players_manager:countselected() then
        draw_utils.print_text(string.format("¡Te toca, %s! Elige una de las de abajo", self.players[self.player]), 10, 170)

        for i, card in ipairs(self.cards_sprites) do
            card:draw(10 + (i - 1) * 120, 195)
        end
    end
end

function game.startTurn()
    game.cards = cards_manager:selectwhites()
    game.cards_sprites = {}

    -- Le indicamos al jugador la carta a escoger
    if not _DEBUG and (settings_manager.data.chat_level ~= settings_manager.CHAT_LEVEL_VALUES.NONE) then
        twitch.send(string.format("@%s, te toca. Escoge una de las siguientes opciones con %q", game.players[game.player], "!pick numero"))

        if settings_manager.data.chat_level ~= settings_manager.CHAT_LEVEL_VALUES.MINIMAL then
            for i, card in ipairs(game.cards) do
                twitch.send(string.format("%i - %s", i, card.text))
            end
        end
    end

    for i, card in ipairs(game.cards) do
        table.insert(game.cards_sprites, card_sprite(false, string.format("%i. %s", i, card.text)))
    end

    twitch.settimer("onTurnFinished", 10, game.onTurnFinished)
end

function game.onPickACard(_, username, cardPicked)
    if twitch.timers["onTurnFinished"] then
        twitch.removetimer("onTurnFinished")
    end

    if username == game.players[game.player] then
        local parsed_card = tonumber(cardPicked)

        if parsed_card then
            -- Un jugador escogió una carta
            local card = game.cards[tonumber(cardPicked)].card
            cards_manager:pickwhite(card)
            table.insert(game.whites, card)
            game.player = game.player + 1

            -- Comprobamos si pasamos al siguiente turno, o a los votos
            if game.player <= players_manager:countselected() then
                game.startTurn()
            else
                if not _DEBUG then twitch.detach("pick") end
                game.startVote()
            end
        end
    end
end

function game.onTurnFinished()
    if not _DEBUG then
        twitch.detach("pick")
    end

    twitch.removetimer("onTurnFinished")

    game.onPickACard(nil, game.players[game.player], love.math.random(1, 4))
end

function game.startVote()
    if not _DEBUG then
        if settings_manager.data.chat_level ~= settings_manager.CHAT_LEVEL_VALUES.NONE then
            twitch.send(string.format("Hora de votar. Podeis usar %q para elegir la carta que más os guste", "!vote player"))
        end

        twitch.attach("vote", game.onVote)
    end

    twitch.settimer("onVoteClosed", 30, game.onVoteClosed)
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
        votes_manager:vote(username, vote)
    end
end

function game.onVoteClosed()
    if not _DEBUG then
        twitch.detach("vote")
    end

    twitch.removetimer("onVoteClosed")

    if not _DEBUG and (settings_manager.data.chat_level == settings_manager.CHAT_LEVEL_VALUES.ALL) then
        twitch.send("Las votaciones han finalizado. Estoy calculando les ganadories.")
    end

    -- Obtenemos la lista de votos
    local votes = votes_manager:countvotes()

    if #votes > 0 then
        -- Obtenemos les ganadories
        local winners = ""
        local max = votes[1].votes
        for _, player in ipairs(votes) do
            if player.votes < max then
                break
            end

            winners = string.format("%s@%s ", winners, player.nick)
        end

        -- Imprimo les ganadories
        if not _DEBUG and (settings_manager.data.chat_level ~= settings_manager.CHAT_LEVEL_VALUES.NONE) then
            twitch.send(string.format("Les ganadories son %s :)", winners))
        end
    else
        if not _DEBUG and (settings_manager.data.chat_level ~= settings_manager.CHAT_LEVEL_VALUES.NONE) then
            twitch.send("No se ha selecionado a nadie :(")
        end
    end
end

return game