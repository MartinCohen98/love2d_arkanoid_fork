local vector = require "vector"

local coins = {}
coins.image = love.graphics.newImage( "img/800x600/coins.png" )
coins.tile_width = 50
coins.tile_height = 50
coins.tileset_width = 50
coins.tileset_height = 50
coins.radius = 14
coins.speed = vector( 0, 100 )
coins.current_level_coins = {}

local coin_collected_sound = love.audio.newSource("sounds/coin/coin.wav", "static")

function coins.new_coin( position )
   return( { position = position,
	     quad = coins.cointype_to_quad() } )
end

function coins.update_coin( single_coin, dt )
   single_coin.position = single_coin.position + coins.speed * dt
end

function coins.draw_coin( single_coin )
   if single_coin.quad then
      love.graphics.draw(
	 coins.image,
	 single_coin.quad,
	 single_coin.position.x - coins.tile_width / 2,
	 single_coin.position.y - coins.tile_height / 2 )
   else
      local segments_in_circle = 16
      love.graphics.circle( 'line',
			    single_coin.position.x,
			    single_coin.position.y,
			    coins.radius,
			    segments_in_circle )
   end
end

function coins.cointype_to_quad()
   local row = 1
   local col = 1
   local x_pos = coins.tile_width * ( col - 1 )
   local y_pos = coins.tile_height * ( row - 1 )
   return love.graphics.newQuad(
      x_pos, y_pos,
      coins.tile_width, coins.tile_height,
      coins.tileset_width, coins.tileset_height )
end

function coins.update( dt )
   for _, coin in pairs( coins.current_level_coins ) do
      coins.update_coin( coin, dt )
   end
end

function coins.draw()
   for _, coin in pairs( coins.current_level_coins ) do
      coins.draw_coin( coin )
   end
end

function coins.clear_current_level_coins()
   for i in pairs( coins.current_level_coins ) do
      coins.current_level_coins[i] = nil
   end
end

function coins.coin_collected( i, score_display )
   score_display.add_score_for_coin()
   table.remove( coins.current_level_coins, i )
   coin_collected_sound:play()
end

function coins.add_coin( coin )
   table.insert( coins.current_level_coins, coin )
end

function coins.generate_coin(position)
   local spawn_rng = math.random(1, 3)
   if spawn_rng == 3 then
      coins.add_coin(coins.new_coin(position))
   end
end

return coins
