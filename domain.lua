world = require "world"
config = require "config" 
resources = require "resources/resources" 
lm = require "locmath"
enemy_api = require "enemy"

local domain_api = {}
local domain = {}
local domain_rad = 50
local domain_diam = domain_rad * 2

local function domain_location(x, y)
  local mx, my = world.grid_location(x, y)
  return math.floor(mx / domain_diam),
    math.floor(my / domain_diam)
end

local function new_domain(i, j)
  local dm = 
  {
    x = i, y = j,
    simple_enemies_count = math.random(10) - 1,
    simple_enemies = {}
  }
  function dm:radius()
    return domain_rad * world.cell_width
  end
  
  function dm:rand_pnt()
    return self.x * domain_diam * world.cell_width + math.random(domain_diam * world.cell_width),
        self.y * domain_diam * world.cell_height + math.random(domain_diam * world.cell_height)
  end

  function dm:center()
    return (self.x * domain_diam + domain_rad) * world.cell_width,
      (self.y * domain_diam + domain_rad) * world.cell_height
  end
  return dm
end

local function check_domain(i, j)
    if domain[i] == nil then
      domain[i] = {}
    end
    if domain[i][j] == nil then
      domain[i][j] = new_domain(i, j)
    end
end

local function domain_map_curr_rect(f, p)
  local left, top = domain_location(world.center.x, world.center.y)
  local right = left + 1
  local bottom = top + 1
  left = left - 1
  top = top - 1

  for i = left,right do
    for j= top,bottom do
      check_domain(i, j)
      f(p, domain[i][j])
    end
  end
end

local function domain_updater(dt, cell)
  tocreate = cell.simple_enemies_count - #cell.simple_enemies
  if tocreate > 0 then
    for i = 1, tocreate do
      local bot = enemy_api.new(cell)
      table.insert(cell.simple_enemies, bot)  
    end
  end
  for j = 1, #cell.simple_enemies do
    local en = cell.simple_enemies[j]
    world.rm_fg(en)
    en:update(cell, dt)
    world.put_fg(en)
  end
end

function domain_api.update(par)
  domain_map_curr_rect(domain_updater, par.dt)
end

return domain_api