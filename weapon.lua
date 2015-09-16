world = require "world"
object = require "object"

local weapon = {}
function weapon.shoot()
  local shoot = object.new()
  shoot.image = IMAGE_BULLET
  shoot.speed = 3000
  shoot.type = OBJ_TYPE_STUFF
  shoot.level = DRAW_LAYER_BULLET
  shoot.target_type = 0
  shoot.damage = 0
  
  function shoot:update(domain, dt)
    --tcombinevec()
    local cell = world.get_cell(self.x, self.y)
    local allobj = tcombinevecs(cell)
    for _, v in pairs(allobj) do
      if v.type == shoot.target_type then
        v.health = v.health - self.damage
        return false
      end
    end
    
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