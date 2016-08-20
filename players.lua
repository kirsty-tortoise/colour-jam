function getStartingPosition(playerTeam, playerNum, boardData)
  local positions = {{1, 1}, {1, 3}, {3, 1}, {3, 3}}
  if playerTeam == 1 then
    return positions[playerNum][1], positions[playerNum][2]
  else
    return boardData.width + 1 -  positions[playerNum][1],
           boardData.height + 1 - positions[playerNum][2]
  end
end

function playerSetup(players, boardData)
  local team1Count = 0
  local team2Count = 0
  for i,player in pairs(players) do
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
      bx, by = getStartingPosition(1, team1Count, boardData)
    else
      team2Count = team2Count + 1
      bx, by = getStartingPosition(2, team2Count, boardData)
    end
    movePlayerTo(player, boardData, bx, by)

    -- Final player stuff
    player.speed = 70.0
    player.timer = 0
  end
end

function drawPlayer(player)
  love.graphics.setColor(player.colour)
  love.graphics.draw(mainCharacter, player.x, player.y, 0, boardData.squareSize * 0.9 / mainCharacter:getHeight(), boardData.squareSize * 0.9 / mainCharacter:getHeight())
end

function updatePlayer(player, dt)
  player.timer = player.timer + dt

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

  movePlayerIfCan(player, newX, newY, board, boardData)
end

function processKeypressPlayer(player, key)
  if key == player.keys.up then
    player.up = true
  elseif key == player.keys.down then
    player.down = true
  elseif key == player.keys.left then
    player.left = true
  elseif key == player.keys.right then
    player.right = true
  elseif key == player.keys.flip and player.timer >= 0 then
    flipBoard(player.flipMode, board, player.bx, player.by)
    movePlayerTo(player, boardData, player.bx, player.by)
    player.timer = -1
  end
end

function processKeyreleasePlayer(player, key)
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

function updateAllPlayers(players, dt)
  for _,player in pairs(players) do
    updatePlayer(player, dt)
  end
end

function drawAllPlayers(players)
  for _,player in pairs(players) do
    drawPlayer(player)
  end
end

function keypressAllPlayers(players, key)
  for _,player in pairs(players) do
    processKeypressPlayer(player, key)
  end
end

function keyreleaseAllPlayers(players, key)
  for _,player in pairs(players) do
    processKeyreleasePlayer(player, key)
  end
end

function getBXAndBY(boardData, x, y)
  local bx = math.floor((x - boardData.startX) / boardData.squareSize) + 1
  local by = math.floor((y - boardData.startY) / boardData.squareSize) + 1
  return bx, by
end

function getMidPosition(x, y)
  return x + boardData.squareSize * 0.2, y + boardData.squareSize / 2
end

function getOtherSide(x,y)
  return x + boardData.squareSize * 0.5 * 0.9, y + boardData.squareSize * 0.9
end

function movePlayerIfCan(player, newX, newY, board, boardData)
  local otherX, otherY = getOtherSide(newX, newY)
  local onBoard = newX >= boardData.startX
                  and newY >= boardData.startY
                  and otherX < boardData.startX + boardData.width * boardData.squareSize
                  and otherY < boardData.startY + boardData.height * boardData.squareSize

  local bx1,by1 = getBXAndBY(boardData, newX, newY)
  local bx2,by2 = getBXAndBY(boardData, otherX, otherY)
  local bx, by = getBXAndBY(boardData, getMidPosition(newX, newY))

  if onBoard and checkPosition(player, board, bx1, by1)
             and checkPosition(player, board, bx1, by2)
             and checkPosition(player, board, bx2, by1)
             and checkPosition(player, board, bx2, by2) then
    player.x, player.y, player.bx, player.by = newX, newY, bx, by
  end
end

function checkPosition(player, board, bx, by)
  return board[bx][by].isBase or player.team == board[bx][by].colourIndex
end

function movePlayerTo(player, boardData, bx, by)
  player.bx, player.by = bx, by
  player.x = boardData.startX + boardData.squareSize * (bx - 0.8)
  player.y = boardData.startY + boardData.squareSize * (by - 1)
end
