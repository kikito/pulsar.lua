local inspect = require 'lib.inspect'
local buttons = require 'buttons'
local colors = require 'colors'
local pulsar = require 'lib.pulsar'


local Cell   = require 'cell'
local Grid   = require 'grid'

local game = {}
local states = {}
local currentState = {}

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

local function setState(stateName)
  currentState = states[stateName]
end

function game.initialize(g)
  grid = Grid.new()

  buttons.add('Origin',      colors.red,    function() setState('settingOrigin') end)
  buttons.add('Destination', colors.green,  function() setState('settingDestination') end)
  buttons.add('Obstacle',    colors.blue,   function() setState('preparedToSetObstacles') end)
  buttons.add('Eraser',      colors.gray,   function() setState('preparedToEraseObstacles') end)
end

function game.draw()
  buttons.draw()
  grid:draw()
end

function game.update()
  grid:setHighlighted(Cell.getCellCoordinatesFromPixel(love.mouse.getPosition()))
  if currentState.update then currentState.update() end
  if finder then
    if not finder:done() then
      finder:step()
      if finder:done() then print(finder:buildPath()) end
    end
  end
end

function game.mousepressed(x,y)
  buttons.mousepressed(x,y)
  if currentState.mousepressed then currentState.mousepressed(x,y) end
end

function game.mousereleased(x,y)
  if currentState.mousereleased then currentState.mousereleased(x,y) end
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
    game.set('settingObstacles')
  end
}
states.settingObstacles = {
  mousereleased = function()
    game.set('preparedToSetObstacles')
    resetFinder()
  end,
  update = function()
    local x, y = Cell.getCellCoordinatesFromPixel(love.mouse.getPosition())
    grid:setObstacle(x,y,true)
  end
}
states.preparedToEraseObstacles = {
  mousepressed = function(x,y)
    game.set('erasingObstacles')
  end
}
states.erasingObstacles = {
  mousereleased = function()
    game.set('preparedToEraseObstacles')
    resetFinder()
  end,
  update = function()
    local x, y = Cell.getCellCoordinatesFromPixel(love.mouse.getPosition())
    grid:setObstacle(x,y,false)
  end
}

return game
