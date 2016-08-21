requires = {"title", "game", "boards", "game-setup", "players", "tween", "flags", "timer", "score", "gameover", "team-select"}

for _,j in pairs(requires) do
  require(j)
end

local gamestate
local lastGamestate

debug = false

reallyLargeFont = love.graphics.newFont(54)
largeFont = love.graphics.newFont(36)
largeishFont = love.graphics.newFont(25)
mediumFont = love.graphics.newFont(18)
smallFont = love.graphics.newFont(12)

bg = love.audio.newSource("sound/hill2.wav", "stream")
bgtoloop = love.audio.newSource("sound/hill2clipped.wav", "stream")
applause = love.audio.newSource("sound/applause.wav", "static")

mainCharacter = love.graphics.newImage("art/mainchar.png")
floatingNumbers = {}
for i=1,8 do
  table.insert(floatingNumbers, love.graphics.newImage("art/"..i..".png"))
end
gobutton = love.graphics.newImage("art/go.png")

local flickFlags = {}

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

function love.mousemoved(x, y, dx, dy, istouch)
  if gamestate.mousemoved then
    gamestate = gamestate.mousemoved(x, y, dx, dy, istouch)
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

function checkFlick(joystick)
  if flickFlags[joystick:getID()] then
    local axisx = joystick:getAxis(1)
    if math.abs(axisx) < math.abs(joystick:getAxis(3)) then
      axisx = joystick:getAxis(3)
    end
    if axisx > 0.5 then
      -- Right!
      flickFlags[joystick:getID()].left = false
      if not flickFlags[joystick:getID()].right then
        flickFlags[joystick:getID()].right = true
        return "right"
      end
    elseif axisx < -0.5 then
      -- Left!
      flickFlags[joystick:getID()].right = false
      if not flickFlags[joystick:getID()].left then
        flickFlags[joystick:getID()].left = true
        return "left"
      end
    else
      flickFlags[joystick:getID()].right = false
      flickFlags[joystick:getID()].left = false
    end
  else
    flickFlags[joystick:getID()] = {left=false, right=false}
  end
  return false
end

function love.quit()
  local toQuit
  if gamestate.quit then
    gamestate, toQuit = gamestate.quit()
  end
  return toQuit
end
