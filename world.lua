config = require "config" 
lm = require "locmath"
require "resources/resources" 

local world = 
{
  camera = {x = 0, y = 0, angle = 0.},
  grid = {},
  -- constants
  cell_width = 200,
  cell_height = 200,
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
      for lev = 1, DRAW_LAYERS_COUNT do
        if tfind(grid_layers, lev) then
          world.grid[i][j][lev] = {}
        end
      end
    end
end

function world.get_cell(x, y)
  local gx, gy = world.grid_location(x, y)
  check_cell(gx, gy)
  return world.grid[gx][gy]
end

function world.screen_rect()
  local rad = math.max(WINDOW_WIDTH, WINDOW_HEIGHT) / 2
  return world.camera.x - rad, world.camera.x + rad, 
    world.camera.y - rad, world.camera.y + rad
end

function world.screen_grid_rect()
  local rad = math.ceil(math.max(world.grid_width, world.grid_height) / 2)
  local x, y = world.grid_location(world.camera.x, world.camera.y)
  return x - rad, x + rad, y - rad, y + rad
end

function world.grid_map_curr_rect(f, level, data)
  local left, right, top, bottom = world.screen_grid_rect()
  for i = left, right do
    for j= top, bottom do
      check_cell(i, j)
      f(data, world.grid[i][j][level], i, j, level)
    end
  end
end

function world.put(obj)
  local gx, gy = world.grid_location(obj.x, obj.y)
  check_cell(gx, gy)
  local cell = world.grid[gx][gy][obj.level]
  if cell == nil then
    cell = {}
  end
  table.insert(cell, obj)
end

function world.rm(obj)
  local gx, gy = world.grid_location(obj.x, obj.y)
  if world.grid[gx] == nil or world.grid[gx][gy] == nil or world.grid[gx][gy][obj.level] == nil then
    return
  end
  local cell = world.grid[gx][gy][obj.level]
  for i = 1, #cell do
    if cell[i] == obj then
     table.remove(cell, i)
     break
    end
  end
end

return world