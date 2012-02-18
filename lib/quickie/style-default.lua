-- default style
local color = {
  normal = {bg = {128,128,128,200}, fg = {59,59,59,200}},
  hot    = {bg = {145,153,153,200}, fg = {60,61,54,200}},
  active = {bg = {145,153,153,255}, fg = {60,61,54,255}}
}

-- load default font
if not love.graphics.getFont() then
  love.graphics.setFont(love.graphics.newFont(12))
end

local function Button(state, title, x,y,w,h)
  local c = color[state]
  if state ~= 'normal' then
    love.graphics.setColor(c.fg)
    love.graphics.rectangle('fill', x+3,y+3,w,h)
  end
  love.graphics.setColor(c.bg)
  love.graphics.rectangle('fill', x,y,w,h)
  love.graphics.setColor(c.fg)
  local f = love.graphics.getFont()
  love.graphics.print(title, x + (w-f:getWidth(title))/2, y + (h-f:getHeight(title))/2)
end

local function Slider(state, fraction, x,y,w,h, vertical)
  local c = color[state]
  if state ~= 'normal' then
    love.graphics.setColor(c.fg)
    love.graphics.rectangle('fill', x+3,y+3,w,h)
  end
  love.graphics.setColor(c.bg)
  love.graphics.rectangle('fill', x,y,w,h)

  love.graphics.setColor(c.fg)
  local hw,hh = w,h
  if vertical then
    hh = h * fraction
    y = y + (h - hh)
  else
    hw = w * fraction
  end
  love.graphics.rectangle('fill', x,y,hw,hh)
end

-- the style
return {
  color    = color,
  Button   = Button,
  Slider   = Slider,
}
