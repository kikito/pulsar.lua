-- state
local context = {maxid = 0}
local NO_WIDGET = function()end

local function generateID()
  context.maxid = context.maxid + 1
  return context.maxid
end

local function setHot(id) context.hot = id end
local function isHot(id)  return context.hot == id end

local function setActive(id) context.active = id end
local function isActive(id)  return context.active == id end

-- input
local mouse = {x = 0, y = 0, down = false}

function mouse.inRect(x,y,w,h)
  return mouse.x >= x and mouse.x <= x+w and mouse.y >= y and mouse.y <= y+h
end

function mouse.updateState(id, x,y,w,h)
  if mouse.inRect(x,y,w,h) then
    setHot(id)
    if not context.active and mouse.down then
      setActive(id)
    end
  end
end

function mouse.releasedOn(id)
  return not mouse.down and isHot(id) and isActive(id)
end

-- helper functions
local function strictAnd(...)
  local n = select("#", ...)
  local ret = true
  for i = 1,n do ret = select(i, ...) and ret end
  return ret
end

local function strictOr(...)
  local n = select("#", ...)
  local ret = false
  for i = 1,n do ret = select(i, ...) or ret end
  return ret
end

-- allow packed nil
local function save_pack(...)
  return {n = select('#', ...), ...}
end

local function save_unpack(t, i)
  i = i or 1
  if i >= t.n then return t[i] end
  return t[i], save_unpack(t, i+1)
end

local draw_items = {n = 0}
local function registerDraw(id, f, ...)
  assert(type(f) == 'function' or (getmetatable(f) or {}).__call,
         'Drawing function is not a callable type!')

  local state = 'normal'
  if isHot(id) then
    state = isActive(id) and 'active' or 'hot'
  end
  local rest = save_pack(...)
  draw_items.n = draw_items.n + 1
  draw_items[draw_items.n] = function() f(state, save_unpack(rest)) end
end

-- actually update-and-draw
local function draw()
  -- close frame state
  if not mouse.down then -- released
    setActive(nil)
  elseif not context.active then -- clicked outside
    setActive(NO_WIDGET)
  end

  for i = 1,draw_items.n do draw_items[i]() end

  -- prepare for next frame
  draw_items.n = 0
  context.maxid = 0

  -- update mouse status
  setHot(nil)
  mouse.x, mouse.y = love.mouse.getPosition()
  mouse.down = love.mouse.isDown('l')

end

return {
  mouse        = mouse,

  generateID   = generateID,
  setHot       = setHot,
  setActive    = setActive,
  isHot        = isHot,
  isActive     = isActive,
  makeTabable  = makeTabable,

  style        = require((...):match("^(.+)%.[^%.]+") .. '.style-default'),
  color        = color,
  registerDraw = registerDraw,
  draw         = draw,

  strictAnd    = strictAnd,
  strictOr     = strictOr,
  save_pack    = save_pack,
  save_unpack  = save_unpack,
}
