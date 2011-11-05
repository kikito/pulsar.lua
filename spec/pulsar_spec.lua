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
      assert_equal(path, pulsar.Path:new())
    end)

    describe("without obstacles", function()

      it("finds the path to a neighbor", function()
        local destination = map:getCell(2,1)
        local path = pulsar:findPath(map, origin, destination)
        assert_equal(path, pulsar.Path:new(destination) )
      end)

      describe("when destination is not a neighbor", function()
        it("moves to the right", function()
          local destination = map:getCell(3,1)
          local path = pulsar:findPath(map, origin, destination)
          assert_equal(path, pulsar.Path:new( map:getCell(2,1), destination ))
        end)
        it("moves diagonally", function()
          local destination = map:getCell(2,3)
          local path = pulsar:findPath(map, origin, destination)
          assert_equal(path, pulsar.Path:new( map:getCell(2,1), map:getCell(2,2), destination ))
        end)
      end)
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

