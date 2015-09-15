require "utils"
world = require "world" 
weapon = require "weapon"
domainer = require "domain"
require "resources/resources" 

local MAX_SPEED = 1000.
local SPEED_STEP = 10.
local ANGLE_SPEED = math.pi / 1.5 

local hero = 
{
	x = 0, y = 0, angle = -math.pi / 2., image = IMAGE_SHIP,
  speed = 0., objtype = OBJ_TYPE_HERO,
  shoot_timer = new_timer(0.1),
  level = DRAW_LAYER_USER
}

local hero_events = {}

function hero_events.load()
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
    world.rm(hero)
    hero.x = hero.x + math.cos(hero.angle) * hero.speed * par.dt
    hero.y = hero.y + math.sin(hero.angle) * hero.speed * par.dt
    world.camera.x = hero.x
    world.camera.y = hero.y
    world.camera.angle = -(hero.angle + math.pi / 2.)
    world.put(hero)
  end
end

return hero_events