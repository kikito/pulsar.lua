local colors = require 'colors'


local cellWidth  = 16
local cellHeight = 16
local left       =  8
local top        = 66

local graphicalGrid = { cellWidth  = cellWidth, cellHeight = cellHeight, left = left, top = top }


function graphicalGrid.world2grid(wx, wy)
  return math.floor((wx - left) / cellWidth) + 1,
         math.floor((wy - top ) / cellHeight) + 1
end

function graphicalGrid.grid2world(x,y)
  return left + (x-1) * cellWidth,
         top  + (y-1) * cellHeight
end


local function calculateCellFormat(cell, origin, destination, highlighted)
  local bgColor, lineWidth, lineColor = nil, 1, colors.gray

  if cell == origin then
    bgColor = colors.red
  elseif  cell == destination then
    bgColor = colors.green
  elseif cell.obstacle then
    bgColor = colors.blue
  end

  if cell == highlighted then
    lineWidth = 3
    lineColor = colors.white
  end

  return bgColor, lineWidth, lineColor
end

local function drawCell(cell, origin, destination, highlighted)
  local x,y = graphicalGrid.grid2world(cell.x, cell.y)

  local bgColor, lineWidth, lineColor = calculateCellFormat(cell, origin, destination, highlighted)

  if bgColor then
    love.graphics.setColor(bgColor)
    love.graphics.rectangle('fill', x, y, cellWidth, cellHeight)
  end

  love.graphics.setColor(lineColor)
  love.graphics.setLineWidth(lineWidth)
  love.graphics.rectangle('line', x, y, cellWidth, cellHeight)
end


function graphicalGrid.draw(grid, origin, destination, highlighted)
  for x=1, grid.columns do
    for y=1, grid.rows do
      drawCell(grid:getCell(x,y), origin, destination, highlighted)
    end
  end
end

return graphicalGrid
