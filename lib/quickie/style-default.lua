-- default style
local color = {
  normal = {bg = {145,145,145,200}, fg = {60,60,60,255}},
  hot    = {bg = {145,153,153,200}, fg = {60,60,60,255}},
  active = {bg = {145,153,153,255}, fg = {60,60,60,255}}
}

-- load default font
if not love.graphics.getFont() then
  love.graphics.setFont(love.graphics.newFont(12))
end

local function box(state, x,y,w,h)
  local c = color[state]
  if state ~= 'normal' then
    love.graphics.setColor(c.fg)
    love.graphics.rectangle('fill', x+3,y+3,w,h)
  end
  love.graphics.setColor(c.bg)
  love.graphics.rectangle('fill', x,y,w,h)
  love.graphics.setColor(c.fg)
end


local function Button(state, title, x,y,w,h)
  box(state, x,y,w,h)
  local f = love.graphics.getFont()
  love.graphics.printf(title, x, y + (h-f:getHeight())/2, w, 'center')
end

local function Slider(state, fraction, x,y,w,h)
  box(state, x,y,w,h)
  love.graphics.rectangle('fill', x,y,w*fraction,h)
end

-- the style
return {
  color    = color,
  Button   = Button,
  Slider   = Slider,
}
