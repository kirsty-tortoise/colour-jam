local flagImage = love.graphics.newImage("art/flag.png")

function drawFlag(flag, boardData)
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(flagImage, flag.x, flag.y, 0, 0.9 * boardData.squareSize / flagImage:getHeight())
end

function flagSetup(flag1, flag2, boardData)
  flag1.team = 1
  moveFlagTo(flag1, boardData, 2, 2)
  flag2.team = 2
  moveFlagTo(flag2, boardData, boardData.width - 1, boardData.height - 1)
end

function moveFlagTo(object, boardData, bx, by)
  object.bx, object.by = bx, by
  object.x = boardData.startX + boardData.squareSize * (bx - 0.5)
  object.y = boardData.startY + boardData.squareSize * (by - 1.3)
end
