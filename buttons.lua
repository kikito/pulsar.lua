
local Button   = require 'lib.button'

local buttons = {}
local methods = {}


local hsep = 8
local vsep = 8
local buttonWidth = 90
local buttonHeight = 50

local function allButtons(methodName, ...)
  local button
  for i=1,#buttons do
    button = buttons[i]
    button[methodName](button, ...)
  end
end

local function highLightButton(index)
  allButtons('setHighlight', false)
  buttons[index]:setHighlight(true)
end

function methods.draw()
  allButtons('draw')
end

function methods.mousepressed(x,y)
  allButtons('mousepressed', x, y)
end

function methods.add(name, color, callback)
  local n = #buttons
  buttons[n + 1] = Button.new(
    name,
    color,
    hsep * (n + 1) + buttonWidth * n, -- x
    vsep,                             -- y
    buttonWidth,
    buttonHeight,
    function()
      highLightButton(n + 1)
      callback()
    end
  )
end

return setmetatable(buttons, {__index = methods})
