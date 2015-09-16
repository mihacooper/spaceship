lm = require "locmath"
object = require "object"

local bot_api = {}

local base_obj = object.new()

function bot_api.new()
  local bot = object.new()
  bot.speed = 0
  bot.max_speed = 0
  bot.max_angsp = 0
  
  bot.dst_pnt = {x = 0, y = 0}
  bot.start_pnt = {x = 0, y = 0}
  bot.mid_pnt = {x = 0, y = 0}
  bot.mid2_pnt = {x = 0, y = 0}
  bot.move_t = 0
  bot.total_time = 0
  bot.flexway = 1
  bot.agresway = false
  bot.moving = false
    
    function bot:move_to(x, y)
      self.dst_pnt.x = x
      self.dst_pnt.y = y
      self.start_pnt.x = self.x
      self.start_pnt.y = self.y
      
      local dst_dir = lm.vecsub(self.dst_pnt, self)
      local way_length = lm.vecmod(dst_dir)
      local mid = lm.vecadd(lm.vecmulc(lm.vecnorm(lm.vecmk(self)), way_length * self.flexway), self)
      local mid2 = lm.vecadd(lm.vecmulc(dst_dir, 0.5), self)
      self.mid_pnt.x = mid.x
      self.mid_pnt.y = mid.y
      self.mid2_pnt.x = mid2.x
      self.mid2_pnt.y = mid2.y
      self.total_time = way_length / (self.speed)
      self.move_t = 0.
      self.moving = true
    end
    function bot:update(domain, dt)
      if not base_obj.update(self, domain, dt) then
        return false
      end
      if self.moving == false then
        return true
      end
      local dst_dir = lm.vecsub(self.dst_pnt, self)
      if lm.vecmod(dst_dir) <= self.speed * dt then
        self.moving = false
        return true
      end
      local step = dt / self.total_time
      local function bezier2(t)
        return math.pow(1 - t , 2) * self.start_pnt.x 
            + 2 * t* (1 - t) * self.mid_pnt.x + t * t * self.dst_pnt.x,
            math.pow(1 - t , 2) * self.start_pnt.y 
            + 2 * t* (1 - t) * self.mid_pnt.y + t * t * self.dst_pnt.y
      end
      local function bezier3(t)
        return math.pow(1 - t , 3) * self.start_pnt.x + 3 * t * math.pow(1 - t, 2) * self.mid_pnt.x 
            + 3 * t * t * (1 - t) * self.mid2_pnt.x + t * t * t * self.dst_pnt.x,
            math.pow(1 - t , 3) * self.start_pnt.y + 3 * t * math.pow(1 - t, 2) * self.mid_pnt.y 
            + 3 * t * t * (1 - t) * self.mid2_pnt.y + t * t * t * self.dst_pnt.y
      end
      
      local besizer = nil
      if self.agresway then
        besizer = bezier2
      else
        besizer = bezier3
      end

      local oldpos = { x = self.x, y = self.y}
      local function estimate_step(cstep)
        local sx, sy = besizer(self.move_t + cstep, self.start_pnt.x, self.mid_pnt.x, self.dst_pnt.x)
        return lm.vecmod(lm.vecsub({x = sx, y = sy}, oldpos)) - self.speed * dt
      end
      local function find_step(lstep, rstep, it)
        local cstep = (lstep + rstep) / 2
        local dif = estimate_step(cstep)
        if it == 0 or math.abs(dif) < self.speed * dt * 0.1 then
          return cstep
        elseif dif > 0 then
          return find_step(lstep, cstep, it - 1)
        else
          return find_step(cstep, rstep, it - 1)
        end
      end
      if estimate_step(step) > 0 then
        local lower = step 
        while estimate_step(lower) >= 0 do
          lower = lower / 2
        end
        step = find_step(lower, step, 20)
      else
        local upper = step 
        while estimate_step(upper) <= 0 do
          upper = upper * 2
        end
        step = find_step(step, upper, 20)
      end
      self.move_t = self.move_t + step
      if self.move_t > 1 then
        self.move_t = 1.
      end
      self.x, self.y = besizer(self.move_t)
      local movedir = lm.vecsub(self, oldpos)
      if lm.vecmod(movedir) > 0 then
        lm.vectoang(self, movedir)
      end
      return true
    end
  return bot
end

return bot_api