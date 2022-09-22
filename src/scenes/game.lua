local gamestate = require "libraries.hump.gamestate"
local twitch = require "libraries.twitch.twitch-love"

--local chat_manager = require "managers.chat"
local players_manager = require "src.managers.players"
local cards_manager = require "src.managers.cards"
local votes_manager = require "src.managers.votes"

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
    twitch.send(string.format("%q", self.black.text))

    -- Añadimos el comando de escoger carta
    twitch.attach("pick", self.onPickACard)

    self.startTurn()
end

function game.startTurn()
    game.cards = cards_manager:selectwhites()

    -- Le indicamos al jugador la carta a escoger
    twitch.send(string.format("@%s, te toca. Escoge una de las siguientes opciones con %q", game.players[game.player], "!pick numero"))
    for i, card in ipairs(game.cards) do
        twitch.send(string.format("%i - %s", i, card.text))
    end
end

function game.startVote()
    twitch.send(string.format("Hora de votar. Podeis usar %q para elegir la carta que más os guste", "!vote player"))
    twitch.attach("vote", game.onVote)
    twitch.settimer("onVoteClosed", 20, game.onVoteClosed)
end

function game.onPickACard(_, username, cardPicked)
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
                twitch.detach("pick")
                game.startVote()
            end
        end
    end
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
    if vote and (vote ~= username) and not votes_manager:userhasvoted(username) then
        print(string.format("> %s has voted to %s", username, vote))
        votes_manager:vote(username, vote)
    end
end

function game.onVoteClosed()
    twitch.detach("vote")
    twitch.removetimer("onVoteClosed")

    twitch.send("Las votaciones han finalizado. Estoy calculando les ganadories.")

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
        twitch.send(string.format("Les ganadories son %s :)", winners))
    else
        twitch.send("No se ha selecionado a nadie :(")
    end
end

return game
