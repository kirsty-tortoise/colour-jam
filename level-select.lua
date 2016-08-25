levelSelect = {code = "level-select"}

local levelPanels = {}
levelSelected = "random"
local screenShown = 1
local totalScreens
local maxPanels = 4

function levelSelect.setup()
  levelPanels = {}
  levelSelected = "random"
  screenShown = 1
  totalScreens = 1
  local panelNum = 1
  local x, y

  -- Add random grid level
  x, y = getPanelCoordinates(panelNum)
  table.insert(levelPanels, {code = "random", name = "Random Level", x = x, y = y, width = 300, height = 225, screen = totalScreens, colour = {185, 55, 237}, selected = true})
  panelNum = panelNum + 1

  -- Add default levels
  for i,j in ipairs(defaultLevels) do
    x, y = getPanelCoordinates(panelNum)
    table.insert(levelPanels, {code = "default"..i, name = j.name, x = x, y = y, width = 300, height = 225, screen = totalScreens, colour = {102, 153, 255}, selected = false})
    if panelNum == maxPanels then
      totalScreens = totalScreens + 1
      panelNum = 1
    else
      panelNum = panelNum + 1
    end
  end

  -- Add your levels
  for i,j in ipairs(yourLevels) do
    x, y = getPanelCoordinates(panelNum)
    table.insert(levelPanels, {code = "your-level"..i, name = j.name, x = x, y = y, width = 300, height = 225, screen = totalScreens,  colour = {245, 88, 242}, selected = false})
    if panelNum == maxPanels then
      totalScreens = totalScreens + 1
      panelNum = 1
    else
      panelNum = panelNum + 1
    end
  end

  -- Add option of making a new level
  x, y = getPanelCoordinates(panelNum)
  table.insert(levelPanels, {code = "new-level", name = "Make a new level!", x = x, y = y, width = 300, height = 225, screen = totalScreens,  colour = {59, 232, 255}, selected = false})

  -- load screenshots
  local screenshots = {}
  for _, file in ipairs(love.filesystem.getDirectoryItems("level-images")) do
    screenshots[file] = love.graphics.newImage("level-images/"..file)
  end
  for _, file in ipairs(love.filesystem.getDirectoryItems("default-images")) do
    screenshots[file] = love.graphics.newImage("default-images/"..file)
  end
  for _, panel in ipairs(levelPanels) do
    panel.image = screenshots[panel.name .. ".png"]
  end

  return levelSelect
end

function levelSelect.draw()
  for _,panel in pairs(levelPanels) do
    if panel.screen == screenShown then
      drawPanel(panel)
    end
  end
  return levelSelect
end

function levelSelect.mousepressed(x, y, button, istouch)
  for _,j in ipairs(levelPanels) do
    if j.screen == screenShown and isOverButton(j, x, y) then
      levelSelected = j.code
      -- Deselect everything else
      for _,k in ipairs(levelPanels) do
        k.selected = false
      end
      j.selected = true
      break
    end
  end
  return levelSelect
end

function levelSelect.keypressed(key, scancode, isrepeat)
  if key == "return" then
    if levelSelected == "new-level" then
      levelSelected = "your-level" .. (#yourLevels+1)
      return levelCreator
    else
      return game
    end
    return game
  elseif key == "left" then
    if screenShown == 1 then
      screenShown = totalScreens
    else
      screenShown = screenShown - 1
    end
  elseif key == "right" then
    if screenShown == totalScreens then
      screenShown = 1
    else
      screenShown = screenShown + 1
    end
  end
  return levelSelect
end

function getPanelCoordinates(panelNum)
  if panelNum == 1 then
    return 200/3, 50
  elseif panelNum == 2 then
    return 400/3 + 300, 50
  elseif panelNum == 3 then
    return 200/3, 325
  elseif panelNum == 4 then
    return 400/3 + 300, 325
  end
end

function drawPanel(panel)
  if not panel.image then
    love.graphics.setColor(panel.colour or {255, 255, 255})
    love.graphics.rectangle("fill", panel.x, panel.y, panel.width, panel.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(largeishFont)
    love.graphics.printf(panel.name or panel.code, panel.x, panel.y + 0.4 * panel.height, panel.width, "center")
  else
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(panel.image, panel.x, panel.y, 0, panel.width / panel.image:getWidth())
    love.graphics.setColor(panel.colour or {255, 255, 255})
    love.graphics.rectangle("fill", panel.x, panel.y + 0.8 * panel.height, panel.width, 0.2 * panel.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(largeishFont)
    love.graphics.printf(panel.name, panel.x, panel.y + 0.84 * panel.height, panel.width, "center")
  end
  if panel.selected then
    love.graphics.setLineWidth(5)
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", panel.x, panel.y, panel.width, panel.height)
    love.graphics.setLineWidth(1)
  end
end
