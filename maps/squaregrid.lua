local Cell = {}

local cellmt = {
  __index = Cell,
  __tostring = function(self)
    return ("{%d,%d}"):format(self.x, self.y)
  end
}

function Cell:new(x,y)
  return setmetatable({x = x, y = y}, cellmt)
end

--------------------------------------------------------------------

local distance = {}

local abs = function(x) return x < 0 and -x or x end
function distance.manhattan(cell1, cell2)
  return abs(cell2.x - cell1.x) + abs(cell2.y - cell1.y)
end

--------------------------------------------------------------------

local neighbors = {}

-- up, right, down, left; like in CSS
local axisDeltas = { {0,-1}, {1, 0}, {0, 1}, {-1, 0} }

function neighbors.axis(map)
  return function(cell)

    local result, count, x, y = {}, 0, cell.x, cell.y
    local neighbor, delta

    for i=1, #axisDeltas do
      delta = axisDeltas[i]
      neighbor = map(x + delta[1], y + delta[2])
      if neighbor and not neighbor.obstacle then
        count = count + 1
        result[count] = neighbor
      end
    end

    return result
  end
end

--------------------------------------------------------------------

local Map = {}


function Map:getNeighbors(cell)
end

local function isInsideMap(map, x, y)
  return x > 0 and y > 0 and x <= map.width and y <= map.height
end

local mapmt = {
  __index = Map,
  __call = function(self, x, y)
    if isInsideMap(self, x, y) then return self.cells[y][x] end
  end,
  __tostring = function(self)
    local buffer = {}
    for y = 1, self.height do
      for x = 1, self.width do
        table.insert(buffer, self(x,y).obstacle and "#" or " ")
      end
      table.insert(buffer, "\n")
    end
    return table.concat(buffer, "")
  end

}

local function parseObstacles(map, str)
  local x,y = 1,1
  for row in str:gmatch("[^\n]+") do
    x = 1
    for character in row:gmatch(".") do
      if character ~= " " then map(x,y).obstacle = true end
      x = x + 1
    end
    y = y + 1
  end
  return map
end

local function getDimensions(str)
  local width, height = 0, 0
  for row in str:gmatch("[^\n]+") do
    height = height + 1
    width = math.max(width, #row)
  end
  return width, height
end

local function createCells(map)
  for y=1, map.height do
    map.cells[y] = {}
    for x=1, map.width do
      map.cells[y][x] = Cell:new(x,y)
    end
  end
  return map
end

local function newMapFromString(str)
  str = str:match("^[\n]?(.-)[\n]?$")
  return parseObstacles(Map:new(getDimensions(str)), str)
end

function Map:new(w, h)
  if type(w) == 'string' then return newMapFromString(w) end
  return createCells(setmetatable({width=w, height=h, cells={}}, mapmt))
end

local squaregrid = {}

squaregrid.Cell = Cell
squaregrid.distance = distance
squaregrid.neighbors = neighbors
squaregrid.Map = Map

return squaregrid
