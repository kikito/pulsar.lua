local inspect = require 'lib.inspect'
local buttons = require 'buttons'
local colors = require 'colors'
local pulsar = require 'lib.pulsar'

local graphicalGrid = require 'graphical_grid'

local game = {}
local states = {}
local currentState = {}

local grid = nil
local finder = nil

local origin, destination, highlighted

local function setState(stateName)
  currentState = states[stateName]
end

function game.initialize(g)
  grid = pulsar.squareGrid.newGrid(32,49)

  buttons.add('Origin',      colors.red,    function() setState('settingOrigin') end)
  buttons.add('Destination', colors.green,  function() setState('settingDestination') end)
  buttons.add('Obstacle',    colors.blue,   function() setState('preparedToSetObstacles') end)
  buttons.add('Eraser',      colors.gray,   function() setState('preparedToEraseObstacles') end)
end

local function drawStatusLine()
  if highlighted then
    local x, y = graphicalGrid.grid2world(1, grid.rows + 1.5)
    local msg = { tostring(highlighted) }
    if finder then
      local node = finder.nodes[highlighted]
      if node then
        msg = { tostring(node) }
      end
    end
    if highlighted == origin      then msg[#msg+1] = "origin" end
    if highlighted == destination then msg[#msg+1] = "destination" end
    if highlighted.obstacle       then msg[#msg+1] = "obstacle" end

    love.graphics.setColor(colors.white)
    love.graphics.print(table.concat(msg, ' '), x, y)
  end
end

function game.draw()
  buttons.draw()
  graphicalGrid.draw(grid, finder, origin, destination, highlighted)
  drawStatusLine()
end

function game.update()
  highlighted = grid:getCell(graphicalGrid.world2grid(love.mouse.getPosition()))
  if currentState.update then currentState.update() end
  if finder then
    if not finder:done() then
      finder:walk(10)
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


local function resetFinder()
  if origin and destination then
    finder = pulsar.newFinder(
      origin,
      destination,
      pulsar.squareGrid.neighbors.fourDirections(grid),
      pulsar.squareGrid.costs.avoidObstacles,
      pulsar.squareGrid.heuristics.manhattan
    )
  else
    finder = nil
  end
end

states.settingOrigin = {
  mousepressed = function(x,y)
    origin = grid:getCell(graphicalGrid.world2grid(x,y))
    resetFinder()
  end
}
states.settingDestination = {
  mousepressed = function(x,y)
    destination = grid:getCell(graphicalGrid.world2grid(x,y))
    resetFinder()
  end
}
states.preparedToSetObstacles = {
  mousepressed = function(x,y)
    setState('settingObstacles')
  end
}
states.settingObstacles = {
  mousereleased = function()
    setState('preparedToSetObstacles')
    resetFinder()
  end,
  update = function()
    local cell = grid:getCell(graphicalGrid.world2grid(love.mouse.getPosition()))
    if cell then cell.obstacle = true end
  end
}
states.preparedToEraseObstacles = {
  mousepressed = function(x,y)
    setState('erasingObstacles')
  end
}
states.erasingObstacles = {
  mousereleased = function()
    setState('preparedToEraseObstacles')
    resetFinder()
  end,
  update = function()
    local cell = grid:getCell(graphicalGrid.world2grid(love.mouse.getPosition()))
    if cell then cell.obstacle = false end
  end
}

return game
