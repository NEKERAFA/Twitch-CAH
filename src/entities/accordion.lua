local class = require "library.hump.class"

local ui_element = require "src."

local accordion = class {
    __includes = ui_element,
}

return accordion