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

describe("pulsar.Node", function()

  describe(":new", function()

    it("initializes a node with all its parameters", function()
      local parent, location, g, h = {},{},1,2
      local node = pulsar.Node:new(location, parent, g, h)
      assert_equal(parent, node.parent)
      assert_equal(location, node.location)
      assert_equal(g, node.g)
      assert_equal(h, node.h)
      assert_equal(3, node.f)
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
    cost = function() return 1 end
  end)

  describe(":new", function()

    it("throws an error if map, origin, destination, cost or heuristic are nils", function()
      assert_error(function() pulsar.Finder:new(nil, origin, destination, cost, heuristic) end)
      assert_error(function() pulsar.Finder:new(map,    nil, destination, cost, heuristic) end)
      assert_error(function() pulsar.Finder:new(map, origin,         nil, cost, heuristic) end)
      assert_error(function() pulsar.Finder:new(map, origin, destination,  nil, heuristic) end)
      assert_error(function() pulsar.Finder:new(map, origin, destination, cost,       nil) end)
    end)

    describe("initial node", function()

      local finder, originNode
      before(function()
        finder = pulsar.Finder:new(map, origin, destination, cost, heuristic)
        initialNode = finder:getOrCreateNode(origin)
      end)


      it("starts creating a node for the origin", function()
        assert_equal(initialNode, finder.nodes[origin])
        assert_equal(1, #finder.open)
        assert_true(initialNode.open)
        assert_equal(initialNode, finder.open[1])
      end)

      it("has g=0, heuristic=origin, destination", function()
        assert_equal(0, initialNode.g)
        assert_equal(8, initialNode.h)
      end)
    
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

  describe(":getOrCreateNode", function()
    local finder, cell, originNode
    before(function()
      finder = pulsar.Finder:new(map, origin, destination, cost, heuristic)
      cell = map:getCell(5,5)
      originNode = finder:getOrCreateNode(origin)
    end)

    it("initializes a node with the correct attributes", function()
      local node = finder:getOrCreateNode(cell)
      assert_equal(originNode, node.parent)
      assert_equal(cell, node.location)
      assert_equal(1, node.g)
      assert_equal(8, node.h)
      assert_equal(9, node.f)
    end)
    it("gets the same node it inserts", function()
      local node = finder:getOrCreateNode(cell)
      assert_equal(node, finder:getOrCreateNode(cell))
    end)

    it("addepts default values for a new node", function()
      local falseParent = {}
      local node = finder:getOrCreateNode(cell, falseParent, 0, 10)
      assert_equal(cell, node.location)
      assert_equal(falseParent, node.parent)
      assert_equal(0, node.g)
      assert_equal(10, node.h)
      assert_equal(10, node.f)
    end)
  end)

  describe("opening and closing nodes", function()
    local finder, node, cell
    before(function()
      finder = pulsar.Finder:new(map, origin, destination, cost, heuristic)
      cell = map:getCell(1,2)
      node = finder:getOrCreateNode(map:getCell(1,1))
    end)
    it("marks open nodes as open", function()
      finder:openNode(node)
      assert_true(node.open)
    end)
    it("marks closed nodes as closed", function()
      finder:openNode(node)
      finder:closeNode(node)
      assert_false(node.open)
    end)
  end)

  describe(":getNextNode", function()
    local finder, node, cell, originNode
    before(function()
      finder = pulsar.Finder:new(map, origin, destination, cost, heuristic)
      cell = map:getCell(2,2)
      originNode = finder:getOrCreateNode(origin)
      node = finder:getOrCreateNode(cell)
    end)
    it("returns the origin node at the start", function()
      assert_equal(originNode, finder:getNextNode())
    end)
    it("returns nil after returning all elements", function()
      finder:openNode(node)
      finder:getNextNode()
      finder:getNextNode()
      assert_nil(finder:getNextNode())
    end)
    it("returns the elements in order", function()
      node.f = -1
      finder:openNode(node)
      assert_equal(node, finder:getNextNode())
      assert_equal(originNode, finder:getNextNode())
      assert_nil(finder:getNextNode())
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

