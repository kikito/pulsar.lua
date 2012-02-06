

local pulsar   = require 'lib.pulsar'
local beholder = require 'lib.beholder'
local Button   = require 'lib.button'

local Grid = require 'grid'


local buttons = {}
local defaultFont
local grid

function love.load()
  defaultFont = love.graphics.newFont(12)
  local red, green, blue = {128,0,0}, {0,128,0}, {0,0,128}

  buttons.origin       = Button.new('Origin',      red,     8, 30, 90, 50, function() print 'origin' end)
  buttons.destination  = Button.new('Destination', green, 108, 30, 90, 50, function() print 'destination' end)
  buttons.obstacle     = Button.new('Obstacle',    blue,  208, 30, 90, 50, function() print 'obstacle' end)

  grid = Grid.new()
end


function love.draw()
  love.graphics.setFont(defaultFont)
  for _,b in pairs(buttons) do
    b:draw()
  end
  grid:draw()
end

function love.update()
  grid:setHighlighted(grid:getCellByWorldCoordinates(love.mouse.getPosition()))
end

function love.mousepressed(x,y,button)
  beholder.trigger('mousepressed', button, x, y) -- swapped button and x,y
end

function love.keypressed(key)
  if key == 'escape' then love.event.push('q') end
end

