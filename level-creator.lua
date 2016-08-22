levelCreator = {code = "level-creator"}

local controls = {save = {x = 675, y = 515, width = 100, height = 70}}

local boards = {}
local newLevel
local mode = "flip"
local lastX, lastY = 0, 0
local mousedown
local defaults
local defaultShown

function levelCreator.setup()
  defaults = love.filesystem.load("default.lua")()
  newLevel = generateRandomBoard(0, 0, 16, 10, 50)
  mousedown = false
  mode = "flip"
  lastX, lastY = 0, 0
  defaultShown = 1
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
    if isOverButton(controls.save, x, y) then
      table.insert(defaults, newLevel)
      love.filesystem.write("default.lua", "return " .. tableToLua(defaults))
    end
  end
  return levelCreator
end

function levelCreator.mousereleased(x, y, button, istouch)
  if button == 1 then
    lastX, lastY = 0, 0
    mousedown = false
  end
  return levelCreator
end

function levelCreator.keypressed(key, scancode, isrepeat)
  if key == "left" then
    defaultShown = defaultShown - 1
    if defaultShown == 0 then defaultShown = #defaults end
  elseif key == "right" then
    defaultShown = defaultShown + 1
    if defaultShown > #defaults then defaultShown = 1 end
  end
  newLevel = defaults[defaultShown]
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
  love.graphics.rectangle("line", 15, 515, 200, 70)
  love.graphics.setFont(smallFont)
  love.graphics.printf("Change colour mode", 15, 525, 200, "center")
  love.graphics.rectangle("line", 675, 515, 100, 70)
  love.graphics.setFont(largeishFont)
  love.graphics.printf("SAVE", 675, 535, 100, "center")
end
