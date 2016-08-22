colours = {{61, 82, 213}, {39, 251, 107}} -- blue and green colours for now

local baseImage1 = love.graphics.newImage("art/base1.png")
local baseImage2 = love.graphics.newImage("art/base2.png")

function generateRandomBoard(startX, startY, width, height, squareSize)
  local board = {}
  local boardData = {startX = startX, startY = startY,
                     width = width, height = height, squareSize = squareSize}
  local level = {board = board, boardData = boardData}
  local x = startX
  for i = 1,width do
    local y = startY
    board[i] = {}
    for j = 1,height do
      local colourIndex = math.random(2)
      board[i][j] = {x = x, y = y, colourIndex = colourIndex, squareSize = squareSize, shrink = false, grow = false}
      y = y + squareSize
    end
    x = x + squareSize
  end

  moveBases(1, 1, width - 2, height - 2, level)

  return level
end

function moveBases(bx1, by1, bx2, by2, level)
  local boardData = level.boardData
  boardData.base1BX, boardData.base1BY = bx1, by1
  boardData.base2BX, boardData.base2BY = bx2, by2
  boardData.base1X, boardData.base1Y = getSquarePos(bx1, by1, level)
  boardData.base2X, boardData.base2Y = getSquarePos(bx2, by2, level)
  for i, row in pairs(level.board) do
    for j, square in pairs(row) do
      if i - bx1 >= 0 and i - bx1 <= 2 and j - by1 >= 0 and j - by1 <= 2 then
        square.teamBase = 1
      elseif i - bx2 >= 0 and i - bx2 <= 2 and j - by2 >= 0 and j - by2 <= 2 then
        square.teamBase = 2
      else
        square.teamBase = nil
      end
    end
  end
end

function drawBoard(level)
  local board, boardData = level.board, level.boardData
  for _,col in ipairs(board) do
    for _,square in ipairs(col) do
      drawSquare(square)
    end
  end
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(baseImage1, boardData.base1X, boardData.base1Y, 0, 3 * boardData.squareSize / baseImage1:getWidth(), 3 * boardData.squareSize / baseImage1:getHeight())
  love.graphics.draw(baseImage2, boardData.base2X, boardData.base2Y, 0, 3 * boardData.squareSize / baseImage2:getWidth(), 3 * boardData.squareSize / baseImage2:getHeight())
end

function drawSquare(square)
  love.graphics.setColor(colours[square.colourIndex])
  if square.shrink then
    love.graphics.rectangle("fill", square.x + valueTween(square.shrink), square.y, square.squareSize - (2 * valueTween(square.shrink)), square.squareSize)
  elseif square.grow then
    love.graphics.rectangle("fill", square.x + valueTween(square.grow), square.y, square.squareSize - (2 * valueTween(square.grow)), square.squareSize)
  else
    love.graphics.rectangle("fill", square.x, square.y, square.squareSize, square.squareSize)
  end
end

function updateBoard(dt, level)
  local board, boardData = level.board, level.boardData
  for x=1, boardData.width do
    for y=1, boardData.height do
      if board[x][y].shrink then
        updateTweens(board[x][y].shrink, dt)
        if isTweenFinished(board[x][y].shrink) then
          board[x][y].colourIndex = 3 - board[x][y].colourIndex
          board[x][y].grow = createTweens({{boardData.squareSize/2,0,0.1}})
          board[x][y].shrink = false
        end
      elseif board[x][y].grow then
        updateTweens(board[x][y].grow, dt)
        if isTweenFinished(board[x][y].grow) then board[x][y].grow = false end
      end
    end
  end
end

function flipBoard(mode, bx, by, level)
  local board, boardData = level.board, level.boardData
  if mode == "column" then
    for i = 1,boardData.height do
      if by ~= i then
        flipSquare(board[bx][i], level)
      end
    end
  elseif mode == "row" then
    for j = 1,boardData.width do
      if bx ~= j then
        flipSquare(board[j][by], level)
      end
    end
  elseif mode == "area" then
    for i = 1,boardData.width do
      for j = 1,boardData.height do
        distance = math.abs(i - bx) + math.abs(j - by)
        if distance ~= 0 and distance <= 2 then
          flipSquare(board[i][j], level)
        end
      end
    end
  end
end

function flipSquare(square, level)
  if square.shrink then
    square.colourIndex = 3 - square.colourIndex
  end
  square.shrink = createTweens({{0,level.boardData.squareSize/2,0.1}})
end

function getSquarePos(bx, by, level)
  local x = level.boardData.startX + level.boardData.squareSize * (bx - 1)
  local y = level.boardData.startY + level.boardData.squareSize * (by - 1)
  return x, y
end

function getBXAndBY(x, y, level)
  local boardData = level.boardData
  local bx = math.floor((x - boardData.startX) / boardData.squareSize) + 1
  local by = math.floor((y - boardData.startY) / boardData.squareSize) + 1
  return bx, by
end

function onBoard(x, y, otherx, othery, level)
  local boardData = level.boardData
  local onBoard = x >= boardData.startX
              and y >= boardData.startY
              and otherx < boardData.startX + boardData.width * boardData.squareSize
              and othery < boardData.startY + boardData.height * boardData.squareSize
  return onBoard
end
