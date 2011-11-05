local grid = require 'grid'

describe("grid", function()



  describe(":getCell", function()
    local map
    before(function()
      map = grid:new(10,10)
    end)

    it("returns the cell if inside map", function()
      assert_not_nil( map:getCell(1,1) )
    end)

    it("returns nil if cell is not inside map", function()
      assert_nil( map:getCell(0,0) )
    end)

  end)

  describe("grid.cell", function()
  
    describe(":new", function()
      it("sets the x,y parameters", function()
        local cell = grid.cell:new(1,2)
        assert_equal(cell.x, 1)
        assert_equal(cell.y, 2)
      end)
    end)
    
    describe("equality", function()

      test("0,0 is equal to itself", function()
        local cell1 = grid.cell:new(0,0)
        local cell2 = grid.cell:new(0,0)

        assert_equal(cell1, cell2)
      end)

      test("0,0 is not equal to 0,1", function()
        local cell1, cell2 = grid.cell:new(0,0), grid.cell:new(0,1)
        assert_not_equal(cell1, cell2)
      end)

    end)

    test("tostring", function()
      assert_equal("{1,1}", tostring(grid.cell:new(1,1)))
    end)
  end)


end)

