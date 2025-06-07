local vector = require "vector"

local collisions = {}

function collisions.resolve_collisions( balls, platform,
					walls, bricks,
					bonuses, side_panel )
   collisions.balls_platform_collision( balls, platform )
   collisions.balls_walls_collision( balls, walls )
   collisions.balls_bricks_collision( balls, bricks, bonuses,
				      side_panel.score_display )
   collisions.platform_walls_collision( platform, walls )
   collisions.platform_bonuses_collision( platform, bonuses,
					  balls, walls,
					  side_panel.lives_display )
end

function collisions.check_rectangles_overlap( a, b )
   local overlap = false
   local small_shift_to_prevent_overlap = 0.1
   local shift_b = vector( 0, 0 )
   if not( a.x + a.width < b.x  or b.x + b.width < a.x  or
	   a.y + a.height < b.y or b.y + b.height < a.y ) then
      overlap = true
      if ( a.x + a.width / 2 ) < ( b.x + b.width / 2 ) then
	 shift_b.x = ( a.x + a.width ) - b.x + small_shift_to_prevent_overlap
      else 
	 shift_b.x = a.x - ( b.x + b.width ) - small_shift_to_prevent_overlap
      end
      if ( a.y + a.height / 2 ) < ( b.y + b.height / 2 ) then
	 shift_b.y = ( a.y + a.height ) - b.y + small_shift_to_prevent_overlap
      else
	 shift_b.y = a.y - ( b.y + b.height ) - small_shift_to_prevent_overlap
      end      
   end
   return overlap, shift_b
end

function collisions.balls_platform_collision( balls, platform )
   local overlap, shift_ball
   local a = { x = platform.position.x,
	       y = platform.position.y,
	       width = platform.width,
	       height = platform.height }
   for _, ball in pairs( balls.current_balls ) do
      local b = { x = ball.position.x - ball.radius,
		  y = ball.position.y - ball.radius,
		  width = 2 * ball.radius,
		  height = 2 * ball.radius }
      overlap, shift_ball =
	 collisions.check_rectangles_overlap( a, b )   
      if overlap then
	 balls.platform_rebound( ball, shift_ball, platform )
      end
   end
end

function collisions.balls_walls_collision( balls, walls )
   local overlap, shift_ball
   for _, ball in pairs( balls.current_balls ) do
      local b = { x = ball.position.x - ball.radius,
		  y = ball.position.y - ball.radius,
		  width = 2 * ball.radius,
		  height = 2 * ball.radius }
      for _, wall in pairs( walls.current_level_walls ) do
	 local a = { x = wall.position.x,
		     y = wall.position.y,
		     width = wall.width,
		     height = wall.height }      
	 overlap, shift_ball =
	    collisions.check_rectangles_overlap( a, b )
	 if overlap then
	    balls.wall_rebound( ball, shift_ball )
	 end
      end
   end
end

function collisions.balls_bricks_collision( balls, bricks, bonuses,
					    score_display )
   local overlap, shift_ball
   for _, ball in pairs( balls.current_balls ) do
      local b = { x = ball.position.x - ball.radius,
		  y = ball.position.y - ball.radius,
		  width = 2 * ball.radius,
		  height = 2 * ball.radius }
      for i, brick in pairs( bricks.current_level_bricks ) do   
	 local a = { x = brick.position.x,
		     y = brick.position.y,
		     width = brick.width,
		     height = brick.height }
	 overlap, shift_ball =
	    collisions.check_rectangles_overlap( a, b )
	 if overlap then	 
	    balls.brick_rebound( ball, shift_ball )
	    bricks.brick_hit_by_ball( i, brick, shift_ball, bonuses,
				      score_display )
	 end
      end
   end
end

function collisions.platform_walls_collision( platform, walls )
   local overlap, shift_platform
   local b = { x = platform.position.x,
	       y = platform.position.y,
	       width = platform.width,
	       height = platform.height }
   for _, wall in pairs( walls.current_level_walls ) do
      local a = { x = wall.position.x,
		  y = wall.position.y,
		  width = wall.width,
		  height = wall.height }      
      overlap, shift_platform =
      	 collisions.check_rectangles_overlap( a, b )
      if overlap then	 
	 platform.bounce_from_wall( shift_platform, wall )
      end
   end
end

function collisions.platform_bonuses_collision( platform, bonuses,
						balls, walls,
						lives_display )
   local overlap
   local b = { x = platform.position.x,
	       y = platform.position.y,
	       width = platform.width,
	       height = platform.height }
   for i, bonus in pairs( bonuses.current_level_bonuses ) do
      local a = { x = bonus.position.x - bonuses.radius,
		  y = bonus.position.y - bonuses.radius,
		  width = 2 * bonuses.radius,
		  height = 2 * bonuses.radius }      
      overlap = collisions.check_rectangles_overlap( a, b )
      if overlap then
	 bonuses.bonus_collected( i, bonus,
				  balls, platform,
				  walls, lives_display )
      end
   end
end

return collisions
