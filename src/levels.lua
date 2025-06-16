local levels = {}

levels.current_level = 1
levels.gamefinished = false
levels.sequence = require "levels/sequence" 

local bricks_rng = love.math.newRandomGenerator( os.time() )

function levels.require_current_level()
   local level_filename = "levels/" ..
      levels.sequence[ levels.current_level ]
   local level = require( level_filename )
   level = levels.create_random_level(levels.current_level)
   return level
end

function levels.generateRandomMatrix(rows, cols, max)
    local matrix = {}
    for i = 1, rows do
        matrix[i] = {}
        for j = 1, cols do
            matrix[i][j] = bricks_rng:random(11, 20)
            if matrix[i][j] > max or matrix[i][j] > 16 then
               matrix[i][j] = 0
            end
        end
    end
    return matrix
end

function levels.create_random_level(difficulty)
   local bricks = levels.generateRandomMatrix(11, 8, 10 + difficulty)
   return {
      name = "random",
      bricks = bricks,
      bonuses = {
         {00, 00, 00, 00, 00, 00, 00, 00},
         {00, 00, 00, 00, 00, 00, 00, 00},
         {00, 00, 00, 00, 00, 00, 00, 00},
         {00, 00, 00, 00, 00, 00, 00, 00},
         {00, 00, 00, 00, 00, 00, 00, 00},
         {00, 00, 00, 00, 00, 00, 00, 00},
         {00, 00, 00, 00, 00, 00, 00, 00},
         {00, 00, 00, 00, 00, 00, 00, 00},
         {00, 00, 00, 00, 00, 00, 00, 00},
         {00, 00, 00, 00, 00, 00, 00, 00},
         {00, 00, 00, 00, 00, 00, 00, 00},
      }
   }
end

return levels
