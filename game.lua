game = {code="game"}

local level
scores = {0, 0}
local flag1, flag2
local loopflag = true

function game.setup()
  love.audio.play(bg)
  loopflag = true
  if levelSelected == "random" then
    level = generateRandomBoard(0, 0, 16, 10, 50)
  else
    local n = string.match(levelSelected, "default(%d+)")
    if n then
      level = copy(defaultLevels[tonumber(n)])
    else
      n = string.match(levelSelected, "your%-level(%d+)")
      if n then
        level = copy(yourLevels[tonumber(n)])
      else
        error("Something wrong with levelSelected! " .. levelSelected)
      end
    end
  end
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
