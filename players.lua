function drawPlayer(player)
  love.graphics.setColor(player.colour)
  love.graphics.draw(mainCharacter, player.x, player.y, 0, boardData.squareSize * 0.9 / mainCharacter:getHeight(), boardData.squareSize * 0.9 / mainCharacter:getHeight())
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
                  and otherX <= boardData.startX + boardData.width * boardData.squareSize
                  and otherY <= boardData.startY + boardData.height * boardData.squareSize

  local bx1,by1 = getBXAndBY(boardData, newX, newY)
  local bx2,by2 = getBXAndBY(boardData, otherX, otherY)
  local bx, by = getBXAndBY(boardData, getMidPosition(newX, newY))

  if onBoard and player.team == board[bx1][by1].colourIndex
             and player.team == board[bx1][by2].colourIndex
             and player.team == board[bx2][by1].colourIndex
             and player.team == board[bx2][by2].colourIndex then
    player.x, player.y, player.bx, player.by = newX, newY, bx, by
  end
end
