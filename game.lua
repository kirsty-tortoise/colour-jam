game = {code="game"}

board = {}
boardData = {startX = 0, startY = 0, width = 16, height = 10, squareSize = 50}
scores = {0, 0}
local flag1, flag2
local loopflag = true

function game.setup()
  love.audio.play(bg)
  board = generateRandomBoard(board, boardData.startX, boardData.startY, boardData.width, boardData.height, boardData.squareSize)
  playerSetup(players, boardData)
  flag1, flag2 = {}, {}
  flagSetup(flag1, flag2, boardData)
  scores = {0, 0}
  resetTimer()
  setupScoreBar()
  return game
end

function game.update(dt)
  joystickUpdateAllPlayers(players)
  updateAllPlayers(players, dt)
  updateFlags(players, flag1, flag2, board, boardData)
  updateTimer(dt)
  updateScoreBar(dt)
  if isGameOver() then
    if bg:isPlaying() then
      love.audio.stop(bg)
    else
      love.audio.stop(bgtoloop)
    end
    return gameover
  end
  if not bg:isPlaying() and loopflag then
    love.audio.play(bgtoloop)
    bgtoloop:setLooping(true)
    loopflag = false
  end
  return game
end

function game.joystickpressed(j, b)
  joystickpressedAllPlayers(players, j, b)
  return game
end

function game.draw()
  drawBoard(board)
  drawAllPlayers(players)
  drawFlag(flag1, boardData)
  drawFlag(flag2, boardData)
  drawTimer()
  drawScore()
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
