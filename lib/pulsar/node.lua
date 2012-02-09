local function newNode(location, parent, g, h)
  local node = {
    parent = parent,
    location = location,
    g = g,
    h = h,
    f = g + h
  }
  return node
end

return newNode
