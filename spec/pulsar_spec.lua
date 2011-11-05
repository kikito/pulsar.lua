pulsar = require 'pulsar'
grid = require 'grid'


describe("pulsar", function()

  describe(":findPath", function()

    local map, origin
    before(function()
      map = grid:new(10,10)
      origin = map:getCell(1,1)
    end)

    it("finds the nil path", function()
      local path = pulsar:findPath(map, origin, origin)
      assert_equal(path, pulsar.path:new())
    end)

    describe("without obstacles", function()

      it("finds the path to a neighbor", function()
        local destination = map:getCell(2,1)
        local path = pulsar:findPath(map, origin, destination)
        assert_equal(path, pulsar.path:new(destination) )
      end)

      describe("when destination is not a neighbor", function()
        it("moves to the right", function()
          local destination = map:getCell(3,1)
          local path = pulsar:findPath(map, origin, destination)
          assert_equal(path, pulsar.path:new( map:getCell(2,1), destination ))
        end)
        it("moves diagonally", function()
          local destination = map:getCell(2,3)
          local path = pulsar:findPath(map, origin, destination)
          assert_equal(path, pulsar.path:new( map:getCell(2,1), map:getCell(2,2), destination ))
        end)
      end)
    end)

  end)

end)
