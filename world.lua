config = require "config" 
resources = require "resources/resources" 
lm = require "locmath"

local world = 
{
  camera = {x = 0, y = 0},
  center = {x = 0, y = 0},
  grid = {},
  -- constants
  cell_width = 50,
  cell_height = 50,
  grid_width = nil,
  grid_height = nil,
  scale = 1.
}

world.grid_width = math.floor((WINDOW_WIDTH + world.cell_width - 1) / world.cell_width)
world.grid_height = math.floor((WINDOW_HEIGHT + world.cell_height - 1) / world.cell_height)

function world.grid_location(x, y)
  return math.floor(x / world.cell_width),
    math.floor(y / world.cell_height)
end

local function check_cell(i, j)
    if world.grid[i] == nil then
      world.grid[i] = {}
    end
    if world.grid[i][j] == nil then
      world.grid[i][j] = {}
      for lev = 1, DRAW_LAYERS do
        world.grid[i][j][lev] = {}
      end
    end
end

function world.grid_map_curr_rect(f, level, data)
  local left, top = world.grid_location(world.camera.x, world.camera.y)
  local right = left + world.grid_width 
  local bottom = top + world.grid_height

  for i = left,right do
    for j= top,bottom do
      check_cell(i, j)
      f(data, world.grid[i][j][level], i, j, level)
    end
  end
end

local function newRandomStar(cx, cy, w, h)
  local t = math.random(10)
  local sx = cx + math.random(w) - 1
  local sy = cy + math.random(h) - 1
  if t > 3 then
    return nil
  elseif t == 1 then
    return {image = small_star, x = sx, y = sy, angle = 0}
  elseif t == 2 then
    return {image = big_star, x = sx, y = sy, angle = 0}
  elseif t == 3 then
    return {image = tiny_star, x = sx, y = sy, angle = 0}
  end
end

function world.update(par)
  world.grid_map_curr_rect(
    function(_, cell, left, top, _)
      print(#cell)
      if #cell == 0 then
        local star = newRandomStar(left * world.cell_width, 
            top * world.cell_height, world.cell_width, world.cell_height)
        if star ~= nil then
          world.put(star, DRAW_LAYER_BG)
        end
      end
    end, DRAW_LAYER_BG, {}
    )
end

function world.put(obj, level)
  local gx, gy = world.grid_location(obj.x, obj.y)
  check_cell(gx, gy)
  local cell = world.grid[gx][gy][level]
  if cell == nil then
    cell = {}
  end
  table.insert(cell, obj)
end

function world.rm(obj, level)
  local gx, gy = world.grid_location(obj.x, obj.y)
  if world.grid[gx] == nil or world.grid[gx][gy] == nil or world.grid[gx][gy][level] == nil then
    return
  end
  local cell = world.grid[gx][gy][level]
  for i = 1, #cell do
    if cell[i] == obj then
     table.remove(cell, i)
     break
    end
  end
end

return world