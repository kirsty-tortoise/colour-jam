function generateRandomBoard(board, startX, startY, width, height, squareSize, colours)
  local x = startX
  for i = 1,width do
    local y = startY
    board[i] = {}
    for j = 1,height do
      local colour = colours[math.random(2)]
      board[i][j] = {x = x, y = y, colour = colour, squareSize = squareSize}
      y = y + squareSize
    end
    x = x + squareSize
  end
  return board
end

function drawBoard(board)
  for _,col in pairs(board) do
    for _,square in pairs(col) do
      drawSquare(square)
    end
  end
end

function drawSquare(square)
  love.graphics.setColor(square.colour)
  love.graphics.rectangle("fill", square.x, square.y, square.squareSize, square.squareSize)
end
