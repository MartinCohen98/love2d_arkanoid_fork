local vector = require "vector"
local buttons = require "buttons"
local levels = require "levels"
local platform = require "platform"
local balls = require "balls"

local shop = {}

-- Shop item prices
local platform_length_price = 10
local ball_speed_price = 10
local life_price = 10

-- Button style
local button_width = 320
local button_height = 48
local button_radius = 12
local button_color = {0.95, 0.95, 0.95, 1}
local button_hover_color = {0.8, 0.85, 1, 1}
local button_border_color = {0.2, 0.2, 0.2, 1}
local button_text_color = {0.1, 0.1, 0.1, 1}
local font = love.graphics.newFont(24)

local buy_sound = love.audio.newSource("sounds/shop/buy.mp3", "static")

-- Individual buttons
local platform_button, speed_button, life_button, skip_button

function shop.load(prev_state, ...)
   -- Button positions
   local center_x = (800 - button_width) / 2
   local start_y = 200
   local gap = 24

   platform_button = buttons.new_button{
      position = vector(center_x, start_y),
      width = button_width,
      height = button_height,
      text = "+ Platform Length $" .. platform_length_price
   }
   speed_button = buttons.new_button{
      position = vector(center_x, start_y + button_height + gap),
      width = button_width,
      height = button_height,
      text = "- Ball Speed $" .. ball_speed_price
   }
   life_button = buttons.new_button{
      position = vector(center_x, start_y + 2 * (button_height + gap)),
      width = button_width,
      height = button_height,
      text = "Extra Life $" .. life_price
   }
   skip_button = buttons.new_button{
      position = vector(center_x, start_y + 3 * (button_height + gap)),
      width = button_width,
      height = button_height,
      text = "Continue"
   }
end

function shop.enter(prev_state, ...)
   local args = ...
   shop.current_level = args.current_level
   shop.coins_display = args.coins_display
   shop.platform = args.platform
   shop.balls = args.balls
   shop.lives_display = args.lives_display
end

function shop.update(dt)
   buttons.update_button(platform_button, dt)
   buttons.update_button(speed_button, dt)
   buttons.update_button(life_button, dt)
   buttons.update_button(skip_button, dt)
end

function shop.draw()
   -- Draw background (clean, dark)
   love.graphics.setColor(0.13, 0.13, 0.13, 1)
   love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

   -- Draw title and coins
   love.graphics.setFont(font)
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.printf("Shop", 0, 100, love.graphics.getWidth(), "center")
   love.graphics.printf("Coins: " .. shop.coins_display.coins, 0, 150, love.graphics.getWidth(), "center")

   -- Draw buttons
   local draw_btn = function(btn)
      if btn.selected then
         love.graphics.setColor(button_hover_color)
      else
         love.graphics.setColor(button_color)
      end
      love.graphics.rectangle("fill", btn.position.x, btn.position.y, btn.width, btn.height, button_radius, button_radius)
      love.graphics.setColor(button_border_color)
      love.graphics.setLineWidth(2)
      love.graphics.rectangle("line", btn.position.x, btn.position.y, btn.width, btn.height, button_radius, button_radius)
      love.graphics.setColor(button_text_color)
      love.graphics.printf(btn.text, btn.position.x, btn.position.y + btn.height / 2 - 14, btn.width, "center")
   end
   draw_btn(platform_button)
   draw_btn(speed_button)
   draw_btn(life_button)
   draw_btn(skip_button)
   love.graphics.setColor(1, 1, 1, 1)
end

function shop.play_buy_sound()
   buy_sound:stop()
   buy_sound:play()
end

function shop.mousereleased(x, y, button, istouch)
   if button == 'l' or button == 1 then
      if buttons.mousereleased(platform_button, x, y, button) then
         if shop.coins_display.coins >= platform_length_price then
            shop.platform.increase_permanent_length()
            shop.coins_display.spend_coins(platform_length_price)
            platform_length_price = platform_length_price + 10
            platform_button.text = "+ Platform Length $" .. platform_length_price
            shop.play_buy_sound()
         end
      elseif buttons.mousereleased(speed_button, x, y, button) then
         if shop.coins_display.coins >= ball_speed_price then
            shop.balls.decrease_permanent_speed()
            shop.coins_display.spend_coins(ball_speed_price)
            ball_speed_price = ball_speed_price * 2
            speed_button.text = "- Ball Speed $" .. ball_speed_price
            shop.play_buy_sound()
         end
      elseif buttons.mousereleased(life_button, x, y, button) then
         if shop.coins_display.coins >= life_price then
            shop.lives_display.add_life()
            shop.coins_display.spend_coins(life_price)
            shop.play_buy_sound()
         end
      elseif buttons.mousereleased(skip_button, x, y, button) then
         shop.proceed_to_next_level()
      end
   end
end

function shop.proceed_to_next_level()
   if shop.current_level < #levels.sequence then
      gamestates.set_state("game", {
         current_level = shop.current_level + 1,
         coins = shop.coins_display.coins,
         platform = shop.platform,
         balls = shop.balls,
         lives_display = shop.lives_display
      })
   else
      gamestates.set_state("gamefinished")
   end
end

return shop 