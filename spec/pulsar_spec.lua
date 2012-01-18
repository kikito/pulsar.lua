pulsar = require 'pulsar'
squaregrid = require 'maps.squaregrid'

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

  local map, neighbors, origin, destination, heuristic, cost, finder
  before(function()
    map = squaregrid.Map:new(10,10)
    origin = map(1,1)
    destination = map(5,5)
    neighbors = squaregrid.neighbors.axis(map)
    heuristic = squaregrid.distance.manhattan
    cost = function() return 1 end
    finder = pulsar.Finder:new(origin, destination, neighbors, cost, heuristic)
  end)

  describe(":new", function()

    it("throws an error if origin, destination,neighbors, cost or heuristic are nils", function()
      assert_error(function() pulsar.Finder:new(   nil, destination, neighbors, cost, heuristic) end)
      assert_error(function() pulsar.Finder:new(origin,         nil, neighbors, cost, heuristic) end)
      assert_error(function() pulsar.Finder:new(origin, destination,       nil, cost, heuristic) end)
      assert_error(function() pulsar.Finder:new(origin, destination, neighbors,  nil, heuristic) end)
      assert_error(function() pulsar.Finder:new(origin, destination, neighbors, cost,       nil) end)
    end)

    describe("initial node", function()

      local initialNode
      before(function()
        initialNode = finder:getOrCreateNode(origin)
      end)

      it("starts creating a node for the origin", function()
        assert_equal(initialNode, finder.nodes[origin])
        assert_equal(1, #finder.open)
        assert_true(initialNode.open)
        assert_equal(initialNode, finder.open[1])
      end)

      it("has g=0, h = heuristic(origin, destination)", function()
        assert_equal(0, initialNode.g)
        assert_equal(8, initialNode.h)
      end)

    end)

    describe("when given nice params", function()
      it("sets the right attributes on the finder", function()
        assert_equal(finder.origin, origin)
        assert_equal(finder.destination, destination)
        assert_equal(finder.neighbors, neighbors)
        assert_equal(finder.cost, cost)
        assert_equal(finder.heuristic, heuristic)
      end)
      it("sets initializes the best candidate to origin", function()
        assert_equal(finder.bestLocation, origin)
      end)
    end)
  end)

  describe(":pickNextBestNode", function()
    it("returns sets best to the next best child, according to its heuristic", function()
      finder:findNext()
      assert_equal(finder.bestLocation, map(2,1))
      finder:findNext()
      assert_equal(finder.bestLocation, map(3,1))
    end)
  end)

  describe(":getOrCreateNode", function()
    local cell, originNode
    before(function()
      cell = map(5,5)
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
      finder = pulsar.Finder:new(origin, destination, neighbors, cost, heuristic)
      cell = map(1,2)
      node = finder:getOrCreateNode(map(1,1))
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

  describe(":pickNextBestNode", function()
    local node, cell, originNode
    before(function()
      cell = map(2,2)
      originNode = finder:getOrCreateNode(origin)
      node = finder:getOrCreateNode(cell)
    end)
    it("returns the origin node at the start", function()
      assert_equal(originNode, finder:pickNextBestNode())
    end)
    it("returns nil after returning all elements", function()
      finder:openNode(node)
      finder:pickNextBestNode()
      finder:pickNextBestNode()
      assert_nil(finder:pickNextBestNode())
    end)
    it("returns the elements in order", function()
      node.f = -1
      finder:openNode(node)
      assert_equal(node, finder:pickNextBestNode())
      assert_equal(originNode, finder:pickNextBestNode())
      assert_nil(finder:pickNextBestNode())
    end)
  end)

  describe(":openNeighbors", function()
    local cell
    before(function()
      cell = map(1,10)
      finder.bestLocation = cell
    end)

    describe("when the best node doesn't have any neighbors", function()
      it("does not increase the size of the open set", function()
        map(1,9).obstacle = true
        map(2,10).obstacle = true
        local prevOpenSize = #finder.open
        finder:openNeighbors()
        assert_equal(prevOpenSize, #finder.open)
      end)
    end)

    describe("when the neigbors are not on the open set", function()
      it("adds the neighbors to the open set", function()
        map(1,9).obstacle = true
        local prevOpenSize = #finder.open
        finder:openNeighbors()
        assert_equal(prevOpenSize + 1, #finder.open)
      end)
    end)
  end)
end)




