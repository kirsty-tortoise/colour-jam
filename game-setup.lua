gameSetup = {code="game-setup"}

local players = {}
local keysToSet = {"up", "down", "left", "right", "flip"}
local keySetting, playerSetting, keysTaken
local errorMsg

function gameSetup.setup()
  return gameSetup
  playerSetting, keySetting = 1,1
  players = {}
  keysTaken = {}
  errorMsg = nil
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
      errorMsg = ""

      if keySetting == 1 then
        players:insert({})
      end

      players[playerSetting][keysToSet[keySetting]] = key -- save this

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
