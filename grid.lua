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

local mapmt = {
  __index = {
    getCell = function(self, x, y)
      if x <= self.width and x > 0 and y <= self.height and y > 0 then
        return self.cells[x][y]
      end
    end,
    getNeighbors = function(self, cell)
      local x,y = cell.x, cell.y
      local n1, n2, n3, n4 = self:getCell(x, y-1), self:getCell(x+1,y), self:getCell(x,y+1), self:getCell(x-1,y)
      local n = {}
      if n1 then table.insert(n, n1) end
      if n2 then table.insert(n, n2) end
      if n3 then table.insert(n, n3) end
      if n4 then table.insert(n, n4) end
      return n
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
