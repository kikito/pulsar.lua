-- pulsar.lua - v1.0 (2011-11)
-- Copyright (c) 2011 Enrique García Cota
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local Path = {}

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

function Path:new(...)
  return setmetatable({...}, pathmt)
end


local Finder = {}

local findermt = {
  __index = {

    findPath = function(self)
      local result = Path:new()
      local neighbors

      while self.best ~= self.destination do
        neighbors = self.map:getNeighbors(self.best)
        table.sort(neighbors, function(a,b) return a:getManhattanDistance(self.destination) < b:getManhattanDistance(self.destination) end)
        self.best = neighbors[1]
        table.insert(result, self.best)
      end

      return result
    end
  }
}

local function checkParam(value, name)
  assert(value, name .. " expected. Was (" .. tostring(value) .. ")")
end

function Finder:new(map, origin, destination, cost, heuristic)
  checkParam(map, "map")
  checkParam(origin, "origin")
  checkParam(destination, "destination")
  checkParam(cost, "cost")
  checkParam(heuristic, "heuristic")
  local finder = {
    map = map,
    origin = origin,
    destination = destination,
    cost = cost,
    heuristic = heuristic
  }
  finder.best = origin
  setmetatable(finder, findermt)
  return finder
end


local pulsar = {}

function pulsar:findPath(map, origin, destination, heuristic, cost)
  local finder = Finder:new(map, origin, destination, heuristic, cost)
  return finder:findPath()
end

pulsar.Path = Path
pulsar.Finder = Finder

return pulsar
