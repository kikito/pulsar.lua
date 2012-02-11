local folder = (...):gsub('init$','') .. '.'

local squareGrid      = require(folder .. 'core')

squareGrid.newCell    = require(folder .. 'cell')
squareGrid.newGrid    = require(folder .. 'grid')
squareGrid.neighbors  = require(folder .. 'neighbors')
squareGrid.costs      = require(folder .. 'costs')
squareGrid.heuristics = require(folder .. 'heuristics')

return squareGrid
