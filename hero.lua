world = require "world" 
resources = require "resources/resources" 

local MAX_SPEED = 800
local SPEED_STEP = 10
local ANGLE_SPEED = math.pi / 2

local hero = 
{
	x = 0, y = 0, angle = 0., image = nil,
  speed = 0.,
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