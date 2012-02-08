local pulsar   = require 'lib.pulsar'

local buttons = require 'buttons'
local colors  = require 'colors'

local Cell    = require 'cell'
local Grid    = require 'grid'

local grid

local currentState

local states = {}

states.none = {}

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
    currentState = states.settingObstacles
  end
}
states.settingObstacles = {
  mousereleased = function()
    currentState = states.preparedToSetObstacles
  end,
  update = function()
    local x, y = Cell.getCellCoordinatesFromPixel(love.mouse.getPosition())
    grid:setObstacle(x,y,true)
  end
}
states.preparedToEraseObstacles = {
  mousepressed = function(x,y)
    currentState = states.erasingObstacles
  end
}
states.erasingObstacles = {
  mousereleased = function()
    currentState = states.preparedToEraseObstacles
  end,
  update = function()
    local x, y = Cell.getCellCoordinatesFromPixel(love.mouse.getPosition())
    grid:setObstacle(x,y,false)
  end
}

currentState = states.none

function love.load()
  buttons.add('Origin',      colors.red,    function() currentState = states.settingOrigin end)
  buttons.add('Destination', colors.green,  function() currentState = states.settingDestination end)
  buttons.add('Obstacle',    colors.blue,   function() currentState = states.preparedToSetObstacles end)
  buttons.add('Eraser',      colors.gray,   function() currentState = states.preparedToEraseObstacles end)

  grid = Grid.new()

  local defaultFont = love.graphics.newFont(12)
  love.graphics.setFont(defaultFont)
end


function love.draw()
  buttons.draw()
  grid:draw()
  if grid.highlighted then
    love.graphics.print(tostring(grid.highlighted), 8, 580)
  end
end

function love.update()
  grid:setHighlighted(Cell.getCellCoordinatesFromPixel(love.mouse.getPosition()))
  if currentState.update then currentState.update() end
end

function love.mousepressed(x,y,button)
  if button == 'l' then
    buttons.mousepressed(x,y)
    if currentState.mousepressed then currentState.mousepressed(x,y) end
  end
end

function love.mousereleased(x,y,button)
  if button == 'l' then
    if currentState.mousereleased then currentState.mousereleased(x,y) end
  end
end

function love.keypressed(key)
  if key == 'escape' then love.event.push('q') end
end

