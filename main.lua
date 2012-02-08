local pulsar   = require 'lib.pulsar'

local buttons = require 'buttons'
local colors  = require 'colors'

local Cell    = require 'cell'
local Grid    = require 'grid'

local states  = require 'states'

local grid

function love.load()
  grid = Grid.new()

  states.initialize(grid)

  buttons.add('Origin',      colors.red,    function() states.set('settingOrigin') end)
  buttons.add('Destination', colors.green,  function() states.set('settingDestination') end)
  buttons.add('Obstacle',    colors.blue,   function() states.set('preparedToSetObstacles') end)
  buttons.add('Eraser',      colors.gray,   function() states.set('preparedToEraseObstacles') end)

  local defaultFont = love.graphics.newFont(12)
  love.graphics.setFont(defaultFont)
end


function love.draw()
  buttons.draw()
  grid:draw()
end

function love.update()
  grid:setHighlighted(Cell.getCellCoordinatesFromPixel(love.mouse.getPosition()))
  states.update()
end

function love.mousepressed(x,y,button)
  if button == 'l' then
    buttons.mousepressed(x,y)
    states.mousepressed(x,y)
  end
end

function love.mousereleased(x,y,button)
  if button == 'l' then
    states.mousereleased(x,y)
  end
end

function love.keypressed(key)
  if key == 'escape' then love.event.push('q') end
end

