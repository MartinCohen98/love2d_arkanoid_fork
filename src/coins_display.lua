local vector = require "vector"

local coins_display = {}
coins_display.coins = 0

local position = vector(650, 100)  -- Positioned below the score
local width = 120
local height = 65
local separation = 35
local bungee_font = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 30)

function coins_display.update(dt)
end

function coins_display.draw()
   local oldfont = love.graphics.getFont()
   love.graphics.setFont(bungee_font)
   local r, g, b, a = love.graphics.getColor()
   love.graphics.setColor(1, 1, 1, 0.9)
   love.graphics.printf("Coins:",
      position.x,
      position.y,
      width,
      "center")
   love.graphics.printf(coins_display.coins,
      position.x,
      position.y + separation,
      width,
      "center")
   love.graphics.setFont(oldfont)
   love.graphics.setColor(r, g, b, a)
end

function coins_display.add_coin()
   coins_display.coins = coins_display.coins + 10
end

function coins_display.spend_coins(amount)
   coins_display.coins = coins_display.coins - amount
end

function coins_display.reset()
   coins_display.coins = 0
end

return coins_display 