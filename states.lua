local inspect = require 'lib.inspect'
local pulsar = require 'lib.pulsar'
local Cell   = require 'cell'

local states = {}

local current = {}
local grid = nil
local finder = nil

local function resetFinder()
  if grid.origin and grid.destination then
    finder = pulsar.newFinder(
      grid.origin,
      grid.destination,
      pulsar.squareGrid.neighbors.fourDirections(grid),
      pulsar.squareGrid.costs.avoidObstacles,
      pulsar.squareGrid.heuristics.manhattan
    )
  else
    finder = nil
  end
end


function states.initialize(g)
  grid = g
end

function states.set(stateName)
  current = states[stateName]
end

function states.update()
  if current.update then current.update() end
  if finder and finder:done() then
    print(inspect(finder))
    finder:step()
  end
end

function states.mousepressed(x,y)
  if current.mousepressed then current.mousepressed(x,y) end
end

function states.mousereleased(x,y)
  if current.mousereleased then current.mousereleased(x,y) end
end


states.settingOrigin = {
  mousepressed = function(x,y)
    grid:setOrigin(Cell.getCellCoordinatesFromPixel(x,y))
    resetFinder()
  end
}
states.settingDestination = {
  mousepressed = function(x,y)
    grid:setDestination(Cell.getCellCoordinatesFromPixel(x,y))
    resetFinder()
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
    resetFinder()
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
    resetFinder()
  end,
  update = function()
    local x, y = Cell.getCellCoordinatesFromPixel(love.mouse.getPosition())
    grid:setObstacle(x,y,false)
  end
}

return states
