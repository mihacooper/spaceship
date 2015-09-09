bot_api = require "bot"
world = require "world"
lm = require "locmath"

local enemy_api = {}
bot = bot_api.new()

local ATTACK_RADIUS = function(domain_rad) return domain_rad / 2 end 

function enemy_api.new(domain)
  local enemy = bot_api.new()
  enemy.x, enemy.y = domain:center()
  enemy.image = image_enemy
  enemy.angle = math.random() * math.pi * lm.rand_sign()
  enemy.max_speed = 300
  enemy.speed = enemy.max_speed
  enemy.max_angsp = math.pi / (math.random() * 2 + 1)
  enemy:move_to(domain:rand_pnt())
  enemy.to_center = false
  enemy.attacking = false
  enemy.retreating = false

  function enemy:can_shoot()
    local mydir = lm.vecmk(self)
    local enemdir = lm.vecsub(world.center, self)
    if math.abs(lm.vecscal(mydir, enemdir) / (lm.vecmod(enemdir) * lm.vecmod(mydir)) - 1) < 0.15 then
      return true
    end
    return false
  end

  function enemy:update(domain, dt)
    local waytotarg = lm.vecmod(lm.vecsub(world.center, self))
    if self:can_shoot() then
      --
    end
    if self.attacking then
      if self.retreating then
        if bot.update(self, dt) then
          self.retreating = false
        end
      else
        if waytotarg > domain:radius() then
          self.attacking = false
          self.retreating = true
          self.speed = 300
          self.flexway = 1.
          self.agresway = false
        elseif waytotarg < 150 then
          local ang = self.angle + math.random(math.pi / 2) - math.pi / 4
          local subrad = 300
          local nx, ny = subrad * math.cos(ang), subrad * math.sin(ang)
          self.retreating = true
          self:move_to(world.center.x + nx, world.center.y + ny)
        else
          self:move_to(world.center.x, world.center.y)
        end
        bot.update(self, dt)
      end
    else
      if waytotarg < domain:radius() / 2 then
          self.attacking = true
          self.speed = 500
          self.flexway = 0.25
          self.agresway = true
          self:move_to(world.center.x, world.center.y)
      elseif bot.update(self, dt) then
        if self.to_center then
          self:move_to(domain:rand_pnt())
          self.to_center = false
        else
          self:move_to(domain:center())
          self.to_center = true
        end
      end
    end
  end
  return enemy
end

return enemy_api