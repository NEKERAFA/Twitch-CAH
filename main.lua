require "packages"

local gamestate = require "libraries.hump.gamestate"
local twitch = require "libraries.twitch.twitch-love"

local settings_manager = require "src.managers.settings"
local screen_manager = require "src.managers.screen"

local main_menu = require "src.gamestates.main_menu"
local game = require "src.gamestates.game"
local edit = require "src.gamestates.edit"

local ui_element = require "src.entities.ui_element"

local checkConnection = nil
local checkJoin = nil

--local auth = require "src.managers.auth"

function love.load()
    -- Cargamos los ajustes
    settings_manager:load()

    if not _DEBUG then
        print("Conectando...")
        checkConnection = twitch.connect(_USERNAME, _TOKEN_AUTH)
    end

    love.graphics.setBackgroundColor(0, 0, 0, 1)

    -- Cargamos los assets
    ui_element.load_sounds()

    love.keyboard.setKeyRepeat(true)

    -- debug
    if _DEBUG then
        gamestate.switch(edit)
        gamestate.registerEvents()
        --auth:performaccesstoken()
    end
end

function love.threaderror(thread, msg)
    error(msg)
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
    screen_manager:prepare()

    if not _DEBUG and (checkConnection or checkJoin) then
        draw_utils.print_text("Conectando a twitch", 10, 10)
    else
        --love.graphics.print(tostring(auth.auth_server:isRunning()), 10, 10)
    end
end

function love.resize(width, height)
    screen_manager:resize(width, height)
end

function love.quit()
    if not _DEBUG then
        twitch.close()
    end
end