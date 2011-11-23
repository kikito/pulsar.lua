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

----------------------------------------------------------------------------

local Node = {}

function Node:new(location, parent, g, h)
  local node = {
    parent = parent,
    location = location,
    g = g,
    h = h,
    f = g + h
  }
  return node
end

----------------------------------------------------------------------------

local Finder = {}

function Finder:findPath()
  local result = Path:new()

  while self.best ~= self.destination do
    self:findNext()
    table.insert(result, self.best)
  end

  return result
end

function Finder:findNext()
  local neighbors = self.map:getNeighbors(self.best)
  table.sort(neighbors, self.sort)
  self.best = neighbors[1]
end

function Finder:getOrCreateNode(location, parent, g, h)
  local node = self.nodes[location]
  if not node then
    parent = parent or self.current
    local parentLocation = parent and parent.location or self.origin
    g = g or self.cost(parentLocation, location)
    h = h or self.heuristic(parentLocation, location)

    node = Node:new(location, parent, g, h)
    self.nodes[location] = node
  end
  return node
end

local findermt = { __index = Finder }
local function checkAndSetParam(finder, value, name)
  assert(value, name .. " expected. Was (" .. tostring(value) .. ")")
  finder[name] = value
end
function Finder:new(map, origin, destination, cost, heuristic)
  local finder = {}
  checkAndSetParam(finder, map, "map")
  checkAndSetParam(finder, origin, "origin")
  checkAndSetParam(finder, destination, "destination")
  checkAndSetParam(finder, cost, "cost")
  checkAndSetParam(finder, heuristic, "heuristic")

  finder.best = origin
  finder.sort = function(node1, node2) return heuristic(node1, destination) < heuristic(node2, destination) end

  finder.nodes = {}
  finder.open = {}

  setmetatable(finder, findermt)
  local initialNode = finder:getOrCreateNode(origin, nil, 0, heuristic(origin, destination))
  finder:openNode(initialNode)
  finder.current=initialNode
  return finder
end


function Finder:openNode(node)
  node.open = true
  table.insert(self.open, node)
  self.openIsSorted = false
end

function Finder:closeNode(node)
  node.open = false
end

local function sortByf(a,b)
  return a.f < b.f
end
function Finder:pickNextBestNode()
  if not self.openIsSorted then
    table.sort(self.open, sortByf)
    self.openIsSorted = true
  end
  local node = self.open[1]
  if node then
    table.remove(self.open, 1)
    return node
  end
end
function Finder:processBestNeighbors()
  local neighbors = self.map:getNeighbors(self.best)
  local node
  for i=1, #neighbors do
    node = self:getOrCreateNode(neighbors[i])
    self:openNode(node)
  end
end

----------------------------------------------------------------------------

local pulsar = {}

function pulsar:findPath(map, origin, destination, heuristic, cost)
  local finder = Finder:new(map, origin, destination, heuristic, cost)
  return finder:findPath()
end

pulsar.Path = Path
pulsar.Node = Node
pulsar.Finder = Finder


return pulsar
