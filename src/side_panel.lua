local vector = require "vector"
local lives_display = require "lives_display"
local score_display = require "score_display"
local coins_display = require "coins_display"

local side_panel = {}
local position_x = 608
local width = 200
local height_top = 180
local height_middle = 268
local height_bottom = 160
local position_top = vector( position_x, 0 )
local position_middle = vector( position_x, height_top )
local position_bottom = vector( position_x, height_top + height_middle )

side_panel.lives_display = lives_display
side_panel.score_display = score_display
side_panel.coins_display = coins_display

function side_panel.update( dt )
   side_panel.lives_display.update( dt )
   side_panel.score_display.update( dt )
   side_panel.coins_display.update( dt )
end

function side_panel.draw()
   side_panel.draw_background()
   side_panel.lives_display.draw()
   side_panel.score_display.draw()
   side_panel.coins_display.draw()
end

function side_panel.draw_background()
   local r, g, b, a = love.graphics.getColor( )
   -- top
   love.graphics.setColor( 1, 0.4, 0, 1 )
   love.graphics.rectangle("fill",
			   position_top.x,
			   position_top.y,
			   width,
			   height_top )
   love.graphics.setColor( 0, 0, 0, 1 )
   love.graphics.rectangle("line",
			   position_top.x,
			   position_top.y,
			   width,
			   height_top )
   -- middle
   love.graphics.setColor( 1, 0.5, 0.15, 1 )
   love.graphics.rectangle("fill",
			   position_middle.x,
			   position_middle.y,
			   width,
			   height_middle )
   love.graphics.setColor( 0, 0, 0, 1 )
   love.graphics.rectangle("line",
			   position_middle.x,
			   position_middle.y,
			   width,
			   height_middle )
   -- bottom
   love.graphics.setColor( 1, 0.4, 0, 1 )
   love.graphics.rectangle("fill",
			   position_bottom.x,
			   position_bottom.y,
			   width,
			   height_bottom )
   love.graphics.setColor( 0, 0, 0, 1 )
   love.graphics.rectangle("line",
			   position_bottom.x,
			   position_bottom.y,
			   width,
			   height_bottom )   
   love.graphics.setColor( r, g, b, a )      
end

function side_panel.add_life_if_score_reached()
   side_panel.lives_display.add_life_if_score_reached(
      side_panel.score_display.score )
end

function side_panel.reset()
   side_panel.lives_display.reset()
   side_panel.score_display.reset()
   side_panel.coins_display.reset()
end

return side_panel
