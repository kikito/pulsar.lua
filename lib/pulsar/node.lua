local Node = {}

local alpha = 0.4999
local beta = 1-alpha

function Node:calculateF()
  self.f = alpha*self.g + beta*self.h
end

local Nodemt = {
  __index = Node,
  __tostring = function(self)
    return table.concat({ tostring(self.location), " ", self.direction, " g:", self.g, " h:", self.h, " f:", self.f })
  end
}

local function newNode(location, parent, direction, g, h)
  local node = setmetatable({
      location = location,
      parent = parent,
      direction = direction,
      g = g,
      h = h
    },
    Nodemt
  )
  node:calculateF()

  return node
end

return newNode
