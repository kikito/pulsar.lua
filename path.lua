local path = {}


pathmt = {

  __tostring = function(self)

    local buffer = {}
    for i=1,#self do
      table.insert(buffer, tostring(self[i]))
    end
    return '{ ' .. table.concat(buffer, ', ') .. ' }'

  end,

  __eq = function(self, other)

    local myLength, otherLength = #self, #other
    if myLength ~= otherLength then return false end

    for i=1, myLength do
      if self[i] ~= other[i] then return false end
    end

    return true
  end
}

function path:new(...)
  return setmetatable({...}, pathmt)
end

return path
