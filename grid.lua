local grid = {}

grid.Cell = {}

local cellmt = {
  __eq = function(cell1, cell2)
    return cell1.x == cell2.x and cell1.y == cell2.y
  end,
  __tostring = function(self)
    return '{' .. tostring(self.x) .. ',' .. tostring(self.y) .. '}'
  end,
  __index = {
    getManhattanDistance = function(self, other)
      return math.abs(other.x - self.x) + math.abs(other.y - self.y)
    end
  }
}

function grid.Cell:new(x,y)
  return setmetatable({x = x, y = y}, cellmt)
end


grid.Map = {}

local mapmt = {
  __index = {
    getCell = function(self, x, y)
      if x <= self.width and x > 0 and y <= self.height and y > 0 then
        return grid.Cell:new(x,y)
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

function grid.Map:new(width, height)
  return setmetatable({ width = width, height = height }, mapmt)
end

return grid
