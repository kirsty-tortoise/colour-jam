colours = {{61, 82, 213}, {39, 251, 107}} -- blue and green colours for now

local baseImage1 = love.graphics.newImage("art/base1.png")
local baseImage2 = love.graphics.newImage("art/base2.png")

function generateRandomBoard(board, startX, startY, width, height, squareSize)
  local x = startX
  for i = 1,width do
    local y = startY
    board[i] = {}
    for j = 1,height do
      local colourIndex = math.random(2)
      board[i][j] = {x = x, y = y, colourIndex = colourIndex, squareSize = squareSize, shrink = false, grow = false}
      y = y + squareSize
      if i <= 3 and j <= 3 then
        board[i][j].teamBase = 1
      elseif i > width - 3 and j > height - 3 then
        board[i][j].teamBase = 2
      end
    end
    x = x + squareSize
  end

  board.base1X, board.base1Y = startX, startY
  board.base2X, board.base2Y = startX + (width - 3) * squareSize, startY + (height - 3) * squareSize

  return board

end

function drawBoard(board)
  for _,col in ipairs(board) do
    for _,square in ipairs(col) do
      drawSquare(square)
    end
  end
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(baseImage1, board.base1X, board.base1Y, 0, 3 * boardData.squareSize / baseImage1:getWidth(), 3 * boardData.squareSize / baseImage1:getHeight())
  love.graphics.draw(baseImage2, board.base2X, board.base2Y, 0, 3 * boardData.squareSize / baseImage2:getWidth(), 3 * boardData.squareSize / baseImage2:getHeight())
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

function updateBoard(dt)
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

function flipBoard(mode, board, bx, by)
  if mode == "column" then
    for i = 1,boardData.height do
      if by ~= i then
        flipSquare(board[bx][i], boardData)
      end
    end
  elseif mode == "row" then
    for j = 1,boardData.width do
      if bx ~= j then
        flipSquare(board[j][by], boardData)
      end
    end
  elseif mode == "area" then
    for i = 1,boardData.width do
      for j = 1,boardData.height do
        distance = math.abs(i - bx) + math.abs(j - by)
        if distance ~= 0 and distance <= 2 then
          flipSquare(board[i][j], boardData)
        end
      end
    end
  end
end

function flipSquare(square, boardData)
  if square.shrink then
    square.colourIndex = 3 - square.colourIndex
  end
  square.shrink = createTweens({{0,boardData.squareSize/2,0.1}})
end

function getBXAndBY(boardData, x, y)
  local bx = math.floor((x - boardData.startX) / boardData.squareSize) + 1
  local by = math.floor((y - boardData.startY) / boardData.squareSize) + 1
  return bx, by
end

function onBoard(boardData, x, y, otherx, othery)
  if not otherx then local otherx = x end
  if not othery then local othery = y end
  local onBoard = x >= boardData.startX
              and y >= boardData.startY
              and otherx < boardData.startX + boardData.width * boardData.squareSize
              and othery < boardData.startY + boardData.height * boardData.squareSize
  return onBoard
end
