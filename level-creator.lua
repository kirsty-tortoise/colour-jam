levelCreator = {code = "level-creator"}

local controls = {save = {x = 675, y = 515, width = 100, height = 70, text = "SAVE", colour = {255, 255, 255}},
                  colourMode = {x = 15, y = 515, width = 200, height = 70},
                  blueMode = {x = 38.75, y = 540, width = 35, height = 35},
                  greenMode = {x = 97.5, y = 540, width = 35, height = 35},
                  flipMode = {x = 156.25, y = 540, width = 35, height = 35},
                  resetLevel = {x = 230, y = 540, width = 200, height = 70},
                  greenReset = {},
                  blueReset = {},
                  randomReset = {}}

local newLevel
local mode = "flip"
local lastX, lastY = 0, 0
local mousedown
local defaultShown
local selectedModeButton

local creatingDefaults = true -- Set this to true if you are messing with default levels

function levelCreator.setup()
  if creatingDefaults then
    defaultShown = 1
  end
  newLevel = generateRandomBoard(0, 0, 16, 10, 50)
  if creatingDefaults then
    table.insert(defaultLevels, newLevel)
  else
    table.insert(yourLevels, newLevel)
  end

  mousedown = false
  mode = "flip"
  selectedModeButton = controls.flipMode
  lastX, lastY = 0, 0
  return levelCreator
end

function levelCreator.draw()
  drawBoard(newLevel)
  drawControls()
  return levelCreator
end

function levelCreator.mousepressed(x, y, button, istouch)
  if button == 1 then
    mousedown = true
    if onBoard(x, y, x, y, newLevel) then
      local bx, by = getBXAndBY(x, y, newLevel)
      colourSquare(newLevel.board[bx][by], mode)
      lastX, lastY = bx, by
    end
  end
  return checkControlsMousepress(x, y)
end

function levelCreator.mousereleased(x, y, button, istouch)
  if button == 1 then
    lastX, lastY = 0, 0
    mousedown = false
  end
  return levelCreator
end

function levelCreator.keypressed(key, scancode, isrepeat)
  if creatingDefaults then
    -- when creating levels, you can flick through them to check all have loaded
    if key == "left" then
      defaultShown = defaultShown - 1
      if defaultShown == 0 then defaultShown = #defaultLevels end
    elseif key == "right" then
      defaultShown = defaultShown + 1
      if defaultShown > #defaultLevels then defaultShown = 1 end
    end
    newLevel = defaultLevels[defaultShown]
  end
  return levelCreator
end

function levelCreator.mousemoved(x, y, dx, dy, istouch)
  if mousedown then
    if onBoard(x, y, x, y, newLevel) then
      local bx, by = getBXAndBY(x, y, newLevel)
      if not (lastX == bx and lastY == by) then
        colourSquare(newLevel.board[bx][by], mode)
        lastX, lastY = bx, by
      end
    end
  end
  checkControlsMousemoved(x, y)
  return levelCreator
end

function colourSquare(square, mode)
  if mode == "flip" then
    square.colourIndex = 3 - square.colourIndex
  elseif mode == "blue" then
    square.colourIndex = 1
  elseif mode == "green" then
    square.colourIndex = 2
  end
end

function isOverSquare(square, x, y)
  return x > square.x
     and y > square.y
     and x < square.x + square.squareSize
     and y < square.y + square.squareSize
end

function drawControls()
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", controls.colourMode.x, controls.colourMode.y,
                          controls.colourMode.width, controls.colourMode.height)
  love.graphics.setFont(smallFont)
  love.graphics.printf("Change colour mode", 15, 520, 200, "center")

  love.graphics.setColor(colours[1])
  love.graphics.rectangle("fill", controls.blueMode.x, controls.blueMode.y,
                                  controls.blueMode.width, controls.blueMode.height)
  love.graphics.setColor(colours[2])
  love.graphics.rectangle("fill", controls.greenMode.x, controls.greenMode.y,
                                  controls.greenMode.width, controls.greenMode.height)

  -- draw flipmode half blue half green
  love.graphics.setColor(colours[1])
  love.graphics.polygon('fill', controls.flipMode.x, controls.flipMode.y,
                                controls.flipMode.x, controls.flipMode.y + controls.flipMode.height,
                                controls.flipMode.x + controls.flipMode.width, controls.flipMode.y)
  love.graphics.setColor(colours[2])
  love.graphics.polygon('fill', controls.flipMode.x + controls.flipMode.width, controls.flipMode.y + controls.flipMode.height,
                                controls.flipMode.x, controls.flipMode.y + controls.flipMode.height,
                                controls.flipMode.x + controls.flipMode.width, controls.flipMode.y)

  -- draw white square around chosen mode
  love.graphics.setColor(255, 255, 255)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line", selectedModeButton.x, selectedModeButton.y,
                                  selectedModeButton.width, selectedModeButton.height)

  love.graphics.setLineWidth(1)

  drawButton(controls.save)
end

function checkControlsMousepress(x, y)
  if isOverButton(controls.save, x, y) then
    if creatingDefaults then
      love.filesystem.write("defaultLevels.lua", "return " .. tableToLua(defaultLevels))
    else
      love.filesystem.write("yourLevels.lua", "return " .. tableToLua(yourLevels))
    end
  elseif isOverButton(controls.blueMode, x, y) then
    mode = "blue"
    selectedModeButton = controls.blueMode
  elseif isOverButton(controls.greenMode, x, y) then
    mode = "green"
    selectedModeButton = controls.greenMode
  elseif isOverButton(controls.flipMode, x, y) then
    mode = "flip"
    selectedModeButton = controls.flipMode
  end
  return levelCreator
end

function checkControlsMousemoved(x, y)
  for _,j in pairs(controls) do
    if j.colour then
      if isOverButton(j, x, y) then
        j.colour = {255, 0, 0}
      else
        j.colour = {255, 255, 255}
      end
    end
  end
end
