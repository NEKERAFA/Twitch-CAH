local url = require "socket.url"

local auth = {
    auth_server = love.thread.newThread("src/auth/auth_server.lua"),
    access_token_channel = love.thread.getChannel("access_token")
}

local _TWITCH_AUTHORIZE_URL = "https://id.twitch.tv/oauth2/authorize?response_type=token"
local _CLIENT_ID = "h6wokrt6dgkzkeayvalikmftcbtjk9"
local _REDIRECT_URI = "http://localhost:3000/authorize"
local _READ_CHAT = "chat:read"
local _WRITE_CHAT = "chat:edit"

function auth:performaccesstoken()
    self.auth_server:start()
    local authorize_url = url.parse(_TWITCH_AUTHORIZE_URL)
    authorize_url.query = authorize_url.query .. "&client_id=" .. _CLIENT_ID
    authorize_url.query = authorize_url.query .. "&redirect_uri=" .. _REDIRECT_URI
    authorize_url.query = authorize_url.query .. "&scope=" .. url.escape(_READ_CHAT .. " " .. _WRITE_CHAT)

    print(url.build(authorize_url))
    assert(love.system.openURL(url.build(authorize_url)))
end

function auth:trygetaccesstoken()
    if self.access_token_channel:getCount() > 0 then
        return self.access_token_channel:demand()
    end

    return nil
end

return auth