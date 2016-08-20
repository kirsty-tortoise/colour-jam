game = {code="game"}

board = {}
boardData = {startX = 0, startY = 0, width = 16, height = 10, squareSize = 50}

function game.setup()
  board = generateRandomBoard(board, boardData.startX, boardData.startY, boardData.width, boardData.height, boardData.squareSize)
  playerSetup(players, boardData)
  return game
end

function game.update(dt)
  updateAllPlayers(players, dt)
  return game
end

function game.draw()
  drawBoard(board)
  drawAllPlayers(players)
  return game
end

function game.keypressed(key, scancode, isrepeat)
  keypressAllPlayers(players, key)
  return game
end

function game.keyreleased(key)
  keyreleaseAllPlayers(players, key)
  return game
end
