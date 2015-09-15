world = require "world"

local weapon = {}
function weapon.shoot()
  local shoot = { x = 0, y = 0, image = IMAGE_BULLET,
    speed = 3000, angle = 0., objtype = OBJ_TYPE_STUFF, level = DRAW_LAYER_BULLET}
  
  function shoot:update(domain, dt)
    self.x = self.x + math.cos(self.angle) * self.speed * dt
    self.y = self.y + math.sin(self.angle) * self.speed * dt
    local left, right, top, bottom = world.screen_rect()
    if self.x < left or self.x > right or 
        self.y < top or self.y > bottom then
      return false
    end
    return true
  end
  
  return shoot
end
return weapon