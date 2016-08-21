gameSetup = {code="game-setup"}

players = {}
local defaultkeys = {{keys={up="up", down="down", left="left", right="right", flip="space"}, used=false}, {keys={up="w", down="s", left="a", right="d", flip="e"}, used=false}, {keys={up="t", down="g", left="f", right="h", flip="y"}, used=false}, {keys={up="i", down="k", left="j", right="l", flip="o"}, used=false}}
local defaultjoys = {}
local addplayer = love.graphics.newImage("art/addplayer.png")
local mustSpecifyJoyButton = {}

function gameSetup.setup()
  defaultjoys = love.joystick.getJoysticks()
  for i in pairs(defaultjoys) do
    defaultjoys[i] = {joystick = defaultjoys[i], used = false}
  end
  players = {}
  if #defaultjoys > 0 then
    table.insert(players, {joystick = defaultjoys[1].joystick, flipMode = "row", team = 0, buttonid = 0})
    table.insert(mustSpecifyJoyButton,{players[#players].joystick:getID(), #players})
    defaultjoys[1].used = true
    if #defaultjoys > 1 then
      table.insert(players, {joystick = defaultjoys[2].joystick, flipMode = "row", team = 0, buttonid = 0})
      table.insert(mustSpecifyJoyButton,{players[#players].joystick:getID(), #players})
      defaultjoys[2].used = true
    else
      table.insert(players, {keys = defaultkeys[1].keys, flipMode = "row", team = 0})
      defaultkeys[1].used = true
    end
  else
    table.insert(players, {keys = defaultkeys[1].keys, flipMode = "row", team = 0})
    table.insert(players, {keys = defaultkeys[2].keys, flipMode = "row", team = 0})
    defaultkeys[1].used = true
    defaultkeys[2].used = true
  end
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
      love.graphics.setFont(smallFont)
      love.graphics.printf("Using controller: "..j.joystick:getName(), x + 15, y + 50, 120, "center")
    else
      love.graphics.printf("Is AI", x + 15, y + 75, 120, "center")
    end
    love.graphics.setFont(mediumFont)
    love.graphics.printf("Flip Mode:\n< "..j.flipMode.." >", x + 15, y + 160, 120, "center")
    if love.joystick.getJoystickCount() > 0 then
      love.graphics.setColor(255,255,255)
      love.graphics.rectangle("fill", x + 50, y + 225, 100, 20)
      love.graphics.setColor(0,0,0)
      love.graphics.setFont(smallFont)
      if j.keys then
        love.graphics.print("Controller?", x + 55, y + 225)
      else
        love.graphics.print("Keyboard?", x + 55, y + 225)
      end
    end
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
  if #mustSpecifyJoyButton > 0 then
    love.graphics.setColor(0,0,0,200)
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    love.graphics.setColor(255,255,255)
    love.graphics.setFont(largeFont)
    love.graphics.printf("Please press a button to use as flip.",0,100,800,"center")
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

function gameSetup.update(dt)
  for i,j in pairs(players) do
    if j.joystick then
      local dir = checkFlick(j.joystick)
      if dir then
        modifyFlipType(dir, j)
      end
    end
  end
  return gameSetup
end

function getUnusedJoystick()
  for i in pairs(defaultjoys) do
    if not defaultjoys[i].used then
      return i
    end
  end
  return 0
end

function getUnusedKeymap()
  for i in pairs(defaultkeys) do
    if not defaultkeys[i].used then
      return i
    end
  end
  return 0
end

function gameSetup.mousepressed(mx, my, b, istouch)
  if b == 1 and #mustSpecifyJoyButton == 0 then
    local x, y = rectanglePosition(#players + 1)
    local h, w = addplayer:getHeight() * 0.4, addplayer:getWidth() * 0.4
    if mx > x - 2 and mx < x - 2 + w and my > y + 10 and my < y + 10 + h then
      -- First try to add a joystick:
      local joystickfree = getUnusedJoystick()
      if joystickfree > 0 then
        table.insert(players, {flipMode = "row", joystick = defaultjoys[joystickfree].joystick, buttonid = 0, team = 0})
        defaultjoys[joystickfree].used = true
        table.insert(mustSpecifyJoyButton, {players[#players].joystick:getID(), #players})
      else
        local keyboardfree = getUnusedKeymap()
        if keyboardfree > 0 then
          table.insert(players, {flipMode = "row", keys = defaultkeys[keyboardfree].keys, team = 0})
          defaultkeys[keyboardfree].used = true
        else
          -- Nothing's free, sad. Add "AI"
          table.insert(players, {flipMode = "row", team = 0})
        end
      end
    elseif mx > 720 and mx < 720 + (gobutton:getHeight() * 0.3) and my > 540 and my < 540 + (gobutton:getWidth() * 0.3) then
      return teamSelect
    else
      -- Check for controls swap!
      for k=1, #players do
        local x, y = rectanglePosition(k)
        if mx > x + 50 and mx < x + 150 and my > y + 225 and my < y + 245 then
          if players[k].keys then
            for i in pairs(defaultkeys) do
              if players[k].keys.up == defaultkeys[i].keys.up then
                print("Player "..k.." changing to joystick.")
                local joystickfree = getUnusedJoystick()
                if joystickfree > 0 then
                  defaultkeys[i].used = false
                  players[k].keys = nil
                  players[k].joystick = defaultjoys[joystickfree].joystick
                  players[k].buttonid = 0
                  defaultjoys[joystickfree].used = true
                  table.insert(mustSpecifyJoyButton, {defaultjoys[joystickfree].joystick:getID(), k})
                  break
                end
              end
            end
          else
            for i in pairs(defaultjoys) do
              if defaultjoys[i].joystick:getID() == players[k].joystick:getID() then
                local keyboardfree = getUnusedKeymap()
                if keyboardfree > 0 then
                  defaultjoys[i].used = false
                  players[k].joystick = nil
                  players[k].buttonid = nil
                  players[k].keys = defaultkeys[keyboardfree].keys
                  defaultkeys[keyboardfree].used = true
                  break
                end
              end
            end
          end
        end
      end
      for k=1, #players do
        if players[k].keys then print("Player "..k.." using keyboard.")
        elseif players[k].joystick then print("Player "..k.." using controller.")
        else print("Player "..k.." is confused.") end
      end
    end
  end
  return gameSetup
end

function gameSetup.keypressed(k, sc, ir)
  if #mustSpecifyJoyButton == 0 then
    if k == "return" then
      return teamSelect
    else
      for i, j in ipairs(players) do
        if j.keys then
          if k == j.keys.left then
            modifyFlipType("left",j)
          elseif k == j.keys.right then
            modifyFlipType("right",j)
          end
        end
      end
    end
  return gameSetup
  end
end

function modifyFlipType(k, j) -- direction, player
  if k == "left" then
    if j.flipMode == "row" then j.flipMode = "area"
    elseif j.flipMode == "column" then j.flipMode = "row"
    else j.flipMode = "column" end
  elseif k == "right" then
    if j.flipMode == "row" then j.flipMode = "column"
    elseif j.flipMode == "column" then j.flipMode = "area"
    else j.flipMode = "row" end
  end
end

function gameSetup.joystickadded(j)
  console.log("Joystick added!")
  table.insert(defaultjoys, {joystick = j, used = false})
  return gameSetup
end

function gameSetup.joystickremoved(j)
  console.log("Joystick removed...")
  local eyedee = j:getID()
  local removedindex = 0
  for i in pairs(defaultjoys) do
    if defaultjoys[i].joystick:getID() == eyedee then
      removedindex = i
      break
    end
  end
  table.remove(defaultjoys, removedindex)
  return gameSetup
end

function gameSetup.joystickpressed(j, b)
  if #mustSpecifyJoyButton > 0 then
    local toremove = {}
    for i in pairs(mustSpecifyJoyButton) do
      if j:getID() == mustSpecifyJoyButton[i][1] then
        -- Set that button
        players[mustSpecifyJoyButton[i][2]].buttonid = b
        table.insert(toremove, i)
      end
    end
    for i in pairs(toremove) do
      table.remove(mustSpecifyJoyButton, toremove[i])
    end
  end
  return gameSetup
end
