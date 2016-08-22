local flagImage = love.graphics.newImage("art/flag.png")

function drawFlag(flag, level)
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(flagImage, flag.x, flag.y, 0, 0.9 * level.boardData.squareSize / flagImage:getHeight())
end

function flagSetup(flag1, flag2, level)
  flag1.team, flag2.team = 1, 2
  flag1.isDown, flag2.isDown = true, true
  moveFlagTo(flag1, level.boardData.base1BX + 1, level.boardData.base1BY + 1, level)
  moveFlagTo(flag2, level.boardData.base2BX + 1, level.boardData.base2BY + 1, level)
  flag1.initialBX, flag1.initialBY = flag1.bx, flag1.by
  flag2.initialBX, flag2.initialBY = flag2.bx, flag2.by
end

function moveFlagTo(object, bx, by, level)
  local boardData = level.boardData
  object.bx, object.by = bx, by
  object.x = boardData.startX + boardData.squareSize * (bx - 0.5)
  object.y = boardData.startY + boardData.squareSize * (by - 1.3)
end

function updateFlags(players, flag1, flag2, level)
  for _,player in pairs(players) do
    if flag1.isDown and player.bx == flag1.bx and player.by == flag1.by then
      if player.team == 2 then
        flag1.isDown = false
        flag1.playerHolding = player
        player.flagHolding = flag1
      elseif player.team == 1 then
        moveFlagTo(flag1, flag1.initialBX, flag1.initialBY, level)
      end
    elseif flag2.isDown and player.bx == flag2.bx and player.by == flag2.by then
      if player.team == 1 then
        flag2.isDown = false
        flag2.playerHolding = player
        player.flagHolding = flag2
      elseif player.team == 2 then
        moveFlagTo(flag2, flag2.initialBX, flag2.initialBY, level)
      end
    end
  end
  updateFlag(flag1, level)
  updateFlag(flag2, level)
end

function dropFlag(flag, bx, by, level)
  moveFlagTo(flag, bx, by, level)
  flag.isDown = true
  if flag.playerHolding then
    flag.playerHolding.flagHolding = nil
  end
  flag.playerHolding = nil
end

function updateFlag(flag, level)
  local boardData = level.boardData
  if not flag.isDown then
    flag.x, flag.y = flag.playerHolding.x + 0.4 * boardData.squareSize, flag.playerHolding.y - 0.1 * boardData.squareSize
    flag.bx, flag.by = getBXAndBY(flag.playerHolding.x, flag.playerHolding.y, level)
    if isFlagBack(flag, level) then
      love.audio.play(applause)
      scores[3 - flag.team] = scores[3 - flag.team] + 1
      dropFlag(flag, flag.initialBX, flag.initialBY, level)
      flag.isDown = true
      flag.playerHolding = nil
    end
  end
end

function isFlagBack(flag, level)
  local teamBase = level.board[flag.bx][flag.by].teamBase
  return teamBase and teamBase ~= flag.team
end
