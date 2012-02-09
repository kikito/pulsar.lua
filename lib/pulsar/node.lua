local function newNode(location, parent, direction, g, h)
  local node = {
    location = location,
    parent = parent,
    direction = direction,
    g = g,
    h = h,
    f = g + h
  }
  return node
end

return newNode
