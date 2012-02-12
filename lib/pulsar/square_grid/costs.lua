local costs = {}

function costs.standard(a,b)
  if a.obstacle or b.obstacle then return math.huge end
  return 1
end

return costs
