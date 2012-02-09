local folder = (...) .. '.'

local squareGrid = {}

squareGrid.newCell           = require(folder .. 'cell')
squareGrid.neighborFunctions = require(folder .. 'neighbor_functions')
squareGrid.costFunctions     = require(folder .. 'cost_functions')
squareGrid.heuristics        = require(folder .. 'heuristics')

return squareGrid
