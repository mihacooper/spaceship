require "utils"
world = require "world" 
resources = require "resources/resources" 
weapon = require "weapon"
domainer = require "domain"

local MAX_SPEED = 1200
local SPEED_STEP = 15
local ANGLE_SPEED = math.pi 

local hero = 
{
	x = 0, y = 0, angle = 0., image = nil,
  speed = 0., objtype = OBJ_TYPE_HERO,
  shoot_timer = new_timer(0.1)
}

local hero_events = {}

function hero_events.load()
  hero.image = ship
end

function hero_events.update(par)
  if par.msg == "GoUp" then
		hero.speed = hero.speed + SPEED_STEP
    if hero.speed > MAX_SPEED then
      hero.speed = MAX_SPEED
    end
  elseif par.msg == "GoDown" then
		hero.speed = hero.speed - SPEED_STEP
    if hero.speed < 0 then
      hero.speed = 0
    end
  elseif par.msg == "RotateLeft" then
		hero.angle = hero.angle - ANGLE_SPEED * par.dt
  elseif par.msg == "RotateRight" then
		hero.angle = hero.angle + ANGLE_SPEED * par.dt
  elseif par.msg == "Shoot" then
    if hero.shoot_timer:age(par.dt) then
      local bull = weapon.shoot()
      bull.x = hero.x
      bull.y = hero.y
      bull.angle = hero.angle
      domainer.get_domain():put(bull)
    end
  elseif par.msg == nil then
    world.rm_fg(hero)
    hero.x = hero.x + math.cos(hero.angle) * hero.speed * par.dt
    hero.y = hero.y + math.sin(hero.angle) * hero.speed * par.dt
    world.camera.x = hero.x - WINDOW_WIDTH / 2
    world.camera.y = hero.y - WINDOW_HEIGHT / 2
    world.center.x = hero.x
    world.center.y = hero.y
    world.put_fg(hero)
  end
end

return hero_events