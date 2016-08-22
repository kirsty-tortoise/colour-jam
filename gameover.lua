gameover = {code = "gameover"}

local sameTeamsButton = {x = 50, y = 300, width = 200, height = 200, text = "REMATCH! \n Same Players \n Same Teams", colour = {255, 255, 255}}
local samePlayersButton = {x = 300, y = 300, width = 200, height = 200, text = "REMATCH! \n Same Players \n Different Teams", colour = {255, 255, 255}}
local menuButton = {x = 550, y = 300, width = 200, height = 200, text = "Back to Menu", colour = {255, 255, 255}}

function gameover.setup()
  moveScoreBarToTop()
  love.audio.play(applause)

  -- set colours back to white
  sameTeamsButton.colour = {255, 255, 255}
  samePlayersButton.colour = {255, 255, 255}
  menuButton.colour = {255, 255, 255}

  return gameover
end

function gameover.draw()
  drawScoreInGameover()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(largeFont)
  love.graphics.printf("GAME OVER", 50, 100, 700, "center")
  displayWinner()
  drawButton(sameTeamsButton)
  drawButton(samePlayersButton)
  drawButton(menuButton)
  return gameover
end

function gameover.mousepressed(x, y, button, istouch)
  if isOverButton(sameTeamsButton, x, y) then
    return game
  elseif isOverButton(samePlayersButton, x, y) then
    return teamSelect
  elseif isOverButton(menuButton, x, y) then
    return title
  end
  return gameover
end

function gameover.mousemoved(x, y, dx, dy, istouch)
  for _,btn in pairs({sameTeamsButton, samePlayersButton, menuButton}) do
    if isOverButton(btn, x, y) then
      btn.colour = {255, 0, 0}
    else
      btn.colour = {255, 255, 255}
    end
  end
  return gameover
end

function displayWinner()
  love.graphics.setFont(reallyLargeFont)
  local msg
  if scores[1] > scores[2] then
    msg = "BLUE WINS!"
    love.graphics.setColor(colours[1])
  elseif scores[2] > scores[1] then
    msg = "GREEN WINS!"
    love.graphics.setColor(colours[2])
  else
    msg = "DRAW!"
    love.graphics.setColor(255, 255, 255)
  end
  love.graphics.printf(msg, 50, 180, 700, "center")
end

function drawButton(button)
  love.graphics.setColor(button.colour)
  love.graphics.rectangle("line", button.x, button.y, button.width, button.height)
  love.graphics.setFont(largeishFont)
  love.graphics.printf(button.text, button.x, button.y + 0.2 * button.height, button.width, "center")
end

function isOverButton(button, x, y)
  return x > button.x and x < button.x + button.width and y > button.y and y < button.y + button.height
end
