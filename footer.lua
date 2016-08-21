local timer = 0
local scoreBar = {}

function resetTimer()
  timer = 5
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

function setupScoreBar()
  scoreBar = {x = 300, y = 525, width = 400, height = 50, lastScore1 = 0, lastScore2 = 0, divide = 200}
end

function drawScore()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(largeFont)
  love.graphics.print(scores[1], 250, 525)
  love.graphics.print(scores[2], 750, 525)
  drawScoreBar()
end

function updateScoreBar(dt)
  if scoreBar.lastScore1 ~= scores[1] or scoreBar.lastScore2 ~= scores[2] then
    -- we need to move the divide
    local divide = scoreBar.width * scores[1] / (scores[1] + scores[2])
    scoreBar.centreTween = createTweens({{scoreBar.divide, divide, 0.5}})
    scoreBar.lastScore1, scoreBar.lastScore2 =  scores[1], scores[2]
  end
  if scoreBar.centreTween then
    updateTweens(scoreBar.centreTween, dt)
    scoreBar.divide = valueTween(scoreBar.centreTween)
    if isTweenFinished(scoreBar.centreTween) then
      scoreBar.centreTween = nil
    end
  end
end

function drawScoreBar()
  -- draw first half
  love.graphics.setColor(colours[1])
  love.graphics.rectangle("fill", scoreBar.x, scoreBar.y, scoreBar.divide, scoreBar.height)
  love.graphics.setColor(colours[2])
  love.graphics.rectangle("fill", scoreBar.x + scoreBar.divide, scoreBar.y, scoreBar.width - scoreBar.divide, scoreBar.height)
end

function moveScoreBarToTop()
  scoreBar.x = 100
  scoreBar.width = 600
  scoreBar.y = 20
  if scores[1] == 0 and scores[2] == 0 then
    scoreBar.divide = scoreBar.width / 2
  else
    scoreBar.divide = scoreBar.width * scores[1] / (scores[1] + scores[2])
  end
end

function drawScoreInGameover()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setFont(largeFont)
  love.graphics.print(scores[1], 50, 25)
  love.graphics.print(scores[2], 730, 25)
  drawScoreBar()
end
