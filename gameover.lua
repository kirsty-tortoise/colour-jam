gameover = {}

function gameover.draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(largeFont)
  love.graphics.printf("GAME OVER", 50, 100, 700, "center")
  return gameover
end
