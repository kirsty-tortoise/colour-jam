local cooldown = 0.5

function getStartingPosition(playerTeam, playerNum, level)
  local positions = {{0, 0}, {0, 2}, {2, 0}, {2, 2}}
  local boardData = level.boardData
  if playerTeam == 1 then
    return boardData.base1BX +  positions[playerNum][1],
           boardData.base1BY + positions[playerNum][2]
  else
    return boardData.base2BX +  positions[playerNum][1],
           boardData.base2BY + positions[playerNum][2]
  end
end

function playerSetup(players, level)
  local boardData = level.boardData
  local team1Count = 0
  local team2Count = 0
  for i,player in pairs(players) do
    player.scale = 0.7 * boardData.squareSize / mainCharacter:getHeight()
    player.width = mainCharacter:getWidth() * player.scale
    player.height = mainCharacter:getHeight() * player.scale

    -- Set their team and colour
    if not player.team or player.team == 0 then
      if i % 2 == 0 then
        player.team = 1
      else
        player.team = 2
      end
    end
    player.colour = colours[player.team]

    -- move them to the right place depending on team
    local bx, by
    if player.team == 1 then
      team1Count = team1Count + 1
      bx, by = getStartingPosition(1, team1Count, level)
    else
      team2Count = team2Count + 1
      bx, by = getStartingPosition(2, team2Count, level)
    end
    movePlayerTo(player, bx, by, level)
    player.initialBX, player.initialBY = bx, by

    -- Final player stuff
    player.speed = 100.0
    player.timer = 0

    -- set up, down, left and right to false, so they don't move at start
    player.up, player.down, player.left, player.right = false, false, false, false
  end
end

function drawPlayer(player,i)
  if player.timer < 0 then
    love.graphics.setColor(255,255,255)
    love.graphics.setLineWidth(3)
    love.graphics.arc("line", "open", player.x + 0.5 * player.width, player.y + 0.5 * player.height, 0.6 * player.height, - math.pi * 0.5, - 2 * math.pi * player.timer / cooldown - math.pi * 0.5)
    love.graphics.setLineWidth(1)
  end
  love.graphics.setColor(player.colour)
  love.graphics.draw(mainCharacter, player.x, player.y, 0, player.scale)
  love.graphics.draw(floatingNumbers[i], player.x + 0.25 * player.width, player.y - 0.7 * player.height, 0, 0.25)
end

function updatePlayer(player, dt, level)
  player.timer = player.timer + dt

  -- check if they have somehow become stuck
  if not checkPosition(player, player.bx, player.by, level) then
    if player.flagHolding then
      dropFlag(player.flagHolding, player.bx, player.by, level)
    end
    movePlayerTo(player, player.initialBX, player.initialBY, level)
  elseif not canPlayerMove(player, level) then
    -- they are in the right square, but slightly stuck
    movePlayerTo(player, player.bx, player.by, level)
  end

  local newX, newY = player.x, player.y
  if player.up then
    newY = player.y - player.speed * dt
  end
  if player.down then
    newY = player.y + player.speed * dt
  end
  if player.left then
    newX = player.x - player.speed * dt
  end
  if player.right then
    newX = player.x + player.speed * dt
  end

  movePlayerIfCan(player, newX, newY, level)
end

function processKeypressPlayer(player, key, level)
  if player.keys then
    if key == player.keys.up then
      player.up = true
    elseif key == player.keys.down then
      player.down = true
    elseif key == player.keys.left then
      player.left = true
    elseif key == player.keys.right then
      player.right = true
    elseif key == player.keys.flip and player.timer >= 0 then
      flipBoard(player.flipMode, player.bx, player.by, level)
      player.timer = -cooldown
    end
  end
end

function processKeyreleasePlayer(player, key)
  if player.keys then
    if key == player.keys.up then
      player.up = false
    elseif key == player.keys.down then
      player.down = false
    elseif key == player.keys.left then
      player.left = false
    elseif key == player.keys.right then
      player.right = false
    end
  end
end

function processJoystickpressPlayer(player, j, b, level)
  if player.joystick and b == player.buttonid and player.joystick:getID() == j:getID() then
    flipBoard(player.flipMode, player.bx, player.by, level)
    player.timer = -1
  end
end

function updateAllPlayers(players, dt, level)
  for _,player in pairs(players) do
    updatePlayer(player, dt, level)
  end
end

function drawAllPlayers(players)
  for i,player in pairs(players) do
    drawPlayer(player,i)
  end
end

function keypressAllPlayers(players, key, level)
  for _,player in pairs(players) do
    processKeypressPlayer(player, key, level)
  end
end

function keyreleaseAllPlayers(players, key)
  for _,player in pairs(players) do
    processKeyreleasePlayer(player, key)
  end
end

function joystickpressedAllPlayers(players, j, b, level)
  for _, player in pairs(players) do
    processJoystickpressPlayer(player, j, b, level)
  end
end

function joystickUpdateAllPlayers(players)
  for _,player in pairs(players) do
    if player.joystick then
      local x1, x2 = player.joystick:getAxis(1), player.joystick:getAxis(3)
      local y1, y2 = player.joystick:getAxis(2), player.joystick:getAxis(4)
      local x, y
      if math.abs(x1) > math.abs(x2) then x = x1 else x = x2 end
      if math.abs(y1) > math.abs(y2) then y = y1 else y = y2 end
      if x < -0.5 then
        player.left = true
        player.right = false
      elseif x > 0.5 then
        player.left = false
        player.right = true
      else
        player.left = false
        player.right = false
      end

      if y < -0.5 then
        player.up = true
        player.down = false
      elseif y > 0.5 then
        player.up = false
        player.down = true
      else
        player.up = false
        player.down = false
      end

    end
  end
end

function getMidPosition(player, x, y)
  return x + player.width / 2, y + player.height / 2
end

function getOtherSide(player, x, y)
  return x + player.width, y + player.height
end

function canPlayerMove(player, level)
  local board, boardData = level.board, level.boardData
  local otherX, otherY = getOtherSide(player, player.x, player.y)
  local bx1,by1 = getBXAndBY(player.x, player.y, level)
  local bx2,by2 = getBXAndBY(otherX, otherY, level)

  return checkPosition(player, bx1, by1, level)
     and checkPosition(player, bx1, by2, level)
     and checkPosition(player, bx2, by1, level)
     and checkPosition(player, bx2, by2, level)
end

function movePlayerIfCan(player, newX, newY, level)
  local board, boardData = level.board, level.boardData
  local otherX, otherY = getOtherSide(player, newX, newY)
  local bx1,by1 = getBXAndBY(newX, newY, level)
  local bx2,by2 = getBXAndBY(otherX, otherY, level)
  local midX, midY = getMidPosition(player, newX, newY)
  local bx, by = getBXAndBY(midX, midY, level)

  if onBoard(newX, newY, otherX, otherY, level)
     and checkPosition(player, bx1, by1, level)
     and checkPosition(player, bx1, by2, level)
     and checkPosition(player, bx2, by1, level)
     and checkPosition(player, bx2, by2, level) then
    player.x, player.y, player.bx, player.by = newX, newY, bx, by
  end
end

function checkPosition(player, bx, by, level)
  return level.board[bx][by].teamBase or (player.team == level.board[bx][by].colourIndex and not level.board[bx][by].shrink)
end

function movePlayerTo(object, bx, by, level)
  local boardData = level.boardData
  object.bx, object.by = bx, by
  object.x = boardData.startX + boardData.squareSize * (bx - 0.8)
  object.y = boardData.startY + boardData.squareSize * (by - 1)
end
