local Grid = {}

local rows, columns = 49,33

local function buildCells()
  local cells = {}
  for y=1, columns do
    cells[y] = {}
    for x=1, rows do
      cells[y][x] = {x=x,y=y}
    end
  end
  return cells
end

function Grid:getCell(x,y)
  return self.cells[y] and self.cells[y][x]
end

function Grid:setOrigin(x,y)
  self.origin = self:getCell(x,y)
end

function Grid:setDestination(x,y)
  self.destination = self:getCell(x,y)
end

function Grid:toggleObstacle(x,y)
  local cell = self:getCell(x,y)
  if cell then cell.obstacle = not cell.obstacle end
end

function Grid:setHighlighted(x,y)
  self.highlighted = self:getCell(x,y)
end

function Grid.new()
  return setmetatable({
    cells = buildCells(),
    rows = rows,
    columns = columns
  },{
    __index = Grid,
    __call = Grid.getCell
  })
end


return Grid
