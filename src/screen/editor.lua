local scroller = require "src.entities.scroller"
local input = require "src.entities.input"
local label = require "src.entities.label"
local new_card_button = require "src.entities.new_card_button"

local cards_manager = require "src.managers.cards"

local editor = {}

function editor:init()
    self.sprite = scroller({ x = 32, y = 32 })

    self.title = input("Untitled", "", 640 - 64)
    self.sprite:addelement(self.title)

    self.whites = label("Whites.", "NotoSans-Medium.ttf", 26)
    self.whites:move(0, self.title.position.y + self.title:getheight() + 16 - self.sprite.offset.y)
    self.sprite:addelement(self.whites)

    self.new_white_btn = new_card_button()
    self.new_white_btn:move(0, self.whites.position.y + self.whites:getheight() + 8 - self.sprite.offset.y)
    self.sprite:addelement(self.new_white_btn)

    self.blacks = label("Blacks.", "NotoSans-Medium.ttf", 26)
    self.blacks:move(0, self.new_white_btn.position.y + self.new_white_btn:getheight() + 8 - self.sprite.offset.y)
    self.sprite:addelement(self.blacks)

    self.new_black_btn = new_card_button()
    self.new_black_btn:move(0, self.blacks.position.y + self.blacks:getheight() + 8 - self.sprite.offset.y)
    self.sprite:addelement(self.new_black_btn)
end

function editor:mousemoved(mx, my)
    self.sprite:onmousemoved(mx, my)
end

function editor:wheelmoved(wx, wy)
    self.sprite:onwheelmoved(wx, wy)
end

function editor:enter(deck_name)
    if deck_name then
        -- pass
        self.title:clear(deck_name)
    else
        cards_manager:new("Untitled")
        self.title:clear()
    end
end


function editor:draw()
    self.sprite:draw()
end

return editor