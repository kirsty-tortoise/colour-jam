game = {code="game"}

local board = {}

function game.setup()
  board = generateRandomBoard(board, 0, 0, 16, 10, 50)
  return game
end

function game.update(dt)
  return game
end

function game.draw()
  print("running")
  drawBoard(board)
  return game
end
