
local beholder = require 'lib.beholder'

local Button = {}
local methods = {}

local function isInside(self, x, y)
  return x >= self.x and x <= self.x + self.width and
         y >= self.y and y <= self.y + self.height
end

local function yOffset(self)
  local font = love.graphics.getFont()
  local fontHeight = font:getHeight()
  return self.y + self.height/2 - fontHeight/2
end


function methods:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  love.graphics.setColor(255,255,255)
  love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
  love.graphics.printf(self.label, self.x, yOffset(self), self.width, "center")
end

function Button.new(label, color, x,y, width,height, callback)
  local b = setmetatable(
    { label = label, color = color, x = x, y = y, width = width, height = height, callback = callback },
    { __index = methods }
  )
  beholder.observe('mousepressed', 'l', function(x,y)
    if isInside(b, x, y) then b.callback() end
  end)
  return b
end

return Button
