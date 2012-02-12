local Node = {}

local alpha = 0.4999
local beta = 1-alpha

Node.alpha = alpha
Node.beta = beta

function Node:calculateF()
  self.f = alpha*self.g + beta*self.h
end

local Nodemt = {
  __index = Node,
  __tostring = function(self)
    return table.concat({
      tostring(self.location), " ", tostring(self.direction),
      " g:", tostring(self.g), " h:", tostring(self.h), " f:", tostring(self.f) 
    })
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
