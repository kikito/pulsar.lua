local costFunctions = {}

function costFunctions.avoidObstacles(a,b)
  if a.obstacle or b.obstacle then return math.huge end
  return 1
end

return costFunctions
