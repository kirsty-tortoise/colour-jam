gameover = {code = "gameover"}

function gameover.setup()
  moveScoreBarToTop()
  return gameover
end

function gameover.draw()
  drawScoreInGameover()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(largeFont)
  love.graphics.printf("GAME OVER", 50, 100, 700, "center")
  return gameover
end
