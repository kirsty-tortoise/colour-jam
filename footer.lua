local timer = 0

function resetTimer()
  timer = 60
end

function updateTimer(dt)
  timer = timer - dt
end

function drawTimer()
  local toPrint = tostring(timer)
  if not string.find(toPrint, "%.") then
    toPrint = toPrint .. ".000"
  else
    toPrint = toPrint .. "000"
  end
  toPrint = toPrint:sub(1, 5)
  love.graphics.setFont(largeFont)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(toPrint, 30, 525)
end

function isGameOver()
  return timer <= 0
end
