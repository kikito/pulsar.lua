local grid = require 'grid'

describe("grid.Map", function()

  local map
  before(function()
    map = grid.Map:new(10,10)
  end)

  describe(":getCell", function()
    it("returns the cell if inside map", function()
      assert_not_nil( map:getCell(1,1) )
    end)

    it("returns nil if cell is not inside map", function()
      assert_nil( map:getCell(0,0) )
    end)
  end)

  describe(":getNeighbors", function()
    it("returns all neighbors when the cell is not in a border", function()
      local cell = map:getCell(5,5)
      local n = map:getNeighbors(cell)

      assert_equal(n[1], map:getCell(5,4))
      assert_equal(n[2], map:getCell(6,5))
      assert_equal(n[3], map:getCell(5,6))
      assert_equal(n[4], map:getCell(4,5))
    end)

    it("returns all neighbors when the cell is a corner", function()
      local cell = map:getCell(1,1)
      local n = map:getNeighbors(cell)

      assert_equal(n[1], map:getCell(2,1))
      assert_equal(n[2], map:getCell(1,2))
    end)

    it("returns all neighbors when the cell is a corner", function()
      local cell = map:getCell(10,10)
      local n = map:getNeighbors(cell)

      assert_equal(n[1], map:getCell(10,9))
      assert_equal(n[2], map:getCell(9,10))
    end)
    describe("equality", function()

      test("1,1 is equal to itself", function()
        local cell1, cell2 = map:getCell(1,1), map:getCell(1,1)
        assert_equal(cell1, cell2)
      end)

      test("1,1 is not equal to 1,2", function()
        local cell1, cell2 = map:getCell(1,1), map:getCell(1,2)
        assert_not_equal(cell1, cell2)
      end)

    end)
  end)

end)


describe("grid.Cell", function()

  describe(":new", function()
    it("sets the x,y parameters", function()
      local cell = grid.Cell:new(1,2)
      assert_equal(cell.x, 1)
      assert_equal(cell.y, 2)
    end)
  end)



  test("tostring", function()
    assert_equal("{1,1}", tostring(grid.Cell:new(1,1)))
  end)

  test(":manhattanDistance", function()
    local cell1 = grid.Cell:new(1,1)
    local cell2 = grid.Cell:new(5,4)

    assert_equal(7, cell1:getManhattanDistance(cell2) )
  end)

end)
