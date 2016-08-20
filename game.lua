game = {}

local board = {}
local newGame = true

function game.update(dt)
  if newGame then
    board = generateRandomBoard(board, 0, 0, 16, 10, 50)
    newGame = false
  end
  return game
end

function game.draw()
  print("running")
  drawBoard(board)
  return game
end
