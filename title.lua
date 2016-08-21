title = {code="title"}

require "tween"

local logo = love.graphics.newImage("art/logo.png")
local isdisplayed, isflashing, totaldt, logotween, chartween

function title.setup()
  logo = love.graphics.newImage("art/logo.png")
  isdisplayed = false
  isflashing = false
  totaldt = 0
  logotween = createTweens({{-300, 70, 1}})
  chartween = createTweens({{1200, 580, 1}})
end

function title.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(logo, valueTween(logotween), 50)
  love.graphics.draw(mainCharacter, valueTween(chartween), 200, 0.25, 0.6, 0.6)
  love.graphics.setFont(mediumFont)
  if isdisplayed then love.graphics.printf("- press any key - ", 100, 400, 560, "center") end
  return title
end

function title.update(dt)
  totaldt = totaldt + dt
  if isflashing then
    if totaldt > 0.5 then
      totaldt = totaldt - 0.5
      isdisplayed = not isdisplayed
    end
  else
    updateTweens(logotween, dt)
    updateTweens(chartween, dt)
    if totaldt > 1 then
      totaldt = totaldt - 1
      isflashing = true
      isdisplayed = true
    end
  end
  return title
end

function title.keypressed(blah, blahh, blahhh)
  return gameSetup
end

function title.joystickpressed(blah, blahh)
  return gameSetup
end
