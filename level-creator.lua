levelCreator = {code = "level-creator"}

local boards = {}
local board = {}

function levelCreator.setup()
  board = generateRandomBoard(board, boardData.startX, boardData.startY, boardData.width, boardData.height, boardData.squareSize)
  return levelCreator
end

function levelCreator.draw()
  drawBoard(board)
  return levelCreator
end

function levelCreator.mousepressed(x, y, button, istouch)
  if button == 1 then
    for i = 1,#board do
      for j = 1,#(board[1]) do
        if isOverSquare(board[i][j], x, y) then
          board[i][j].colourIndex = 3 - board[i][j].colourIndex
        end
      end
    end
  end
  return levelCreator
end

function isOverSquare(square, x, y)
  return x > square.x
     and y > square.y
     and x < square.x + square.squareSize
     and y < square.y + square.squareSize
end
