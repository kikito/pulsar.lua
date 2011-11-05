local pulsar = {}


pulsar.path = {}

local pathmt = {

  __tostring = function(self)

    local buffer = {}
    for i=1,#self do
      table.insert(buffer, tostring(self[i]))
    end
    return '{ ' .. table.concat(buffer, ', ') .. ' }'

  end,

  __eq = function(self, other)

    local myLength, otherLength = #self, #other
    if myLength ~= otherLength then return false end

    for i=1, myLength do
      if self[i] ~= other[i] then return false end
    end

    return true
  end
}

function pulsar.path:new(...)
  return setmetatable({...}, pathmt)
end


function pulsar:findPath(map, origin, destination, h, g)

  local result = pulsar.path:new()

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
