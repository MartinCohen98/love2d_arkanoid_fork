local vector = require "vector"

local bricks = {}
bricks.image = love.graphics.newImage( "img/800x600/bricks.png" )
bricks.tile_width = 64
bricks.tile_height = 32
bricks.tileset_width = 384
bricks.tileset_height = 160
bricks.rows = 11
bricks.columns = 8
bricks.top_left_position = vector( 47, 34 )
bricks.brick_width = bricks.tile_width
bricks.brick_height = bricks.tile_height
bricks.horizontal_distance = 0
bricks.vertical_distance = 0
bricks.current_level_bricks = {}
bricks.no_more_bricks = false

local simple_break_sound = {
   love.audio.newSource(
      "sounds/simple_break/recordered_glass_norm.ogg",
      "static"),   
   love.audio.newSource(
      "sounds/simple_break/edgardedition_glass_hit_norm.ogg",
      "static") }

local armored_hit_sound = {
   love.audio.newSource(
      "sounds/armored_hit/qubodupImpactMetal_short_norm.ogg",
      "static"),
   love.audio.newSource(
      "sounds/armored_hit/cast_iron_clangs_14_short_norm.ogg",
      "static"),
   love.audio.newSource(
      "sounds/armored_hit/cast_iron_clangs_22_short_norm.ogg",
      "static") }

local armored_break_sound = {
   love.audio.newSource(
      "sounds/armored_break/armored_glass_break_short_norm.ogg",
      "static"),
   love.audio.newSource(
      "sounds/armored_break/ngruber__breaking-glass_6_short_norm.ogg",
      "static") }

local ball_heavyarmored_sound = {
   love.audio.newSource(
      "sounds/heavyarmored_hit/cast_iron_clangs_11_short_norm.ogg",
      "static"),
   love.audio.newSource(
      "sounds/heavyarmored_hit/cast_iron_clangs_18_short_norm.ogg",
      "static") }

local snd_rng = love.math.newRandomGenerator( os.time() )

function bricks.new_brick( position, width, height, bricktype, bonustype )
   return( { position = position,
	     width = width or bricks.brick_width,
	     height = height or bricks.brick_height,
	     bricktype = bricktype,
	     quad = bricks.bricktype_to_quad( bricktype ),
	     bonustype = bonustype } )
end

function bricks.update_brick( single_brick )
end

function bricks.draw_brick( single_brick )
   if single_brick.quad then
      love.graphics.draw( bricks.image,
			  single_brick.quad, 
			  single_brick.position.x,
			  single_brick.position.y )
   end
end

function bricks.bricktype_to_quad( bricktype )
   if bricktype == nil or bricktype <= 10 then
      return nil
   end
   local row = math.floor( bricktype / 10 )
   local col = bricktype % 10
   local x_pos = bricks.tile_width * ( col - 1 )
   local y_pos = bricks.tile_height * ( row - 1 )
   return love.graphics.newQuad( x_pos, y_pos,
                                 bricks.tile_width, bricks.tile_height,
                                 bricks.tileset_width, bricks.tileset_height )

end

function bricks.place_brick(row, col, bricktype, level)
   local new_brick_position_x = bricks.top_left_position.x +
      ( col - 1 ) *
      ( bricks.brick_width + bricks.horizontal_distance )
   local new_brick_position_y = bricks.top_left_position.y +
      ( row - 1 ) *
      ( bricks.brick_height + bricks.vertical_distance )
   local new_brick_position = vector( new_brick_position_x,
                  new_brick_position_y )
   local bonustype = level.bonuses[ row ][ col ]
   local new_brick = bricks.new_brick( new_brick_position,
            bricks.brick_width,
            bricks.brick_height,
            bricktype,
            bonustype )
   table.insert( bricks.current_level_bricks, new_brick )
end


function bricks.construct_level( level )
   bricks.no_more_bricks = false
   for row_index, row in ipairs( level.bricks ) do
      for col_index, bricktype in ipairs( row ) do
	 if bricktype ~= 0 then
	    bricks.place_brick(row_index, col_index, bricktype, level)
	    table.insert( bricks.current_level_bricks, new_brick )
	 end
      end
   end
end

function bricks.clear_current_level_bricks()
   for i in pairs( bricks.current_level_bricks ) do
      bricks.current_level_bricks[i] = nil
   end
end

function bricks.update( dt )
   local no_more_bricks = true
   for _, brick in pairs( bricks.current_level_bricks ) do
      if bricks.is_heavyarmored( brick ) then
	 no_more_bricks = no_more_bricks and true
      else
	 no_more_bricks = no_more_bricks and false
      end
   end
   bricks.no_more_bricks = no_more_bricks
end

function bricks.draw()
   for _, brick in pairs( bricks.current_level_bricks ) do
      bricks.draw_brick( brick )
   end
end

function bricks.brick_hit_by_ball( i, brick, shift_ball, bonuses, coins, score_display )
   if bricks.is_simple( brick ) then
      bricks.decrease_color(brick)
      score_display.add_score_for_simple_brick()
      if bricks.should_remove(brick) then
         bonuses.generate_bonus(
            vector( brick.position.x + brick.width / 2,
               brick.position.y + brick.height / 2 ),
            brick.bonustype, coins )
         table.remove( bricks.current_level_bricks, i )
      end
      local snd = simple_break_sound[ snd_rng:random( #simple_break_sound ) ]
      snd:play()
   elseif bricks.is_armored( brick ) then
      bricks.armored_to_scrathed( brick )
      local snd = armored_hit_sound[ snd_rng:random( #armored_hit_sound ) ]
      snd:play()
   elseif bricks.is_scratched( brick ) then
      bricks.scrathed_to_cracked( brick )
      local snd = armored_hit_sound[ snd_rng:random( #armored_hit_sound ) ]
      snd:play()
   elseif bricks.is_cracked( brick ) then
      bonuses.generate_bonus(
	 vector( brick.position.x + brick.width / 2,
		 brick.position.y + brick.height / 2 ),
	 brick.bonustype )
      score_display.add_score_for_cracked_brick()
      table.remove( bricks.current_level_bricks, i )
      local snd = armored_break_sound[ snd_rng:random( #armored_break_sound ) ]
      snd:play()
   elseif bricks.is_heavyarmored( brick ) then
      local snd = ball_heavyarmored_sound[ snd_rng:random( #ball_heavyarmored_sound ) ]
      snd:play()
   end
end

function bricks.is_simple( single_brick )
   local row = math.floor( single_brick.bricktype / 10 )
   return ( row == 1 )
end

function bricks.is_armored( single_brick )
   local row = math.floor( single_brick.bricktype / 10 )
   return ( row == 2 )
end

function bricks.is_scratched( single_brick )
   local row = math.floor( single_brick.bricktype / 10 )
   return ( row == 3 )
end

function bricks.is_cracked( single_brick )
   local row = math.floor( single_brick.bricktype / 10 )
   return ( row == 4 )
end

function bricks.is_heavyarmored( single_brick )
   local row = math.floor( single_brick.bricktype / 10 )
   return ( row == 5 )
end

function bricks.decrease_color(brick)
   brick.bricktype = brick.bricktype - 1
   brick.quad = bricks.bricktype_to_quad( brick.bricktype )
end

function bricks.should_remove(brick)
   local singles_digit = brick.bricktype % 10
   return (singles_digit == 0)
end

function bricks.armored_to_scrathed( single_brick )
   single_brick.bricktype = single_brick.bricktype + 10
   single_brick.quad = bricks.bricktype_to_quad( single_brick.bricktype )
end

function bricks.scrathed_to_cracked( single_brick )
   single_brick.bricktype = single_brick.bricktype + 10
   single_brick.quad = bricks.bricktype_to_quad( single_brick.bricktype )
end

return bricks
