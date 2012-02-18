local core = require((...):match("^(.+)%.[^%.]+") .. '.core')

return function(info, x,y,w,h, draw)
  assert(type(info) == 'table' and info.value, "Incomplete slider value info")
  info.min = info.min or 0
  info.max = info.max or math.max(info.value, 1)
  info.step = info.step or (info.max - info.min) / 50
  local fraction = (info.value - info.min) / (info.max - info.min)

  local id = core.generateID()
  core.mouse.updateState(id, x,y,w,h)
  core.registerDraw(id,draw or core.style.Slider, fraction, x,y,w,h, info.vertical)

  -- mouse update
  if core.isActive(id) then
    fraction = math.min(1, math.max(0, (core.mouse.x - x) / w))
    local v = fraction * (info.max - info.min) + info.min
    if v ~= info.value then
      info.value = v
      return true
    end
  end
end
