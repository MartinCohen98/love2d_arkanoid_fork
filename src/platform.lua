local vector = require "vector"

local platform = {}
platform.position = vector( 300, 500 )
platform.speed = vector( 800, 0 )
platform.image = love.graphics.newImage( "img/800x600/platform.png" )
platform.base_small_width = 75
platform.base_norm_width = 108
platform.base_large_width = 141
platform.length_multiplier = 1.0
platform.small_tile_width = platform.base_small_width
platform.small_tile_height = 16
platform.small_tile_x_pos = 0
platform.small_tile_y_pos = 0
platform.norm_tile_width = platform.base_norm_width
platform.norm_tile_height = 16
platform.norm_tile_x_pos = 0
platform.norm_tile_y_pos = 32
platform.large_tile_width = platform.base_large_width
platform.large_tile_height = 16
platform.large_tile_x_pos = 0
platform.large_tile_y_pos = 64
platform.glued_x_pos_shift = 192
platform.tileset_width = 333
platform.tileset_height = 80
platform.quad = love.graphics.newQuad( platform.norm_tile_x_pos,
				       platform.norm_tile_y_pos,
				       platform.norm_tile_width,
				       platform.norm_tile_height,
				       platform.tileset_width,
				       platform.tileset_height )
platform.width = platform.norm_tile_width
platform.height = platform.norm_tile_height
platform.size = "norm"
platform.glued = false
platform.activated_next_level_bonus = false
platform.permanent_length_increases = 0

function platform.update( dt )
   platform.follow_mouse( dt )
end

function platform.draw()
   local original_tile_width
   if platform.size == "small" then
      original_tile_width = 75
   elseif platform.size == "norm" then
      original_tile_width = 108
   elseif platform.size == "large" then
      original_tile_width = 141
   end
   local scale_x = platform.width / original_tile_width
   love.graphics.draw(
      platform.image,
      platform.quad,
      platform.position.x,
      platform.position.y,
      0,         -- rotation
      scale_x,   -- scale x (width)
      1          -- scale y (height)
   )
end

function platform.follow_mouse( dt )
   local x, y = love.mouse.getPosition()
   local left_wall_plus_half_platform = 34 + platform.width / 2
   local right_wall_minus_half_platform = 576 - platform.width / 2
   if ( x > left_wall_plus_half_platform and
	x < right_wall_minus_half_platform ) then
      platform.position.x = x - platform.width / 2
   elseif x < left_wall_plus_half_platform then
      platform.position.x =
	 left_wall_plus_half_platform - platform.width / 2
   elseif x > right_wall_minus_half_platform then
      platform.position.x =
	 right_wall_minus_half_platform - platform.width / 2
   end
end

function platform.bounce_from_wall( shift_platform, wall )
   platform.position.x = platform.position.x + shift_platform.x
   if wall.next_level_bonus then
      platform.activated_next_level_bonus = true
   end
end

function platform.apply_length_multiplier()
   platform.small_tile_width = platform.base_small_width * platform.length_multiplier
   platform.norm_tile_width = platform.base_norm_width * platform.length_multiplier
   platform.large_tile_width = platform.base_large_width * platform.length_multiplier
end

function platform.increase_permanent_length()
   platform.base_small_width = platform.base_small_width + 10
   platform.base_norm_width = platform.base_norm_width + 10
   platform.base_large_width = platform.base_large_width + 10

   platform.small_tile_width = platform.base_small_width
   platform.norm_tile_width = platform.base_norm_width
   platform.large_tile_width = platform.base_large_width

   platform.width = platform.norm_tile_width
   platform.height = platform.norm_tile_height
   platform.quad = love.graphics.newQuad(
      platform.norm_tile_x_pos, platform.norm_tile_y_pos,
      platform.norm_tile_width, platform.norm_tile_height,
      platform.tileset_width, platform.tileset_height )
end

function platform.reset_size_to_norm()
   platform.width = platform.norm_tile_width
   platform.height = platform.norm_tile_height
   platform.quad = love.graphics.newQuad(
      platform.norm_tile_x_pos, platform.norm_tile_y_pos,
      platform.norm_tile_width, platform.norm_tile_height,
      platform.tileset_width, platform.tileset_height )
   platform.size = "norm"
end

function platform.react_on_decrease_bonus()
   if platform.size == "norm" then
      platform.width = platform.small_tile_width
      platform.height = platform.small_tile_height
      platform.quad = love.graphics.newQuad(
         platform.small_tile_x_pos, platform.small_tile_y_pos,
         platform.small_tile_width, platform.small_tile_height,
         platform.tileset_width, platform.tileset_height )
      platform.size = "small"
   elseif platform.size == "large" then
      platform.width = platform.norm_tile_width
      platform.height = platform.norm_tile_height
      platform.quad = love.graphics.newQuad(
         platform.norm_tile_x_pos, platform.norm_tile_y_pos,
         platform.norm_tile_width, platform.norm_tile_height,
         platform.tileset_width, platform.tileset_height )
      platform.size = "norm"
   end
end

function platform.react_on_increase_bonus()
   if platform.size == "small" then
      platform.width = platform.norm_tile_width
      platform.height = platform.norm_tile_height
      platform.quad = love.graphics.newQuad(
         platform.norm_tile_x_pos, platform.norm_tile_y_pos,
         platform.norm_tile_width, platform.norm_tile_height,
         platform.tileset_width, platform.tileset_height )
      platform.size = "norm"
   elseif platform.size == "norm" then
      platform.width = platform.large_tile_width
      platform.height = platform.large_tile_height
      platform.quad = love.graphics.newQuad(
         platform.large_tile_x_pos, platform.large_tile_y_pos,
         platform.large_tile_width, platform.large_tile_height,
         platform.tileset_width, platform.tileset_height )
      platform.size = "large"
   end
end

function platform.react_on_glue_bonus()
   platform.glued = true
   if platform.size == "small" then
      platform.quad = love.graphics.newQuad(
	 platform.small_tile_x_pos + platform.glued_x_pos_shift,
	 platform.small_tile_y_pos,
	 platform.small_tile_width,
	 platform.small_tile_height,
	 platform.tileset_width,
	 platform.tileset_height )
   elseif platform.size == "norm" then
      platform.quad = love.graphics.newQuad(
	 platform.norm_tile_x_pos + platform.glued_x_pos_shift,
	 platform.norm_tile_y_pos,
	 platform.norm_tile_width,
	 platform.norm_tile_height,
	 platform.tileset_width,
	 platform.tileset_height )
   elseif platform.size == "large" then
      platform.quad = love.graphics.newQuad(
	 platform.large_tile_x_pos + platform.glued_x_pos_shift,
	 platform.large_tile_y_pos,
	 platform.large_tile_width,
	 platform.large_tile_height,
	 platform.tileset_width,
	 platform.tileset_height )
   end   
end

function platform.remove_glued_effect()
   if platform.glued then
      platform.glued = false
      if platform.size == "small" then
	 platform.quad = love.graphics.newQuad(
	    platform.small_tile_x_pos,
	    platform.small_tile_y_pos,
	    platform.small_tile_width,
	    platform.small_tile_height,
	    platform.tileset_width,
	    platform.tileset_height )
      elseif platform.size == "norm" then
	 platform.quad = love.graphics.newQuad(
	    platform.norm_tile_x_pos,
	    platform.norm_tile_y_pos,
	    platform.norm_tile_width,
	    platform.norm_tile_height,
	    platform.tileset_width,
	    platform.tileset_height )
      elseif platform.size == "large" then
	 platform.quad = love.graphics.newQuad(
	    platform.large_tile_x_pos,
	    platform.large_tile_y_pos,
	    platform.large_tile_width,
	    platform.large_tile_height,
	    platform.tileset_width,
	    platform.tileset_height )
      end
   end
end

function platform.remove_bonuses_effects()
   platform.remove_glued_effect()
   platform.reset_size_to_norm()
   platform.activated_next_level_bonus = false
end

return platform
