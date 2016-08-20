requires = {"menu", "game", "boards"}

for _,j in pairs(requires) do
  require(j)
end

local gamestate
local lastGamestate

function love.load()
  gamestate = game
  lastGamestate = gamestate.code
  math.randomseed(os.time())
end

function love.draw()
  if gamestate.draw then
    gamestate = gamestate.draw()
  end
end

function love.update(dt)
  if gamestate.update then
    gamestate = gamestate.update(dt)
    if gamestate.code ~= lastGamestate then
      gamestate.setup()
      lastGamestate = gamestate.code
    end
  end
end

function love.mousepressed(x, y, button, istouch)
  if gamestate.mousepressed then
    gamestate = gamestate.mousepressed(x, y, button, istouch)
  end
end

function love.quit()
  local toQuit
  if gamestate.quit then
    gamestate, toQuit = gamestate.quit()
  end
  return toQuit
end
