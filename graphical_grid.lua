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

local function max(a,b)
  return a > b and a or b
end

local function calculateMaxF(finder)
  local maxF = 0
  if finder then
    for _,node in pairs(finder.nodes) do
      if node.f ~= math.huge then maxF = max(maxF,node.f) end
    end
  end
  return maxF
end


local function calculateCellFormat(cell, finder, maxF, origin, destination, highlighted)
  local bgColor, lineWidth, lineColor = nil, 1, colors.gray

  if cell == origin then
    bgColor = colors.red
  elseif  cell == destination then
    bgColor = colors.green
  elseif cell.obstacle then
    bgColor = colors.blue
  elseif finder then
    local node = finder.nodes[cell]
    if node then
      local x = 256/(maxF+1)
      bgColor = { math.floor(node.h*x/2), math.floor(node.f*x), math.floor(node.g*x/2) }
    end
  end

  if cell == highlighted then
    lineWidth = 3
    lineColor = colors.white
  end

  return bgColor, lineWidth, lineColor
end

local function drawCell(cell, finder, origin, destination, highlighted)
  local x,y = graphicalGrid.grid2world(cell.x, cell.y)

  local bgColor, lineWidth, lineColor = calculateCellFormat(cell, finder, origin, destination, highlighted)

  if bgColor then
    love.graphics.setColor(bgColor)
    love.graphics.rectangle('fill', x, y, cellWidth, cellHeight)
  end

  love.graphics.setColor(lineColor)
  love.graphics.setLineWidth(lineWidth)
  love.graphics.rectangle('line', x, y, cellWidth, cellHeight)
end


function graphicalGrid.draw(grid, finder, origin, destination, highlighted)
  local maxF = calculateMaxF(finder)
  for x=1, grid.columns do
    for y=1, grid.rows do
      drawCell(grid:getCell(x,y), finder, maxF, origin, destination, highlighted)
    end
  end
end

return graphicalGrid
