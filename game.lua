game = {code="game"}

board = {}
boardData = {startX = 0, startY = 0, width = 16, height = 10, squareSize = 50}

function game.setup()
  board = generateRandomBoard(board, boardData.startX, boardData.startY, boardData.width, boardData.height, boardData.squareSize)
  for _,player in pairs(players) do
    -- temporary code so things work
    player.x,player.y = 10,10
    player.row, player.col = 1,1
    player.timer = 0
    player.team = 1
    player.colour = colours[player.team]
    player.speed = 5
  end
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
