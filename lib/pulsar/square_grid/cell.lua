local cellmt = {
  __index = Cell,
  __tostring = function(self)
    return ("{%d,%d}"):format(self.x, self.y)
  end
}

local function newCell(x,y)
  return setmetatable({x = x, y = y}, cellmt)
end

return newCell
