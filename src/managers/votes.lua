local table_utils = require "src.utils.table"

local votes_manager = {
    votes = {}
}

function votes_manager:vote(username, player)
    player = string.lower(player)
    if not self.votes[player] then
        self.votes[player] = {}
    end

    username = string.lower(username)
    if not self.votes[player][username] then
        self.votes[player][username] = true
    end
end

function votes_manager:userhasvoted(username)
    for _, users in pairs(self.votes) do
        if users[string.lower(username)] then
            return true
        end
    end

    return false
end

function votes_manager:countvotes()
    -- Se crea un objeto temporal con la lista de votos y el nombre del jugador votado
    local votes = {}
    for player, users in pairs(self.votes) do
        table.insert(votes, { nick = player, votes = table_utils.size(users)})
    end

    -- Ordenamos los votos de mayor a menor
    table.sort(votes, function (a, b)
        return a.votes < b.votes
    end)

    return votes
end

function votes_manager:clear()
    self.votes = {}
end

return votes_manager