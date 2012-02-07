-- this file holds useful functions that relate the screen with the grid itself

local Grid = require 'grid.base'

local cellWidth, cellHeight = 16,16
local left,top = 8, 66

-- transform a cell's row and column into screen pixel coordinates
function Grid:grid2screen(x,y)
  return left + (x-1) * cellWidth,
         top  + (y-1) * cellHeight
end

-- given a pixel coordinate, return the coordinates of the cell containing it
function Grid:screen2grid(wx, wy)
  return math.floor((wx - left) / cellWidth) + 1,
         math.floor((wy - top ) / cellHeight) + 1
end

Grid.cellWidth = cellWidth
Grid.cellHeight = cellHeight


