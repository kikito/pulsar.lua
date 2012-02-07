local colors = require 'colors'

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

-- screen/grid relationship

Grid.cellWidth = 16
Grid.cellHeight = 16

local left,top = 8, 66

-- transform a cell's row and column into screen pixel coordinates
function Grid:grid2screen(x,y)
  return left + (x-1) * Grid.cellWidth,
         top  + (y-1) * Grid.cellHeight
end

-- given a pixel coordinate, return the coordinates of the cell containing it
function Grid:screen2grid(wx, wy)
  return math.floor((wx - left) / Grid.cellWidth) + 1,
         math.floor((wy - top ) / Grid.cellHeight) + 1
end

-- drawing functions

local function drawCell(self, cell)
  local x,y = self:grid2screen(cell.x, cell.y)

  local bgcolor = nil
  if      self.origin == cell then
    bgcolor = colors.red
  elseif  self.destination == cell then
    bgcolor = colors.green
  end
  if bgcolor then
    love.graphics.setColor(bgcolor)
    love.graphics.rectangle('fill', x, y, self.cellWidth, self.cellHeight)
  end

  if self.highlighted == cell then
    love.graphics.setColor(colors.white)
    love.graphics.setLineWidth(3)
  else
    love.graphics.setColor(colors.gray)
    love.graphics.setLineWidth(1)
  end
  love.graphics.rectangle('line', x, y, self.cellWidth, self.cellHeight)
end

function Grid:draw()
  for x=1, self.rows do
    for y=1, self.columns do
      drawCell(self, self:getCell(x,y))
    end
  end
end

return Grid
