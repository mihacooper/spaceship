world = require "world"

local background_api = {}
  
local bgcell_width = world.cell_width * 4
local bgcell_height = world.cell_height * 4
 
local bg_grid = {}
local function newRandomStar(cx, cy, w, h)
  local t = math.random(3)
  local sx = cx + math.random(w) - 1
  local sy = cy + math.random(h) - 1
  if t == 1 then
    return {image = IMAGE_SMALLSTAR, x = sx, y = sy, angle = 0, level = DRAW_LAYER_BG}
  elseif t == 2 then
    return {image = IMAGE_BIGSTAR, x = sx, y = sy, angle = 0, level = DRAW_LAYER_BG}
  elseif t == 3 then
    return {image = IMAGE_TINYSTAR, x = sx, y = sy, angle = 0, level = DRAW_LAYER_BG}
  end
end

local function check_cell(i, j)
    if bg_grid[i] == nil then
      bg_grid[i] = {}
    end
    if bg_grid[i][j] == nil then
      bg_grid[i][j] = {}
      local num = math.random(10) + 20
      for s = 1, num do
        bg_grid[i][j][s] = newRandomStar(i * bgcell_width, j * bgcell_height, bgcell_width, bgcell_height)
      end
    end
    return bg_grid[i][j]
end

function background_api.update(par)
end

function background_api.predraw(lev)
  if lev == DRAW_LAYER_BG then
    local left, right, top, bottom = world.screen_grid_rect()
    left = math.floor(left / 4) 
    right = math.ceil(right / 4) 
    top = math.floor(top / 4)
    bottom = math.ceil(bottom / 4)
    for i = left, right do
      for j= top, bottom do
        local cell = check_cell(i, j)
        for s = 1, #cell do
          local obj = cell[s]
          local offx = obj.image:getWidth() / 2
          local offy = obj.image:getHeight() / 2
          love.graphics.draw(obj.image, 
            obj.x  - world.camera.x + WINDOW_WIDTH / 2,
            obj.y  - world.camera.y + WINDOW_HEIGHT / 2,
            0, 1, 1, offx, offy)
        end
      end
    end
  end
end

return background_api