local Cell = {}

function Cell:getManhattanDistance(other)
  return math.abs(other.x - self.x) + math.abs(other.y - self.y)
end

local cellmt = {
  __index = Cell,
  __tostring = function(self)
    return '{' .. tostring(self.x) .. ',' .. tostring(self.y) .. '}'
  end
}

function Cell:new(x,y)
  return setmetatable({x = x, y = y}, cellmt)
end

--------------------------------------------------------------------

local Map = {}

local neighborDirections = {
  {  0, -1 },
  {  1,  0 },
  {  0,  1 },
  { -1,  0 }
}

function Map:getNeighbors(cell)
  local neighbors = {}
  local x,y = cell.x, cell.y
  local neighbor, dir
  for i=1, #neighborDirections do
    dir = neighborDirections[i]
    neighbor = self(x+dir[1], y+dir[2])
    if neighbor then table.insert(neighbors, neighbor) end
  end
  return neighbors
end

local function isInsideMap(map, x, y)
  return x > 0 and y > 0 and x <= map.width and y <= map.height
end

local mapmt = {
  __index = Map,
  __call = function(self, x, y)
    if isInsideMap(self, x, y) then return self.cells[x][y] end
  end
}

local function createCells(map)
  for x=1, map.width do
    map.cells[x] = {}
    for y=1, map.height do
      map.cells[x][y] = Cell:new(x,y)
    end
  end
end

function Map:new(width, height)
  local map = {width = width, height = height, cells = {}}
  createCells(map)
  return setmetatable(map, mapmt)
end

local squaregrid = {}

squaregrid.Cell = Cell
squaregrid.Map = Map

return squaregrid
