game = {code="game"}

board = {}
boardData = {startX = 0, startY = 0, width = 16, height = 10, squareSize = 50}
scores = {0, 0}
local flag1, flag2

function game.setup()
  board = generateRandomBoard(board, boardData.startX, boardData.startY, boardData.width, boardData.height, boardData.squareSize)
  playerSetup(players, boardData)
  flag1, flag2 = {}, {}
  flagSetup(flag1, flag2, boardData)
  scores = {0, 0}
  resetTimer()
  return game
end

function game.update(dt)
  updateAllPlayers(players, dt)
  updateFlags(players, flag1, flag2, board, boardData)
  updateTimer(dt)
  return game
end

function game.draw()
  drawBoard(board)
  drawAllPlayers(players)
  drawFlag(flag1, boardData)
  drawFlag(flag2, boardData)
  drawTimer()
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
