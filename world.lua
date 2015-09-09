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
  return math.floor((x + world.cell_width - 1) / world.cell_width),
    math.floor((y + world.cell_height - 1) / world.cell_height)
end

local function check_cell(i, j)
    if world.grid[i] == nil then
      world.grid[i] = {}
    end
    if world.grid[i][j] == nil then
      world.grid[i][j] = {}
    end
end

function world.grid_map_curr_rect(f, p)
  local left, top = world.grid_location(world.camera.x, world.camera.y)
  local right = left + world.grid_width 
  local bottom = top + world.grid_height

  for i = left,right do
    for j= top,bottom do
      check_cell(i, j)
      f(p, world.grid[i][j], i, j)
    end
  end
end

local function newRandomStar(cx, cy, w, h)
  local t = math.random(10)
  local sx = cx + math.random(w) - 1
  local sy = cy + math.random(h) - 1
  if t > 3 then
    return {image = nil}
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
    function(_, cell, left, top)
      if cell.bg == nil then
            cell.bg = {newRandomStar(left * world.cell_width, 
              top * world.cell_height, world.cell_width, world.cell_height)}
          end
    end, {}
    )
end

function world.put_fg(obj)
  local gx, gy = world.grid_location(obj.x, obj.y)
  check_cell(gx, gy)
  local cell = world.grid[gx][gy]
  local num = 1
  if cell.fg ~= nil then
    num = #cell.fg + 1
  else
    cell.fg = {}
  end
  cell.fg[num] = obj
end

function world.rm_fg(obj)
  local gx, gy = world.grid_location(obj.x, obj.y)
  if world.grid[gx] == nil or world.grid[gx][gy] == nil then
    return
  end
  local cell = world.grid[gx][gy]
  if cell == nil or cell.fg == nil then
    return
  end
  for i = 1, #cell.fg do
    if cell.fg[i] == obj then
     table.remove(cell.fg, i)
     break
    end
  end
end

return world