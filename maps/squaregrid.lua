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
    if neighbor and not neighbor.obstacle then table.insert(neighbors, neighbor) end
  end
  return neighbors
end

local function isInsideMap(map, x, y)
  return x > 0 and y > 0 and x <= map.width and y <= map.height
end

local mapmt = {
  __index = Map,
  __call = function(self, x, y)
    if isInsideMap(self, x, y) then return self.cells[y][x] end
  end,
  __tostring = function(self)
    local buffer = {}
    for y = 1, self.height do
      for x = 1, self.width do
        table.insert(buffer, self(x,y).obstacle and "#" or " ")
      end
      table.insert(buffer, "\n")
    end
    return table.concat(buffer, "")
  end

}

local function parseObstacles(map, str)
  local x,y = 1,1
  for row in str:gmatch("[^\n]+") do
    x = 1
    for character in row:gmatch(".") do
      if character ~= " " then map(x,y).obstacle = true end
      x = x + 1
    end
    y = y + 1
  end
end

local function getDimensions(str)
  local width, height = 0, 0
  for row in str:gmatch("[^\n]+") do
    height = height + 1
    width = math.max(width, #row)
  end
  return width, height
end

local function createCells(map)
  for y=1, map.height do
    map.cells[y] = {}
    for x=1, map.width do
      map.cells[y][x] = Cell:new(x,y)
    end
  end
end

function Map:parse(str)
  assert(type(str) == 'string', "Parameter of type string expected")

  str = str:match("^[\n]?(.-)[\n]?$")

  local map = Map:new(getDimensions(str))
  parseObstacles(map, str)

  return map
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
