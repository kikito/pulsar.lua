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

function methods:setHighlight(value)
  self.highlighted = value
end

function methods:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  love.graphics.setColor(255,255,255)
  love.graphics.setLineWidth(self.highlighted and 3 or 1)
  love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
  love.graphics.printf(self.label, self.x, yOffset(self), self.width, "center")
end

function methods:mousepressed(x,y)
  if isInside(self, x, y) then self.callback() end
end

function Button.new(label, color, x,y, width,height, callback)
  local b = setmetatable(
    { label = label, color = color, x = x, y = y, width = width, height = height, callback = callback },
    { __index = methods }
  )
  return b
end

return Button
