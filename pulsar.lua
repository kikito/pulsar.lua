local path = require 'path'

local pulsar = {}

function pulsar:findPath(map, origin, destination, h, g)
  
  local result = path:new()

  local current = origin
  local x = current.x
  while current ~= destination do
    if destination.x > current.x then
      x = current.x + 1
    end
    current = map:getCell(x, current.y)
    table.insert(result, current)
  end

  return result
end


return pulsar
