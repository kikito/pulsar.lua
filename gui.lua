local quickie = require 'lib.quickie'


local gui = {}
local buttons = {}
local sliderCallback = nil
local activeButton = nil
local sliderInfo = { min=0, max=100, step=5 }

function gui.addButton(label, callback)
  buttons[#buttons+1] = { label=label, callback=callback }
end

function gui.initializeSlider(initialValue, callback)
  sliderInfo.value = initialValue
  sliderCallback = callback
end


local left, top = 8,16
local width, height = 80, 32
local hsep = 8
local padding = 3

local function updateButtons()
  local button

  for i=1,#buttons do
    local button = buttons[i]
    local x = left + (hsep + width) * (i-1)
    if quickie.Button(button.label, x,top, width, height) then
      button.callback()
      activeButton = button
    end
    if activeButton == button then
      love.graphics.rectangle('line', x - padding, top - padding, width + 2*padding, height + 2*padding)
    end
  end
end

local function updateSlider()
  if quickie.Slider(sliderInfo, 430, top, 360, height) then
    sliderInfo.value = math.floor(sliderInfo.value)
    sliderCallback(sliderInfo.value)
  end
end

function gui.update()
  updateButtons()
  updateSlider()
end

function gui.draw()
  quickie.core.draw()
end

return gui
