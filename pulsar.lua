local path = require 'path'

local pulsar = {}

function pulsar:findPath(map, origin, destination, h, g)
  if origin == destination then return path:new() end
  return path:new(destination)
end


return pulsar
