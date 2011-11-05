local inspect = require 'inspect'
local grid = {}

grid.cell = {}


local cellmt = {
  __eq = function(cell1, cell2)
    return cell1.x == cell2.x and cell1.y == cell2.y
  end,
  __tostring = function(self)
    return '{' .. tostring(self.x) .. ',' .. tostring(self.y) .. '}'
  end
}

function grid.cell:new(x,y)
  return setmetatable({x = x, y = y}, cellmt)
end


local mapmt = {
  __index = {
    getCell = function(self, x, y)
      if x < self.width and x > 0 and y < self.height and y > 0 then
        return grid.cell:new(x,y)
      end
    end
  }
}


function grid:new(width, height)
  return setmetatable({ width = width, height = height }, mapmt)
end



return grid
