require "packages"
require "auth"

local gamestate = require "libraries.hump.gamestate"
local twitch = require "libraries.twitch.twitch-love"

local settings_manager = require "src.managers.settings"

--local draw_utils = require "src.utils.draw"

--local start = require "src.scenes.start"
local game = require "src.gamestates.game"
local main_menu = require "src.gamestates.main_menu"

local ui_element = require "src.entities.ui_element"

local checkConnection = nil
local checkJoin = nil

function love.load()
    if not _DEBUG then
        print("Conectando...")
        checkConnection = twitch.connect(_USERNAME, _TOKEN_AUTH)
    end

    love.graphics.setBackgroundColor(0, 0, 0, 1)

    -- Cargamos los ajustes
    settings_manager.load()

    -- Cargamos los assets
    ui_element.load_sounds()

    love.keyboard.setKeyRepeat(true)

    -- debug
    if _DEBUG then
        gamestate.switch(main_menu)
        gamestate.registerEvents()
    end
end

function love.update(dt)
    twitch.update(dt)

    if not _DEBUG then
        if checkConnection and checkConnection() then
            checkConnection = nil
            checkJoin = twitch.join(_CHANNEL)
        end

        if checkJoin and checkJoin() then
            checkJoin = nil
            gamestate.switch(start)
            gamestate.registerEvents()
        end
    end
end

function love.draw()
    if not _DEBUG and (checkConnection or checkJoin) then
        draw_utils.print_text("Conectando a twitch", 10, 10)
    end
end

function love.quit()
    if not _DEBUG then
        twitch.close()
    end
end