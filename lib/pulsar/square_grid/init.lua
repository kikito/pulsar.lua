local folder = (...) .. '.'

local squareGrid = {}

squareGrid.newCell    = require(folder .. 'cell')
squareGrid.neighbors  = require(folder .. 'neighbors')
squareGrid.costs      = require(folder .. 'costs')
squareGrid.heuristics = require(folder .. 'heuristics')

return squareGrid
