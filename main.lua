local pulsar   = require 'lib.pulsar'
local beholder = require 'lib.beholder'

local buttons = require 'buttons'
local Grid    = require 'grid'

local grid

function love.load()
  local red, green, blue = {128,0,0}, {0,128,0}, {0,0,128}

  buttons.add('Origin',      red,   function() print 'origin' end)
  buttons.add('Destination', green, function() print 'destination' end)
  buttons.add('Obstacle',    blue,  function() print 'obstacle' end)

  grid = Grid.new()

  local defaultFont = love.graphics.newFont(12)
  love.graphics.setFont(defaultFont)
end


function love.draw()
  buttons.draw()
  grid:draw()
end

function love.update()
  grid:setHighlighted(grid:screen2grid(love.mouse.getPosition()))
end

function love.mousepressed(x,y,button)
  beholder.trigger('mousepressed', button, x, y) -- swapped button and x,y
end

function love.keypressed(key)
  if key == 'escape' then love.event.push('q') end
end

