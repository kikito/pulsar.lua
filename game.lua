local inspect = require 'lib.inspect'
local pulsar  = require 'lib.pulsar'
local cron    = require 'lib.cron'
local colors  = require 'colors'
local gui     = require 'gui'

local graphicalGrid = require 'graphical_grid'

local game = {}
local states = {}
local currentState = {}

local grid      = nil
local finder    = nil
local frequency = 1 -- steps per second
local cronId    = nil

local origin, destination, highlighted

local function setState(stateName)
  currentState = states[stateName]
end

local function step()
  if finder and not finder:done() then finder:step() end
end

function game.initialize(g)
  grid = pulsar.squareGrid.newGrid(32,49)

  cronId = cron.every(1/frequency, step)

  gui.addButton('Origin',      function() setState('settingOrigin') end)
  gui.addButton('Destination', function() setState('settingDestination') end)
  gui.addButton('Obstacle',    function() setState('preparedToSetObstacles') end)
  gui.addButton('Eraser',      function() setState('preparedToEraseObstacles') end)

  gui.initializeSlider(frequency, function(newFrequency)
    currentState = {} -- avoids resets if the currentState is erasing/blocking
    if frequency ~= newFrequency then
      frequency = newFrequency
      if cronId then cron.cancel(cronId) end
      cronId = frequency > 0 and cron.every(1/frequency, step)
    end
  end)
end

local function drawStatusLine()
  if highlighted then
    local x, y = graphicalGrid.grid2world(1, grid.rows + 1.5)
    local msg = { tostring(highlighted) }
    if finder and finder.nodes[highlighted] then
      msg = { tostring(finder.nodes[highlighted]) }
    end
    if highlighted == origin      then msg[#msg+1] = "origin" end
    if highlighted == destination then msg[#msg+1] = "destination" end
    if highlighted.obstacle       then msg[#msg+1] = "obstacle" end

    love.graphics.setColor(colors.white)
    love.graphics.print(table.concat(msg, ' '), x, y)
  end
end

function game.draw()
  gui.draw()
  graphicalGrid.drawGrid(grid, finder, origin, destination, highlighted)
  graphicalGrid.drawPath(finder, origin, destination, highlighted)
  drawStatusLine()
end

function game.update(dt)
  cron.update(dt)
  gui.update()

  highlighted = grid:getCell(graphicalGrid.world2grid(love.mouse.getPosition()))
  if currentState.update then currentState.update() end
end

function game.mousepressed(x,y)
  if currentState.mousepressed then currentState.mousepressed(x,y) end
end

function game.mousereleased(x,y)
  if currentState.mousereleased then currentState.mousereleased(x,y) end
end


local function resetFinder(newOrigin, newDestination, hardReset)
  local changedOrigin      = newOrigin      ~= origin
  local changedDestination = newDestination ~= destination
  local changed = newOrigin      and changedOrigin or
                  newDestination and changedDestination

  origin      = newOrigin      or origin
  destination = newDestination or destination

  if (changed or hardReset) and origin and destination then
    finder = pulsar.newFinder(
      origin,
      destination,
      pulsar.squareGrid.neighbors.fourDirections(grid),
      pulsar.squareGrid.costs.standard,
      pulsar.squareGrid.heuristics.manhattan
    )
  end
end

states.settingOrigin = {
  mousepressed = function(x,y)
    resetFinder(grid:getCell(graphicalGrid.world2grid(x,y)), destination)
  end
}
states.settingDestination = {
  mousepressed = function(x,y)
    resetFinder(origin, grid:getCell(graphicalGrid.world2grid(x,y)))
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
    resetFinder(origin, destination, true)
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
    resetFinder(origin, destination, true)
  end,
  update = function()
    local cell = grid:getCell(graphicalGrid.world2grid(love.mouse.getPosition()))
    if cell then cell.obstacle = false end
  end
}

return game
