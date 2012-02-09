
local function copy(t)
  local cp = {}
  for i=1,#t do cp[i] = t[i] end
  return cp
end

local pathmt = {

  __tostring = function(self)

    local buffer = {}
    for i=1,#self do
      buffer[#buffer+1] = tostring(self[i])
    end
    return ("{ %s }"):format(table.concat(buffer, ', '))

  end,

  __eq = function(self, other)

    local myLength = #self
    if myLength ~= #other then return false end

    for i=1, myLength do
      if self[i] ~= other[i] then return false end
    end

    return true
  end
}

local function newPath(locations)
  return setmetatable(copy(locations), pathmt)
end

return newPath
