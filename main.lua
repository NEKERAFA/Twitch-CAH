require "packages"
require "auth"

local gamestate = require "libraries.hump.gamestate"
local twitch = require "libraries.twitch.twitch-love"

--local start = require "src.scenes.start"
local game = require "src.scenes.game"

local checkConnection = nil
local checkJoin = nil
function love.load()
    print("conectando...")
    checkConnection = twitch.connect(_USERNAME, _TOKEN_AUTH)
    
    --twitch.join(_CHANNEL)

    --gamestate.switch(start)
    --gamestate.switch()
    --gamestate.registerEvents()
end

function love.update(dt)
    twitch.update(dt)

    if checkConnection and checkConnection() then
        checkConnection = nil
        checkJoin = twitch.join(_CHANNEL)
    end

    if checkJoin and checkJoin() then
        checkJoin = nil
        gamestate.switch(game)
        gamestate.registerEvents()
    end
end

function love.quit()
    twitch.close()
end