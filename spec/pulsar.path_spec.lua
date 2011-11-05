
local pulsar = require 'pulsar'

describe('pulsar.path', function()
  describe('tostring', function()

    it("returns '{  }' for the empty path", function()
      assert_equal("{  }", tostring(pulsar.path:new()))
    end)

    it("returns '{ 1, 2, 3 }' for the built-in path", function()
      assert_equal( "{ 1, 2, 3 }", tostring(pulsar.path:new(1, 2, 3)) )
    end)

  end)

  describe('equality', function()

    it("returns true for the nil path", function()
      assert_equal(pulsar.path:new(), pulsar.path:new())
    end)

    it("returns true for equivalent paths", function()
      assert_equal(pulsar.path:new(1,2,3), pulsar.path:new(1,2,3))
    end)

    it("returns false for non-equivalent paths", function()
      assert_not_equal(pulsar.path:new(1,2), pulsar.path:new(1,2,3))
    end)


  end)

end)
