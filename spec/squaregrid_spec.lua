local squaregrid = require 'maps.squaregrid'

local Map, Cell = squaregrid.Map, squaregrid.Cell

describe("maps.squaregrid", function()

  describe("Cell", function()

    test(":new sets the x,y parameters", function()
      local cell = Cell:new(1,2)
      assert_equal(cell.x, 1)
      assert_equal(cell.y, 2)
    end)

    test("tostring", function()
      assert_equal("{1,1}", tostring(Cell:new(1,1)))
    end)
  end)

  describe("distance", function()
    describe("manhattan", function()
      local manhattan = squaregrid.distance.manhattan
      it("returns 0 on the same cell", function()
        assert_equal(0, manhattan(Cell:new(1,1), Cell:new(1,1)))
      end)

      it("calculates the distance between two distant cells correctly", function()
        assert_equal(7, manhattan(Cell:new(1,1), Cell:new(5,4)))
      end)
    end)
  end)

  describe("neighbors", function()
    describe("axis", function()
      local map, neighbors

      before(function()
        map = Map:new(10,10)
        neighbors = squaregrid.neighbors.axis(map)
      end)

      local function checkNeighbors(n, ...)
        local args = {...}
        assert_equal(#n, #args)
        for i=1,#n do
          assert_equal(n[i], args[i])
        end
      end

      it("returns all neighbors when the cell is not in a border", function()
        local cell = map(5,5)
        checkNeighbors(neighbors(cell), map(5,4), map(6,5), map(5,6), map(4,5))
      end)

      it("returns all neighbors when the cell is a corner", function()
        local cell = map(1,1)
        checkNeighbors(neighbors(cell), map(2,1), map(1,2))
      end)

      it("returns all neighbors when the cell is a corner", function()
        local cell = map(10,10)
        checkNeighbors(neighbors(cell), map(10,9), map(9,10))
      end)

      it("only returns non-obstacle neighbors", function()
        local cell = map(10,10)
        map(10,9).obstacle = true
        checkNeighbors(neighbors(cell), map(9,10))
      end)
    end)
  end)

  describe("Map", function()

    describe("__call", function()
      it("returns the cell if inside map", function()
        local map = Map:new(10,10)
        assert_not_nil( map(1,1) )
      end)

      it("returns nil if cell is not inside map", function()
        local map = Map:new(10,10)
        assert_nil( map(0,0) )
      end)
    end)

    describe(":new", function()
      it("sets width & height", function()
        local map = Map:new(10,20)
        assert_equal(10, map.width)
        assert_equal(20, map.height)
      end)

      describe("when given a string", function()

        it("calculates the width correctly", function()
          assert_equal(5, Map:new("\n     \n").width)
        end)

        it("calculates the height correctly", function()
          assert_equal(2, Map:new("\n  \n  \n").height)
        end)

        it("creates obstacles correctly", function()
          local map = Map:new([[
     
 *
  *
]])
         assert_nil ( map(1,1).obstacle)
         assert_true( map(2,2).obstacle)
         assert_true( map(3,3).obstacle)

        end)
      end)
    end)

    describe("__tostring", function()
      it("returns a map representation similar to the parsed string", function()
        local str = [[
    #  
   # # 
  #   #
   # # 
    #  
]]
        assert_equal(str, tostring(Map:new(str)))
      end)
    end)
  end)
end)


