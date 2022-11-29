local table_utils = {}

function table_utils.size(tbl)
    local size = -1
    local key = nil

    repeat
        size = size + 1
        key = next(tbl, key)
    until key == nil

    return size
end

function table_utils.join(tbl, delim)
    local str = ""
    for _, value in pairs(tbl) do
        if str == "" then
            str = str .. tostring(value)
        else
            str = str .. tostring(delim) .. tostring(value)
        end
    end
    return str
end

function table_utils.pick(tbl, n)
    local tbl_size = table_utils.size(tbl)

    assert(
        n <= tbl_size,
        string.format("the pick number (%i) must be less or equal to table size (%i)", n, tbl_size)
    )

    local keys = {}
    local key = next(tbl)
    while key ~= nil do
        keys[key] = true
        key = next(tbl, key)
    end

    local picked = {}
    local picked_size = 0
    while picked_size < n do
        local selected_pos = love.math.random(tbl_size - picked_size)
        key = nil
        for _ = 1, selected_pos do
            key = next(keys, key)
        end

        table.insert(picked, key)
        picked_size = picked_size + 1
        keys[key] = nil
    end

    return picked
end

function table_utils.pickuntil(tbl, n)
    local tbl_size = table_utils.size(tbl)
    local pick = math.min(tbl_size, n)

    local keys = {}
    local key = next(tbl)
    while key ~= nil do
        keys[key] = true
        key = next(tbl, key)
    end

    local picked = {}
    local picked_size = 0
    while picked_size < pick do
        local selected_pos = love.math.random(tbl_size - picked_size)
        key = nil
        for _ = 1, selected_pos do
            key = next(keys, key)
        end

        table.insert(picked, key)
        picked_size = picked_size + 1
        keys[key] = nil
    end

    return picked
end

return table_utils