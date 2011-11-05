local grid = {}

grid.cell = {}


local cellmt = {
  __eq = function(cell1, cell2)
    return cell1[1] == cell2[1] and cell1[2] == cell2[2]
  end,
  __tostring = function(self)
    return '{' .. tostring(self[1]) .. ',' .. tostring(self[2]) .. '}'
  end
}

function grid.cell:new(x,y)
  return setmetatable({x,y}, cellmt)
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
