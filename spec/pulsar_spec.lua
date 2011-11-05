pulsar = require 'pulsar'
grid = require 'grid'
path = require 'path'


describe("pulsar", function()

  describe(":findPath", function()

    local map, origin
    before(function()
      map = grid:new(10,10)
      origin = map:getCell(1,1)
    end)

    it("finds the nil path", function()
      local mypath = pulsar:findPath(map, origin, origin)
      assert_equal(mypath, path:new())
    end)

    it("finds the path of length 1", function()
      local destination = map:getCell(2,1)
      local mypath = pulsar:findPath(map, origin, destination)
      assert_equal(mypath, path:new(destination) )
    end)

    describe("when finding a path of length 2", function()
      it("finds the straight line path", function()
        local destination = map:getCell(3,1)
        local mypath = pulsar:findPath(map, origin, destination)
        assert_equal(mypath, path:new( map:getCell(2,1), destination ))
      end)
    end)

  end)

end)
