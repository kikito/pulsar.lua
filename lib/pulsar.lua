-- pulsar.lua - v1.0 (2011-11)
-- Copyright (c) 2011 Enrique García Cota
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local Path = {}

local function copy(t)
  local cp = {}
  for i=1,#t do cp[i] = t[i] end
  return cp
end

local pathmt = {

  __tostring = function(self)

    local buffer = {}
    for i=1,#self do
      buffer[#buffer+1] = tostring(self[i])
    end
    return ("{ %s }"):format(table.concat(buffer, ', '))

  end,

  __eq = function(self, other)

    local myLength = #self
    if myLength ~= #other then return false end

    for i=1, myLength do
      if self[i] ~= other[i] then return false end
    end

    return true
  end
}

function Path:new(locations)
  return setmetatable(copy(locations), pathmt)
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
local findermt = { __index = Finder }

local function reverse(t)
  local rev, len = {}, #t
  for i=1, len do rev[i] = t[len - i - 1] end
  return rev
end

local function sortByf(a,b)
  return a.f < b.f
end

local function createNode(self, location, parent, g, h)
  local node = Node:new(location, parent, g, h)
  self.nodes[location] = node
  return node
end

local function checkAndSetParam(finder, value, name)
  assert(value, ("%s expected. Was (%s)"):format(name, tostring(value)))
  finder[name] = value
end

local function pickNextBestNode(self)
  if not self.openIsSorted then
    table.sort(self.open, sortByf)
    self.openIsSorted = true
  end

  self.bestNode = table.remove(self.open, 1)
  self.openCount = self.openCount - 1
  return self.bestNode
end

local function getOrCreateNode(self, location)
  return self.nodes[location] or createNode(self, location, self.bestNode, math.huge, 0)
end

local function openNode(self, node, g)
  if not node.open then
    node.open = true
    self.openCount = self.openCount + 1
    self.open[self.openCount] = node
  end

  node.g = g
  node.h = self.heuristic(node.location, self.destination)
  node.f = node.g + node.h

  self.openIsSorted = false
end

local function openNeighbors(self)
  local bestNode = self.bestNode
  local bestLocation = bestNode.location

  local neighbors, neighbor, c, g, node

  neighbors = self.neighbors(bestLocation)

  for i=1, #neighbors do
    neighbor = neighbors[i]
    c = self.cost(bestLocation, neighbor)
    g = bestNode.g + c
    node = getOrCreateNode(self, neighbor)

    if g < node.g then
      openNode(self, node, g)
    end
  end
end

local function createInitialNode(self)
  local origin = self.origin
  local initialNode = createNode(self, origin, nil, 0, self.heuristic(origin, self.destination))
  initialNode.open = true
  self.open[1] = initialNode
  return initialNode
end


function Finder:step()
  local bestLocation = pickNextBestNode(self).location
  if bestLocation ~= self.destination then
    openNeighbors(self)
  end
  return bestLocation
end

function Finder:buildPath()
  local node = self.bestNode
  local origin = self.origin
  local path = { node.location }
  local count = 1
  while node.location ~= origin do
    node = node.parent
    count = count + 1
    path[count] = node.location
  end
  return Path:new(rev(path))
end

function Finder:findPath()
  local destination = self.destination
  local bestLocation = self.bestNode.location

  while self.openCount > 0 and bestLocation ~= destination do
    bestLocation = self:step()
  end

  if bestLocation == destination then
    return self:buildPath()
  end
end

function Finder:new(origin, destination, neighbors, cost, heuristic)
  local finder = {}
  checkAndSetParam(finder, origin,      "origin")
  checkAndSetParam(finder, destination, "destination")
  checkAndSetParam(finder, neighbors,   "neighbors")
  checkAndSetParam(finder, cost,        "cost")
  checkAndSetParam(finder, heuristic,   "heuristic")

  finder.nodes = {}
  finder.open = {}
  finder.openCount = 0

  setmetatable(finder, findermt)

  self.bestNode = createInitialNode(finder)

  return finder
end

----------------------------------------------------------------------------

local pulsar = {}

pulsar.Path = Path
pulsar.Node = Node
pulsar.Finder = Finder

return pulsar
