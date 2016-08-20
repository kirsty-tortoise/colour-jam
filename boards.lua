colours = {{250, 0, 0}, {0, 0, 204}} -- red and blue colours for now

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
  love.graphics.draw(baseImage, board.base1X, board.base1Y, 0, 3 * boardData.squareSize / baseImage:getWidth(), 3 * boardData.squareSize / baseImage:getHeight())
  love.graphics.draw(baseImage, board.base2X, board.base2Y, 0, 3 * boardData.squareSize / baseImage:getWidth(), 3 * boardData.squareSize / baseImage:getHeight())
end

function drawSquare(square)
  love.graphics.setColor(colours[square.colourIndex])
  love.graphics.rectangle("fill", square.x, square.y, square.squareSize, square.squareSize)
end

function flipBoard(mode, board, bx, by)

end
