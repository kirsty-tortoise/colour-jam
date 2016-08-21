local flagImage = love.graphics.newImage("art/flag.png")

function drawFlag(flag, boardData)
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(flagImage, flag.x, flag.y, 0, 0.9 * boardData.squareSize / flagImage:getHeight())
end

function flagSetup(flag1, flag2, boardData)
  flag1.team, flag2.team = 1, 2
  flag1.isDown, flag2.isDown = true, true
  moveFlagTo(flag1, boardData, 2, 2)
  moveFlagTo(flag2, boardData, boardData.width - 1, boardData.height - 1)
  flag1.initialBX, flag1.initialBY = flag1.bx, flag1.by
  flag2.initialBX, flag2.initialBY = flag2.bx, flag2.by
end

function moveFlagTo(object, boardData, bx, by)
  object.bx, object.by = bx, by
  object.x = boardData.startX + boardData.squareSize * (bx - 0.5)
  object.y = boardData.startY + boardData.squareSize * (by - 1.3)
end

function updateFlags(players, flag1, flag2, board, boardData)
  for _,player in pairs(players) do
    if player.team == 2 and flag1.isDown and player.bx == flag1.bx and player.by == flag1.by then
      flag1.isDown = false
      flag1.playerHolding = player
    elseif player.team == 1 and flag2.isDown and player.bx == flag2.bx and player.by == flag2.by then
      flag2.isDown = false
      flag2.playerHolding = player
    end
  end
  updateFlag(flag1, board, boardData)
  updateFlag(flag2, board, boardData)
end

function updateFlag(flag, board, boardData)
  if not flag.isDown then
    flag.x, flag.y = flag.playerHolding.x + 0.4 * boardData.squareSize, flag.playerHolding.y - 0.1 * boardData.squareSize
    flag.bx, flag.by = getBXAndBY(boardData, flag.playerHolding.x, flag.playerHolding.y)
    if isFlagBack(flag, board) then
      scores[3 - flag.team] = scores[3 - flag.team] + 1
      moveFlagTo(flag, boardData, flag.initialBX, flag.initialBY)
      flag.isDown = true
      flag.playerHolding = nil
    end
  end
end

function isFlagBack(flag, board)
  local teamBase = board[flag.bx][flag.by].teamBase
  return teamBase and teamBase ~= flag.team
end
