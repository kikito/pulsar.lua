local colors = require 'colors'

local Cell = {}

Cell.width, Cell.height  = 16,16
local left, top = 8, 66

-- given a pixel, return the coordinates of the cell containing it
-- does not check that the cell exists
-- usage: Cell.getCellCoordinatesFromPixel(100,200)
function Cell.getCellCoordinatesFromPixel(px, py)
  return math.floor((px - left) / Cell.width) + 1,
         math.floor((py - top ) / Cell.height) + 1
end

-- returns the screen coordinates of "self"
-- self must exist and be a cell
-- usage: cell:screenCoordinates()
function Cell:screenCoordinates()
  return left + (self.x-1) * Cell.width,
         top  + (self.y-1) * Cell.height
end


local function calculateFormat(self)
  local bgColor, lineWidth, lineColor = nil, 1, colors.gray

  if self.origin then
    bgColor = colors.red
  elseif  self.destination then
    bgColor = colors.green
  elseif self.obstacle then
    bgColor = colors.blue
  end

  if self.highlighted then
    lineWidth = 3
    lineColor = colors.white
  end

  return bgColor, lineWidth, lineColor
end

function Cell:draw()
  local x,y = self:screenCoordinates()

  local bgColor, lineWidth, lineColor = calculateFormat(self)

  if bgColor then
    love.graphics.setColor(bgColor)
    love.graphics.rectangle('fill', x, y, Cell.width, Cell.height)
  end

  love.graphics.setColor(lineColor)
  love.graphics.setLineWidth(lineWidth)
  love.graphics.rectangle('line', x, y, Cell.width, Cell.height)
end


local Cellmt = {
  __index = Cell,
  __tostring = function(self)
    local buffer = {'(', self.x, ',', self.y, ')'}
    if self.origin      then buffer[#buffer + 1] = ', origin' end
    if self.destination then buffer[#buffer + 1] = ', destination' end
    if self.obstacle    then buffer[#buffer + 1] = ', obstacle' end
    return table.concat(buffer, '')
  end
}

Cell.new = function(x,y)
  return setmetatable({x=x, y=y}, Cellmt)
end


return Cell
