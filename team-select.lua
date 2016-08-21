teamSelect = {code="team-select"}
local playerTweens = {}
local bg = love.graphics.newImage("art/teambg.png")

function teamSelect.setup()
  for i=1, #players do
    table.insert(playerTweens, createTweens({{0,0,1}}))
  end
  return teamSelect
end

function setTeamColour(team)
  if team == 0 then
    love.graphics.setColor(255,255,255)
  else
    love.graphics.setColor(colours[team])
  end
end

function teamSelect.draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(bg, 0, 0)
  for i=1, #players do
    love.graphics.setFont(mediumFont)
    love.graphics.setColor(0, 0, 0)
    if players[i].team == 0 then
      love.graphics.rectangle("line", 310+valueTween(playerTweens[i]), (20 * i) + (50 * (i-1)), 180, 50)
      love.graphics.printf("Player "..i, 310+valueTween(playerTweens[i]), 5 + (20 * i) + (50 * (i-1)), 180, "center")
      setTeamColour(0)
      love.graphics.draw(mainCharacter, 300+valueTween(playerTweens[i]), (20 * i) + (50 * (i-1)) - 10, -0.25, 0.1)
    elseif players[i].team == 1 then
      love.graphics.rectangle("line", 10+valueTween(playerTweens[i]), (20 * i) + (50 * (i-1)), 180, 50)
      love.graphics.printf("Player "..i, 10+valueTween(playerTweens[i]), 5 + (20 * i) + (50 * (i-1)), 180, "center")
      setTeamColour(1)
      love.graphics.draw(mainCharacter, valueTween(playerTweens[i]), (20 * i) + (50 * (i-1)) - 10, -0.25, 0.1)
    else
      love.graphics.rectangle("line", 615+valueTween(playerTweens[i]), (20 * i) + (50 * (i-1)), 180, 50)
      love.graphics.printf("Player "..i, 615+valueTween(playerTweens[i]), 5 + (20 * i) + (50 * (i-1)), 180, "center")
      setTeamColour(2)
      love.graphics.draw(mainCharacter, 605+valueTween(playerTweens[i]), (20 * i) + (50 * (i-1)) - 10, -0.25, 0.1)
    end
  end
  if debug or playersOnTeam(0) == 0 then
    -- READY TO GO!
    love.graphics.setColor(0,0,0)
    love.graphics.draw(gobutton, 365, 510, 0, 0.3)
  end
  return teamSelect
end

function teamSelect.update(dt)
  for i=1, #playerTweens do
    updateTweens(playerTweens[i], dt)
  end
  for i, j in pairs(players) do
    if j.joystick then
      local dir = checkFlick(j.joystick)
      if dir then
        if dir == "left" and j.team ~= 1 then
          if j.team == 2 then
            j.team = 0
            playerTweens[i] = createTweens({{305, 0, 0.1}})
          else
            if playersOnTeam(1) < #players / 2 then
              j.team = 1
              playerTweens[i] = createTweens({{305, 0, 0.1}})
            else
              playerTweens[i] = createTweens({{20, 0, 0.05},{0, -20, 0.05},{-20, 20, 0.1},{20, 0, 0.05}})
            end
          end
        elseif dir == "right" and j.team ~= 2 then
          if j.team == 1 then
            j.team = 0
            playerTweens[i] = createTweens({{-305, 0, 0.1}})
          else
            if playersOnTeam(2) < #players / 2 then
              j.team = 2
              playerTweens[i] = createTweens({{-305, 0, 0.1}})
            else
              playerTweens[i] = createTweens({{20, 0, 0.05},{0, -20, 0.05},{-20, 20, 0.1},{20, 0, 0.05}})
            end
          end
        end
      end
    end
  end
  return teamSelect
end

function playersOnTeam(n)
  local count = 0
  for i=1, #players do
    if players[i].team == n then count = count + 1 end
  end
  return count
end

function teamSelect.keypressed(k, sc, ir)
  if k == "return" and playersOnTeam(0) == 0 then
    return game
  else
    for i=1, #players do
      if players[i].keys then
        if players[i].keys.left == k and players[i].team ~= 1 then
          if players[i].team == 2 then
            players[i].team = 0
            playerTweens[i] = createTweens({{305, 0, 0.1}})
          else
            if playersOnTeam(1) < #players / 2 then
              players[i].team = 1
              playerTweens[i] = createTweens({{305, 0, 0.1}})
            else
              playerTweens[i] = createTweens({{20, 0, 0.05},{0, -20, 0.05},{-20, 20, 0.1},{20, 0, 0.05}})
            end
          end
        elseif players[i].keys.right == k and players[i].team ~= 2 then
          if players[i].team == 1 then
            players[i].team = 0
            playerTweens[i] = createTweens({{-305, 0, 0.1}})
          else
            if playersOnTeam(2) < #players / 2 then
              players[i].team = 2
              playerTweens[i] = createTweens({{-305, 0, 0.1}})
            else
              playerTweens[i] = createTweens({{20, 0, 0.05},{0, -20, 0.05},{-20, 20, 0.1},{20, 0, 0.05}})
            end
          end
        end
      else
        -- DEAL WITH CONTROLLER STUFF
      end
    end
  end
  return teamSelect
end

function teamSelect.mousepressed(x, y, b, istouch)
  if b == 1 and (debug or playersOnTeam(0) == 0) then
    if x > 365 and x < 448 and y > 510 and y < 573 then
      return game
    end
  end
  return teamSelect
end
