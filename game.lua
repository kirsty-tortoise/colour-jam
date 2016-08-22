game = {code="game"}

local level
-- board = {}
-- boardData = {startX = 0, startY = 0, width = 16, height = 10, squareSize = 50}
scores = {0, 0}
local flag1, flag2
local loopflag = true

function game.setup()
  love.audio.play(bg)
  loopflag = true
  level = generateRandomBoard(0, 0, 16, 10, 50)
  playerSetup(players, level)
  flag1, flag2 = {}, {}
  flagSetup(flag1, flag2, level)
  scores = {0, 0}
  resetTimer()
  setupScoreBar()
  return game
end

function game.update(dt)
  joystickUpdateAllPlayers(players)
  updateBoard(dt, level)
  updateAllPlayers(players, dt, level)
  updateFlags(players, flag1, flag2, level)
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
  joystickpressedAllPlayers(players, j, b, level)
  return game
end

function game.draw()
  drawBoard(level)
  drawAllPlayers(players)
  drawFlag(flag1, level)
  drawFlag(flag2, level)
  drawTimer()
  drawScore()
  return game
end

function game.keypressed(key, scancode, isrepeat)
  keypressAllPlayers(players, key, level)
  return game
end

function game.keyreleased(key)
  keyreleaseAllPlayers(players, key)
  return game
end
