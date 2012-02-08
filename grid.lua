local colors = require 'colors'
local Cell   = require 'cell'

local Grid = {}

local columns, rows = 49,32

local function buildCells()
  local cells = {}
  for y=1, rows do
    cells[y] = {}
    for x=1, columns do
      cells[y][x] = Cell.new(x,y)
    end
  end
  return cells
end

function Grid:getCell(x,y)
  return self.cells[y] and self.cells[y][x]
end

function Grid:setOrigin(x,y)
  if self.origin then self.origin.origin = false end
  self.origin = self(x,y)
  if self.origin then self.origin.origin = true end
end

function Grid:setDestination(x,y)
  if self.destination then self.destination.destination = false end
  self.destination = self:getCell(x,y)
  if self.destination then self.destination.destination = true end
end

function Grid:setObstacle(x,y,value)
  local cell = self(x,y)
  if cell then cell.obstacle = value end
end

function Grid:setHighlighted(x,y)
  if self.highlighted then self.highlighted.highlighted = false end
  self.highlighted = self(x,y)
  if self.highlighted then self.highlighted.highlighted = true end
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

-- drawing functions
function Grid:draw()
  for x=1, self.columns do
    for y=1, self.rows do
      self(x,y):draw()
    end
  end
  local cx, cy = self(1, rows):screenCoordinates()
  cy = cy + Cell.width + 5
  love.graphics.print(tostring(self.highlighted), cx, cy)
end

return Grid
