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

local function calculateCellBorderFormat(cell, highlighted)
  if cell == highlighted then return 3, colors.white end
  return 1, colors.gray
end

local function drawCellBorder(x,y,borderWidth,borderColor)
  love.graphics.setColor(borderColor)
  love.graphics.setLineWidth(borderWidth)
  love.graphics.rectangle('line', x, y, cellWidth, cellHeight)
end

local function calculateCellBgColor(cell, finder, maxF, origin, destination, defaultBgColor)
  local bgColor = nil

  if cell == origin      then return colors.red   end
  if cell == destination then return colors.green end
  if cell.obstacle       then return colors.gray  end
  if finder then
    local node = finder.nodes[cell]
    if node then
      local x = 256/(maxF+1)
      return { math.floor(node.h*x/2), math.floor(node.f*x), math.floor(node.g*x/2) }
    end
  end
  return defaultBgColor
end

local function drawCellBg(x,y,bgColor)
  if bgColor then
    love.graphics.setColor(bgColor)
    love.graphics.rectangle('fill', x, y, cellWidth, cellHeight)
  end
end


local function drawCell(cell, finder, maxF, origin, destination, highlighted, defaultBgColor)
  local x,y = graphicalGrid.grid2world(cell.x, cell.y)

  drawCellBg(    x,y, calculateCellBgColor(cell, finder, maxF, origin, destination, defaultBgColor))
  drawCellBorder(x,y, calculateCellBorderFormat(cell, highlighted))
end

function graphicalGrid.drawGrid(grid, finder, origin, destination, highlighted)
  local maxF = calculateMaxF(finder)
  for x=1, grid.columns do
    for y=1, grid.rows do
      drawCell(grid:getCell(x,y), finder, maxF, origin, destination, highlighted)
    end
  end
end

function graphicalGrid.drawPath(finder, origin, destination, highlighted)
  if finder then
    local pathColor = finder:hasFoundPath() and colors.brightGreen or colors.brightRed
    local path = finder:buildPath()
    for i=1,#path do
      drawCell(path[i], nil, nil, origin, destination, highlighted, pathColor)
    end
  end
end

return graphicalGrid
