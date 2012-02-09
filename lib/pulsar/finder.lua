local inspect = require 'lib.inspect'

local pulsar = require( (...):match("(.-)[^%.]+$") .. 'core')

local function reverse(t)
  local rev, len = {}, #t
  for i=1, len do rev[i] = t[len - i - 1] end
  return rev
end

local function sortByf(a,b)
  return a.f < b.f
end

local function createNode(self, location, parent, direction, g, h)
  local node = pulsar.newNode(location, parent, direction, g, h)
  self.nodes[location] = node
  return node
end

local function checkAndSetParam(self, value, name)
  assert(value, ("%s expected. Was (%s)"):format(name, tostring(value)))
  self[name] = value
end

local function pickNextBestNode(self)
  self.bestNode.open = false

  if not self.openIsSorted then
    table.sort(self.open, sortByf)
    self.openIsSorted = true
  end

  self.bestNode = table.remove(self.open, 1)
  self.openCount = self.openCount - 1
  return self.bestNode
end

local function getOrCreateNode(self, location, direction)
  return self.nodes[location] or createNode(self, location, self.bestNode, direction, math.huge, 0)
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
  local bestLocation = self.bestNode.location

  local neighbors, c, g, node

  neighbors = self.neighbors(bestLocation)

  for direction, neighbor in pairs(neighbors) do
    c = self.cost(bestLocation, neighbor)
    g = bestNode.g + c
    node = getOrCreateNode(self, neighbor, direction)

    if g < node.g then
      print(inspect(node))
      openNode(self, node, g)
    end
  end
end

local function createInitialNode(self)
  local origin = self.origin
  local initialNode = createNode(self, origin, nil, nil, 0, self.heuristic(origin, self.destination))
  initialNode.open = true
  self.open[1] = initialNode
  self.openCount = 1
  return initialNode
end

---------------------------------------------------------------

local Finder = {}

function Finder:step()
  pickNextBestNode(self)
  print(self.bestNode.location)
  if not self:done() then
    openNeighbors(self)
  end
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
  return pulsar.newPath(reverse(path))
end

function Finder:hasFoundPath()
  return self.bestNode.location == self.destination
end

function Finder:done()
  return self.bestNode.location == self.destination or self.openCount == 0
end

function Finder:walk()
  while not self:done() do
    self:step()
  end
end

local findermt = { __index = Finder }

local function newFinder(origin, destination, neighbors, cost, heuristic)
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

  finder.bestNode = createInitialNode(finder)

  return finder
end

return newFinder
