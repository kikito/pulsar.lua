local squareGrid = require( (...):match("(.-)[^%.]+$") .. 'core')

local Grid = {}

local function buildCells(rows, columns)
  local cells = {}
  for y=1, rows do
    cells[y] = {}
    for x=1, columns do
      cells[y][x] = squareGrid.newCell(x,y)
    end
  end
  return cells
end

function Grid:getCell(x,y)
  return self.cells[y] and self.cells[y][x]
end

local Gridmt = {
  __index = Grid,
  __call = Grid.getCell
}

local function newGrid(rows, columns)
  return setmetatable({
      cells = buildCells(rows, columns),
      rows = rows,
      columns = columns
    },
    Gridmt
  )
end

return newGrid
