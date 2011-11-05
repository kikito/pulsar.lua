local path = require 'path'

local pulsar = {}

function pulsar:findPath(map, origin, destination, h, g)
  
  local result = path:new()

  local current = origin
  local x,y = current.x, current.y
  local dx,dy
  while current ~= destination do
    dx,dy = destination.x - current.x, destination.y - current.y

    if     dx > 0 then x = x + 1
    elseif dx < 0 then x = x - 1
    elseif dy > 0 then y = y + 1
    elseif dy < 0 then y = y - 1
    end

    current = map:getCell(x, y)
    table.insert(result, current)
  end

  return result
end


return pulsar
