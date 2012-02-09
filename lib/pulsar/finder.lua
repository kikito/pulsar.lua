local pulsar = require( (...):match("(.-)[^%.]+$") .. 'core')

local function reverse(t)
  local rev, len = {}, #t
  for i=1, len do rev[i] = t[len - i - 1] end
  return rev
end

local function sortByf(a,b)
  return a.f < b.f
end

local function createNode(self, location, parent, g, h)
  local node = pulsar.newNode(location, parent, g, h)
  self.nodes[location] = node
  return node
end

local function checkAndSetParam(self, value, name)
  assert(value, ("%s expected. Was (%s)"):format(name, tostring(value)))
  self[name] = value
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

---------------------------------------------------------------

local Finder = {}

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
  return pulsar.newPath(reverse(path))
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
