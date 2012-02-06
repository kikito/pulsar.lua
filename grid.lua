local Grid = {}
local methods = {}

local rows, columns = 49,30
local cellWidth, cellHeight = 16,16
local left,top = 8, 100

local function grid2world(x,y)
  return left + (x-1) * cellWidth,
         top  + (y-1) * cellHeight
end

local function world2grid(wx, wy)
  return math.floor((wx - left) / cellWidth) + 1,
         math.floor((wy - top ) / cellHeight) + 1
end

local function drawCell(cell, isHighlighted)
  local x,y = grid2world(cell.x, cell.y)
  if isHighlighted then
    love.graphics.setColor(255,255,255,255)
    love.graphics.setLineWidth(3)
  else
    love.graphics.setColor(255, 255, 255, 100)
    love.graphics.setLineWidth(1)
  end
  love.graphics.rectangle('line', x, y, cellWidth, cellHeight)
end

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

function methods:draw()
  local cell = nil
  for x=1, rows do
    for y=1, columns do
      cell = self(x,y)
      drawCell(cell, self.highlighted == cell)
    end
  end
end

function methods:getCell(x,y)
  return self.cells[y] and self.cells[y][x]
end

function methods:getCellByWorldCoordinates(wx,wy)
  return self:getCell(world2grid(wx,wy))
end

function methods:setOrigin(cell)
  self.origin = cell
end

function methods:setDestination(cell)
  self.destination = cell
end

function methods:toggleObstacle(cell)
  cell.obstacle = not cell.obstacle
end

function methods:setHighlighted(cell)
  self.highlighted = cell
end

function Grid.new()
  return setmetatable({
    cells = buildCells()
  },{
    __index = methods,
    __call = methods.getCell
  })
end


return Grid
