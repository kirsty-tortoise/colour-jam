gameSetup = {code="game-setup"}

players = {}
local keysToSet = {"up", "down", "left", "right", "flip"}
local keySetting, playerSetting, keysTaken
local errorMsg
local defaultkeys = {{up="up", down="down", left="left", right="right", flip="space"}, {up="w", down="s", left="a", right="d", flip="e"}, {up="t", down="g", left="f", right="h", flip="y"}, {up="i", down="k", left="j", right="l", flip="o"}}
local defaultkeysindex = 2
local addplayer = love.graphics.newImage("art/addplayer.png")
local gobutton = love.graphics.newImage("art/go.png")

function gameSetup.setup()
  playerSetting, keySetting = 1,1
  players = {}
  table.insert(players, {keys = defaultkeys[1]})
  keysTaken = {}
  errorMsg = nil
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
    elseif j.controller then
      love.graphics.printf("Using controller", x + 15, y + 50, 120, "center") -- TODO: add controller name / number
    else
      love.graphics.printf("Is AI", x + 15, y + 75, 120, "center")
    end
  end
  love.graphics.setColor(255,255,255)
  if #players < 8 then
    -- Render "+" button
    local x, y = rectanglePosition(#players + 1)
    love.graphics.draw(addplayer, x - 2, y + 10, 0, 0.4)
  end
  if #players > 1 then
    love.graphics.draw(gobutton, 720, 540, 0, 0.3)
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
      if defaultkeysindex > #defaultkeys then
        table.insert(players, {})
      else
        table.insert(players, {keys=defaultkeys[defaultkeysindex]})
        defaultkeysindex = defaultkeysindex + 1
      end
    elseif mx > 720 and mx < 720 + (gobutton:getHeight() * 0.3) and my > 540 and my < 540 + (gobutton:getWidth() * 0.3) then
      return game
    end
  end
  return gameSetup
end

-- function gameSetup.keypressed(key, scancode, isrepeat)
--   if key == "return" and keySetting == 1 then
--     return game
--   else
--     if key == "return" then
--       errorMsg = "You can't choose the enter key, choose another"
--     elseif keysTaken[key] then
--       errorMsg = "That key has already been chosen, choose another key"
--     else
--       errorMsg = nil

--       if keySetting == 1 then
--         table.insert(players, {keys = {}})
--       end

--       players[playerSetting].keys[keysToSet[keySetting]] = key -- save this

--       keysTaken[key] = true

--       -- change the current key and player being set
--       keySetting = keySetting + 1
--       if keySetting > #keysToSet then
--         playerSetting = playerSetting + 1
--         keySetting = 1
--       end
--     end
--   end
--   return gameSetup
-- end

-- function gameSetup.draw()
--   local data = "Player "..playerSetting..", press the key or move joystick you want to use for " .. keysToSet[keySetting] .. "."
--   if keySetting == 1 then
--     data = data .. " If there are no more players, press enter to continue."
--   end

--   love.graphics.setFont(largeFont)
--   love.graphics.printf(data, 50, 100, 750, "center")

--   if errorMsg then
--     love.graphics.setFont(mediumFont)
--     love.graphics.printf(errorMsg, 50, 500, 750, "center")
--   end
--   return gameSetup
-- end
