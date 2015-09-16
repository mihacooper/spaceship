world = require "world"
config = require "config" 
resources = require "resources/resources" 
lm = require "locmath"
enemy_api = require "enemy"
log = require "loger"

local domain_api = {}
local domain = {}
local domain_rad = 30
local domain_diam = domain_rad * 2

local function domain_location(x, y)
  local mx, my = world.grid_location(x, y)
  return math.floor(mx / domain_diam),
    math.floor(my / domain_diam)
end

function domain_api.radius()
  return domain_rad * world.cell_width
end

function domain_api.diameter()
  return domain_diam * world.cell_width
end

local function new_domain(i, j)
  local dm = 
  {
    x = i, y = j,
    objects = {}
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
  
  function dm:put(obj)
      table.insert(self.objects, obj)  
  end

  function dm:rm(obj)
    local num = nil
    for j = 1, #self.objects do
      if self.objects[j] == obj then
        world.rm_fg(obj)
        num = j
        break
      end
    end
    if num ~= nil then
      table.remove(self.objects, num)
    end
  end
  
  return dm
end

local function check_domain(i, j)
    if domain[i] == nil then
      domain[i] = {}
    end
    if domain[i][j] == nil then
      domain[i][j] = new_domain(i, j)
      for k = 1, #events.domain_creator do
        ev = events.domain_creator[k]
        ev[2].domain = domain[i][j]
        ev[1](ev[2])
      end
      log.send("Domain creation: " .. tostring(i) ..", " .. tostring(j), LOG_BASE)
    end
end

function domain_api.domain_map_curr_rect(f, p, rad)
  local left, top = domain_location(world.camera.x, world.camera.y)
  local radius = rad or 2
  local right = left + radius
  local bottom = top + radius
  left = left - radius
  top = top - radius

  for i = left,right do
    for j= top,bottom do
      check_domain(i, j)
      f(p, domain[i][j])
    end
  end
end

local function domain_updater(dt, cell)
  local i, count = 1, #cell.objects
  while i <= count do
    local en = cell.objects[i]
    world.rm(en)
    if not en:update(cell, dt) then
      table.remove(cell.objects, i)
      count = count - 1
    else
      i = i + 1
      world.put(en)
    end
  end
end

function domain_api.update(par)
  domain_api.domain_map_curr_rect(domain_updater, par.dt)
end

function domain_api.get_domain(x, y)
  local dx, dy = domain_location(x or world.camera.x, y or world.camera.y)
  check_domain(dx, dy)
  return domain[dx][dy] 
end

function domain_api.get_domain_neigh(x, y, cx, cy)
  local dx, dy = domain_location(world.camera.x, world.camera.y)
  check_domain(dx + cx, dy + cy)
  return domain[dx + cx][dy + cy] 
end

return domain_api