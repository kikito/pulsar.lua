local pulsar = require( (...):match("(.-)[^%.]+$") .. 'core')

local function reverse(t)
  local rev, len = {}, #t
  for i=0,len-1 do rev[i+1] = t[len - i] end
  return rev
end

local function sortByF(a,b)
  return a.f < b.f
end

local function createNode(self, location, parent, direction, g, h)
  local node = pulsar.newNode(location, parent, direction, g, h)
  self.nodes[location] = node
  self.nodesArray[#self.nodesArray + 1] = node
  return node
end

local function checkAndSetParam(self, value, name)
  assert(value, ("%s expected. Was (%s)"):format(name, tostring(value)))
  self[name] = value
end

local function pickNextBestNode(self)

  if not self.openIsSorted then
    table.sort(self.open, sortByF)
    self.openIsSorted = true
  end

  self.bestNode.open = false
  self.bestNode = table.remove(self.open, 1)
  self.openCount = self.openCount - 1
  return self.bestNode
end

local function getOrCreateNode(self, location, direction)
  return self.nodes[location] or createNode(self, location, self.bestNode, direction, math.huge, 0)
end

local function openNode(self, node)
  if not node.open then
    node.open = true
    self.openCount = self.openCount + 1
    self.open[self.openCount] = node
  end
end

local function updateNode(self, node, direction, g)

  openNode(self, node)

  node.g = g
  node.h = self.heuristic(node.location, self.destination)
  node.parent = self.bestNode
  node.direction = direction
  node:calculateF()

  self.openIsSorted = false
end

local function openNeighbors(self)
  local bestNode_g = self.bestNode.g
  local bestLocation = self.bestNode.location
  local neighborLocations = self.neighbors(bestLocation)
  local g
  for direction, neighborLocation in pairs(neighborLocations) do
    local node = getOrCreateNode(self, neighborLocation, direction)
    g = bestNode_g + self.cost(bestLocation, neighborLocation)
    if g < node.g then
      updateNode(self, node, direction, g)
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
  if not self:hasFoundPath() then
    openNeighbors(self)
  end
end

function Finder:buildPath()
  local node = self.bestNode
  local path = {}
  local count = 0
  while node.parent do
    count = count + 1
    path[count] = node.location
    node = node.parent
  end
  return pulsar.newPath(reverse(path))
end

function Finder:hasFoundPath()
  return self.bestNode.location == self.destination
end

function Finder:done()
  return self.openCount == 0 or self:hasFoundPath()
end

function Finder:searchPath(numberOfSteps)
  numberOfSteps = numberOfSteps or -1
  while numberOfSteps ~= 0 and not self:done() do
    self:step()
    numberOfSteps = numberOfSteps - 1
  end
end

function Finder:replan(location)
  local targetNode = self.nodes[location]
  if not targetNode then return end

  targetNode = targetNode.parent

  local nodeCount = #self.nodesArray
  local node, location
  repeat
    node = self.nodesArray[nodeCount]
    location = node.location
    self.nodes[location] = nil
    self.nodesArray[nodeCount] = nil
    nodeCount = nodeCount - 1
  until node == targetNode

  self.open = { targetNode }
  self.openCount = 1
  self.bestNode = targetNode
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
  finder.nodesArray ={}

  setmetatable(finder, findermt)

  finder.bestNode = createInitialNode(finder)

  return finder
end

return newFinder
