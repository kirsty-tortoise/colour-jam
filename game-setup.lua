gameSetup = {code="game-setup"}

local players = {}
local keysToSet = {"up", "down", "left", "right", "flip"}
local keySetting, playerSetting, keysTaken
local errorMsg

function gameSetup.setup()
  playerSetting, keySetting = 1,1
  players = {}
  keysTaken = {}
  errorMsg = nil
  return gameSetup
end

function gameSetup.keypressed(key, scancode, isrepeat)
  if key == "return" and keySetting == 1 then
    return game
  else
    if key == "return" then
      errorMsg = "You can't choose the enter key, choose another"
    elseif keysTaken[key] then
      errorMsg = "That key has already been chosen, choose another key"
    else
      errorMsg = nil

      if keySetting == 1 then
        table.insert(players, {})
      end

      players[playerSetting][keysToSet[keySetting]] = key -- save this

      keysTaken[key] = true

      -- change the current key and player being set
      keySetting = keySetting + 1
      if keySetting > #keysToSet then
        playerSetting = playerSetting + 1
        keySetting = 1
      end
    end
  end
  return gameSetup
end

function gameSetup.draw()
  local data = "Player "..playerSetting..", press the key or move joystick you want to use for " .. keysToSet[keySetting] .. "."
  if keySetting == 1 then
    data = data .. " If there are no more players, press enter to continue."
  end

  love.graphics.setFont(largeFont)
  love.graphics.printf(data, 50, 100, 750, "center")

  if errorMsg then
    love.graphics.setFont(mediumFont)
    love.graphics.printf(errorMsg, 50, 500, 750, "center")
  end
  return gameSetup
end
