local table_utils = require "src.utils.table"

local players_manager = {
    players = {["nekerafa"] = true},
    selected = {}
}

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
        if player == nick then
            return true
        end
    end

    return false
end

function players_manager:select()
    self.selected = table_utils.pick(self.players, 1)

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

function players_manager:clear()
    self.players = {}
    self.selected = {}
end

return players_manager