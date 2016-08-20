function drawPlayer(player)
  love.graphics.setColor(player.colour)
  love.graphics.draw(mainCharacter, player.x, player.y)
end

function updatePlayer(player, dt)
  player.timer = player.timer + dt

  local newX, newY = player.x, player.y
  if player.up then
    newY = player.y - player.speed
  end
  if player.down then
    newY = player.y + player.speed
  end
  if player.left then
    newX = player.x - player.speed
  end
  if player.right then
    newX = player.x + player.speed
  end

  local newBx, newBy = getBXAndBY(boardData, newX, newY)
  if player.team == board[newBx][newBy].colourIndex then
    player.x, player.y, player.bx, player.by = newX, newY, newBx, newBy
  end

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
    player.timer = -2
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
  -- temporary code
  local bx = math.floor((x - boardData.startX) / boardData.squareSize)
  local by = math.floor((y - boardData.startY) / boardData.squareSize)
  return bx, by
end
