bot_api = require "bot"
world = require "world"
lm = require "locmath"
weapon = require "weapon"
require "utils"

local enemy_api = {}
bot = bot_api.new()

local ATTACK_RADIUS = function(domain_rad) return domain_rad / 2 end 

local ENEMY_USUAL_SPEED = 200
local ENEMY_ATACK_SPEED = 350
local ENEMY_USUAL_FLEX = 0.8
local ENEMY_ATACK_FLEX = 0.28

function enemy_api.new(domain)
  local enemy = bot_api.new()
  enemy.x, enemy.y = domain:center()
  enemy.image = IMAGE_ENEMY
  enemy.angle = math.random() * math.pi * lm.rand_sign()
  enemy.max_speed = ENEMY_USUAL_SPEED
  enemy.speed = enemy.max_speed
  enemy.max_angsp = math.pi / (math.random() * 2 + 1)
  enemy:move_to(domain:rand_pnt())
  enemy.to_center = false
  enemy.attacking = false
  enemy.retreating = false
  enemy.shoot_timer = new_timer(0.1)
  enemy.level = DRAW_LAYER_BOT
  enemy.type = OBJ_TYPE_BOT

  function enemy:can_shoot()
    local mydir = lm.vecmk(self)
    local enemdir = lm.vecsub(world.camera, self)
    if math.abs(lm.vecscal(mydir, enemdir) / (lm.vecmod(enemdir) * lm.vecmod(mydir)) - 1) < 0.1 then
      return true
    end
    return false
  end

  function enemy:update(domain, dt)
    local waytotarg = lm.vecmod(lm.vecsub(world.camera, self))
    if self.attacking then
      if self:can_shoot() then
        if self.shoot_timer:age(dt) then
          local bull = weapon.shoot()
          bull.x = self.x
          bull.y = self.y
          bull.angle = self.angle
          bull.target_type = OBJ_TYPE_HERO
          bull.damage = 1
          domain:put(bull)
        end
      end
      if self.retreating then
        if not bot.update(self, domain, dt) then
          return false
        end
        if self.moving == false then
          self.retreating = false
        end
      else
        if waytotarg > domain:radius() then
          self.attacking = false
          self.retreating = true
          self.speed = ENEMY_USUAL_SPEED
          self.flexway = ENEMY_USUAL_FLEX
          self.agresway = false
        elseif waytotarg < 150 then
          local ang = self.angle + (math.random() * (math.pi / 4) + math.pi / 6) * lm.rand_sign()
          local subrad = 300
          local nx, ny = subrad * math.cos(ang), subrad * math.sin(ang)
          self.retreating = true
          self:move_to(world.camera.x + nx, world.camera.y + ny)
        else
          self:move_to(world.camera.x, world.camera.y)
        end
        if not bot.update(self, domain, dt) then
          return false
        end
      end
    else
      if waytotarg < domain:radius() / 2 then
          self.attacking = true
          self.speed = ENEMY_ATACK_SPEED
          self.flexway = ENEMY_ATACK_FLEX
          --self.agresway = true
          self:move_to(world.camera.x, world.camera.y)
      else
        if not bot.update(self, domain, dt) then
          return false
        end
        if self.moving == false then
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
    return true
  end
  return enemy
end

function enemy_api.domain_init(par)
  local count  = math.random(5)
  for i = 1, count do
    local en = enemy_api.new(par.domain)
    par.domain:put(en)
  end
end

return enemy_api