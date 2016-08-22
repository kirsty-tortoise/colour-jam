levelCreator = {code = "level-creator"}

local boards = {}
local newBoard = {}
local mode = "flip"
local lastX, lastY = 0, 0
local mousedown


function levelCreator.setup()
  newBoard = generateRandomBoard(newBoard, boardData.startX, boardData.startY, boardData.width, boardData.height, boardData.squareSize)
  mousedown = false
  mode = "flip"
  lastX, lastY = 0, 0
  return levelCreator
end

function levelCreator.draw()
  drawBoard(newBoard)
  return levelCreator
end

function levelCreator.mousepressed(x, y, button, istouch)
  if button == 1 then
    mousedown = true
    if onBoard(boardData, x, y) then
      local bx, by = getBXAndBY(boardData, x, y)
      colourSquare(newBoard[bx][by], mode)
      lastX, lastY = bx, by
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

function levelCreator.mousemoved(x, y, dx, dy, istouch)
  if mousedown then
    if onBoard(boardData, x, y) then
      local bx, by = getBXAndBY(boardData, x, y)
      if not (lastX == bx and lastY == by) then
        colourSquare(newBoard[bx][by], mode)
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
