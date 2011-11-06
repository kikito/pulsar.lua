pulsar = require 'pulsar'
grid = require 'grid'


describe("pulsar", function()

  describe(":findPath", function()

    local map, origin, cost, heuristic
    before(function()
      map = grid.Map:new(10,10)
      origin = map:getCell(1,1)
      cost = function() return 1 end
      heuristic = grid.Cell.getManhattanDistance
    end)

    it("finds the nil path", function()
      local path = pulsar:findPath(map, origin, origin, cost, heuristic)
      assert_equal(path, pulsar.Path:new())
    end)

    describe("without obstacles", function()

      it("finds the path to a neighbor", function()
        local destination = map:getCell(2,1)
        local path = pulsar:findPath(map, origin, destination, cost, heuristic)
        assert_equal(path, pulsar.Path:new(destination) )
      end)

      describe("when destination is not a neighbor", function()
        it("moves to the right", function()
          local destination = map:getCell(3,1)
          local path = pulsar:findPath(map, origin, destination, cost, heuristic)
          assert_equal(path, pulsar.Path:new( map:getCell(2,1), destination ))
        end)
        it("moves diagonally", function()
          local destination = map:getCell(2,3)
          local path = pulsar:findPath(map, origin, destination, cost, heuristic)
          assert_equal(path, pulsar.Path:new( map:getCell(2,1), map:getCell(2,2), destination ))
        end)
      end)
    end)
  end)

end)

describe("pulsar.Finder", function()

  local map, origin, destination, heuristic, cost
  before(function()
    map = grid.Map:new(10,10)
    origin = map:getCell(1,1)
    destination = map:getCell(5,5)
    heuristic = grid.Cell.getManhattanDistance
    cost = function() end
  end)

  describe(":new", function()

    it("throws an error if map, origin, destination, cost or heuristic are nils", function()
      assert_error(function() pulsar.Finder:new(nil, origin, destination, cost, heuristic) end)
      assert_error(function() pulsar.Finder:new(map,    nil, destination, cost, heuristic) end)
      assert_error(function() pulsar.Finder:new(map, origin,         nil, cost, heuristic) end)
      assert_error(function() pulsar.Finder:new(map, origin, destination,  nil, heuristic) end)
      assert_error(function() pulsar.Finder:new(map, origin, destination, cost,       nil) end)
    end)

    describe("when given nice params", function()
      local finder
      before(function()
        finder = pulsar.Finder:new(map, origin, destination, cost, heuristic)
      end)
      it("sets the right attributes on the finder", function()
        assert_equal(finder.map, map)
        assert_equal(finder.origin, origin)
        assert_equal(finder.destination, destination)
        assert_equal(finder.cost, cost)
        assert_equal(finder.heuristic, heuristic)
      end)
      it("sets initializes the best candidate to origin", function()
        assert_equal(finder.best, origin)
      end)
    end)
  end)

  describe(":findNext", function()
    local finder
    before(function()
      finder = pulsar.Finder:new(map, origin, destination, cost, heuristic)
    end)
    it("returns sets best to the next best child, according to its heuristic", function()
      finder:findNext()
      assert_equal(finder.best, map:getCell(2,1))
      finder:findNext()
      assert_equal(finder.best, map:getCell(3,1))
    end)
  end)

end)



describe('pulsar.Path', function()
  describe('tostring', function()

    it("returns '{  }' for the empty path", function()
      assert_equal("{  }", tostring(pulsar.Path:new()))
    end)

    it("returns '{ 1, 2, 3 }' for the built-in path", function()
      assert_equal( "{ 1, 2, 3 }", tostring(pulsar.Path:new(1, 2, 3)) )
    end)

  end)

  describe('equality', function()

    it("returns true for the nil path", function()
      assert_equal(pulsar.Path:new(), pulsar.Path:new())
    end)

    it("returns true for equivalent paths", function()
      assert_equal(pulsar.Path:new(1,2,3), pulsar.Path:new(1,2,3))
    end)

    it("returns false for non-equivalent paths", function()
      assert_not_equal(pulsar.Path:new(1,2), pulsar.Path:new(1,2,3))
    end)

  end)

end)

