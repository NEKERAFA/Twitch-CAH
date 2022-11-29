local table_utils = require "src.utils.table"

local players_manager = {
    players = {},
    selected = {}
}

if _DEBUG then
    players_manager.players["nekerafa"] = true
    players_manager.players["gatipedrobot"] = true
end

function players_manager:join(nick)
    if not self.players[nick] then
        self.players[nick] = true

        print("Se ha unido " .. nick)
    end
end

function players_manager:include(nick)
    for player in pairs(self.player) do
        if player == nick then
            return true
        end
    end

    return false
end

function players_manager:includeselected(nick)
    for _, player in ipairs(self.selected) do
        if string.lower(player) == string.lower(nick) then
            return true
        end
    end

    return false
end

function players_manager:select()
    self.selected = table_utils.pickuntil(self.players, 4)

    -- debug
    for _, player in ipairs(self.selected) do
        print("user: " .. player)
    end

    return self.selected
end

function players_manager:count()
    return table_utils.size(self.players)
end

function players_manager:countselected()
    return table_utils.size(self.selected)
end

function players_manager:iterate()
    local value = nil
    local index = 1

    local function iterator(players)
        value = next(players, value)
        return value and (index + 1), value
    end

    return iterator, players_manager.players, index
end

function players_manager:clear()
    self.players = {}
    self.selected = {}
end

return players_manager