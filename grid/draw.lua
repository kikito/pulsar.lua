-- this file has methods for drawing the grid in the screen; and nothing else

local Grid = require 'grid.base'

local function drawCell(self, cell)
  local x,y = self:grid2screen(cell.x, cell.y)
  if self.highlighted == cell then
    love.graphics.setColor(255,255,255,255)
    love.graphics.setLineWidth(3)
  else
    love.graphics.setColor(255, 255, 255, 100)
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
