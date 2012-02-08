local pulsar   = require 'lib.pulsar'

local buttons = require 'buttons'
local colors  = require 'colors'

local Cell    = require 'cell'
local Grid    = require 'grid'

local grid

local states = {
  none = {
    mousepressed = function() end,
    mousereleased = function() end
  },
  settingOrigin = {
    mousepressed = function(x,y)
      grid:setOrigin(Cell.getCellCoordinatesFromPixel(x,y))
    end,
    mousereleased = function() end
  },
  settingDestination = {
    mousepressed = function(x,y)
      grid:setDestination(Cell.getCellCoordinatesFromPixel(x,y))
    end,
    mousereleased = function() end
  }
}

local currentState = states.none

function love.load()
  buttons.add('Origin',      colors.red,   function() currentState = states.settingOrigin end)
  buttons.add('Destination', colors.green, function() currentState = states.settingDestination end)
  buttons.add('Obstacle',    colors.blue,  function() print 'obstacle' end)

  grid = Grid.new()

  local defaultFont = love.graphics.newFont(12)
  love.graphics.setFont(defaultFont)
end


function love.draw()
  buttons.draw()
  grid:draw()
end

function love.update()
  grid:setHighlighted(Cell.getCellCoordinatesFromPixel(love.mouse.getPosition()))
end

function love.mousepressed(x,y,button)
  if button == 'l' then
    buttons.mousepressed(x,y)
    currentState.mousepressed(x,y)
  end
end

function love.keypressed(key)
  if key == 'escape' then love.event.push('q') end
end

