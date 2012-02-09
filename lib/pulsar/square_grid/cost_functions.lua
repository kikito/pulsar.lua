local costFunctions = {}

local abs = function(x) return x < 0 and -x or x end

function costFunctions.manhattan(cell1, cell2)
  return abs(cell2.x - cell1.x) + abs(cell2.y - cell1.y)
end

return costFunctions
