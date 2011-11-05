-- pulsar.lua - v1.0 (2011-11)
-- Copyright (c) 2011 Enrique García Cota
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local pulsar = {}

pulsar.Path = {}

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

function pulsar.Path:new(...)
  return setmetatable({...}, pathmt)
end


function pulsar:findPath(map, origin, destination, h, g)

  local result = pulsar.Path:new()

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
