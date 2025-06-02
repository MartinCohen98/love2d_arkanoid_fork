local levels = {}

levels.current_level = 1
levels.gamefinished = false
levels.sequence = require "levels/sequence" 

function levels.require_current_level()
   local level_filename = "levels/" ..
      levels.sequence[ levels.current_level ]
   local level = require( level_filename )
   if levels.current_level == 1 then
      level = levels.create_random_level()
   end
   return level
end

function levels.generateRandomMatrix(rows, cols)
    local matrix = {}
    for i = 1, rows do
        matrix[i] = {}
        for j = 1, cols do
            matrix[i][j] = math.random(11, 20)
            if matrix[i][j] > 16 then
               matrix[i][j] = 0
            end
        end
    end
    return matrix
end

function levels.create_random_level()
   local bricks = levels.generateRandomMatrix(11, 8)
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
