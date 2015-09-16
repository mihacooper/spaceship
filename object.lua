lm = require "locmath"

local obj_api = {}

function obj_api.new()
  local obj = {}
  obj.x = 0
  obj.y = 0
  obj.angle = 0
  obj.image = nil
  obj.type = OBJ_TYPE_BOT
  obj.level = 0
  obj.health = 10

    function obj:offsetx(image)
      return image:getWidth() / 2
    end
     
    function obj:offsety(image)
      return image:getHeight() / 2
    end

    function obj:draw()
      if self.image ~= nil then
        local offx = self:offsetx(self.image)
        local offy = self:offsety(self.image)
        love.graphics.draw(self.image, 
          self.x  - world.camera.x + WINDOW_WIDTH / 2,
          self.y  - world.camera.y + WINDOW_HEIGHT / 2,
          self.angle + math.pi / 2, 1, 1, offx, offy)
      end
    end
    function obj:update(domain, dt)
      if self.health <= 0 then
        return false
      end
      return true
    end
  return obj
end

return obj_api