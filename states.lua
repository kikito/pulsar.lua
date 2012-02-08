local Cell = require 'cell'


local states = {}

local current = {}
local grid = nil



function states.set(stateName)
  current = states[stateName]
end

function states.update()
  if current.update then current.update() end
end

function states.mousepressed(x,y)
  if current.mousepressed then current.mousepressed(x,y) end
end

function states.mousereleased(x,y)
  if current.mousereleased then current.mousereleased(x,y) end
end

function states.initialize(grd)
  grid = grd
end

states.settingOrigin = {
  mousepressed = function(x,y)
    grid:setOrigin(Cell.getCellCoordinatesFromPixel(x,y))
  end
}
states.settingDestination = {
  mousepressed = function(x,y)
    grid:setDestination(Cell.getCellCoordinatesFromPixel(x,y))
  end
}
states.preparedToSetObstacles = {
  mousepressed = function(x,y)
    states.set('settingObstacles')
  end
}
states.settingObstacles = {
  mousereleased = function()
    states.set('preparedToSetObstacles')
  end,
  update = function()
    local x, y = Cell.getCellCoordinatesFromPixel(love.mouse.getPosition())
    grid:setObstacle(x,y,true)
  end
}
states.preparedToEraseObstacles = {
  mousepressed = function(x,y)
    states.set('erasingObstacles')
  end
}
states.erasingObstacles = {
  mousereleased = function()
    states.set('preparedToEraseObstacles')
  end,
  update = function()
    local x, y = Cell.getCellCoordinatesFromPixel(love.mouse.getPosition())
    grid:setObstacle(x,y,false)
  end
}

return states
