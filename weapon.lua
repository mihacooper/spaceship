local weapon = {}
function weapon.shoot()
  local shoot = { x = 0, y = 0, image = bullet,
    speed = 2000, angle = 0., objtype = OBJ_TYPE_STUFF, level = DRAW_LAYER_BULLET}
  
  function shoot:update(domain, dt)
    self.x = self.x + math.cos(self.angle) * self.speed * dt
    self.y = self.y + math.sin(self.angle) * self.speed * dt
    if self.x < world.camera.x or self.x > world.camera.x + WINDOW_WIDTH or 
        self.y < world.camera.y or self.y > world.camera.y + WINDOW_HEIGHT then
      return false
    end
    return true
  end
  
  return shoot
end
return weapon