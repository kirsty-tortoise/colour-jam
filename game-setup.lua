gameSetup = {code="game-setup"}

players = {}
local defaultkeys = {{keys={up="up", down="down", left="left", right="right", flip="space"}, used=false}, {keys={up="w", down="s", left="a", right="d", flip="e"}, used=false}, {keys={up="t", down="g", left="f", right="h", flip="y"}, used=false}, {keys={up="i", down="k", left="j", right="l", flip="o"}, used=false}}
local defaultjoys = {}
local addplayer = love.graphics.newImage("art/addplayer.png")
local gobutton = love.graphics.newImage("art/go.png")
local mustSpecifyJoyButton = false

function gameSetup.setup()
  defaultjoys = love.joystick.getJoysticks()
  for i in pairs(defaultjoys) do
    defaultjoys[i] = {joystick = defaultjoys[i], used = false}
  end
  players = {}
  table.insert(players, {keys = defaultkeys[1].keys, flipMode = "row", team = 0})
  defaultkeys[1].used = true
  return gameSetup
end

function gameSetup.draw()
  for i, j in ipairs(players) do
    love.graphics.setFont(mediumFont)
    love.graphics.setColor(255,255,255)
    local x, y = rectanglePosition(i)
    love.graphics.rectangle("fill", x, y, 150, 225)
    love.graphics.draw(mainCharacter, x - 10, y, -0.2, 0.1, 0.1)
    love.graphics.setColor(0,0,0)
    love.graphics.print("Player "..i, x + 40, y + 10)
    if j.keys then
      love.graphics.setFont(smallFont)
      local keystrings = {j.keys.up, j.keys.down, j.keys.left, j.keys.right}
      for i, _ in ipairs(keystrings) do
        if #keystrings[i] > 5 then
          keystrings[i] = keystrings[i]:sub(0,2).."…"
        end
      end
      love.graphics.rectangle("line", x + 55, y + 50, 40, 25)
      love.graphics.printf(keystrings[1], x + 55, y + 55, 40, "center")
      love.graphics.rectangle("line", x + 55, y + 75, 40, 25)
      love.graphics.printf(keystrings[2], x + 55, y + 80, 40, "center")
      love.graphics.rectangle("line", x + 15, y + 75, 40, 25)
      love.graphics.printf(keystrings[3], x + 15, y + 80, 40, "center")
      love.graphics.rectangle("line", x + 95, y + 75, 40, 25)
      love.graphics.printf(keystrings[4], x + 95, y + 80, 40, "center")
      love.graphics.rectangle("line", x + 15, y + 120, 120, 25)
      love.graphics.printf(j.keys.flip, x + 15, y + 125, 125, "center")
    elseif j.joystick then
      love.graphics.printf("Using controller: "..j.joystick:getName().." with ID "..j.joystick:getID()..".", x + 15, y + 50, 120, "center")
    else
      love.graphics.printf("Is AI", x + 15, y + 75, 120, "center")
    end
    love.graphics.setFont(mediumFont)
    love.graphics.printf("Flip Mode: "..j.flipMode, x + 15, y + 160, 120, "center")
  end
  love.graphics.setColor(255,255,255)
  if #players < 4 + love.joystick.getJoystickCount() then
    -- Render "+" button
    local x, y = rectanglePosition(#players + 1)
    love.graphics.draw(addplayer, x - 2, y + 10, 0, 0.4)
  end
  if #players > 1 then
    love.graphics.draw(gobutton, 720, 540, 0, 0.3)
  end
  if mustSpecifyJoyButton then
    love.graphics.setColor(0,0,0,50)
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    love.graphics.setColor(255,255,255)
    love.graphics.setFont(largeFont)
    love.graphics.printf("Please press a button to use as flip.",0,0,800)
  end
  return gameSetup
end

function rectanglePosition(playernumber)
  local x, y = 0, 0
  if playernumber % 2 == 0 then
    -- lower row
    y = 285
    x = (40 * (playernumber / 2)) + (150 * ((playernumber / 2) - 1)) - 20
  else
    y = 10
    x = (40 * ((playernumber + 1) / 2)) + (150 * ((playernumber - 1) / 2)) - 20
  end
  return x, y
end

function gameSetup.mousepressed(mx, my, b, istouch)
  if b == 1 then
    local x, y = rectanglePosition(#players + 1)
    local h, w = addplayer:getHeight() * 0.4, addplayer:getWidth() * 0.4
    if mx > x - 2 and mx < x - 2 + w and my > y + 10 and my < y + 10 + h then
      -- First try to add a joystick:
      local joystickfree = 0
      for i in pairs(defaultjoys) do
        if not defaultjoys[i].used then
          joystickfree = i
          break
        end
      end
      if joystickfree > 0 then
        table.insert(players, {flipMode = "row", joystick = defaultjoys[joystickfree].joystick, buttonid = 0, team = 0})
        defaultjoys[joystickfree].used = true
        mustSpecifyJoyButton = true
      else
        local keyboardfree = 0
        for i in pairs(defaultkeys) do
          if not defaultkeys[i].used then
            keyboardfree = i
            break
          end
        end
        if keyboardfree > 0 then
          table.insert(players, {flipMode = "row", keys = defaultkeys[keyboardfree].keys, team = 0})
          defaultkeys[keyboardfree].used = true
        else
          -- Nothing's free, sad. Add "AI"
          table.insert(players, {flipMode = "row", team = 0})
        end
      end
    elseif mx > 720 and mx < 720 + (gobutton:getHeight() * 0.3) and my > 540 and my < 540 + (gobutton:getWidth() * 0.3) then
      return game
    end
  end
  return gameSetup
end

function gameSetup.joystickadded(j)
  table.insert(defaultjoys, {joystick = j, used = false})
end

function gameSetup.joystickremoved(j)
  local eyedee = j:getID()
  local removedindex = 0
  for i in pairs(defaultjoys) do
    if defaultjoys[i].joystick:getID() == eyedee then
      removedindex = i
      break
    end
  end
  table.remove(defaultjoys, removedindex)
end
