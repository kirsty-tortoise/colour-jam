requires = {"title", "game", "boards", "game-setup", "players", "tween", "flags", "footer", "gameover"}

for _,j in pairs(requires) do
  require(j)
end

local gamestate
local lastGamestate

largeFont = love.graphics.newFont(36)
mediumFont = love.graphics.newFont(18)
smallFont = love.graphics.newFont(12)

mainCharacter = love.graphics.newImage("art/mainchar.png")

function love.load()
  gamestate = title
  lastGamestate = gamestate.code
  if gamestate.setup then gamestate.setup() end
  math.randomseed(os.time())
  print(love.joystick.getJoystickCount())
end

function love.draw()
  if gamestate.draw then
    gamestate = gamestate.draw()
  end
end

function love.update(dt)
  if gamestate.code ~= lastGamestate then
    if gamestate.setup then gamestate.setup() end
    lastGamestate = gamestate.code
  end
  if gamestate.update then
    gamestate = gamestate.update(dt)
    if gamestate.code ~= lastGamestate then
      if gamestate.setup then gamestate.setup() end
      lastGamestate = gamestate.code
    end
  end
end

function love.mousepressed(x, y, button, istouch)
  if gamestate.mousepressed then
    gamestate = gamestate.mousepressed(x, y, button, istouch)
  end
end

function love.keypressed( key, scancode, isrepeat )
  if gamestate.keypressed then
    gamestate = gamestate.keypressed(key, scancode, isrepeat)
  end
end

function love.keyreleased(key)
  if gamestate.keyreleased then
    gamestate = gamestate.keyreleased(key)
  end
end

function love.joystickadded(j)
  if gamestate.joystickadded then
    gamestate = gamestate.joystickadded(j)
  end
end

function love.joystickremoved(j)
  if gamestate.joystickremoved then
    gamestate = gamestate.joystickremoved(j)
  end
end

function love.joystickpressed(j, b)
  if gamestate.joystickpressed then
    gamestate = gamestate.joystickpressed(j, b)
  end
end

function love.joystickreleased(j, b)
  if gamestate.joystickreleased then
    gamestate = gamestate.joystickreleased(j, b)
  end
end

function love.quit()
  local toQuit
  if gamestate.quit then
    gamestate, toQuit = gamestate.quit()
  end
  return toQuit
end
