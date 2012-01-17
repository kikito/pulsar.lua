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

    test(":manhattanDistance", function()
      local cell1 = Cell:new(1,1)
      local cell2 = Cell:new(5,4)

      assert_equal(7, cell1:getManhattanDistance(cell2) )
    end)

  end)

  describe("Map", function()

    local map

    describe("__call", function()
      before(function()
        map = Map:new(10,10)
      end)

      it("returns the cell if inside map", function()
        assert_not_nil( map(1,1) )
      end)

      it("returns nil if cell is not inside map", function()
        assert_nil( map(0,0) )
      end)
    end)

    describe(":parse", function()
      it("throws an error if the parameter is not a string", function()
        assert_error(function() Map:parse(2) end)
      end)

      it("calculates the width correctly", function()
        assert_equal(5, Map:parse("\n     \n").width)
      end)

      it("calculates the height correctly", function()
        assert_equal(2, Map:parse("\n  \n  \n").height)
      end)

      it("creates obstacles correctly", function()
        local map = Map:parse([[
     
 *
  *
]])
       assert_nil ( map(1,1).obstacle)
       assert_true( map(2,2).obstacle)
       assert_true( map(3,3).obstacle)

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
        assert_equal(str, tostring(Map:parse(str)))
      end)
    end)

    describe(":getNeighbors", function()

      before(function()
        map = Map:new(10,10)
      end)

      it("returns all neighbors when the cell is not in a border", function()
        local cell = map(5,5)
        local n = map:getNeighbors(cell)

        assert_equal(n[1], map(5,4))
        assert_equal(n[2], map(6,5))
        assert_equal(n[3], map(5,6))
        assert_equal(n[4], map(4,5))
      end)

      it("returns all neighbors when the cell is a corner", function()
        local cell = map(1,1)
        local n = map:getNeighbors(cell)

        assert_equal(n[1], map(2,1))
        assert_equal(n[2], map(1,2))
      end)

      it("returns all neighbors when the cell is a corner", function()
        local cell = map(10,10)
        local n = map:getNeighbors(cell)

        assert_equal(n[1], map(10,9))
        assert_equal(n[2], map(9,10))
      end)

      it("only returns non-obstacle neighbors", function()
        local cell = map(10,10)
        local obstacle = map(10,9)
        obstacle.obstacle = true
        local n = map:getNeighbors(cell)

        assert_equal(n[1], map(9,10))
      end)

    end)

    describe("equality", function()

      test("1,1 is equal to itself", function()
        local cell1, cell2 = map(1,1), map(1,1)
        assert_equal(cell1, cell2)
      end)

      test("1,1 is not equal to 1,2", function()
        local cell1, cell2 = map(1,1), map(1,2)
        assert_not_equal(cell1, cell2)
      end)

    end)
  end)
end)


