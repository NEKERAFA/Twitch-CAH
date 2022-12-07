local json = require "libraries.json.json"

local decks = {
    system = {},
    user = {}
}

local _SYSTEM_PATH = "data"
local _USER_PATH = "Saved Desks"
local _DECK_FOLDERS = { _SYSTEM_PATH, _USER_PATH }
local _BLACK_CARDS_FILE = "black_cards.json"
local _WHITE_CARDS_FILE = "white_cards.json"

-- Obtiene un mazo en caché (si no está lo carga)
function decks:load(deck_name)
    local deck = decks:getdeck(deck_name)

    if not deck then
        local path_deck = assert(decks:getdeckpath(deck_name))

        deck = {
            blacks = json.decode(assert(love.filesystem.read(("%s/%s"):format(path_deck, _BLACK_CARDS_FILE)))),
            whites = json.decode(assert(love.filesystem.read(("%s/%s"):format(path_deck, _WHITE_CARDS_FILE))))
        }

        local cache = path_deck:find("^data") and self.system or self.user
        cache[deck_name] = deck
    end

    return deck
end

-- Obtiene la ruta donde está el mazo
function decks:getdeckpath(deck_name)
    local path
    for _, folder in ipairs(_DECK_FOLDERS) do
        local deck_path = ("%s/%s"):format(folder, deck_name)
        if love.filesystem.getInfo(deck_path, "directory") then
            path = deck_path
            break
        end
    end

    return path, path and nil or ("%s not exists in %s/%s or %s/%s/%s"):format(
        deck_name, _SYSTEM_PATH, deck_name, love.filesystem.getSaveDirectory(), _USER_PATH, deck_name
    )
end

-- Eliminar un mazo de la caché
function decks:release(deck_name)
    local cache = self.system[deck_name] and self.system or self.user
    cache[deck_name] = nil
end

-- Obtiene un mazo de la caché
function decks:getdeck(deck_name)
    return self.system[deck_name] or self.user[deck_name]
end

-- Actualiza un mazo creado por el usuario en la caché y lo guarda en disco
function decks:updatedeck(deck_name, blacks, whites)
    self.user[deck_name] = {
        blacks = blacks, whites = whites
    }

    local path_deck = ("%s/%s"):format(_USER_PATH, deck_name)
    if not love.filesystem.getInfo(path_deck, "directory") then
        love.filesystem.createDirectory(path_deck)
    end

    assert(love.filesystem.write(("%s/%s"):format(path_deck, _BLACK_CARDS_FILE), json.encode(blacks)))
    assert(love.filesystem.write(("%s/%s"):format(path_deck, _WHITE_CARDS_FILE), json.encode(whites)))
end

-- Lista los mazos disponibles en disco (en modo DEBUG, tanto del usuario como del sistema)
function decks:list()
    local deck_list = {}

    -- Obtenemos los mazos guardados por el jugador
    for _, folder in ipairs(_DECK_FOLDERS) do
        -- Obtenemos los mazos del sistema solo si estamos en DEBUG
        if _DEBUG or folder ~= _SYSTEM_PATH then
            local items = love.filesystem.getDirectoryItems(folder)
            for _, item in pairs(items) do
                table.insert(deck_list, ("%s/%s"):format(folder, item))
            end
        end
    end

    -- Los ordenamos por nombre del mazo
    table.sort(deck_list)

    return deck_list
end

-- Comprueba que el mazo existe (tanto en la carpeta del sistema como del usuario)
function decks:exists(deck_name)
    for _, folder in ipairs(_DECK_FOLDERS) do
        local deck_path = ("%s/%s"):format(folder, deck_name)
        if love.filesystem.getInfo(deck_path, "directory") then
            return true
        end
    end

    return false
end

return decks