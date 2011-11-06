local Cell = {}

local cellmt = {
  __tostring = function(self)
    return '{' .. tostring(self.x) .. ',' .. tostring(self.y) .. '}'
  end,
  __index = {
    getManhattanDistance = function(self, other)
      return math.abs(other.x - self.x) + math.abs(other.y - self.y)
    end
  }
}

function Cell:new(x,y)
  return setmetatable({x = x, y = y}, cellmt)
end


local Map = {}

local neighborDirections = {
  {  0, -1 },
  {  1,  0 },
  {  0,  1 },
  { -1,  0 }
}

local function isInsideMap(map, x, y)
  return x > 0 and y > 0 and x <= map.width and y <= map.height
end

local mapmt = {
  __index = {
    getCell = function(self, x, y)
      if isInsideMap(self, x, y) then return self.cells[x][y] end
    end,
    getNeighbors = function(self, cell)
      local neighbors = {}
      local x,y = cell.x, cell.y
      local neighbor, dir
      for i=1, #neighborDirections do
        dir = neighborDirections[i]
        neighbor = self:getCell(x+dir[1], y+dir[2])
        if neighbor then table.insert(neighbors, neighbor) end
      end
      return neighbors
    end
  }
}

function Map:new(width, height)
  local map = {width = width, height = height, cells = {}}

  for x=1,width do
    map.cells[x] = {}
    for y=1,height do
      map.cells[x][y] = Cell:new(x,y)
    end
  end

  return setmetatable(map, mapmt)
end

local grid = {}

grid.Cell = Cell
grid.Map = Map

return grid
