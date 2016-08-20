colours = {{250, 0, 0}, {0, 0, 204}} -- red and blue colours for now

local baseImage1 = love.graphics.newImage("art/base1.png")
local baseImage2 = love.graphics.newImage("art/base2.png")

function generateRandomBoard(board, startX, startY, width, height, squareSize)
  local x = startX
  for i = 1,width do
    local y = startY
    board[i] = {}
    for j = 1,height do
      local colourIndex = math.random(2)
      board[i][j] = {x = x, y = y, colourIndex = colourIndex, squareSize = squareSize}
      y = y + squareSize
      if (i <= 3 and j <= 3) or (i > width - 3 and j > height - 3) then
        board[i][j].isBase = true
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
  love.graphics.rectangle("fill", square.x, square.y, square.squareSize, square.squareSize)
end

function flipBoard(mode, board, bx, by)
  if mode == "column" then
    for i = 1,boardData.height do
      if by ~= i then
        board[bx][i].colourIndex = 3 - board[bx][i].colourIndex
      end
    end
  elseif mode == "row" then
    for j = 1,boardData.width do
      if bx ~= j then
        board[j][by].colourIndex = 3 - board[j][by].colourIndex
      end
    end
  elseif mode == "area" then
    for i = 1,boardData.width do
      for j = 1,boardData.height do
        distance = math.abs(i - bx) + math.abs(j - by)
        if distance ~= 0 and distance <= 2 then
          board[i][j].colourIndex = 3 - board[i][j].colourIndex
        end
      end
    end
  end
end
