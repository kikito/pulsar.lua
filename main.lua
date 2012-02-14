local game    = require 'game'

function love.load()
  game.initialize()

  local defaultFont = love.graphics.newFont(12)
  love.graphics.setFont(defaultFont)
end


function love.draw()
  game.draw()
end

function love.update(dt)
  game.update(dt)
end

function love.mousepressed(x,y,button)
  if button == 'l' then
    game.mousepressed(x,y)
  end
end

function love.mousereleased(x,y,button)
  if button == 'l' then
    game.mousereleased(x,y)
  end
end

function love.keypressed(key)
  if key == 'escape' then love.event.push('q') end
end

