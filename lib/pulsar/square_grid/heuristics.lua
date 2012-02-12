local heuristics = {}

local max = function(a,b) return a > b and a or b end
local abs = function(x) return x < 0 and -x or x end

function heuristics.manhattan(cell1, cell2)
  return abs(cell2.x - cell1.x) + abs(cell2.y - cell1.y)
end

function heuristics.diagonal(cell1, cell2)
  return max(abs(cell1.x - cell2.x), abs(cell1.y - cell2.y))
end


return heuristics
