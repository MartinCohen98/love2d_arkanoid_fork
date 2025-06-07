local gameover = {}

local game_objects = {}

bungee_font = love.graphics.newFont(
   "/fonts/Bungee_Inline/BungeeInline-Regular.ttf", 40 )

function gameover.enter( prev_state, ... )
   game_objects = ...
end

function gameover.update( dt )
end

function gameover.draw()
   for _, obj in pairs( game_objects ) do
      if type(obj) == "table" and obj.draw then
	      obj.draw()
      end
   end
   gameover.cast_shadow()

   local oldfont = love.graphics.getFont()
   love.graphics.setFont( bungee_font )
   love.graphics.printf( "Game Over. Press Enter to continue or Esc to quit",
			 108, 110, 400, "center" )
   love.graphics.setFont( oldfont )
end

function gameover.cast_shadow()
   local r, g, b, a = love.graphics.getColor( )
   love.graphics.setColor( 0.01, 0.01, 0.01, 0.7 )
   love.graphics.rectangle("fill",
			   0,
			   0,
			   love.graphics.getWidth(),
			   love.graphics.getHeight() )
   love.graphics.setColor( r, g, b, a )
end

function gameover.keyreleased( key, code )
   if key == "return" then      
      gamestates.set_state( "game", { current_level = 1 } )
   elseif key == 'escape' then
      love.event.quit()
   end    
end

function gameover.exit()
   game_objects = nil 
end

return gameover
